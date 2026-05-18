; ==============================================================================
; CONFIG.AHK — Costanti, variabili globali e lettura impostazioni da INI
; ==============================================================================

; Versione centralizzata: modificare QUI per aggiornare tutta l'app
Global APP_VERSION := "1.3.1"
Global APP_TITLE   := "PixelBot v" APP_VERSION

; --- Stato runtime ---
Global X_Min     := 0
Global Y_Min     := 0
Global X_Max     := 0
Global Y_Max     := 0
Global Calibrato := false
Global IsWaiting := false
Global on        := false

; --- Percorso INI (stesso livello dell'exe / dello script root) ---
Global IniFile := A_ScriptDir "\PixelBot_Settings.ini"

; --- Lettura impostazioni salvate (con valori di default al primo avvio) ---
Global Grid_Saved   := IniRead(IniFile, "Settings", "Grid",   "32x32")
Global Colors_Saved := IniRead(IniFile, "Settings", "Colors", "10")
Global Speed_Saved  := IniRead(IniFile, "Settings", "Speed",  "1.0x (Originale)")
Global HK1          := IniRead(IniFile, "Hotkeys",  "Angle1", "F1")
Global HK2          := IniRead(IniFile, "Hotkeys",  "Angle2", "F2")
Global HK3          := IniRead(IniFile, "Hotkeys",  "Reset",  "F3")
Global HK_Start     := IniRead(IniFile, "Hotkeys",  "Start",  "z")

; --- Compatibilità con v1.2.0 (Speed era uno slider numerico) ---
if (IsInteger(Speed_Saved)) {
    Speed_Saved := "1.0x (Originale)"
}
