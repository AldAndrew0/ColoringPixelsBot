; ==============================================================================
; GUI.AHK — Interfaccia compatta a 3 tab: Bot | Calibra | Tasti
; Layout a 280px di larghezza, ~340px di altezza (vs ~500px precedente)
; ==============================================================================

MainGui := Gui("+AlwaysOnTop", APP_TITLE)
MainGui.OnEvent("Close", (*) => ExitApp())
MainGui.SetFont("s9", "Segoe UI")

; ── Header ───────────────────────────────────────────────────────────────────
MainGui.SetFont("s10 bold")
MainGui.Add("Text", "x0 y8 w280 Center", "🎨 " APP_TITLE)
MainGui.SetFont("s9 norm")

; ── Tab container ─────────────────────────────────────────────────────────────
Tabs := MainGui.Add("Tab3", "x5 y30 w270 h290", ["  🤖 Bot  ", "  📐 Calibra  ", "  ⌨ Tasti  "])

; ══════════════════════════════════════════════════════════════════════════════
; TAB 1 — BOT
; ══════════════════════════════════════════════════════════════════════════════
Tabs.UseTab(1)

MainGui.Add("Text", "x15 y70 w95", "Griglia (NxM):")
Global GridEdit      := MainGui.Add("Edit", "x115 y67 w140", Grid_Saved)

MainGui.Add("Text", "x15 y100 w95", "N. Colori:")
Global ColoriEdit    := MainGui.Add("Edit", "x115 y97 w140", Colors_Saved)

MainGui.Add("Text", "x15 y130 w95", "Velocità:")
SpeedArray := ["0.50x (Lento)", "0.75x", "1.0x (Originale)", "1.25x", "1.50x", "2.0x", "3.0x (Max)"]
Global SpeedDropdown := MainGui.Add("DropDownList", "x115 y127 w140", SpeedArray)
SpeedDropdown.Choose(Speed_Saved)

BtnStartStop := MainGui.Add("Button", "x15 y162 w240 h32", "▶  AVVIA   /   ■  STOP")
BtnStartStop.OnEvent("Click", (*) => StartBot())

Global ProgressBar   := MainGui.Add("Progress", "x15 y204 w240 h12 Range0-100", 0)
Global LabelProgress := MainGui.Add("Text",     "x15 y221 w240 cGray", "In attesa...")

MainGui.Add("Text", "x15 y263 w240 cGray Center", "F4 mostra / nasconde il pannello")

; ══════════════════════════════════════════════════════════════════════════════
; TAB 2 — CALIBRA
; ══════════════════════════════════════════════════════════════════════════════
Tabs.UseTab(2)

MainGui.SetFont("s8 cGray")
MainGui.Add("Text", "x15 y67 w240", "Angolo 1  ↖  (alto-sinistra)")
MainGui.SetFont("s9 norm")
Global LabelPos1 := MainGui.Add("Text", "x15 y82 w240", "non registrato")

BtnPos1 := MainGui.Add("Button", "x15 y102 w116 h28", "📌 Registra A1")
BtnPos1.OnEvent("Click", (*) => SetPos1())
BtnAutoCalib := MainGui.Add("Button", "x139 y102 w116 h28", "🤖 AutoCalibra")
BtnAutoCalib.OnEvent("Click", (*) => AutoCalibrate())

MainGui.SetFont("s8 cGray")
MainGui.Add("Text", "x15 y143 w240", "Angolo 2  ↘  (basso-destra)")
MainGui.SetFont("s9 norm")
Global LabelPos2 := MainGui.Add("Text", "x15 y158 w240", "non registrato")

BtnPos2 := MainGui.Add("Button", "x15 y178 w116 h28", "📌 Registra A2")
BtnPos2.OnEvent("Click", (*) => SetPos2())
BtnReset := MainGui.Add("Button", "x139 y178 w116 h28", "🔄 Reset Cal.")
BtnReset.OnEvent("Click", (*) => ResetCal())

MainGui.SetFont("s8 cGray")
MainGui.Add("Text", "x15 y222 w240", "💡 F5  →  AutoCalibra automatica")
MainGui.Add("Text", "x15 y238 w240", "💡 F1 / F2  →  Registra manualmente")
MainGui.SetFont("s9 norm")

; ══════════════════════════════════════════════════════════════════════════════
; TAB 3 — TASTI
; ══════════════════════════════════════════════════════════════════════════════
Tabs.UseTab(3)

MainGui.SetFont("s8 cGray")
MainGui.Add("Text", "x15 y70  w95", "Angolo 1:")
MainGui.SetFont("s9 norm")
Global HK1_Edit     := MainGui.Add("Hotkey", "x115 y67  w140", HK1)

MainGui.SetFont("s8 cGray")
MainGui.Add("Text", "x15 y102 w95", "Angolo 2:")
MainGui.SetFont("s9 norm")
Global HK2_Edit     := MainGui.Add("Hotkey", "x115 y99  w140", HK2)

MainGui.SetFont("s8 cGray")
MainGui.Add("Text", "x15 y134 w95", "Reset Cal.:")
MainGui.SetFont("s9 norm")
Global HK3_Edit     := MainGui.Add("Hotkey", "x115 y131 w140", HK3)

MainGui.SetFont("s8 cGray")
MainGui.Add("Text", "x15 y166 w95", "AutoCalibra:")
MainGui.SetFont("s9 norm")
Global HKAuto_Edit  := MainGui.Add("Hotkey", "x115 y163 w140", HK_Auto)

MainGui.SetFont("s8 cGray")
MainGui.Add("Text", "x15 y198 w95", "Avvia/Stop:")
MainGui.SetFont("s9 norm")
Global HKStart_Edit := MainGui.Add("Hotkey", "x115 y195 w140", HK_Start)

BtnSave := MainGui.Add("Button", "x15 y232 w240 h30", "💾  SALVA E APPLICA TASTI")
BtnSave.OnEvent("Click", (*) => SaveAndApply())

; ══════════════════════════════════════════════════════════════════════════════
Tabs.UseTab(0)
MainGui.Show("AutoSize Center")
