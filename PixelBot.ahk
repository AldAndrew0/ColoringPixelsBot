#Requires AutoHotkey v2.0
#SingleInstance Force
#MaxThreadsPerHotkey 2

CoordMode "Mouse", "Screen"
CoordMode "ToolTip", "Screen"
CoordMode "Pixel", "Screen"   ; necessario per AutoCalibrate (PixelSearch)
SetMouseDelay -1

#Include src/Config.ahk
#Include src/Calibration.ahk
#Include src/Bot.ahk
#Include src/GUI.ahk
#Include src/Hotkeys.ahk

; --- AVVIO ---
; Registra F4 per mostrare/nascondere la GUI
Hotkey("F4", (*) => ToggleGui())

; Registrazione iniziale delle hotkey salvate nell'INI
SaveAndApply()
