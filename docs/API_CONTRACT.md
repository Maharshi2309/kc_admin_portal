# Keshav Admin Portal — REST API contract (frontend expectations)

This is the API the Flutter admin portal is built against. Each response shape
has a matching example in [`api-examples/`](api-examples/). The contract tests
(`test/contract/api_contract_test.dart`) run those examples through the real
parsing code. **If the backend differs, send us the real shape.** Endpoint
paths live in one file (`lib/core/constants/api_constants.dart`), so changes
are cheap.

Items marked **(confirm)** are assumptions that still need the backend team's
confirmation.

**V2** (schedules, overtime, holidays, calendar, users and permissions) adds the
endpoints in §2 marked *V2*. The tables, calculation rules and migration are in
[`DATABASE_V2.md`](DATABASE_V2.md).

---

## 1. Conventions

| Topic | Expectation |
|---|---|
| Base URL | Set per environment with `API_BASE_URL` (e.g. `https://api.example.com/api`). The paths below are relative to it. |
| Transport | HTTPS in staging and production. Release builds on iOS and Android block plain HTTP. |
| Auth | `Authorization: Bearer <accessToken>` on every request except login. |
| Body | Plain JSON with **no envelope**: return the object or list itself, not `{ "data": … }`. |
| Keys | camelCase (`ecNumber`, `joiningDate`). |
| Enum values | snake_case strings (`on_leave`, `half_day`, `weekly_off`, `device_issue`). The app shows unknown values as "Unknown" and does not crash. |
| Ids | Strings or numbers are both accepted and handled as strings. Leave-type ids may be slugs (`casual`). |
| Dates | Calendar dates as `YYYY-MM-DD` (`joiningDate`, leave `startDate`). The app never shifts them by timezone. |
| Instants | ISO 8601 **with an offset** (`2026-09-28T09:35:00+05:30` or `…Z`). Send them with the **company time zone's** offset (`Asia/Kolkata`, `+05:30`): the app shows times in the company zone, whatever the device's zone. Times the app sends include the offset. |
| Times of day | `"HH:mm"`, 24-hour, company time zone (schedule start/end, break window). |
| Durations | Whole **minutes** as integers (`workedMinutes`, `overtimeMinutes`, `expectedMinutes`). Never fractional hours. |
| Months | Query `month=YYYY-MM`. |
| Nulls | Optional values may be `null` or missing. |
| CORS (web) | Allow the portal's origin, the `Authorization` and `Content-Type` headers, and the methods `GET, POST, PATCH, PUT, DELETE`, including preflight. |

### Pagination

List endpoints take `page` (**1-based**) and `pageSize`. They return:

```json
{ "items": [ … ], "total": 124, "page": 1, "pageSize": 10 }
```

Extra keys are allowed. The employee and leave lists also return `counts` (see below).

### Errors

Every error sends an HTTP status code and this body:

```json
{ "code": "LEAVE_NOT_EDITABLE", "message": "Human-readable, safe to show", "errors": { "field": ["message"] } }
```

- `message` is shown to the admin as-is, so never put stack traces or SQL in it. `error` is accepted as a fallback key.
- `code` is optional and machine-readable, for the cases the app treats differently: `PERMISSION_DENIED` (403), `LEAVE_NOT_EDITABLE`, `SCHEDULE_OVERLAP`, `LAST_PERMISSION_MANAGER`, `CANNOT_CHANGE_OWN_ACCESS` (409). Examples: [`error.forbidden.response.json`](api-examples/error.forbidden.response.json), [`error.leave-not-editable.response.json`](api-examples/error.leave-not-editable.response.json).
- `errors` is optional. Keys match the request body fields (`ecNumber`, `email`, `endDate`, …). A value may be a string or a list of strings. The app shows the message under that field. Example: [`error.validation.response.json`](api-examples/error.validation.response.json).

| Status | App behaviour |
|---|---|
| 400 / 422 | Validation: the field errors appear on the form. |
| 401 on any endpoint except `/auth/login` | Session ended: the local session is cleared and the app returns to login, showing `message` when there is one (e.g. "Your account has been deactivated.", §4.2 of `DATABASE_V2.md`), otherwise "Your session has expired". |
| 401 on `/auth/login` | Wrong credentials: `message` is shown on the form. |
| 403 | The server's `message` ("You do not have permission to …"). The app refreshes the signed-in user's permissions. |
| 404 | "Not found" view. |
| 409 | Conflict (e.g. a duplicate); `message` and `errors` are shown. |
| 5xx / timeout / offline | Generic message with a Retry button. |

The request timeout is `API_TIMEOUT_SECONDS` (default 30).

---

## 2. Endpoints

### Auth

| Method & path | Request | Response |
|---|---|---|
| `POST /auth/login` | [`auth.login.request.json`](api-examples/auth.login.request.json) `{ email, password }` | [`auth.login.response.json`](api-examples/auth.login.response.json) `{ accessToken, user }` |
| `GET /auth/me` | — | [`auth.me.response.json`](api-examples/auth.me.response.json): the user with their `permissions` (keys). Called at start-up to restore a saved session, and again after a 403. |
| `POST /auth/logout` | — | Any 2xx; the body is ignored. The app signs out locally even if this call fails. |

**Permissions** in the user (login and `/auth/me`) are the user's own permission keys (§2, *Required permissions*). The app uses them only to hide or disable what the user can't do; the backend checks every request.

**Sessions.** The token is kept in secure storage, but only when the admin
ticks "Keep me signed in on this device" (the default). Otherwise it lives in
memory until the app closes. **(confirm)** Token lifetime and refresh: there is
no refresh token yet, so an expired token sends the admin back to login. **(confirm)**
For the web build, an httpOnly cookie would be safer than browser storage, if
the backend can issue one.

### Master data

| Method & path | Response |
|---|---|
| `GET /departments` | [`departments.response.json`](api-examples/departments.response.json) |
| `GET /departments/{id}/designations` | [`designations.response.json`](api-examples/designations.response.json) |

### Dashboard

| Method & path | Query | Response |
|---|---|---|
| `GET /dashboard/summary` | `date=YYYY-MM-DD` | [`dashboard.summary.response.json`](api-examples/dashboard.summary.response.json) |
| `GET /dashboard/attendance-chart` | `month=YYYY-MM` | [`dashboard.attendance-chart.response.json`](api-examples/dashboard.attendance-chart.response.json) |

*V2* today's figures follow each employee's schedule (`DATABASE_V2.md` §3):

- `scheduledToday`: active employees for whom today is a working day (not a company holiday, not their weekly off). `presentToday` (half days included), `onLeaveToday` and `absentToday` are counted **among them only**, and the three percentages are shares of `scheduledToday` (`null` when it is 0). Holidays and weekly offs are never absences.
- `holiday`: today's company holiday (`{ id, date, name, description }`) or `null`. Example: [`dashboard.summary-holiday.response.json`](api-examples/dashboard.summary-holiday.response.json).
- `weekOffToday`: employees whose weekly off is today, working or not. `holidayWorkedToday` / `weekOffWorkedToday`: employees working today on a holiday / their weekly off.
- `overtimeMinutesThisMonth` and `overtimeEmployeesThisMonth`: all employees' overtime from the 1st of the month to `date`. Sent only when the caller has `overtime.view`; otherwise `null`.
- `attention`: `not_punched_in` counts only scheduled employees; it is left out when nobody is scheduled.
- Chart `days[].percent`: present as a share of those scheduled that day. Days nobody was scheduled are left out.

### Employees

Employees are **never deleted**, only deactivated.

| Method & path | Request | Response |
|---|---|---|
| `GET /employees` | Query: `search`, `departmentId`, `designationId`, `status` (`active`/`inactive`), `joinedFrom`, `joinedTo` (dates, inclusive), `page`, `pageSize` | [`employees.list.response.json`](api-examples/employees.list.response.json) |
| `GET /employees/next-ec-number` | — | [`employees.next-ec-number.response.json`](api-examples/employees.next-ec-number.response.json) `{ "ecNumber": "KC1129" }` |
| `POST /employees` | [`employees.create.request.json`](api-examples/employees.create.request.json), including the first working `schedule` (*V2*) | The created employee ([`employees.get.response.json`](api-examples/employees.get.response.json)) |
| `GET /employees/{id}` | — | [`employees.get.response.json`](api-examples/employees.get.response.json), with the current `schedule` (*V2*) |
| `PATCH /employees/{id}` | Same body as create, **without** `schedule` (schedule changes add a version, below) | The updated employee |
| `PATCH /employees/{id}/status` | [`employees.status.request.json`](api-examples/employees.status.request.json) `{ "status": "inactive" }` | The updated employee |
| `GET /employees/{id}/attendance-log` | `month=YYYY-MM` | [`employees.attendance-log.response.json`](api-examples/employees.attendance-log.response.json) |
| `GET /employees/{id}/leave-balance` | — | [`employees.leave-balance.response.json`](api-examples/employees.leave-balance.response.json) |
| `GET /employees/{id}/leaves` | — | [`employees.leaves.response.json`](api-examples/employees.leaves.response.json) |

- **`search`** matches the name or EC number.
- **`counts`** in the list response is `{ "active": n, "inactive": n }`. It applies every filter except `status`, so the counts don't change when the admin switches between Active and Inactive. The page subtitle shows "124 active · 4 inactive".
- **EC number format:** `KC` followed by digits (e.g. `KC1001`). The app checks it with `^KC\d+$`.
- **Email:** the app suggests `firstname.lastname@<admin's domain>` for new employees. The admin can change it, so the backend should only check the format and uniqueness.

### Attendance

| Method & path | Request | Response |
|---|---|---|
| `GET /attendance` | Query: `date`, `status` (`present`/`late`/`on_leave`/`absent`; omitted means all), `search`, `departmentId`, `page`, `pageSize` | [`attendance.day.response.json`](api-examples/attendance.day.response.json): `{ summary, items, total, page, pageSize }` |
| `GET /attendance/{id}` | — | [`attendance.record.response.json`](api-examples/attendance.record.response.json) |
| `POST /attendance/punch-in` | [`attendance.punch.request.json`](api-examples/attendance.punch.request.json) `{ employeeId }` | The updated record |
| `POST /attendance/punch-out` | `{ employeeId }` | The updated record |
| `POST /attendance/punch-in/bulk` | [`attendance.punch-in-bulk.request.json`](api-examples/attendance.punch-in-bulk.request.json) `{ date }` | [`attendance.punch-in-bulk.response.json`](api-examples/attendance.punch-in-bulk.response.json) `{ count }` |
| `PATCH /attendance/{id}` | [`attendance.correct.request.json`](api-examples/attendance.correct.request.json) | The updated record |
| `POST /attendance` | Same body, with `employeeId` set (adds a missing day) | The created record |

- An employee with no record yet appears in `items` with `"id": null`.
- Punches record the **server's** current time, so the app does not send a time.
- Records carry (*V2*) `dayKind` (`working` / `holiday_worked` / `week_off_worked`), the employee's `schedule` for that date (`startTime`, `endTime`, `expectedMinutes`; null on holidays and weekly offs), `expectedMinutes` and `overtimeMinutes`. The day summary's `shiftStart`/`shiftEnd` are no longer used, because each employee has their own schedule.
- Work on a holiday or weekly off is entered with `POST /attendance` / `PATCH /attendance/{id}` like any correction; the backend sets `dayKind`.
- Correction `reason` is one of `forgot_to_punch`, `device_issue`, `on_field_duty`, `wrong_time_recorded` or `other`. It is required; `remarks` is optional.

### Leave

Leave is **never deleted**. Cancelled leave stays in the history.

| Method & path | Request | Response |
|---|---|---|
| `GET /leaves` | Query: `status` (`pending`/`approved`/`rejected`/`cancelled`), `search`, `from`, `to`, `leaveTypeId`, `departmentId`, `page`, `pageSize` | [`leaves.list.response.json`](api-examples/leaves.list.response.json), including `counts` per status for the tabs |
| `GET /leaves/{id}` | — | [`leaves.get.response.json`](api-examples/leaves.get.response.json) |
| `POST /leaves` | [`leaves.create.request.json`](api-examples/leaves.create.request.json) | The created leave |
| `PATCH /leaves/{id}` | Same body as create | The updated leave. **Pending leave only**: otherwise 409 `LEAVE_NOT_EDITABLE`. |
| `PATCH /leaves/{id}/status` | [`leaves.status.request.json`](api-examples/leaves.status.request.json) `{ "status": "approved" \| "rejected" \| "cancelled" }` | The updated leave |
| `POST /leaves/preview` | [`leaves.preview.request.json`](api-examples/leaves.preview.request.json) (`leaveId` is set when editing) | [`leaves.preview.response.json`](api-examples/leaves.preview.response.json) `{ days, balanceBefore, balanceAfter }` |
| `GET /leave-types` | — | [`leave-types.response.json`](api-examples/leave-types.response.json) |
| `GET /leave-calendar` | `month=YYYY-MM`, `employeeId` (*V2*) | [`leave-calendar.response.json`](api-examples/leave-calendar.response.json): company holidays (with `id`) and **that employee's** weekly offs (`weeklyOffDays` from the schedule on the 1st, and the exact `weekOffDates`, which also cover a mid-month schedule change), for the date picker. Without `employeeId`, no weekly offs. |

- **`status` on create:** an admin adding leave may create it directly as `approved` (the design default) or as `pending`. **(confirm)**
- **`canDecide` / `canChange`** on a leave tell the app which actions to show. The backend decides both.
- **Editing** is allowed only while a leave is `pending` (*V2*). Approved leave can still be cancelled; it can't be edited. There's no special correction path for approved or rejected leave yet.

### Working schedules (*V2*)

| Method & path | Request | Response |
|---|---|---|
| `GET /employees/{id}/schedules` | — | [`employees.schedules.response.json`](api-examples/employees.schedules.response.json): versions, newest first |
| `POST /employees/{id}/schedules` | [`employees.schedules.create.request.json`](api-examples/employees.schedules.create.request.json) | The new version. 409 `SCHEDULE_OVERLAP` if a version already starts that day. |

- The backend computes `expectedMinutes` (= end − start − `breakMinutes`) and closes the previous version the day before `effectiveFrom`.
- `weeklyOffDays` are ISO weekdays (1 = Monday … 7 = Sunday).
- `breakStart`/`breakEnd` are optional. When sent, they must lie inside the shift and add up to `breakMinutes`.
- Field errors for the `schedule` inside `POST /employees` are keyed `schedule.startTime`, `schedule.endTime`, `schedule.breakMinutes`, `schedule.breakStart` and `schedule.weeklyOffDays`. On `POST /employees/{id}/schedules` the same fields have no prefix, plus `effectiveFrom`.

### Overtime (*V2*)

| Method & path | Query | Response |
|---|---|---|
| `GET /employees/{id}/overtime` | `from`, `to` (dates, inclusive) | [`employees.overtime.response.json`](api-examples/employees.overtime.response.json) |

Everything is in minutes: `totalMinutes`, `months[]` (every month of the range up to today, oldest first), and `days[]` (dates with overtime only, newest first, never after today). *V2 profile:* `expectedMinutes` and `workedMinutes` give the working hours of the whole range, and of each month in `months[]`, counting days up to today (holiday and weekly-off work included in worked). `to` before `from` → 422 with `errors.to`. `dayBasisMinutes` is the expected length of one working day: for the total, under the current schedule; for each day, under that date's schedule. The app uses it to show "1 day 2 h 30 m". `scheduleChanged` is `true` when the schedule changed inside the range. The rules are in `DATABASE_V2.md` §3.

### Employee calendar (*V2*)

| Method & path | Query | Response |
|---|---|---|
| `GET /employees/{id}/calendar` | `month=YYYY-MM` | [`employees.calendar.response.json`](api-examples/employees.calendar.response.json): every day of the month and a `summary` |
| `GET /employees/{id}/calendar/{date}` | — | [`employees.calendar-day.response.json`](api-examples/employees.calendar-day.response.json): the day plus its change `history` (newest first; empty unless the caller has `audit.view`) |

Each day has these fields:
- `dayType`: `working`, `week_off` or `holiday`, plus `holidayName` on holidays;
- `schedule`: null on holidays and weekly offs;
- `attendance`: null on a holiday or weekly off with no work, and `id: null` for an absence;
- `leaves[]`: pending, approved and rejected requests touching the day;
- `overtimeMinutes`.

- `leaves[]` lists pending, approved and rejected requests; cancelled leave is left out.
- `summary`: attendance figures (`workingDays`, `present`, `absent`, `leaveDays`, worked, expected and overtime minutes, `holidayWorked`, `weekOffWorked`) count days **up to today**; `holidays` and `weekOffs` cover the whole month. The app labels the current month "so far", and shows planned leave instead for months to come.
- Months up to 12 ahead are requested (holidays, weekly offs and planned leave).

Edits from the calendar use the attendance and leave endpoints above.

### Company holidays (*V2*)

| Method & path | Request | Response |
|---|---|---|
| `GET /holidays` | Query: `year`, `search` | [`holidays.list.response.json`](api-examples/holidays.list.response.json) (plain list, by date) |
| `POST /holidays` | [`holidays.create.request.json`](api-examples/holidays.create.request.json) | The holiday ([`holidays.get.response.json`](api-examples/holidays.get.response.json)). A duplicate date returns `errors.date`. |
| `PATCH /holidays/{id}` | Same body as create | The updated holiday |
| `DELETE /holidays/{id}` | — | 204 |

Adding, moving or deleting a holiday recalculates attendance and leave days on the affected dates (`DATABASE_V2.md` §3.5).

### Users and permissions (*V2*)

There are **no roles**: each staff user has their own list of permissions (changed 2026-10-02 at the client's request). One permission, `permission.manage`, covers everything on this page, because anyone who can set permissions could grant themselves the rest.

| Method & path | Request | Response |
|---|---|---|
| `GET /permissions` | — | [`permissions.response.json`](api-examples/permissions.response.json): the catalogue, grouped by module, for the permission list |
| `GET /users` | Query: `search` (name or email), `page`, `pageSize` | [`users.list.response.json`](api-examples/users.list.response.json); each user carries `permissions` |
| `GET /users/{id}` | — | [`users.get.response.json`](api-examples/users.get.response.json) |
| `POST /users` | [`users.create.request.json`](api-examples/users.create.request.json) (`permissions` optional, usually empty) | The user. **(confirm)** The backend emails an invitation to set a password; the app never sends other users' passwords. Email taken → `errors.email`; employee already linked → `errors.employeeId`. |
| `PATCH /users/{id}` | `{ name, email, employeeId, isActive? }`. `employeeId: null` unlinks the employee; `isActive` is sent only to change it. | The user. Email taken → `errors.email`; employee already linked to another user → `errors.employeeId`. Deactivating yourself → 409 `CANNOT_CHANGE_OWN_ACCESS`; leaving nobody active with `permission.manage` → 409 `LAST_PERMISSION_MANAGER`. |
| `PUT /users/{id}/permissions` | [`users.permissions.request.json`](api-examples/users.permissions.request.json) (the full list) | The user. Unknown keys → 422. Removing `permission.manage` from yourself → 409 `CANNOT_CHANGE_OWN_ACCESS`; leaving nobody active with it → 409 `LAST_PERMISSION_MANAGER`. |

### Audit (*V2*)

| Method & path | Query | Response |
|---|---|---|
| `GET /audit-logs` | `employeeId`, `date`, `from`, `to`, `entityType`, `page`, `pageSize` | [`audit-logs.response.json`](api-examples/audit-logs.response.json) |

### Required permissions (*V2*)

Every endpoint except login checks the caller's permission and returns 403 with `PERMISSION_DENIED` if it's missing.

| Endpoints | Permission |
|---|---|
| `GET /dashboard/*` | `dashboard.view` |
| `GET /departments*` | any signed-in user |
| `GET /employees`, `GET /employees/{id}`, `GET /employees/{id}/schedules`, `GET /employees/{id}/leave-balance`, `GET /employees/{id}/leaves`, `GET /employees/next-ec-number` | `employee.view` |
| `POST /employees` | `employee.create` |
| `PATCH /employees/{id}` | `employee.edit` |
| `PATCH /employees/{id}/status` | `employee.deactivate` |
| `POST /employees/{id}/schedules` | `schedule.edit` |
| `GET /attendance*`, `GET /employees/{id}/attendance-log` | `attendance.view` |
| `POST /attendance/punch-in`, `/punch-out`, `/punch-in/bulk` | `attendance.punch` |
| `POST /attendance`, `PATCH /attendance/{id}` | `attendance.correct` |
| `GET /employees/{id}/overtime` | `overtime.view` |
| `GET /employees/{id}/calendar*` | `calendar.view` |
| `GET /leaves*`, `GET /leave-types`, `GET /leave-calendar` | `leave.view` |
| `POST /leaves`, `POST /leaves/preview` | `leave.create` (preview also with `leave.edit`) |
| `PATCH /leaves/{id}` | `leave.edit` (and the leave must be pending) |
| `PATCH /leaves/{id}/status` | `leave.approve` for `approved` / `rejected`; `leave.cancel` for `cancelled` |
| `GET /holidays` | `holiday.view` |
| `POST` / `PATCH` / `DELETE /holidays*` | `holiday.create` / `holiday.edit` / `holiday.delete` |
| `GET /permissions`, `GET` / `POST` / `PATCH /users*`, `PUT /users/{id}/permissions` | `permission.manage` |
| `GET /audit-logs` | `audit.view` |

---

## 3. Business rules the backend owns

The app does **not** compute any of these. It displays what the API returns.
The dev mock only imitates them with sample values.

1. **EC numbers:** they must be unique, and `next-ec-number` returns the next free one. A duplicate returns 409 or 422 with `errors.ecNumber`.
2. **Employee email:** must be unique. A duplicate returns `errors.email`.
3. **Attendance status and "late":** each employee has their own schedule (*V2*). Late means after their start time plus 15 minutes. Holidays and weekly offs are never absent. See `DATABASE_V2.md` §3.
4. **Worked, expected and overtime minutes, and `workedPercent`** (of the expected minutes): all come from the backend, including for open punches (`DATABASE_V2.md` §3.3).
5. **Who "Punch in all" covers:** active employees who have not punched in and are not on leave. **(confirm)**
6. **Leave days:** the employee's working days in the range, excluding their weekly offs and company holidays, with half days counted as 0.5. A holiday added later inside approved leave gives that day back to the balance.
7. **Balances:** quotas, carry-forward, and which types have a balance (`hasBalance`). The mock uses 12 / 8 / 15. **(confirm)**
8. **Leave validation:** overlaps with the employee's existing leave, insufficient balance, and end before start. These return field `errors` (`startDate`, `endDate`, `leaveTypeId`).
9. **Leave status transitions:** only `pending` → `approved`/`rejected`, and `pending`/`approved` → `cancelled`. Invalid transitions return 409. Edits are allowed only while pending (`LEAVE_NOT_EDITABLE`).
10. **Dashboard percentages and counts:** computed server-side for the requested date or month, among employees scheduled to work (see Dashboard above).
11. **Deactivation effects:** inactive employees are excluded from attendance and from new leave. **(confirm)**
12. **Permissions and lock-out protection:** `DATABASE_V2.md` §4.

---

## 4. Switching the app from mock to real API

- `env/dev.json` sets `"USE_MOCK_API": true`. Set it to `false` and point `API_BASE_URL` at the backend.
- A production build (`APP_ENV=prod`) refuses to start if `API_BASE_URL` is not `https://` or if `USE_MOCK_API` is `true`.
- On web, the portal must be served over HTTPS (secure context) for secure storage to work.
