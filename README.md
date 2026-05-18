# ColoringPixelsBot (PixelBot) 🎨🤖

Un bot automatizzato, ultra-veloce e preciso per completare automaticamente i livelli del gioco [Coloring Pixels](https://store.steampowered.com/app/897330/Coloring_Pixels/). 

Il bot è dotato di un'interfaccia grafica (GUI) e di un doppio ciclo di colorazione intelligente (a trama incrociata) che garantisce di non mancare nemmeno un pixel, ottimizzando i tempi saltando le aree centrali già completate durante la fase di rifinitura.

## 🚀 Download e Installazione

Se vuoi solo usare il bot senza leggere il codice, sei nel posto giusto!
1. Vai nella sezione **[Releases](../../releases/latest)** qui a destra su GitHub.
2. Scarica il file **`PixelBot.exe`**.
3. Fai doppio clic sul file scaricato per avviarlo (non richiede installazione).

## ⚙️ Come si usa

Una volta avviato `PixelBot.exe`, apparirà il pannello di controllo al centro dello schermo.

1. Apri un livello su *Coloring Pixels* e assicurati che sia ben visibile sullo schermo.
2. Inserisci le **Dimensioni del Disegno** (es. `32x32`, `50x50`) e il **Numero totale di colori** del livello nel pannello del bot.
3. Posiziona il mouse sul primo quadratino in alto a sinistra del disegno e premi **F1**.
4. Posiziona il mouse sull'ultimo quadratino in basso a destra del disegno e premi **F2**.
5. Premi **Z** per avviare il bot! 

Il bot farà tutto da solo, passando automaticamente da un colore all'altro, e si spegnerà al termine del disegno.

## ⌨️ Comandi Rapidi (Scorciatoie)

* **`F1`** : Registra l'angolo in alto a sinistra del disegno.
* **`F2`** : Registra l'angolo in basso a destra del disegno.
* **`F3`** : Resetta la calibrazione degli angoli.
* **`F4`** : Mostra / Nascondi il pannello di controllo.
* **`Z`** : **Avvia / Metti in pausa** il bot.
* **`ESC`** : Spegnimento di emergenza immediato.

## 🛠️ Per gli Sviluppatori

Se vuoi modificare il codice o compilarlo da solo:
* Il codice sorgente è scritto in **AutoHotkey v2.0**.
* Scarica il file sorgente `.ahk` da questa repository e aprilo con qualsiasi editor di testo (consigliato VS Code).