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

; ==============================================================================
; AUTOCALIBRATE — Rileva automaticamente i bordi del canvas via PixelSearch
;
; Principio: lo sfondo del gioco è SEMPRE nero puro (0,0,0).
; PixelSearch con target 0x808080 ±127 cattura qualsiasi pixel non-nero.
; Si esegue una scansione coarse (step=5px) + raffinamento (step=1px) per
; trovare i 4 bordi del canvas (top, bottom, left, right) in modo preciso.
; Funziona con canvas rettangolari E forme irregolari.
; ==============================================================================
AutoCalibrate() {
    Global X_Min, Y_Min, X_Max, Y_Max, Calibrato, IsWaiting
    if (IsWaiting)
        return

    IsWaiting := true
    try {
        ToolTip "🔍 Ricerca canvas in corso..."

        ; --- 1. Trova la finestra del gioco ---
        if !WinExist("ColoringPixels") {
            SoundBeep 200, 300
            ToolTip "❌ Finestra 'ColoringPixels' non trovata!`nApri il gioco e carica un livello prima."
            Sleep 3000
            ToolTip ""
            return
        }
        WinGetPos(&WX, &WY, &WW, &WH, "ColoringPixels")

        ; --- 2. Definisci zona di ricerca (esclude title bar e bottom bar UI) ---
        ; Title bar Windows: ~32px | Bottom bar colori del gioco: ~92px
        SL := WX + 5           ; Search Left   (margine sicurezza)
        SR := WX + WW - 5      ; Search Right
        ST := WY + 32          ; Search Top    (sotto la title bar)
        SB := WY + WH - 92     ; Search Bottom (sopra la barra colori)

        ; Parametri PixelSearch:
        ; Target 0x808080 ±127 → cattura tutto ciò che NON è nero puro (0,0,0)
        SC := 0x808080
        SV := 127
        PS := 5  ; passo scan coarse (pixel)

        ; Helper: search su una singola riga
        _RowHit(y) => PixelSearch(&_x, &_y, SL, y, SR, y, SC, SV)
        ; Helper: search su una singola colonna
        _ColHit(x) => PixelSearch(&_x, &_y, x, ST, x, SB, SC, SV)

        ; --- 3. Trova Y_Min (bordo superiore) ---
        Found_YMin := -1
        y := ST
        while (y <= SB) {
            if _RowHit(y) { Found_YMin := y  ;  break
                break }
            y += PS
        }
        if (Found_YMin == -1) {
            SoundBeep 200, 300
            ToolTip "❌ Canvas non trovato!`nAssicurati che un livello sia aperto e visibile."
            Sleep 3000
            ToolTip ""
            return
        }
        ; Raffinamento pixel-perfect (risale fino a Step-1 righe prima)
        Loop (Min(PS - 1, Found_YMin - ST)) {
            yy := Found_YMin - A_Index
            if _RowHit(yy)
                Found_YMin := yy
        }

        ; --- 4. Trova Y_Max (bordo inferiore) ---
        Found_YMax := -1
        y := SB
        while (y >= ST) {
            if _RowHit(y) { Found_YMax := y
                break }
            y -= PS
        }
        Loop (Min(PS - 1, SB - Found_YMax)) {
            yy := Found_YMax + A_Index
            if _RowHit(yy)
                Found_YMax := yy
        }

        ; --- 5. Trova X_Min (bordo sinistro) ---
        Found_XMin := -1
        x := SL
        while (x <= SR) {
            if _ColHit(x) { Found_XMin := x
                break }
            x += PS
        }
        Loop (Min(PS - 1, Found_XMin - SL)) {
            xx := Found_XMin - A_Index
            if _ColHit(xx)
                Found_XMin := xx
        }

        ; --- 6. Trova X_Max (bordo destro) ---
        Found_XMax := -1
        x := SR
        while (x >= SL) {
            if _ColHit(x) { Found_XMax := x
                break }
            x -= PS
        }
        Loop (Min(PS - 1, SR - Found_XMax)) {
            xx := Found_XMax + A_Index
            if _ColHit(xx)
                Found_XMax := xx
        }

        ; --- 7. Validazione risultato ---
        if (Found_XMin == -1 || Found_XMax == -1 || Found_YMin == -1 || Found_YMax == -1
            || Found_XMin >= Found_XMax || Found_YMin >= Found_YMax) {
            SoundBeep 200, 300
            ToolTip "❌ Autocalibrazione fallita!`nVerifica che il livello sia ben visibile e non zoomato."
            Sleep 3000
            ToolTip ""
            return
        }

        ; --- 8. Applica e aggiorna GUI ---
        X_Min := Found_XMin
        Y_Min := Found_YMin
        X_Max := Found_XMax
        Y_Max := Found_YMax
        Calibrato := true

        LabelPos1.Value := "Angolo 1 (↖):  X=" X_Min "  Y=" Y_Min
        LabelPos2.Value := "Angolo 2 (↘):  X=" X_Max "  Y=" Y_Max

        SoundBeep 1200, 100
        SoundBeep 1600, 200
        ToolTip "✅ AutoCalibrazione OK!`nAngolo 1: X=" X_Min "  Y=" Y_Min "`nAngolo 2: X=" X_Max "  Y=" Y_Max
        Sleep 3000
        ToolTip ""

    } finally {
        IsWaiting := false
    }
}
