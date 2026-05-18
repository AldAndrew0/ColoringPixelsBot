#Requires AutoHotkey v2.0
#SingleInstance Force
#MaxThreadsPerHotkey 2

CoordMode "Mouse", "Screen"
CoordMode "ToolTip", "Screen"
SetMouseDelay -1

; --- VARIABILI GLOBALI E SETTING PREDEFINITI ---
Global X_Min := 0, Y_Min := 0, X_Max := 0, Y_Max := 0
Global Calibrato := false
Global IsWaiting := false
Global IniFile := A_ScriptDir "\PixelBot_Settings.ini"

Global Grid_Saved := IniRead(IniFile, "Settings", "Grid", "32x32")
Global Colors_Saved := IniRead(IniFile, "Settings", "Colors", "10")
Global Speed_Saved := IniRead(IniFile, "Settings", "Speed", "1.0x (Originale)")
Global HK1 := IniRead(IniFile, "Hotkeys", "Angle1", "F1")
Global HK2 := IniRead(IniFile, "Hotkeys", "Angle2", "F2")
Global HK3 := IniRead(IniFile, "Hotkeys", "Reset", "F3")
Global HK_Start := IniRead(IniFile, "Hotkeys", "Start", "z")

; Se l'utente ha una vecchia versione salvata con il numero dello slider, lo resettiamo
if (IsInteger(Speed_Saved)) {
    Speed_Saved := "1.0x (Originale)"
}

; ==============================================================================
; CREAZIONE INTERFACCIA GRAFICA (GUI)
; ==============================================================================
MainGui := Gui("+AlwaysOnTop", "PixelBot v1.3.0")
MainGui.OnEvent("Close", (*) => ExitApp())

MainGui.SetFont("s9 bold")
MainGui.Add("Text", "w250", "--- CONFIGURAZIONE DISEGNO ---")
MainGui.SetFont("s9 norm") 

MainGui.Add("Text", "w250 y+10", "Dimensioni (es. 50x30):")
Global GridEdit := MainGui.Add("Edit", "w250", Grid_Saved)

MainGui.Add("Text", "w250 y+10", "Numero di Colori:")
Global ColoriEdit := MainGui.Add("Edit", "w250", Colors_Saved)

MainGui.Add("Text", "w250 y+10", "Velocità di esecuzione:")
SpeedArray := ["0.50x (Lento)", "0.75x", "1.0x (Originale)", "1.25x", "1.50x", "2.0x", "3.0x (Max)"]
Global SpeedDropdown := MainGui.Add("DropDownList", "w250", SpeedArray)
SpeedDropdown.Choose(Speed_Saved)

MainGui.SetFont("s9 bold")
MainGui.Add("Text", "w250 y+15", "--- CALIBRAZIONE E TASTI ---")
MainGui.SetFont("s9 norm") 

BtnPos1 := MainGui.Add("Button", "x10 y+10 w120 h25", "📌 Angolo 1")
BtnPos1.OnEvent("Click", (*) => SetPos1())
Global HK1_Edit := MainGui.Add("Hotkey", "x140 yp w110 h25", HK1)

BtnPos2 := MainGui.Add("Button", "x10 y+10 w120 h25", "📌 Angolo 2")
BtnPos2.OnEvent("Click", (*) => SetPos2())
Global HK2_Edit := MainGui.Add("Hotkey", "x140 yp w110 h25", HK2)

BtnReset := MainGui.Add("Button", "x10 y+10 w120 h25", "🔄 Reset")
BtnReset.OnEvent("Click", (*) => ResetCal())
Global HK3_Edit := MainGui.Add("Hotkey", "x140 yp w110 h25", HK3)

MainGui.Add("Text", "x10 y+15 w120", "Avvia/Stop:")
Global HKStart_Edit := MainGui.Add("Hotkey", "x140 yp-3 w110", HK_Start)

BtnSave := MainGui.Add("Button", "x10 y+20 w250 h30", "SALVA E APPLICA TASTI")
BtnSave.OnEvent("Click", (*) => SaveAndApply())

MainGui.Add("Text", "w250 cGray Center y+10", "Premi F4 per nascondere/mostrare")

MainGui.Show("AutoSize Center")

; Registra F4 in modo dinamico per evitare errori
Hotkey("F4", (*) => ToggleGui())

; ==============================================================================
; LOGICA HOTKEYS DINAMICHE
; ==============================================================================
ToggleGui() {
    if WinExist("PixelBot v1.3.0") {
        MainGui.Hide()
    } else {
        MainGui.Show()
    }
}

SaveAndApply() {
    Global HK1, HK2, HK3, HK_Start
    
    try {
        Hotkey(HK1, "Off")
    }
    try {
        Hotkey(HK2, "Off")
    }
    try {
        Hotkey(HK3, "Off")
    }
    try {
        Hotkey(HK_Start, "Off")
    }

    HK1 := HK1_Edit.Value
    HK2 := HK2_Edit.Value
    HK3 := HK3_Edit.Value
    HK_Start := HKStart_Edit.Value

    IniWrite(GridEdit.Value, IniFile, "Settings", "Grid")
    IniWrite(ColoriEdit.Value, IniFile, "Settings", "Colors")
    IniWrite(SpeedDropdown.Text, IniFile, "Settings", "Speed")
    IniWrite(HK1, IniFile, "Hotkeys", "Angle1")
    IniWrite(HK2, IniFile, "Hotkeys", "Angle2")
    IniWrite(HK3, IniFile, "Hotkeys", "Reset")
    IniWrite(HK_Start, IniFile, "Hotkeys", "Start")

    Hotkey(HK1, (*) => SetPos1())
    Hotkey(HK2, (*) => SetPos2())
    Hotkey(HK3, (*) => ResetCal())
    Hotkey(HK_Start, (*) => StartBot())

    SoundBeep 1500, 150
    ToolTip "Impostazioni salvate e applicate!"
    Sleep 1500
    ToolTip ""
}

SaveAndApply()

; ==============================================================================
; FUNZIONI CORE
; ==============================================================================
SetPos1() {
    Global X_Min, Y_Min, IsWaiting
    if (IsWaiting) {
        return
    }
    IsWaiting := true
    
    SoundBeep 500, 150
    ToolTip ">> Fai CLICK SINISTRO sull'ANGOLO IN ALTO A SINISTRA <<"
    
    KeyWait "LButton" 
    
    if !KeyWait("LButton", "D T10") {
        SoundBeep 200, 300
        ToolTip "Tempo scaduto per l'Angolo 1!"
        Sleep 1500
        ToolTip ""
        IsWaiting := false
        return
    }
    
    MouseGetPos &X_Min, &Y_Min
    SoundBeep 1000, 150
    ToolTip "✅ Angolo 1 registrato!"
    Sleep 1000
    ToolTip ""
    IsWaiting := false
}

SetPos2() {
    Global X_Max, Y_Max, Calibrato, IsWaiting
    if (IsWaiting) {
        return
    }
    IsWaiting := true
    
    SoundBeep 500, 150
    ToolTip ">> Fai CLICK SINISTRO sull'ANGOLO IN BASSO A DESTRA <<"
    
    KeyWait "LButton" 
    
    if !KeyWait("LButton", "D T10") {
        SoundBeep 200, 300
        ToolTip "Tempo scaduto per l'Angolo 2!"
        Sleep 1500
        ToolTip ""
        IsWaiting := false
        return
    }
    
    MouseGetPos &X_Max, &Y_Max
    Calibrato := true
    SoundBeep 1000, 150
    ToolTip "✅ Angolo 2 registrato! Pronto a partire."
    Sleep 1000
    ToolTip ""
    IsWaiting := false
}

ResetCal() {
    Global Calibrato := false
    SoundBeep 800, 100
    SoundBeep 600, 150
    ToolTip "🔄 Reset effettuato!"
    Sleep 1000
    ToolTip ""
}

; ==============================================================================
; MOTORE DEL BOT
; ==============================================================================
Global on := false
StartBot() {
    Global on, X_Min, Y_Min, X_Max, Y_Max, Calibrato, IsWaiting
    
    if (IsWaiting) {
        return
    }

    if (!Calibrato) {
        SoundBeep 200, 300
        ToolTip "❌ ERRORE: Registra prima i due angoli!"
        Sleep 2000
        ToolTip ""
        return
    }

    if on := !on 
    {
        Parti := StrSplit(StrLower(GridEdit.Value), "x")
        if (Parti.Length != 2) {
            SoundBeep 200, 300
            ToolTip "❌ Formato dimensioni errato!"
            Sleep 1500
            ToolTip ""
            on := false
            return
        }
        
        Colonne := Number(Parti[1])
        Righe := Number(Parti[2])
        NumColori := Number(ColoriEdit.Value)
        
        Passo_X := (X_Max - X_Min) / (Colonne - 1)
        Passo_Y := (Y_Max - Y_Min) / (Righe - 1)
        
        ; -- IMPOSTAZIONE ALGORITMO DI VELOCITÀ --
        SelectedSpeed := SpeedDropdown.Text
        ModuloVal := 4
        SleepVal := 1
        BordoVal := 1
        
        if (SelectedSpeed == "0.50x (Lento)") {
            ModuloVal := 1, SleepVal := 4, BordoVal := 5
        } else if (SelectedSpeed == "0.75x") {
            ModuloVal := 2, SleepVal := 1, BordoVal := 2
        } else if (SelectedSpeed == "1.0x (Originale)") {
            ModuloVal := 4, SleepVal := 1, BordoVal := 1
        } else if (SelectedSpeed == "1.25x") {
            ModuloVal := 8, SleepVal := 1, BordoVal := 0
        } else if (SelectedSpeed == "1.50x") {
            ModuloVal := 15, SleepVal := 1, BordoVal := 0
        } else if (SelectedSpeed == "2.0x") {
            ModuloVal := 30, SleepVal := 1, BordoVal := 0
        } else if (SelectedSpeed == "3.0x (Max)") {
            ModuloVal := 0, SleepVal := 0, BordoVal := 0
        }

        Loop NumColori {
            if (!on) {
                break
            }
            
            Colore_Attuale := A_Index
            ToolTip "COLORANDO: " Colore_Attuale "/" NumColori
            Direzione := 1
            MouseMove X_Min, Y_Min, 0
            Click "Down"
            
            Loop Righe {
                if (!on) {
                    break
                }
                
                Y_Cur := Y_Min + ((A_Index - 1) * Passo_Y)
                Loop Colonne {
                    if (!on) {
                        break
                    }
                    
                    Col_Idx := (Direzione == 1) ? (A_Index - 1) : (Colonne - A_Index)
                    MouseMove X_Min + (Col_Idx * Passo_X), Y_Cur, 0
                    
                    ; Applica il moltiplicatore di velocità calcolato
                    if (ModuloVal > 0) {
                        if (Mod(A_Index, ModuloVal) == 0) {
                            Sleep SleepVal
                        }
                    }
                }
                Sleep 20
                Direzione := -Direzione
            }
            Click "Up"
            
            if (!on) {
                break
            }
            
            Click "Down"
            Loop 2 { 
                For Col_Bordo in [0, 1, 2, 3, Colonne-4, Colonne-3, Colonne-2, Colonne-1] {
                    if (!on) {
                        break
                    }
                    
                    X_Cur := X_Min + (Col_Bordo * Passo_X)
                    Loop Righe {
                        if (!on) {
                            break
                        }
                        
                        Y_Cur := (Mod(Col_Bordo, 2) == 0) ? (Y_Min + ((A_Index-1)*Passo_Y)) : (Y_Max - ((A_Index-1)*Passo_Y))
                        MouseMove X_Cur, Y_Cur, 0
                        
                        ; Pausa sui bordi in base al moltiplicatore
                        if (BordoVal > 0) {
                            Sleep BordoVal
                        } else if (ModuloVal > 0) {
                            if (Mod(A_Index, ModuloVal) == 0) {
                                Sleep 1
                            }
                        }
                    }
                }
            }
            Click "Up"
        }
        
        if (on) {
            on := false
            SoundBeep 1500, 300
            ToolTip "🎉 LAVORO FINITO!"
            Sleep 3000
            ToolTip ""
        }
    } else {
        Click "Up"
        SoundBeep 400, 200
        ToolTip "🛑 BOT FERMATO"
        Sleep 1000
        ToolTip ""
    }
}