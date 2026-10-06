# Keshav Admin Portal: V3 changes (2026-10-05)

What changed for the backend in V3, in one place. The details live in
[`API_CONTRACT.md`](API_CONTRACT.md) and [`DATABASE_V2.md`](DATABASE_V2.md);
this page lists every change and where to read about it. Example payloads
are in [`api-examples/`](api-examples/), and the app's contract tests parse
every one of them.

> **Superseded in part (2026-10-06):** with organizations
> ([`ARCHITECTURE_MULTI_ORG.md`](ARCHITECTURE_MULTI_ORG.md)), departments and
> positions are each organization's own `{ id, name }` items, and the leave
> rule below becomes Keshav Clothing's policy. See `API_CONTRACT.md`
> § Organization settings, departments and positions.

## 1. API changes

### Removed

| What | Notes | Contract |
|---|---|---|
| `email` on employees | Gone from requests, responses, search and validation. Login emails on **users** stay. | § Employees |
| `GET /departments`, `GET /designations` | Replaced by one fixed list of codes (since 2026-10-06: per organization again, `GET /departments`, `GET /positions`). | § Organization settings, departments and positions |
| Sick and Earned leave types | Only `casual` and `unpaid` remain. | § Leave |
| Per-type `quota` balances | Replaced by one calculated Casual balance. | § Employees, § Leave |
| `balanceBefore` / `balanceAfter` on the preview | Replaced by `paidDays`, `unpaidDays` and `availableCasual`. | § Leave |
| `usedPercent`, `takenDays`, `remainingDays` in the dashboard's `leaveUsage` | There's no yearly quota to take a percentage of. | § Dashboard |

### Changed

| What | Now | Contract |
|---|---|---|
| Employee `department`, `position` | Codes `accountant`, `graphic_designer`, `tailor` (since 2026-10-06: `{ id, name }` items of the organization). | § Organization settings, departments and positions |
| `GET /employees/{id}/leave-balance` | One object `{ asOf, accrued, used, pending, remaining, unpaidTaken }`. | § Employees |
| `GET /employees/{id}/leaves` | Each item adds `isPaid` and `balanceAfter`. | § Employees |
| Leave records | Add `isPaid`, `balanceAfter`, `unpaidPartId`. | § Leave |
| `POST /leaves`, `PATCH /leaves/{id}` | Optional `splitExcessAsUnpaid`. Casual beyond the balance → 422 `INSUFFICIENT_LEAVE_BALANCE` unless it is set. | § Leave |
| `POST /leaves/preview` | `{ days, paidDays, unpaidDays, availableCasual }`. | § Leave |
| `GET /leave-types` | Adds `isPaid`. | § Leave |
| Dashboard `leaveUsage` | `casualRemainingDays`, `casualTakenDays`, `unpaidTakenDays`, and approved / pending / rejected requests this month. | § Dashboard |

### Added

| What | Contract |
|---|---|
| `overtimeMinutesThisYear` on employees (list and detail; `null` without `overtime.view`) | § Employees |
| `lateMinutes` on attendance records (the app writes "Late by 38 Minutes"; `note` holds no durations) | § Attendance |
| `GET /leave-balances`: active employees' balances with totals for the filters (`leave.view`) | § Leave |
| Error code `INSUFFICIENT_LEAVE_BALANCE` (422) | § Errors |

**Durations:** the API always sends whole **minutes**. The app formats them
("3 Hours 53 Minutes", or "3h 53m" where space is tight), so no API sends
formatted durations.

## 2. Database changes

| Change | Where |
|---|---|
| Drop `employees.email` | §2.0 |
| `employees.department` / `position` codes replace the department and designation tables | §2.0 |
| `leave_types.is_paid`; only `casual` and `unpaid` | §2.7 |
| `leaves.unpaid_part_of` (links the two parts of a split leave) | §2.7 |
| New `leave_balance_adjustments` (opening balances and corrections) | §2.7 |
| Company setting `leave_accrual_start_month` | §2.7 |
| **No stored balance**: one function calculates it from leave records | §3.7 |
| `users.employee_id` kept as an optional, informational link | §2.4 |

Migration order: [`DATABASE_V2.md`](DATABASE_V2.md) §6, steps 7–9, after the V2 steps.

## 3. The leave rules (one backend function, `DATABASE_V2.md` §3.7)

- **Earned:** 1 Casual day per month, from the later of the policy start month and the joining month, plus adjustments. Unused days carry forward, with no cap and no year-end reset.
- **Taken:** approved and pending Casual leave counts; pending leave reserves its days.
- **No future months:** for every month M, Casual days dated up to M must not exceed the days earned by M. Booking ahead is fine once that month's days cover it.
- **Over the balance:** refused (422), or, with `splitExcessAsUnpaid`, the earliest days stay Casual and the rest become a linked Unpaid leave, in one transaction.
- **Figures:** `remaining = accrued − used − pending`. Unpaid leave never adds to or uses the Casual balance.

## 4. Business rules and where they are checked

| # | Rule | Enforced by | App tests |
|---|---|---|---|
| 1 | No employee email | API and DB (§2.0) | `employee_screens_test` (no email field), `docs_consistency_test` |
| 2–3 | Department and position: Accountant, Graphic Designer, Tailor | Keshav's own lists (2026-10-06) | `employee_screens_test`, `api_contract_test` |
| 4 | Employee list shows this year's overtime, not the joining date | API `overtimeMinutesThisYear` | `overtime_this_year_test` |
| 5 | 233 minutes shows as "3 Hours 53 Minutes" | App (`DurationFormat`) | `duration_format_test` |
| 6 | Only Casual and Unpaid leave | API `/leave-types` | `leave_screens_test`, `api_contract_test` |
| 7 | 1 Casual day earned per month | Backend §3.7 | `leave_accrual_test` |
| 8 | Unused Casual leave carries forward | Backend §3.7 | `leave_accrual_test` |
| 9 | No using a future month's leave | Backend §3.7 | `leave_accrual_test`, `leave_mock_test` |
| 10 | All earned leave can be used | Backend §3.7 | `leave_accrual_test` (3 of 3 allowed) |
| 11 | Leave beyond the balance becomes Unpaid | Backend (422 or split) | `leave_mock_test`, `leave_screens_test` |
| 12 | Remaining leave visible on the Leave page | `GET /leave-balances` | `leave_screens_test` (Balances tab) |
| 13 | Balance calculated, never stored | Backend §3.7 | `leave_mock_test` (balance follows each change) |
| 14 | Linked Employee explained and kept | API § Users and employees, DB §2.4 | `access_control_screen_test`, `v2_models_contract_test` |

The app tests run against the dev mock (`USE_MOCK_API=true`), which copies
these rules so the app can be built before the backend exists. The backend
is the authority: the app never calculates balances or decides leave rules.

## 5. Still to confirm with the client

- **Casual leave start month** (`leave_accrual_start_month`; the mock uses January 2026) and **opening balances** for staff who took leave before it.
- **Existing data mapping:** old departments and designations to the three codes, and existing Sick and Earned leave to Casual or Unpaid.
- **Inactive employees:** whether a partly inactive month still earns its day, and whether inactive employees should appear on the Balances list (currently left out).
- **"Taken this year"** on the dashboard currently includes leave booked for later in the year.

Earlier open items (password invitations, break length, punch auditing) are
in `DATABASE_V2.md` §7.
