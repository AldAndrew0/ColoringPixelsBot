; ==============================================================================
; GUI.AHK — Creazione interfaccia grafica e binding degli eventi sui controlli
; ==============================================================================

MainGui := Gui("+AlwaysOnTop", APP_TITLE)
MainGui.OnEvent("Close", (*) => ExitApp())

; --- Sezione: Configurazione Disegno ---
MainGui.SetFont("s9 bold")
MainGui.Add("Text", "w250", "--- CONFIGURAZIONE DISEGNO ---")
MainGui.SetFont("s9 norm")

MainGui.Add("Text", "w250 y+10", "Dimensioni (es. 50x30):")
Global GridEdit := MainGui.Add("Edit", "w250", Grid_Saved)

MainGui.Add("Text", "w250 y+10", "Numero di Colori:")
Global ColoriEdit := MainGui.Add("Edit", "w250", Colors_Saved)

MainGui.Add("Text", "w250 y+10", "Velocità de esecuzione:")
SpeedArray := ["0.50x (Lento)", "0.75x", "1.0x (Originale)", "1.25x", "1.50x", "2.0x", "3.0x (Max)"]
Global SpeedDropdown := MainGui.Add("DropDownList", "w250", SpeedArray)
SpeedDropdown.Choose(Speed_Saved)

; --- Sezione: Calibrazione e Tasti ---
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

; --- Sezione: Coordinate Calibrate (aggiornate live da Calibration.ahk) ---
MainGui.SetFont("s9 bold")
MainGui.Add("Text", "w250 y+15", "--- COORDINATE CALIBRATE ---")
MainGui.SetFont("s9 norm")

Global LabelPos1 := MainGui.Add("Text", "w250 y+8 cGray", "Angolo 1 (↖):  non registrato")
Global LabelPos2 := MainGui.Add("Text", "w250 y+5 cGray", "Angolo 2 (↘):  non registrato")

; --- Pulsante Salva ---
BtnSave := MainGui.Add("Button", "x10 y+20 w250 h30", "SALVA E APPLICA TASTI")
BtnSave.OnEvent("Click", (*) => SaveAndApply())

; --- Sezione: Stato Esecuzione (aggiornata live da Bot.ahk) ---
MainGui.SetFont("s9 bold")
MainGui.Add("Text", "w250 y+15", "--- STATO ESECUZIONE ---")
MainGui.SetFont("s9 norm")

Global LabelProgress := MainGui.Add("Text", "w250 y+8 cGray", "In attesa...")
Global ProgressBar   := MainGui.Add("Progress", "w250 h14 y+5 Range0-100", 0)

MainGui.Add("Text", "w250 cGray Center y+12", "Premi F4 per nascondere/mostrare")

MainGui.Show("AutoSize Center")
