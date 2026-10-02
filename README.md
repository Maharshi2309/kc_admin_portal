# Keshav Admin Portal

Flutter admin portal (Android, iOS, Web) for managing employees, EC numbers, attendance and leave.
It talks to a separate Next.js REST API.

- **State:** Riverpod · **Routing:** go_router · **HTTP:** dio · **Models:** freezed + json_serializable
- **Design reference:** Claude Design canvas "Keshav Admin Portal"

## Setup

Requires Flutter 3.44+ (Dart 3.12+).

```bash
flutter pub get
cp env/dev.example.json env/dev.json   # then edit API_BASE_URL
```

### Environment config

The app reads its configuration at build time from `env/<name>.json`, passed with `--dart-define-from-file`.
Only the `*.example.json` templates are committed.

| Key | Meaning |
|---|---|
| `APP_ENV` | `dev` or `prod` |
| `API_BASE_URL` | REST API root, e.g. `http://localhost:3000/api` |
| `API_TIMEOUT_SECONDS` | Request timeout (default 30) |
| `USE_MOCK_API` | **Dev only.** `true` uses built-in fake data instead of the REST API (sign in as a sample user, e.g. `admin@keshav.in` (full access), `nisha.solanki@keshav.in` or `arjun.joshi@keshav.in` (limited access), with the password `password`; the mock enforces each user's own permissions like the backend). The app refuses to start with it in a `prod` build. Set to `false` once the backend is running. |

### API contract

The API the app expects is written up for the backend team in
[`docs/API_CONTRACT.md`](docs/API_CONTRACT.md), with an example request/response for every endpoint in
[`docs/api-examples/`](docs/api-examples/). Contract tests (`test/contract/`) run those examples through the real
parsing code. Endpoint paths live in `lib/core/constants/api_constants.dart`.

Sessions use a bearer token. With "Keep me signed in" (the default) it is kept in the platform's secure storage;
otherwise it lives in memory until the app closes. On web, secure storage needs a secure context (HTTPS or
`localhost`); if storage is unavailable the session still works until the page is reloaded.

The app refuses to start without a valid `API_BASE_URL`.

Local backend addresses:
- **Web / iOS simulator:** `http://localhost:3000/api`
- **Android emulator:** `http://10.0.2.2:3000/api` (plain HTTP is allowed only in debug builds)

## Run

```bash
flutter run -d chrome --dart-define-from-file=env/dev.json
flutter run            --dart-define-from-file=env/dev.json   # connected Android/iOS device
```

In VS Code and Android Studio the env file is passed automatically
(`.vscode/settings.json`, `.idea/runConfigurations/main_dart.xml`), so the Run button works as is.

If the app starts without its configuration it shows a "The app could not start" screen with the reason.
Env values are compiled in, so after changing `env/*.json` stop and re-run the app; hot reload is not enough.

### Web hosting

The web build uses path URLs (`/employees/42`, not `/#/employees/42`).
The web server must return `index.html` for every app path, e.g.:
- nginx: `try_files $uri /index.html;`
- Firebase Hosting: `"rewrites": [{ "source": "**", "destination": "/index.html" }]`

Without this rule, refreshing or deep-linking returns a 404.

### Routes

| Path | Screen |
|---|---|
| `/login` | Sign in |
| `/dashboard` | Dashboard |
| `/employees` (`?search=`) | Employee list |
| `/employees/add` · `/employees/:id` · `/employees/:id/edit` | Add · profile · edit |
| `/attendance` · `/attendance/:id/edit` · `/attendance/new` | Attendance · correction dialog · add a missing record |
| `/leave` · `/leave/add` · `/leave/:id/edit` | Leaves · add/edit side sheet |
| `/dev/components` | Component gallery (not in production builds) |

Navigate by name (`context.goNamed(AppRouteNames.…)`); names and paths live in `lib/app/router/route_names.dart`.

## Code generation

Models use freezed and json_serializable. After changing a model:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Never edit `*.g.dart` or `*.freezed.dart` by hand.

## Testing

```bash
flutter analyze
flutter test                       # unit, widget, contract and responsive tests
flutter test --coverage            # writes coverage/lcov.info
```

| Folder | What it covers |
|---|---|
| `test/core/`, `test/features/` | Widgets, providers, validation, formatting, mock data sources, full screen flows |
| `test/contract/` | Every real API data source, fed the JSON in `docs/api-examples/` |
| `test/responsive/` | Every screen at 15 sizes (320 px phones to 2560 px), large text (1.3×, 2×), touch targets, labels, contrast, window resizing |
| `test/app/` | Routing, guards, page titles, keyboard navigation |
| `integration_test/` | End to end on a real device or browser: sign in, add an employee, punch in, approve leave, sign out |

End-to-end tests run the real app against the built-in mock API:

```bash
flutter test integration_test -d <device-id>          # Android, iOS or macOS
# Web: start chromedriver on port 4444 first, then
flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/app_flow_test.dart -d chrome
```

Tests use a fixed clock (Mon 28 Sep 2026, 14:30) and zero mock latency, so they never depend on the real date.

### Continuous integration

`.github/workflows/ci.yml` runs on every push to `main` and every pull request: formatting, generated code up to
date, `flutter analyze`, `flutter test --coverage` (report uploaded as an artifact) and a web build.

## Project structure

```
lib/
├── main.dart          entry point: ProviderScope + env
├── app/               app widget, router, responsive shell, theme
├── core/              config, constants, errors, network, responsive, storage, utils, design-system widgets
├── features/          auth · dashboard · employees · attendance · leave · master_data
│                      (each: data/ · domain/ · presentation/{providers,screens,widgets})
└── shared/            models and widgets used by more than one feature
```

Data flow: **Widget → Riverpod provider → Repository → Remote datasource → ApiClient → REST API.**
Widgets never call the API directly.

## Fonts

Plus Jakarta Sans and IBM Plex Mono are bundled under `assets/fonts/` (SIL Open Font License, see `OFL-*.txt`).
