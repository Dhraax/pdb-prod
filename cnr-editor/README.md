# Control Panel

Reusable internal web application for administering connected systems. The existing
`cnr-editor/` directory, Compose project, environment variables, cookies and
database table names remain stable deployment identifiers; they do not limit
the panel to one feature or installation. The visible title and subtitle are
configured with `CONTROL_PANEL_TITLE` and `CONTROL_PANEL_SUBTITLE`.

## Current slice

- opaque server-side sessions with Argon2 password hashes and CSRF protection;
- optional per-account TOTP authentication with encrypted seeds, one-use
  recovery codes, replay protection, and administrator recovery;
- progressive per-account login cooldowns after repeated password failures;
- descriptive `admin`, `technical` (Equipo técnico), `dungeon_master`, `editor`,
  and `collaborator` roles with explicit per-user capabilities;
- granular view/edit permissions for recipes, users, accounts, and individual
  character-sheet sections, managed by administrators on every user profile;
- permission-controlled account and character browsing/editing with masked CD
  keys, optional full read-only character UUIDs, read-only normalized classes,
  live tradeskills, and immutable revision snapshots;
- controlled account CD-key recapture: the game captures a denied candidate,
  the panel exposes only a masked hint, and a user with the administrator-granted
  `activate_cd_keys` permission must confirm it before ownership changes;
- authenticated recipe list and detail endpoints;
- transactional full-recipe updates with optimistic concurrency and revision
  snapshots;
- administrator-only unified audit history for recipe, account, character, and
  system-user changes, with immutable before-and-after snapshots;
- a versioned, server-validated property catalogue that presents localized
  labels while preserving the exact numeric values consumed by NWScript;
- React screens for login, recipe browsing/editing, account and character
  management, and system-user administration.

The recipe form exposes property types, damage types, races, alignments,
amounts, save DCs and other constant-backed fields as guided selectors. It also
shows the generated numeric tuple as a diagnostic preview. The backend rejects
unknown property types and numeric combinations before a recipe is written.

Catalogue writes are disabled by default. The local `cnr-editor/.env` file
controls the gate through `CNR_EDITOR_WRITES_ENABLED=true|false`. Enable it
only after the in-game generic consumer has passed its runtime validation.

## Runtime

Only Docker with Compose is required. Python and Node run exclusively inside
the build/runtime containers; do not install or replace either runtime in WSL.

Database credentials are deliberately not versioned. For a fresh checkout,
copy `config/mysql.env.example` to `config/mysql.env`, replace every placeholder,
and keep the resulting file local. `linux_run_server-dev.sh` stages it as
`server/config/mysql.env`; `cnr-editor/compose.yml` reads that staged file so the
panel and the development MySQL service use the same connection values. Never
commit either real credential file.

The panel's Compose project joins the development stack's existing
`server_default` network and uses its running MySQL service. It does not define,
replace or start MySQL or the NWN server.

Create the ignored local configuration once:

```bash
cp cnr-editor/.env.example cnr-editor/.env
```

Set `CNR_EDITOR_WRITES_ENABLED=false` for read-only mode or `true` to permit
authorized recipe saves. Then launch the panel from the repository root:

```bash
./scripts/run_cnr_editor.sh
```

The launcher reads `cnr-editor/.env` explicitly and force-recreates the panel
containers, so changing the write flag and relaunching applies the new mode.
It validates the local setting and dependencies without printing database
credentials.

The web application is available at `http://localhost:8088`. The backend runs
Alembic migrations before serving requests.

TOTP enrollment requires `CNR_EDITOR_MFA_ENCRYPTION_KEY` in the ignored
`config/mysql.env` file. The API already receives that file as its secret
environment source. Generate a Fernet key without writing it to the terminal
history, store it beside the database credentials, and preserve it in the same
private backup policy. Do not add the key to `cnr-editor/.env` or
`cnr-editor/remote.env`, which hold non-secret deployment controls. The panel
continues to accept password-only accounts when the key is absent, but it
refuses MFA enrollment and fails closed for accounts that already require MFA.

The current plain-HTTP development endpoint is not an acceptable production
transport for passwords, session cookies, or MFA codes. Put the panel behind
HTTPS and set `CNR_EDITOR_COOKIE_SECURE=true` before exposing it outside the
trusted development network.

Create the first administrator interactively after the services are healthy:

```bash
docker compose --env-file cnr-editor/.env -f cnr-editor/compose.yml run --rm api control-panel-bootstrap-admin
```

Stopping this stack does not stop MySQL or delete the server database volume:

```bash
docker compose --env-file cnr-editor/.env -f cnr-editor/compose.yml down
```

## Authorization contract

Roles are descriptive presets, not authorization shortcuts. Access is granted
per user through explicit permissions for viewing and editing recipes, panel
users, game accounts, and each character-sheet section. Recipe writes also
require the target profession in the user's editable-profession scope.

Backend dependencies enforce every permission and omit unauthorized character
sections from responses. Frontend route and section visibility mirrors that
policy but is not the security boundary. Only administrators can change system
permissions; a user with `edit_users` may maintain ordinary profile fields and
profession scopes, but cannot create or modify administrator profiles. The API
preserves at least one active administrator with both user-view and user-edit
permissions.

The profession tabs are generated from `cnr_profession` in stable numeric
order. Sastrería is profession 7 and remains visible even while its station has
no authored recipes.

## Authentication security

Password failures are tracked by a hash of the normalized account name; the
database does not store the submitted name in the throttle table. Five failures
within the configured fifteen-minute window trigger a 30-second cooldown.
Further failures increase it to 60 seconds, five minutes, and then fifteen
minutes. A successful complete login clears the record. Responses do not reveal
whether the account exists.

An account with MFA enabled does not receive a normal session after its password
is accepted. It receives an HttpOnly, five-minute challenge cookie instead. The
challenge permits five failed codes before it is destroyed. TOTP verification
accepts the current 30-second step plus one adjacent step for clock drift and
records the accepted step so the same code cannot be replayed. Recovery codes
are stored only as SHA-256 hashes and are consumed once.

Users enable or disable MFA from **Account security**. Enrollment returns a QR
code and reveals ten recovery codes only after the first TOTP code succeeds.
Disabling MFA requires the current password and either a current TOTP or an
unused recovery code, then revokes every session. An administrator may reset MFA
for another user from system-user management; this also revokes every session
and writes an audit revision. Administrators cannot use that recovery endpoint
on themselves.

Per-IP throttling is intentionally not implemented yet. The API must first have
an explicit trusted-proxy configuration; accepting `X-Forwarded-For` from an
untrusted client would let an attacker choose the address used by the limiter.
Add IP limits only after the HTTPS reverse proxy and its trust boundary are
defined.
