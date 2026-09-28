/*
 * RB_SWITCH_firmware.ino
 *
 * RB Switch - production firmware for the RevD/RevD2 mechanical-switch PCB.
 *
 * Hardware inputs:
 *   SW1 -> GPIO10 -> Left Arrow
 *   SW2 -> GPIO11 -> Enter
 *   SW3 -> GPIO12 -> Right Arrow
 *
 * The switches are wired from the GPIO to GND. Each input therefore uses
 * INPUT_PULLUP and is considered active when the GPIO reads LOW.
 *
 * The device presents itself as a standard BLE HID keyboard using NimBLE.
 * Each switch produces one press/release event on the activation edge.
 *
 * Deliberately NOT included:
 *   - TTP223 touch sensors
 *   - proximity / I2C sensors
 *   - NeoPixel / RGB LED control
 *   - mono-jack inputs
 *   - unused expansion inputs
 *
 * Board target:
 *   ESP32-S3 module used by the project (select "ESP32S3 Dev Module"
 *   in Arduino IDE unless your board package/project build process specifies
 *   an equivalent ESP32-S3 target).
 *
 * Modifying this file (remapping keys, changing debounce timing, renaming
 * the BLE device, etc.)? See docs/firmware-customization.md for a guided
 * walkthrough and a HID Usage ID reference table before editing the
 * constants below.
 */

#include <Arduino.h>
#include <NimBLEDevice.h>
#include <NimBLEHIDDevice.h>

// -----------------------------------------------------------------------------
// Hardware pin map — derived from the RevD/RevD2 schematic and net table.
// SW1_NET -> U1 pin 14 -> GPIO10
// SW2_NET -> U1 pin 15 -> GPIO11
// SW3_NET -> U1 pin 16 -> GPIO12
// -----------------------------------------------------------------------------

static constexpr uint8_t SW1_PIN = 10;
static constexpr uint8_t SW2_PIN = 11;
static constexpr uint8_t SW3_PIN = 12;

// USB HID Usage IDs:
//   0x4F = Keyboard Right Arrow
//   0x50 = Keyboard Left Arrow
//   0x28 = Keyboard Return (Enter)
static constexpr uint8_t LEFT_ARROW = 0x50;
static constexpr uint8_t ENTER_KEY = 0x28;
static constexpr uint8_t RIGHT_ARROW = 0x4F;

static constexpr uint32_t DEBOUNCE_MS = 35;

// -----------------------------------------------------------------------------
// BLE HID state
// -----------------------------------------------------------------------------

NimBLEHIDDevice* hid = nullptr;
NimBLECharacteristic* inputReport = nullptr;
bool connected = false;

class ServerCallbacks : public NimBLEServerCallbacks {
  void onConnect(NimBLEServer* server, NimBLEConnInfo& connInfo) override {
    (void)server;
    (void)connInfo;
    connected = true;
    Serial.println("BLE connected");
  }

  void onDisconnect(NimBLEServer* server, NimBLEConnInfo& connInfo, int reason) override {
    (void)server;
    (void)connInfo;
    (void)reason;
    connected = false;
    Serial.println("BLE disconnected; restarting advertising");
    NimBLEDevice::startAdvertising();
  }
};

// -----------------------------------------------------------------------------
// Debounce state
// -----------------------------------------------------------------------------

struct SwitchState {
  uint8_t pin;
  uint8_t key;
  bool rawState;
  bool stableState;
  uint32_t lastChangeMs;
};

SwitchState sw1{ SW1_PIN, LEFT_ARROW, HIGH, HIGH, 0 };
SwitchState sw2{ SW2_PIN, ENTER_KEY, HIGH, HIGH, 0 };
SwitchState sw3{ SW3_PIN, RIGHT_ARROW, HIGH, HIGH, 0 };

// -----------------------------------------------------------------------------
// BLE HID keyboard
// -----------------------------------------------------------------------------

void sendKey(uint8_t keycode) {
  if (!connected) {
    Serial.println("Key ignored: BLE not connected");
    return;
  }

  // Report ID 1 + modifier + reserved + six key slots.
  uint8_t pressReport[9] = {
    0x01,  // Report ID
    0x00,  // No modifier
    0x00,  // Reserved
    keycode,
    0x00, 0x00, 0x00, 0x00, 0x00
  };

  uint8_t releaseReport[9] = {
    0x01,  // Report ID
    0x00,  // No modifier
    0x00,  // Reserved
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  };

  inputReport->setValue(pressReport, sizeof(pressReport));
  inputReport->notify();

  delay(20);

  inputReport->setValue(releaseReport, sizeof(releaseReport));
  inputReport->notify();
}

void setupBLE() {
  NimBLEDevice::init("RB Switch");
  NimBLEDevice::setMTU(247);
  NimBLEDevice::setPower(ESP_PWR_LVL_P9);
  NimBLEDevice::setSecurityAuth(true, false, false);

  NimBLEServer* server = NimBLEDevice::createServer();
  server->setCallbacks(new ServerCallbacks());

  hid = new NimBLEHIDDevice(server);
  hid->setManufacturer("RB Switch");
  hid->setPnp(0x01, 0xFFFF, 0x0001, 0x0100);

  inputReport = hid->getInputReport(1);

  // Standard boot-compatible keyboard report:
  //   8 modifier bits
  //   1 reserved byte
  //   6 keycode bytes
  static const uint8_t reportMap[] = {
    0x05, 0x01,  // Usage Page (Generic Desktop)
    0x09, 0x06,  // Usage (Keyboard)
    0xA1, 0x01,  // Collection (Application)
    0x85, 0x01,  //   Report ID (1)

    0x05, 0x07,  //   Usage Page (Keyboard/Keypad)
    0x19, 0xE0,  //   Usage Minimum (Left Control)
    0x29, 0xE7,  //   Usage Maximum (Right GUI)
    0x15, 0x00,  //   Logical Minimum (0)
    0x25, 0x01,  //   Logical Maximum (1)
    0x75, 0x01,  //   Report Size (1)
    0x95, 0x08,  //   Report Count (8)
    0x81, 0x02,  //   Input (Data, Variable, Absolute)

    0x75, 0x08,  //   Report Size (8)
    0x95, 0x01,  //   Report Count (1)
    0x81, 0x01,  //   Input (Constant)

    0x75, 0x08,  //   Report Size (8)
    0x95, 0x06,  //   Report Count (6)
    0x15, 0x00,  //   Logical Minimum (0)
    0x25, 0x73,  //   Logical Maximum (115)
    0x05, 0x07,  //   Usage Page (Keyboard/Keypad)
    0x19, 0x00,  //   Usage Minimum (0)
    0x29, 0x73,  //   Usage Maximum (115)
    0x81, 0x00,  //   Input (Data, Array)

    0xC0  // End Collection
  };

  hid->setReportMap((uint8_t*)reportMap, sizeof(reportMap));
  hid->setBatteryLevel(100);

  NimBLEAdvertising* advertising = NimBLEDevice::getAdvertising();
  NimBLEAdvertisementData advertisementData;
  advertisementData.setFlags(0x06);
  advertisementData.setName("RB Switch");
  advertisementData.addServiceUUID(NimBLEUUID("1812"));  // HID service
  advertising->setAdvertisementData(advertisementData);
  advertising->setMinInterval(32);
  advertising->setMaxInterval(48);
  advertising->start();

  Serial.println("BLE advertising as \"RB Switch\"");
}

// -----------------------------------------------------------------------------
// Switch handling
// -----------------------------------------------------------------------------

void updateSwitch(SwitchState& sw) {
  // Active LOW: HIGH = released, LOW = pressed.
  const bool raw = digitalRead(sw.pin);
  const uint32_t now = millis();

  if (raw != sw.rawState) {
    sw.rawState = raw;
    sw.lastChangeMs = now;
  }

  if ((now - sw.lastChangeMs) >= DEBOUNCE_MS && sw.stableState != sw.rawState) {

    sw.stableState = sw.rawState;

    // Fire only on the transition to pressed.
    if (sw.stableState == LOW) {
      Serial.printf("SW GPIO%u -> HID 0x%02X\n", sw.pin, sw.key);
      sendKey(sw.key);
    }
  }
}

// -----------------------------------------------------------------------------
// Arduino setup / loop
// -----------------------------------------------------------------------------

void setup() {
  Serial.begin(115200);
  delay(250);

  pinMode(SW1_PIN, INPUT_PULLUP);
  pinMode(SW2_PIN, INPUT_PULLUP);
  pinMode(SW3_PIN, INPUT_PULLUP);

  // Initialize debounce states from the actual switch state so a held
  // switch during boot does not generate a phantom transition.
  const uint32_t now = millis();
  sw1.rawState = sw1.stableState = digitalRead(sw1.pin);
  sw2.rawState = sw2.stableState = digitalRead(sw2.pin);
  sw3.rawState = sw3.stableState = digitalRead(sw3.pin);
  sw1.lastChangeMs = now;
  sw2.lastChangeMs = now;
  sw3.lastChangeMs = now;

  Serial.println();
  Serial.println("RB Switch firmware");
  Serial.println("SW1 GPIO10 -> Left Arrow");
  Serial.println("SW2 GPIO11 -> Enter");
  Serial.println("SW3 GPIO12 -> Right Arrow");

  setupBLE();
}

void loop() {
  updateSwitch(sw1);
  updateSwitch(sw2);
  updateSwitch(sw3);
  delay(1);
}
