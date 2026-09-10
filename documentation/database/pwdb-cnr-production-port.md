# PWDB And CNR Production Port

Current checklist for moving persistent identity and database-driven crafting
from PDB DEV into the production module. Use this document for the port; the
integration runbook records the historical development sequence.

The paired CNR
[`legacy-removal-and-production-promotion.md`](../oficios/cnr/legacy-removal-and-production-promotion.md)
owns current catalogue counts, profession-resource cleanup, station inventory,
potion activation, collection blockers, and the combined smoke test. A
production promotion must complete both documents; this checklist alone is not
evidence that the profession runtime is ready.

The character rebuild extension has an additional atomic port contract in
[`character-rebuild-workflow.md`](character-rebuild-workflow.md). That document
owns the DM wand blueprint, `Mod_OnActvtItem` integration, dialogue/script
manifest, migration `0010_character_rebuild_cleanup`, controlled acceptance
test, and rollback order. Do not infer those resources from the generic PWDB
directory transfer below.

Controlled account-key recapture is a separate slice documented in
[`account-cd-key-reset.md`](account-cd-key-reset.md). It requires editor
migration `0011_account_cdkey_reset`, backend/frontend actions, denied candidate
capture in the PWDB resolver, and post-validation synchronization of the legacy
character container. Deploy its database migration before its panel or module
code.

The least-privilege Dungeon Master extension follows with migration
`0012_dungeon_master_role`. It grants the role read-only identity access while
keeping general identity, catalogue, and user writes denied. Migration
`0013_system_user_permissions` then persists administrator-assigned capabilities
and backfills `activate_cd_keys` for existing technical-team and Dungeon Master
users. Migration `0014_integral_permissions` expands those grants into explicit
view/edit capabilities and backfills compatibility presets for every existing
role. Apply `0011`, `0012`, `0013`, and `0014` in that order.

## 1. Ownership boundaries

| Layer | Owner | Location | Persistence |
|-------|-------|----------|-------------|
| Account and character identity | PWDB | `src/pwdb/nss/` | `pwdb_account`, `pwdb_character` |
| Module event integration | Target module | its existing `OnModuleLoad` and `OnClientEnter` scripts | None |
| Tradeskill progress and settings | CNR | `src/cnr/nss/` | `cnr_tradeskill`, `cnr_character_setting` |
| Recipe catalogue | CNR | `migration/catalogue/` and generated SQL | Replaceable catalogue tables |
| SQL transport | NWNX_SQL | NWNX:EE runtime | MySQL protocol |

PWDB exposes identity; it does not own crafting. CNR references only the
surrogate `pwdb_character.character_id`. No CNR table may duplicate a CD key,
UUID, player name or character name.

The source directories are organizational. NWN has one flat module resource
namespace after compilation, so `#include "pwdb_i_user"` works from shared and
CNR scripts once `src/pwdb/nss/` is on the compiler include path.

## 2. Files to transfer

### PWDB subsystem

Copy the directory `src/pwdb/nss/` as a unit:

| File | Contract |
|------|----------|
| `pwdb_c_config.nss` | Table names, session cache key and player-facing denial policy |
| `pwdb_i_db.nss` | Private MySQL implementation and ownership checks |
| `pwdb_i_user.nss` | Public API; the only PWDB include other systems consume |

The public identity API is `PWDB_EnsureIdentitySchema`,
`PWDB_ResolveCharacterId`, `PWDB_WasOwnershipDenied`,
`PWDB_GetCharacterId` and `PWDB_CanPersist`. Callers must not use
`PWDB_DB_*` functions or `PWDB_RESULT_*` constants directly.

Do not copy DEV's `wrap_on_*` scripts over production. Merge the hook blocks
into the scripts already assigned in production's `module.ifo`.

### CNR subsystem

Merge `src/cnr/` into production, preserving its `nss/` and `dlg/` structure.
The database-driven station also needs the existing chat hook in
`src/shared/nss/pb_chat.nss` if creation by typed public id is required.

Station placeables must use:

- `OnUsed`: `cnr_device_ou`
- conversation: `cnr_c_station`
- `OnInventoryDisturbed`, `OnOpen`, and `OnClosed`: empty

Do not replace unrelated production placeable events without auditing them.

### Database migrations

Persistent state is deliberately separate from the replaceable catalogue:

| Migration | Destructive? | Owns |
|-----------|--------------|------|
| `migration/pwdb/01_identity_schema.sql` | No; `CREATE TABLE IF NOT EXISTS` | Account and character identity |
| `migration/cnr/00_player_state_schema.sql` | No; `CREATE TABLE IF NOT EXISTS` | Tradeskill XP/level and character settings |
| `migration/01_schema.sql` | **Yes for catalogue tables** | CNR professions, stations, categories, recipes and properties |
| `migration/02_seed.sql` | Replaces global seed rows | Professions, stations, tools and materials |
| `migration/03_catalogue.sql` | Replaces catalogue rows in a transaction | Categories, recipes, components and properties |

Never copy the DEV MySQL volume into production. Apply schema and catalogue
migrations to the production database through its own credentials and backup
policy.

The character profile schema must also include the nullable
`snapshot_captured_at` marker introduced by the editor migration
`0005_character_snapshot_marker`. Deploy that migration before the NWScript
snapshot integration. The first eligible login captures profile and class data
and sets the marker; later logins only read the marker and never rewrite that
snapshot. Do not replace this explicit marker with null-field inference because
subrace, portrait and deity may legitimately be empty. A future refresh process
must deliberately clear or replace the marker under its own documented policy.

## 3. Build configuration

Production Nasher must include all `src/**/*.{nss,json}` and route PWDB before
the generic shared rule:

```toml
[package.rules]
"pwdb_*.nss" = "src/pwdb/$ext"
"*.${shared-files}" = "src/shared/$ext"
```

The specific rule matters only when unpacking a new PWDB resource. Existing
tracked sources retain their current path. Do not add another identical
`*.${shared-files}` rule for PWDB; first-match routing would make it unreachable.

Any direct `nwn_script_comp` invocation must include these directories:

```text
src/shared/nss
src/cnr/nss
src/pwdb/nss
src/nui
```

Nasher still packages all compiled resources into the target module. PWDB is
not a separate runtime service or HAK.

### Required change-level compile policy

Before transferring code, copy the mandatory focused NWScript compilation rule
from DEV's `AGENTS.md` into the production repository's `AGENTS.md`. This is a
required migration item, not DEV-only guidance.

Every production change that creates or modifies `.nss` files must run a
non-writing compiler check against only the explicit changed executable scripts
and representative executable consumers of changed includes. A failed check
blocks handoff. A documentation, SQL, JSON, GFF, or configuration-only change
does not trigger NWScript compilation.

Production may use a differently named wrapper, but it must accept an explicit
file list and preserve the same invariant. Do not use a whole-module compile,
clean build, Nasher install, or package operation as the change-level test. If
production has no focused check command, add one before porting the first
NWScript slice; do not fall back to compiling the entire module.

## 4. Required module hooks

### OnModuleLoad

Merge this before any character-owned system can use the database:

```nwscript
#include "pwdb_i_user"

void main()
{
    PWDB_EnsureIdentitySchema();
    // Existing production initialization continues here.
}
```

The SQL identity migration remains the deployment source of truth. The runtime
ensure is an idempotent safety net and validates that NWNX_SQL is using MySQL.

### OnClientEnter

Identity must resolve before CNR loads or writes character state:

```nwscript
#include "pwdb_i_user"
#include "cnr_i_skill"

void main()
{
    object oPC = GetEnteringObject();

    if (!GetIsDM(oPC) && !GetIsDMPossessed(oPC))
    {
        PWDB_ResolveCharacterId(oPC);
        if (PWDB_WasOwnershipDenied())
        {
            return;
        }
    }

    CnrSkill_Load(oPC);
    // Existing production login logic continues here.
}
```

The target module must provide the `CONTENEDOR_VARIABLES` item used as the
session cache. In PDB it is `dmfi_pc_emote`, declared by `mti_libreria.nss`.
Existing characters also use its legacy `CDKEY` value as a migration guard when
their UUID is still absent from PWDB. A mismatch imports the UUID under that
stored owner and denies the presented key, leaving a panel account on which an
`activate_cd_keys` operator can open the normal recapture workflow. Confirm that
the item is available before identity resolution and before `CnrSkill_Load`;
otherwise an unimported BIC has no legacy ownership evidence and the CNR cache
cannot load.

No logout flush is required. `CnrSkill_SetXP` writes through to MySQL and then
updates the session cache.

## 5. Infrastructure prerequisites

- MySQL is healthy before the NWN server starts.
- NWNX_SQL is enabled with `NWNX_SQL_TYPE=MYSQL`.
- `NWNX_SQL_HOST` is the Compose service name reachable by the NWN container.
- The MySQL application user, password and database match the corresponding
  NWNX_SQL settings.
- Both sides use `utf8mb4`; `NWNX_SQL_USE_UTF8=true` remains enabled.
- Production uses its own secrets. Never copy or document DEV credential
  values.

The MySQL initialization helper runs only for an empty data volume. Changing an
environment file does not rewrite users already stored in an existing volume.

## 6. Deployment order

### Existing production database: identity and player state only

These migrations are non-destructive and safe to re-run, but take a backup
first:

```bash
./linux_apply_sql.sh \
  migration/pwdb/01_identity_schema.sql \
  migration/cnr/00_player_state_schema.sql
```

### Catalogue cutover

Only during the approved CNR cutover, after backing up the database:

```bash
python3 migration/build_catalogue.py --check

./linux_apply_sql.sh \
  migration/01_schema.sql \
  migration/02_seed.sql \
  migration/03_catalogue.sql
```

`migration/01_schema.sql` drops and recreates global catalogue tables. It does
not drop PWDB identity, tradeskill progress or character settings.

Run the mandatory focused, non-writing compile before staging. Includes have no
`main()` and are reported as skipped, so verify the changed event and consumer
scripts instead. This example lists the scripts affected by the PWDB/CNR port;
do not replace it with bare `--check`, which compiles all of `src/`:

```bash
./linux_build-dev.sh --check \
  wrap_on_mod_load.nss \
  wrap_on_clnt_ent.nss \
  cnr_a_craft.nss \
  cnr_device_ou.nss
```

Then use the production repository's own build and deployment commands. Do not
reuse the DEV module name or copy `PB_EE_PGCC.mod` into production.

## 7. Verification

Before opening the server to players, confirm:

1. Production's `AGENTS.md` contains the mandatory focused compilation rule,
   and its non-writing check command accepts an explicit script list without
   compiling the whole module.
2. The four persistent tables exist: `pwdb_account`, `pwdb_character`,
   `cnr_tradeskill`, `cnr_character_setting`.
3. `cnr_tradeskill.character_id` and
   `cnr_character_setting.character_id` reference
   `pwdb_character.character_id` with `ON DELETE CASCADE`.
4. The packed module contains `wrap_on_mod_load.ncs`, `wrap_on_clnt_ent.ncs`,
   `cnr_device_ou.ncs` and the PWDB consumer bytecode.
5. Startup logs contain `[PWDB:DB] Identity schema ready` and no
   `Expected MYSQL` message.
6. A normal player login creates or resolves one account and one character;
   seven tradeskill rows load for that character.
7. Craft XP survives a full server restart and another character on the same
   account has independent tradeskill rows.
8. A database outage allows login but prevents crafting persistence, with a
   clear server log; it must not create unowned items or XP.

Do not print CD keys, passwords or player records in deployment reports.

## 8. Rollback

Rollback the module by deploying the previous production artifact. Leave the
four persistent tables in place: they are additive and contain player data.
Catalogue rollback requires restoring the catalogue backup or reapplying the
previous generated catalogue SQL. Never drop `pwdb_*`, `cnr_tradeskill` or
`cnr_character_setting` as part of a code rollback.
