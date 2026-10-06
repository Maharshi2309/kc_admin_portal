# Attendance Portal: multi-organization architecture (proposal, 2026-10-06)

**Status: approved 2026-10-06** (§11 answers: per-user permissions per
organization, several organizations per login, **free sign-up for anyone**,
Keshav's leave rule as a preset, import valid rows and report the rest).
Built so far on branch `dynamic`: steps 1–6 (organization foundation,
sign-up and onboarding, organization settings, leave policy per
organization, mobile/desktop mode, Excel employee import). Step 4 was scoped to one paid type with a balance plus one
unpaid type per organization; several paid types can follow on the same
design. Still open: product name and app ids (step 7).

This turns the Keshav Admin Portal into a reusable Attendance Portal that any
organization can sign up for, on Android, iOS and the web. It builds on what
already exists and replaces nothing that works.

- **Current state:** [`API_CONTRACT.md`](API_CONTRACT.md),
  [`DATABASE_V2.md`](DATABASE_V2.md), [`V3_CHANGES.md`](V3_CHANGES.md).
- **The decisions only you can make** are in §11. Everything else is a
  recommendation you can accept as is.

---

## 0. What the current app already gives us

| Area | Today | What it means for this change |
|---|---|---|
| Layers | UI → Riverpod → repository → `ApiClient` (dio) → REST. No API calls in widgets. | Organization context fits in the session and the API client; screens barely change. |
| Auth | Bearer token in secure storage; `/auth/login`, `/auth/me` return the user and their `permissions`. | Add the organization to the session. Endpoints never take an organization id (§3). |
| Permissions | Per-user permission keys (roles dropped 2026-10-02); `permission.manage` guards Access control; lock-out protection. | Permissions move from the user to the user's **membership** in an organization. Same keys, same screens. |
| Responsive UI | One mapping `ScreenSize.fromWidth` (600 / 1024 / 1440), used by `context.screenSize` and `ResponsiveBuilder`. Tables fall back to cards by available width. | The Mobile/Desktop mode can be applied in that one place (§5). |
| Business rules | All computed by the backend (one `computeDay`, one Casual-balance function). The app only displays them. | Rules become organization settings read by those same functions. |
| Hardcoded Keshav items | Departments and positions as a fixed `JobRole` enum (15 files); Casual/Unpaid wording in leave screens; accrual start; KC logo and "Keshav Admin" name; `com.example.*` app ids; sample data in the dev mock. | Listed with their replacements in §6 and §9. |
| Employee import | None. No file picker or Excel packages. | New feature (§4). |

No new architecture is needed. Multi-tenancy is mostly a **backend**
concern (data isolation), plus a session and settings on the app side.

---

## A. Multi-organization model

```
user (a login: email + password)
  └─ membership (user × organization): active flag, permissions, linked employee
       └─ organization: name, logo, timezone, settings
            ├─ employees ─ schedules, attendance, leave, overtime, calendar
            ├─ departments, positions
            ├─ leave types (with their accrual policy), holidays
            └─ import jobs, audit log
```

- **User** = a person's login, global across the platform (email unique
  platform-wide). It holds no organization data.
- **Organization** = one company's isolated workspace.
- **Membership** = "this user may use that organization, with these
  permissions". Today's per-user permissions and the "Linked employee" move
  here unchanged. The "no roles" decision stays (see §11, question 1).
- **Employee** belongs to exactly one organization. Employees still don't sign
  in. Employee and user stay separate, as in V3.
- **Creating an organization:** whoever signs up and creates it becomes its
  **owner**, with every permission. Lock-out protection already prevents
  removing the last `permission.manage` holder.
- **Joining an organization:** **only by invitation** from someone with
  `permission.manage` (the existing "add user" flow, which already assumes an
  emailed invitation). No join codes: a guessable code would let strangers in.
- **Several organizations per login:** the schema allows it, at no extra
  cost. If a user has more than one, the app asks which one after sign-in and
  offers "Switch organization" in the account menu. See §11, question 2.

---

## B. Database changes

### New tables

| Table | Key columns | Notes |
|---|---|---|
| `organizations` | `id` UUID, `name`, `logo_url` NULL, `timezone` (IANA, e.g. `Asia/Kolkata`), `status` (`active`/`suspended`/`deleted`), `created_at` | `timezone` replaces today's implicit "company time", so "today", lateness and month boundaries are per organization. |
| `organization_settings` | `organization_id` PK/FK, `late_grace_minutes` (default 15), `default_weekly_off_days` (default `[7]`), default schedule (`start_time`, `end_time`, `break_start`, `break_minutes`), `leave_accrual_start_month` | One row per organization. Columns can be added later without restructuring. |
| `memberships` | `id`, `user_id`, `organization_id`, `is_owner`, `is_active`, `employee_id` NULL (linked employee), `last_sign_in_at`; UNIQUE (`user_id`, `organization_id`) and (`organization_id`, `employee_id`) | Replaces `users.employee_id` and `users.is_active`. |
| `membership_permissions` | PK (`membership_id`, `permission_key`) | Replaces `user_permissions`. The permission catalogue stays global (it's code). |
| `departments`, `positions` | `id`, `organization_id`, `name`, `is_active`, `sort`; UNIQUE (`organization_id`, lower(`name`)) | Replace the fixed codes from V3. Deactivate instead of delete when in use. |
| `employee_imports` | `id`, `organization_id`, `created_by`, `status`, `file_name`, `row_count`, `mapping` JSON, `duplicate_strategy`, counts, `expires_at` | One import session (§D). |
| `employee_import_rows` | `import_id`, `row_number`, `data` JSON (raw cells), `status` (`valid`/`warning`/`error`/`imported`/`updated`/`skipped`/`failed`), `messages` JSON, `employee_id` NULL | The parsed rows. **The uploaded file itself is not kept.** |

### Changed tables

- **`organization_id` NOT NULL** (FK, indexed) on `employees`,
  `employee_work_schedules`, `attendance_records`, `leaves`, `leave_types`,
  `leave_balance_adjustments`, `company_holidays`, `audit_logs`.
  - Child rows (attendance, schedules, leave) carry it too, although
    they could reach it through the employee. That keeps every query and
    database rule simple and indexable.
- **Uniqueness becomes per organization:** `employees` (`organization_id`,
  `ec_number`), `company_holidays` (`organization_id`, `date`), `leave_types`
  (`organization_id`, `code`).
- **`employees.department_id` / `position_id`** → the new tables, replacing
  V3's fixed codes.
- **`leave_types`** gets its policy (generalizing V3 §3.7, no payroll):
  `name`, `is_paid`, `accrual` (`none` | `monthly`), `days_per_month`,
  `carry_forward_cap` NULL (= unlimited), `allow_future_months` (bool),
  `is_active`, `sort`.
  - The balance function stays the same; the numbers come from the type
    instead of constants.
  - Keshav's Casual is `monthly`, 1 day, no cap, no future months. Unpaid is
    `none`, unpaid.
- **`users`** keeps login data only (`email`, password hash, `name`,
  `email_verified_at`, `deleted_at`).

### Unchanged

The calculation rules (`computeDay`, overtime, day conversion, the
Casual-balance rules, audit) keep working as they are. They just read the
organization's settings and run inside its context.

---

## C. Authentication and organization context

- **Sign-up:** `POST /auth/register` `{ name, email, password }`, followed by
  email verification. Then the app shows "Create your organization" (§8).
- **Sign-in:** the response carries the user, their memberships, and an
  **active organization**:
  - one membership: that one;
  - several: the last used;
  - none: onboarding.
- **The token identifies the user and the active membership.** The server
  issues and signs it. **The app never sends an organization id**, and no
  endpoint accepts one.
  - Switching is `POST /auth/switch-organization` `{ organizationId }`. The
    server checks the membership and returns a new token.
- **Every request:** token → membership → `is_active` on both the
  membership and the organization → permissions. The result is cached
  briefly, and dropped when permissions or memberships change.
- **The user object** (login, `/auth/me`, switch) adds
  `organization: { id, name, logoUrl, timezone }` and
  `memberships: [{ organizationId, name, logoUrl }]`. `permissions` are the
  active membership's. Adding fields to the existing user object keeps
  today's shape working (as built in step 1; see `API_CONTRACT.md` § Auth).
- **App side:** the session model gains `organization` and `memberships`.
  - Switching organization or signing out **rebuilds the app's provider
    container**. No cached list from organization A can then show while
    organization B loads. This also makes the existing "clear messages on
    sign-out" fix part of a general rule.
  - The token key in secure storage loses its `keshav_admin` prefix, with a
    one-time migration so nobody is signed out.

---

## D. Employee import

**Parsing happens on the backend.** The server reads the file, validates it
against the real database (existing EC numbers, departments), supports `.xls`
as well as `.xlsx`, and keeps one set of rules. The app only picks, uploads
and shows results.

### Flow and endpoints

| Step | App | API |
|---|---|---|
| Template | "Download template" | `GET /employee-imports/template` → `.xlsx` with the headers, one example row and an instructions sheet listing the organization's departments and positions |
| 1. Upload | File picker (`.xlsx`, `.xls`), upload progress | `POST /employee-imports` (multipart) → `{ id, fileName, headers, sampleRows (first 5), rowCount, suggestedMapping }` |
| 2–4. Map columns | One row per Excel header → a portal field (or "Ignore"), pre-filled by name matching ("Employee Code" → EC number, "Designation" → Position) | — |
| 5–7. Validate and preview | Summary (total / valid / warnings / errors) and a list of problem rows, filterable and paged | `PUT /employee-imports/{id}` `{ mapping, duplicateStrategy, createMissing, defaults }` → `{ counts }`; `GET /employee-imports/{id}/rows?status=error&page=…` |
| 8. Confirm | "Import N employees" | `POST /employee-imports/{id}/confirm` → `202` with the status |
| 9. Result | Progress, then imported / updated / skipped / failed, and "Download failed rows" | `GET /employee-imports/{id}` (polled while `status=importing`); `GET /employee-imports/{id}/report` → `.xlsx` of failed rows with the reason in an extra column |

### Fields

These match the current employee model; email stays excluded.

| Portal field | Required | Validation |
|---|---|---|
| Employee name | yes | 2–100 characters |
| EC number | yes* | Organization's format; unique in the organization and in the file. *Blank → "assign the next EC number" if the admin ticks it. |
| Mobile | yes | Today's mobile validation |
| Department | yes | Must match an active department (case-insensitive), or be created if "Create missing departments and positions" is ticked |
| Position | yes | As department |
| Joining date | yes | A real date. Excel date cells and `dd/mm/yyyy`, `dd-mm-yyyy`, `yyyy-mm-dd` text; ambiguous values are errors, never guessed |
| Status | no | `active` (default) / `inactive` |
| Shift start, shift end, break minutes, weekly offs | no | Defaults come from the organization's default schedule. Times as `09:00` or `9:00 AM`; end after start; break shorter than the shift; weekly offs as day names (`Sun`, `Sat, Sun`). Becomes the employee's first schedule from the joining date, as in the current Add employee flow. |

### Validation (whole file, before anything is saved)

- **Errors** (the row won't be imported): missing required value, invalid
  date, time or format, unknown department or position (unless "create
  missing"), EC number already used **in this file**, an existing EC number
  under the **Skip** strategy, or a value too long.
- **Warnings** (imported, but flagged): an existing employee will be
  updated; the same name and mobile appear under another EC number (possible
  duplicate); a department or position will be created; a schedule
  default was used.
- **Limits:** up to **5,000 rows** and **5 MB** per file. A larger file is
  refused with a clear message. Both limits are easy to raise later.

### Duplicates

The identifier is the **EC number within the organization**. The admin
chooses one strategy per import:

| Strategy | Effect |
|---|---|
| **Skip** (default) | Existing EC numbers are not touched; those rows are listed as skipped. |
| **Update existing** | Only the **mapped, non-empty** cells overwrite existing values. The preview shows each change ("Department: Tailor → Production"). Schedules are never changed by an update; that stays a separate, dated action. |

"Import as new" isn't offered for an existing EC number, because EC numbers
must stay unique. A row with a **blank** EC number can be imported as new
with the next number assigned.

### Transaction safety and scale

- **Confirm re-validates** everything. Data may have changed since the
  preview.
- **Rows with errors are never imported.** Valid rows are written in
  batches of 200. Each batch runs in its own transaction, and each row (the
  employee plus its first schedule) is all-or-nothing.
  - A row that fails at write time (e.g. someone just added that EC number)
    is reported as failed, never half-written.
  - See §11, question 6 for the stricter all-or-nothing option.
- **Size:** under ~500 rows the import finishes within the confirm request.
  Above that, a background job runs and the app shows progress. Both use the
  same job record, so the app works the same way.
- **Housekeeping:** unconfirmed imports and their rows are deleted after
  24 hours. Completed ones are kept for 30 days for the report. One import
  at a time per organization.
- **Audit:** each import writes one audit entry plus one per created or
  updated employee.

### Mobile and desktop layouts

- **Mobile:** a step-by-step flow (Upload → Map → Review → Result) with one
  step per screen.
  - The mapping is a list of cards, each with a field dropdown.
  - Problem rows are cards ("Row 18 · EC number already exists"),
    filterable by Errors / Warnings.
  - The buttons stay at the bottom.
- **Desktop:** one wide page with a step indicator.
  - The mapping is a two-column table next to a sample preview.
  - Problem rows are a paged table with row number, EC number, name and
    message.
- **Shared:** both use the same providers and widgets, so the existing
  table-to-cards fallback does most of the work.
- **New packages:** `file_picker` (Android, iOS and web), and on mobile
  `share_plus` for the downloaded template and failed-rows report (on web,
  the browser downloads them).

---

## E. Mobile mode and Desktop mode

**Today:** layout follows the width automatically. **Added:** a preference
with three values, applied in the **one place** the app turns width into a
layout (`ScreenSize`). Screens don't change, and there's no second app.

| Mode | Navigation and layout | On a narrow screen | On a wide screen |
|---|---|---|---|
| **Automatic** (default; today's behaviour) | By width | Phone layout | Desktop layout |
| **Mobile** | Bottom navigation, compact header, cards instead of tables, single-column forms, compact charts, touch-size controls | Same as Automatic | Phone layout, with content centred at up to 720 px so cards don't stretch across a monitor |
| **Desktop** | Sidebar (or rail on tablets), desktop header, tables, multi-column layouts | Below 600 px there's no room for a sidebar and tables, so it **falls back** to the phone layout and the switch explains why. Rotating to landscape or widening the window applies Desktop. | Same as Automatic |

- **The switch** is on the Dashboard header (as requested) and in the
  account menu (reachable everywhere). It's a three-way control:
  Auto · Mobile · Desktop.
- **Remembered per device** with `shared_preferences` (new package). A phone
  and a laptop can use different modes. It survives restarts and isn't
  synced between devices.
- **Touch targets** keep following the device (finger or mouse), whatever
  the mode.
- **Tests:** the existing 15-size responsive matrix runs once per mode.

---

## F. Organization configuration (only what's needed now)

A new **Settings** section, protected by a new permission `settings.manage`.

| Setting | Replaces | Keshav's values after migration |
|---|---|---|
| Name, logo (PNG/JPG, ≤ 1 MB, checked server-side), timezone | "Keshav Clothing" text, the KC logo, implicit IST | Keshav Clothing, the KC logo, Asia/Kolkata |
| Departments, positions (add, rename, reorder, deactivate) | V3's fixed `JobRole` enum | Accountant, Graphic Designer, Tailor (both lists) |
| Leave types and policy (§B) | V3's fixed Casual/Unpaid rules | Casual: 1/month, unlimited carry, no future months, paid. Unpaid: no balance |
| Holidays | Already an admin feature; becomes per organization | Unchanged |
| Default schedule and weekly off | The app's starting values for a new employee (`ScheduleDraft.standard`) | 09:30–18:30, 1-hour break, Sunday off, as in the app today (still to be confirmed as Keshav's standard) |
| Late grace minutes | Hardcoded 15 | 15 |

**Not added now** (no requirement yet; the settings row can take them
later): overtime rules beyond today's (all time over the schedule, and all
work on holidays and weekly offs), attendance rounding, payroll.

**What changes in the app:**
- `JobRole` becomes `departmentId`/`positionId` with names from the API.
  That touches the same 15 files V3 changed. Filters and forms load the
  organization's lists.
- The leave screens show **leave type names** instead of the word
  "Casual". Balances become "per paid, accruing type", which is just Casual
  for Keshav.
- Times and dates follow the organization's timezone, as sent by the
  server.

---

## G. API changes

**New**

| Endpoint | Purpose |
|---|---|
| `POST /auth/register`, `POST /auth/verify-email`, `POST /auth/forgot-password`, `POST /auth/reset-password` | Public sign-up |
| `POST /auth/switch-organization` | Change the active organization (new token) |
| `DELETE /auth/account` | Delete my account (store requirement, §I) |
| `POST /organizations` | Create an organization (the caller becomes owner) |
| `GET`/`PATCH /organization`, `POST /organization/logo` | The **active** organization's profile (no id in the path) |
| `GET`/`PATCH /organization/settings` | Defaults and rules (§F) |
| `GET`/`POST`/`PATCH /departments`, `/positions` | Organization lists (deactivate via `PATCH`) |
| `GET`/`POST`/`PATCH /leave-types` | Leave types with policy (`GET` exists today) |
| `/employee-imports…` | Import (§D) |
| `POST /invitations/{token}/accept` | Join an organization from an emailed invitation |

**Changed (same paths, now scoped to the active organization)**
- **Every existing endpoint** is scoped by the server; nothing in the
  request changes.
- **Employees:** `department`/`position` become `{ id, name }`; the
  `department`/`position` filters take ids.
- **`/auth/login`, `/auth/me`:** add `organization` and `memberships`.
- **`/users`:** now lists the organization's **members**. Adding one sends
  an invitation; an existing account just gets a membership.
- **Dashboard and leave balances:** unchanged shapes, with leave figures
  per type.

---

## H. Security: tenant isolation

1. **The context comes only from the token.** The server derives the
   organization from the authenticated membership. Ids sent by the client
   are never trusted, and there's no `organizationId` parameter to tamper
   with.
2. **Every query is scoped in the repository layer.** Backend repositories
   take the context as a required argument, so no query can be written
   without it. Lookups by id use `WHERE id = $1 AND organization_id = $ctx`.
3. **The database enforces it as well (defence in depth).** PostgreSQL
   row-level security on every tenant table, with
   `organization_id = current_setting('app.organization_id')`, set per
   transaction. A forgotten filter returns nothing instead of another
   company's data.
4. **Other organizations' ids return `404`, not `403`,** so nobody can probe
   which ids exist. Ids are UUIDs.
5. **Permissions** are checked after the organization context, per
   membership, as today (`DATABASE_V2.md` §4.2). Owner and lock-out
   protection apply per organization.
6. **Writes check every referenced id** (department, position, leave type,
   employee) belongs to the same organization. RLS blocks it anyway.
7. **Files:**
   - extension and **content** (file signature) are checked;
   - size limits apply; the client's file name is never trusted;
   - files are parsed in memory with formulas and macros ignored, then
     dropped;
   - logos are re-encoded server-side.
8. **Public endpoints:** rate limits on sign-up, sign-in and password reset;
   email verification before creating an organization.
9. **Automated isolation tests (backend):** for every endpoint, a user of
   organization A asking for organization B's ids gets `404` and sees B's
   data nowhere.
   - The app's dev mock gets two sample organizations and the same tests,
     so the app is built and tested against isolation from day one.
10. **Audit entries and imports** are per organization too.

---

## I. App Store and Play Store readiness

| Item | Change |
|---|---|
| App ids | `com.example.kc_admin_portal` / `com.example.kcAdminPortal` → your real ids, e.g. `com.<yourdomain>.attendance`. Needs your developer accounts; **can't be changed after the first release.** |
| Name and icons | Product name, icons and splash screen from §11, question 4. Organization logos show inside the app only. |
| Account deletion | **Required by Apple and Google** for apps with sign-up: in-app "Delete account", plus a web page for Google Play. An owner must transfer ownership or delete the organization first. |
| Privacy policy and terms | Public URLs, linked from sign-up and the stores. Store privacy forms ("data safety", "privacy nutrition labels") declare employee data. |
| Organization deletion and export | Owner-only, with confirmation and a 30-day grace period. Expected for a public product. |
| App Review | A demo organization and account for the reviewers. |
| Release builds | The dev mock, and the sample sign-in hint shown with it, already can't be enabled in production builds (`Env` refuses it), and must stay so. Production API URL over HTTPS; build flavours for dev/staging/production. |
| Payments | Not in the requirements. **If organizations will pay**, Apple and Google rules on in-app subscriptions apply and change the design (§11, question 3). |

---

## J. Migration of Keshav's data

Run in this order, rehearsed first on a copy of production with row counts
compared before and after:

1. Create the new tables (all additive).
2. Insert the **Keshav Clothing** organization with its settings (timezone
   Asia/Kolkata, late grace 15, default schedule, leave accrual start month,
   logo).
3. Add `organization_id` to every tenant table as nullable, **backfill
   Keshav's id**, then make it NOT NULL and switch the unique indexes to
   per-organization.
4. Create departments and positions (Accountant, Graphic Designer, Tailor)
   and convert `employees.department`/`position` codes to ids.
5. Set up Keshav's leave types:
   - Casual gets its policy: monthly, 1 day, unlimited carry, no future
     months.
   - Unpaid stays as it is.
   - Existing leave, splits and adjustments keep their ids, so balances
     stay identical. Verify every employee's balance matches before and
     after.
6. Turn each user into a **membership** of Keshav: copy `is_active`,
   `employee_id`, and `user_permissions` → `membership_permissions`. The
   current `permission.manage` holders become owners.
7. Enable row-level security, after checking every query passes with it.
8. **Compatibility:**
   - Tokens issued before the change resolve to the user's only
     membership, so nobody is signed out.
   - The current app version keeps working, since every response it reads
     is unchanged except department/position. Release the new app before
     changing those shapes, or send both shapes for one release.

Attendance, overtime and calendars are calculated from attendance records
and schedules, and holidays keep their dates. With every row kept and
tagged, all of it comes out the same.

---

## 9. Hardcoded items and where they go

| Item | Becomes |
|---|---|
| "Keshav Admin Portal" / "Keshav Admin" (app name, page titles, store labels) | Product name constant (§11, question 4); page titles add the organization name |
| KC logo and "Keshav Clothing" in the sidebar, sign-in page and splash | Product mark on sign-in and splash; **organization logo and name** in the sidebar and header once signed in |
| `JobRole` (Accountant, Graphic Designer, Tailor) | Organization departments and positions |
| Casual/Unpaid wording, accrual start January 2026 | Organization leave types and settings |
| `name@keshav.in` hint in the user form, `keshav_admin.*` storage key | Generic |
| Keshav employees, holidays and users in the dev mock | Stay as **sample organization 1**, plus a second sample organization for isolation tests |

---

## 10. Delivery plan (one feature at a time, each approved before the next)

| # | Feature | Depends on |
|---|---|---|
| 1 | **Tenant foundation:** session with organization and memberships, organization switch, provider reset, two-organization dev mock with isolation tests, contract and DB docs | — |
| 2 | **Sign-up and onboarding:** register, verify email, create organization, invitations, empty states (no employees: "Add employee" / "Import employees") | 1 |
| 3 | **Organization settings:** profile, logo, timezone; departments and positions (replacing `JobRole`); default schedule; late grace | 1 |
| 4 | **Leave types per organization** (generalizing Casual) | 3 |
| 5 | **Mobile / Desktop mode** | — (can move earlier) |
| 6 | **Employee import** (template → upload → map → validate → preview → confirm → result → report) | 3 |
| 7 | **Branding and store readiness:** product name, icons, app ids, account and organization deletion, legal links, release flavours | 2 |
| 8 | **Docs and testing pass:** migration rehearsal checklist, isolation tests | all |

The backend team can build in the same order; each step's API is in the
contract before the app uses it.

---

## 11. Decisions needed from you

1. **Roles.** The new requirements mention "roles". On 2026-10-02 you chose
   **per-user permissions without roles**.
   - **Recommendation:** keep per-user permissions, now per organization.
     Optionally add "copy permissions from another user" to speed up setup.
   - Real roles would mean bringing back role management, which you asked
     to remove.
2. **More than one organization per login?**
   - **Recommendation: yes.** The schema supports it at no extra cost; the
     app shows a switcher only when a user has more than one.
   - **No** means one organization per login, forever.
3. **Who may create organizations, and is it paid?** Free sign-up for
   anyone, invitation only, or paid plans? Paid plans bring Apple/Google
   in-app subscription rules and a billing design, which isn't in these
   requirements.
4. **Product name** for the stores and the web: keep "Keshav Admin Portal",
   or a neutral name such as "Attendance Portal" (Keshav then becomes one
   organization in it)?
   - **Recommendation:** a neutral product name. Only the display name and
     icons change; the project isn't renamed.
5. **Leave policy for new organizations:**
   - **Recommendation:** offer Keshav's policy as a one-tap preset
     ("1 paid day per month, carried forward, no advance") during
     onboarding, editable later.
   - The alternative is starting with Unpaid only until the admin sets
     something up.
6. **Import with some invalid rows:**
   - **Recommendation:** import the valid rows and report the rest.
   - The alternative is all-or-nothing: nothing is imported unless every
     row is valid.
7. **App ids and accounts:** the reverse-domain id (e.g.
   `com.keshavclothing.attendance`) and whose Apple/Google developer
   accounts will publish the app.

## 12. Conflicts with earlier requirements

| Earlier decision | This proposal |
|---|---|
| V3: Department and Position are exactly Accountant, Graphic Designer, Tailor | Those become **Keshav's** values; other organizations have their own. |
| V3: 1 Casual day per month, carry forward, no future months | Becomes **Keshav's leave policy**; other organizations configure theirs (§F). |
| V2: per-user permissions, no roles | Kept, now per organization (question 1). |
| V3: Linked Employee on the user | Moves to the membership; same meaning. |
| V3: employees have no email | Unchanged. Invitations and sign-up use **user** emails only. |
| Branding: KC logo "in every possible place" (2026-10-02) | The KC logo stays as Keshav's **organization** logo. The product's own mark depends on question 4. |
