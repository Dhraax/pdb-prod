# Account CD-Key Reset

This document is the canonical security, runtime, database, and production-port
contract for changing the public CD key assigned to an existing game account.
The operation is a controlled recapture, not a text-field edit.

## Security invariant

No panel user can type or submit a CD key. A user explicitly granted both
`view_accounts` and `activate_cd_keys` by an administrator can only open a
24-hour recapture window. The game server captures the
first different public CD key actually presented with a known character UUID,
denies that connection, and exposes only a masked hint in the panel. A second
authorized action with the dedicated `activate_cd_keys` permission is required
to confirm the captured candidate.

The account's active key remains unchanged until confirmation. Opening a reset,
capturing a candidate, or allowing the request to expire never grants game
access.

An administrator who also holds `activate_cd_keys` may instead promote a key
already present in that account's access history. This is an explicit recovery
operation for a previously observed installation, not a replacement for the
candidate-recapture proof. It refuses active global bans and keys owned by
another account, requires a confirmation dialog, clears stale recapture state,
and writes a masked `cdkey_primary` identity revision. The operator must
verify the player through a trusted external channel because an attempted key
in history is not proof of ownership.

## State model

Migration `0011_account_cdkey_reset`, after
`0010_character_rebuild_cleanup`, creates
`pwdb_account_cdkey_reset` with one row per account:

| Column | Contract |
|--------|----------|
| `account_id` | Primary key and cascading foreign key to `pwdb_account` |
| `candidate_cd_key` | First presented candidate; nullable and unique |
| `requested_by` / `requested_at` | Panel actor and reset start time |
| `expires_at` | End of the fixed 24-hour capture window |
| `candidate_captured_at` | Game-server capture time |
| `confirmed_by` / `confirmed_at` | Panel actor and final confirmation time |

The API derives these states without exposing either the active or candidate
key in full:

```text
none -> awaiting_candidate -> awaiting_confirmation -> confirmed
                         `-> expired
```

The first candidate wins. Later mismatched connections cannot overwrite it.
The panel operator must cancel and deliberately start a new window to discard a
wrong candidate. A candidate already owned by another `pwdb_account` is not
captured and cannot be confirmed.

After confirmation, the backend assigns the candidate to
`pwdb_account.cd_key`, clears `candidate_cd_key`, and retains only confirmation
metadata. `pwdb_identity_revision` records `cdkey_request`, `cdkey_cancel`, and
`cdkey_confirm` actions using masked response snapshots. Raw keys are never
copied to the API response or revision JSON.

## Runtime sequence

1. A user with the administrator-granted `activate_cd_keys` permission opens
   the target account in the control panel and selects `Iniciar recaptura`.
2. The player connects using an existing character BIC and the intended new
   installation/CD key.
3. `PWDB_DB_ResolveCharacterId` resolves the immutable character UUID first and
   detects that the presented key differs from the account owner.
4. If an unexpired request exists, no candidate has been stored, and the key is
   not owned by another account, the game writes that presented key as the
   candidate and its capture timestamp.
5. The player is still booted immediately. Candidate capture does not change
   ownership, account status, character status, login timestamps, or the
   character container.
6. The operator refreshes the panel, verifies the coordinated attempt and
   masked candidate, and selects `Confirmar candidata`.
7. A separate confirmation dialogue explains the ownership change. On final
   confirmation, the backend locks the account and reset row, rechecks expiry
   and uniqueness, changes the active account key, clears the raw candidate,
   and writes the masked audit revision in the same transaction.
8. The old key stops resolving the account. The new key still requires a
   registered character UUID; changing the account key does not bypass the
   character identity check.
9. On each character's next successful login, PWDB validates UUID and active
   account key before writing the validated key into that character's legacy
   container variable `CDKEY`. This happens before the old transparent
   security check in `wrap_on_clnt_ent.nss`.

The legacy container check runs when the UUID is absent from PWDB. A mismatch
imports the BIC under the stored legacy key, records the presented key as a
rejected observation and denies the session; it never registers ownership under
the rejected key. The resulting account is then available in the panel. An
operator with `activate_cd_keys` can open a recapture window and ask the player
to retry, at which point the normal known-UUID path captures the candidate for
confirmation. If the legacy account already had an open window, the importing
attempt captures it immediately.

The container does not override an already registered UUID, so a confirmed
account-key change can pass database ownership validation and replace the stale
per-character value. This distinction prevents an unimported legacy BIC from
being claimed with a foreign key without making administrative recovery
impossible.

The last step is deliberately repeated for every successful login. An account
can own several characters, each with a separate `CONTENEDOR_VARIABLES` item.
Synchronizing only the first character would leave the others frozen by the
legacy check.

## Resource manifest

| Resource | Contract |
|----------|----------|
| `cnr-editor/backend/migrations/versions/0011_account_cdkey_reset.py` | Reset state table, unique candidate and actor foreign keys |
| `cnr-editor/backend/migrations/versions/0012_dungeon_master_role.py` | Dungeon Master role constraint; follows migration `0011` |
| `cnr-editor/backend/migrations/versions/0013_system_user_permissions.py` | Persistent administrator-assigned system permissions; backfills existing technical-team and Dungeon Master users |
| `cnr-editor/backend/migrations/versions/0014_integral_permissions.py` | Granular view/edit catalogue and compatibility presets; makes `view_accounts` a dependency of key activation |
| `cnr-editor/backend/app/models.py` | `AccountCdKeyReset` persistence mapping |
| `cnr-editor/backend/app/schemas.py` | Masked reset response state; no raw key field |
| `cnr-editor/backend/app/dependencies.py` | Read-only identity access and the dedicated `activate_cd_keys` authorization gate |
| `cnr-editor/backend/app/routers/identity.py` | Request, cancel and confirm endpoints with CSRF, permission checks, row locks and audit revisions |
| `cnr-editor/frontend/src/Accounts.tsx` | Reset state, actions and explicit confirmation dialogue |
| `cnr-editor/frontend/src/types.ts` | Frontend response contract |
| `src/pwdb/nss/pwdb_c_config.nss` | Reset table name |
| `src/pwdb/nss/pwdb_i_db.nss` | First-candidate capture during an otherwise denied UUID/key mismatch |
| `src/pwdb/nss/pwdb_i_user.nss` | Post-validation synchronization of the legacy per-character `CDKEY` value |
| `src/shared/nss/wrap_on_clnt_ent.nss` | Representative executable consumer; PWDB still runs before legacy security |

The control-panel routes are:

```text
POST   /api/admin/identity/accounts/{account_id}/cd-key-reset
DELETE /api/admin/identity/accounts/{account_id}/cd-key-reset
POST   /api/admin/identity/accounts/{account_id}/cd-key-reset/confirm
POST   /api/admin/identity/accounts/{account_id}/cd-keys/{cd_key}/primary
```

The three recapture writes require an authenticated session carrying the explicit
`activate_cd_keys` and `view_accounts` grants plus a valid CSRF token. A role
alone is insufficient. Promoting a historical key additionally requires the
exact `admin` role. Other account, character, catalogue, and user access is
controlled by its own explicit view or edit permission.

## Failure and abuse handling

| Condition | Result |
|-----------|--------|
| No active request | Mismatched character is booted; nothing is captured |
| Active request, first unused candidate | Candidate is stored; mismatched character is still booted |
| Another mismatch after capture | First candidate remains unchanged; connection is booted |
| Candidate belongs to another account | Candidate is not stored; connection is booted |
| Request expired | Candidate cannot be captured or confirmed |
| Confirmation loses a uniqueness race | Transaction rolls back with conflict |
| Account is blocked | Reset may be prepared, but blocked status continues to deny the new key |
| Old key after confirmation | UUID ownership check fails and the connection is booted |
| New key with an unrelated BIC UUID | UUID ownership check fails or resolves its own identity; the reset grants no UUID bypass |

Opening the window creates a bounded opportunity for someone possessing a
stolen BIC to become the first candidate. The operator must coordinate the
attempt in real time and confirm the player through an external trusted channel
before accepting it. The masked hint and timestamps support that verification;
they do not replace it.

If the player first creates a new character using the intended new key, normal
registration may create a separate account row for that key. The candidate is
then rejected as already owned. This workflow intentionally does not merge two
accounts: stop and resolve that identity conflict separately rather than
deleting or re-parenting records during a key reset.

## Production deployment

Deploy this slice in the following order:

1. Back up the production database and inspect its current Alembic head.
2. Apply `0011_account_cdkey_reset` after
   `0010_character_rebuild_cleanup`, followed by
   `0012_dungeon_master_role`, `0013_system_user_permissions`, and
   `0014_integral_permissions`.
3. Deploy the backend and frontend changes. Confirm authorized users can open,
   cancel, and expire a reset while all key values remain masked.
4. Merge the PWDB include changes and run the production repository's focused,
   non-writing compile against its `OnClientEnter` executable consumer.
5. Deploy the module through the production workflow.
6. Run the controlled acceptance test below before resetting a real account.

Do not deploy the game capture code before the table migration. A missing table
does not grant access—the mismatch still boots—but it produces SQL errors and
cannot capture a candidate. Do not copy the DEV module artifact into PROD.

## Acceptance test

Use a disposable account with at least two disposable characters and preserve
a database/server-vault backup.

1. Confirm the API and page show only masked active keys.
2. Confirm an ungranted user of every role cannot call a reset endpoint;
   confirm an administrator can grant and revoke `activate_cd_keys`, and that
   only a currently granted user can call the three reset endpoints.
3. Open a reset and verify its state is `awaiting_candidate` with an expiry 24
   hours after the request.
4. Connect a known character with a different unused key. Confirm immediate
   boot, unchanged account key, unchanged login timestamps, and one masked
   candidate in `awaiting_confirmation`.
5. Retry with another different key. Confirm the first candidate remains.
6. Cancel the reset. Confirm the candidate disappears and neither different key
   can log in.
7. Repeat capture, open the confirmation dialogue, cancel it, and confirm the
   active account key remains unchanged.
8. Confirm the candidate administratively. Confirm the raw candidate is cleared
   from `pwdb_account_cdkey_reset`, the account row owns the new key, and the
   revision JSON contains no full active or candidate key.
9. Log in with the first character and new key. Confirm PWDB succeeds and its
   container `CDKEY` is synchronized before legacy security executes.
10. Log in with the second character and confirm its separate container is also
    synchronized.
11. Confirm the old key and an unrelated UUID/new-key combination are still
    booted immediately.
12. Block the account and confirm the new key cannot bypass account status.

## DEV verification record

The changed PWDB includes were checked through the explicit `OnClientEnter`
consumer without writing bytecode or packaging the module:

```bash
./linux_build-dev.sh --check wrap_on_clnt_ent.nss
```

Result: one successful compilation, zero skipped, zero errors.

The frontend passed `npm run build`, including TypeScript compilation and a
production Vite build. Vite reported its existing advisory that the main
minified JavaScript chunk exceeds 500 kB. Python application, test, and
migration sources passed `python3 -m compileall`.

The host provides Python 3.10 while the backend explicitly requires Python
3.12 or newer, and it does not contain `pytest`. The focused backend unit suite
therefore could not execute in the host environment. `npm run lint` also
remains unavailable because the repository has ESLint 9 but no
`eslint.config.js`. These are test-infrastructure gaps, not successful checks.
The migration was not applied to a live database, and no panel container, NWN
server, module package, deployment, or in-game validation was run.

## Rollback

1. Remove or disable the panel reset actions.
2. Roll back the game capture and legacy-sync include changes through the
   production module workflow.
3. Downgrade `0014_integral_permissions`,
   `0013_system_user_permissions`, then
   `0012_dungeon_master_role`, before removing the reset table if an
   exact schema rollback is required.
4. Only then downgrade `0011_account_cdkey_reset`. The table is operational
   state and may otherwise remain safely.
5. Do not restore an old account key automatically during code rollback. Any key
   already confirmed is active identity data and requires its own reviewed reset
   or a database-backup recovery decision.
