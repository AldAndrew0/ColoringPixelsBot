#Requires AutoHotkey v2.0
#MaxThreadsPerHotkey 2

CoordMode "Mouse", "Screen"
SetMouseDelay -1

; Variabili Globali
Global X_Min := 0, Y_Min := 0, X_Max := 0, Y_Max := 0
Global Calibrato := false
Global GuiVisibile := true 

; ==============================================================================
; CREAZIONE DELL'INTERFACCIA GRAFICA (GUI)
; ==============================================================================
MainGui := Gui("+AlwaysOnTop", "Coloring Pixels Bot - Pannello")

MainGui.Add("Text", "w250", "1. Risoluzione Schermo (Informativa):")
ResList := MainGui.Add("DropDownList", "w250 vRis", ["1280x720", "1366x768", "1600x900", "1920x1080", "2560x1440", "3840x2160"])
ResList.Text := A_ScreenWidth "x" A_ScreenHeight 

MainGui.Add("Text", "w250 y+15", "2. Dimensioni del Disegno (es. 50x30):")
Global GridEdit := MainGui.Add("Edit", "w250", "32x32") 

MainGui.Add("Text", "w250 y+15", "3. Numero di Colori nel Disegno:")
Global ColoriEdit := MainGui.Add("Edit", "w250", "10") 

MainGui.Add("Text", "w250 y+15", "4. Calibrazione Area:")
BtnF1 := MainGui.Add("Button", "w250 h30", "Imposta Angolo SUP-SIN (Tasto F1)")
BtnF1.OnEvent("Click", (*) => GuiSetPos(1))

BtnF2 := MainGui.Add("Button", "w250 h30", "Imposta Angolo INF-DES (Tasto F2)")
BtnF2.OnEvent("Click", (*) => GuiSetPos(2))

BtnF3 := MainGui.Add("Button", "w250 h30", "Resetta Calibrazione (Tasto F3)")
BtnF3.OnEvent("Click", (*) => ResetCal())

MainGui.Add("Text", "w250 y+15 cGray", "Tasto F4: Mostra/Nascondi Menu`nTasto Z: Avvia/Ferma il Bot`nTasto ESC: Chiudi tutto")

MainGui.Show("AutoSize Center")

; ==============================================================================
; FUNZIONI COLLEGATE AL MENU E AI TASTI
; ==============================================================================
GuiSetPos(tipo) {
    ToolTip "Sposta il mouse sul punto esatto... 3 secondi!"
    Sleep 1000
    ToolTip "2 secondi..."
    Sleep 1000
    ToolTip "1 secondo..."
    Sleep 1000
    if (tipo == 1) {
        SetPos1()
    } else {
        SetPos2()
    }
}

SetPos1() {
    Global X_Min, Y_Min
    MouseGetPos &X_Min, &Y_Min
    ToolTip "Angolo SUPERIORE SINISTRO registrato!"
    Sleep 800
    ToolTip ""
}

SetPos2() {
    Global X_Max, Y_Max, Calibrato
    MouseGetPos &X_Max, &Y_Max
    Calibrato := true
    ToolTip "Angolo INFERIORE DESTRO registrato! Area pronta."
    Sleep 800
    ToolTip ""
}

ResetCal() {
    Global Calibrato := false
    ToolTip "Calibrazione RESETTATA!"
    Sleep 1000
    ToolTip ""
}

F1::SetPos1()
F2::SetPos2()
F3::ResetCal()

F4:: {
    Global GuiVisibile
    if (GuiVisibile) {
        MainGui.Hide()
        GuiVisibile := false
        ToolTip "Pannello Nascosto (Premi F4 per riaprirlo)"
        Sleep 1000
        ToolTip ""
    } else {
        MainGui.Show() 
        GuiVisibile := true
    }
}

; ==============================================================================
; MOTORE PRINCIPALE DEL BOT (TASTO Z)
; ==============================================================================
z:: {
    Static on := false
    Global X_Min, Y_Min, X_Max, Y_Max, Calibrato
    
    if (!Calibrato) {
        MsgBox "Errore: Area non definita! Usa F1 e F2 prima di avviare."
        return
    }
    
    if on := !on 
    {
        Dimensione := StrLower(GridEdit.Value)
        Parti := StrSplit(Dimensione, "x")
        
        if (Parti.Length != 2) {
            MsgBox "Formato non valido! Usa la 'x' in mezzo (es: 32x32)"
            on := false
            return
        }
        
        Colonne := Number(Parti[1])
        Righe := Number(Parti[2])
        NumColori := Number(ColoriEdit.Value)
        
        if (NumColori <= 0) {
            MsgBox "Inserisci un numero valido di colori (maggiore di 0)!"
            on := false
            return
        }
        
        Larghezza_Totale := X_Max - X_Min
        Altezza_Totale := Y_Max - Y_Min
        Passo_X := Larghezza_Totale / (Colonne - 1)
        Passo_Y := Altezza_Totale / (Righe - 1)
        
        Pixel_Per_Pausa_Ciclo1 := 3  
        Pixel_Per_Pausa_Ciclo2 := 1  
        Pausa_Bordi := 20            
        
        Colonne_Bordi := []
        Loop Colonne {
            C := A_Index - 1 
            if (C < 4 || C >= Colonne - 4) {
                Colonne_Bordi.Push(C)
            }
        }
        
        ; === LOOP PER OGNI COLORE ===
        Loop NumColori {
            if (!on) {
                break
            }
                
            Colore_Corrente := A_Index
                
            ; --- CICLO 1: TUTTO LO SCHERMO ---
            ToolTip "CICLO 1 (Colore " Colore_Corrente "/" NumColori ") - Premi Z per fermare"
            Direzione_X := 1 
            
            MouseMove X_Min, Y_Min, 0
            Sleep 20
            Click "Down" 
            
            Loop Righe {
                if (!on) {
                    break
                }
                    
                Rigo_Attuale := A_Index - 1
                Y_Attuale := Y_Min + (Rigo_Attuale * Passo_Y)
                
                Loop Colonne {
                    if (!on) {
                        break
                    }
                        
                    Colonna_Attuale := (Direzione_X == 1) ? (A_Index - 1) : (Colonne - A_Index)
                    X_Attuale := X_Min + (Colonna_Attuale * Passo_X)
                    
                    MouseMove X_Attuale, Y_Attuale, 0
                    if (Mod(A_Index, Pixel_Per_Pausa_Ciclo1) == 0) {
                        Sleep 1 
                    }
                }
                
                Sleep Pausa_Bordi 
                if (!on) {
                    break
                }
                Direzione_X := -Direzione_X 
            }
            Click "Up" 
            
            if (!on) {
                break
            }
                
            ; --- CICLO 2: SOLO I LATI SU 4 COLONNE ---
            ToolTip "CICLO 2 (Colore " Colore_Corrente "/" NumColori ") - Lati in rifinitura"
            Direzione_Y := 1 
            
            if (Colonne_Bordi.Length > 0) {
                Prima_Col_Sicura := Colonne_Bordi[1]
                MouseMove X_Min + (Prima_Col_Sicura * Passo_X), Y_Min, 0
                Sleep 20
                Click "Down" 
                
                For Indice, Colonna_Attuale in Colonne_Bordi {
                    if (!on) {
                        break
                    }
                        
                    X_Attuale := X_Min + (Colonna_Attuale * Passo_X)
                    
                    Loop Righe {
                        if (!on) {
                            break
                        }
                            
                        Rigo_Attuale := (Direzione_Y == 1) ? (A_Index - 1) : (Righe - A_Index)
                        Y_Attuale := Y_Min + (Rigo_Attuale * Passo_Y)
                        
                        MouseMove X_Attuale, Y_Attuale, 0
                        if (Mod(A_Index, Pixel_Per_Pausa_Ciclo2) == 0) {
                            Sleep 1 
                        }
                    }
                    
                    Sleep Pausa_Bordi 
                    if (!on) {
                        break
                    }
                    Direzione_Y := -Direzione_Y 
                }
                Click "Up"
            } 
        }
        
        ; Se finisce tutti i cicli senza essere bloccato
        if (on) {
            Click "Up" 
            on := false
            ToolTip "DISEGNO COMPLETATO! Tutti i " NumColori " colori sono stati colorati."
            Sleep 4000
            ToolTip ""
        }
    } 
    Else {
        Click "Up" 
        ToolTip "BOT IN PAUSA"
        Sleep 800
        ToolTip ""
    }
}

Esc:: {
    Click "Up" 
    ExitApp
}