# Account Access History And Pre-Vault CD-Key Enforcement

## Status And Boundary

This is the implemented DEV security layer for connection auditing, protected
account names, and persistent public CD-key bans. It complements the existing
character UUID ownership check; it does not change server-vault storage or the
disguise system.

The decisive enforcement point is `NWNX_ON_CLIENT_CONNECT_BEFORE`. NWNX Events
fires it with the presented community name, public CD key, IP address and DM
flag before `SendServerToPlayerCharList`. Skipping that event rejects the
connection, so the client does not receive the server-vault character list.

Sources and version:

- `src/shared/nss/nwnx_events.nss`, Client Connect Events contract;
- pinned `nwnxee/Plugins/Events/ClientEvents.cpp`, the
  `SendServerToPlayerCharList` hook;
- runtime baseline `nwnxee/unified:build8193.37` in the repository Compose
  configuration.

## Data Model

Migrations `0019_account_access_security` and `0020_dm_cd_key_whitelist` add
the access-control tables:

| Table | Purpose |
|-------|---------|
| `pwdb_account_name_history` | Stable set of community names observed after successful ownership validation for an account |
| `pwdb_account_cd_key_history` | Per-account public CD keys, first/last observation and attempted/verified counters |
| `pwdb_account_ip_history` | Per-account IP addresses, first/last observation and internal attempted/verified counters |
| `pwdb_cd_key_ban` | Global persistent ban state, timestamps and current administrative reason for each public CD key |
| `pwdb_dm_cd_key_whitelist` | Public CD keys explicitly authorized to connect through the DM client |
| `pwdb_dm_cd_key_whitelist_revision` | Immutable panel audit of whitelist additions and removals |

The history tables aggregate repeated observations by account and value. They
do not append one row per connection. This preserves useful history while
avoiding the duplicate-row growth exhibited by `knownservernames.2da`.

The migration seeds the current `pwdb_account.player_name` and canonical
`pwdb_account.cd_key` as the initial verified history. IP history starts empty
because PWDB did not previously persist a trustworthy IP observation.

Every panel ban or unban also writes a `pwdb_identity_revision` against the
account from which the action was initiated. The ban itself is global: the same
key is rejected regardless of the community name it presents.

## Connection Policy

`pwdb_ev_connect.nss` applies this order on every new connection:

1. Read the active global ban for the presented public CD key.
2. Reject an active global ban.
3. For a DM client, require the presented key to exist in
   `pwdb_dm_cd_key_whitelist`; deny the connection when the whitelist is empty,
   the key is absent, or the query fails. An authorized DM returns from the
   gate here.
4. For a player client, resolve the presented community name through
   `pwdb_account_name_history`.
5. When the name resolves to exactly one account, aggregate the attempted key
   and IP before deciding whether to admit it.
6. Reject a name associated with more than one PWDB account. Ambiguity must be
   resolved administratively instead of guessing which account owns the vault
   namespace.
7. Reject a blocked account.
8. Reject a protected name when the presented key is not the account's current
   key.
9. Allow the connection otherwise. After the selected character passes the
   existing UUID/CD-key check, record the name, key and IP as verified.

DM clients bypass the normal player-name ownership check because they do not
select a player server-vault BIC through that path, but they no longer bypass
CD-key authorization. The global ban is evaluated first and always overrides a
whitelist entry. `NWNX_ON_CLIENT_CONNECT_BEFORE` is still skipped on denial, so
an unauthorized DM password holder is disconnected before receiving the avatar
list.

SQL failures are fail-closed. If the access schema or database cannot be read,
the module denies the connection with a generic validation message rather than
exposing the character list without checking policy.

## Deliberate Exceptions And Remaining Gaps

An active, unconfirmed CD-key recapture window remains an explicit exception to
the protected-name key match. It allows the candidate key to reach the existing
character UUID proof, where it is still denied and captured for later
administrative confirmation. A global ban always wins over this exception.

An unknown community name is allowed so a genuinely new account can connect.
Therefore, a legacy server-vault folder that has never been represented in
PWDB and has no imported owner name is not protected by this layer yet. PROD
deployment must inventory that residual set and decide how to register or
quarantine it; inventing CD-key ownership for those folders is not safe.

After character selection, an unregistered UUID receives one additional
migration guard before PWDB trusts the presented key: a non-empty legacy
`CONTENEDOR_VARIABLES.CDKEY` must match it. On mismatch, PWDB imports the account
and UUID under the stored legacy key, records the presented key as rejected and
denies the session. The panel can then use the existing `activate_cd_keys`
recapture workflow; the operator opens a window and the next coordinated retry
captures the candidate. This protects previously played BICs that carry the
recent legacy safeguard even when their vault name has not yet been imported.
A BIC with no stored key remains indistinguishable from a genuinely new
character and is allowed to register; that residual case cannot be solved by
inventing ownership.

A panel write is hot for subsequent connection attempts because the event reads
MySQL on every connection. It does not retroactively disconnect a client that
is already at character selection or in the module. Account blocking also
becomes pre-vault for protected names, but it does not push-disconnect an
existing session. Character blocking and deletion still require the character
to be selected because the character identity does not exist at client-connect
time.

This layer does not repair the disguise system's community-name overrides and
does not change `server.vault.by-player-name`. Those remain separate urgent
work. The protected-name check limits reuse of names already bound by verified
PWDB access; it is not a substitute for removing presentation names from the
storage boundary.

The runtime dependency is NWNX Events. The Administration plugin and its
process-local native ban list are not required; the authoritative ban remains
in MySQL, which is why an unban can also take effect without a restart.

## Control Panel Contract

Only users whose panel role is exactly `admin` receive full public CD keys,
access histories or the ban endpoints. Permission-based account viewers keep
receiving the masked hint. This is enforced by the API independently of UI
visibility.

The account search includes historical public CD keys, historical IP addresses
and historical account names for administrators. An account detail exposes an
expandable access-history section. Selecting any observed key can create or
remove its global ban and optionally record an administrative reason. An
administrator who also holds `activate_cd_keys` can explicitly make an
unbanned historical key the account's primary key after a confirmation dialog.
The operation refuses keys currently assigned to another account, clears any
stale recapture state and records `cdkey_primary` in the identity audit.
The former primary key remains in history so the same controlled operation can
restore it. The IP table shown in the panel omits the internal verified counter;
that implementation detail is retained only to distinguish pre-vault
observations from successful character validation.

The address supplied by NWNX is the network peer visible to the NWN process.
Docker or host NAT can therefore produce a bridge or gateway address instead
of the public client address. The panel must not claim that such a value is a
public origin address; production acceptance must verify the actual Compose
network path before relying on IP history for attribution.

The separate **DM Administration** workspace is available only to panel users
whose role is exactly `admin` or `technical`. Both the UI and every API endpoint
enforce that role boundary. It displays complete public keys, accepts an
optional internal label, and supports explicit addition and removal. Each write
requires CSRF validation and creates a durable audit revision. A key with an
active global ban cannot be added; if a listed key is banned later, the global
ban still wins and the workspace reports that state.

## Deployment And Acceptance

Deploy this as one coordinated slice:

1. Take the normal database backup.
2. Apply Alembic migrations through `0020_dm_cd_key_whitelist`.
3. Deploy the updated panel backend and frontend.
4. Before deploying the new module, use **DM Administration** to add at least
   one known operator key. An empty whitelist intentionally denies every DM.
5. Build and deploy the module containing `pwdb_ev_connect` and the modified
   PWDB includes.
6. Restart the NWN module once so `OnModuleLoad` subscribes the new event.

After that initial module restart, ban, unban, whitelist-add and
whitelist-remove changes require no NWN or container restart.

Acceptance must cover:

- an administrator sees full current and historical keys and IPs;
- the current key is marked as primary, and an authorized administrator can
  promote an unbanned, unassigned historical key after explicit confirmation;
- a non-administrator with `view_accounts` never receives those raw fields;
- searching an old key or IP returns every matching account;
- a mismatched key presenting a protected account name is logged and rejected
  before character selection;
- banning that key from any matching account rejects it under a different name;
- unbanning restores subsequent connection attempts without a restart;
- a client already connected before the ban is not incorrectly claimed to have
  been disconnected;
- a valid owner key and an explicitly authorized CD-key recapture still follow
  their documented paths;
- a simulated MySQL failure denies the connection before the character list.
- an authorized DM key reaches avatar selection with the correct DM password;
- an absent DM key with the correct password is rejected before avatar
  selection;
- an active global ban rejects a key even while it remains in the DM whitelist;
- administrator and technical roles can manage the whitelist, while every
  other panel role receives HTTP 403.

No in-game or remote-host acceptance test has been performed by static
implementation and focused compilation alone.
