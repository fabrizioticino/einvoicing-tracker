#!/usr/bin/env python3
"""
update_data.py
----------------
Ad ogni esecuzione (ogni lunedì):
  1. Scarica la pagina indice di theinvoicinghub.com per rilevare nuovi paesi
  2. Aggiunge automaticamente i nuovi paesi a countries.json (con nome italiano)
  3. Verifica la data "Last update" di ogni paese esistente e segnala le modifiche

Uso:
    python scripts/update_data.py
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
INDEX_URL = f"{BASE_URL}/einvoicing-compliance/"
USER_AGENT = "Mozilla/5.0 (compatible; EInvoicingTrackerBot/1.0; +https://github.com/)"

# Mappa slug URL -> nome inglese canonico
SLUG_TO_NAME = {
    "italy": "Italy",
    "france": "France",
    "germany": "Germany",
    "spain": "Spain",
    "belgium": "Belgium",
    "the-netherlands": "Netherlands",
    "poland": "Poland",
    "portugal": "Portugal",
    "romania": "Romania",
    "greece": "Greece",
    "australia": "Australia",
    "austria": "Austria",
    "denmark": "Denmark",
    "finland": "Finland",
    "sweden": "Sweden",
    "norway": "Norway",
    "ireland": "Ireland",
    "croatia": "Croatia",
    "india": "India",
    "malaysia": "Malaysia",
    "mexico": "Mexico",
    "saudi-arabia": "Saudi Arabia",
    "colombia": "Colombia",
    "israel": "Israel",
    "singapore": "Singapore",
    "new-zealand": "New Zealand",
    "uae": "United Arab Emirates",
    "united-kingdom": "United Kingdom",
    "usa": "USA",
    "oman": "Oman",
    "the-philippines": "Philippines",
    "luxembourg": "Luxembourg",
}

# Mappa nome inglese -> slug URL (inverso di SLUG_TO_NAME)
NAME_TO_SLUG = {v: k for k, v in SLUG_TO_NAME.items()}

# Nomi italiani per tutti i paesi noti (e futuri comuni)
NAME_IT = {
    "Italy": "Italia",
    "France": "Francia",
    "Germany": "Germania",
    "Spain": "Spagna",
    "Belgium": "Belgio",
    "Netherlands": "Paesi Bassi",
    "Poland": "Polonia",
    "Portugal": "Portogallo",
    "Romania": "Romania",
    "Greece": "Grecia",
    "Australia": "Australia",
    "Austria": "Austria",
    "Denmark": "Danimarca",
    "Finland": "Finlandia",
    "Sweden": "Svezia",
    "Norway": "Norvegia",
    "Ireland": "Irlanda",
    "Croatia": "Croazia",
    "India": "India",
    "Malaysia": "Malesia",
    "Mexico": "Messico",
    "Saudi Arabia": "Arabia Saudita",
    "Colombia": "Colombia",
    "Israel": "Israele",
    "Singapore": "Singapore",
    "New Zealand": "Nuova Zelanda",
    "United Arab Emirates": "Emirati Arabi Uniti",
    "United Kingdom": "Regno Unito",
    "USA": "Stati Uniti",
    "Oman": "Oman",
    "Philippines": "Filippine",
    "Luxembourg": "Lussemburgo",
    # Paesi futuri — aggiungere qui quando rilevati
    "Switzerland": "Svizzera",
    "Czech Republic": "Repubblica Ceca",
    "Hungary": "Ungheria",
    "Slovakia": "Slovacchia",
    "Bulgaria": "Bulgaria",
    "Lithuania": "Lituania",
    "Latvia": "Lettonia",
    "Estonia": "Estonia",
    "Slovenia": "Slovenia",
    "Turkey": "Turchia",
    "Brazil": "Brasile",
    "Argentina": "Argentina",
    "Chile": "Cile",
    "Peru": "Perù",
    "Japan": "Giappone",
    "South Korea": "Corea del Sud",
    "China": "Cina",
    "Indonesia": "Indonesia",
    "Thailand": "Tailandia",
    "Vietnam": "Vietnam",
    "South Africa": "Sudafrica",
    "Kenya": "Kenya",
    "Egypt": "Egitto",
    "Nigeria": "Nigeria",
    "Canada": "Canada",
}

# Regex per estrarre la data di aggiornamento dalla pagina
LAST_UPDATE_RE = re.compile(
    r"Last update:\s*([0-9]{4}),?\s*([A-Za-z]+)\s*([0-9]{1,2})", re.IGNORECASE
)

# Regex per trovare i link alle pagine paese nella pagina indice
COUNTRY_LINK_RE = re.compile(
    r'href="(https://www\.theinvoicinghub\.com/einvoicing-compliance-([a-z0-9-]+)/)"',
    re.IGNORECASE,
)


def fetch(url: str, timeout: int = 20) -> str:
    req = Request(url, headers={"User-Agent": USER_AGENT})
    with urlopen(req, timeout=timeout) as resp:
        return resp.read().decode("utf-8", errors="ignore")


def extract_last_update(html: str) -> str | None:
    m = LAST_UPDATE_RE.search(html)
    if not m:
        return None
    year, month, day = m.groups()
    return f"{month} {day}, {year}"


def slug_to_display_slug(url_slug: str) -> str:
    """Converte lo slug URL in slug display (senza 'the-')."""
    return url_slug.replace("the-", "")


def load_json(path: Path, default):
    if path.exists():
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    return default


def save_json(path: Path, data):
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)


def detect_new_countries(existing_slugs: set) -> list[dict]:
    """Scarica la pagina indice e restituisce i nuovi paesi non ancora in countries.json."""
    print(f"  [INDEX] Scarico lista paesi da {INDEX_URL}")
    try:
        html = fetch(INDEX_URL)
    except Exception as e:
        print(f"  [INDEX] ERRORE: {e}")
        return []

    found_slugs = set()
    for match in COUNTRY_LINK_RE.finditer(html):
        url_slug = match.group(2).lower()
        found_slugs.add(url_slug)

    new_slugs = found_slugs - existing_slugs
    if not new_slugs:
        print("  [INDEX] Nessun nuovo paese rilevato.")
        return []

    print(f"  [INDEX] Nuovi paesi rilevati: {new_slugs}")
    new_entries = []
    for url_slug in sorted(new_slugs):
        name = SLUG_TO_NAME.get(url_slug)
        if not name:
            # Costruisce un nome dal slug se non mappato
            name = url_slug.replace("-", " ").title()
            # Aggiorna anche SLUG_TO_NAME e NAME_TO_SLUG per questa sessione
            SLUG_TO_NAME[url_slug] = name
            NAME_TO_SLUG[name] = url_slug

        name_it = NAME_IT.get(name, name)
        display_slug = slug_to_display_slug(url_slug)
        last_update = ""

        # Prova a leggere la data di aggiornamento dalla pagina del paese
        country_url = f"{BASE_URL}/einvoicing-compliance-{url_slug}/"
        try:
            country_html = fetch(country_url)
            last_update = extract_last_update(country_html) or ""
            time.sleep(0.8)
        except Exception as e:
            print(f"    [WARN] Impossibile leggere {country_url}: {e}")

        entry = {
            "name": name,
            "name_it": name_it,
            "b2g_status": "N/A",
            "b2g_since": "N/A",
            "b2g_platform": "N/A",
            "b2g_format": "N/A",
            "b2g_network": "N/A",
            "b2g_notes": "Dati da verificare — paese aggiunto automaticamente.",
            "b2b_status": "N/A",
            "b2b_since": "N/A",
            "b2b_platform": "N/A",
            "b2b_format": "N/A",
            "b2b_network": "N/A",
            "b2b_notes": "Dati da verificare — paese aggiunto automaticamente.",
            "b2c_status": "N/A",
            "b2c_since": "N/A",
            "b2c_platform": "N/A",
            "b2c_format": "N/A",
            "b2c_network": "N/A",
            "b2c_notes": "N/A",
            "ereporting_status": "N/A",
            "ereporting_since": "N/A",
            "ereporting_platform": "N/A",
            "ereporting_scope": "N/A",
            "ereporting_frequency": "N/A",
            "ereporting_notes": "N/A",
            "archiving_mandatory": "N/A",
            "archiving_retention": "N/A",
            "archiving_rules": "N/A",
            "archiving_platform": "N/A",
            "archiving_notes": "N/A",
            "last_update": last_update,
            "slug": display_slug,
            "needs_content_review": True,
        }
        new_entries.append(entry)
        print(f"    [NEW] Aggiunto: {name} ({name_it}) — slug: {display_slug}")

    return new_entries


def main():
    countries = load_json(DATA_FILE, [])
    if not countries:
        print("ERRORE: data/countries.json non trovato o vuoto.", file=sys.stderr)
        sys.exit(1)

    changelog = load_json(CHANGELOG_FILE, [])

    # Calcola gli slug URL già presenti (invertendo NAME_TO_SLUG)
    existing_slugs = set()
    for c in countries:
        name = c["name"]
        url_slug = NAME_TO_SLUG.get(name)
        if url_slug:
            existing_slugs.add(url_slug)

    # 1. Rileva e aggiunge nuovi paesi
    new_entries = detect_new_countries(existing_slugs)
    if new_entries:
        countries.extend(new_entries)
        for entry in new_entries:
            changelog.append({
                "country": entry["name"],
                "event": "new_country_added",
                "name_it": entry["name_it"],
                "url": f"{BASE_URL}/einvoicing-compliance-{NAME_TO_SLUG.get(entry['name'], entry['slug'])}/",
                "detected_at": datetime.now(timezone.utc).isoformat(),
            })

    # 2. Verifica aggiornamenti paesi esistenti
    checked = 0
    changed = []
    errors = []

    for country in countries:
        name = country["name"]

        # Garantisce che name_it sia sempre presente
        if "name_it" not in country:
            country["name_it"] = NAME_IT.get(name, name)

        url_slug = NAME_TO_SLUG.get(name)
        if not url_slug:
            print(f"  [SKIP] Nessun mapping URL per {name}")
            continue

        url = f"{BASE_URL}/einvoicing-compliance-{url_slug}/"
        print(f"  [CHECK] {name} ({country.get('name_it', name)}) → {url}")

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
                "name_it": country.get("name_it", name),
                "previous_last_update": local_update,
                "new_last_update": remote_update,
                "url": url,
                "detected_at": datetime.now(timezone.utc).isoformat(),
            })
            country["last_update"] = remote_update
            country["needs_content_review"] = True
        else:
            country["needs_content_review"] = country.get("needs_content_review", False)

        time.sleep(0.8)

    # Salva countries.json aggiornato
    save_json(DATA_FILE, countries)

    # Aggiorna changelog
    if changed or new_entries:
        changelog.extend(changed)
        save_json(CHANGELOG_FILE, changelog)

    # Aggiorna meta.json
    MESI_IT = ["gennaio","febbraio","marzo","aprile","maggio","giugno",
               "luglio","agosto","settembre","ottobre","novembre","dicembre"]
    now = datetime.now(timezone.utc)
    data_it = f"{now.day} {MESI_IT[now.month - 1]} {now.year}"
    meta = {
        "last_run": data_it,
        "last_run_iso": now.isoformat(),
        "countries_total": len(countries),
        "countries_checked": checked,
        "countries_changed": len(changed),
        "countries_new": len(new_entries),
        "errors": errors,
        "status": "ok" if not errors else "partial_errors",
    }
    save_json(META_FILE, meta)

    print(f"\n✓ Totale paesi: {len(countries)}")
    print(f"✓ Controllati: {checked}")
    print(f"✓ Nuovi paesi aggiunti: {len(new_entries)}")
    print(f"✓ Cambiamenti rilevati: {len(changed)}")
    if new_entries:
        print("  Nuovi paesi:")
        for e in new_entries:
            print(f"   - {e['name']} ({e['name_it']})")
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
