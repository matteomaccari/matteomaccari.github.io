# Istruzioni per GitHub Copilot

## Cos'è questo repository

Il sito personale di Matteo Maccari, pubblicato con GitHub Pages da `main` su
https://matteomaccari.github.io/

Sito statico. **Non esiste build, né `package.json`, né test.**

## Struttura

| File | Ruolo |
|---|---|
| `index.html` | home in italiano (`lang="it"`) |
| `en.html` | home in inglese (`lang="en"`) |
| `assets/` | immagini già ottimizzate (`.webp`, favicon, apple-touch-icon) |
| `scripts/` e `.vscode/` | comandi locali dell'autore, non fanno parte del sito |
| `.github/` | workflow e istruzioni, non viene pubblicato |

## Regole da rispettare

1. **Due pagine, un contenuto.** Ogni modifica di contenuto va replicata in
   `index.html` **e** in `en.html`: stessa struttura, testo tradotto. Se una
   modifica vale solo per una lingua, dillo nella pull request.
2. **Niente framework, niente bundler, niente dipendenze esterne.** Un file HTML
   autonomo, CSS inline, nessun CDN. Il sito deve funzionare aprendo il file
   direttamente da disco (`file://`): nessun percorso assoluto, nessun
   `localhost` cablato, niente JS che richiede un server.
3. **Non toccare** `.github/workflows/`, `scripts/`, `.vscode/`. Non aggiungere
   tooling di build. Non cambiare la configurazione di Pages.
4. **Non ridisegnare** il sito se non richiesto: mantieni il linguaggio visivo
   esistente (palette, tipografia, spaziature). Modifiche minime e chirurgiche.
5. **Immagini:** usa quelle presenti in `assets/`, non cancellarle. Se serve una
   nuova immagine, chiedi prima: va in `assets/`, formato `.webp`, sotto i 500 KB.
6. **Accessibilità:** `alt` descrittivo su ogni immagine, HTML semantico,
   contrasto leggibile, nessun testo dentro le immagini.

## Come verificare una modifica

- Apri il file nel browser: la pagina deve renderizzare senza errori.
- Controlla che i link relativi puntino a file che esistono davvero.
- Controlla che `index.html` e `en.html` siano ancora coerenti tra loro.
- Se il contenuto è cambiato, riporta nel corpo della pull request **cosa** è
  cambiato e **su quale pagina**.

## Pull request

- Una modifica = una pull request, con descrizione in linguaggio semplice.
- Non fare merge: la revisione e il merge sono dell'autore.
- Se qualcosa non è chiaro, dichiaralo nella pull request invece di indovinare.
