; ==============================================================================
; HOTKEYS.AHK — Gestione hotkey dinamiche: registrazione, rimozione, toggle GUI
; ==============================================================================

ToggleGui() {
    if WinExist(APP_TITLE) {
        MainGui.Hide()
    } else {
        MainGui.Show()
    }
}

SaveAndApply() {
    Global HK1, HK2, HK3, HK_Start

    ; Rimozione hotkey precedenti prima di riregistrarle
    ; Nota: sintassi AHK v2 corretta per try su singola istruzione (senza graffe)
    try Hotkey(HK1, "Off")
    try Hotkey(HK2, "Off")
    try Hotkey(HK3, "Off")
    try Hotkey(HK_Start, "Off")

    ; Lettura dei nuovi valori dai controlli GUI
    HK1     := HK1_Edit.Value
    HK2     := HK2_Edit.Value
    HK3     := HK3_Edit.Value
    HK_Start := HKStart_Edit.Value

    ; Persistenza su INI
    IniWrite(GridEdit.Value,      IniFile, "Settings", "Grid")
    IniWrite(ColoriEdit.Value,    IniFile, "Settings", "Colors")
    IniWrite(SpeedDropdown.Text,  IniFile, "Settings", "Speed")
    IniWrite(HK1,                 IniFile, "Hotkeys",  "Angle1")
    IniWrite(HK2,                 IniFile, "Hotkeys",  "Angle2")
    IniWrite(HK3,                 IniFile, "Hotkeys",  "Reset")
    IniWrite(HK_Start,            IniFile, "Hotkeys",  "Start")

    ; Registrazione nuove hotkey
    Hotkey(HK1,     (*) => SetPos1())
    Hotkey(HK2,     (*) => SetPos2())
    Hotkey(HK3,     (*) => ResetCal())
    Hotkey(HK_Start, (*) => StartBot())

    SoundBeep 1500, 150
    ToolTip "Impostazioni salvate e applicate!"
    Sleep 1500
    ToolTip ""
}
