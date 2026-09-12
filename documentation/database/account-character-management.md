# Account And Character Management

## Scope

This document defines the administrative extension of the existing
`pwdb_account` and `pwdb_character` identity model. It is based on the legacy
MariaDB schema supplied for review and on PDB's current MySQL 8.4 runtime.

The control panel exposes these records through explicit per-user permissions,
not through role-name checks. `view_accounts` grants the account list and
masked key hints. `view_characters` grants the character list, while separate
permissions control identity, timestamps, abilities, classes, level unlocks,
technical profile fields, and tradeskills inside each character. Matching edit
permissions govern account changes and each writable character section.

Only administrators may alter these system permissions, but they may configure
them on a user with any descriptive role. Recipe editing is independently
controlled by `edit_recipes` and the user's assigned profession IDs.
`activate_cd_keys` remains a separate, administrator-assigned capability and
requires `view_accounts`.

## Legacy schema findings

The supplied dump cannot be adopted as the new identity model:

- `gs_player_data` identifies an installation by several partial CD-key
  columns, while `gs_account_data` maps a mutable `playername` back to it.
- `gs_pc_data` duplicates `playername` instead of owning one mandatory foreign
  key to an account row. Its useful `keydata` relationship is equivalent to the
  new `pwdb_character.account_id`, but names remain denormalized.
- Three fixed pairs (`classname_1..3`, `classlevel_1..3`) encode a repeating
  relationship as columns. They cannot carry foreign keys to `classes.2da`,
  enforce unique classes, or evolve cleanly.
- `bank`, nation, elemental powers, appearance, crafting values, server state,
  and locations are mixed into the character identity row even though they
  belong to independent systems with different ownership and lifecycles.
- Numerous domain tables correctly point to `gs_pc_data.id`, but some use
  `MyISAM`, which means declared relational expectations cannot be enforced.
- The supplied `gs_account_data` DDL contains a stray `hhhh` token after its
  primary key and cannot be executed unchanged.
- Legacy tables use `latin1`; the target schema uses `utf8mb4`.

No player data from the dump was imported by this change.

## Resulting ownership model

```text
pwdb_account
    account_id PK
    cd_key UNIQUE                    immutable natural identity
    player_name                     latest name observed by the game
        |
        +-- pwdb_account_management account display override, status, notes
        |
        +--< pwdb_character
                 character_id PK    only character join key
                 character_uuid UQ  immutable natural identity
                 account_id FK      explicit ownership/transfer point
                 char_name          registered name; changed only by rebuild
                     |
                     +-- pwdb_character_profile
                     |      display override, status, race, subrace,
                     |      gender, portrait, deity, six base ability
                     |      scores, notes
                     |
                     +--< pwdb_character_class
                     |      class_slot 1..3, class_id FK, level 1..40
                     |
                     +--< cnr_tradeskill
                     |      one live XP/level row per CNR tradeskill
                     |
                     +--< pwdb_character_level_unlock
                     |      irreversible panel grants restored at login
                     |
                     +--< future character-owned system tables

pwdb_class_definition               player classes from PDB classes.2da
pwdb_identity_revision              immutable authorized edit snapshots
```

The character name is stored on first registration and is not changed by an
ordinary login. Only a completed rebuild migration may replace it together
with the UUID. This prevents disguises or other runtime presentation changes
from rewriting persistent character identity. Administrative display overrides
remain separate and editable in the panel. CD keys remain masked in API
responses. Character UUIDs are visible in full to users with
`view_character_identity` for exact diagnosis, but are never editable from the
browser.

Character ownership changes only through an operation authorized by
`edit_character_identity` that updates `pwdb_character.account_id`. Login never
rewrites ownership.

## Login enforcement

Game login is fail-closed for non-DM player characters. Identity resolution
checks the immutable character UUID against its registered CD key before any
write. A mismatch displays a generic ownership message, records only masked
diagnostic fragments, stops the remaining `OnClientEnter` workflow, and boots
the player after the configured delay.

Account and character management statuses are also runtime access policy:

- account `active` allows login; `blocked` immediately boots every character
  owned by that account, including newly created characters;
- character `active` allows login and `blocked` immediately boots only that
  character;
- character `deleted` is a durable tombstone, not a request to delete its
  database row. The NPC first stores that status and `deleted_at`; only after
  MySQL confirms the owned UUID and CD key does
  `NWNX_Administration_DeletePlayerCharacter(oPC, FALSE, message)` delete the
  server-vault BIC without preserving a renamed backup;
- the tombstone retains the UUID, account ownership, profile, classes,
  tradeskills, level unlocks, rebuild counters, domain rows, and audit history.
  Every character section becomes read-only in the panel;
- the tombstone blocks only its deleted UUID. A new UUID may register the same
  character name in the same or another account and receives a new
  `character_id` and independent domain rows. Name equality never revives or
  links the deleted record;
- if the NPC cannot persist the tombstone, the BIC is preserved. This prevents
  an SQL failure from destroying the only remaining character record;
- an identity or database validation failure denies the session instead of
  allowing gameplay without a verified identity;
- DMs remain outside persistent player identity and are not evaluated by this
  policy.

The account check is performed by the presented CD key independently of the
character UUID. This is required so a blocked account cannot evade policy by
entering with a new character. A UUID presented by a different CD key is booted
immediately through native `BootPC`; there is no grace period in which the
unverified character can move or invoke later `OnClientEnter` systems. Denied
logins do not advance account or character login timestamps.

An authorized key change uses the controlled recapture workflow in
[`account-cd-key-reset.md`](account-cd-key-reset.md). The panel never accepts a
manually entered key: it opens a bounded request, the denied game connection
captures the first candidate, and a second administrative action confirms it.
An exact administrator with the same `activate_cd_keys` grant may also promote
an already observed historical key after explicit confirmation; this does not
permit arbitrary input. For an unregistered legacy BIC, a container mismatch
first imports ownership under the stored old key and denies the connection, so
the normal recapture can then operate on a real panel account without ever
assigning ownership to the rejected key.
After successful PWDB validation, each character's legacy container key is
synchronized before the old transparent security check. The operational
`activate_cd_keys` capability is an explicit per-user grant controlled only by
an administrator; it is not implied by any role.

## Character rebuild workflow

Character rebuilds preserve the old `character_id` and its complete domain
tree while replacing the engine UUID with the UUID of the replacement BIC. The
dedicated DM rebuild wand enforces this order:

1. The DM stores the old character copy and asks the player to confirm BIC
   deletion. The request is refused before deletion when the persistent
   `rebuilds_available` count is zero or cannot be read. Confirmation deletes
   only the active server-vault BIC; it does not modify the old database
   identity or consume a rebuild.
2. The player creates and enters with the replacement character. Normal login
   creates a provisional `pwdb_character` row and its domain tree.
3. `Clean character` verifies that the provisional `character_id`, live UUID,
   and presented CD key identify the same row. It then deletes the character
   root. The cleanup SQL first removes polymorphic revision rows after matching
   the same character ID, UUID, and CD key; InnoDB then deletes every
   foreign-key child by cascade. The new variable container is destroyed only
   after MySQL confirms exactly one deleted character root.
4. The DM copies the old variable container to the replacement character.
5. `Migrate character` reads the old `character_id` from that container,
   verifies that it belongs to the presented CD key, refuses UUID conflicts,
   and updates the old root row to the replacement BIC UUID and current name.
   The name may differ from the original because the container-held identifier,
   not name equality, authorizes this operation. That guarded update atomically
   decrements `rebuilds_available` and increments
   `rebuilds_completed`. It then refreshes the engine-owned profile and class
   snapshot, synchronizes restored metadata and unlocks, and reloads the CNR
   cache. Retrying after a partial snapshot failure recognizes the already-bound
   UUID and cannot consume a second use.

Cleanup and migration must finish in the same player session. After successful
cleanup, persistent writes are disabled for that character until migration
finishes so runtime systems cannot silently recreate the provisional tree. If
any cleanup database operation fails, the new container is preserved and both
the DM and player receive an error. If migration fails, the restored container
is preserved and the player is instructed not to leave the server.

The server-vault deletion contract is sourced from the pinned NWNX:EE
Administration header at
`nwnxee/Plugins/Administration/NWScript/nwnx_admin.nss`. It documents that the
operation immediately boots the connected PC and that `bPreserveBackup = FALSE`
removes the BIC instead of renaming it to a `.deleted0` backup.

## Deleted-character lifecycle

Migration `0021_character_tombstones` adds `deleted_at` to the character
profile. It must be applied before the updated module scripts are deployed; the
runtime deliberately fails closed if the expected schema is absent.

Normal deletion and rebuild cleanup are separate resource paths. The character
deletion NPC uses `borrarpjs.dlg` and `borrarpjs.nss`, which create the tombstone
before deleting the BIC. The rebuild wand uses `rebuild_confirm.dlg` and
`rebuild_bic.nss`, which delete only the provisional BIC and never mark the old
identity deleted.

Once persisted as `deleted`, a character cannot be edited, transferred,
reactivated, or granted domain progress through the ordinary character update
endpoint. Its UUID remains permanently rejected unless an exact administrator
uses the separate hard-purge action. The tombstone does not reserve its name:
a normal recreation receives a new identity and never inherits the old domain
tree. The rebuild workflow cannot use a deleted row because its guarded lookup
requires the old profile to remain `active`.

**Permanently delete data** requires the exact typed confirmation `ELIMINAR`
and an unchanged concurrency timestamp. It deletes character-targeted audit
snapshots, then the character root so foreign-key cascades remove every
character-owned row. A minimal account-scoped audit records that a character
ID was purged. Account-level CD-key and IP history remains because it is shared
security evidence, not character-owned data.

The exact wand blueprint, resource graph, module event binding, database
migration, operator procedure, production deployment order, acceptance test,
and rollback contract are documented in
[`character-rebuild-workflow.md`](character-rebuild-workflow.md). Treat that
manifest as a single production port slice; copying only the UTI or only the
scripts produces an incomplete tool.

## Character classes

`pwdb_character_class` replaces the six fixed legacy class columns. Its stored
shape enforces:

- at most three consecutive class slots;
- one occurrence of a class per character;
- levels from 1 through 40;
- a total character level no greater than 40 when captured;
- class IDs present in `pwdb_class_definition`.

The panel presents class identity, slot, and level as a single read-only
technical section. Character update requests reject class fields rather than
silently accepting edits that cannot modify the server-vault BIC. Only the game
capture path owns this snapshot.

The initial class reference rows are the 41 `PlayerClass = 1` entries in PDB's
`haks-2da/classes.2da`, including custom PDB classes. Class metadata stored here
does not modify a server-vault BIC. After resolving the persistent character ID,
every successful login refreshes the engine's current three class positions and
levels, removing stale class slots that no longer exist.

The same recurring operation captures race, subrace, gender, portrait resref,
deity, and the six base ability scores in `pwdb_character_profile`. Strength,
Dexterity, Constitution, Intelligence, Wisdom, and Charisma use
`GetAbilityScore(oPC, ABILITY_*, TRUE)` so equipment and temporary bonuses are
excluded. The panel exposes these values as read-only observations because
editing a database snapshot does not modify the server-vault BIC.

Existing characters created before the statistics migration acquire those
values the next time they enter the module. `snapshot_captured_at` records the
first successful capture for historical provenance; it is not a guard against
later refreshes. A failed capture can retry on a later login and does not
invalidate an otherwise successful identity resolution. The database migration
must run before the updated module is deployed; if ordering is reversed,
identity still resolves but the snapshot query fails until the schema is
upgraded.

All snapshot values are passed as bound parameters through the
[NWNX:EE SQL prepared-statement API](https://nwnxee.github.io/unified/group__sql.html);
player-controlled character strings are never concatenated into SQL.

## Character creation and login dates

`persist_pjs_nuev.nss` stores the Unix timestamp `PB_FECHA_CREACION` on the
established character-variable container. `guia_pb.dlg.json` exposes the same
date through `guia_fecha.nss`, which reads it with `ObtenerIntPersistente`.

Early identity validation intentionally runs before `persist_pjs_nuev.nss`, so
a new character does not yet have the container timestamp at that point. The
resolver may insert a provisional current database timestamp, but a second,
post-initialization synchronization reads `PB_FECHA_CREACION` through the same
established helper and replaces `pwdb_character.created_at` with that exact
Unix timestamp. Existing characters therefore repair a provisional panel date
on their next successful login; new characters synchronize the date written by
their initializer during the same login.

`last_login_at` remains runtime-owned and advances on every successful login.
Both dates are read-only in the API and are displayed together in the
character summary.

## Level unlock grants

`pwdb_character_level_unlock` records the level permissions granted by a user
with `edit_character_level_unlocks`. Its accepted values mirror the live
`wrap_on_ply_lvl.nss` checks exactly: levels 9, 13, 17, 21, 22, 24, 26, 30,
and 35. The panel also shows the current cap immediately below each permission,
for example cap 8 permits level 9.

Migration `0022_level_unlock_application_status` separates authorization from
delivery. `granted_at` records when the panel authorized the unlock;
`applied_at` remains `NULL` until the module has confirmed the corresponding
campaign value. The panel therefore presents an authorized row as pending until
the character reconnects, and as applied only after that acknowledgement.

On successful login, and only for a resolved non-DM character, the module first
reads the existing BioWare campaign values. Legacy values missing from MySQL
are imported with `applied_at` already set, and existing pending rows whose
campaign value is present are acknowledged without producing a player message.
It then reads the authorized rows once and compares each one with its variable
in campaign `DESBLOQUEO`. A missing value is written with `SetCampaignInt` and
immediately read back with `GetCampaignInt`. Only a successful read-back emits
the pale-green player message and qualifies the row for `applied_at`; a failed
write remains pending and is retried on the next successful connection. A
database acknowledgement failure also leaves the panel state pending and is
retried without revoking the campaign value.

No character row or no grants means no assignment and no player message. This
flow deliberately does not attempt a hot update from the web process: granting
an unlock in the panel requires the affected character to reconnect before it
can become applied.

Grants are deliberately append-only in the panel. Removing a MySQL row cannot
reliably revoke a permission already copied into the BioWare campaign store, so
the API rejects removal instead of presenting a misleading reversible control.

The current login query is transitional. Before production deployment, split
known-character access validation from automatic registration and move new
character registration, profile capture, creation-date synchronization, and
unlock synchronization to the designated world-entry NPC trigger. Immediate
UUID/CD-key and blocked/deleted access enforcement must remain in the earliest
safe login path so an unauthorized character cannot act. The source call is
marked with the corresponding TODO; the NPC resref cannot be bound until that
game-design choice is made.

Class IDs are external engine identifiers, not generated database identities.
In particular, class `0` is valid and must be stored literally. The migration
therefore disables auto-increment on `pwdb_class_definition.class_id`.

MySQL commits DDL statements even if a later statement in the same Alembic
migration fails. Migration `0002_identity_management` checks for each table,
uses idempotent reference/backfill inserts, and can resume after a partial DDL
application without deleting identity or domain data.

## CNR tradeskills

`cnr_tradeskill` is live CNR progression, not character-class metadata. The
account editor reads and writes the seven canonical skills: Herreria,
Carpinteria, Peleteria, Alquimia, Joyeria, Arcano, and Sastreria. The interface displays
their localized labels and one selected character at a time, so skill data is
not confused with repeated character profile forms.

At most two non-Alchemy skills may be saved at level 2 or above. Alchemy does
not occupy a slot; level-one skills do not occupy one either.

The API accepts the experience value as authoritative and derives the stored
level with the same 20-level threshold curve used by `cnr_i_skill.nss` and
`PersistDetermineTradeskillLevel`. Selecting a level in the browser sets the
minimum experience for that level. Each row carries its own optimistic
timestamp; a save is rejected if the game or another editor changed that skill
after the form was loaded.

Administrators should edit tradeskills while the character is offline. The
module loads these rows into the character's session cache on login, so an
online character may continue using stale values and later persist them. The
updated values take effect when the character enters again.

The former development fixture named `Oficios` was a real test character, not
a tradeskill section. It and the other development character were removed from
the development database after explicit authorization; accounts were retained.

## Deliberately excluded data

Location and respawn location are excluded at the user's request.

The following legacy fields also do not belong in the identity/profile tables:

| Legacy data | Correct future owner |
|-------------|----------------------|
| `bank` | A banking system table keyed by `account_id` or `character_id`, depending on whether balances are shared |
| `c1..c6`, timeout, points | `cnr_tradeskill` and other CNR-owned tables |
| nation, factions, ranks | Nation/faction membership tables keyed by `character_id` |
| fire, water, earth, air, life, death | A dedicated elemental progression table keyed by `character_id` |
| wings, bone arm, hair/skin color | An appearance system table keyed by `character_id` |
| wealth | An economy/character-assessment table, not identity |
| modified server/current player | Session or shard-presence tables with their own expiry rules |

## Extension rule for banks and future systems

Do not add generic JSON columns or a polymorphic `owner_type/owner_id` pair to
identity. Each subsystem owns its tables and uses a real foreign key:

```sql
-- Account-wide bank example
CREATE TABLE bank_account (
  account_id INT NOT NULL,
  ...,
  PRIMARY KEY (account_id),
  CONSTRAINT fk_bank_account_owner
    FOREIGN KEY (account_id) REFERENCES pwdb_account(account_id)
    ON DELETE CASCADE
);

-- Character-specific persistent system example
CREATE TABLE system_character_state (
  character_id INT NOT NULL,
  ...,
  PRIMARY KEY (character_id),
  CONSTRAINT fk_system_character
    FOREIGN KEY (character_id) REFERENCES pwdb_character(character_id)
    ON DELETE CASCADE
);
```

If a future bank must support both ownership modes, use a `bank_ledger` plus
two separate owner-link tables with real foreign keys. Do not create a nullable
account/character pair or an unenforced polymorphic reference.

## Current limitations

- Character classes, engine-captured base ability scores, and identity
  timestamps are read-only observations in the panel. Editable profile fields
  remain administrative metadata and do not modify the BIC.
- A panel status change to `deleted` removes the BIC only when that character
  next connects. The in-game deletion NPC removes it immediately after MySQL
  stores the tombstone. Neither path keeps a BIC recovery backup.
- A deleted UUID can be rejected only after character selection because the
  engine does not expose character identity at pre-vault connect. Reusing the
  same name with a different UUID is intentionally allowed and creates an
  independent persistent character.
