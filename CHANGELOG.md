# Changelog

Tutte le modifiche rilevanti a PixelBot sono documentate in questo file.
Il formato segue [Keep a Changelog](https://keepachangelog.com/it/1.0.0/).

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