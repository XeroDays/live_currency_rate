# AI Context Index — live_currency_rate

## How to use and maintain this file

**For LLMs:** If this file is read without other chat context, treat it as a request to load full project context from here before exploring the repo.

**Update this file when:** features/workflows change, files move, architecture changes, new integrations, API contract changes, or example app behavior changes.

**Format rules:**
- Concise, high-signal, low-noise — no code snippets, no user docs, no install steps
- Reference file paths and flows, not implementation details
- Tables and short bullets over paragraphs
- Re-scan the codebase before editing; remove stale entries

---

## Project Summary

| Item | Value |
|------|--------|
| **Purpose** | Flutter/Dart package for live forex conversion via remote API (Skysol / Softasium backend) |
| **Architecture** | Single-package library + optional demo app; static API facade, no layered backend |
| **Framework** | Flutter (`>=1.17.0`), Dart SDK `>=3.0.5 <4.0.0` |
| **Languages** | Dart |
| **Database** | None |
| **External services** | `https://api.softasium.com/Currency` (HTTPS POST) |
| **Deployment** | Published to [pub.dev](https://pub.dev/packages/live_currency_rate); CI publish on version tags |
| **Repo layout** | Package root + `example/` demo app + `images/` for README |

---

## Architecture Rules

- **Public API** is exported only through `lib/live_currency_rate.dart` → `lib/src/livecurrencyrate.dart`
- **All network logic** lives in `LiveCurrencyRate` static methods in `lib/src/livecurrencyrate.dart` — no separate service/repository layers
- **Consumers** import `package:live_currency_rate/live_currency_rate.dart` and call `LiveCurrencyRate.convertCurrency`
- **Example app** depends on package via `path: ../` in `example/pubspec.yaml` — not pub.dev version during local dev
- **No local persistence** — rates are fetched on demand; no caching layer beyond in-memory `_healthCheck` flag
- **Global HTTP override** — `HttpOverrides.global` set inside `convertCurrency` for certificate handling (`MyHttpOverrides`)
- **Health check** runs once per process before conversion POST (guarded by `_healthCheck`)

---

## Feature Registry

### Currency Conversion (package core)

**Purpose:** Convert an amount from one ISO currency code to another using live rates.

**Entry points:**
- `LiveCurrencyRate.convertCurrency(currentCurrency, toCurrency, price, {timeOutSeconds})`

**Primary files:**
- `lib/src/livecurrencyrate.dart` — `LiveCurrencyRate`, `CurrencyRate`, `MyHttpOverrides`
- `lib/live_currency_rate.dart` — barrel export

**Related files:**
- `test/livecurrencyrate_test.dart` — placeholder (empty `main`)
- `pubspec.yaml` — `http` dependency

**Dependencies:** `package:http`, remote Currency API

**Workflow:**
Caller → `convertCurrency` → (optional health POST) → conversion POST → JSON parse → `CurrencyRate`

---

### Health Check (package internal)

**Purpose:** Verify API availability once before first conversion in a process.

**Entry points:** Internal — first `convertCurrency` call when `_healthCheck == false`

**Primary files:** `lib/src/livecurrencyrate.dart`

**Workflow:**
`convertCurrency` → POST `{baseUrl}/health` → set `_healthCheck = true` on 200

---

### Demo App — Live Rate Screen

**Purpose:** Minimal UI demo: USD → AED, fetch and display rate on button tap.

**Entry points:**
- `example/lib/main.dart` — `main()`, `MyApp`, `Home`

**Primary files:**
- `example/lib/main.dart` — `Home`, `_HomeState`, `_fetchRate`, `_CurrencyPairCard`, `_RateCard`, `_CurrencyChip`

**Related files:**
- `example/pubspec.yaml`
- `example/test/widget_test.dart` — **stale** (still expects counter app; not aligned with current UI)

**Dependencies:** `live_currency_rate` (path), Flutter Material 3

**Workflow:**
App start → `Home` → user taps "Get live rate" → `_fetchRate` → `LiveCurrencyRate.convertCurrency('USD','AED',1)` → `setState` with formatted rate string

---

### Pub.dev Publish (CI)

**Purpose:** Automated package publish when version tag is pushed.

**Entry points:** `.github/workflows/publish.yml` — trigger `push` tags `v*.*.*`

**Primary files:**
- `.github/workflows/publish.yml`
- Root `pubspec.yaml` (version must match tag strategy)

**Workflow:**
Tag push → checkout → `flutter pub get` → `flutter pub publish --dry-run` → `flutter pub publish -f`

---

## Workflow Registry

### Convert Currency (library)

**Trigger:** App or package consumer calls `LiveCurrencyRate.convertCurrency`.

**Flow:**
1. Set `HttpOverrides.global` (`MyHttpOverrides`)
2. If `!_healthCheck` → POST `/Currency/health`
3. POST `/Currency/{from}/{to}/{amount}` with auth header
4. Status 200 → `CurrencyRate.fromSnapshot(json)`
5. Status 300 → timeout / weak network result
6. Other / exception → error `CurrencyRate` with `status: false`

**Files:**
- `lib/src/livecurrencyrate.dart`

---

### Example — Fetch USD/AED Rate

**Trigger:** User taps `FilledButton` ("Get live rate") in demo.

**Flow:**
`Home` → `_fetchRate` → `isLoading=true` → `convertCurrency` → update `rates` string → `isLoading=false`

**Files:**
- `example/lib/main.dart`

---

### Publish Package

**Trigger:** Git tag matching `v[0-9]+.[0-9]+.[0-9]+*`.

**Flow:**
GitHub Actions → Flutter/Dart setup → `pub get` → dry-run publish → force publish

**Files:**
- `.github/workflows/publish.yml`

---

## File Responsibility Map

| Responsibility | File |
|----------------|------|
| Public package export | `lib/live_currency_rate.dart` |
| API client, models, HTTP overrides | `lib/src/livecurrencyrate.dart` |
| Package metadata & deps | `pubspec.yaml` |
| Package tests (unused stub) | `test/livecurrencyrate_test.dart` |
| Lint config (package) | `analysis_options.yaml` |
| User-facing package overview | `README.md` |
| Version history | `CHANGELOG.md` |
| Demo app UI & integration | `example/lib/main.dart` |
| Demo app deps | `example/pubspec.yaml` |
| Demo widget test (outdated) | `example/test/widget_test.dart` |
| CI publish | `.github/workflows/publish.yml` |
| Flutter SDK pin (FVM) | `.fvmrc` |
| README screenshots | `images/*` |

---

## Data Flow Map

```
Consumer app (example or external)
  → LiveCurrencyRate.convertCurrency()
    → http POST api.softasium.com/Currency/health (once)
    → http POST api.softasium.com/Currency/{from}/{to}/{amount}
      → JSON { message, status, result }
        → CurrencyRate
          → UI display / caller logic
```

No database, queue, or local cache of rates (except `_healthCheck` boolean).

---

## Integration Registry

### Softasium Currency API

| Item | Detail |
|------|--------|
| **Purpose** | Live currency conversion rates |
| **Base URL** | `https://api.softasium.com/Currency` |
| **Auth** | Header `Authorization: iamsyedidrees` (hardcoded in `livecurrencyrate.dart`) |
| **Methods** | POST health, POST `/{from}/{to}/{amount}` |
| **Files** | `lib/src/livecurrencyrate.dart` |
| **Entry** | `LiveCurrencyRate.convertCurrency` |
| **Platform notes** | iOS, Android, Web, Windows, Linux, macOS supported |

### pub.dev

| Item | Detail |
|------|--------|
| **Purpose** | Package distribution |
| **Files** | `pubspec.yaml`, `.github/workflows/publish.yml` |
| **Auth** | GitHub OIDC / pub publish token (workflow `id-token: write`) |

---

## Dependency Impact Map

### Module: `lib/src/livecurrencyrate.dart`

**Changing these files may impact:**
- All consumers of `LiveCurrencyRate.convertCurrency`
- `CurrencyRate` JSON shape expectations
- Network error messages and timeout behavior
- SSL/certificate behavior app-wide (sets global `HttpOverrides`)

### Module: `lib/live_currency_rate.dart`

**Changing may impact:**
- Public import path (keep stable for pub.dev consumers)

### Module: `example/lib/main.dart`

**Changing may impact:**
- Demo UX only — not package API

### Module: `pubspec.yaml` (root)

**Changing may impact:**
- pub.dev version, `http` dependency, SDK constraints, publish CI

### Module: Remote API contract

**Changing may impact:**
- `CurrencyRate.fromSnapshot` field mapping (`message`, `status`, `result`)
- Health check and conversion endpoints

---

## Known Conventions

- **Package name:** `live_currency_rate` (pub); library file uses `livecurrencyrate` internally
- **Single implementation file** under `lib/src/` — no feature folders in package
- **Static-only API** — no instances of `LiveCurrencyRate`
- **Example app name:** `example` (folder and pubspec `name: example`)
- **Example uses path dependency** `../` for local package development
- **FVM:** `.fvmrc` pins Flutter `3.32.7` (example may use newer SDK `^3.8.1` in its pubspec)
- **Linting:** `flutter_lints` — package `^2.0.0`, example `^5.0.0`
- **Private UI widgets** in example prefixed with `_` (`_CurrencyPairCard`, etc.)
- **Demo hardcodes** USD → AED, amount `1` — not configurable in UI
- **Tests:** root package test is empty; example widget test does not match current demo (counter expectations)

---

## Repository Map (quick navigation)

```
live_currency_rate/          # Flutter package (publishable)
  lib/
    live_currency_rate.dart
    src/livecurrencyrate.dart
  test/
  example/                   # Flutter demo app
    lib/main.dart
  images/                    # README assets
  .github/workflows/
```

---

## Maintenance Checklist (sync triggers)

- [ ] New public method or model on `LiveCurrencyRate` / `CurrencyRate`
- [ ] API URL, headers, or response schema change
- [ ] Example UI or default currency pair change
- [ ] `example2` renamed / removed / added apps
- [ ] Platform support change (web, desktop, etc.)
- [ ] CI or publish workflow change
- [ ] Major dependency bumps (`http`, SDK, Flutter min version)
