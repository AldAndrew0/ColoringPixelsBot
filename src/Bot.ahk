; ==============================================================================
; BOT.AHK — Motore cross-hatching con smart skip delle celle non disegnabili
;
; Ciclo 1: campiona 5 punti per riga → salta righe completamente nere
; Ciclo 2: smart drag per colonne di bordo → salta celle nere con segmenti
; Ciclo 3: smart drag per righe di bordo  → salta celle nere con segmenti
;
; Questo permette di colorare SOLO la zona disegnabile, ottimizzando
; forme irregolari (alambicchi, tavole periodiche, ecc.)
; ==============================================================================

; Ritorna la luminosità RGB sommata (0-765) di un pixel sullo schermo
_PxBright(x, y) {
    px := PixelGetColor(Round(x), Round(y), "RGB")
    return ((px >> 16) & 0xFF) + ((px >> 8) & 0xFF) + (px & 0xFF)
}

StartBot() {
    Global on, X_Min, Y_Min, X_Max, Y_Max, Calibrato, IsWaiting
    if (IsWaiting)
        return

    if (!Calibrato) {
        SoundBeep 200, 300
        ToolTip "❌ ERRORE: Registra prima i due angoli!"
        Sleep 2000
        ToolTip ""
        return
    }

    if on := !on
    {
        ; --- Parse griglia ---
        GridValue := StrReplace(GridEdit.Value, " ", "")
        Parti := StrSplit(StrLower(GridValue), "x")
        if (Parti.Length != 2) {
            SoundBeep 200, 300
            ToolTip "❌ Formato errato! Usa: 32x32 oppure 50x30"
            Sleep 1500
            ToolTip ""
            on := false
            return
        }

        Colonne   := Number(Trim(Parti[1]))
        Righe     := Number(Trim(Parti[2]))
        NumColori := Number(ColoriEdit.Value)
        Passo_X   := (X_Max - X_Min) / (Colonne - 1)
        Passo_Y   := (Y_Max - Y_Min) / (Righe - 1)

        ; --- Mappa velocità → parametri interni ---
        SelectedSpeed := SpeedDropdown.Text
        ModuloVal := 4, SleepVal := 1, BordoVal := 1
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

        ; Soglia luminosità: sopra = cella disegnabile, sotto = sfondo nero
        DrawThresh := 20

        Loop NumColori {
            if (!on)
                break

            Colore_Attuale := A_Index
            ProgressBar.Value := Round((Colore_Attuale - 1) / NumColori * 100)
            LabelProgress.Value := "🎨 Colore " Colore_Attuale " / " NumColori
            ToolTip "COLORANDO: " Colore_Attuale "/" NumColori
            Direzione := 1
            MouseMove X_Min, Y_Min, 0
            Click "Down"

            ; ────────────────────────────────────────────────────────────────
            ; CICLO 1: Riempimento orizzontale a serpentina
            ; Campiona 5 punti per riga: salta se TUTTI neri (riga vuota)
            ; ────────────────────────────────────────────────────────────────
            Loop Righe {
                if (!on)
                    break

                Y_Cur := (A_Index == Righe) ? Y_Max : Y_Min + ((A_Index - 1) * Passo_Y)

                ; 5 campioni distribuiti: SX, 25%, 50%, 75%, DX
                rowEmpty := (_PxBright(X_Min,                             Y_Cur) <= DrawThresh
                          && _PxBright(X_Min + Passo_X*(Colonne-1)*0.25, Y_Cur) <= DrawThresh
                          && _PxBright(X_Min + Passo_X*(Colonne-1)*0.50, Y_Cur) <= DrawThresh
                          && _PxBright(X_Min + Passo_X*(Colonne-1)*0.75, Y_Cur) <= DrawThresh
                          && _PxBright(X_Max,                             Y_Cur) <= DrawThresh)

                if (!rowEmpty) {
                    Loop Colonne {
                        if (!on)
                            break
                        if (Direzione == 1) {
                            X_Cur := (A_Index == Colonne) ? X_Max : X_Min + ((A_Index - 1) * Passo_X)
                        } else {
                            X_Cur := (A_Index == Colonne) ? X_Min : X_Max - ((A_Index - 1) * Passo_X)
                        }
                        MouseMove X_Cur, Y_Cur, 0
                        if (ModuloVal > 0 && Mod(A_Index, ModuloVal) == 0)
                            Sleep SleepVal
                    }
                }

                Sleep 20
                Direzione := -Direzione
            }
            Click "Up"

            if (!on)
                break

            ; ────────────────────────────────────────────────────────────────
            ; CICLO 2: Rifinitura bordi VERTICALI (colonne SX e DX)
            ; Smart drag: gestisce segmenti → salta celle nere sollevando il mouse
            ; ────────────────────────────────────────────────────────────────
            BorderColCount := Min(4, Colonne // 2)
            BordiColArray := []
            Loop BorderColCount
                BordiColArray.Push(A_Index - 1)
            Loop BorderColCount
                BordiColArray.Push(Colonne - A_Index)

            For Col_Bordo in BordiColArray {
                if (!on)
                    break

                X_Cur   := (Col_Bordo == Colonne-1) ? X_Max : X_Min + (Col_Bordo * Passo_X)
                InDrag  := false

                Loop Righe {
                    if (!on) {
                        if (InDrag)
                            Click "Up"
                        break
                    }

                    if (Mod(Col_Bordo, 2) == 0) {
                        Y_Cur := (A_Index == Righe) ? Y_Max : Y_Min + ((A_Index - 1) * Passo_Y)
                    } else {
                        Y_Cur := (A_Index == Righe) ? Y_Min : Y_Max - ((A_Index - 1) * Passo_Y)
                    }

                    isDrawable := (_PxBright(X_Cur, Y_Cur) > DrawThresh)

                    if (isDrawable) {
                        if (!InDrag) {
                            MouseMove Round(X_Cur), Round(Y_Cur), 0
                            Click "Down"
                            InDrag := true
                        } else {
                            MouseMove Round(X_Cur), Round(Y_Cur), 0
                        }
                        if (BordoVal > 0)
                            Sleep BordoVal
                    } else {
                        if (InDrag) {
                            Click "Up"
                            InDrag := false
                        }
                    }
                }
                if (InDrag) {
                    Click "Up"
                    InDrag := false
                }
            }

            if (!on)
                break

            ; ────────────────────────────────────────────────────────────────
            ; CICLO 3: Rifinitura bordi ORIZZONTALI (righe TOP e BOTTOM)
            ; Smart drag: stessa logica del Ciclo 2 applicata alle righe
            ; ────────────────────────────────────────────────────────────────
            BorderRowCount := Min(4, Righe // 2)
            BordiRigheArray := []
            Loop BorderRowCount
                BordiRigheArray.Push(A_Index - 1)
            Loop BorderRowCount
                BordiRigheArray.Push(Righe - A_Index)

            For Riga_Bordo in BordiRigheArray {
                if (!on)
                    break

                Y_Cur  := (Riga_Bordo == Righe-1) ? Y_Max : Y_Min + (Riga_Bordo * Passo_Y)
                InDrag := false

                Loop Colonne {
                    if (!on) {
                        if (InDrag)
                            Click "Up"
                        break
                    }

                    if (Mod(Riga_Bordo, 2) == 0) {
                        X_Cur := (A_Index == Colonne) ? X_Max : X_Min + ((A_Index - 1) * Passo_X)
                    } else {
                        X_Cur := (A_Index == Colonne) ? X_Min : X_Max - ((A_Index - 1) * Passo_X)
                    }

                    isDrawable := (_PxBright(X_Cur, Y_Cur) > DrawThresh)

                    if (isDrawable) {
                        if (!InDrag) {
                            MouseMove Round(X_Cur), Round(Y_Cur), 0
                            Click "Down"
                            InDrag := true
                        } else {
                            MouseMove Round(X_Cur), Round(Y_Cur), 0
                        }
                        if (BordoVal > 0)
                            Sleep BordoVal
                    } else {
                        if (InDrag) {
                            Click "Up"
                            InDrag := false
                        }
                    }
                }
                if (InDrag) {
                    Click "Up"
                    InDrag := false
                }
            }
        }

        if (on) {
            on := false
            ProgressBar.Value := 100
            LabelProgress.Value := "✅ Completato!"
            SoundBeep 1500, 300
            ToolTip "🎉 LAVORO FINITO!"
            Sleep 3000
            ToolTip ""
        }

    } else {
        Click "Up"
        ProgressBar.Value := 0
        LabelProgress.Value := "🛑 Fermato"
        SoundBeep 400, 200
        ToolTip "🛑 BOT FERMATO"
        Sleep 1000
        ToolTip ""
    }
}
