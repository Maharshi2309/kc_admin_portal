# CLAUDE.md — kc_admin_portal

Flutter web admin portal for Keshav Clothing. Manages employees, attendance, and leave.

---

## Running the app

**Always run with the env file — the app throws at startup without it:**

```bash
flutter run -d chrome --dart-define-from-file=env/dev.json
```

**CORS issue on Flutter Web (mandatory for real API):**

```bash
flutter run -d chrome --web-browser-flag "--disable-web-security" --dart-define-from-file=env/dev.json
```

Chrome must be fully closed before running — if Chrome is already open the flag is ignored and all API calls fail with "Cannot reach the server." For a reliable workaround use an isolated profile:

```bash
flutter run -d chrome --web-browser-flag "--disable-web-security --user-data-dir=C:\tmp\flutter-dev-chrome" --dart-define-from-file=env/dev.json
```

**Mock API (no backend needed):**

Set `"USE_MOCK_API": true` in `env/dev.json`. Mock credentials work on the login screen. Use this when the real API is unavailable or to test UI without CORS.

---

## Environment files

| File | Purpose |
|------|---------|
| `env/dev.example.json` | Template — copy to `env/dev.json` |
| `env/dev.json` | Local dev config (git-ignored) |
| `env/prod.example.json` | Production template |

Keys:

```json
{
  "APP_ENV": "dev",
  "API_BASE_URL": "https://your-backend/api",
  "API_TIMEOUT_SECONDS": 30,
  "USE_MOCK_API": false
}
```

`USE_MOCK_API: true` is rejected in production builds (`APP_ENV: "prod"`). The API URL must use HTTPS in production.

---

## Architecture

Feature-first layered architecture. Every feature folder looks like:

```
lib/features/<feature>/
  data/
    datasources/   ← API or mock data source (interface + implementations)
    models/        ← Freezed models (plain Dart, no Flutter)
    repositories/  ← Repository implementations
  domain/
    repositories/  ← Abstract repository interface
  presentation/
    providers/     ← Riverpod providers and controllers
    screens/       ← Full-page widgets (ConsumerWidget)
    widgets/       ← Reusable sub-widgets for the feature
```

Shared code lives in:

```
lib/core/         ← Network, errors, storage, theme, widgets, utils
lib/shared/       ← Models used across features (JobRole, ListEntry, etc.)
lib/app/          ← Router, shell, theme, startup
```

---

## State management — Riverpod 3.x

- Use `ConsumerWidget` / `ConsumerStatefulWidget` for widgets that watch providers.
- Helper functions that call `ref.watch` must take `WidgetRef`, not `Ref`.
- `AsyncValue.valueOrNull` does not exist in Riverpod 3.x. Use pattern matching:

```dart
switch (ref.watch(someProvider)) {
  AsyncData(:final value) => value,
  _ => const [],
}
```

- `FutureProvider` has no `retry:` parameter. Use `ref.invalidate(provider)` on error to retry.

---

## Data models — Freezed

All models use `freezed` + `json_serializable`. Files are:

```
foo_model.dart          ← source of truth (edit this)
foo_model.freezed.dart  ← generated (manually maintained — see below)
foo_model.g.dart        ← generated (manually maintained — see below)
```

**Code generation is broken** — the project requires Dart `^3.12.2` (Flutter ≥ 3.38.4) but the installed Flutter may be older. Do not run `dart run build_runner build`; edit the `.freezed.dart` and `.g.dart` files manually when models change.

**Generated file rules:**
- Models without a private constructor use `implements` in the generated class.
- Models with `const ModelName._()` use `extends` and call `super._()`.
- `@Default(x)` fields get `@JsonKey(defaultValue: x)` in `.g.dart`.
- `whenOrNull` callbacks return `TResult?` (nullable), while `when`/`maybeWhen` use `TResult`.

---

## Networking

`ApiClient` (`lib/core/network/api_client.dart`) is the only class that talks HTTP. It wraps Dio and always returns typed results or an `AppException` — never a raw Dio error.

Data sources call `ApiClient` methods with a `parse:` callback:

```dart
_client.get(ApiConstants.departments, parse: _entries);
_client.post(ApiConstants.login, body: {...}, parse: (json) => Model.fromJson(...));
_client.patch(path, body: {...}, parse: ApiClient.ignoreBody);
```

`ApiClient.ignoreBody` is the `parse:` for endpoints whose response body is not needed.

All API path strings live in `lib/core/constants/api_constants.dart`. Add new paths there; never hard-code paths in data sources.

---

## Error handling

`AppException` (`lib/core/errors/app_exception.dart`) is a sealed class. Subtypes:

| Type | Cause |
|------|-------|
| `NetworkException` | No connection, DNS failure, CORS block |
| `RequestTimeoutException` | Timeout |
| `UnauthorizedException` | 401 — session expired |
| `ForbiddenException` | 403 — lacks permission. Has `.code` for machine-readable reason |
| `NotFoundException` | 404 |
| `ValidationException` | 400/409/422. Has `.fieldErrors` (map field→message) and `.code` |
| `ServerException` | 5xx |
| `UnknownException` | Anything else |

Machine-readable error codes from `ApiConstants`:

- `INSUFFICIENT_LEAVE_BALANCE` — resend with `splitExcessAsUnpaid: true` for unpaid overflow
- `LEAVE_NOT_EDITABLE` — 409 when editing a non-pending leave
- `LAST_PERMISSION_MANAGER` — 409 when removing the last permission manager
- `CANNOT_CHANGE_OWN_ACCESS` — 409 when user tries to change their own permissions
- `PERMISSION_DENIED` — 403 when the user lacks the required permission

---

## Master data (departments & positions)

`GET /departments` and `GET /positions` return `List<ListEntry>`. These are fetched once after sign-in.

```dart
// In a widget build method:
final departments = watchDepartments(ref);  // List<ListEntry>
final positions   = watchPositions(ref);    // List<ListEntry>
```

`ListEntry` has `id`, `code` (stable snake_case, e.g. `graphic_designer`), `name` (human label), and `employeeCount`.

To resolve a code to a display name:

```dart
resolveEntryName(employee.department, departments)  // falls back to humanise()
```

**Important:** `EmployeeModel.department` and `.position` are still `JobRole` (enum) for display. Query/filter models (`EmployeeQuery`, `AttendanceQuery`, `LeaveQuery`, `LeaveBalanceQuery`) use `String?` for department/position — this was migrated from `JobRole?` in API 0.3.0.

---

## JobRole enum

`lib/shared/models/job_role.dart` — fixed 3-value enum: `accountant`, `graphicDesigner`, `tailor`, plus `unknown` for unrecognised values.

Used in `EmployeeModel` and `EmployeeFormData` for the employee's own department/position. Do not use it for filter queries — those take `String?` codes directly.

---

## Responsive layout

Breakpoints in `AppBreakpoints`:

| Size | Width | Layout |
|------|-------|--------|
| mobile | < 600 | Bottom nav, single column |
| tablet | 600–1023 | Nav rail, two columns |
| desktop | 1024–1439 | Full sidebar |
| largeDesktop | ≥ 1440 | Same as desktop, content capped at 1440 px |

Max content width: 1440 px. Max form width: 1120 px.

Use `ScreenSize.fromWidth(MediaQuery.sizeOf(context).width)` to get the current size class.

---

## Router

go_router with path-based URLs (no hash). Public paths (no auth required): `/login`, `/splash`, `/dev/components`.

Auth redirect logic in `lib/app/router/route_guards.dart`:
- Unknown session → splash
- Signed out → login (with `?from=` for deep-link return)
- Signed in on login/splash → redirects to `?from` or dashboard

---

## Theme & widgets

Use design tokens from `AppColors`, `AppTextStyles`, `AppDimensions`. Never use raw hex values or hard-coded font sizes.

Core widget library in `lib/core/widgets/`. Always prefer these over Material widgets directly:

| Widget | Purpose |
|--------|---------|
| `AppButton` | Primary / secondary / destructive buttons |
| `AppTextField` | Form text input |
| `AppDropdown` | Searchable dropdown |
| `AppDatePicker` | Date selection |
| `AppCard` | Content card |
| `AppDialog` | Modal dialog |
| `AppSnackbar` | Toast notifications |
| `AppPage` / `AppPageBody` | Page scaffold |
| `AsyncValueView` | Loading / error / data states for `AsyncValue` |
| `AppPagination` | Page controls |
| `AppFilterDropdown` | Filter chips with dropdown |

---

## Features overview

| Feature | Screens | Key endpoints |
|---------|---------|---------------|
| auth | Login | `POST /auth/login`, `GET /auth/me`, `POST /auth/logout` |
| employees | List, Add/Edit form | `GET/POST /employees`, `PATCH /employees/:id`, `GET /employees/:id` |
| attendance | Day view, log | `GET /attendance`, `POST /attendance/punch-in`, `POST /attendance/punch-out` |
| leave | List, Add/Edit | `GET/POST /leaves`, `PATCH /leaves/:id/status` |
| master_data | (no screen yet) | `GET /departments`, `GET /positions` |
| access_control | Permissions | `GET /permissions`, `GET/PATCH /users/:id/permissions` |

---

## Adding a new feature

1. Create the folder structure under `lib/features/<name>/`.
2. Add API path constants to `ApiConstants`.
3. Write the Freezed model in `.dart`; manually write matching `.freezed.dart` and `.g.dart`.
4. Write the `abstract interface class` data source and the API implementation.
5. Write the repository interface and implementation.
6. Create Riverpod providers in `presentation/providers/`.
7. Build screens using `AppPage`, `AsyncValueView`, and design-token widgets.
8. Register routes in the router.

---

## Known constraints

- **`build_runner` is non-functional** until Flutter is upgraded to ≥ 3.38.4 (Dart ≥ 3.12.2). All generated files must be maintained manually.
- **CORS on Flutter Web** — any request to an external API requires `--disable-web-security` in Chrome, or a backend CORS header (`Access-Control-Allow-Origin: *`). This is a browser restriction, not a code problem.
- **`EmployeeModel.department/position`** remain `JobRole` (enum) in the model and display layer. Filter/query fields are `String?`.
- `USE_MOCK_API` has no mock data source for `master_data` — departments and positions always come from the real API even in mock mode.
