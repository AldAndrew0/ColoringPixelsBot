# Changelog

Tutte le modifiche rilevanti a PixelBot sono documentate in questo file.
Il formato segue [Keep a Changelog](https://keepachangelog.com/it/1.0.0/).

---

## [1.3.1] - 2025 (Versione Stabile Attuale)

### Fixed
- Algoritmo: fix arrotondamento decimali → ultima riga forzata su `Y_Max` esatto, ultima colonna su `X_Max` esatto (zero pixel mancati sui bordi)
- Ciclo 2 (rifinitura bordi): rimossi i loop ridondanti, eseguita una sola passata sulle prime 4 colonne SX e ultime 4 DX

### Changed
- Velocità: slider numerico sostituito con menu a tendina stile YouTube (`0.50x` → `3.0x Max`)
- Aggiunta compatibilità retroattiva per utenti con INI generato da v1.2.0 (Speed come intero)

---

## [1.2.0] - Versione Precedente

### Added
- GUI completa con salvataggio automatico su INI
- Calibrazione al click con timeout di sicurezza (10s) e feedback acustico
- Hotkey dinamiche personalizzabili
- Algoritmo cross-hatching (Ciclo 1 serpentina + Ciclo 2 rifinitura bordi)
- Slider velocità (poi sostituito in v1.3.1)