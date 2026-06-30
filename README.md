# E-Invoicing Compliance Tracker

Sito statico con lo stato della fatturazione elettronica (B2G, B2B, B2C),
e-reporting ed e-archiving in 31 paesi, aggiornato automaticamente ogni
settimana.

## 🚀 Setup iniziale (una tantum)

### 1. Crea il repository su GitHub
1. Vai su [github.com/new](https://github.com/new)
2. Nome repository: `einvoicing-tracker` (o quello che preferisci)
3. Visibilità: **Public** (necessaria per GitHub Pages gratuito)
4. Non aggiungere README/gitignore (li abbiamo già)
5. Clicca "Create repository"

### 2. Carica questi file
Dalla cartella di questo progetto, sul tuo computer:

```bash
cd einvoicing-site
git init
git add .
git commit -m "Initial commit: e-invoicing tracker"
git branch -M main
git remote add origin https://github.com/TUO-USERNAME/einvoicing-tracker.git
git push -u origin main
```

Sostituisci `TUO-USERNAME` con il tuo username GitHub.

> Se non hai `git` installato sul computer, puoi anche caricare i file
> manualmente da browser: apri il repository su GitHub → "Add file" →
> "Upload files" → trascina tutta la cartella `einvoicing-site`.

### 3. Attiva GitHub Pages
1. Nel repository, vai su **Settings → Pages**
2. In "Build and deployment" → Source: seleziona **GitHub Actions**
3. Salva

### 4. Lancia il primo deploy
1. Vai su **Actions** (tab in alto nel repository)
2. Seleziona il workflow **"Weekly e-invoicing data update"**
3. Clicca **"Run workflow"** → **"Run workflow"** (pulsante verde)
4. Attendi 1-2 minuti che finisca (icona verde ✓)

### 5. Trova il tuo URL pubblico
Vai su **Settings → Pages**: in cima alla pagina troverai l'URL del sito,
tipo:

```
https://tuo-username.github.io/einvoicing-tracker/
```

Quello è il link da condividere — è pubblico e accessibile a chiunque.

## 🔄 Come funziona l'aggiornamento automatico

Ogni **lunedì alle 08:00 (ora italiana)**, GitHub esegue automaticamente
`scripts/update_data.py`, che:

1. Visita le 31 pagine paese su theinvoicinghub.com
2. Legge la data "Last update" pubblicata su ciascuna pagina
3. La confronta con quella salvata nel sito
4. Se è cambiata, aggiorna `data/countries.json` e logga il cambiamento
   in `data/changelog.json`
5. Il sito viene ripubblicato automaticamente con i dati aggiornati

**Importante**: lo script rileva *che* una pagina è cambiata (tramite la
data di aggiornamento), ma l'estrazione del nuovo testo dettagliato resta
da rivedere manualmente per garantire accuratezza — i siti normativi
cambiano formato senza preavviso, e un parser troppo rigido rischia di
estrarre dati sbagliati senza che nessuno se ne accorga.

Quando un paese risulta cambiato, lo trovi segnalato in
`data/changelog.json` con la data del cambiamento. Puoi chiedermi (a
Claude) di rivedere quel paese specifico e aggiornare il contenuto
dettagliato in chat.

## 🖱️ Lanciare un aggiornamento manuale

Oltre allo scheduling automatico, puoi sempre forzare un controllo:
**Actions → Weekly e-invoicing data update → Run workflow**

## 📁 Struttura del progetto

```
einvoicing-site/
├── index.html              ← la pagina del sito
├── data/
│   ├── countries.json       ← dati dei 31 paesi
│   ├── meta.json             ← timestamp ultimo controllo
│   └── changelog.json        ← storico dei cambiamenti rilevati
├── scripts/
│   └── update_data.py        ← script di controllo settimanale
└── .github/workflows/
    └── weekly-update.yml      ← automazione GitHub Actions
```

## 🛠️ Modifiche manuali ai dati

Per correggere o aggiornare manualmente il contenuto di un paese, modifica
`data/countries.json` (è testo semplice, un oggetto per paese) e fai commit.
Il sito si aggiorna automaticamente al prossimo push su `main`.
