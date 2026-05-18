# PixelBot 🎨🤖

Un bot automatizzato, ultra-veloce e preciso per completare automaticamente i livelli del gioco [Coloring Pixels](https://store.steampowered.com/app/897330/Coloring_Pixels/).

Scritto interamente in **AutoHotkey v2**, PixelBot è dotato di una comoda interfaccia grafica (GUI) e di un algoritmo di colorazione intelligente (a trama incrociata) che garantisce di non mancare nemmeno un pixel, ottimizzando i tempi e le prestazioni.

## ✨ Caratteristiche Principali

* 🎛️ **Pannello di Controllo (GUI)**: Gestisci tutte le impostazioni da un'unica finestra intuitiva.
* 🎯 **Calibrazione Intelligente al Click**: Definisci i limiti del disegno semplicemente cliccando con il mouse sugli angoli dell'immagine. Prenditi tutto il tempo che ti serve!
* 💾 **Salvataggio Automatico (Memoria)**: Le dimensioni, la velocità e le tue scorciatoie da tastiera vengono salvate automaticamente e ricaricate al prossimo avvio.
* ⚡ **Velocità Regolabile in Tempo Reale**: Menu a tendina con preset stile YouTube per adattarti al framerate del tuo PC.
* 🧠 **Algoritmo Cross-Hatching**: Il bot colora la zona centrale a velocità estrema, per poi fare una passata di rifinitura chirurgica sui bordi laterali.

## 🚀 Download e Installazione

Non hai bisogno di saper programmare per usare questo bot!

1. Vai nella sezione **[Releases](../../releases/latest)** qui a destra su GitHub.
2. Scarica il file **`PixelBot_Installer_v1.3.1.exe`**.
3. Avvia l'installazione guidata e scegli se creare un collegamento sul desktop.
4. Avvia PixelBot!

## ⚙️ Come si usa

1. Apri un livello su *Coloring Pixels* e assicurati che l'area sia ben visibile sullo schermo.
2. Inserisci le **Dimensioni del Disegno** (es. `32x32`, `50x50`) e il **Numero di colori** indicati dal gioco.
3. **Calibrazione:**
   * Clicca sul pulsante **Angolo 1** (oppure premi `F1`), poi fai *Click Sinistro* sull'angolo in alto a sinistra del tuo disegno.
   * Clicca sul pulsante **Angolo 2** (oppure premi `F2`), poi fai *Click Sinistro* sull'angolo in basso a destra.
4. Premi **Z** (o il tuo tasto di avvio personalizzato) per far partire la magia! Il bot si spegnerà in automatico dopo aver completato tutti i colori.

## ⌨️ Tasti Rapidi (Personalizzabili)

| Tasto | Funzione |
|-------|----------|
| `F1`  | Registra l'angolo in alto a sinistra |
| `F2`  | Registra l'angolo in basso a destra |
| `F3`  | Resetta la calibrazione degli angoli |
| `Z`   | **Avvia / Ferma** il bot |
| `F4`  | Mostra / Nascondi la finestra del menu |

## ⚠️ Nota su Windows Defender (SmartScreen)

Poiché questo bot è un progetto open-source indipendente e non è firmato con un certificato aziendale a pagamento, al primo avvio Windows Defender potrebbe mostrare una schermata blu "PC protetto da Windows".

Si tratta di un falso positivo comunissimo per i nuovi installer scaricati da GitHub. Per avviare l'installazione in totale sicurezza:

1. Clicca su **Ulteriori informazioni**.
2. Clicca su **Esegui comunque**.

## 🛠️ Per gli Sviluppatori

Vuoi studiare o modificare il codice sorgente?

* Il bot è scritto in **AutoHotkey v2.0**, suddiviso in moduli nella cartella `src/`.
* Compila l'eseguibile con **Ahk2Exe** puntando a `PixelBot.ahk` (entry point nella root).
* Crea il setup di installazione con **Inno Setup 6** usando `installer/PixelBot_Setup.iss`.

### Struttura del progetto

```
PixelBot/
├── PixelBot.ahk          ← entry point (bootstrap + #Include)
├── README.md
├── CHANGELOG.md
├── .gitignore
├── src/
│   ├── Config.ahk        ← variabili globali, lettura INI
│   ├── Calibration.ahk   ← SetPos1, SetPos2, ResetCal
│   ├── Bot.ahk           ← motore algoritmo cross-hatching
│   ├── GUI.ahk           ← interfaccia grafica
│   └── Hotkeys.ahk       ← hotkey dinamiche, SaveAndApply
├── assets/
│   └── PixelBot.ico
└── installer/
    └── PixelBot_Setup.iss
```