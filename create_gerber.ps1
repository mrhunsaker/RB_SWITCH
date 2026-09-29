$KiCad="C:\Users\ryhunsaker\AppData\Local\Programs\KiCad\10.0\bin\kicad-cli.exe"
$Board = "electrical\mechanical_switch\RB_Switch.kicad_pcb"
$Gerbers = "electrical\mechanical_switch\gerbers"

# Remove old production files
Remove-Item $Gerbers -Recurse -Force -ErrorAction SilentlyContinue

# Create fresh output directory
New-Item -ItemType Directory -Path $Gerbers -Force | Out-Null

# Export Gerbers
& $KiCad pcb export gerbers `
    --output $Gerbers `
    --layers "F.Cu,In1.Cu,In2.Cu,B.Cu,F.Mask,B.Mask,F.SilkS,B.SilkS,Edge.Cuts" `
    $Board

# Export drill files
& $KiCad pcb export drill `
    --output $Gerbers `
    --excellon-separate-th `
    $Board

# Show generated files
Write-Host "`nGenerated production files:`n"
Get-ChildItem $Gerbers -File |
    Select-Object Name, Length

& $KiCad pcb render `
    --output "RB_Switch_3D.png" `
    --width 2400 `
    --height 1600 `
    --side top `
    --quality high `
    --preset follow_pcb_editor `
    $Board
& $KiCad pcb render `
    --output "RB_Switch_TOP.png" `
    --width 2400 `
    --height 1600 `
    --side top `
    --quality high `
    --preset follow_pcb_editor `
    $Board

& $KiCad pcb render `
    --output "RB_Switch_BOTTOM.png" `
    --width 2400 `
    --height 1600 `
    --side bottom `
    --quality high `
    --preset follow_pcb_editor `
    $Board
