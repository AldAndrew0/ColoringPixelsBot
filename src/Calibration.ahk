; ==============================================================================
; CALIBRATION.AHK — Registrazione degli angoli del disegno tramite click
; ==============================================================================

SetPos1() {
    Global X_Min, Y_Min, IsWaiting
    if (IsWaiting)
        return

    IsWaiting := true
    ; Bug 3 Fix: try/finally garantisce IsWaiting := false in ogni caso
    ; (timeout, eccezione interna, return anticipato)
    try {
        SoundBeep 500, 150
        ToolTip ">> Fai CLICK SINISTRO sull'ANGOLO IN ALTO A SINISTRA <<"
        KeyWait "LButton"
        if !KeyWait("LButton", "D T10") {
            SoundBeep 200, 300
            ToolTip "Tempo scaduto!"
            Sleep 1500
            ToolTip ""
            return
        }
        MouseGetPos &X_Min, &Y_Min
        LabelPos1.Value := "Angolo 1 (↖):  X=" X_Min "  Y=" Y_Min
        SoundBeep 1000, 150
        ToolTip "✅ Angolo 1 registrato!"
        Sleep 1000
        ToolTip ""
    } finally {
        IsWaiting := false
    }
}

SetPos2() {
    Global X_Max, Y_Max, Calibrato, IsWaiting
    if (IsWaiting)
        return

    IsWaiting := true
    ; Bug 3 Fix: try/finally garantisce IsWaiting := false in ogni caso
    try {
        SoundBeep 500, 150
        ToolTip ">> Fai CLICK SINISTRO sull'ANGOLO IN BASSO A DESTRA <<"
        KeyWait "LButton"
        if !KeyWait("LButton", "D T10") {
            SoundBeep 200, 300
            ToolTip "Tempo scaduto!"
            Sleep 1500
            ToolTip ""
            return
        }
        MouseGetPos &X_Max, &Y_Max
        Calibrato := true
        LabelPos2.Value := "Angolo 2 (↘):  X=" X_Max "  Y=" Y_Max
        SoundBeep 1000, 150
        ToolTip "✅ Angolo 2 registrato!"
        Sleep 1000
        ToolTip ""
    } finally {
        IsWaiting := false
    }
}

ResetCal() {
    Global Calibrato
    Calibrato := false
    LabelPos1.Value := "Angolo 1 (↖):  non registrato"
    LabelPos2.Value := "Angolo 2 (↘):  non registrato"
    SoundBeep 800, 100
    ToolTip "🔄 Reset effettuato!"
    Sleep 1000
    ToolTip ""
}
