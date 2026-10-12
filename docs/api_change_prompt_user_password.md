# API change: admin-set passwords for staff users

Paste everything below the line into a Claude Code session opened in
`D:\Clients\Keshav-Cloths\kc_admin_portal_backend`.

---

## Context

The Keshav Admin Portal (Flutter app in `../kc_admin_portal`) now lets an
admin set a password when adding a staff user in Access control, and set a
new one when editing a user. Those users must be able to sign in to the
portal with their email and that password, and only see and use what the
admin granted them.

This settles client question **T-06** ("how do new users get a password"):
the admin sets it. There is no invitation email.

What already exists in this backend (verify, don't rebuild):

- `src/lib/auth/password.ts`: Argon2id `hashPassword` / `verifyPassword`,
  `PASSWORD_MIN_LENGTH = 8`, `PASSWORD_MAX_LENGTH = 200`.
- `prisma/schema.prisma`: `User.passwordHash` (nullable, `password_hash`).
- `src/modules/auth/auth.service.ts`: `login` verifies `passwordHash` (with a
  dummy check when missing), rejects inactive users, and the user DTO from
  login and `GET /auth/me` carries the user's `permissions` keys.
- `src/lib/auth/authed.ts`: `authed({ permission })` route wrapper answering
  403 `PERMISSION_DENIED`.

What is missing: `POST /users` and `PATCH /users/{id}` don't accept a
password (`src/modules/users/user.validation.ts` says "No password: see
T-06"), so users created in the app have `passwordHash = null` and can never
sign in.

## Contract (what the app now sends)

`POST /users`:

```json
{
  "name": "Nisha Solanki",
  "email": "nisha.solanki@keshav.in",
  "password": "Nisha@2026",
  "employeeId": "25",
  "permissions": []
}
```

- `password` is **required**, at least 8 and at most 200 characters, not
  trimmed (spaces count).
- Too short / missing → 422 with `errors.password`, e.g.
  `{ "message": "Use at least 8 characters", "errors": { "password": ["Use at least 8 characters"] } }`.
  The app shows `errors.password` under the password field.

`PATCH /users/{id}`: `{ name, email, employeeId, isActive?, password? }`

- `password` is **optional**; sent only when the admin sets a new one. Absent
  (or `null`) keeps the current password. Same length rules and
  `errors.password`.

Responses are unchanged (`UserAccountDto`). **Never** return the password or
its hash in any response, log line or audit entry.

The app's copy of the contract is `../kc_admin_portal/docs/API_CONTRACT.md`
(Users table) and `../kc_admin_portal/docs/api-examples/users.create.request.json`
(now includes `password`). Update this repo's own contract docs and examples
to match.

## Tasks

1. **Validation** (`src/modules/users/user.validation.ts`): add a shared
   password schema (min `PASSWORD_MIN_LENGTH`, max `PASSWORD_MAX_LENGTH`, not
   trimmed, message "Use at least 8 characters" for too short). Required in
   `createUserBody`, optional/nullable in `updateUserBody`. Remove the "No
   password: see T-06" note.

2. **Create** (`user.service.ts` `create`): hash with `hashPassword` and store
   `passwordHash`. Hash before opening the transaction so Argon2 doesn't hold
   the DB transaction open.

3. **Update** (`user.service.ts` `update`): when `password` is present, hash
   and store it, and revoke the user's other active sessions (reuse
   `repo.revokeAllSessions`) so a reset password signs them out everywhere.
   If the admin resets their **own** password, keep the current session
   (`auth.sessionId`) alive.

4. **Audit**: record a password change as a line like
   `{ field: "password", label: "Password", before: null, after: "Changed" }`
   (on create: "Set"). Never put the value or hash in the audit log.

5. **Login and `/auth/me`**: confirm a user created through `POST /users`
   can sign in with the password set for them, that deactivated users are
   still refused, and that both responses carry exactly that user's own
   permission keys. No shape change is expected.

6. **Permission enforcement**: audit every route under `src/app/api/**`. Every
   endpoint except `POST /auth/login` must require a signed-in user, and every
   non-auth endpoint must check the permission listed in the contract's
   *Required permissions* table (403 with code `PERMISSION_DENIED`). List any
   route that is missing a check or checks the wrong key, and fix it. The app
   relies on this: it only hides pages and buttons, the backend is the real
   guard.

7. **Seed / existing users**: users already in the database with
   `passwordHash = null` stay unable to sign in until an admin sets a
   password via `PATCH /users/{id}`. Make sure `prisma/seed.ts` still creates
   a first admin with a password (from an env var, never hard-coded for
   production).

8. **Docs**: update this repo's API docs / OpenAPI export
   (`npm run openapi:export`) and mark T-06 as decided (2026-10-10: admin sets
   the password; stored as an Argon2id hash).

## Tests

Add or update tests in `tests/` (unit, api, integration as fits the existing
layout):

- `POST /users` without `password` → 422 `errors.password`; with a 7-char
  password → 422; with a valid one → 201/200 and `passwordHash` is an Argon2
  hash, not the plain text.
- The created user can `POST /auth/login` with that password; the response's
  `user.permissions` equals what was granted; a wrong password → 401.
- `PATCH /users/{id}` with `password` changes it (old fails, new works) and
  revokes that user's existing sessions; without `password` the old one keeps
  working.
- A user with only `leave.view` gets 403 `PERMISSION_DENIED` on, for example,
  `GET /employees` and `GET /users`, and 200 on `GET /leaves`.
- No response body or audit entry contains the password or hash.

Run `npm run typecheck` and `npm test` and make sure both pass.
