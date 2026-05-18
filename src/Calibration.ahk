; ==============================================================================
; CALIBRATION.AHK — Registrazione degli angoli del disegno tramite click
; ==============================================================================

SetPos1() {
    Global X_Min, Y_Min, IsWaiting
    if (IsWaiting)
        return

    IsWaiting := true
    SoundBeep 500, 150
    ToolTip ">> Fai CLICK SINISTRO sull'ANGOLO IN ALTO A SINISTRA <<"
    KeyWait "LButton"
    if !KeyWait("LButton", "D T10") {
        SoundBeep 200, 300
        ToolTip "Tempo scaduto!"
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
    if (IsWaiting)
        return

    IsWaiting := true
    SoundBeep 500, 150
    ToolTip ">> Fai CLICK SINISTRO sull'ANGOLO IN BASSO A DESTRA <<"
    KeyWait "LButton"
    if !KeyWait("LButton", "D T10") {
        SoundBeep 200, 300
        ToolTip "Tempo scaduto!"
        Sleep 1500
        ToolTip ""
        IsWaiting := false
        return
    }
    MouseGetPos &X_Max, &Y_Max
    Calibrato := true
    SoundBeep 1000, 150
    ToolTip "✅ Angolo 2 registrato!"
    Sleep 1000
    ToolTip ""
    IsWaiting := false
}

ResetCal() {
    ; FIX SINTATTICO AHK v2: separare dichiarazione Global dall'assegnazione
    Global Calibrato
    Calibrato := false
    SoundBeep 800, 100
    ToolTip "🔄 Reset effettuato!"
    Sleep 1000
    ToolTip ""
}
