#Requires AutoHotkey v2.0
#SingleInstance Force
#MaxThreadsPerHotkey 2

CoordMode "Mouse", "Screen"
SetMouseDelay -1

; --- VARIABILI GLOBALI E SETTING PREDEFINITI ---
Global X_Min := 0, Y_Min := 0, X_Max := 0, Y_Max := 0
Global Calibrato := false
Global IniFile := A_ScriptDir "\PixelBot_Settings.ini"

; Caricamento impostazioni dal file .ini (se esiste)
Global Grid_Saved := IniRead(IniFile, "Settings", "Grid", "32x32")
Global Colors_Saved := IniRead(IniFile, "Settings", "Colors", "10")
Global Speed_Saved := IniRead(IniFile, "Settings", "Speed", "2") ; Default 2ms
Global HK1 := IniRead(IniFile, "Hotkeys", "Angle1", "F1")
Global HK2 := IniRead(IniFile, "Hotkeys", "Angle2", "F2")
Global HK3 := IniRead(IniFile, "Hotkeys", "Reset", "F3")
Global HK_Start := IniRead(IniFile, "Hotkeys", "Start", "z")

; ==============================================================================
; CREAZIONE INTERFACCIA GRAFICA (GUI)
; ==============================================================================
MainGui := Gui("+AlwaysOnTop", "PixelBot v1.2.0")
MainGui.OnEvent("Close", (*) => ExitApp()) ; Chiusura standard con la X

MainGui.SetFont("s9 bold")
MainGui.Add("Text", "w250", "--- CONFIGURAZIONE DISEGNO ---")
MainGui.SetFont("s9 norm") 

MainGui.Add("Text", "w250 y+10", "Dimensioni (es. 50x30):")
Global GridEdit := MainGui.Add("Edit", "w250", Grid_Saved)

MainGui.Add("Text", "w250 y+10", "Numero di Colori:")
Global ColoriEdit := MainGui.Add("Edit", "w250", Colors_Saved)

MainGui.Add("Text", "w250 y+10", "Velocità (ms di pausa):")
Global SpeedSlider := MainGui.Add("Slider", "w250 Range1-20 ToolTip", Speed_Saved)

MainGui.SetFont("s9 bold")
MainGui.Add("Text", "w250 y+15", "--- TASTI RAPIDI (HOTKEYS) ---")
MainGui.SetFont("s9 norm") 

MainGui.Add("Text", "x10 y+15 w120", "Angolo 1:")
Global HK1_Edit := MainGui.Add("Hotkey", "x140 yp-3 w120", HK1)

MainGui.Add("Text", "x10 y+15 w120", "Angolo 2:")
Global HK2_Edit := MainGui.Add("Hotkey", "x140 yp-3 w120", HK2)

MainGui.Add("Text", "x10 y+15 w120", "Reset:")
Global HK3_Edit := MainGui.Add("Hotkey", "x140 yp-3 w120", HK3)

MainGui.Add("Text", "x10 y+15 w120", "Avvia/Stop:")
Global HKStart_Edit := MainGui.Add("Hotkey", "x140 yp-3 w120", HK_Start)

BtnSave := MainGui.Add("Button", "x10 y+20 w250 h30", "SALVA E APPLICA")
BtnSave.OnEvent("Click", (*) => SaveAndApply())

MainGui.Add("Text", "w250 cGray Center y+10", "Premi F4 per nascondere/mostrare")

MainGui.Show("AutoSize Center")

; ==============================================================================
; LOGICA HOTKEYS DINAMICHE
; ==============================================================================
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
    IniWrite(SpeedSlider.Value, IniFile, "Settings", "Speed")
    IniWrite(HK1, IniFile, "Hotkeys", "Angle1")
    IniWrite(HK2, IniFile, "Hotkeys", "Angle2")
    IniWrite(HK3, IniFile, "Hotkeys", "Reset")
    IniWrite(HK_Start, IniFile, "Hotkeys", "Start")

    ; Attiva le nuove Hotkey
    Hotkey(HK1, (*) => SetPos1())
    Hotkey(HK2, (*) => SetPos2())
    Hotkey(HK3, (*) => ResetCal())
    Hotkey(HK_Start, (*) => StartBot())

    ToolTip "Impostazioni salvate e applicate!"
    Sleep 1500
    ToolTip ""
}

SaveAndApply()

; ==============================================================================
; FUNZIONI CORE (AGGIORNATE CON IL CLICK MOUSE)
; ==============================================================================
SetPos1() {
    Global X_Min, Y_Min
    ToolTip "Fai CLICK SINISTRO sull'angolo in ALTO A SINISTRA del disegno..."
    
    KeyWait "LButton"      ; Aspetta che il tasto sinistro venga rilasciato
    KeyWait "LButton", "D" ; Attende che il tasto sinistro venga premuto
    
    MouseGetPos &X_Min, &Y_Min
    ToolTip "Angolo 1 registrato!"
    Sleep 800
    ToolTip ""
}

SetPos2() {
    Global X_Max, Y_Max, Calibrato
    ToolTip "Fai CLICK SINISTRO sull'angolo in BASSO A DESTRA del disegno..."
    
    KeyWait "LButton"      ; Aspetta il rilascio
    KeyWait "LButton", "D" ; Attende il click
    
    MouseGetPos &X_Max, &Y_Max
    Calibrato := true
    ToolTip "Angolo 2 registrato!"
    Sleep 800
    ToolTip ""
}

ResetCal() {
    Global Calibrato := false
    ToolTip "Reset effettuato!"
    Sleep 800
    ToolTip ""
}

F4:: {
    if WinExist("PixelBot v1.2.0") {
        MainGui.Hide()
    } else {
        MainGui.Show()
    }
}

; ==============================================================================
; MOTORE DEL BOT
; ==============================================================================
Global on := false
StartBot() {
    Global on, X_Min, Y_Min, X_Max, Y_Max, Calibrato
    
    if (!Calibrato) {
        MsgBox "Registra prima i due angoli cliccando sul disegno!"
        return
    }

    if on := !on 
    {
        Parti := StrSplit(StrLower(GridEdit.Value), "x")
        if (Parti.Length != 2) {
            MsgBox "Formato dimensioni errato!"
            on := false
            return
        }
        
        Colonne := Number(Parti[1])
        Righe := Number(Parti[2])
        NumColori := Number(ColoriEdit.Value)
        
        Passo_X := (X_Max - X_Min) / (Colonne - 1)
        Passo_Y := (Y_Max - Y_Min) / (Righe - 1)
        
        Loop NumColori {
            if (!on) {
                break
            }
            
            Colore_Attuale := A_Index
            
            ; --- CICLO 1: ORIZZONTALE ---
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
                    
                    if (Mod(A_Index, 3) == 0) {
                        Sleep SpeedSlider.Value
                    }
                }
                Sleep 20
                Direzione := -Direzione
            }
            Click "Up"
            
            ; --- CICLO 2: RIFINITURA LATI ---
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
                        Sleep SpeedSlider.Value + 1
                    }
                }
            }
            Click "Up"
        }
        
        if (on) {
            on := false
            ToolTip "LAVORO FINITO!"
            Sleep 3000
            ToolTip ""
        }
    } else {
        Click "Up"
        ToolTip "BOT FERMATO"
        Sleep 1000
        ToolTip ""
    }
}