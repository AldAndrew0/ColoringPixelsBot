# PixelBot 🎨🤖

Un bot automatizzato, ultra-veloce e preciso per completare automaticamente i livelli del gioco [Coloring Pixels](https://store.steampowered.com/app/897330/Coloring_Pixels/). 

Scritto interamente in **AutoHotkey v2**, PixelBot è dotato di una comoda interfaccia grafica (GUI) e di un algoritmo di colorazione intelligente (a trama incrociata) che garantisce di non mancare nemmeno un pixel, ottimizzando i tempi e le prestazioni.

## ✨ Caratteristiche Principali

* 🎛️ **Pannello di Controllo (GUI)**: Gestisci tutte le impostazioni da un'unica finestra intuitiva.
* 🎯 **Calibrazione Intelligente al Click**: Definisci i limiti del disegno semplicemente cliccando con il mouse sugli angoli dell'immagine. Prenditi tutto il tempo che ti serve!
* 💾 **Salvataggio Automatico (Memoria)**: Le dimensioni, la velocità e le tue scorciatoie da tastiera vengono salvate automaticamente in un file `PixelBot_Settings.ini` e ricaricate al prossimo avvio.
* ⚡ **Velocità Regolabile in Tempo Reale**: Usa lo slider integrato per rallentare o velocizzare il bot in base al framerate del tuo PC.
* 🧠 **Algoritmo Cross-Hatching**: Il bot colora la zona centrale a velocità estrema, per poi rallentare e fare una passata di rifinitura chirurgica sui lati, chiudendo il colore da solo.

## 🚀 Download e Installazione

Non hai bisogno di saper programmare per usare questo bot!
1. Vai nella sezione **[Releases](../../releases/latest)** qui a destra su GitHub.
2. Scarica il file **`PixelBot.exe`**.
3. Avvialo con un doppio clic (non richiede installazione).

## ⚙️ Come si usa

1. Apri un livello su *Coloring Pixels* e assicurati che l'area sia ben visibile sullo schermo.
2. Avvia `PixelBot.exe` (il pannello apparirà al centro dello schermo).
3. Inserisci le **Dimensioni del Disegno** (es. `32x32`, `50x50`) e il **Numero di colori** indicati dal gioco.
4. **Calibrazione:**
   * Clicca sul pulsante per l'**Angolo 1** (oppure premi `F1`), poi fai *Click Sinistro* sull'angolo in alto a sinistra del tuo disegno.
   * Clicca sul pulsante per l'**Angolo 2** (oppure premi `F2`), poi fai *Click Sinistro* sull'angolo in basso a destra.
5. Clicca su **SALVA E APPLICA** sulla GUI se hai cambiato dei tasti.
6. Premi **Z** (o il tuo tasto di avvio personalizzato) per far partire la magia! Il bot si spegnerà in automatico dopo aver completato tutti i colori.

## ⌨️ Tasti Rapidi (Personalizzabili)

I seguenti tasti sono quelli predefiniti, ma puoi cambiarli in qualsiasi momento dall'interfaccia dell'app:

* **`F1`** : Attiva la registrazione dell'angolo in alto a sinistra.
* **`F2`** : Attiva la registrazione dell'angolo in basso a destra.
* **`F3`** : Resetta la memoria della calibrazione degli angoli.
* **`Z`** : **Avvia / Ferma** il bot.

**Tasti fissi del sistema:**
* **`F4`** : Mostra / Nascondi la finestra del menu.
* **`X` (sulla finestra)** : Chiude definitivamente il programma.

## 🛠️ Per gli Sviluppatori

Vuoi studiare o modificare il codice sorgente?
* Il bot è scritto in **AutoHotkey v2.0**.
* Scarica il file `PixelBot.ahk` da questa repository.
* Compila l'eseguibile utilizzando l'utility ufficiale `Ahk2Exe` impostando il *Base File* sulla versione v2.0.