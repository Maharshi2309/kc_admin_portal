# Keshav Admin Portal — database & backend rules, V2

Scope: per-employee working schedules, overtime, company holidays, work on
holidays and weekly offs, the employee calendar, pending-only leave edits,
staff users and their permissions, and the audit log.

This is the specification the Flutter app is built against. It extends the
existing schema; nothing existing is removed. Types are written for
PostgreSQL; adapt them to your ORM. The API shapes are in
[`API_CONTRACT.md`](API_CONTRACT.md), with examples in
[`api-examples/`](api-examples/).

Decisions approved on 2026-09-30 are stated as rules. Anything still open is
marked **(confirm)**.

---

## 1. Conventions

| Topic | Rule |
|---|---|
| Company time zone | One setting, `COMPANY_TIMEZONE=Asia/Kolkata`. "Today", day boundaries and the date of a punch are decided in this zone. |
| Instants | `timestamptz`, stored in UTC. The API sends them with the company offset (`+05:30`). |
| Calendar dates | `DATE` (attendance date, holiday date, leave dates, schedule effective dates). |
| Times of day | `TIME` (e.g. shift start), wall-clock time in the company zone. The API uses `"HH:mm"`. |
| Durations | **Whole minutes (`INTEGER`) everywhere.** Never store fractional hours. Worked minutes are rounded **down** to the minute. |
| Overnight shifts | Not supported yet: a schedule's `end_time` must be later than its `start_time`. |
| Deletes | Employees, leave and attendance are never deleted. Holidays are soft-deleted (`deleted_at`) so audit entries keep their subject. |

---

## 2. Tables

### 2.0 `employees` (changed 2026-10-05)

| Change | Notes |
|---|---|
| **Drop `email`** (and its unique index) | Employees have no email. Logins are staff **users** with their own `users.email`, which stays. Nothing else references `employees.email`. |
| **`department`, `position`** replace `department_id`, `designation_id` | Each is an enum or `VARCHAR` with a CHECK in (`accountant`, `graphic_designer`, `tailor`). They are independent of each other. Drop the `departments` and `designations` tables after migrating. |

### 2.1 `employee_work_schedules` (new)

A schedule is **versioned**: a change adds a new row from its effective date,
so past days keep the schedule they were worked under.

| Column | Type | Notes |
|---|---|---|
| `id` | PK | |
| `employee_id` | FK → employees | |
| `effective_from` | DATE NOT NULL | |
| `effective_to` | DATE NULL | Last day of this version; NULL = current. Set automatically when a newer version is added. |
| `start_time` | TIME NOT NULL | |
| `end_time` | TIME NOT NULL | CHECK `end_time > start_time` |
| `break_minutes` | INTEGER NOT NULL DEFAULT 0 | CHECK `>= 0` |
| `break_start` / `break_end` | TIME NULL | Optional window. If set: both set, inside the shift, and `break_end − break_start = break_minutes`. |
| `weekly_off_days` | SMALLINT[] NOT NULL | ISO weekdays, 1 = Monday … 7 = Sunday. May be empty. |
| `expected_minutes` | INTEGER, generated | `end − start − break_minutes`; CHECK `> 0`. |
| `created_by` | FK → users | |
| `created_at` | timestamptz | |

Constraints and indexes:
- `UNIQUE (employee_id, effective_from)`.
- The versions of one employee must not overlap. Use an exclusion constraint on `daterange(effective_from, effective_to, '[]')`, or check it in the service.
- Index `(employee_id, effective_from DESC)`.
- **The schedule for a date** is the row where `effective_from <= date` and (`effective_to` is NULL or `>= date`).
- **Rule:** a new version may start today or later. A start date in the past needs `schedule.edit` and recalculates attendance from that date (§3.4).

### 2.2 `company_holidays` (new)

| Column | Type | Notes |
|---|---|---|
| `id` | PK | |
| `date` | DATE NOT NULL | Unique among rows where `deleted_at IS NULL` |
| `name` | VARCHAR(100) NOT NULL | e.g. "Gandhi Jayanti" |
| `description` | TEXT NULL | |
| `created_by`, `created_at`, `updated_at` | | |
| `deleted_at` | timestamptz NULL | Soft delete |

Holidays apply to every employee. Optional or per-location holidays are not
part of this version.

### 2.3 `attendance_records` (extended)

New columns. These are **snapshots** written by the calculation function
(§3), never computed by clients:

| Column | Type | Notes |
|---|---|---|
| `day_kind` | ENUM `working`, `holiday_worked`, `week_off_worked` | From the calendar on that date |
| `schedule_id` | FK → employee_work_schedules NULL | The version used; NULL on holidays and weekly offs |
| `expected_minutes` | INTEGER NOT NULL DEFAULT 0 | |
| `worked_minutes` | INTEGER NULL | NULL while a punch is open (the API computes the live value) |
| `overtime_minutes` | INTEGER NOT NULL DEFAULT 0 | |

Existing columns (`punch_in`, `punch_out`, `status`, `note`, `corrected_by`,
`corrected_at`, `reason`, `remarks`) stay. Uniqueness stays
`(employee_id, date)`.

### 2.4 Users and permissions

There are **no roles**: each staff user has their own permissions (changed 2026-10-02 at the client's request).

**`permissions`** (new) is seeded from the backend code (§4); the UI can't create permissions.

| Column | Type | Notes |
|---|---|---|
| `key` | PK VARCHAR | e.g. `employee.edit` |
| `module` | VARCHAR | e.g. `employee` |
| `action` | VARCHAR | e.g. `edit` |
| `label` | VARCHAR | e.g. "Edit employees" |
| `sort` | INTEGER | Display order |

**`user_permissions`** (new) has the primary key `(user_id, permission_key)`: what each user may do.

**`users`** (extended). These are staff login accounts; employees don't sign in. A user stores no employee data (EC number, department, position and so on); those live only on `employees`.

| Column | Type | Notes |
|---|---|---|
| `employee_id` | FK → employees NULL, UNIQUE | Optional, informational link to the employee record of the same person (API_CONTRACT § Users and employees). Nothing else depends on it. Keep it `ON DELETE SET NULL`, although employees are deactivated rather than deleted. |
| `is_active` | BOOLEAN DEFAULT true | Inactive users can't sign in. |
| `last_sign_in_at` | timestamptz NULL | |

### 2.5 `audit_logs` (new, append-only)

| Column | Type | Notes |
|---|---|---|
| `id` | PK (BIGSERIAL) | |
| `actor_user_id` | FK → users | |
| `action` | VARCHAR | e.g. `attendance.correct` (list in §5) |
| `entity_type`, `entity_id` | VARCHAR | e.g. `attendance`, `a-7-20260928` |
| `employee_id` | FK → employees NULL | |
| `affected_date` | DATE NULL | |
| `summary` | VARCHAR | Display text, e.g. "Corrected punch in" |
| `changes` | JSONB | `[{field, label, before, after}]`, values formatted for display |
| `reason`, `remarks` | TEXT NULL | |
| `created_at` | timestamptz | |

Indexes: `(employee_id, affected_date)`, `(entity_type, entity_id)`, `(created_at DESC)`.
The application's database user has INSERT and SELECT only on this table.

### 2.6 Relationships

```
employees 1─* employee_work_schedules
employees 1─* attendance_records *─0..1 employee_work_schedules
employees 1─* leaves *─1 leave_types
leaves 0..1─0..1 leaves (unpaid_part_of)
employees 1─* leave_balance_adjustments
users *─* permissions (user_permissions)
users 0..1─0..1 employees
audit_logs *─1 users (actor), *─0..1 employees
company_holidays (stand-alone; joined by date)
```

### 2.7 Leave types and balance (2026-10-05)

| Change | Notes |
|---|---|
| **`leave_types`** keeps only `casual` (`is_paid = true`, `has_balance = true`) and `unpaid` (`is_paid = false`, `has_balance = false`) | Add `is_paid BOOLEAN NOT NULL`. Retire `sick` and `earned` (step 9 of §6). Drop any per-type quota column: the balance is not a quota. |
| **`leaves.unpaid_part_of`** `UUID NULL` → `leaves.id` | Set on the Unpaid part of a split leave, pointing to its Casual part. The API exposes the reverse as `unpaidPartId`. |
| **`leave_balance_adjustments`** (new) | `id`, `employee_id` → employees, `days NUMERIC(5,1)` (positive or negative, in 0.5 steps), `effective_month DATE` (1st of a month), `reason TEXT NOT NULL`, `created_by` → users, `created_at`. For opening balances and corrections; counts as accrued from `effective_month`. Audited. |
| **Company setting `leave_accrual_start_month`** | The first month that earns Casual leave (the mock uses January 2026). **(confirm)** |

There is **no stored balance column**: §3.7 calculates it from these rows.

---

## 3. Calculation rules (one function, used everywhere)

All numbers come from one backend function, `computeDay(employeeId, date)`,
used by punches, corrections, the calendar, overtime, attendance lists and
the dashboard. Clients only display the result.

### 3.1 Day type (for each employee and date)

1. A company holiday exists on the date → `holiday`. Holidays win over weekly offs.
2. Otherwise, the date's ISO weekday is in the schedule's `weekly_off_days` → `week_off`.
3. Otherwise → `working`.

### 3.2 Expected minutes

| Situation | Expected |
|---|---|
| `holiday` or `week_off` | 0 |
| Working day, approved **full-day** leave | 0 |
| Working day, approved **half-day** leave | `floor(schedule.expected_minutes / 2)` |
| Working day | `schedule.expected_minutes` |

### 3.3 Worked and overtime minutes (after punch-out)

1. `stay = floor((punch_out − punch_in) in minutes)`.
2. Break deduction, only on days with a schedule, meaning working days:
   - If the schedule has a break window: deduct `break_minutes` only when the stay covers the whole window (`punch_in <= break_start` and `punch_out >= break_end`).
   - If there's no window: deduct `break_minutes` only when `stay > break_minutes`.
   - Holidays and weekly offs have no schedule, so there's no deduction.
3. `worked = max(0, stay − deduction)`.
4. Overtime:
   - On a working day: `max(0, worked − expected)`. A shortfall is **not** overtime, and one day's shortfall never reduces another day's overtime.
   - On `holiday` or `week_off`: all of `worked` is overtime, and the record's `day_kind` is `holiday_worked` or `week_off_worked`.
5. There's no overtime approval step and no minimum threshold.

Worked example (schedule 09:00–17:30, 60-minute break from 13:00 to 14:00, expected 450):
- **Punches 08:58–19:00:** the stay is 602 minutes and covers the break, so 60 is deducted. Worked is 542, overtime 92.
- **A holiday, punches 10:00–15:00:** 300 minutes worked. With no schedule there's no break, so all 300 minutes are overtime.

### 3.4 Status and "late"

- **Late:** `punch_in > start_time + 15 minutes` (grace period approved 2026-09-30) on a working day. The note gives the minutes late counted from `start_time` (a 10:08 punch against a 09:30 start is "38 min late").
- **Absent:** a working day, not on approved leave, no punch, and the day has ended or it's past `start_time + grace` today.
- **Pending leave** doesn't excuse absence: the day is Absent, and the calendar shows the pending request as a marker.
- **Holidays and weekly offs** are never Absent and never count as missing attendance or working days.

- **Worked share** (`workedPercent`, for the progress bar): `min(100, worked × 100 / expected)`; null when nothing is expected (holidays, weekly offs, full-day leave).

### 3.5 When to recalculate

Recalculate the stored snapshots for these dates, in the same transaction as the change:

| Change | Recalculate |
|---|---|
| Punch in/out, correction, added record | That record |
| New schedule version from date D | The employee's records from D |
| Holiday added, edited (date moved) or deleted | Every employee's records on the old and new dates |
| Leave approved, cancelled or edited | The employee's records in the leave range |

Also:
- **Holiday added inside approved leave:** that day stops counting as leave, and the balance gets it back.
- **Holiday deleted where work was recorded:** that work becomes a normal working day (`day_kind = working`).

### 3.6 Overtime report and day conversion

`GET /employees/{id}/overtime?from&to` returns:
- `totalMinutes`, `months[]` and `days[]` (each day with its own `dayBasisMinutes`);
- `dayBasisMinutes` for the total, which is the **current** schedule's `expected_minutes`;
- `scheduleChanged: true` if a different schedule version applied anywhere in the range.

The app shows minutes as days using the basis. For example, with a 450-minute basis, 600 minutes is 1 day 150 minutes, shown as "1 day 2 h 30 m".

### 3.7 Casual leave balance (approved 2026-10-05)

One backend function, `casualBalance(employeeId, asOf)`, used by
`/employees/{id}/leave-balance`, the preview, create, update and status
changes. Nothing is stored.

- **Earned** `accrued(M)` up to and including month M = 1 × the months from the **start month** to M, plus `leave_balance_adjustments` with `effective_month ≤ M`. The start month is the later of `leave_accrual_start_month` and the joining month (the joining month counts in full, whatever the day).
- **No accrual while inactive:** months in which the employee is inactive for the whole month don't count. **(confirm the partial-month rule)**
- **No cap and no year-end reset:** unused days carry forward.
- **Leave days** are counted as in rule 6 of the API contract (working days only, half days 0.5).
- **Which leave counts:** Casual leave that is `approved` or `pending`. Rejected and cancelled leave gives its days back.
- **No future months:** for **every** month M, the Casual days **dated** up to the end of M must not exceed `accrued(M)`. It only needs checking for months that have Casual leave. Booking ahead is fine once that month's days cover it: in March, 3 days for June (6 earned by June) are allowed.
  - Example: 1 day per month from January, nothing used. In March 3 days are allowed, 4 are refused. In January 2 days are refused (the second would be February's).
- **Insufficient balance** on create or update (pending leave already holds its days, so approving it can't go over): 422 `INSUFFICIENT_LEAVE_BALANCE`, unless `splitExcessAsUnpaid` is set on create/update. With the flag, the **longest run from the first day** that fits stays Casual and the remaining (latest) days become an Unpaid leave linked by `unpaid_part_of`.
- **Response figures:** `accrued` = `accrued(current month)`; `used` = approved Casual days; `pending` = pending Casual days; `remaining = accrued − used − pending` (it can be lower than what's free for a later month, since later months add days); `unpaidTaken` = approved Unpaid days; `balanceAfter` on a leave = `accrued(month of its end date)` − Casual days dated up to its end date.
- **Lists and totals:** `GET /leave-balances` and the dashboard's `casualRemainingDays` run the same function per active employee. With few employees this is cheap; if it gets slow, cache per employee and clear the cache on any change to that employee's leave, holidays, schedule or adjustments.
- **Concurrency:** check and save in one transaction, locking the employee's leave rows (`SELECT … FOR UPDATE`), so two requests can't spend the same day.

---

## 4. Permissions and authorization

### 4.1 Permission seed

| Module | Keys |
|---|---|
| Dashboard | `dashboard.view` |
| Employees | `employee.view`, `employee.create`, `employee.edit`, `employee.deactivate` |
| Working schedules | `schedule.edit` (viewing needs `employee.view`) |
| Attendance | `attendance.view`, `attendance.punch` (in, out, all), `attendance.correct` (correct, add, holiday and weekly-off work) |
| Overtime | `overtime.view` |
| Leave | `leave.view`, `leave.create`, `leave.edit` (pending only), `leave.cancel`, `leave.approve` (approve and reject) |
| Employee calendar | `calendar.view`; edits made from the calendar use the permission of what's changed |
| Holidays | `holiday.view`, `holiday.create`, `holiday.edit`, `holiday.delete` |
| Users & permissions | `permission.manage`: the Access control page — list, add, edit and deactivate users, and set each user's permissions (`GET /permissions`, `/users*`). Anyone who can set permissions could grant themselves the rest, so this is one permission. |
| Audit | `audit.view` |

The exact list is in [`api-examples/permissions.response.json`](api-examples/permissions.response.json). The app's contract tests fail if the two drift apart.

### 4.2 Request check (every protected endpoint)

1. Authenticate the bearer token → 401 if invalid.
2. Load the user. If the user is inactive → 401 (session ends).
3. Load the user's permission keys. They may be cached per request, or briefly across requests; clear the cache when the user's permissions change.
4. If the endpoint's required permission is missing → **403** with `{ "code": "PERMISSION_DENIED", "message": "You do not have permission to …" }`.
5. Status rules come after permissions. For example, `PATCH /leaves/{id}` on a leave that isn't pending → **409** `{ "code": "LEAVE_NOT_EDITABLE", … }`.

The per-endpoint permissions are listed in `API_CONTRACT.md` §2.

### 4.3 Lock-out protection

- There must always be at least one active user with `permission.manage`. A change that would leave none → 409 `LAST_PERMISSION_MANAGER`.
- Users can't remove `permission.manage` from themselves or deactivate themselves → 409 `CANNOT_CHANGE_OWN_ACCESS`.

---

## 5. Audit

The service layer writes one `audit_logs` row **in the same transaction** as
each of these changes:

| Action | When |
|---|---|
| `attendance.create` / `attendance.correct` | Added or corrected record, including holiday and weekly-off work |
| `leave.create` / `leave.update` / `leave.status` | Leave added, pending leave edited, status changed |
| `schedule.create` | New schedule version |
| `holiday.create` / `holiday.update` / `holiday.delete` | |
| `employee.create` / `employee.update` / `employee.status` | |
| `user.create` / `user.update` / `user.permissions.update` | |

Punches (`attendance.punch`) aren't audited individually; the record itself
holds who punched and when. **(confirm)**

---

## 6. Migration plan

1. **Schema:** create the new tables and columns (all additive).
2. **Seed:** insert the permissions from §4.1 and give every existing user all of them; admins then narrow each user's access.
3. **Schedules:** for each employee, add one version from their `joining_date`, copied from today's global shift. Set its break window and weekly offs (default `[7]`). **(confirm the current break length)**
4. **Holidays:** move any existing holiday data (the source of `/leave-calendar`) into `company_holidays`.
5. **Snapshots:** run `computeDay` for all existing attendance records, in batches.
6. **Deploy the backend first.** The old app keeps working; the new fields are optional for it. Then release the app, which needs `permissions` in `/auth/me` and `/auth/login`.
7. **Employee email (2026-10-05):** drop `employees.email` after deploying the backend that no longer reads it. No data moves: user logins keep their own email.
8. **Department and position (2026-10-05):** add the two columns and fill them from today's department and designation using a mapping **the client provides (confirm)**. Employees without a mapping are listed for an admin to set. Then drop `department_id`, `designation_id`, `departments` and `designations`.
9. **Leave types (2026-10-05):** add `leave_types.is_paid`, `leaves.unpaid_part_of`, `leave_balance_adjustments` and the `leave_accrual_start_month` setting. Move existing Sick and Earned leave to Casual or Unpaid using a mapping **the client provides (confirm)**, then retire those types. Existing Casual leave dated before the start month needs an opening adjustment so balances don't go negative **(confirm the opening balances)**.

---

## 7. Still to confirm

- **Password setup for new staff users:** the app never sends passwords for other users. Assumed: `POST /users` emails an invitation link where the user sets their password. **(confirm)**
- **Break length of the current global shift,** for migration step 3. **(confirm)**
- **Casual leave start month** (`leave_accrual_start_month`), opening balances, and the mapping of existing Sick/Earned leave (§2.7, §6 step 9). **(confirm)**
- **Inactive employees on the Balances list:** left out (they earn nothing while inactive). **(confirm)**
- **Inactive months:** whether a partly inactive month still earns its Casual day (§3.7). **(confirm)**
- **Punch auditing:** whether punches need audit rows (§5). **(confirm)**
