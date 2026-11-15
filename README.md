# Schappie: stap 1 installeren

Deze map bevat de eerste werkende versie van Schappie:

- inloggen met je eigen account
- voorraad bekijken per koelkast, vriezer en kast
- producten toevoegen, aanpassen en verwijderen
- per product kiezen: bijhouden in aantal, gram of vol/half/leeg
- houdbaarheidsdatum, openingsdatum (de houdbaarheid rekent mee) en verplaatsen naar de vriezer
- een lijstje van wat bijna over de datum gaat

Het kost je ongeveer 20 minuten. Je hoeft niets te programmeren, alleen te kopiëren en plakken.

## Wat zit erin?

| Bestand | Wat het is |
|---|---|
| `schema.sql` | De database: tabellen en beveiligingsregels |
| `index.html` | De app zelf |
| `manifest.json`, `sw.js`, `icon-*.png` | Zodat je hem als app op je iPhone kunt zetten |

---

## Stap A: Supabase-project maken

1. Ga naar **supabase.com** en log in. Met je GitHub-account is het makkelijkst.
2. Klik op **New project**.
   - Name: `schappie`
   - Database password: verzin er een en bewaar hem in je wachtwoordmanager
   - Region: **Central EU (Frankfurt)**
3. Wacht een minuut tot het project klaarstaat.

## Stap B: de database aanmaken

1. Klik links op **SQL Editor** en dan op **New query**.
2. Open `schema.sql`, kopieer alles en plak het in het venster.
3. Klik op **Run**. Je ziet "Success. No rows returned". Dat is goed.

## Stap C: je account maken (en anderen buiten houden)

1. Ga naar **Authentication → Sign In / Providers** (soms heet het menu iets anders) en zet **"Allow new users to sign up"** **uit**. Nu kan niemand zelf een account maken.
2. Ga naar **Authentication → Users → Add user → Create new user**.
   - Vul je e-mailadres en een wachtwoord in.
   - Vink **Auto Confirm User** aan.
3. Wil je later een kennis toelaten? Maak hier dan op dezelfde manier een account voor hem aan. Aan de app hoeft niets te veranderen.

## Stap D: de app aan je database koppelen

1. Ga naar **Project Settings → API Keys** (of **Data API**).
2. Kopieer:
   - de **Project URL** (iets als `https://abcdefgh.supabase.co`)
   - de **anon public key** of **publishable key**. Dit is de openbare sleutel. Deze mag in de app staan, omdat de beveiligingsregels uit stap B je data beschermen.
   - **Gebruik nooit de `service_role`- of secret key.** Die geeft volledige toegang.
3. Open `index.html` in een teksteditor (bijvoorbeeld Kladblok of VS Code) en vul bovenaan de twee regels in:

```js
const SUPABASE_URL = 'https://abcdefgh.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOi...';   // of sb_publishable_...
```

## Stap E: online zetten met GitHub Pages (gratis)

1. Ga naar **github.com** en klik op **New repository**.
   - Naam: `schappie`
   - Mag gewoon **Public** zijn, want er staan geen geheimen in.
2. Klik op **uploading an existing file** en sleep alle bestanden uit deze map erin (ook de plaatjes). Klik op **Commit changes**.
3. Ga naar **Settings → Pages**.
   - Source: **Deploy from a branch**
   - Branch: **main**, map **/ (root)**, en klik op **Save**.
4. Na een minuutje staat je app op `https://<jouw-gebruikersnaam>.github.io/schappie/`.

## Stap F: op je iPhone zetten

1. Open die link in **Safari**.
2. Tik op **Deel** (vierkantje met pijl) → **Zet op beginscherm**.
3. Open de app vanaf je beginscherm en log in.

Op de pc open je dezelfde link in Chrome of Edge. Je ziet daar precies dezelfde voorraad.

---

## Iets werkt niet?

- **"Inloggen mislukt":** controleer of je account bestaat (stap C) en "Auto Confirm" aan stond.
- **"Laden mislukt" of een lege pagina:** controleer de URL en key in `index.html` (stap D). Na een aanpassing moet je het bestand opnieuw uploaden naar GitHub.
- **De app laat een oude versie zien:** sluit de app helemaal af en open hem opnieuw.
- **Supabase zegt dat je project gepauzeerd is:** dat gebeurt na een week zonder gebruik. Klik in het dashboard op **Restore**. Je data blijft bewaard.

## Volgende stappen

2. Barcode scannen (Open Food Facts)
3. Recepten met Claude, met aantal personen en kosten
4. Vaste combi's
5. Meldingen als iets bijna over de datum gaat
