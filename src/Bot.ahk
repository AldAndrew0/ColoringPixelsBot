; ==============================================================================
; BOT.AHK — Motore principale: algoritmo di colorazione cross-hatching
; ==============================================================================

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
        Parti := StrSplit(StrLower(GridEdit.Value), "x")
        if (Parti.Length != 2) {
            SoundBeep 200, 300
            ToolTip "❌ Formato dimensioni errato!"
            Sleep 1500
            ToolTip ""
            on := false
            return
        }

        Colonne    := Number(Parti[1])
        Righe      := Number(Parti[2])
        NumColori  := Number(ColoriEdit.Value)
        Passo_X    := (X_Max - X_Min) / (Colonne - 1)
        Passo_Y    := (Y_Max - Y_Min) / (Righe - 1)

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

        Loop NumColori {
            if (!on)
                break

            Colore_Attuale := A_Index
            ToolTip "COLORANDO: " Colore_Attuale "/" NumColori
            Direzione := 1
            MouseMove X_Min, Y_Min, 0
            Click "Down"

            ; --- CICLO 1: Riempimento orizzontale a serpentina ---
            Loop Righe {
                if (!on)
                    break

                ; Fix arrotondamento: ultima riga forzata su Y_Max esatto
                Y_Cur := (A_Index == Righe) ? Y_Max : Y_Min + ((A_Index - 1) * Passo_Y)

                Loop Colonne {
                    if (!on)
                        break

                    ; Fix fine riga: ultima colonna forzata su X esatto
                    if (Direzione == 1) {
                        X_Cur := (A_Index == Colonne) ? X_Max : X_Min + ((A_Index - 1) * Passo_X)
                    } else {
                        X_Cur := (A_Index == Colonne) ? X_Min : X_Max - ((A_Index - 1) * Passo_X)
                    }

                    MouseMove X_Cur, Y_Cur, 0
                    if (ModuloVal > 0 && Mod(A_Index, ModuloVal) == 0) {
                        Sleep SleepVal
                    }
                }
                Sleep 20
                Direzione := -Direzione
            }
            Click "Up"

            if (!on)
                break

            ; --- CICLO 2: Rifinitura bordi laterali (prime 4 col SX + ultime 4 col DX) ---
            Click "Down"
            BordiArray := [0, 1, 2, 3, Colonne-4, Colonne-3, Colonne-2, Colonne-1]

            For Col_Bordo in BordiArray {
                if (!on)
                    break

                ; Sicurezza: salta indici fuori range (griglie molto piccole)
                if (Col_Bordo < 0 || Col_Bordo >= Colonne)
                    continue

                ; Forza la colonna esatta per evitare buchi intermedi
                X_Cur := (Col_Bordo == Colonne-1) ? X_Max : X_Min + (Col_Bordo * Passo_X)

                Loop Righe {
                    if (!on)
                        break

                    ; Movimento alternato: colonne pari Sopra→Sotto, dispari Sotto→Sopra
                    if (Mod(Col_Bordo, 2) == 0) {
                        Y_Cur := (A_Index == Righe) ? Y_Max : Y_Min + ((A_Index - 1) * Passo_Y)
                    } else {
                        Y_Cur := (A_Index == Righe) ? Y_Min : Y_Max - ((A_Index - 1) * Passo_Y)
                    }

                    MouseMove X_Cur, Y_Cur, 0
                    if (BordoVal > 0) {
                        Sleep BordoVal
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
