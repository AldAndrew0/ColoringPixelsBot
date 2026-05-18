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
        ; Bug 4 Fix: rimuovi tutti gli spazi prima di parsare (gestisce "32 x 32", "32X32", ecc.)
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

        Colonne    := Number(Trim(Parti[1]))
        Righe      := Number(Trim(Parti[2]))
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

            ; --- CICLO 2: Rifinitura bordi VERTICALI (colonne SX e DX) ---
            ; Bug 1 Fix: BorderCount dinamico → mai duplicati su griglie piccole (<8 col)
            ;   Es. 4 col: BorderCount=2 → SX=[0,1]  DX=[3,2]  (nessuna sovrapposizione)
            ;   Es. 8 col: BorderCount=4 → SX=[0,1,2,3]  DX=[7,6,5,4]
            Click "Down"
            BorderColCount := Min(4, Colonne // 2)
            BordiColArray := []
            Loop BorderColCount
                BordiColArray.Push(A_Index - 1)         ; SX: 0, 1, 2, 3
            Loop BorderColCount
                BordiColArray.Push(Colonne - A_Index)   ; DX: Colonne-1, Colonne-2, ...

            For Col_Bordo in BordiColArray {
                if (!on)
                    break

                X_Cur := (Col_Bordo == Colonne-1) ? X_Max : X_Min + (Col_Bordo * Passo_X)

                Loop Righe {
                    if (!on)
                        break

                    if (Mod(Col_Bordo, 2) == 0) {
                        Y_Cur := (A_Index == Righe) ? Y_Max : Y_Min + ((A_Index - 1) * Passo_Y)
                    } else {
                        Y_Cur := (A_Index == Righe) ? Y_Min : Y_Max - ((A_Index - 1) * Passo_Y)
                    }

                    MouseMove X_Cur, Y_Cur, 0
                    if (BordoVal > 0)
                        Sleep BordoVal
                }
            }
            Click "Up"

            if (!on)
                break

            ; --- CICLO 3: Rifinitura bordi ORIZZONTALI (righe TOP e BOTTOM) ---
            ; Bug 2 Fix: aggiunta passata chirurgica sulle prime/ultime righe
            ;   stessa logica dinamica del Ciclo 2 ma applicata alle righe
            Click "Down"
            BorderRowCount := Min(4, Righe // 2)
            BordiRigheArray := []
            Loop BorderRowCount
                BordiRigheArray.Push(A_Index - 1)       ; TOP: 0, 1, 2, 3
            Loop BorderRowCount
                BordiRigheArray.Push(Righe - A_Index)   ; BOTTOM: Righe-1, Righe-2, ...

            For Riga_Bordo in BordiRigheArray {
                if (!on)
                    break

                Y_Cur := (Riga_Bordo == Righe-1) ? Y_Max : Y_Min + (Riga_Bordo * Passo_Y)

                Loop Colonne {
                    if (!on)
                        break

                    ; Movimento alternato: righe pari SX→DX, dispari DX→SX
                    if (Mod(Riga_Bordo, 2) == 0) {
                        X_Cur := (A_Index == Colonne) ? X_Max : X_Min + ((A_Index - 1) * Passo_X)
                    } else {
                        X_Cur := (A_Index == Colonne) ? X_Min : X_Max - ((A_Index - 1) * Passo_X)
                    }

                    MouseMove X_Cur, Y_Cur, 0
                    if (BordoVal > 0)
                        Sleep BordoVal
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
