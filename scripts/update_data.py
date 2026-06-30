#!/usr/bin/env python3
"""
update_data.py
----------------
Controlla le pagine paese su theinvoicinghub.com/country-profiles/,
confronta la data "Last update" con quella già salvata in data/countries.json,
e segnala/aggiorna i paesi che sono cambiati.

Uso:
    python scripts/update_data.py

Note:
    - Questo script rileva i CAMBIAMENTI (tramite la data "Last update" pubblicata
      su ogni pagina paese) ma l'estrazione strutturata dei nuovi contenuti
      richiede revisione: il sito non espone un'API e la formattazione delle
      pagine può variare. Lo script:
        1. Scarica ogni pagina paese
        2. Estrae la data "Last update: <data>"
        3. La confronta con quella salvata in countries.json (campo last_update)
        4. Se diversa, segna il paese come "needs_review" in data/meta.json
           e logga il cambiamento in data/changelog.json
    - Per applicare automaticamente le modifiche di testo (non solo la data),
      integrare qui un parser HTML più approfondito (vedi extract_country_data).
"""

import json
import re
import sys
import time
from datetime import datetime, timezone
from pathlib import Path
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError

ROOT = Path(__file__).resolve().parent.parent
DATA_FILE = ROOT / "data" / "countries.json"
META_FILE = ROOT / "data" / "meta.json"
CHANGELOG_FILE = ROOT / "data" / "changelog.json"

BASE_URL = "https://www.theinvoicinghub.com"
USER_AGENT = "Mozilla/5.0 (compatible; EInvoicingTrackerBot/1.0; +https://github.com/)"

# Mappa nome paese -> slug usato nell'URL della pagina sorgente
COUNTRY_URL_SLUGS = {
    "Italy": "italy",
    "France": "france",
    "Germany": "germany",
    "Spain": "spain",
    "Belgium": "belgium",
    "Netherlands": "the-netherlands",
    "Poland": "poland",
    "Portugal": "portugal",
    "Romania": "romania",
    "Greece": "greece",
    "Australia": "australia",
    "Austria": "austria",
    "Denmark": "denmark",
    "Finland": "finland",
    "Sweden": "sweden",
    "Norway": "norway",
    "Ireland": "ireland",
    "Croatia": "croatia",
    "India": "india",
    "Malaysia": "malaysia",
    "Mexico": "mexico",
    "Saudi Arabia": "saudi-arabia",
    "Colombia": "colombia",
    "Israel": "israel",
    "Singapore": "singapore",
    "New Zealand": "new-zealand",
    "United Arab Emirates": "uae",
    "United Kingdom": "united-kingdom",
    "USA": "usa",
    "Oman": "oman",
    "Philippines": "the-philippines",
}

LAST_UPDATE_RE = re.compile(
    r"Last update:\s*([0-9]{4}),?\s*([A-Za-z]+)\s*([0-9]{1,2})", re.IGNORECASE
)


def fetch(url: str, timeout: int = 20) -> str:
    req = Request(url, headers={"User-Agent": USER_AGENT})
    with urlopen(req, timeout=timeout) as resp:
        return resp.read().decode("utf-8", errors="ignore")


def extract_last_update(html: str) -> str | None:
    """Estrae la stringa 'Last update: YYYY, Month D' dalla pagina."""
    m = LAST_UPDATE_RE.search(html)
    if not m:
        return None
    year, month, day = m.groups()
    return f"{month} {day}, {year}"


def load_json(path: Path, default):
    if path.exists():
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    return default


def save_json(path: Path, data):
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)


def main():
    countries = load_json(DATA_FILE, [])
    if not countries:
        print("ERRORE: data/countries.json non trovato o vuoto.", file=sys.stderr)
        sys.exit(1)

    changelog = load_json(CHANGELOG_FILE, [])

    checked = 0
    changed = []
    errors = []

    for country in countries:
        name = country["name"]
        slug = COUNTRY_URL_SLUGS.get(name)
        if not slug:
            print(f"  [SKIP] Nessun mapping URL per {name}")
            continue

        url = f"{BASE_URL}/einvoicing-compliance-{slug}/"
        print(f"  [CHECK] {name} → {url}")

        try:
            html = fetch(url)
            checked += 1
        except (URLError, HTTPError, TimeoutError) as e:
            print(f"    ERRORE fetch: {e}")
            errors.append({"country": name, "url": url, "error": str(e)})
            time.sleep(1)
            continue

        remote_update = extract_last_update(html)
        local_update = country.get("last_update", "")

        if remote_update and remote_update.strip() not in local_update:
            print(f"    >>> CAMBIATO: locale='{local_update}' remoto='{remote_update}'")
            changed.append({
                "country": name,
                "previous_last_update": local_update,
                "new_last_update": remote_update,
                "url": url,
                "detected_at": datetime.now(timezone.utc).isoformat(),
            })
            # Aggiorna solo il timestamp; il contenuto testuale completo
            # richiede revisione manuale o un parser più approfondito.
            country["last_update"] = remote_update
            country["needs_content_review"] = True
        else:
            country["needs_content_review"] = country.get("needs_content_review", False)

        time.sleep(0.8)  # cortesia verso il server

    # Salva countries.json aggiornato (solo timestamp + flag di revisione)
    save_json(DATA_FILE, countries)

    # Aggiorna changelog
    if changed:
        changelog.extend(changed)
        save_json(CHANGELOG_FILE, changelog)

    # Aggiorna meta.json
    now = datetime.now(timezone.utc)
    meta = {
        "last_run": now.strftime("%d %B %Y").lstrip("0"),
        "last_run_iso": now.isoformat(),
        "countries_checked": checked,
        "countries_changed": len(changed),
        "errors": errors,
        "status": "ok" if not errors else "partial_errors",
    }
    save_json(META_FILE, meta)

    print(f"\n✓ Controllati {checked}/{len(countries)} paesi")
    print(f"✓ Cambiamenti rilevati: {len(changed)}")
    if changed:
        print("  Paesi con nuova data di aggiornamento (richiedono revisione contenuti):")
        for c in changed:
            print(f"   - {c['country']}: {c['previous_last_update']} → {c['new_last_update']}")
    if errors:
        print(f"⚠ Errori di rete: {len(errors)}")
        for e in errors:
            print(f"   - {e['country']}: {e['error']}")


if __name__ == "__main__":
    main()
