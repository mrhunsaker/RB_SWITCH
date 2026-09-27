// =====================================================================
// BLE ADAPTIVE SWITCH NODE — EXPANDED SCAFFOLD  (v3, I2C removed)
// Board : ESP32-S3 SuperMini  (ESP32S3FH4R2 — in-package flash+PSRAM)
// Target: NimBLE HID keyboard over BLE → iPadOS Switch Control
//
// Pin layout — verified against board's actual header positions:
//
//   LEFT HEADER  (top→bottom)
//     GPIO  1, 2, 4, 5, 6, 7 → TTP223 capacitive touch (6 sensors)
//       ⚠  GPIO 3 is a strapping pin. TTP223 rests LOW when untouched,
//          which is the safe boot-time state. Do NOT touch the pad
//          connected to GPIO 3 while powering on or pressing RESET.
//
//   RIGHT HEADER (top→bottom from 3V3 pin)
//     GPIO 8, 9, 10, 11, 12 → mono-jack mechanical switches (5 switches)
//       ✓  ESP32S3FH4R2 has in-package flash; this GPIO range is NOT
//          wired to any external chip, so these pads are free GPIO.
//     GPIO 13 → unused / free, available for future expansion
//
//   GPIO 48 → NeoPixel RGB LED (onboard, shared with red power LED)
//
// I2C / proximity-sensor support has been fully removed from this
// scaffold. GPIO 8 (former SDA) and GPIO 9 (former SCL) are now plain
// switch inputs, alongside GPIO 10, 11, and 12.
//
// 11 unique HID keycodes: F1–F6 (touch) and F9–F13 (switch), no
// modifier byte needed.
// All inputs fire on activation EDGE only (debounced, 35 ms).
// LED fades to off 250 ms after last event.
// =====================================================================

#include <NimBLEDevice.h>
#include <NimBLEHIDDevice.h>
#include <HIDKeyboardTypes.h>
#include <Adafruit_NeoPixel.h>

#include "types_expanded.h"

// =====================================================================
// HARDWARE — PIN MAP
// =====================================================================

// ── TTP223 capacitive touch (INPUT, active HIGH, no pull needed) ──────
static const uint8_t TOUCH_PINS[] = { 1, 2, 4, 5, 6, 7 };  // GPIO 3 skipped (strapping pin)
static constexpr uint8_t NUM_TOUCH = 6;

// ── Mono-jack switches (INPUT_PULLUP, active LOW) ─────────────────────
static const uint8_t SWITCH_PINS[] = { 8, 9, 10, 11, 12 };
static constexpr uint8_t NUM_SWITCH = 5;

// ── NeoPixel ─────────────────────────────────────────────────────────
#define LED_PIN    48
#define NUM_PIXELS 1

// =====================================================================
// HID KEYCODE LOOKUP TABLES  (F1–F6, F9–F13, all unique, no modifier needed)
// =====================================================================
//  id  GPIO  Source   Keycode  Key   LED Color
//   0     1  TOUCH    0x3A     F1    GREEN
//   1     2  TOUCH    0x3B     F2    GREEN
//   2     4  TOUCH    0x3C     F3    GREEN
//   3     5  TOUCH    0x3D     F4    GREEN
//   4     6  TOUCH    0x3E     F5    GREEN
//   5     7  TOUCH    0x3F     F6    GREEN
//   0     8  SWITCH   0x42     F9    BLUE
//   1     9  SWITCH   0x43     F10   BLUE
//   2    10  SWITCH   0x44     F11   BLUE
//   3    11  SWITCH   0x45     F12   BLUE
//   4    12  SWITCH   0x68     F13   BLUE
//
// LED color indicates INPUT TYPE, not individual sensor:
//   GREEN = any touch sensor (F1-F6)   BLUE = any switch input (F9-F13)
//   OFF   = idle

static const uint8_t TOUCH_KEYS[]    = { 0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x3F };
static const uint8_t SWITCH_KEYS[]   = { 0x42, 0x43, 0x44, 0x45, 0x68 };
static const Color   TOUCH_COLORS[]  = { GREEN, GREEN, GREEN, GREEN, GREEN, GREEN };
static const Color   SWITCH_COLORS[] = { BLUE, BLUE, BLUE, BLUE, BLUE };

// =====================================================================
// GLOBALS
// =====================================================================
Adafruit_NeoPixel pixel(NUM_PIXELS, LED_PIN, NEO_GRB + NEO_KHZ800);

Color   ledCurrent = {0, 0, 0};
Color   ledTarget  = {0, 0, 0};
UIState ui;

const uint32_t DEBOUNCE_MS = 35;

DebouncedBtn t[NUM_TOUCH];
DebouncedBtn s[NUM_SWITCH];

NimBLEHIDDevice*      hid;
NimBLECharacteristic* input;
bool connected = false;

// =====================================================================
// BLE SERVER CALLBACKS
// =====================================================================
class ServerCallbacks : public NimBLEServerCallbacks {
  void onConnect(NimBLEServer* pServer, NimBLEConnInfo& connInfo) override {
    connected = true;
    Serial.println("=== CONNECTED ===");
  }
  void onDisconnect(NimBLEServer* pServer, NimBLEConnInfo& connInfo, int reason) override {
    connected = false;
    Serial.println("=== DISCONNECTED, restarting advertising ===");
    NimBLEDevice::startAdvertising();
  }
};

// =====================================================================
// LED FADE ENGINE
// =====================================================================
void fadeStep() {
  auto step = [](uint8_t &c, uint8_t tgt) {
    if (c < tgt) c++;
    else if (c > tgt) c--;
  };
  step(ledCurrent.r, ledTarget.r);
  step(ledCurrent.g, ledTarget.g);
  step(ledCurrent.b, ledTarget.b);
  pixel.setPixelColor(0, pixel.Color(ledCurrent.r, ledCurrent.g, ledCurrent.b));
  pixel.show();
}

// =====================================================================
// DEBOUNCE — returns true on stable-state change only
// =====================================================================
bool updateBtn(DebouncedBtn &b, bool raw) {
  uint32_t now = millis();
  if (raw != b.last) { b.last = raw; b.t = now; }
  if ((now - b.t) > DEBOUNCE_MS && b.stable != raw) {
    b.stable = raw;
    return true;
  }
  return false;
}

// =====================================================================
// HID KEY SEND  (press + release)
// =====================================================================
void sendKey(uint8_t modifier, uint8_t keycode) {
  if (!connected) { Serial.println("  (not connected, skipping)"); return; }

  uint8_t press[9]   = { 0x01, modifier, 0x00, keycode, 0x00, 0x00, 0x00, 0x00, 0x00 };
  uint8_t release[9] = { 0x01, 0x00,     0x00, 0x00,    0x00, 0x00, 0x00, 0x00, 0x00 };

  input->setValue(press, sizeof(press));
  input->notify();
  delay(30);
  input->setValue(release, sizeof(release));
  input->notify();
  delay(20);
}

// =====================================================================
// EVENT HANDLERS
// =====================================================================
void handleTouch(uint8_t id) {
  ui.lastEvent   = millis();
  ui.targetColor = TOUCH_COLORS[id];
  Serial.printf("TOUCH  %d  GPIO%-2d -> F%d (0x%02X)\n",
                id, TOUCH_PINS[id], id + 1, TOUCH_KEYS[id]);
  sendKey(0x00, TOUCH_KEYS[id]);
}

void handleSwitch(uint8_t id) {
  ui.lastEvent   = millis();
  ui.targetColor = SWITCH_COLORS[id];
  Serial.printf("SWITCH %d  GPIO%-2d -> F%d (0x%02X)\n",
                id, SWITCH_PINS[id], id + 9, SWITCH_KEYS[id]);
  sendKey(0x00, SWITCH_KEYS[id]);
}

// =====================================================================
// BLE SETUP
// =====================================================================
void setupBLE() {
  Serial.println("=== BLE INIT START ===");

  NimBLEDevice::init("BT Switch");
  NimBLEDevice::setMTU(247);
  NimBLEDevice::setPower(ESP_PWR_LVL_P9);
  NimBLEDevice::setSecurityAuth(true, false, false);

  NimBLEServer* server = NimBLEDevice::createServer();
  server->setCallbacks(new ServerCallbacks());

  hid = new NimBLEHIDDevice(server);
  hid->setManufacturer("ESP32 Switch");
  hid->setPnp(0x01, 0xFFFF, 0x0001, 0x0100);

  input = hid->getInputReport(1);

  static const uint8_t reportMap[] = {
    0x05, 0x01,        // Usage Page (Generic Desktop)
    0x09, 0x06,        // Usage (Keyboard)
    0xA1, 0x01,        // Collection (Application)
    0x85, 0x01,        //   Report ID (1)
    // Modifier keys (8 bits)
    0x05, 0x07,        //   Usage Page (Key Codes)
    0x19, 0xE0,        //   Usage Minimum (Left Ctrl)
    0x29, 0xE7,        //   Usage Maximum (Right GUI)
    0x15, 0x00,        //   Logical Minimum (0)
    0x25, 0x01,        //   Logical Maximum (1)
    0x75, 0x01,        //   Report Size (1 bit)
    0x95, 0x08,        //   Report Count (8)
    0x81, 0x02,        //   Input (Data, Variable, Absolute)
    // Reserved byte
    0x95, 0x01,        //   Report Count (1)
    0x75, 0x08,        //   Report Size (8 bits)
    0x81, 0x03,        //   Input (Constant)
    // Key array (6 key slots)
    0x95, 0x06,        //   Report Count (6)
    0x75, 0x08,        //   Report Size (8 bits)
    0x15, 0x00,        //   Logical Minimum (0)
    0x25, 0x73,        //   Logical Maximum (115) -- covers F13 (0x68)
    0x05, 0x07,        //   Usage Page (Key Codes)
    0x19, 0x00,        //   Usage Minimum (0)
    0x29, 0x73,        //   Usage Maximum (115) -- covers F13 (0x68)
    0x81, 0x00,        //   Input (Data, Array)
    // LED output (5 LEDs + 3 padding bits)
    0x95, 0x05,        //   Report Count (5)
    0x75, 0x01,        //   Report Size (1)
    0x05, 0x08,        //   Usage Page (LEDs)
    0x19, 0x01,        //   Usage Minimum (Num Lock)
    0x29, 0x05,        //   Usage Maximum (Kana)
    0x91, 0x02,        //   Output (Data, Variable, Absolute)
    0x95, 0x01,        //   Report Count (1)
    0x75, 0x03,        //   Report Size (3)
    0x91, 0x03,        //   Output (Constant)
    0xC0               // End Collection
  };

  hid->setReportMap((uint8_t*)reportMap, sizeof(reportMap));
  hid->setBatteryLevel(100);

  // --- Battery Service (Required for Android/Nokia) ---
  NimBLEService* battSvc = server->createService(BLEUUID((uint16_t)0x180F));
  NimBLECharacteristic* battChr = battSvc->createCharacteristic(
      BLEUUID((uint16_t)0x2A19),
      NIMBLE_PROPERTY::READ | NIMBLE_PROPERTY::NOTIFY
  );
  uint8_t battLevel = 100;
  battChr->setValue(&battLevel, 1);

  // --- Advertising ---
  NimBLEAdvertising* adv = NimBLEDevice::getAdvertising();
  NimBLEAdvertisementData advData;
  advData.setFlags(0x06);  // General Discovery + LE-only
  advData.setName("BT Switch");
  advData.addServiceUUID(NimBLEUUID("1812"));  // Standard HID UUID
  advData.addServiceUUID(hid->getHidService()->getUUID());
  advData.addServiceUUID(battSvc->getUUID());
  adv->setAdvertisementData(advData);
  adv->setMinInterval(32);  // 20ms (0x20 * 0.625ms)
  adv->setMaxInterval(48);  // 30ms (0x30 * 0.625ms)
  adv->start();

  Serial.println("=== BLE READY, ADVERTISING ===");
}


// =====================================================================
// SETUP
// =====================================================================
void setup() {
  Serial.begin(115200);
  delay(2000);
  Serial.println("=== SETUP START ===");

  // ── Touch sensors (TTP223 drives output directly, no pull needed) ──
  for (int i = 0; i < NUM_TOUCH; i++) {
    pinMode(TOUCH_PINS[i], INPUT);
    Serial.printf("  Touch  GPIO%2d -> INPUT\n", TOUCH_PINS[i]);
  }

  // ── Mechanical switches (INPUT_PULLUP; switch shorts pin to GND) ───
  for (int i = 0; i < NUM_SWITCH; i++) {
    pinMode(SWITCH_PINS[i], INPUT_PULLUP);
    Serial.printf("  Switch GPIO%2d -> INPUT_PULLUP\n", SWITCH_PINS[i]);
  }

  // ── NeoPixel ──────────────────────────────────────────────────────
  pixel.begin();
  pixel.setBrightness(80);
  pixel.clear();
  pixel.show();
  Serial.println("=== NEOPIXEL OK ===");

  ui.targetColor = COLOR_OFF;
  setupBLE();
  Serial.println("=== SETUP COMPLETE ===");
}

// =====================================================================
// MAIN LOOP
// =====================================================================
void loop() {
  // ── Touch sensors (active HIGH, read directly) ────────────────────
  for (int i = 0; i < NUM_TOUCH; i++) {
    bool raw = (bool)digitalRead(TOUCH_PINS[i]);
    if (updateBtn(t[i], raw) && t[i].stable) {
      handleTouch(i);
    }
  }

  // ── Mechanical switches (active LOW — invert the digital read) ────
  for (int i = 0; i < NUM_SWITCH; i++) {
    bool raw = !digitalRead(SWITCH_PINS[i]);
    if (updateBtn(s[i], raw) && s[i].stable) {
      handleSwitch(i);
    }
  }

  // ── LED timeout — fade to off 250 ms after last event ─────────────
  if (millis() - ui.lastEvent > 250) {
    ui.targetColor = COLOR_OFF;
  }
  ledTarget = ui.targetColor;
  fadeStep();
  delay(3);
}
