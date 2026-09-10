# Urgent Server-Vault And Disguise Security Assessment

## Status And Scope

**Status:** urgent. A DEV pre-vault audit and global CD-key ban layer is now
implemented but not deployed or validated in game. The disguise and
name-keyed-vault remediation remains open.

**Assessment date:** 2026-09-06.

This document records the security assessment of the legacy disguise system,
community-name handling, Sticky Player Names, `knownservernames.2da`, the
name-based server vault, and the point at which PDB currently enforces account
and character ownership.

The supplied `docker-compose-pdb.yml`, `settings.tml`, `run-server.sh`, and
`knownservernames.2da` are evidence from another server environment. They are
not proof of the configuration or image currently running on the remote host.
No remote runtime, container, database, or live server-vault validation was
performed during this assessment.

`pwdb_*` is explicitly **not identified as the cause of this vulnerability**.
PWDB is a newer identity layer. Its current placement in `OnClientEnter`
explains why it can deny or boot an unauthorized character only after the
engine has already selected and loaded a server-vault BIC.

This document contains no credentials, raw public CD keys, player names, IP
addresses, or BIC data.

The implemented containment slice is documented in
[`../database/account-access-security.md`](../database/account-access-security.md).
It rejects database-banned keys and foreign keys presenting protected PWDB
account names in `NWNX_ON_CLIENT_CONNECT_BEFORE`, before the character list. It
does not yet remove community-name overrides or migrate the server vault.

## Executive Finding

The supplied configuration and module source form a critical identity-boundary
failure:

1. The engine server vault is configured by mutable community/player name.
2. Sticky Player Names uses `knownservernames.2da` as a first-use mapping
   between that name and a public CD key.
3. The disguise library deliberately requests a community-name override for
   normal characters, disguises, anonymous identities, random identities, and
   transformations.
4. A disguised player can submit a weakly validated replacement name through
   `!renombrar`.
5. The server chooses and exposes the server-vault character list before the
   module's `OnClientEnter` ownership checks run.

The resulting design allows a presentation value to influence the storage
namespace from which characters are selected. A post-load panel or
`OnClientEnter` check cannot close the first-access window because the BIC has
already been exposed to the engine and selected by that point.

The correct target architecture is:

```text
Security identity     public CD key validated against a stable account ID
Character identity    engine UUID validated against the owning account ID
Community name        observed display/audit data only
Disguise name         presentation only
Server-vault key      public CD key, only after ownership data is recoverable
```

## Current Access Sequence

The vulnerable sequence is:

```text
Connecting community name + public CD key
        |
        v
Sticky Player Names / knownservernames.2da
        |
        v
servervault/<community-name>/
        |
        v
Character list and selected BIC
        |
        v
Module OnClientEnter
        |
        +-- PWDB account/UUID validation
        +-- panel-backed account/character status
        +-- legacy per-character CDKEY check
        `-- boot, paralysis or other response
```

The documented PWDB model correctly treats names as display data and CD key
plus character UUID as identity. However, its earlier assumption that the
engine vault already partitions BICs by CD key is not satisfied by the supplied
`settings.tml`. The engine boundary must be corrected independently of the
database model.

## Confirmed Findings

### F-01: The server vault is keyed by a mutable name

**Severity:** critical.

The supplied `settings.tml` sets:

```toml
[server.vault]
    by-player-name = true
    sticky-player-names = true
```

This makes a community/player name part of the server-vault authorization
boundary. The same file disables server-character backups.

Current NWN:EE 8193.37 defaults publish both `server.vault.by-player-name` and
`server.vault.sticky-player-names` as false. The supplied server deliberately
departs from those defaults.

Source and provenance:

- supplied `settings.tml`, lines 121-126;
- Beamdog 8193.37 configuration listing:
  <https://forums.beamdog.com/discussion/89081/neverwinter-nights-enhanced-edition-new-patch-89-8193-37-13-now-live>.

### F-02: The central disguise wrapper always overrides the community name

**Severity:** critical.

`PB_Disguise_SetNameOverride` declares a default
`NWNX_RENAME_PLAYERNAME_DEFAULT`, but its implementation:

- ignores the supplied `sNewName`;
- ignores the supplied `iPlayerNameState`;
- reloads `Disfrazado_nombre` from the character's persistent container;
- always calls `NWNX_Rename_SetPCNameOverride` with
  `NWNX_RENAME_PLAYERNAME_OVERRIDE`.

The NWNX Rename contract defines:

- `NWNX_RENAME_PLAYERNAME_DEFAULT`: do not rename the community name;
- `NWNX_RENAME_PLAYERNAME_OVERRIDE`: use the specified character name as the
  community-name override on the player list.

The implementation also passes `OVERRIDE` to per-observer calls. Current NWNX
does not support a per-observer community-name override and falls back to
`DEFAULT`, logging a warning. The global call remains the dangerous one.

Sources:

- `src/shared/nss/lib_disguise.nss`, lines 18 and 51-81;
- `src/shared/nss/nwnx_rename.nss`, lines 8-26;
- pinned `nwnxee/Plugins/Rename/Rename.cpp`, lines 553-580.

### F-03: Every normal player is placed into the override path on login

**Severity:** critical.

`Disfrazarse_ModEnter` does not limit community-name overriding to disguised
characters. Its normal, undisguised branch persists the real character name as
`Disfrazado_nombre` and calls the dangerous wrapper. The source comment
explicitly states that it changes both the character and account name to the
character name.

This matches the reported behavior that a connecting player's displayed
community name becomes the character name even without actively applying a
disguise.

Source: `src/shared/nss/lib_disguise.nss`, lines 663-683.

### F-04: The system explicitly instructs users to reconnect into the alias

**Severity:** high.

The anonymous, configured-disguise, removed-disguise, and random-disguise paths
tell the player to reconnect so that the account is the same as the character
name. All of those paths persist the alias and request a community-name
override.

Sources:

- `src/shared/nss/lib_disguise.nss`, lines 250-290;
- `src/shared/nss/lib_disguise.nss`, lines 335-383;
- `src/shared/nss/lib_disguise.nss`, lines 485-520;
- `src/shared/nss/lib_disguise.nss`, lines 524-540 and 640-659.

Current NWNX describes the override as player-list presentation state and says
that it does not persist through save, reset, or logout. Its current plugin
implementation temporarily substitutes the outgoing player-name field while
building relevant network messages and then restores the original internal
value. It does not document a permanent account-credential rewrite.

The observed production behavior is nevertheless security-relevant: after the
override and reconnect, the client reportedly presents the alias as its
community name, and that value reaches Sticky Player Names and the name-based
vault before `OnClientEnter`. That client/runtime transition requires a focused
reproduction against the exact remote image, but the community-name override
must be removed regardless.

### F-05: `!renombrar` feeds player-controlled text into the dangerous wrapper

**Severity:** high.

The player chat handler permits any disguised player to select a replacement
name. It checks only a three-character minimum and an exact Campaign DB lookup.
It does not establish a maximum length, canonical form, case-insensitive
uniqueness, reserved-name policy, control/color-code policy, or rate limit.

The accepted value is persisted as the disguise identity and the dangerous
wrapper is called twice: immediately and again after one second.

Source: `src/shared/nss/pjr_on_chat.nss`, lines 168-203.

### F-06: The vulnerable wrapper has a wider blast radius than the disguise item

**Severity:** high.

Direct consumers include the disguise library, player chat, druid and
wild-shape scripts, shifter logic, and MMF. Fixing only the disguise item or one
dialog would leave other community-name override paths active.

Known consumers at assessment time:

- `src/shared/nss/fdruidas_exe.nss`;
- `src/shared/nss/nw_s2_wildshape.nss`;
- `src/shared/nss/x2_s2_gwildshp.nss`;
- `src/shared/nss/sute_shifter.nss`;
- `src/shared/nss/pb_inc_mmf.nss`;
- `src/shared/nss/pjr_on_chat.nss`;
- `src/shared/nss/lib_disguise.nss`.

### F-07: Ownership enforcement occurs after BIC selection

**Severity:** critical design gap.

`wrap_on_clnt_ent.nss` begins PWDB identity resolution near the start of
`OnClientEnter`, before other module systems write persistent state. That is
correct within the module event, but the event itself occurs after the engine
has already exposed the server-vault character list and loaded the selected
BIC.

The legacy transparent `CDKEY` check occurs considerably later. On a first
access with an empty stored value, it binds the currently presented public CD
key. On mismatch, it paralyzes and disables the character rather than denying
the pre-vault connection.

Sources:

- `src/shared/nss/wrap_on_clnt_ent.nss`, lines 75-89;
- `src/shared/nss/wrap_on_clnt_ent.nss`, lines 120-126;
- `src/shared/nss/wrap_on_clnt_ent.nss`, lines 340-381.

This does not make PWDB the cause. It defines the remaining boundary that PWDB
cannot protect from its current event position.

### F-08: The supplied `knownservernames.2da` is untrusted and unbounded state

**Severity:** high.

The supplied copy contains 292,888 data rows and is 13,406,822 bytes. Aggregate
analysis found:

| Measure | Value |
|---------|------:|
| Exact duplicate rows | 82,956 |
| Distinct public CD keys | 202,780 |
| Distinct case-folded player names | 101,334 |
| CD keys linked to multiple distinct names | 1,796 |
| Maximum distinct names linked to one CD key | 261 |
| Names linked to multiple distinct CD keys | 57,933 |
| Empty names | 11 |

Connection-type distribution:

| Connect type | Rows | Share |
|--------------|-----:|------:|
| `016` | 103,035 | 35.2% |
| `032` | 189,853 | 64.8% |

The pinned NWNX client-event implementation maps connection type `32` to
`IS_DM = 1`. The `032` volume therefore appears to be dominated by DM
connection attempts. This interpretation applies to the pinned/current NWNX
source; the exact remote runtime image has not been established.

These rows do **not** prove successful player or DM authentication. The server
owner reports that failed login attempts are appended, so the file must not be
treated as a ledger of verified ownership. Its duplicate and many-to-many data
also make it unsafe as the sole source for a server-vault migration.

No disguise NWScript directly writes this file. The engine generates it for
Sticky Player Names; the disguise system can contaminate its namespace
indirectly when a client reconnects under an overridden alias.

Sources and provenance:

- supplied `knownservernames.2da`, assessed 2026-09-06 without exposing raw
  identities;
- pinned `nwnxee/Plugins/Events/Events/ClientEvents.cpp`, lines 171-193;
- historical description of the generated mapping and name-vault dependency:
  <https://forums.beamdog.com/discussion/69795/organizing-the-servervault-and-sticky-player-names>.

### F-09: The normal `knownservernames.2da` path should already be persistent

**Severity:** corrected earlier hypothesis; not a confirmed vulnerability.

Historical deployment descriptions place the generated file under the NWN
`override/` directory. The supplied `run-server.sh` links both `override` and
`servervault` from `/nwn/run` into the host-mounted `/nwn/home`, while the
supplied Compose mounts the remote server directory at `/nwn/home`.

Therefore, if the remote server uses the normal
`/nwn/run/override/knownservernames.2da` path, the file should survive container
recreation. The root-level copy supplied for this assessment is evidence only;
it is not automatically the live runtime file. The remote canonical path must
be verified, but loss on `docker compose down/up` is not established.

Sources:

- supplied `run-server.sh`, lines 5-7 and 40-45;
- supplied `docker-compose-pdb.yml`, lines 4 and 9-12.

### F-10: Sensitive credentials have multiple plaintext sources

**Severity:** high.

The supplied Compose and `settings.tml` contain plaintext server credentials,
and their DM values are not the same. `run-server.sh` always passes the Compose
environment values to `nwserver` as command-line arguments, so editing only
`settings.tml` is not a reliable password-change procedure for this stack.

A plaintext DM credential was exposed while inspecting the supplied file. It
must be considered compromised and rotated. No credential value is retained in
this document.

The target state is one deployment-owned secret source with restrictive host
permissions. Moving a value from YAML to a Compose environment file reduces
repository exposure but does not hide it from a user with Docker control;
file-based secrets require corresponding entrypoint support.

Sources:

- supplied `settings.tml`, server login section;
- supplied `docker-compose-pdb.yml`, server environment section;
- supplied `run-server.sh`, lines 177-200.

### F-11: Additional configuration increases incident impact

**Severity:** medium to high depending on the live host.

The supplied files also establish:

- master-server key authentication is set to `always`, which is favorable but
  does not repair name-based vault selection;
- player-to-DM login is disabled, which is favorable;
- ELC is disabled and must be assessed separately against the custom module;
- relayed connections are accepted, so source IP is not a durable identity;
- native log rotation is disabled;
- server-character backups are disabled;
- `NWNX_RENAME_ALLOW_DM=TRUE`, reducing the reliability of DM identity display;
- `NWNX_RENAME_ON_PLAYER_LIST` is absent and therefore uses the current plugin
  default `true`;
- NWNX calls from `ExecuteScriptChunk` are enabled, increasing the impact of a
  compromised administrative execution channel;
- the Compose requests Administration, Events, Player, and Rename plugins by
  setting their skip variables to `n`.

The owner reports that Administration is not active. The YAML requests it, but
only the remote NWNX startup log can establish whether it loaded successfully
or whether that host uses this Compose file.

Sources:

- supplied `settings.tml`;
- supplied `docker-compose-pdb.yml`;
- pinned `nwnxee/Plugins/Rename/README.md`, lines 6-14.

### F-12: Audit logs combine player name, public CD key and IP address

**Severity:** medium.

`wrap_on_clnt_ent.nss` writes the character name, community name, full public
CD key, and IP address into one normal login record. A public CD key is an
identifier rather than a password, but the combined record is still sensitive
operational data. Logs require restricted permissions, an explicit retention
period, and redaction outside private incident analysis.

Source: `src/shared/nss/wrap_on_clnt_ent.nss`, lines 141-145.

## Container Version Finding

The supplied Compose uses the mutable image tag:

```text
nwnxee/unified:build8193.37
```

At assessment time, Docker Hub maps that tag to the same published digest as
`build8193.37.17` and commit tag `3d4c4e1`. A remote host may still have an
older cached image. NWNX explicitly recommends a seven-character commit tag to
make the selected build and rollback reproducible.

Do not pull or recreate the production container until its current image ID,
revision and startup log have been captured. The repository cannot establish
the remote host's actual image.

Sources:

- NWNX Docker guidance:
  <https://github.com/nwnxee/unified/blob/master/README.md>;
- published image tags:
  <https://hub.docker.com/r/nwnxee/unified/tags>;
- NWNX release history:
  <https://github.com/nwnxee/unified/releases>.

The project `src/shared/nss/nwnx_rename.nss` matched the pinned NWNX Rename
include byte-for-byte at assessment time. No Rename-include divergence was
found in this checkout.

## Immediate Containment

The following order avoids turning an incident into data loss.

1. If exploitation is active, place the server into maintenance or protect it
   with a temporary player password. Without a working live Administration
   plugin, effective DM/admin/player password changes require a server restart
   or container recreation.
2. Before that recreation, record the running image ID and pin the exact known
   runtime. Do not blindly pull the mutable `build8193.37` tag.
3. Preserve a cold, access-restricted copy of the server vault,
   `knownservernames.2da`, databases, effective configuration, and NWN/NWNX
   logs. Record hashes and timestamps for incident analysis.
4. Rotate DM and admin credentials, including the exposed DM credential, and
   remove duplicate plaintext definitions.
5. Set `NWNX_RENAME_ON_PLAYER_LIST=false`. Current NWNX then falls back to
   `NWNX_RENAME_PLAYERNAME_DEFAULT` when legacy code requests a community-name
   override, preserving the visual character rename while refusing the
   community-name part.
6. Set `NWNX_RENAME_ALLOW_DM=false` so DMs retain a reliable original identity
   view.
7. Keep `NWNX_RENAME_SKIP=n` until all unguarded module calls have been
   removed or protected. Current NWNX aborts a script that calls an unavailable
   NWNX function unless availability is checked.
8. Disable NWNX functions in `ExecuteScriptChunk` unless a documented
   operational requirement justifies the additional administrative attack
   surface.
9. Do not delete, truncate or deduplicate the live `knownservernames.2da` while
   the vault remains keyed by player name.
10. Do not switch `by-player-name` or `sticky-player-names` off until a safe
    ownership map and server-vault migration exist.

NWNX 8193.37.13 changed the NWNX API and documents the unavailable-plugin
abort behavior:
<https://github.com/nwnxee/unified/blob/master/CHANGELOG.md>.

## Required Code Remediation

The disguise layer must become presentation-only.

### Central wrapper

Replace the public operation with a deliberately narrow function such as
`PB_Disguise_SetVisibleName`. It must:

- use the supplied visible name instead of reloading an unrelated persistent
  value;
- always pass `NWNX_RENAME_PLAYERNAME_DEFAULT`;
- expose no community-name-state argument to callers;
- keep DM annotations as per-observer character-name suffixes using `DEFAULT`;
- never alter or obfuscate a community name;
- retain a guarded fallback when NWNX Rename is unavailable.

### Login behavior

Remove the undisguised login override. Reapply visual disguise state only when
a character is actually anonymous, disguised, transformed, or otherwise owns a
documented visual identity.

Remove every message that tells a player to reconnect to synchronize an
account name with a character or disguise name.

### Player-supplied aliases

`!renombrar` must have a single validation boundary covering:

- leading and trailing whitespace;
- a project-defined maximum length;
- empty and whitespace-only values;
- line breaks, control characters and color markup;
- reserved administrative and system names;
- case-insensitive/canonical uniqueness;
- a rate limit;
- private audit of the real account, real character and chosen alias.

The duplicate delayed override must be removed.

### Consumers

Search and update every direct wrapper consumer in the same change. A modified
shared include requires focused compilation through representative executable
consumers under the repository verification contract.

## Pre-Vault Authorization Requirement

Containment of the first-access window requires a decision before the engine
sends the character list. Current NWNX exposes:

```text
NWNX_ON_CLIENT_CONNECT_BEFORE
```

The event provides `PLAYER_NAME`, `CDKEY`, `IS_DM`, `IP_ADDRESS`, client
version, and platform. Skipping the event denies the connection and can return
a reason. The event is implemented around the server's character-list send,
before `OnClientEnter`.

The future handler should evaluate:

- blocked account or public CD key;
- blocked community name where legacy compatibility still requires it;
- the expected account/key association;
- a separate DM allowlist and DM connection policy;
- backend availability and an explicit failure policy.

DM authorization should fail closed. IP address may support rate limiting and
incident correlation but must not establish ownership.

NWNX also exposes:

```text
NWNX_ON_CHECK_STICKY_PLAYER_NAME_RESERVED_BEFORE
```

It can replace the engine `knownservernames.2da` decision with another mapping
during a transitional name-vault period. That is an alternative to the file,
not the preferred final storage identity.

Sources:

- pinned `nwnxee/Plugins/Events/NWScript/nwnx_events.nss`, client-connect and
  server-vault event sections;
- pinned `nwnxee/Plugins/Events/Events/ClientEvents.cpp`, lines 135-193;
- upstream changelog entry adding pre-character-list and Sticky Player Name
  events: <https://github.com/nwnxee/unified/blob/master/CHANGELOG.md>.

## CD-Key Vault Migration Feasibility

### Current conclusion

A correct automatic migration from hundreds of name-based account folders to
CD-key folders is **not currently possible without a trusted account-to-CD-key
map**.

This is not merely a high-cost copy operation. Ownership cannot be inferred
safely from a folder name or BIC filename. The supplied
`knownservernames.2da` cannot be the sole source because it includes attempts,
aliases, duplicates, many-to-many associations, and no trustworthy success or
ownership timestamp.

Blind migration could give an attacker every BIC under a victim's account
folder. Copying an ambiguous account folder to every observed CD key is
strictly forbidden.

### Possible partial evidence

The legacy module attempts to persist a `CDKEY` string on each character's
`CONTENEDOR_VARIABLES` item when the value is empty. The helper writes a local
string to the `dmfi_pc_emote` inventory item.

Sources:

- `src/shared/nss/wrap_on_clnt_ent.nss`, lines 342-350;
- `src/shared/nss/mti_libreria.nss`, lines 8 and 227-238.

That value is useful only if all of the following can be established:

- the corresponding code was deployed before the incident;
- the character possesses the container and the variable was saved in its BIC;
- the first binding was made by the legitimate owner;
- a later administrative operation did not replace it incorrectly.

It is evidence, not automatic proof. Likewise, PWDB is not the cause of the
incident, but verified associations from a deployed PWDB database could become
corroborating migration evidence. This assessment does not assume that the
remote server has either source populated reliably.

### Feasible migration strategy

Until an ownership map exists:

1. Keep the production vault name-based.
2. Remove every community-name override from disguise and transformation
   behavior.
3. Enforce blocks before the character list.
4. Start a controlled account re-enrollment process through a trusted external
   channel, coordinated panel action, or DM procedure.
5. Build a reviewed account-folder to public-CD-key map with evidence and an
   explicit confidence state.
6. Prepare a CD-key vault mirror offline. Never overwrite a BIC collision.
7. Quarantine accounts with multiple claimants or insufficient evidence.
8. Change the engine vault mode only after the accepted coverage threshold,
   conflict policy, player communication, rollback, and maintenance window are
   approved.

The engine supports one active vault organization at a time; a staged mirror
can be prepared while the name vault remains live, but final cutover is a
coordinated maintenance event.

### Operational cost

For hundreds of accounts, the initial operational cost is high:

- full vault inventory and hashing;
- owner-evidence collection;
- manual resolution of ambiguous accounts;
- temporary storage for backup plus staged vault;
- an offline final synchronization;
- per-account and per-character verification;
- player support for missing or disputed ownership;
- auditing legacy systems that use `GetPCPlayerName()` in persistent keys;
- a documented rollback to the untouched name-based vault.

The physical file move is the smallest part of the work. Proving ownership is
the dominant cost and cannot be automated from the supplied data.

After a validated migration, steady-state vault operation by CD key is simpler
and no longer needs Sticky Player Names for storage isolation. Administration
becomes less human-readable on disk, so the control panel or a private operator
report must map the masked public CD key to the account and its characters.

## Alternatives

| Option | Security result | Cost and limitation |
|--------|-----------------|---------------------|
| Display-only disguise plus current name vault | Immediate containment of the disguise-induced namespace mutation | Does not remove first-use name-vault risk or the unbounded sticky file |
| Name vault plus custom Sticky Player Name event/backend | Can replace `knownservernames.2da` and reject before name reservation | Retains mutable names in the storage boundary and needs a trusted map |
| CD-key vault plus pre-connect authorization | Preferred final design; storage isolation no longer depends on a name | Impossible to migrate old accounts safely until ownership evidence exists |
| Post-load PWDB/panel boot only | Protects gameplay and database writes after load | Cannot prevent the initial character-list/BIC exposure |

The recommended sequence is the first option as urgent containment, then
pre-connect authorization, evidence collection, and finally the third option
when migration is actually supportable.

## Verification Plan

No static inspection proves live NWN client behavior. The exact pinned runtime
must pass a staging test matrix before production deployment.

### Runtime and deployment identity

- Record the running container image ID, NWNX commit and NWN build.
- Confirm Rename, Events and Administration plugin load status from startup
  logs.
- Confirm the effective `settings.tml` and command-line options without
  printing secrets.
- Confirm the canonical live `knownservernames.2da` path and persistence.

### Disguise containment

- A normal player retains the original community name after entering.
- Anonymous, configured, random, druid, wild-shape, shifter and MMF identities
  change only the visible character name.
- `GetPCPlayerName()` remains the connection's original community name.
- Reconnecting after every disguise path does not change the presented
  community name.
- `!renombrar` rejects invalid, reserved and non-canonical inputs.
- No disguise action creates a new Sticky Player Names entry.
- DMs see the original account and character identity required for auditing.

### First-access authorization

- A blocked account is denied before receiving a character list.
- A blocked public CD key is denied before receiving a character list.
- A different public CD key presenting a victim community name cannot see or
  select the victim's BIC.
- A failed backend follows the approved failure policy and cannot silently
  bypass DM authorization.
- Player and DM connection attempts are distinguished and rate-limited without
  using IP as ownership proof.

### Eventual CD-key vault

- Every accepted source folder maps to exactly one reviewed public CD key.
- Every destination BIC count and hash matches the accepted source.
- No collision is overwritten.
- The legitimate key can see all expected characters after cutover.
- A different key cannot see those characters regardless of community name.
- The same legitimate key retains its vault when using another community name.
- Legacy persistence does not fork or reset when the community name changes.
- `knownservernames.2da` stops being an authorization dependency after Sticky
  Player Names is disabled.
- The original vault remains unchanged and rollback-tested until acceptance is
  complete.

## Decisions Still Required

1. Whether production containment starts with a temporary player password or
   scheduled downtime.
2. The exact remote image and whether Administration actually loads.
3. The first pre-vault policy: block list only, strict account/key binding, or a
   staged combination.
4. The trusted channel by which existing players can prove account ownership.
5. Whether legacy per-character `CDKEY` values exist and are trustworthy enough
   to contribute evidence.
6. The acceptable migration coverage threshold and treatment of unclaimed
   accounts.
7. The policy for legitimate public-CD-key replacement.
8. Retention, protection and final archival treatment for
   `knownservernames.2da` and identity logs.

## Actions Explicitly Not Taken

- No module source was changed.
- No Compose, TOML, shell script or credential was changed.
- No NWScript compilation or module packaging was run.
- No container was started, stopped, recreated, inspected or pulled.
- No server-vault file was moved, copied, renamed, or deleted.
- No `knownservernames.2da` row was altered or exposed.
- No remote server or production database was accessed.
