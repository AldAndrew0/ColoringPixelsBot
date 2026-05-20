# Changelog

Tutte le modifiche rilevanti a PixelBot sono documentate in questo file.
Il formato segue [Keep a Changelog](https://keepachangelog.com/it/1.0.0/).

---

## [1.7.0] - 2025

### Added
- **Smart skip celle non disegnabili** (Bot.ahk): il bot colora SOLO le zone
  effettivamente parte del disegno, ignorando lo sfondo nero.
  - Ciclo 1: campiona 5 punti per riga (SX, 25%, 50%, 75%, DX). Se tutti e 5
    sono sotto la soglia di luminosità (brightness ≤ 20), la riga viene saltata.
  - Ciclo 2 e 3: smart drag con gestione segmenti. Quando il mouse incontra
    una cella nera, solleva il tasto, la supera, e riprende il drag sulla
    prima cella disegnabile successiva.
  - Funziona per qualsiasi forma: rettangolare, irregolare, con buchi interni.
- **Nuova UI a 3 tab** (GUI.ahk): interfaccia completamente ridisegnata,
  compatta (280×340px vs precedente ~260×500px).
  - Tab "Bot": griglia, colori, velocità, pulsante avvia/stop, barra avanzamento.
  - Tab "Calibra": registrazione manuale A1/A2, AutoCalibra, reset, suggerimenti.
  - Tab "Tasti": personalizzazione hotkey e salvataggio.

### Fixed
- **AutoCalibra fullscreen** (Calibration.ahk): rilevamento dinamico title bar
  via flag WS_CAPTION invece di offset hardcoded 32px. BottomBarH=120px per
  coprire sia la modalità fullscreen (~116px) che windowed (~92px).

---

## [1.6.0] - 2025

### Added
- **Autocalibrazione automatica** (`AutoCalibrate`, default `F5`): rileva in automatico
  i bordi del canvas senza nessun click manuale. Principio: lo sfondo del gioco è sempre
  nero puro (0,0,0); `PixelSearch` con target `0x808080 ±127` cattura qualsiasi pixel
  non-nero. Scan coarse a step=5px + raffinamento pixel-perfect a step=1px per tutti e 4
  i bordi (top, bottom, left, right). Funziona con canvas rettangolari e forme irregolari.
  Richiede che la finestra `ColoringPixels` sia aperta con un livello caricato.
- Aggiunto `CoordMode "Pixel", "Screen"` all'entry point per PixelSearch.
- Nuovo hotkey `HK_Auto` (default `F5`) salvato su INI e personalizzabile dalla GUI.

---

## [1.5.0] - 2025

### Added
- **Coordinate calibrate visibili in GUI**: nuova sezione "COORDINATE CALIBRATE" che mostra
  in tempo reale X e Y di entrambi gli angoli registrati. Si aggiorna subito dopo ogni click
  di calibrazione e si azzera al Reset.
- **Barra di avanzamento**: nuova sezione "STATO ESECUZIONE" con barra Progress e label testuale
  che mostrano il colore corrente (`🎨 Colore 3 / 10`), il completamento (`✅ Completato!`)
  e lo stop manuale (`🛑 Fermato`). La barra va da 0 a 100% sul totale dei colori.

---

## [1.4.0] - 2025

### Fixed
- **Bug 1 — BordiArray su griglie piccole**: l'array dei bordi era hardcoded a 8 elementi fissi.
  Su griglie con meno di 8 colonne produceva indici duplicati (doppia passata) o negativi.
  Ora `BorderColCount = Min(4, Colonne // 2)` genera l'array dinamicamente, senza mai
  produrre sovrapposizioni indipendentemente dalle dimensioni della griglia.
- **Bug 2 — Nessuna rifinitura top/bottom**: il Ciclo 2 copriva solo i bordi laterali
  (colonne SX e DX). Aggiunto Ciclo 3 che esegue la stessa passata chirurgica sulle
  prime/ultime righe (bordi TOP e BOTTOM), con la stessa logica dinamica del Ciclo 2.
- **Bug 3 — IsWaiting bloccabile**: in caso di eccezione interna o return anticipato
  durante la calibrazione, il flag `IsWaiting` restava `true` bloccando il bot fino
  al riavvio. Risolto avvolgendo il corpo di `SetPos1()` e `SetPos2()` in `try/finally`,
  che garantisce `IsWaiting := false` in qualsiasi percorso di uscita.
- **Bug 4 — Input griglia con spazi**: input come `32 x 32` o `32X32` causavano un
  crash silenzioso. Aggiunto `StrReplace(..., " ", "")` + `Trim()` prima del parsing.

---

## [1.3.2] - 2025

### Changed
- Codice sorgente ristrutturato in moduli separati via `#Include` (src/)
- Aggiunta costante `APP_VERSION` / `APP_TITLE` in Config.ahk

### Fixed
- Sintassi AHK v2: `try { }` inline → `try statement` in Hotkeys.ahk
- Sintassi AHK v2: `Global var := val` → dichiarazione e assegnazione separate in ResetCal()
- Aggiornato `.gitignore`: aggiunto `PixelBot_Settings.ini`
- Corretti path icona e URL placeholder in `installer/PixelBot_Setup.iss`

---

## [1.3.1] - 2025

### Fixed
- Algoritmo: fix arrotondamento decimali → ultima riga su `Y_Max` esatto, ultima colonna su `X_Max` esatto
- Ciclo 2 (rifinitura bordi): rimossi loop ridondanti, una sola passata su prime 4 col SX e ultime 4 DX

### Changed
- Velocità: slider numerico sostituito con menu a tendina stile YouTube (`0.50x` → `3.0x Max`)
- Compatibilità retroattiva per INI generato da v1.2.0 (Speed come intero)

---

## [1.2.0] - Versione Precedente

### Added
- GUI completa con salvataggio automatico su INI
- Calibrazione al click con timeout di sicurezza (10s) e feedback acustico
- Hotkey dinamiche personalizzabili
- Algoritmo cross-hatching (Ciclo 1 serpentina + Ciclo 2 rifinitura bordi laterali)