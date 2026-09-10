# Caster level: `pb_nivellanzador.nss`

Status: **partially implemented.** S1 and S2, including level-down remediation,
were implemented on 2026-09-02. S3 onward, the cast gate, the remaining probes
and in-game validation are still open. The concise current-state authority is
[`../rules/caster-level.md`](../rules/caster-level.md).

This is the implementation research record. Sections 1-12 preserve the path by
which the design was reached and contain claims explicitly corrected by later
sections. Read sections 14-15 for the final corrections and section 13 for the
remaining slices; do not use an earlier corrected paragraph as current truth.

This is the review the plan kept deferring:
`spells-and-effects.md` §"Order after the direct families" step 6 —
*"Review `pb_nivellanzador`, spell resistance and dispelling as three separate
high-coupling changes"* — and `changelog/modulo/2026-08.md`,
*"`pb_nivellanzador` still awaits its separate caster-level review."*
Neither ever said what the review would find. This does.

---

## 1. The system as it stands

`src/shared/nss/pb_nivellanzador.nss`, 523 lines, included by **279 files**.

| Function | Call sites | Consumers |
|---|--:|---|
| `GetTotalCasterLevel` | 377 | 328 files; **287 of the calls pass `OBJECT_SELF`** |
| `ChangedElementalDamage` | 31 | 29 |
| `GetChangesToSaveDC` | 23 | 18 |
| `GetCL` | 6 | `elg_aprender_sh`, `inc_sum_golem:375`, `pb_mod_activate:105`, `pjr_on_chat:56` |
| `GetCasterMaxSpellLevel` | 5 | internal, plus `GetCasterCanCast` |
| `GetCasterCanCast` | 1 | `cwa_enforcer.nss:30` — the module spellhook, so it runs on **every PC cast** |

### 1a. There are two authorities for one number, and they are not interchangeable

> **Corrected twice.** §8 corrects the claim that `ArcSpellLvlMod` feeds
> `GetCasterLevel()`. §16 corrects the row counts: the split below ignored
> `UserType`, so the engine-governed set is **20 rows, not 198**.
>
> **Corrected in §8.** The sentence below claiming `ArcSpellLvlMod` feeds
> `GetCasterLevel()` is **wrong**. Those columns govern spell slots only; the
> stock engine adds no prestige caster level at all. Read §8 before acting on
> anything in §1a or §2a.

`classes.2da` columns `ArcSpellLvlMod` and `DivSpellLvlMod` hold the number of
class levels required per +1 caster level (0 = none, 1 = full, 2 = half,
3 = a third). They drive **the engine**: spell slots per day, which circles a
character may prepare or know, item caster level, and what the native
`GetCasterLevel()` returns.

`GetSpecialCasterLevel` in `pb_nivellanzador.nss` holds a hand-written copy of
the same table. It drives **module NWScript only**.

Measured over `spells.2da` rows that are castable by a player class and name an
`ImpactScript`:

| Governed by | Rows |
|---|--:|
| The module number — impact script lives in `src/` | **347** |
| The engine number — impact script is base-game, so it calls `GetCasterLevel()` | **198** |

So neither number is decorative. A divergence between them is a spell that
behaves one way and a spell slot that was granted for another.

---

## 2. Per-class findings

Verified against `haks-2da/classes.2da`, against the stock `classes.2da`
extracted from the installed game with `nwn_resman_extract`, and against each
class's own in-game description resolved from `tlk/pb_tlk_v6.tlk.json`.

| Row | Class | `classes.2da` | Script | Class description says | Decision |
|--:|---|---|---|---|---|
| 53 | Archimago | `arc=2` half | full | **full**, every level | **full** — 2DA is wrong |
| 34 | Maestro de la lividez | `arc=1` full | level − 1 | full (no exception clause) | **level − 1** — 2DA and description are wrong |
| 45 | Caballero arcano | `arc=1` full | level − 1 | full (no exception clause) | **level − 1** — 2DA and description are wrong |
| 28 | Agente Custodio (Arcano) | `arc=1` full | level − 1 | **"excepto en su primer nivel"** | **level − 1** — 2DA is wrong |
| 54 | Agente Custodio (Divino) | `div=1` full | level − 1 | as above | **level − 1** — 2DA is wrong |
| 37 | Discípulo de dragón | `arc=2` half | **absent** | — | **none** — 2DA is wrong, set to 0 |
| 47 | Siervo de la Muerte | `div=3` third | full | "cada tres niveles" | **remove the class** |
| 51 | Asolador | `div=1` full | never summed to druid | — | **remove the class** |
| 43 | Bribón arcano | `arc=1` full | full | — | agree, no change |
| 46 / 55 | Adepto Sombrío (Arcano/Divino) | `1` full | full | — | agree, no change |
| 48 | Teúrgo Místico | `arc=1 div=1` | full | — | agree, no change |

The two Agente Custodio rows and the two Adepto Sombrío rows are not
duplicates: each pair is the arcane and the divine variant, so a base arcane or
a base divine caster can take the same prestige class. Same for the Teúrgo,
which carries both columns at once.

### 2a. The `−1` rule cannot be written in `classes.2da` at all

`ArcSpellLvlMod` is a **divisor**, not an offset. `1` gives 10 caster levels
over 10 class levels and `2` gives 5. There is no value that gives 9. So for the
Maestro de la lividez, the Caballero arcano and both Agente Custodio rows the
engine and the module **cannot** be made to agree through the 2DA.

Three ways out, in ascending cost:

- **(a) Accept the gap.** Leave the 2DA at full and the script at `−1`. The
  divergence is exactly one caster level, on four classes, and only for the 198
  engine-governed spell rows. Costs nothing, is permanent, is a lie in the data.
- **(b) `NWNX_Creature_SetCasterLevelModifier(oPC, nBaseClass, -1)`.** Applied
  when the character has levels in one of those four, re-applied on load and on
  level-up. Engine and module then agree exactly. The plugin call exists in the
  pinned submodule (`Plugins/Creature/NWScript/nwnx_creature.nss:602`) and the
  module already vendors the header at `src/shared/nss/nwnx_creature.nss:602`;
  nothing in `src/` calls it yet. Modifiers are per class, so a character with
  two of these four needs `−2` and the code has to count them.
- **(c) Drop the `−1`** and make the four full-progression. Cheapest code, but
  it is a balance change and contradicts the Agente Custodio's published text.

**Not decided.** See §5.

### 2b. Archmage: 3.5, the class page and the script all agree; only the 2DA does not

D&D 3.5 (DMG, Archmage): *"When a new archmage level is gained, the character
gains new spells per day (and spells known, if applicable) as if he had also
gained a level in whatever arcane spellcasting class in which he could cast
7th-level spells before he added the prestige class level."* Every level, full
progression, arcane only.

The module's own class description says the same: *"cuando se obtiene un nuevo
nivel de Archimago, el personaje gana nuevos conjuros al día como si hubiera
adquirido un nivel en su clase de lanzador."*

`classes.2da` row 53 says `ArcSpellLvlMod = 2`. That is the only source that
says half, and it is the one the engine reads. **Set it to 1.**

The description adds a caveat the script does not implement: *"Debido a fallos y
limitaciones del NwN, sólo se beneficiará el mago de esta mejora."* The script
adds the Archmage to both the `CLASS_TYPE_WIZARD` and the
`CLASS_TYPE_SORCERER` branches. Open question in §5.

### 2c. Spell Power is not free, and the earlier open probe is closed

`cls_bfeat_arch.2da` grants **one bonus feat at each of class levels 1–5** and
nothing after. `cls_feat_arch.2da` offers nine `List=2` entries — Mastery of
Shapes, Spell Power I–V, Arcane Fire, Spell-Like, Mastery of Elements — plus one
`List=3 GrantedOnLevel=1` auto-grant. Those nine are the "Gran Arcano" list from
the class page.

`feat.2da` chains Spell Power: 1427 requires 1426, 1428 requires 1427, and so on
to 1430. So **+5 caster level costs all five Gran Arcano picks**: an archmage who
takes it has no Arcane Fire, no Mastery of Shapes, no Mastery of Elements and no
Aptitud Sortílega. That is the 3.5 trade and it needs no correction.

This closes the probe left open on 2026-09-01 ("does the Archmage's bonus slot
offer the general feat list?"). It does not: a bonus slot offers only `List=1`
or `List=2` rows of the class table, and the table has exactly those nine.

---

## 3. Defects independent of the progression question

**D1 — `GetCL` counts levels twice.** `case CLASS_TYPE_WARLOCK`,
`case CLASS_TYPE_FAVORED_SOUL` and `case CLASS_TYPE_INGENIERO` each do
`iCasterLevel += iLevel;` and then `iCasterLevel += GetLevelByClass(<same
class>);`. `iLevel` is already that class's level. A warlock 20 gets 40.
Separately, `BARD`/`SORCERER`/`WIZARD` share one block and the loop runs once per
class position, so a Wizard/Sorcerer/Pale Master adds the Pale Master twice.

**D2 — `GetTotalCasterLevel(OBJECT_SELF)` returns 0 inside an area of effect.**
`OBJECT_SELF` is the AoE object. `GetLastSpellCastClass()` still returns the
creator's class (`nwscript.nss:11065`), so the switch matches the right case and
then reads `GetLevelByClass(WIZARD, oAoE)` = 0. The `default:` branch, the only
one that would have called `GetCasterLevel()` and got the right answer, is never
reached. Cross-referencing the 91 `ONENTER`/`ONEXIT`/`HEARTBEAT` scripts in
`vfx_persistent.2da` finds exactly two hits, both the same spell:
`nw_s0_evardsa.nss:47` and `nw_s0_evardsc.nss:49`, where
`nTentaclesPerTarget = d4() + nCasterLevel` — Evard's Black Tentacles grapples at
`d4 + 0` instead of `d4 + 20`. The other eight `(OBJECT_SELF)` calls inside
`nw_i0_spells` and `x0_i0_spells` are in impact helpers where `OBJECT_SELF` is
genuinely the caster.

**D3 — Spell Power applies through items.** Lanzador Veterano and the Elixir are
both gated on `GetSpellCastItem() == OBJECT_INVALID`; `nSpellPowerLevels` is
added unconditionally at the end, so an archmage gets +5 caster level on a wand
or a scroll. It is also added for divine casting and for warlock invocations.

**D4 — `iBaseClass != 0` does not mean "has a class".** `0` is
`CLASS_TYPE_BARBARIAN`; the absent value is `CLASS_TYPE_INVALID` = 255. The
guard blocks the two feat bonuses for barbarians and lets them through when the
class is genuinely unknown, which is the opposite of the intent.

**D5 — `GetCasterMaxSpellLevel` off-by-one for the sorcerer.**
`nMax = FloatToInt(nCasterLevel/2.0f)` gives 0 at class level 1, so
`GetCasterCanCast` rejects every 1st-circle spell for a level-1 sorcerer with
*"Este conjuro es de nivel demasiado alto para ti."* Cantrips still pass. Levels
2–18 are correct. **Needs confirming in play before it is treated as real** — it
is visible enough that someone should have reported it.

**D6 — bard exceeds his own maximum.** `(n+2)/3` gives 7 at caster level 19–20
and the bard tops out at the 6th circle. Harmless today because `spells.2da` has
no bard 7th-circle row; the `if(nMax > 9)` clamp does not catch it.

**D7 — the anti-cheat gate is inert for six classes.**
`case CLASS_TYPE_INGENIERO:` in `GetCasterMaxSpellLevel` is **empty**, so the
artífice falls through to `nMax = 9`; combined with `GetCasterCanCast` mapping
the artífice to the `Wiz_Sorc` column, a level-1 artífice passes the gate for a
9th-circle spell. Brujo, Asesino, Guardia negro, Soldado de la Luz and Alma
Predilecta are absent from the switch entirely and get the same 9.

**D8 — the `Dotes = FALSE` path is dead.** No caller in the repository passes
it; the only call is the internal one in `GetCasterMaxSpellLevel`, and
`cwa_enforcer` uses the `TRUE` default. Effect: Lanzador Veterano (+4) and the
Elixir (+4) raise the maximum circle the gate allows. A wizard 14 (circle 7)
with Veterano passes as caster level 18, so circle 9.

**D9 — dead code.** Nine of the thirteen `case` labels in
`GetSpecialCasterLevel` and its `default:` are unreachable: every call site
names a literal constant, and only Lividez, Caballero arcano, Agente Custodio
×2, Adepto Sombrío ×2, Archimago and Teúrgo are ever passed. Eight cases are
literally `fCasterLevel = fCasterLevel;`. Eight
`//iCasterLevel = GetCasterLevel(oCharacter);` lines record that this file once
delegated to the engine.

**D10 — three unused includes, paid by 279 consumers.** `nwnx_creature` (only
the two commented `NWNX_Creature_GetClericDomain` lines), `inc_sqlite_time`
(nothing) and `x2_inc_switches` (no symbol). **Do not remove them without a full
build first**: a consumer may be relying on the transitive include.

**D11 — cost per PC cast.** `cwa_enforcer` runs `GetCasterCanCast` and then
`GetTotalCasterLevel(OBJECT_SELF)` again at line 41, so the caster level is
computed twice. Each pass is up to five `GetHasFeat`, seven `GetLevelByClass`,
one `GetHitDice` and two `Get2DAString("feat","MinLevelClass")`. A cleric adds
up to eighteen more `Get2DAString` in the domain loop.

**D12 — style.** No `@system/@file/@author/@brief` header; the file opens on
`/// modified by: Dhraax`. `GetCasterCanCast` has no prototype. The prototype
and the definition of `GetTotalCasterLevel` disagree in text
(`int iBaseClass = 255` against `int iBaseClass = CLASS_TYPE_INVALID`). `int
Dotes` has no type prefix while its sibling uses `iDotes`. No prototype carries
`@brief`/`@param`/`@returns`.

---

## 4. Decisions taken — 2026-09-02

These are the owner's, recorded verbatim in intent so they are not re-litigated.

1. **The order of the three bonuses is correct as written.** Lanzador Veterano
   is capped at hit dice; the Elixir and Spell Power are deliberately applied
   *after* that cap and are meant to exceed it. Only Veterano has a cap.
2. **Spell Power is arcane only.** It must stop applying to divine casting and
   to warlock invocations, and — per D3 — to item casts.
3. **Archimago: full progression.** `classes.2da` row 53 `ArcSpellLvlMod` goes
   from `2` to `1`.
4. **Maestro de la lividez, Caballero arcano, Agente Custodio ×2: the script
   wins**, `level − 1`. How the engine is brought into line is still open (§2a).
5. **Discípulo de dragón: the script wins** — no arcane advancement.
   `classes.2da` row 37 `ArcSpellLvlMod` goes from `2` to `0`.
6. **Siervo de la Muerte (Thrall of Orcus) is removed.** Not disabled — removed.
7. **Asolador (Blighter) is removed.** This supersedes the standing instruction
   that nothing named `blig_` may be touched; that rule stands for every other
   purpose and only this removal is exempted.
8. **Brujo** manages its own caster level for invocations. It has no spellbook
   today and will have one later, so it must be computed properly rather than
   left out.
9. **Asesino**: its spells should scale like any other caster; only its save DC
   is computed differently and that conditional stays.
10. **Guardia negro no longer exists as a player class**; it was replaced by
    Paladín Oscuro (row 61), a paladin-based class. **Soldado de la Luz no
    longer exists**; it was replaced by Caballero de Luz (row 60), also
    paladin-based. Neither replacement is a prestige class.
11. **Alma Predilecta** is the divine variant of the sorcerer: it scales like a
    sorcerer but from the cleric spell list.
12. **The anti-cheat gate should be as broad as it can safely be** rather than
    covering only the nine classes it covers now.

### 4a. Removal scope for the two deleted classes

`PlayerClass = 0` is already set on both rows, so neither is selectable today
and neither removal is a balance change.

| | Asolador (51) | Siervo de la Muerte (47) |
|---|---|---|
| `.nss` files naming it | 7 — `cwa_enforcer`, `glt_blig_spellch`, `glt_blig_ushape`, `nw_s0_incclouda`, `nw_s0_inccloudc`, `pb_constantes`, `pb_nivellanzador` | 22 — `pb_constantes`, `pb_nivellanzador`, `pb_ip_slots_inc`, `x0_i0_spells`, seven `prc_to_*`, ten `conv_*` |
| 2DA files naming it | 11 — `classes`, `cls_feat_blig`, `feat`, `spells`, `polymorph`, `appearance`, `portraits`, `tailmodel`, `iprp_onhitspell`, `des_crft_spells`, `mti_crft_scroll` | 5 — `classes`, `cls_pres_orcus`, `appearance`, `portraits`, `tailmodel` |
| Creature blueprints with levels in it | **0** | **1** — `s_nightwings.utc.json` |

For contrast, and as a warning against widening the scope: **Guardia negro has
19 creature blueprints with levels in it** (`babau`, `blor`, `blor001`, …), so
its row must stay even though no player can take it. `Soldado de la Luz` has 0.

**Owner action before either removal:** confirm no live character in the MySQL
vault has levels in row 47 or row 51. Nothing in this repository can answer
that.

---

## 5. Open questions

1. **§2a — how the four `−1` classes are reconciled**: accept the one-level gap
   (a), drive it with `NWNX_Creature_SetCasterLevelModifier` (b), or drop the
   `−1` (c).
2. **Archmage and the sorcerer.** The class page says only the wizard benefits
   from the caster-level advance; the script adds it to the sorcerer too. Is the
   page a real restriction or an obsolete NWN caveat?
3. **The class descriptions for Maestro de la lividez and Caballero arcano** say
   full progression with no exception clause, while the decision is `level − 1`.
   Do the TLK descriptions get corrected?
4. **D5** — is the level-1 sorcerer actually blocked in play?
5. **How broad is "as broad as it can safely be"** for the gate (D7)? Every
   spell-casting class has a `SpellTableColumn` in `classes.2da`
   (`Warlock`, `Assassin`, `Blackguard`, `Soldado_Luz`, `Cleric` for Alma
   Predilecta, `Wiz_Sorc` for the artífice), so a data-driven gate is possible;
   what it must *not* do is start rejecting casts that work today.
6. **Do Brujo and Artífice belong in `GetCasterMaxSpellLevel` at all**, given
   invocations and infusions are feats rather than memorised spells?

---

## 6. Verification owed

Nothing here has been compiled, built, packaged or observed in play. No `.nss`
was modified, so the mandatory focused compilation does not apply to this
document.

When implementation starts, each slice needs: the focused
`./linux_build-dev.sh --check` for its scripts, a changelog entry in the same
commit, and — for anything touching `classes.2da` — a hak repack, which is the
owner's.

---

## 7. What CoW does, read 2026-09-02

**Provenance.** `cow-scripts/` is the reference module's source, placed at the
repository root by the owner and ignored by `.gitignore`, so nothing below can be
re-derived from a checkout of this repository. Line numbers are from that working
copy on 2026-09-02.

The earlier verdict on CoW — *"nothing, it is not a reference here"*, in
`spells-and-effects.md` — was about **saving throws**, where CoW runs stock
BioWare code and has no answer. Caster level is the opposite case: CoW has a
designed subsystem and PDB has already imported half of it.

### 7a. The one structural difference

`AR_GetCasterLevel` in `cow-scripts/inc_customspells.nss:336` opens with:

```nwscript
int nCasterLevel = GetCasterLevel(oCaster);
```

**The base is the engine's number and the module only adds deltas.** Pale Master
(half class level), Harper (five paths, each with its own rule), Shadow Mage,
plus two open bonus channels, then `if (nCasterLevel < 0) nCasterLevel = 0;`.

PDB rebuilds the base from `GetLevelByClass` and never asks the engine. That is
precisely why §1a's two authorities can drift: in CoW they cannot, by
construction, because there is only one base and the 2DA owns it.

**The limit of copying this.** `GetCasterLevel()` returns 0 outside a spell
context. Of the 327 files calling `GetTotalCasterLevel`, **296 are named by
`spells.2da` or `vfx_persistent.2da`** and 31 are not — conversations
(`conv_*`), `x2_pc_umdcheck`, `cerr_setsplev`, `pb_mod_activate`, `cab_amo2`.
CoW keeps a separate function for that case,
`GetGreatestSpellCasterLevel` (`inc_spells.nss:1137`), and it takes the
**highest** casting class rather than the sum. PDB's `GetCL` sums them, which is
the deeper reason it is wrong beyond the double-count in D1.

So the shape CoW implies is **two functions with two contracts**: one that
answers "the caster level of the spell being cast right now" and needs a spell
context, and one that answers "how strong a caster is this character" and does
not. PDB has both functions already and neither honours its contract.

### 7b. Layers PDB has no equivalent for

| CoW | Where | What it buys |
|---|---|---|
| `GetCasterLevelOverride(oCreature, nSpellId)` | `inc_spells.nss:1019` | Per-spell caster level, checked **first** and short-circuiting everything |
| `SetTemporaryCasterLevelBonus` | `:2128` | A transient channel that any effect can raise and clear |
| `AR_GetCasterLevelBonus` | `:3222` | The design channel — their Piety and spirit-pact rules. Not transferable; the *separation* is |
| item `SPELL_CAST_LEVEL` under `STATIC_LEVEL` | `inc_customspells.nss:346` | An item states its own caster level instead of inheriting the user's |
| `GetIsLastSpellCastSpontaneous()` → `GetSpontaneousSpellClass()` | `:353` | Sorcerer and bard resolve to the class they actually cast from |
| `miSPGetLastSpellArcane(oCaster)` | `:327` | **The arcane/divine test decision 4.2 needs.** Three lines |
| `GetIsSpellCastClass(nClass)` | `inc_spells.nss:1350` | `Get2DAString("classes","SpellCaster",nClass)` — the data-driven class test D7's gate needs |

CoW makes **zero NWNX calls** for caster level. Everything is locals and 2DA
reads.

### 7c. PDB imported the write half of CoW's AoE design and left the read half

`inc_spellaoe.nss` is a port of CoW's AoE library, down to the local key
`LIB_SPELLS_PREFIX + "AoECasterLevel"`. `gsSPCreateNonStackingPersistentAoE`
computes the caster level at creation, while `OBJECT_SELF` is still the caster,
and stamps it on the AoE:

    inc_spellaoe.nss:536   int iCasterLevel = GetCasterLevel(oCreator);
    inc_spellaoe.nss:860   gsSPSetAoECasterLevel(oAoE, iCasterLevel);
    inc_spellaoe.nss:861   gsSPSetAoECastClass(oAoE, iCasterClass);
    inc_spellaoe.nss:862   gsSPSetAoEMetaMagic(oAoE, iMetaMagic);

**All three are setters with no getter.** Nothing in `src/` reads any of the
three locals. CoW has `GetAoECasterLevel` (`inc_spells.nss:800`),
`GetAoECastClass` (`:783`) and `GetAoEMetaMagic` (`:873`), and its AoE scripts
use them — `nw_s0_healcircc.nss:36` is `int nCasterLevel = GetAoECasterLevel();`.

Two consequences, both measured:

**Caster level.** Only Evard's reads it wrongly (D2), because the other AoE
scripts use the correct `GetTotalCasterLevel(GetAreaOfEffectCreator())` —
`nw_s0_wallfirea.nss:88` for instance. But that call recomputes on every
heartbeat against the creator's *current* state: it reads
`GetLastSpellCastClass()`, which is the creator's **most recent** cast rather
than the one that made the area, and it collapses to 0 when the creator logs out
or dies, since `GetLevelByClass(nClass, OBJECT_INVALID)` is 0. A wall of fire
whose caster leaves drops to a flat `4d6`. The stamped value is the only stable
one.

**Metamagic.** `GetMetaMagicFeat()` is documented as *"the metamagic type of the
last spell cast by the caller"* (`nwscript.nss:7262`) and an AoE object never
cast anything. **Thirteen AoE scripts read it from inside the area**:
`nw_s0_acidfoga`, `acidfogc`, `bladebara`, `bladebarc`, `cloudkilla`,
`cloudkillc`, `delfirea`, `evardsa`, `evardsc`, `greasea`, `incclouda`,
`inccloudc`, `wallfirea`. If it returns `-1` there, then **Maximize and Empower
have never applied to any area spell's ticks**. CoW concluded exactly this and
wrote `AR_GetMetaMagicFeat` (`inc_customspells.nss`) to dispatch on
`GetObjectType(OBJECT_SELF) == OBJECT_TYPE_AREA_OF_EFFECT`.

This is **not established here** — it is inferred from the engine comment and
from CoW's authors having bothered. It is cheap to settle in play: cast an
Empowered Cloudkill and compare a tick against an unempowered one. Do that
before anything is written.

### 7d. `ExecuteScriptAndReturnInt` as the dependency break

`_Spells_GetCasterLevel` (`inc_spells.nss:2859`) is
`ExecuteScriptAndReturnInt("exe_casterlevel", oCreature)`, and
`exe_casterlevel.nss` is four lines wrapping `AR_GetCasterLevel()`. It exists so
the AoE library can ask for a caster level without including the spell library,
and it has the side effect of evaluating with `oCreature` as `OBJECT_SELF`.

Noted, not recommended. PDB retired four `ExecuteScriptAndReturnInt` hooks in
August for the cost of loading and running a compiled script per call; this would
add one back. It is only worth it if an include cycle turns out to be otherwise
unbreakable.

### 7e. What this changes in the questions

§5 question 1 asked how the four `−1` classes are reconciled. CoW's answer is a
fourth option that was not on the list:

**(d) Keep `classes.2da` as the only progression table and express `−1` as a
delta.** The 2DA says full for Lividez, Caballero arcano and both Agentes
Custodios; `GetTotalCasterLevel` starts from `GetCasterLevel()` and subtracts one
per such class the character has. Engine and module still differ by one for the
198 engine-governed rows — the same residue as option (a) — but there is only
**one** progression table in the repository and the deviation is a visible line
of code rather than a second copy of the data.

Option (b), the NWNX modifier, remains the only one where the two numbers are
equal. CoW does not use it.

---

## 8. Correction: what the engine actually does, read 2026-09-02

CoW predates most of this. §7 stands as a description of CoW, but three of the
things it praises have since become engine behaviour, and §1a and §2a were
written on a wrong premise. This section supersedes them.

The server runs `nwnxee/unified:build8193.37` (`docker-compose.yml:3`,
`docker-compose-dev.yml:3`).

### 8a. `ArcSpellLvlMod` does not feed `GetCasterLevel()`. It never did.

Beamdog's own column documentation for `classes.2da`:

- **`ArcSpellLvlMod`** — *"Specifies the number of levels in this class that
  together add one level to an arcane class when determining the **spell slots**
  based on class level."* It *"does not add on any known spells and does **not**
  automatically increase caster level."*
- **`DivSpellLvlMod`** — the divine equivalent.
- **`CLMultiplier`** — *"Caster Level multiplier. It is applied to the
  `GetCasterLevel` function and the default caster level applied to effects. The
  value is turned into an integer so is essentially floored."*
- **`SpellCaster`** — *"If you set to 1, this will prevent the `DivSpellLvlMod`
  and `ArcSpellLvlMod` from working. Set to 1 for a custom class with its own
  spell list."*

So the engine has **no mechanism at all** for "a prestige class advances another
class's caster level". `CLMultiplier` scales one class by a factor; it cannot
borrow levels from a sibling class. That is why NWNX ships an opt-in tweak for
exactly this, `Plugins/Tweaks/AddPrestigeclassCasterLevels.cpp`, hooking
`ExecuteCommandGetCasterLevel`, `ExecuteCommandResistSpell` and
`CGameEffect::SetCreator`.

**That tweak is not enabled here.** `config/nwserver.env` and
`config/nwserver-dev.env` set six `NWNX_TWEAKS_*` keys and
`ADD_PRESTIGECLASS_CASTER_LEVELS` is not among them; the plugin default is
`false`.

**The consequence is larger than §1a said.** For the 198 base-game spell rows,
prestige classes contribute **nothing** — not half, not `level − 1`, zero. A
Wizard 15 / Archimago 5 with Spell Power V casts a module-scripted spell at
caster level **25** and `nw_s0_barkskin` at caster level **15**. Eighteen
base-game impact scripts in `src/` read `GetCasterLevel(OBJECT_SELF)` directly
for durations and damage, and the 198 rows whose script is not in `src/` do the
same inside the game's own data.

**The two authorities are therefore not two copies of one table.** The 2DA says
how many slots a character gets; the script says what caster level the spell
runs at. They are allowed to differ in kind. What they may not do is disagree
about intent, and the class descriptions in §2 are the statement of intent.

**Sanity check performed:** no class in `haks-2da/classes.2da` has
`SpellCaster = 1` together with a non-zero `ArcSpellLvlMod`/`DivSpellLvlMod`, so
no prestige progression is being silently cancelled by that rule.

### 8b. The NWNX tweak rounds up, and double-counts hybrids

If the tweak were switched on, the formula is
`(nClassLevel - 1) / nClassMod + 1` — a **ceiling**, not the floor assumed in
§1a. With `ArcSpellLvlMod = 2` a Maestro de la lividez gets +1 at class levels
1, 3, 5, 7 and 9: five over ten, but **granted from the first level**. With
`= 3`, ten levels give **four**, not three.

More important, `GetClassLevelHook` loops over *every* other class the character
has and adds the modifier to **each** caster class of the matching type. A
Wizard 10 / Sorcerer 5 / Archimago 5 would get the five archmage levels added to
the wizard **and** to the sorcerer. 3.5 requires the character to pick one class
to advance. This is the hybrid failure mode, and **PDB's script has the same
shape**: both the `CLASS_TYPE_WIZARD` and the `CLASS_TYPE_SORCERER` branches of
`GetTotalCasterLevel` add `GetSpecialCasterLevel(CLASS_TYPE_ARCHMAGE)`.

`GetCL` is worse and is already recorded as D1: for a Cleric / Druid / Teúrgo
its `CLERIC` case and its `DRUID` case each add the Teúrgo, so the prestige
levels land twice in one call.

### 8c. `CLMultiplier` is blank for the Brujo

8193.36: *"Caster level calculations are now made consistent across the engine
including using the Caster Level Multiplier."*

Every class in `haks-2da/classes.2da` with `SpellCaster = 1` carries
`CLMultiplier = 1.0` and `MinCastingLevel = 1` or `4` — **except row 57,
Warlock**, which has `****` in `CLMultiplier`, `MinCastingLevel` **and**
`CanCastSpontaneously`. Bard, Cleric, Druid, Paladin, Ranger, Sorcerer, Wizard,
Assassin, Blackguard, Soldado de la Luz, Alma Predilecta, the three paladin
variants and the Artífice are all filled in. The Warlock row is the only hole.

What the engine does with a blank multiplier is **not established**. If it reads
as `0.0`, every engine-side caster level for a warlock — effect durations, the
dispel check, spell resistance, any base-game spell — is zero. PDB's script
hides this for module spells because `GetTotalCasterLevel` hardcodes
`iCasterLevel = GetLevelByClass(CLASS_TYPE_WARLOCK, oCharacter)` for that class
and never consults the engine.

**This needs a probe before anything else in this document is acted on**, and it
is cheap: a warlock, an invocation with a caster-level-scaled duration, and a
comparison against a wizard of the same level. If it is zero, filling the three
cells is a one-line 2DA fix and a hak repack.

### 8d. 8193.36 made three of CoW's inventions redundant

| CoW hand-rolled | Engine now |
|---|---|
| `SetAoECasterLevel` / `GetAoECasterLevel` | *"Area of Effect objects now consistently store and retrieve their caster level and spell ID"*; *"Area of Effect scripts now use the spell ID and caster level that was stored when the AOE was created."* `GetCasterLevel(oAoE)` returns the creation caster level (`nwscript.nss:7173`) |
| `GetAoECastClass` | *"`GetLastSpellCastClass()` returns the AOE creator's class in AOE scripts"* (`nwscript.nss:11065`) |
| Effect caster level bookkeeping | New natives `SetEffectCreator()`, `SetEffectSpellId()`, `SetEffectCasterLevel()`, `GetEffectCasterLevel()`; *"`EffectDispelMagic()` … will always utilize stored caster level"*; *"Fixed effect caster level not being included in save games"* (8193.35: *"Fixed effects incorrectly setting creator, caster level and spell ID"*) |

**This retires §7c's recommendation.** The three PDB setters
(`gsSPSetAoECasterLevel`, `gsSPSetAoECastClass`, `gsSPSetAoEMetaMagic`) do not
need matching getters; they need **deleting**, because the engine keeps the same
three facts itself and keeps them across a save. `inc_spellaoe.nss:382` already
reads `GetCasterLevel(oAoE)` the modern way, so the file carries both the CoW
port and its replacement.

The Evard's defect (D2) is then a one-line fix in the two scripts, not a library
change.

**Metamagic is the exception.** The 8193.36 notes cover spell id and caster
level and say nothing about metamagic, so the thirteen AoE scripts listed in §7c
are still unaccounted for and `gsSPSetAoEMetaMagic` may be the only one of the
three worth keeping. The in-play probe proposed there stands.

### 8e. Natives PDB is not using yet

| Native | `nwscript.nss` | PDB uses |
|---|--:|--:|
| `SetEffectCreator` | 13593 | 3 |
| `SetEffectSpellId` | — | 2 |
| `SetEffectCasterLevel` | 13598 | 1 |
| `GetEffectCasterLevel` | 11786 | **0** |
| `SpellResistanceCheck` | 13827 | **0** |
| `GetSpellAbilityCasterLevel` | 13631 | **0** |
| `GetSpellAbilityCount` | — | **0** |
| `ActionCastSpellAt*` with `nClass` / `bSpontaneousCast` | — | **0** |

Two of these bear on work already recorded elsewhere:

- **`SetEffectSpellId` answers the "`-1` spell id problem that no list can
  solve"** in `../rules/bonus-stacking.md`. An effect can be given a spell id
  explicitly. `inc_effects.nss:115` already does it once.
- **`SpellResistanceCheck(oTarget, oCaster, nSpellId, nCasterLevel, ...)`** takes
  the caster level as a parameter, which is the shape `MyResistSpell` needed and
  never had.

### 8f. What this changes in the options

§2a offered (a) accept the gap, (b) NWNX modifier, (c) drop the `−1`, and §7e
added (d) a delta over the engine's number. §8a adds:

- **(e) `NWNX_TWEAKS_ADD_PRESTIGECLASS_CASTER_LEVELS=true`.** One environment
  variable makes the engine read the same Arc/Div columns for caster level, so
  the 198 base-game rows stop ignoring prestige classes. It costs a server
  restart and no code. But it **cannot express `level − 1`** (ceiling only), it
  **double-counts arcane hybrids** (§8b), and if the script keeps adding the same
  levels on top, every module spell doubles them. Turning it on is not additive
  with the current script — it replaces part of it.

Options (d) and (e) are now the two coherent ends: either the module owns
prestige caster level entirely and the engine's number is only ever a base, or
the engine owns it and the module stops. Mixing them is what produces the
hybrid errors.

---

## 9. Settled from local 2DA data, 2026-09-02

The owner's local `Content/2da/vanilla/` corpus holds 601 read-only 2DA files
extracted from a vanilla NWN:EE **8193.37** install — the same build the server
runs — and `Content/cow_2da/` holds CoW's. `Content/` is ignored by Git, so these
comparisons are not reproducible from a clean checkout and cannot stand as the
sole evidence for a new canonical claim. They remain the provenance of this
implementation record.

### 9a. Confirmed locally

**The Brujo's blank `CLMultiplier` is a project deviation, not a vanilla
pattern.** In `Content/2da/vanilla/classes.2da`, **every** row with
`SpellCaster = 1` carries `CLMultiplier = 1.0` and a `MinCastingLevel`; **not one
is blank**. PDB's row 57 is the only `SpellCaster = 1` row in either file with
`****` in that column. §8c stands, and the probe it asks for is still the way to
learn what the engine does with the blank — the 2DA can only show that nobody
else leaves it blank.

**Vanilla Pale Master has `Arcane = ****`; PDB set it to `1`.** Harmless — the
NWNX tweak reads `Arcane` only on `SpellCaster = 1` rows, so on a prestige class
it decides nothing — but it is a difference from the baseline and worth knowing
when reading the row.

**CoW's `classes.2da` has no `Arcane` column at all.** Its header predates the
8193.9 custom-spellcaster work. That is the concrete form of "CoW predates most
of this": its caster-level design was written for an engine that had none of
`CLMultiplier`, `MinCastingLevel`, `SpellTableColumn`, `CanCastSpontaneously` or
the AoE caster-level storage.

**`ruleset.2da` has nothing to do with caster level.** PDB ships one
(`haks-2da/ruleset.2da`, 525 rows against vanilla's 522) and it differs from
vanilla in **fifteen rows**, none of them about spellcasting: haste dodge AC
4→1, item max charges 50→250, turn resistance affecting PCs 0→1, seven skill
durations 4.5→8.5, hide-in-plain-sight cooldown 0→6, epic weapon focus 2→1,
flurry of blows to-hit −2→0, plus three appended chargen colour rows. Recorded
so nobody looks there again.

One row is worth noting for the saving-throw work rather than this one:
`SPELLCRAFT_NUM_RANKS_PER_SAVE_BONUS = 5`, unchanged from vanilla. That is the
engine's own statement of the ratio `spells-and-effects.md` had to establish by
other means.

### 9b. D5 is real, and the data proves it

`Content/2da/vanilla/cls_spgn_sorc.2da`, row 0 — class level 1:

    Level  NumSpellLevels  SpellLevel0  SpellLevel1
    1      2               5            3

**A sorcerer has three 1st-circle slots at class level 1.**
`GetCasterMaxSpellLevel` computes `FloatToInt(1 / 2.0f)` = `0`, the `nMax < 1`
clamp leaves it at `0`, and `GetCasterCanCast` therefore rejects every one of
them with *"Este conjuro es de nivel demasiado alto para ti."* Cantrips pass.

Alma Predilecta uses the same `SpellGainTable` (`CLS_SPGN_SORC`), so it inherits
the same block at class level 1.

Still worth one in-play confirmation before the fix, because it is visible enough
that somebody should have reported it — but it is no longer an inference.

### 9c. D6 and D7 are worse than stated, and the tables give the fix

Reading the highest non-`****` `SpellLevelN` column at class level 21:

| Class | `SpellGainTable` | Real max circle | What the gate allows today |
|---|---|--:|--:|
| Bard | `CLS_SPGN_BARD` | **6** | 7 at caster level 19–20 |
| Artífice | `CLS_SPGN_ING` | **6** | **9** — empty `case` |
| Asesino | `CLS_SPGN_ASASIN` | **4** | **9** — absent from the switch |
| Soldado de la Luz | `CLS_SPGN_SOLDLUZ` | **4** | **9** — absent |
| Guardia negro | `CLS_SPGN_BLKGRD` | — | **9** — absent |
| Brujo | `CLS_SPGN_WARLOK` | — | **9** — absent |
| Wizard | `CLS_SPGN_WIZ` | 9 | 9 ✓ |

The artífice is the sharp one: `GetCasterCanCast` maps him to the `Wiz_Sorc`
column of `spells.2da` **and** `GetCasterMaxSpellLevel` gives him 9, so the gate
approves any wizard spell up to the 9th circle for an artífice of any level,
while his own table stops at the 6th.

**The fix is data, not arithmetic.** Every casting class in
`haks-2da/classes.2da` names both a `SpellGainTable` and a `SpellTableColumn`:

| Class | `SpellGainTable` | `SpellTableColumn` |
|---|---|---|
| Bard | `CLS_SPGN_BARD` | `Bard` |
| Cleric | `CLS_SPGN_CLER` | `Cleric` |
| Druid | `CLS_SPGN_DRU` | `Druid` |
| Paladin / Antiguos / Oscuro / Vengador | `CLS_SPGN_PAL{,A,O,V}` | `Paladin{,Antiguos,Oscuro,Vengador}` |
| Ranger | `CLS_SPGN_RANG` | `Ranger` |
| Sorcerer / Wizard / **Artífice** | `CLS_SPGN_{SORC,WIZ,ING}` | `Wiz_Sorc` |
| **Assassin** | `CLS_SPGN_ASASIN` | `Assassin` |
| **Blackguard** | `CLS_SPGN_BLKGRD` | `Blackguard` |
| **Soldado de la Luz** | `CLS_SPGN_SOLDLUZ` | `Soldado_Luz` |
| **Warlock** | `CLS_SPGN_WARLOK` | `Warlock` |
| **Alma Predilecta** | `CLS_SPGN_SORC` | `Cleric` |

The hardcoded switch in `GetCasterCanCast` reproduces the `SpellTableColumn`
mapping exactly for the eleven classes it covers, and the four it omits —
Warlock, Assassin, Blackguard, Soldado de la Luz — are precisely the ones whose
column exists but is not wired. Both functions collapse to:

```
column = Get2DAString("classes", "SpellTableColumn", nClass)
maxCircle = highest N with a value in Get2DAString(gainTable, "SpellLevel"+N, row)
```

This closes §5 question 5 — *"how broad is as broad as it can safely be?"* — with
an answer that cannot start rejecting a cast that works today, because it is
reading the same table the engine used to grant the slot.

### 9d. The gate needs slot level, not caster level — and that is what `Dotes` was for

The gain table is indexed by the level that **grants slots**, which is class
level plus the prestige advancement `ArcSpellLvlMod`/`DivSpellLvlMod` computes.
It is **not** the module's caster level: Lanzador Veterano, the Elixir and Spell
Power raise the caster level and must not raise the circle a character may cast.

That is exactly the distinction the dead `Dotes = FALSE` parameter (D8) was
reaching for and never got, because nothing ever passed it. The replacement is
not a boolean on `GetTotalCasterLevel` but a third quantity with its own name.

So the file needs **three** numbers, not two:

| Answers | Used by | Includes |
|---|---|---|
| The caster level of the spell being cast now | 296 spell scripts | class + prestige + Veterano + Elixir + Spell Power |
| How strong a caster this character is, outside a spell | conversations, UMD, crafting | class + prestige |
| What circle this character may cast | the anti-cheat gate only | class + prestige, **nothing else** |

### 9e. Still not answerable from any 2DA

- **What the engine does with a blank `CLMultiplier`** (§8c). Needs the probe.
- **Whether `GetMetaMagicFeat()` returns `-1` inside an AoE** (§7c). Needs the
  Empowered Cloudkill test.
- **Whether a level-1 sorcerer is actually blocked in play** (§9b).
- **`CLMultiplier` and `ArcSpellLvlMod` semantics** rest on Beamdog's column
  documentation and on the existence of the NWNX tweak. No file in the repository
  states them; `nwscript.nss` describes `GetCasterLevel`'s contract but not how
  the engine builds the number.

---

## 10. Decisions, round two — 2026-09-02

Supersedes §4 where they conflict. §4 stands for everything not restated here.

1. **The engine owns the caster level; the module writes into it.** Option **(b)**
   of §2a, using `NWNX_Creature_SetCasterLevelModifier`. §11 argues why, with the
   plugin's exact semantics. Options (a), (c), (d) and (e) are rejected.
2. **`classes.2da` and the script are both adjusted** so they state the same
   intent. The 2DA is not left saying something the script contradicts.
3. **The TLK class descriptions are not touched.** The published rules live on
   the PDB website and the texts are being rewritten anyway; correcting them now
   is work done twice. This retires §5 question 3 and the "description is wrong"
   column of §2 — the description is simply not a source any more.
4. **Removing Asolador and Siervo de la Muerte is deferred to the DEV→PROD
   migration.** Decisions 4.6 and 4.7 stand as decisions and **not** as work to
   do now. **The standing rule that nothing named `blig_` may be touched is NOT
   revoked** — §4.7's exemption is withdrawn. Doing the removal now and again at
   migration is the same job twice.
5. **Spell Power stays arcane-only** — see §10a.
6. **Archimago on a sorcerer: the caster level is granted; the slots cannot be**
   — see §10b.
7. **D5 is fixed without waiting for a play report.** Few sorcerers exist and the
   gain table is unambiguous (§9b).
8. **The anti-cheat gate becomes data-driven and fail-open** — see §10c.
9. **Brujo and Artífice both get a real caster level.** The Artífice memorises
   from his own spellbook (`MemorizesSpells = 1`, `SpellGainTable = CLS_SPGN_ING`,
   `SpellTableColumn = Wiz_Sorc`) and belongs in the gate like any prepared
   caster. The Brujo needs a correct number now so the 5e rework has something
   stable to attach to, even though his invocations are still feats.
10. **Empowered area spells must give +50% on their ticks.** That is the intended
    behaviour; whether it happens today is still unverified (§12c).

### 10a. Spell Power: arcane only

3.5's text is unqualified — *"the archmage gains +1 to his caster level"* — so
this is a design ruling, not a correctness fix, and it is recorded as such.

Arcane-only is chosen because the Archimago is an arcane class gated on casting
7th-level **arcane** spells, and Poder de Conjuro is bought with arcane high
magic. Without the restriction a Mago 7 / Clérigo 8 / Archimago 5 raises his
**cleric** caster level with an arcane class feature.

It also stops applying through items, for the same reason Lanzador Veterano and
the Elixir already do not: an item carries its own caster level, and the module
now has `NWNX_Creature_SetLastItemCasterLevel` if it ever wants to change that
deliberately.

The test is `GetIsArcaneSpellCastClass`-shaped and reads the `Arcane` column of
`classes.2da` rather than a hardcoded class list, so a 5e subclass added later
is covered by filling in its row.

### 10b. The Archimago and the sorcerer: two different questions

The class page's *"sólo se beneficiará el mago de esta mejora"* is **true, and
it is about spells known, not about caster level.**

`Content/2da/vanilla/cls_spkn_sorc.2da` is indexed by **sorcerer class level**:
a sorcerer first knows an 8th-circle spell at class level 16 and a 9th at 18.
Prestige levels do not advance that table. So a Hechicero 15 / Archimago 5 is
granted the **slots** of a 20th-level sorcerer by `ArcSpellLvlMod` and knows only
what a 15th-level sorcerer knows — the high slots have nothing to put in them.
That is an engine limitation and it cannot be fixed without rewriting how spells
known are granted.

**Caster level has no such limitation.** It is a number the module computes and
now writes into the engine. There is no reason to withhold it from a sorcerer who
paid five class levels for it.

**Ruling: the Archimago advances the caster level of whichever arcane base class
the character casts as, sorcerer included. The spells-known ceiling stays as the
engine enforces it.** The class page's sentence is about a different thing and is
not being implemented as a caster-level restriction.

### 10c. The gate: data-driven, indexed by slot level, fail-open

Three rules, in order:

1. **The spell's circle** comes from
   `Get2DAString("spells", Get2DAString("classes","SpellTableColumn",nClass), nSpellId)`,
   falling back to `Innate` as today. This reproduces the existing switch exactly
   for the eleven classes it covers and adds the four it omits.
2. **The maximum circle** is the highest `SpellLevel<N>` column carrying a value
   in the class's `SpellGainTable`, read at the character's **slot level**.
3. **Missing data allows the cast.** A blank column, an unknown class, a spell
   with no circle: allow. The gate may only ever reject a cast it can positively
   prove is above the character's ceiling. This is what guarantees it cannot
   start rejecting something that works today.

The cleric domain loop stays; it is answering a different question (which circle
a domain spell occupies) and has no data-driven replacement.

### 10d. The file needs three numbers, not two

Restating §9d because it is the decision that shapes everything else.

| Name | Answers | Consumers | Contains |
|---|---|---|---|
| **Caster level** | the level of the spell being cast now | 296 spell scripts, and the engine itself | class + prestige + Veterano + Elixir + Spell Power |
| **Character caster level** | how strong a caster this character is, outside a spell | conversations, UMD, crafting, `pb_mod_activate`, `pjr_on_chat` | class + prestige, **highest** casting class, not the sum |
| **Slot level** | which circle this character may cast | the anti-cheat gate only | class + prestige, **nothing else** |

The dead `Dotes = FALSE` parameter (D8) was a boolean trying to be the third
number. It is replaced by a named function, not restored.

---

## 11. Why (b) is the right long-term answer

The owner asked for an assurance rather than a preference, and the reason is a
planned 5e-hybrid rework with subclasses where multiclassing still exists. The
argument is about **where the number lives**, not about which API is nicer.

### 11a. Exact semantics, read from the plugin source

`nwnxee/Plugins/Creature/Creature.cpp:1684-1746`, revision `3d4c4e13c6`:

- `SetCasterLevelModifier(oCreature, nClass, nModifier, bPersist)` stores an
  nwnx variable `CASTERLEVEL_MODIFIER<nClass>` on the creature.
- It hooks `CNWSCreatureStats::GetClassLevel` at `Hooks::Order::Earliest`, but the
  modifier is applied **only while an internal flag is set**, and that flag is set
  inside exactly three windows: `ExecuteCommandGetCasterLevel` (the NWScript
  `GetCasterLevel()`), `ExecuteCommandResistSpell` (`ResistSpell()`), and
  `CGameEffect::SetCreator` (an effect recording its creator and caster level).
- Everywhere else — `GetLevelByClass`, level-up, feat prerequisites, the
  character sheet, spell slot calculation — **the class level is untouched**.
- `SetCasterLevelOverride` wins over the modifier and short-circuits.
- The result is clamped to `0..255` with explicit under/overflow guards.
- **The hooks are installed lazily**, on the first call to any of the four
  functions.

That scope is exactly what is wanted: it changes the caster level and nothing
else. It is not a class-level cheat.

### 11b. What it buys that the alternatives do not

| | (a) accept | (c) drop −1 | (d) script delta | (e) Tweaks env var | **(b) modifier** |
|---|:-:|:-:|:-:|:-:|:-:|
| The 198 base-game spell rows see prestige levels | no | no | no | yes | **yes** |
| Effects carry the right caster level for dispel | no | no | no | yes | **yes** |
| `ResistSpell` uses the right caster level | no | no | no | yes | **yes** |
| The AoE stores the right caster level at creation | no | no | no | yes | **yes** |
| Can express `level − 1` | no | n/a | yes | **no** | **yes** |
| Correct for arcane hybrids | n/a | n/a | yes | **no** | **yes** |
| One place computes the number | no | yes | no | yes | **yes** |
| Survives a 5e rework with subclasses | no | no | partly | partly | **yes** |

**(e) is disqualified on two counts**, both read from
`Plugins/Tweaks/AddPrestigeclassCasterLevels.cpp`: its formula is a ceiling that
cannot express `level − 1`, and its loop adds a prestige class's levels to
**every** casting class of the matching type, so a Mago/Hechicero/Archimago is
advanced twice. In a system that is about to gain subclasses on top of
multiclassing, that is the failure mode that would be hardest to find.

**(d) keeps two numbers.** It is the cheapest correct-looking option and it
leaves the 198 base-game rows, effect dispel levels and `ResistSpell` still blind
to prestige classes. It is what the file already does, dressed differently.

### 11c. The risks, and how each is contained

1. **A plugin dependency.** If `NWNX_CREATURE_SKIP` were ever `y`, every prestige
   caster level silently vanishes. `config/nwserver*.env` has it at `n` today.
   Contain it with a startup check that logs loudly if the call fails.
2. **Lazy hook installation.** Nothing is hooked until the module calls one of
   the four functions. Setting the modifier on client enter installs them before
   any spell is cast, so this resolves itself — but it means the module **must**
   call it, not merely be willing to.
3. **Staleness.** A modifier is a stored number; a level-up changes what it
   should be. **Use `bPersist = FALSE` and recompute on every client enter and on
   every level-up.** No migration, no persisted state to go wrong, and the
   computation is a handful of `GetLevelByClass` calls. Persisting it buys
   nothing and can only be wrong.
4. **Modifier, not override.** The modifier is a delta on the engine's own base,
   so a missed recompute yields "correct base + stale delta". An override freezes
   the whole number. Reserve `SetCasterLevelOverride` for genuine per-case
   overrides.
5. **Whether the modifier reaches the AoE's stored caster level** is inferred
   from the `CGameEffect::SetCreator` hook and is **not established**. It is on
   the probe list in §12c.

### 11d. What the module then looks like

- `classes.2da` keeps `ArcSpellLvlMod`/`DivSpellLvlMod` as the **slot** table and
  they are set to what the design actually wants, so slots and caster level are
  derived from one place.
- One module function computes each base class's prestige delta from those same
  columns plus the `−1` rules, and writes it with `SetCasterLevelModifier`.
- `GetTotalCasterLevel` becomes `GetCasterLevel(oCaster)` plus only the things
  the engine cannot know: Lanzador Veterano, the Elixir, Spell Power.
- `GetCL` becomes the "character caster level" of §10d and takes the highest
  casting class.
- A third function answers the gate's slot-level question.

That is one table, one writer, one reader per question. A 5e subclass is then a
`classes.2da` row and nothing else.

---

## 12. What the modern engine makes viable

Recorded separately from the plan because several of these pay off outside
caster level.

### 12a. Ready to use now, no decision needed

| Native | Replaces | Where it matters |
|---|---|---|
| `GetCasterLevel(oAoE)` | `gsSPSetAoECasterLevel` + a getter | 8193.36 stores the creation caster level on the AoE and keeps it across a save. **D2 becomes a one-line fix in `nw_s0_evardsa` and `nw_s0_evardsc`.** |
| `GetLastSpellCastClass()` in an AoE | `gsSPSetAoECastClass` + a getter | Returns the AoE creator's class since 8193.36 |
| `SetEffectCasterLevel` / `GetEffectCasterLevel` | hand-stamped locals | `EffectDispelMagic()` uses the stored caster level since 8193.36; effect caster level is saved since the same build |
| `SetEffectSpellId` | nothing — it did not exist | **Answers the `-1` spell id problem in `../rules/bonus-stacking.md`.** An effect can be told which spell made it |
| `SetEffectCreator` | `NWNX_Effect_SetEffectCreator` | The module vendors the NWNX version and uses it in three places; the native is free |
| `SpellResistanceCheck(oTarget, oCaster, nSpellId, nCasterLevel, …)` | `MyResistSpell` | Takes the caster level as a parameter — the shape `MyResistSpell` needed and never had |
| `ActionCastSpellAt*(… nClass, bSpontaneousCast)` | guessing from `GetLastSpellCastClass()` | A scripted cast can name the class instead of hoping |
| `GetSpellAbilityCasterLevel` | nothing | Per-ability caster level for feat-driven casts |

**This retires the §7c recommendation to write three AoE getters.** Two of the
three facts are engine state now, kept across saves, and the setters that write
them into locals should be **deleted**, not completed. `inc_spellaoe.nss:382`
already reads `GetCasterLevel(oAoE)` correctly, so the file carries the CoW port
and its replacement side by side.

**Metamagic is the one that survives.** Nothing in the 8193.35/.36 notes covers
it, so `gsSPSetAoEMetaMagic` may be the only one of the three worth keeping, and
it needs a getter after all — see §12c.

### 12b. NWNX, beyond the caster level modifier

| Function | Use |
|---|---|
| `NWNX_Creature_SetCasterLevelModifier` | §11 — the whole design |
| `NWNX_Creature_SetCasterLevelOverride` | reserved for per-case overrides; not part of the design |
| `NWNX_Creature_SetLastItemCasterLevel` | if items should ever carry a designed caster level rather than the engine default |

### 12c. Probes still owed

1. **A blank `CLMultiplier`.** `haks-2da/classes.2da` row 57, Warlock, is the
   **only** `SpellCaster = 1` row in the project or in vanilla 8193.37 with
   `CLMultiplier` and `MinCastingLevel` blank. (`CanCastSpontaneously` is also
   blank there and on rows 60, 61 and 62, so that one is a project-wide habit
   rather than a warlock-specific hole.) Since 8193.36 applies the multiplier
   engine-wide, a blank may read as `0.0`. Test: a warlock invocation with a
   caster-level duration against a wizard of the same level.
2. **`GetMetaMagicFeat()` inside an AoE.** Thirteen scripts read it there. Test:
   an Empowered Cloudkill tick against an unempowered one. The intended answer is
   +50%; if it does not happen, the fix is a `gsSPGetAoEMetaMagic` getter and a
   dispatch on `GetObjectType(OBJECT_SELF) == OBJECT_TYPE_AREA_OF_EFFECT`.
3. **Whether `SetCasterLevelModifier` reaches the AoE's stored caster level**
   (§11c.5). Test: an archmage casts a persistent AoE and its ticks are compared
   against the expected caster level.

---

## 13. Implementation plan

Every slice is one commit with its own changelog entry, its own focused
`./linux_build-dev.sh --check`, and its own audit. Nothing below has been
started.

### S0 — Probes, before anything else *(owner)*

The three in §12c. **S1 needs probe 1** to know whether the blank `CLMultiplier`
is already breaking the brujo; **S6 needs probe 2** to know whether the metamagic
getter is required. Probe 3 can run after S2.

None of them blocks S2 through S5.

### S1 — `classes.2da` states the slot design *(2DA only, **shipped 2026-09-03**)*

| Row | Class | Column | From | To | Why |
|--:|---|---|--:|--:|---|
| 53 | Archimago | `ArcSpellLvlMod` | 2 | **1** | 3.5, the class page and the script all say full (§2b) |
| 37 | Discípulo de dragón | `ArcSpellLvlMod` | 2 | **0** | decision §4.5; vanilla is also 0 |
| 57 | Brujo | `CLMultiplier` | `****` | **1.0** | only casting row in the project or vanilla left blank (§12c.1) |
| 57 | Brujo | `MinCastingLevel` | `****` | **1** | same |

Rows 34, 45, 28 and 54 keep `1`. **This is a deliberate, documented divergence:
those four keep full *slot* progression because `ArcSpellLvlMod` is a divisor and
cannot express `level − 1`, while their *caster level* is `level − 1` via S2.**
The Agente Custodio's text promises `−1` on both; the slot half is not
expressible and is not being chased.

No `.nss` changes, so no compilation. Changelog entry required. **The hak repack
shipped on 2026-09-03**, so this slice is live.

### S2 — The module writes the prestige caster level into the engine

New include, `src/shared/nss/inc_casterlevel.nss`:

- `int pbCLGetPrestigeDelta(object oPC, int nBaseClass)` — the prestige
  contribution to one base class. Reads `Arcane` from `classes.2da` to pick the
  arcane or divine side, walks the character's classes, applies the per-class
  rule (full, `level − 1`, or none) and returns the sum.
- `void pbCLApplyModifiers(object oPC)` — for each casting class the character
  has, `NWNX_Creature_SetCasterLevelModifier(oPC, nClass, delta, FALSE)`.
  **`bPersist = FALSE`**, recomputed every time (§11c.3).

Called from `wrap_on_clnt_ent` (`Mod_OnClientEntr`) and `wrap_on_ply_lvl`
(`Mod_OnPlrLvlUp`). Both already exist.

**This slice is safe on its own.** `GetTotalCasterLevel` still builds its own
number, so module spells do not move; the 198 base-game rows, `ResistSpell` and
effect dispel levels start seeing prestige classes for the first time. That is a
live behaviour change for every prestige caster and needs its own test pass.

Focused check: `inc_casterlevel.nss` plus `wrap_on_clnt_ent.nss` and
`wrap_on_ply_lvl.nss`.

### S3 — `GetTotalCasterLevel` reads the engine instead of rebuilding it

- Base becomes `GetCasterLevel(oCaster)`, which after S2 already carries the
  prestige levels. **The switch stops adding them — this is the "do not mix"
  rule of §8f and the whole point of the slice.**
- Keeps, in this order: Lanzador Veterano `+4` capped at hit dice, then the
  Elixir `+4`, then Spell Power, both deliberately above the cap (decision §4.1).
- Spell Power becomes arcane-only and stops applying through items (§10a).
- `iBaseClass != 0` becomes `!= CLASS_TYPE_INVALID` (D4).
- `GetSpecialCasterLevel`'s nine unreachable cases and its `default:` go (D9).
- A non-creature or a zero base falls back to the class-derived path, which also
  closes the AoE hole (D2) at the library level.
- The three unused includes (D10) are **not** touched here. That is its own
  slice, after a full build proves no consumer depends on the transitive
  include.

Focused check: `pb_nivellanzador.nss` is an include, so at least one
representative consumer must be compiled with it.

### S4 — `GetCL` becomes the character caster level

Fixes D1: drop the doubled `GetLevelByClass` in the warlock, favoured soul and
artificer cases, and take the **highest** casting class instead of the sum, so
the shared `BARD`/`SORCERER`/`WIZARD` block stops adding a prestige class once
per class position.

Four callers: `elg_aprender_sh`, `inc_sum_golem`, `pb_mod_activate`,
`pjr_on_chat`. Each must be read to confirm it wants "how strong a caster is
this character" and not "the caster level of this spell".

### S5 — The gate

`GetCasterMaxSpellLevel` and `GetCasterCanCast` become data-driven per §10c:
`SpellTableColumn` for the spell's circle, `SpellGainTable` for the ceiling,
slot level for the index, **fail-open** on missing data.

Closes D5 (sorcerer 1), D6 (bard 7th circle), D7 (artífice at 9, and the five
classes absent from the switch) and D8 (the dead `Dotes` flag, replaced by the
slot-level function rather than a boolean).

Brujo and Artífice are both wired (decision §10.9). The brujo's invocations are
feats and `cwa_enforcer:30` already exempts feat casts with
`nSpellFeatId == -1`, so nothing about invocations changes.

### S6 — Evard, and the AoE port that the engine replaced

- `nw_s0_evardsa.nss:47` and `nw_s0_evardsc.nss:49`: `GetTotalCasterLevel(OBJECT_SELF)`
  → the AoE creator's caster level. One line each.
- Delete `gsSPSetAoECasterLevel` and `gsSPSetAoECastClass` and their two call
  sites in `_UpdateAoEDataAtLocation`: the engine has kept both facts since
  8193.36 and keeps them across a save (§12a).
- `gsSPSetAoEMetaMagic` stays or goes on probe 2. If metamagic is lost inside an
  AoE, it gains a getter and the thirteen scripts listed in §7c are migrated;
  if not, it is deleted with the other two.

### S7 — Cleanups with no behavioural claim

- The three unused includes (D10), after a full build.
- The style debts (D12): the missing header, the missing `GetCasterCanCast`
  prototype, the prototype/definition default mismatch, `Dotes` without a type
  prefix.

### Not in this plan

- **Removing Asolador and Siervo de la Muerte** — deferred to the DEV→PROD
  migration (decision §10.4). The `blig_` rule stands.
- **The TLK class descriptions** — not touched (decision §10.3).
- **`nostack_inc`** — untouched, as everywhere else.
- **`src/nui/`** — untouched.

### What changes for players, and therefore needs testing

S2 is the one that moves numbers for existing characters: **every prestige
caster's base-game spells get stronger**, because they were running without their
prestige levels. S3 must not move them again. S5 makes the gate stricter for the
artífice and the asesino and looser for a level-1 sorcerer. S1 changes spell
slots for the Archimago and the Discípulo de dragón and needs a hak repack before
it does anything at all.

---

## 14. Corrections and decisions taken while implementing, 2026-09-02

### 14a. The tweak does not double-count hybrids. That claim was wrong.

§8b and §11b said `AddPrestigeclassCasterLevels` adds a prestige class's levels
to **every** casting class of the matching type and therefore advances a
wizard/sorcerer/archmage twice. **It does not, and neither does this module.**

`GetClassLevelHook` is called per class index, and the engine resolves a cast
against **one** class. So the archmage's levels are *available* to whichever
arcane class the character casts as, but only one number is ever used. Nothing
is added twice.

The correct statement is that a character with two arcane base classes gets the
prestige advancement on both, where 3.5 requires him to choose one at creation.
That is a generosity, not a stacking bug, and `inc_casterlevel.nss` has the same
property deliberately — recording the player's choice needs persistent state and
a way to ask for it.

**This changes the case against (e) but does not overturn it.** The two remaining
disqualifiers stand on their own: the tweak's `(nClassLevel - 1) / nClassMod + 1`
is a ceiling that grants at the first class level, and it cannot express
`level − 1` for the four classes that need it.

**`GetCL`'s double count (D1) is unaffected and is still real.** That one sums
across class positions in a single call, so a Cleric/Druid/Teúrgo genuinely adds
the Teúrgo twice in one number.

### 14b. Discípulo de dragón: the 2DA keeps `2` and the script honours it

Decided by the owner on 2026-09-02, superseding §4.5 and the "held" note in the
S1 changelog entry.

`ArcSpellLvlMod = 2` is left as it is — setting it to `0` would take five arcane
slot levels away from every existing character with ten levels of the class, and
nothing that is already granted is being taken back. The module now reads the
column, so the class advances the caster level at half rate as well, and the two
finally agree.

**The rule this establishes, in the owner's words: `classes.2da` must state the
reality of how a class counts and discounts caster levels, and the script must be
the real record of how the system works.** The `−1` classes are the acknowledged
exception because the column is a divisor and cannot express an offset.

`inc_casterlevel.nss` is written to that rule: every progression is read from the
2DA and only the four `−1` classes are named in code.

Worth recording separately: **the Discípulo de dragón's own class description
says nothing about advancing spellcasting at all.** It mentions arcane casting
only as a prerequisite. The half progression has been granted silently since
somebody set the column to `2`, against vanilla's `0`.

### 14c. Rounding: floor, deliberately unlike the tweak

A class needing `N` levels per caster level grants `floor(level / N)`. That is
what the column's own wording says — `N` levels *"together add one level"*, so
below `N` nothing has been added. NWNX's tweak rounds the other way and grants
at the first class level.

It only matters for a class with `N > 1`, which today is the Discípulo de dragón
alone (the Siervo de la Muerte's `div = 3` is on a class being removed). At
Discípulo 10 both formulas give 5; they differ at odd levels, where floor gives
`level/2` and the tweak gives one more.

**New probe, C5:** whether the engine's *slot* calculation rounds the same way.
If it uses a ceiling, a Discípulo de dragón at an odd class level has one more
slot level than caster level. Test: a Hechicero X / Discípulo 3 or 5, comparing
the circles he is granted against the caster level his spells run at.

### 14d. Class positions

`GetClassByPosition` is documented for 1, 2 and 3 (`nwscript.nss:8526`) and
`inc_casterlevel.nss` uses a named constant, `PB_CL_MAX_CLASS_POSITIONS`, so the
5e rework can raise it in one place if the server ever unlocks more slots.

---

## 15. What the S2 audit found, 2026-09-02

Audit `6d9521c00` came back **BLOCKED** with two blockers. Both were correct.

**F-001 — the 198/347 split in §1a and §8a is not what I said it was.** It is
the count of `ImpactScript` resrefs that do not resolve to a file under `src/`,
which is not the same as "base-game". Recounted:

| | Rows |
|---|--:|
| `spell_crs` — **a resref that exists nowhere in this repository** | **177** |
| Genuine `nw_*` / `x2_*` base-game scripts | 7 |
| `war_arrasar`, `war_filotouch`, `war_salva` — warlock names with no file | 3 |
| `sp_cadpl`, `cls_rang_enemy2` and eight others | 11 |

So the headline number was built on a bad classification. **What is actually
true and now measured**: 18 impact scripts that *do* live in `src/` call
`GetCasterLevel()` directly — `nw_s0_alarm`, `nw_s0_barkskin`, `nw_s0_dismissal`,
`nw_s0_enervat`, `nw_s0_flmarrow`, `nw_s0_invsph`, `nw_s0_mgcconvl`,
`nw_s0_negray`, `nw_s0_poison`, `nw_s0_rayenfeeb`, `nw_s0_searlght`,
`nw_s0_shadshld`, `nw_s0_shapechg`, `nw_s0_slow`, `x0_s0_banishment`,
`x0_s0_quillfire`, `x2_s0_healstng`, `x2_s0_infestmag`. Those change with S2, and
the handoff's invariant that "module-scripted spells must not move" was wrong as
written. The invariant that actually holds is that **spells reached through
`GetTotalCasterLevel` do not move**, and they do not.

**`spell_crs` is an open question of its own.** 177 player-castable rows name it
and no file by that name exists in `src/`, `haks-2da/` or anywhere else in the
repository. It is either an external hak resource or 177 dead rows. Nothing about
those spells should be claimed until somebody finds it.

**F-002 — a lost level left a stale modifier.** The writer ran on client enter
and on level up but not on level down, and `wrap_on_mod_load.nss:97` already
subscribes `NWNX_ON_LEVEL_DOWN_AFTER` to `event_leveldown`. Because the modifier
is runtime state with `bPersist = FALSE`, a prestige caster who lost a level kept
the higher caster level until his next login or his next level up. Fixed by
calling `pbCLApplyModifiers` from that handler.

**Process note.** While rewriting the changelog to correct F-001 I truncated
`documentation/changelog/modulo/2026-09.md` to zero bytes with a Python
`open(p,'w')` whose argument expression read the same file — the truncation
happens before the read. The owner had an uncommitted entry in that file. It was
reconstructed byte-for-byte from the `git diff` captured earlier in the session
and verified to restore exactly the same 43 insertions. **Read a file into a
variable before opening it for writing.**

---

## 16. The row counts, corrected — 2026-09-02

§1a, §8a and §15 counted a row as player-castable when it had an `ImpactScript`
and a class column. That ignores `UserType`, which every real spell row carries
as `1` and which the engine uses to decide whether a row is presented as a
player spell at all.

| | Rows |
|---|--:|
| With an `ImpactScript` and a class column | 545 |
| …with `UserType` blank, so not castable | **178** |
| **Genuinely player-castable** | **367** |
| …script in `src/` | 347 |
| …script not in `src/` | **20** |

**So the engine-governed figure is 20, not 198.** What slice S2 changes is the
**18 impact scripts in `src/` that call `GetCasterLevel()` directly**, plus three
base-game rows — `nw_s0_grshconj`, `nw_s0_shades`, `nw_s0_shadconj`. Around
twenty-one rows.

The direction of S2 is unaffected: those spells were running without the
character's prestige levels and now are not. Only the scale was overstated, and
it was overstated twice.

**The 178 blank rows are incoming work and out of scope here.** They belong to
the 5e rework — the ranger subclass system and the warlock NUI phases — and are
not defects in the live module. They are named only to explain why the earlier
count was wrong.

---

## 17. Re-verified against the production 2DAs — 2026-09-02

The owner replaced `haks-2da/` with the production set. Every measurement in this
document was taken again against it.

### 17a. Nothing in the analysis moved

232 files under `haks-2da/` differ from the previous commit. **All 232 differ in
trailing whitespace and line endings only; not one has a content change.**
Compared line by line with blank lines dropped and each line right-trimmed, old
and new are identical in every file.

So the earlier analysis was never against the wrong data, and every finding
stands as written.

**Slice S1 survived the swap.** `classes.2da` is not among the changed files:
row 53 Archmage still carries `ArcSpellLvlMod = 1`, row 57 Warlock still carries
`CLMultiplier = 1.0` and `MinCastingLevel = 1`, and row 37 Discípulo de dragón
still carries `2` as decided.

Re-measured and unchanged: 545 rows with an `ImpactScript` and a class column,
178 with a blank `UserType`, **367 genuinely castable**, 347 in `src/`, 20 not,
and **18 in-`src/` rows calling `GetCasterLevel()` directly**. The Archmage feat
tables are byte-identical in content: one bonus feat at each of class levels 1-5,
nine `List=2` Gran Arcano entries, Spell Power chained I to V.

### 17b. Three things the re-reading corrected

**The bard is refused nothing at level 1 and should be.** `cls_spgn_bard.2da`
gives a bard of class level 1 **only circle 0** — two cantrips, no first-circle
column at all. The first circle appears at class level 2, with zero slots. The
current formula, `(casterLevel + 2) / 3`, returns 1 at level 1 and therefore
allows a first-circle spell the character has no access to. D6 was recorded as a
problem only at caster level 19-20; it is wrong at level 1 as well, in the
opposite direction from the sorcerer's D5.

**The Artífice's ceiling is not a constant.** `cls_spgn_ing.2da` tops out at
circle 6 at class level 21 but reaches **circle 7 at class level 23**, and
continues into the epic rows. The practical ceiling is 6, because no epic
character exists, but it confirms that S5's gate must read the table **at the
character's level** rather than cache a per-class maximum.

**The Warlock's spell gain table no longer exists.** `classes.2da` row 57
declares `SpellGainTable = CLS_SPGN_WARLOK` and
`SpellKnownTable = CLS_SPKN_WARLOK`, and neither file is present in `haks-2da/`
or tracked by git; both were removed with the "Brujo 5e" work (`8314abb96`).
This is benign today - the warlock casts invocations, which are feats, and
`cwa_enforcer.nss:30` already exempts feat casts - and it is exactly the case
**the fail-open rule of §10c exists for**. A gate that rejected on a missing
table would lock every warlock out.

### 17c. An implementation note for S5

The stock gain tables - `cls_spgn_sorc`, `cls_spgn_wiz`, `cls_spgn_bard`,
`cls_spgn_cler`, `cls_spgn_rang` - are **not in `haks-2da/`**. The module uses
the game's own, which is why the measurements above had to read them from
`Content/2da/vanilla/`.

At runtime this is not a problem: `Get2DAString` resolves against the engine's
merged view of game data, haks and override, so the gate will find them. It only
means that **repository-side analysis of a 2DA cannot assume `haks-2da/` is the
whole picture**, and a check that walks the file tree will report a table as
missing when the engine can see it perfectly well.

---

## 18. Slice S3, implemented 2026-09-02

`GetTotalCasterLevel` no longer rebuilds the caster level from class levels. It
asks the engine, which after S2 already carries the prestige contribution and the
class's `CLMultiplier`, and then adds only what the engine cannot know.

Three routes, in order, so that no caller can end up worse off than before:

1. **No class named** — the normal cast — `GetCasterLevel(oCharacter)`.
2. **A class named**, by the caller or by the warlock/artificer feat detection,
   **or the first route returned nothing**: `GetLevelByClass` plus
   `pbCLGetPrestigeDelta`, the same function that wrote the engine's modifier, so
   the two routes cannot disagree. Only entered when `classes.2da` says the class
   is a spellcaster.
3. **Anything still zero**: `GetCasterLevel(oCharacter)`, which is exactly what
   the old `default:` branch did for every class the switch did not recognise.

The whole per-class switch is gone from this function. The progressions live in
`classes.2da` and are read once, in `inc_casterlevel.nss`.

### 18a. What this closes

**D2, at the library level.** An area of effect script calling
`GetTotalCasterLevel(OBJECT_SELF)` takes route 1, and `GetCasterLevel` on an area
returns the level it was created with. Evard's Black Tentacles goes from `d4 + 0`
to `d4 + caster level` without either of its scripts being touched.

**D4.** `iBaseClass != 0` became `iBaseClass != CLASS_TYPE_INVALID`. `0` is
Barbarian; the absent value is 255. Lanzador Veterano and the Elixir were being
granted on a cast with no resolvable class and refused to a barbarian, which is
the opposite of the intent.

**Decision 4.2, Spell Power arcane only.** It is now gated on the class being a
spellcaster with `Arcane = 1`, and on the cast not coming from an item. It also
moved inside the `Dotes` guard, where the other two feat bonuses already were;
that path has no caller today, so nothing changes now, but the flag now means
what it says.

### 18b. What did not change, deliberately

The order of the three bonuses is untouched: Lanzador Veterano is capped at hit
dice, the Elixir and Spell Power are added afterwards and are meant to exceed the
cap. That is decision §4.1.

### 18c. D9 was partly wrong

D9 said `GetSpecialCasterLevel`'s `default:` branch is unreachable. **It is not.**
`pb_ip_slots_inc.nss:35` calls it with `CLASS_TYPE_ORCUS`, which has no `case`,
so the default's `(level / 2) + 0.5` is live code serving a real caller.

The function also has two external consumers, `pb_ip_slots_inc.nss` and
`x2_pc_umdcheck.nss`, which between them use `TEURGO_MIST`, `ORCUS`,
`PALEMASTER`, `CABALLERO_ARCANO` and `SHADOW_ADEPT`. Five of its cases -
`WARLOCK`, `FAVORED_SOUL`, `SOLDIER_OF_LIGHT`, `ASSASSIN`, `BLIGHTER` - still have
no caller.

`GetTotalCasterLevel` no longer calls it at all, but **it is left exactly as it
is**: it is a public function with live external callers, and gutting it in the
same slice that changes the caster level for every character is risk with no
return. It moves to S7.

Those two external files are now the last consumers of the second copy of the
progression table, and they compute spell slots rather than caster level. Whether
they should read `classes.2da` too is a question for its own slice.

---

## 19. What the S3 audit found, 2026-09-02

Audit `71bae51f9` came back **BLOCKED** with four blockers. All four were correct.

### F-001 — NPC prestige casters lost their prestige levels

The real defect, and the one worth the whole audit. `pbCLApplyModifiers` is
driven by `wrap_on_clnt_ent`, `wrap_on_ply_lvl` and `event_leveldown` — **player
hooks**. A creature that never enters as a client never had a modifier installed,
so route 1 answered it with its base class level and route 2 never ran because
route 1 had returned a positive number.

The reviewer named a real one: `src/shared/utc/pb_imnrayrayhiel.utc.json` is
class 10 level 10 and class 34 level 11 — a **Wizard 10 / Maestro de la lividez
11** with Haste memorised, and `nw_s0_haste.nss` takes its duration from
`GetTotalCasterLevel(OBJECT_SELF)`. Before S3 it cast at `10 + (11 − 1) = 20`;
after S3 it cast at **10**.

Fixed with `pbCLEnsureModifiers`, which installs the modifiers the first time
anything asks about a creature that has never had them and marks it so it happens
once per creature per session. **Installing rather than merely compensating in
the module is the right fix**, because it also makes the engine's own number right
for that NPC, so the base-game spell scripts it casts are correct too.

### F-002 — the canonical document described the architecture that had just been removed

`documentation/rules/caster-level.md` still said *"They are not yet one
implementation"* and *"`GetTotalCasterLevel` still rebuilds the number from its
own class switch"*. Only this analysis and the changelog were updated.

That document was created by the owner earlier the same day, along with
`documentation/nwscript/engine-behavior.md` and the routing table now in
`AGENTS.md`. **The lesson is procedural: a slice that changes behaviour must
update the canonical current-state document in the same commit, not only the
proposal it came from.**

### F-003 — the mandatory documentation check was not recorded

`AGENTS.md` now requires `python3 scripts/check_documentation.py` whenever a
tracked documentation file changes, and the handoff recorded only the compilation.
The checker passes — `78 Markdown files, 23 README indexes` — but the handoff has
to say so before review, not after.

### F-004 — the call-shape inventory was arithmetically wrong

The handoff claimed an inventory "of the 377 sites" whose categories summed to
373, said 287 `OBJECT_SELF` where there are 288, and omitted a site. Regenerated
properly, excluding the prototype and the definition:

| Shape | Sites |
|---|--:|
| `(OBJECT_SELF)` | 288 |
| `(oCaster)` | 44 |
| `(oPC, nClass)` | 10 |
| `(oMaster)` | 9 |
| `(oPC)` | 5 |
| `(oTarget)` | 5 |
| `(GetAreaOfEffectCreator())` | 5 |
| `(oPC, CLASS_TYPE_INGENIERO)` | 4 |
| `(GetEffectCreator(eEfecto))` | 1 |
| `(oPC, CLASS_TYPE_WIZARD)` | 1 |
| `(oCaster, nClass)` | 1 |
| `(oCaster, nClass, FALSE)` | 1 |
| `(oPC,CLASS_TYPE_CLERIC)` | 1 |
| **Total** | **375** |

**375 invocations across 328 files**, not 377; the two extra textual matches are
the prototype and the definition. **357 take route 1** and **18 name a class and
take route 2.**

---

## 20. The second S3 audit, 2026-09-02

`2089dc70d` — the remediation for the first S3 audit — was itself reviewed, at the
owner's request, and came back **BLOCKED** with two blockers. Both correct.

### F-001 — the marker outlived the thing it was tracking

`pbCLEnsureModifiers` marked a creature with `SetLocalInt` while installing the
modifiers with `bPersist = FALSE`. Those are two different lifetimes, and my
handoff asserted they were the same. Two paths break it:

- **DM creature saving.** `chat_consoladm.nss:424` calls `NWNX_Object_Serialize`
  and `pb_mod_activate.nss:2224` calls `NWNX_Object_Deserialize`. Serialisation
  carries ordinary object locals; it does **not** carry NWNX plugin variables that
  were written non-persistent. A restored NPC therefore came back **marked as
  done with nothing installed**, and every later check skipped the install. It
  cast at its base class level for the rest of its life.
- **Runtime NPC level-up.** `zep_cw_levelup.nss` calls
  `NWNX_Creature_LevelUp`. The mark stayed set, so the delta went stale.

Fixed twice over. The mark is now an NWNX variable written with the same
`bPersist = FALSE` as the modifiers — `NWNX_Object_SetInt` /
`NWNX_Object_GetInt` — so it has their lifetime by construction and disappears
with them through serialisation. And `zep_cw_levelup.nss` now calls
`pbCLApplyModifiers`, which re-applies unconditionally: it is the NPC counterpart
of the player level-up hook.

**The lesson is about the claim, not the code.** I wrote "the mark is a local
variable, so it does not survive the creature" as a tradeoff note without checking
whether anything in the repository serialises creatures. Two scripts do.

### F-002 — the NPC change had no changelog entry

`AGENTS.md` requires a player-, DM- or builder-visible change to carry its
changelog entry inside the same candidate. `2089dc70d` restored NPC caster levels
and changed only the `Commits.` line. The entry now describes the NPC behaviour
and asks for three concrete tests: an NPC prestige caster's spell duration, the
same after a DM levels it, and the same after a DM saves and restores it.

### Why this audit cannot close

`finalize` accepts the candidate or **one direct child**. When the review was
started, HEAD was already `7a40b6a9c`, one child past `2089dc70d`, so the
remediation for these findings lands two commits past the candidate.

**That is my error and it is the second time.** The audit-log rule says the branch
has to stay still between `review` and the remediation commit; it is equally true
that **a candidate should be HEAD when the review starts.** Recorded there as
well.

---

## 21. The third S3 audit, 2026-09-02

`72c8b96e9` reviewed at the owner's request. **BLOCKED**, two blockers, both
correct, both cheap, and the first one is a mistake I had already made once.

### F-001 — I wired the creature wizard's level-up and not its level-down

`zep_cw_leveldown.nss` sits beside `zep_cw_levelup.nss` in the same DM dialog and
calls `NWNX_Creature_LevelDown` followed straight by `TokenList()`. A DM removing
prestige levels from an NPC left the old modifier installed, and because
`pbCLEnsureModifiers` saw the surviving mark it skipped recomputation, so the
creature kept casting at its pre-level-down caster level.

**It contradicts the contract this very commit wrote**, three lines above it in
`inc_casterlevel.nss`: *"Anything that changes a creature's class levels
afterwards must call `pbCLApplyModifiers` directly."*

**And it is the same omission as F-002 of the first S2 audit**, where the player
hooks covered client enter and level up but not `event_leveldown`. Twice, the same
shape: the up path wired, the down path forgotten.

Fixed the same way: `zep_cw_leveldown.nss` includes `inc_casterlevel` and calls
`pbCLApplyModifiers` after the level down, and the changelog test now asks a DM to
take a level away and confirm the duration drops.

### F-002 — the changelog entry named the wrong commits

`AGENTS.md` requires a candidate's `Commits.` line to carry `<pending>`, which the
direct child then replaces. The entry still ended at `71bae51f9`: it did not name
`2089dc70d`, which introduced the NPC behaviour the entry now describes, and it
carried no placeholder for the candidate. The line now lists all three commits
that implement the slice.

### Why this one nearly failed to close, and the rule that was wrong

Rule 9, written yesterday, said *a candidate must be HEAD when its review starts*.
I read it as *at most one commit past* and started this review with `e9eab5c94`
already sitting on the candidate — which consumed the single direct-child slot
`finalize` allows **before the remediation existed**.

The rule is not "at most one child". It is **"no children"**: the one child
`finalize` accepts is reserved for the remediation and nothing else may occupy it.

---

## 22. Two owner decisions, 2026-09-03

**The hak repack shipped.** S1 is live: `classes.2da` row 53 gives the Archimago
full arcane slot progression and row 57 gives the Brujo `CLMultiplier = 1.0` and
`MinCastingLevel = 1`. That half needs no module build and can be tested now,
starting with probe C1.

S2 and S3 are NWScript and are **not** live until the module is built and
deployed. Every claim about prestige caster levels, the Evard fix, Poder de
Conjuro going arcane-only and the NPC paths waits on that.

**`haks-2da/` as it now stands is the standard.** The 232 files the owner
installed are the authority, and the earlier measurement holds: they differ from
what preceded them in trailing whitespace and line endings only, with no content
change, so nothing in this analysis moves.

`Content/2da/vanilla/` stays what it always was - an identified external baseline
for comparison, never project authority. **Improvements suggested by a difference
from vanilla belong to a later sprint** and are not part of this plan. Two are
already recorded and are explicitly deferred: the Discípulo de dragón's
`ArcSpellLvlMod`, which is `2` here and `0` in vanilla, and the Maestro de la
lividez's `Arcane` cell, which is `1` here and blank in vanilla.

---

## 23. The NPC mechanism, settled — 2026-09-03

The owner asked for the integral answer rather than the cheap one, and for the
options to be put to Codex. They were, as a design consultation rather than an
audit. Its recommendation and one thing it found are why this section exists.

### What it found that neither audit had

**`pbCLEnsureModifiers` never covered what it claimed to.** It was called from
`GetTotalCasterLevel` and nowhere else, so an NPC whose impact script reads the
native `GetCasterLevel` directly — the eighteen in `src/` listed in §15, and
every base-game script — never triggered installation at all. The claim in §19
that installing "also makes the engine's own number right for that NPC" was
therefore **too broad**: it was right only for spells that happened to route
through the module's own function.

### The decision, which goes one step past the recommendation

Codex recommended keeping the engine-modifier architecture, moving installation
out of the getter, and driving it from lifecycle events with the marked check
retained as a backstop. The first two are taken. **The mark is not.**

A mark has to be invalidated by everything that can change class levels, and this
repository has **ten `LevelUpHenchman` callers outside the creature wizard** —
`cab_entrenarmont`, `cab_inc`, `cab_onactivate`, `creatura_respawn`,
`lvlaumentar`, `vgz_cs_alzarspaw`, `x0_i0_henchman` twice, `x3_s3_palmount`
twice — plus creature serialisation. A marked backstop would have gone stale
after every one of them, silently, which is exactly the failure both previous
audits found in two different disguises.

So the whole thing is deleted: `pbCLEnsureModifiers`, the `PB_CL_APPLIED`
variable, and the `nwnx_object` include it needed. The install moves to
`event_castbefore.nss`, the existing `NWNX_ON_CAST_SPELL_BEFORE` handler where
`OBJECT_SELF` is the caster.

| | Before | Now |
|---|---|---|
| Where the install happens | inside a getter with 375 call sites | once, before each cast |
| Coverage | only spells routed through `GetTotalCasterLevel` | every creature, every spell script |
| Can go stale | yes — ten level-up paths and serialisation | no — derived from class levels on the spot |
| Code | a function, a constant, an include, two audit findings | one line |

`GetTotalCasterLevel` is a pure read again. The player hooks and both halves of
the creature wizard keep re-applying, so the number is right immediately for a DM
inspecting a creature rather than only at its next cast.

**This is a net deletion.** The slice that closes the NPC question removes more
code than it adds, and removes precisely the code the last two audits were about.

### Documentation routing

Codex was also asked whether the four engine findings should move to
`documentation/nwscript/engine-behavior.md` under the new routing table. It said
all four qualify as reusable engine or NWNX behaviour, with the PDB consequences
staying here. Done: the `classes.2da` column semantics, the 8193.36 area-of-effect
provenance, the NWNX tweak's ceiling rounding and the serialisation trap now live
there with build and revision provenance.

One correction it forced: this document called the `classes.2da` column semantics
"Beamdog's own column documentation". The source is `nwn.wiki`, which is
community-maintained. It is now cited as such, and the 8193.36 release note is
cited separately as the independent confirmation that `CLMultiplier` is what the
engine applies.

---

## 24. Slice S5, implemented 2026-09-04

The anti-cheat gate stops carrying a copy of every class's spell progression and
reads the two columns `classes.2da` already provides.

- **The spell's circle** comes from
  `Get2DAString("spells", Get2DAString("classes","SpellTableColumn",nClass), nSpellId)`.
  The thirteen-case switch is gone; **no class is named in the code any more.**
- **The ceiling** is the highest `SpellLevel<N>` column carrying a value in the
  class's `SpellGainTable`, read at the character's slot level. A column holding
  `0` still counts: the circle exists and an ability bonus can fill it.
- **The index is the slot level, not the caster level** — class levels plus the
  prestige advancement and deliberately nothing else. Lanzador Veterano, the
  Elixir and Poder de Conjuro raise the caster level and must not raise the
  circle. That is the distinction `Dotes` was reaching for and never reached,
  since nothing ever passed it; the parameter stays for source compatibility and
  no longer changes the answer, because the number it would have filtered is not
  in there.
- **The prestige contribution is rounded up here**, through
  `pbCLGetPrestigeDelta(..., TRUE)`. The engine's own rounding for slots is not
  established, and erring high only ever allows a cast the engine would not have
  granted a slot for; erring low would refuse a legitimate one.

### Fail open, and the one place it must not

Every unreadable input returns 9: an invalid class, a class with no
`SpellGainTable`, a table that resolves to nothing. That is what guarantees the
gate cannot start refusing something that works today — the Brujo is the live
case, since `CLS_SPGN_WARLOK` no longer exists (§17b) and its invocations are
feats that `cwa_enforcer.nss:30` already exempts.

**A readable row whose circle columns are all blank is not an unreadable input.**
It is a class that has no spells yet, which is exactly a paladin or a ranger below
`MinCastingLevel`. That case returns **0**. The first draft failed open there and
would have handed a first-level paladin the ninth circle; it was caught by
simulating the new function against the real tables before committing.

### What it changes, simulated against the shipped 2DAs

Wizard, cleric, druid, paladin at 1, 3, 4 and 14, ranger and warlock are
identical at every level tested.

| Class | Level | Before | After | |
|---|--:|--:|--:|---|
| Hechicero | 1 | **0** | **1** | D5. He has three first-circle slots and the gate refused all of them |
| Bardo | 1 | 1 | **0** | He has no first circle until class level 2 |
| Bardo | 20 | 7 | **6** | D6. The bard has no seventh circle |
| Asesino | 1 | **9** | **1** | |
| Asesino | 21 | **9** | **4** | |
| Artífice | 1 | **9** | **1** | D7's sharpest case: mapped to the wizard's column with a ceiling of nine |
| Artífice | 21 | **9** | **6** | |
| Alma Predilecta | 1 | **9** | **1** | |

### Two classes that cannot be reached

Guardia negro (row 31) and Soldado de la Luz (row 50) also move from a ceiling of
9 to their own tables, and an earlier draft of this section wrongly claimed every
unlisted class was identical. **Neither is reachable**: both carry
`PlayerClass = 0`, so no character can take them, and `GetCasterCanCast` runs
only for player characters. There is no class list to exclude them from - the
function receives one class, the one the character cast as, and that value can
never be either of these.

### D8 was wrong, and the correction matters

D8 said the `Dotes = FALSE` path was dead because nothing passed it. **It is not
dead.** `pb_ip_slots_inc.nss:7` passes `FALSE`:

```nwscript
return iSlotEsfera <= GetCasterMaxSpellLevel(iSlotClase, oPC, FALSE);
```

It is reached from `wrap_on_equip_it.nss:383` and answers whether a character may
use an item property granting a bonus spell slot of a given circle. Passing
`FALSE` was deliberate: it wanted the ceiling **without** the feat bonuses.

That is exactly what the new function always computes, because the slot level
never contained them. **So that consumer now gets what it always asked for**, and
the parameter is inert because the answer is now unconditionally the `FALSE`
answer. The behaviour is right; the justification given for it was not.

There are **three** invocations in the repository, not the five the handoff
claimed: two in `pb_ip_slots_inc.nss` and one in `GetCasterCanCast`.

**Noticed while reading that file, not fixed here.** Its branch condition is
always true:

```nwscript
if(iSlotClase == CLASS_TYPE_PAL_ANTIGUO || iSlotClase == CLASS_TYPE_PAL_OSCURO
   || iSlotClase != CLASS_TYPE_PAL_VENGADOR || iSlotClase != CLASS_TYPE_PALADIN)
```

A value cannot be both `PAL_VENGADOR` and `PALADIN`, so one of the two `!=`
always holds and the `else` branch is unreachable. It belongs to the slice that
converts this file to `classes.2da`.

Closes **D5**, **D6** and **D7**. **D8 is withdrawn**: the path it called dead
has a live consumer, and the parameter is inert for a different and better
reason.

---

## 25. Slice S4, implemented 2026-09-04

`GetCL` is the third and last function to stop carrying its own copy of the
progression table. It returns the **highest** casting class plus that class's
prestige contribution, taken from `pbCLGetPrestigeDelta` — the same function that
writes the engine's modifier, so this number and the one a spell runs at are
built from one table.

**Its four consumers were read before the change, and all four want exactly this
question**: `elg_aprender_sh.nss:5` (`>= 13`, a scroll),
`inc_sum_golem.nss:375` (`< 10`, activating a golem),
`pb_mod_activate.nss:1581` and `:1736` (`>= 13` and `>= 15`), and
`pjr_on_chat.nss:206`, the `!ecl` command, which **prints the number to the
player**.

That last one matters: the doubled number has been on screen this whole time. A
Brujo 20 who typed `!ecl` was told his caster level was **40**.

### What it changes, simulated

| Character | Before | After |
|---|--:|--:|
| Brujo 20 | **40** | 20 |
| Alma Predilecta 20 | **40** | 20 |
| Artífice 20 | **40** | 20 |
| Mago 10 / Clérigo 10 | 20 | **10** |
| Clérigo 10 / Druida 10 | 20 | **10** |
| Mago 10 / Hechicero 5 / M. de la lividez 5 | 23 | **14** |
| Hechicero 10 / Discípulo de dragón 10 | 10 | **15** |
| Mago 20, Clérigo 20 | 20 | 20 |
| Mago 15 / Archimago 5 | 20 | 20 |
| Mago 10 / M. de la lividez 10 | 19 | 19 |
| Clérigo 10 / Teúrgo 10 | 20 | 20 |
| Mago 16 / Agente Custodio 4 | 19 | 19 |

Three shapes come out of it. **A single-class caster of any kind is unchanged**,
and so is a base class with one prestige class — the common build. **The three
classes that were doubled are halved back.** And **a character with two base
casting classes loses the sum**, which is the intended correction and the one
that can be felt: those characters may drop below one of the three thresholds.

The Discípulo de dragón is the only one that gains, because §14b made the script
honour the column that was already granting him slots.

Closes **D1**.

### 25a. What the S4 audit found

**F-001 — the `SpellCaster` filter was too wide.** The old switch covered eight
classes. `classes.2da` marks **fourteen** with `SpellCaster = 1`: the eight, plus
Paladin, Ranger, Assassin, Blackguard, Soldado de la Luz and the three paladin
variants. Six of those are player-selectable.

A pure paladin 20 would have gone from **0 to 20** and crossed both the golem
threshold and the scroll threshold. The claim that every single-class caster was
unchanged was only true for the classes the old switch happened to name — the
ones I simulated.

Fixed by naming the historical set in `pbCLGetIsFullCaster`. **This is a list in
code, deliberately**, and it does not contradict the "no class may be named" rule
of the gate: that rule is about a *mapping* the data already holds, while this is
a *ruleset judgement* the data does not express. `SpellCaster` marks half-casters
too, and no other column separates them cleanly — `MinCastingLevel` is 4 for the
paladins and the ranger but 1 for the assassin.

**Open question for the owner:** should a paladin, ranger or assassin count
towards the character caster level? Today they do not, and this slice keeps it
that way.

**F-002 — one of the three thresholds runs backwards, and I described it the
wrong way round.** `pb_mod_activate.nss:1736`:

```nwscript
if (iCasterLevel >= 15)
{
    SendMessageToPC(oPC, StringToRGBString("No posees el nivel suficiente para utilizar este hechizo.","700"));
    return;
}
```

It refuses the *Atraer la desgracia* item when the number is **15 or more**, while
the message says the character lacks the level. **The condition is inverted
relative to its own message and it predates all of this work.**

So a Mago 10 / Clérigo 10 goes from 20 and refused to 10 and **allowed**. At that
gate the change grants access rather than removing it, and the changelog said only
the opposite. Corrected, with its own test.

The inverted condition is **not fixed here**. Flipping it would deny the item to
everyone above 15 who can use it today, which is a balance decision.

I had recorded in the handoff that this line was read as a threshold and its
feature not identified. It was the right thing to flag and the wrong thing to
leave: the identification was two lines of reading away.

---

## 26. The last two copies of the progression table, 2026-09-04

`x2_pc_umdcheck.nss` and `pb_ip_slots_inc.nss` were the last places holding a
hand-written prestige list. Both now take it from `pbCLGetPrestigeDelta`.

### 26a. A correction to the record, three times repeated

**`pb_ip_slots_inc.nss` was never a consumer of `GetSpecialCasterLevel`.** Its
lines 16 to 132 of 133 are a single commented-out block, so every call in it is dead.
Its live code is ten lines and already went through `GetCasterMaxSpellLevel`,
which slice S5 converted.

I stated the opposite in two handoffs, in an audit resolution and in
`documentation/rules/caster-level.md`. **Worse, D9's correction rested on it**:
§18c said the `default:` branch of `GetSpecialCasterLevel` was live because
`pb_ip_slots_inc.nss` passed it `CLASS_TYPE_ORCUS`. That line is inside the
comment. **D9's original claim was right and my correction of it was wrong.**

Live callers of `GetSpecialCasterLevel`, established by stripping comments before
searching rather than grepping the raw text: **one**, `x2_pc_umdcheck.nss`. It
passes eight classes — Archimago, Caballero arcano, Agente Custodio arcano and
divino, Maestro de la lividez, Adepto Sombrío arcano y divino, Teúrgo — and every
one has its own `case`. **The `default:` branch is unreachable.**

After this slice `GetSpecialCasterLevel` has **no live caller at all** and can be
deleted in S7.

### 26b. What the conversion changes, enumerated

`pbCLGetPrestigeDelta` credits **every** class `classes.2da` gives a positive
`ArcSpellLvlMod` or `DivSpellLvlMod`. Each hand-written block credited a subset,
and no two subsets agreed. The eight arcane rows are Agente Custodio (28),
Maestro de la lividez (34), Discípulo de dragón (37), Bribón arcano (43),
Caballero arcano (45), Adepto Sombrío (46), Teúrgo (48) and Archimago (53); the
five divine rows are Siervo de la Muerte (47), Teúrgo (48), Asolador (51), Agente
Custodio divino (54) and Adepto Sombrío divino (55).

| Block | Credited before | Gains |
|---|---|---|
| **Bardo** | Lividez, Bribón, Caballero arcano | **five**: Agente Custodio, Discípulo de dragón, Adepto Sombrío, Teúrgo, Archimago |
| **Hechicero** | Lividez, Bribón, Caballero arcano | **five**: the same. Its Archimago and Agente Custodio lines existed but added to `iNivelMago` |
| **Mago** | those three, plus Adepto Sombrío, Archimago, Agente Custodio | **two**: Discípulo de dragón, Teúrgo |
| **Artífice** | the same six as the wizard | **two**: Discípulo de dragón, Teúrgo |
| **Divino** | Teúrgo, Adepto Sombrío divino, Agente Custodio divino | **two rows no player can have** |
| **Druida** | one prestige row, added by row number | Teúrgo, Agente Custodio divino, Adepto Sombrío divino. What it counted before is unchanged, since that row's `DivSpellLvlMod` is 1 and the raw add was its full level |

**This is intended and it is the point of the slice.** The rule the owner set is
that `classes.2da` states how a class counts towards caster level and the script
reads it; a hand-written subset that disagrees with the column is the defect. But
it is a broad change to who can read a scroll and it had to be enumerated rather
than described as "the bard gains three".

Two live defects disappear with the lists, both copy-paste:

- **The sorcerer block** added the Archimago's and the Agente Custodio's
  contribution to **`iNivelMago`**. A Hechicero/Archimago had his bonus credited
  to a wizard level he may not even have had.
- **The druid's** prestige was a raw `GetLevelByClass` of a prestige row by
  number, outside the shared function entirely. It was missed in the first pass
  of this slice and found by the audit.

`pb_ip_slots_inc.nss`'s always-true condition is removed; the `FALSE` arm is the
one that has always run and is now the only one.

### 26c. Two defects found and deliberately not fixed

**The arcane class is picked with a boolean.** `x2_pc_umdcheck.nss:630-631`:

```nwscript
if(iNivelHechicero > ( iNivelMago && iNivelArtifice)) { ... }
if(iNivelArtifice > ( iNivelMago && iNivelHechicero)) { ... }
```

`(a && b)` is `0` or `1`. So the sorcerer's level is compared against **one**, not
against the other two levels. A Hechicero 2 / Mago 20 is treated as a sorcerer for
the whole UMD calculation. The intent is plainly "take the highest", which is the
same rule `GetCL` now follows.

**The divine level is a sum.** `:431` computes
`iNivelDivino = iNivelClerigo + iNivelAlmaPredilecta`, so a Clérigo 10 / Alma
Predilecta 10 emulates a 20th-level divine caster. It is the same defect as D1,
in a different file.

Both change who can use a scroll, so both are balance-visible and neither is this
slice's to take.

---

## 27. The two UMD defects, fixed 2026-09-04

Both were found while converting the file and left out of that slice because they
change who can read a scroll. Fixed on the owner's instruction.

### The arcane class was chosen against a boolean

`x2_pc_umdcheck.nss:615-616` read:

```nwscript
if(iNivelHechicero > ( iNivelMago && iNivelArtifice)) { ... }
if(iNivelArtifice > ( iNivelMago && iNivelHechicero)) { ... }
```

`(a && b)` evaluates to **0 or 1**. So each level was compared against one, not
against the other two. A character with any sorcerer level above 1 was treated as
a sorcerer for the whole scroll calculation regardless of how high his wizard or
artificer level was — a **Hechicero 2 / Mago 20 read scrolls as a 2nd-level
caster**.

Each is now compared against the best found so far, which keeps the existing
wizard-first tie-break and reads as what the code plainly meant.

### The divine level was a sum

`:431` read `int iNivelDivino = iNivelClerigo + iNivelAlmaPredilecta;`, so a
Clérigo 10 / Alma Predilecta 10 emulated a **20th-level** divine caster. It is the
same defect as D1 in another file.

It now takes the higher of the two, and the class picked moves with it.

**Two things about that were wrong in the first attempt and were caught while
tracing every use of the variables before the audit, not by the audit.**

- The commit claimed the ability check followed the chosen class. **It did not.**
  Line 448 still read `iNivelClerigo ? ABILITY_WISDOM : ABILITY_CHARISMA`, a
  separate ternary I had not touched, so an Alma Predilecta 15 / Clérigo 2 was
  still asked for Wisdom. It now reads `nChosenDivineClass`.
- `nChosenDivineClass` was `(iNivelClerigo >= iNivelAlmaPredilecta)`, which for a
  character with **neither** class gives the cleric where the old
  `iNivelClerigo ?` gave the Alma Predilecta. That variable is read further down
  by `ObtenerNivelMinimoPerga`, and the cleric and the Alma Predilecta use
  **different progressions** there, so the baseline for "how many levels am I
  short" changed for characters who have no divine class at all. The test now
  begins `iNivelClerigo > 0 &&`, which restores the old answer in that case.

---

## 28. Three defects found by a cross-cutting review, 2026-09-04

Six audits had each read one commit. A consultation asked the external reviewer
to look at all of them together instead, which is the view none of them had. It
found three things, all mine, none of which any single audit could have seen.

### 28a. The gate ignored `NumSpellLevels`

`GetCasterMaxSpellLevel` took the highest `SpellLevel<N>` column carrying a value
and stopped there. **The gain tables also carry `NumSpellLevels`, the engine's own
count of how many circles the row grants**, and the two do not always agree.

| Table | Row | `NumSpellLevels` | Highest filled column |
|---|--:|--:|--:|
| `cls_spgn_dru` | class level 14 | 8 → circle **7** | `SpellLevel9` |
| `cls_spgn_ing` | class level 4 | 3 → circle **2** | `SpellLevel1` |

They differ in **both** directions, so the answer is the lower of the two.

The druid is the live case and it was a real hole:

| Druida | Before the slice | Without the bound | With it |
|--:|--:|--:|--:|
| 13 | 7 | **8** | 7 |
| 14 | 7 | **9** | 7 |
| 15 | 8 | **9** | 8 |
| 16 | 8 | **9** | 8 |

**And it was not only the anti-cheat gate.** The same ceiling decides whether an
item property granting a bonus spell slot may stay equipped, through
`pb_ip_slots_inc.nss` from `wrap_on_equip_it.nss:378`. A druid of class level 14
would have been allowed to equip a ninth-circle slot item.

It also falsified the claim, in §24 and in the changelog, that the druid was
identical at every level tested. With the bound he is, which is what makes the
claim true rather than merely restated.

Evidence for `NumSpellLevels` being a hard bound is **inference, not proof**: the
pinned NWNX MaxLevel plugin treats it that way before reading a circle
(`Plugins/MaxLevel/MaxLevel.cpp:287`), and that plugin is disabled here. Taking
the lower of the two is safe under either reading.

### 28b. The scroll path capped Lanzador Veterano in the wrong order

`GetTotalCasterLevel` adds the prestige contribution, then the feat, then caps at
hit dice. `x2_pc_umdcheck.nss` added the feat to the wizard's level, capped it,
and **only then** added the prestige.

> A **Mago 5 / Archimago 5 with Lanzador Veterano** was 10 by the canonical
> calculation and **14** for reading scrolls.

The scroll path now uses the same order.

### 28c. The arcane class and the ability were chosen independently

The class came from the highest of the wizard, sorcerer and artificer levels. The
ability was simply `if(iCarisma > iInteligencia)` — the higher of the two scores,
with no reference to the class.

So a wizard-dominant character could satisfy a wizard scroll's requirement **on
Charisma**, and a sorcerer-dominant one on Intelligence.

The divine branch had already been corrected to keep class, level and ability
together; this one had not, and the inconsistency between the two branches is
what makes it obviously wrong rather than arguably intended. The ability now
follows `iClaseArcanaElegida`.

### 28d. What the same review said is still not covered

Recorded rather than acted on:

- **`GetTotalCasterLevel` on an area of effect reads the stored engine level but
  tests feats and locals on the AoE object**, not on its creator, so Lanzador
  Veterano, the Elixir and Poder de Conjuro are not recoverable there. The "one
  number" claim holds for base plus prestige and **not** for the module's total.
- **The named-class route ignores `CLMultiplier`** (`pb_nivellanzador.nss`). Every
  `SpellCaster = 1` row carries `1.0` today, so it is a future-data hazard rather
  than a live defect.
- **`cab_amo2.nss:7` called `GetTotalCasterLevel(oPC)` from a conversation
  conditional**, with no class named and no spell context, where the engine
  returns 0. It is exactly the caller the `GetCL` split existed to isolate and it
  was missed. Pre-existing, not introduced here. **Closed by `660504abc`**, which
  changed it to `GetCL(oPC)`; the call is at `cab_amo2.nss:11` today. This entry
  said line 3 — the `StartingConditional()` declaration — until the audit of
  `9fe97ba7f` raised it as its only advisory.
- **The three UMD requirements are independent global flags**, so a spell on
  several class lists may take its level from one class and its ability score
  from another. Whether that is intended policy is undocumented.

---

## 29. Three of the four from §28d, fixed 2026-09-04

### 29a. An area of effect asked itself for the caster's feats

`GetTotalCasterLevel` took `GetCasterLevel(oCharacter)`, which for an area is
correctly the level it was created at, and then read the module's own bonuses off
**the same object** — `GetHasFeat(FEAT_CONJUROS_VETERANO, oCharacter)`,
`GetLocalInt(oCharacter, "CLS_ING_ELIXIRCON")`, the five Spell Power feats.

An area has no feats and no locals, so those three bonuses were absent whenever
the function was **passed the area**.

**How wide that is, measured rather than assumed.** Of the area scripts named by
`vfx_persistent.2da`, exactly **two** pass the area object:
`nw_s0_evardsa.nss:47` and `nw_s0_evardsc.nss:49`, both Evard's Black Tentacles.
`nw_s0_wallfirea` and the two blade barrier scripts pass
`GetAreaOfEffectCreator()`, and the artificer's bombs pass a named `oCaster`, so
**they read the feats off the creature all along and none of them had this bug**.

The first version of this section, and the changelog entry with it, claimed the
bonuses were missing from every persistent area and used the wall of fire as the
example. That was wrong twice over, and the audit caught it.

`iDG` was the same mistake one step further: `GetHitDice(oCharacter)` on an area
is **0**, so had the feat test ever passed, the hit dice cap would have clamped
the caster level to zero.

The fix is still worth having beyond Evard's: it is what makes
`GetTotalCasterLevel(OBJECT_SELF)` correct inside an area at all, which is the
shape D2 was about, and it protects any area script written that way in future.

Both now read `oOwner`, which is `oCharacter` unless the object is an area of
effect, in which case it is `GetAreaOfEffectCreator`.

**A wobble left in place, deliberately.** The two feat bonuses are gated on
`GetSpellCastItem() == OBJECT_INVALID`, and inside an area heartbeat that native
reports whatever the *creator* last cast from. So an area's ticks lose those
bonuses if its creator subsequently casts from a wand. That is pre-existing, it
is a different bug from this one, and fixing it means deciding what
`GetSpellCastItem` should mean in an area at all.

### 29b. The named-class route ignored `CLMultiplier`

The engine applies a class's `CLMultiplier` on its own route; the fallback did
not. Every `SpellCaster = 1` row carries `1.0` today, so nothing moves — this is a
future-data hazard being closed, not a live defect. It is floored, as the column's
definition states.

### 29c. `cab_amo2.nss` asked the wrong function

It called `GetTotalCasterLevel(oPC)` from a conversation condition, with no class
named and no spell context, so the first route asked the engine for the caster
level of a spell nobody is casting. It now calls `GetCL`.

**This is exactly the caller the `GetCL` split existed to isolate, and it was
missed** — the split was designed in §10d and the four consumers of `GetCL` were
read, but nothing checked which callers of `GetTotalCasterLevel` were asking the
other question. There are 31 files calling it that are not spell scripts; only
this one has been examined.

### 29d. The fourth is not fixed and needs a decision

The three UMD requirements — class, ability score, caster level — are independent
flags initialised once and accepted independently at the end of
`UsarObjetoMagicoPergas()`. For a spell on several class lists, one class can
supply the level while another supplies the ability score.

**Whether that is intended UMD policy is undocumented**, and the reviewer that
raised it said so: treating it as wrong is inference. Changing it would remove
access that works today for multiclass characters. It needs the owner.

---

## 30. The scroll system measures against the class's own circle, 2026-09-05

### 30a. The defect

`x2_pc_umdcheck.nss` read the spell's circle **twice, from two different places**,
and did not notice:

```nwscript
int iEsferaConjuro = StringToInt(Get2DAString("spells", "Innate", iIDConjuro));
int iClerigo       = StringToInt(sClerigo);   // the Cleric column
```

The **ability** requirement was measured against the class's own circle
(`10 + iClerigo`). The **caster level** requirement was measured against `Innate`.

The survey below is measured over exactly the nine `spells.2da` columns this file
reads — `Bard`, `Cleric`, `Druid`, `Paladin`, `Ranger`, `Wiz_Sorc`,
`PaladinAntiguos`, `PaladinOscuro`, `PaladinVengador` — on master rows only,
because `x2_pc_umdcheck.nss:167` remaps a sub-radial row through `Master` before
reading anything.

| | Pairs |
|---|--:|
| `Innate` **above** the class's circle — the system demands more than the class does | **23** |
| `Innate` **below** it — the system demands less | 81 |
| **Total differing** | **104** |

Per column:

| Column | Differing | Stricter |
|---|--:|--:|
| `Druid` | 24 | 4 |
| `Wiz_Sorc` | 22 | 2 |
| `Cleric` | 15 | 3 |
| `Ranger` | 12 | 5 |
| `Bard` | 10 | 6 |
| `PaladinOscuro` | 6 | 1 |
| `Paladin` | 5 | 0 |
| `PaladinAntiguos` | 5 | 1 |
| `PaladinVengador` | 5 | 1 |

All 23 strict pairs:

| Spell | Column | Class circle | Measured |
|---|---|--:|--:|
| Fear | `PaladinOscuro` | 1 | **3** |
| Fear | `PaladinVengador` | 1 | **3** |
| Control_Undead | `Cleric` | 6 | 7 |
| Identify | `Bard` | 1 | 2 |
| Identify | `Wiz_Sorc` | 1 | 2 |
| Lesser_Dispel | `Bard` | 1 | 2 |
| Protection_from_Elements | `Ranger` | 2 | 3 |
| Resist_Elements | `Ranger` | 1 | 2 |
| Resistance | `Bard` | 0 | 1 |
| Resistance | `Cleric` | 0 | 1 |
| Resistance | `Druid` | 0 | 1 |
| Resistance | `Wiz_Sorc` | 0 | 1 |
| Ultravision | `Druid` | 1 | 2 |
| Ultravision | `Ranger` | 1 | 2 |
| Ultravision | `PaladinAntiguos` | 1 | 2 |
| UltravisionEnGrupo | `Druid` | 3 | 4 |
| UltravisionEnGrupo | `Ranger` | 3 | 4 |
| Regenerate | `Druid` | 6 | 7 |
| Legend_Lore | `Bard` | 4 | 5 |
| Find_Traps | `Cleric` | 2 | 3 |
| BalagarnsIronHorn | `Bard` | 1 | 2 |
| Spike_Growth | `Ranger` | 2 | 3 |
| AlineamientoIndetectable | `Bard` | 1 | 2 |

**A first survey published 86 and 20 and was wrong three ways.** It covered only
the six stock columns, so the three custom paladin columns this file also reads
were missing entirely; it treated `*****` as a value rather than as an empty
cell; and it counted sub-radial rows the code never looks up. The audit of
`05c572830` caught it as F-004. The numbers above replace it everywhere.

### 30b. Centralised rather than patched

Per the owner's standing criterion — fewer duplicated functions, one system per
question — the fix is not a changed argument. **Two systems were asking "what
circle does this spell occupy for this class" in two different ways**: the casting
gate read `SpellTableColumn` itself, and the scroll system used `Innate`.

`pbGetSpellCircleForClass(int iSpellId, int iClass)` now owns that question, in
`pb_nivellanzador.nss`. It reads the class's `SpellTableColumn` from
`classes.2da` and then that column of `spells.2da`, returning `-1` when the class
does not have the spell. It names no class. `GetCasterCanCast` was rewritten to
call it, so the gate and the scrolls cannot disagree again.

In the scroll system, each of the nine per-class blocks now computes the circle
for **its own** class, and the chosen circle travels alongside the chosen class
and level into the difficulty calculation — `iEsferaElegida` beside
`iClaseElegida` and `iNivelLanzadorElegido`. Where a class does not have the spell
the old `Innate` value remains as the fallback, so nothing loses an answer.

The nine sites in the assassin, soldier-of-light and blackguard branches take the
lookup directly: those branches hardcode their spell ids and required levels and
never call `ObtenerNivelMinimoPerga`, so they had no computed circle to carry. A
first pass gave them a stale one and it was caught before commit.

### 30c. The reported case, worked through

**Mago 3 / Clérigo 3 / Teúrgo 10, with Lanzador de conjuros veterano.** Reported
from play with a screenshot, and it exercises three separate repairs at once.

The wizard block's hand-written prestige list never contained the Teúrgo, so his
ten levels were not counted:

| | Deployed today | After the repairs |
|---|--:|--:|
| Wizard levels | 3 | 3 |
| Teúrgo (`ArcSpellLvlMod = 1`) | **not counted** | +10 |
| Lanzador Veterano | +4 | +4 |
| Hit dice cap (16) | never binds | binds |
| **Arcane emulation level** | **7** | **16** |

The screenshot's rolls confirm the 7 rather than any other number: the difficulty
is `required + 1` and the roll is `d20 + level`, so *Ruptura de conjuro mayor*
succeeding on 26 against DC 12 needs a d20 of 19 at level 7 — at level 3 it would
need a 23, which does not exist.

| Spell | Circle | Requires | Before | After |
|---|--:|--:|---|---|
| Mano interpuesta de Bigby | 5 | 9 | rolled, DC 10 | **no roll** |
| Barrera de energía | 5 | 9 | rolled | **no roll** |
| Ruptura de conjuro mayor | 6 | 11 | rolled, DC 12 | **no roll** |
| Mano aferradora de Bigby | 7 | 13 | **failed**, DC 14 | **no roll** |
| Puño cerrado de Bigby | 8 | 15 | rolled | **no roll** |
| Mano aplastante de Bigby | 9 | 17 | rolled | still rolls |

**`Innate` equals the class circle for all six**, so this character is not
affected by 30a at all — he is the demonstration of the Teúrgo repair and of the
Lanzador Veterano ordering, and the two must not be conflated.

**The ordering repair is visible in him.** Under the old order — feat, then cap,
then prestige — he would have reached **17**, above his own hit dice. The order
now runs prestige, feat, cap, and he lands on 16.

### 30d. Not done, and why

**The domain branch keeps its `iEsferaConjuro - 1`.** A domain spell's circle
comes from `domains.2da`, not from a class column, and `GetCasterCanCast` has its
own loop for it — a third copy of a related question. Unifying that is a slice of
its own.

**The three requirements are still independent flags.** A spell on several class
lists can take its level from one class and its ability score from another; no
single class need satisfy all three. Changing that removes access that works
today, so it stays the owner's decision. Section 26c and the cross-cutting review
both raise it.


## 31. The audit of `05c572830` and what it found, 2026-09-05

Verdict **BLOCKED**, five blockers, all five confirmed against the tracked files
before any of them was accepted. Three were defects in the change, two were false
statements in the evidence recorded for it.

### 31a. The domain branch built its difficulty from an unassigned circle

`05c572830` changed the difficulty line from

```nwscript
iCDLanzador = ObtenerNivelMinimoPerga(iClaseElegida, iEsferaConjuro) + 1;
```

to `iEsferaElegida`, on the reasoning that the chosen circle must travel with the
chosen class. Every branch that sets `iClaseElegida` was given the matching
`iEsferaElegida` — **except the domain branch**, which sets the class and the
level and nothing else.

`iEsferaElegida` is initialised to `0`. `ObtenerNivelMinimoPerga` is a `switch`
whose cases start at 1, so circle 0 returns 0 and the difficulty becomes **1**.
Every domain scroll passed automatically, for any cleric, at any level. The old
code could refuse.

Verified by listing every `iClaseElegida = ` assignment in the file and checking
each for a companion `iEsferaElegida`: nineteen sites, one miss, the domain
branch at line 696.

Fixed by carrying a circle into `iEsferaElegida` alongside the class.

**The first attempt at that fix carried the wrong one, and the audit of the
remediation caught it.** The branch holds two different circles and always has:
it decides *whether to roll at all* against the domain discount `Innate - 1`,
while the difficulty of the roll was always built from `Innate` itself
(`x2_pc_umdcheck.nss:717` and `:761` before the regression). Carrying `Innate - 1`
into the difficulty restored a number, but a lower one than had ever been in
force. For *Call_Lightning* — `Level_3` of the AIR domain, `Innate` 3 — a
first-level cleric would have rolled against **DC 4** where the pre-regression
code set **DC 6**, dropping the chance of failing from 20% to 10%. It would also
shift which of the three emulation flags the code picks as cheapest. The
remediation now carries `Innate`, which is exactly what the difficulty used
before, and leaves the measurement on `Innate - 1`.

The asymmetry is preserved deliberately, not endorsed. Both numbers are guesses
at a circle that really lives in `domains.2da`; replacing them with that lookup
is the domain unification slice.

**The clamp on the measurement matters**: a circle-0 domain spell would otherwise
reach `ObtenerNivelMinimoPerga` as `-1`.

### 31b. The dark paladin asked the base paladin's column

The commit's whole claim is that each per-class block measures against its own
class. The dark paladin block does not:

```nwscript
iEsferaClase = pbGetSpellCircleForClass(iIDConjuro, CLASS_TYPE_PALADIN);
```

while recording `iClaseElegida = CLASS_TYPE_PAL_OSCURO`. The sibling blocks for
`PAL_ANTIGUO` and `PAL_VENGADOR` are correct; only this one is wrong, and it was
introduced by this commit — the previous line passed `iEsferaConjuro` and named
no class at all.

It is wrong in both directions, because `classes.2da` row 61 maps to the
`PaladinOscuro` column:

| Spell | `PaladinOscuro` | `Paladin` | `Innate` | Measured before the fix |
|---|--:|--:|--:|--:|
| Fear | 1 | absent | 3 | **3** — level 11 demanded instead of 4 |
| Animate_Dead | 4 | absent | 3 | **3** — one circle too permissive |

Fixed by passing `CLASS_TYPE_PAL_OSCURO` to both the circle lookup and
`ObtenerNivelMinimoPerga`. That function already routes `PAL_OSCURO` through the
same paladin progression, so the arithmetic is unchanged for every spell the
base column also carries.

### 31c. The recorded compilation had compiled nothing

The handoff recorded

```
./linux_build-dev.sh --check src/shared/nss/x2_pc_umdcheck.nss src/shared/nss/cwa_enforcer.nss src/shared/nss/pb_nivellanzador.nss
```

and claimed `3 successful, 1 skipped, 0 errored`.

`linux_build-dev.sh:46` resolves each argument with `find src -name "$n"`, which
matches a **basename**. Given a path it matches nothing. Re-running the exact
recorded command prints three `no encontrado en src/` lines and `Nada que
comprobar.` — it compiled nothing at all.

The claimed result was also arithmetically impossible on its face: three
filenames cannot produce four outcomes. It was the previous commit's result,
carried forward.

**The rule this establishes.** `--check` takes basenames. A result line whose
outcome count does not equal the number of files passed is not a result, it is a
transcription error. Both are now checked before an evidence line is written.

### 31d. The survey omitted the columns the commit changed

Covered in section 30a. The published 86/20 became 104/23 once the three custom
paladin columns were included — and those are precisely the columns whose block
carried the wrong-class bug of 31b, so the incomplete survey is what let it
through unnoticed.

### 31e. The changelog entry described someone else's change

The entry committed with `05c572830` was titled *El teúrgo ya no tira para leer
sus propios pergaminos* and spent its first half on the Teúrgo prestige repair,
which is in `9cd2bfd3a`, `98734367f`, `34f03c4e3` and `9fe97ba7f` — all of them
in the first parent. With `<pending>` resolved, the entry would have credited
this commit with behaviour it did not change.

Rewritten to describe only what this commit and its remediation do. The Teúrgo
material stays where it already is, in the entry for `9cd2bfd3a`.


## 32. The audit of `3af0a4156`, 2026-09-05

The remediation commit for section 31 was itself submitted as a candidate,
because the audit contract has no reviewer read a remediation commit — `finalize`
only checks it deterministically. Its two behaviour repairs had therefore passed
no external review. Verdict **BLOCKED**, two blockers, both confirmed.

The reviewer reproduced the focused compilation, the documentation check, the
nineteen-assignment survey and the 104/23/81 arithmetic before finding anything.

### 32a. The domain repair lowered a difficulty instead of restoring it

Recorded in section 31a above, where the defect it corrects is described. The
short form: the remediation's own stated invariant was *"may only ever restore a
requirement the parent commit broke"*, and it did not. It carried `Innate - 1`
into a difficulty that had always been built from `Innate`.

**The lesson is about the shape of the mistake, not the arithmetic.** Section 31a
was found by enumerating every `iClaseElegida` assignment and checking each for a
companion — a mechanical sweep that proved a value was *present*. It never asked
whether the value was the *right* one. A sweep that checks for presence cannot
catch a wrong value, and the fix for a missing assignment is exactly where a
wrong value is easiest to introduce.

### 32b. The changelog claimed more than the change delivered

The rewritten entry said *"Ahora los dos usan el círculo de tu clase"* — that both
the ability and the caster level requirement now measure against the character's
own class circle. Only the caster level one does.

The ability check in all three custom paladin blocks reads
`GetAbilityScore(...) >= 10 + iPaladin`, where `iPaladin` comes from the **base**
`Paladin` column (`x2_pc_umdcheck.nss:538`, `:560`, `:582`). For *Fear* the
`Paladin` column is absent, so `iPaladin` is 0 and the threshold is 10, where the
dark paladin's own circle of 1 makes it 11. The base paladin block at `:516` is
correct because its own column is the one it reads; bard, druid, ranger and the
divine branch all read their own.

Narrowed in the entry, and recorded here as owed: **the ability check of the
three custom paladin classes reads the base paladin's circle.** Pre-existing,
untouched by this series, and a separate change if accepted.


## 33. The domain lookup joins the shared function, 2026-09-05

The debt recorded in sections 30d, 31a and 32a, paid.

### 33a. Four places asked what circle a domain spell occupies

- `GetCasterCanCast` walked `domains.2da` with its own loop and **overwrote** the
  class circle with what it found.
- The scroll system used `Innate - 1` to decide whether to roll.
- The same branch used `Innate` to build the difficulty of that roll.
- The ability check beside it used `Innate` again.

None of them read the number the game actually uses, which is the `Level_N`
column of `domains.2da`.

### 33b. What the table says

**The first survey published here was 65/37/9 and was measured wrong.** It took,
for each spell, the lowest level across *every* domain in the table — a figure no
character can experience, because a cleric holds two domains. The audit of this
commit raised it as F-002. Measured per actual domain route, over the 160
`Level_N` entries in `domains.2da`:

| Domain level against the spell's `Innate` | Entries |
|---|--:|
| Equal | 90 |
| **Below** — the domain is a discount | 50 |
| **Above** — the domain is a surcharge | **20** |

The twenty surcharges, by the route a character actually has:

| Spell | Domain | Domain level | `Innate` |
|---|---|--:|--:|
| Enervation | DEATH | 6 | 4 |
| Hold_Monster | GOOD | 6 | 4 |
| MagnficaMansionDeMordenkainen | TRAVEL | 9 | 7 |
| PasarSinDejarRastro | PB_Elfico | 3 | 1 |
| Sunburst | PB_Elfico | 9 | 8 |
| Volar | AIR | 4 | 3 |
| Polymorph_Self | ANIMAL | 5 | 4 |
| Displacement | PB_Suerte | 4 | 3 |
| Phantasmal_Killer | DEATH | 5 | 4 |
| Legend_Lore | KNOWLEDGE | 6 | 5 |
| Ice_Storm | MAGIC | 5 | 4 |
| Ice_Storm | WATER | 5 | 4 |
| Cone_of_Cold | WATER | 6 | 5 |
| Acid_Fog | WATER | 7 | 6 |
| Stoneskin | STRENGTH | 5 | 4 |
| Stoneskin | PB_Enano | 5 | 4 |
| Protection_from_Spells | PB_Enano | 8 | 7 |
| Confusion | TRICKERY | 4 | 3 |
| Improved_Invisibility | TRICKERY | 5 | 4 |
| Power_Word_Stun | WAR | 8 | 7 |

A cleric who reaches Mordenkainen's Magnificent Mansion only through the Travel
domain spends a **ninth** circle slot on it. `Innate` 7 is the power level of the
spell on the arcane list, and he is not an arcane caster. Measuring him at 7 was
letting him read a scroll of it four class levels early.

**The 90 "equal" entries are not all unchanged**, and the first version of this
section said they were. The scroll system's caster level requirement used
`Innate - 1`, not `Innate`, so a route whose domain level equals `Innate` gets one
circle **stricter**. *Call_Lightning* is `Level_3` of the AIR domain with `Innate`
3: an Air cleric of level 3 or 4 met the old circle-2 requirement and now rolls
against circle 3. Every equal-level entry behaves that way for the scroll path.
The three old numbers each need their own comparison:

| Old requirement | Was | Now | Direction |
|---|---|---|---|
| Scroll, caster level | `Innate - 1` | real domain circle | stricter wherever domain level >= `Innate` |
| Scroll, difficulty | `Innate` | real domain circle | follows the 90/50/20 split |
| Scroll, ability | `Innate` | real domain circle | follows the 90/50/20 split |
| Casting gate | first matching domain, overwriting the class circle | minimum of both domains and the class list | see 33c |

### 33c. The minimum, not the first answer found

`pbGetSpellCircleForClass` gained a defaulted `oCreature` parameter and returns
the lowest circle among the routes that exist: the class's own column, and each
of the two domain slots. A spell on both the cleric list and in a domain resolves
to whichever is cheaper — *Cure Moderate Wounds* is cleric 2 and Healing domain
1, and the answer is 1.

**This changes the casting gate, and the first version of this section said it did
not.** The old loop searched domain 2 only when domain 1 held no match, so slot
order decided the answer. Ten spells sit in more than one domain at different
levels:

| Spell | Routes |
|---|---|
| Stoneskin | EARTH 4, GOOD 4, MAGIC 4, STRENGTH 5, PB_Enano 5 |
| Protection_from_Spells | PB_Suerte 7, MAGIC 7, PB_Enano 8 |
| Hold_Monster | PB_Ley 4, PB_Caos 4, GOOD 6 |
| Volar | TRAVEL 3, AIR 4 |
| True_Seeing | ANIMAL 3, KNOWLEDGE 4 |
| Enervation | EVIL 4, DEATH 6 |
| Improved_Invisibility | PB_Gnomo 4, TRICKERY 5 |
| Power_Word_Stun | PB_Orco 7, WAR 8 |
| Acid_Fog | DESTRUCTION 6, WATER 7 |
| Sunburst | SUN 8, PB_Elfico 9 |

A cleric holding AIR in slot 1 and TRAVEL in slot 2 was refused *Volar* at circle
4 and is now allowed it at circle 3. That is the correct answer — he can prepare
it in a third-circle Travel slot — but it is a live gate change, not a
preservation.

The old loop also *overwrote* the class circle with the domain one rather than
comparing. That agrees with the minimum only because no domain places a spell
above the **cleric list**, which is a different statement from the `Innate`
comparison above and remains true.

### 33d. What is deliberately unchanged

`VerSiEsConjuroDeDominio` still decides *whether* a spell counts as a domain
spell for a character, from a hand-written per-feat list in `dominios_inc.nss`.
It produces no level, so it cannot answer this question, and replacing it is a
separate change. The feats it tests are the `FEAT_*_DOMAIN_POWER` constants
granted by picking a domain (`nwscript.nss:2631-2635`), and `DOMAIN_*` constants
are `domains.2da` row indices.

**The two disagree on six entries**, and the first version of this section claimed
they could not. Measured by walking the feat list and checking each spell id
against the `Level_N` cells of the domain row it is claimed for:

| Feat | Domain | Spell | `Cleric` | `Innate` |
|--:|---|---|--:|--:|
| 313 | DESTRUCTION | Implosion | 9 | 9 |
| 318 | HEALING | Mass_Heal | 9 | 9 |
| 312 | ANIMAL | Summon_Creature_IX | 9 | 9 |
| 315 | EVIL | Summon_Creature_IX | 9 | 9 |
| 317 | GOOD | Summon_Creature_IX | 9 | 9 |
| 1300 | PB_Gnomo | Summon_Creature_IX | 9 | 9 |

For these the feat list says *domain spell* and the table grants no such slot.
The branch therefore runs, `pbGetSpellCircleForClass` finds no domain route, and
the **cleric list** answers instead — circle 9, where the old `Innate - 1` gave
8. A cleric of level 15 or 16 needed no roll before and rolls now.

That is the right answer: the table decides what a domain grants, and if it
grants nothing here the character casts the spell from an ordinary ninth-circle
cleric slot. But it is a behaviour change, it was not predicted, and the claim
that these cases behave exactly as before was false. The real defect is the data:
the feat list should be generated from `domains.2da` rather than maintained by
hand. Recorded as owed.

Where `pbGetSpellCircleForClass` returns `-1` — no domain route **and** no class
list entry — the scroll branch keeps its old `Innate - 1`. The fallback is
narrower than first stated: a class-list circle masks a domain miss, which is
exactly what the six rows above expose.

### 33e. Still owed

**The ability check of the three custom paladin classes** reads the base
`Paladin` column, recorded in section 32b and not touched here.

**`VerSiEsConjuroDeDominio` is hand-maintained and has drifted** from
`domains.2da` on the six entries above. It should be generated from the table.

## 34. The audit of the domain unification, 2026-09-05

Verdict **BLOCKED**, five blockers, all five confirmed. Three were false claims in
the analysis and two were defects in the code.

**F-001, the one that was a live bug.** The domain branch assigned
`iNivelLanzadorElegido` **before** comparing routes, while all eighteen other
branches assign it only inside the winning `else if`. A Bardo 5 / Clerigo 2
reading *Confusion* — bard circle 3, Trickery domain circle 4 — selects the bard
route with difference 2, the domain route loses with difference 5, and the
cleric's level 2 has already overwritten the bard's 5. The roll is then made with
one class's level against another class's requirement. Pre-existing, and the new
domain circle changes which combinations hit it. Fixed by computing into a local
and assigning all three together.

**This is the third time the same shape of defect has appeared in this file**:
`iEsferaElegida` missing from one branch (section 31a), the wrong circle carried
into the difficulty (32a), and now the level assigned outside the winning block.
Each was found by a sweep looking for a different variable. The lesson is that
the three values `iClaseElegida`, `iNivelLanzadorElegido` and `iEsferaElegida`
are one record and should be assigned by one helper, not by nineteen hand-written
brace blocks.

**F-002, F-003 and F-004** were false statements about behaviour, corrected in
sections 33b, 33c and 33d above: the survey used a route no character has, the
"unchanged" 90 are not unchanged for the scroll path, the casting gate really
does change for ten multi-domain spells, and the feat list and the table disagree
on six entries.

**F-005.** The public prototype contract still described a two-argument function
returning "the circle, or -1 when that class does not have the spell", and still
cited the superseded 86-pair figure. Rewritten to document `oCreature`, the
minimum-route semantics, the exact meaning of `-1`, the cantrip case, and the
feat-list divergence.


## 35. The custom paladins measure their ability against their own list, 2026-09-05

The debt recorded in section 32b, paid.

### 35a. The defect

Paladín Antiguo, Oscuro and Vengador are separate casting classes in
`classes.2da` — rows 60, 61 and 62, each `PlayerClass = 1`, `SpellCaster = 1`,
with its own `SpellTableColumn` and its own `AlignRestrict`. A character takes
levels in row 61, and `GetLevelByClass(CLASS_TYPE_PALADIN, oPC)` returns **0** for
him.

Their spell **progression** is genuinely shared: `cls_spgn_pal.2da`,
`cls_spgn_pala.2da`, `cls_spgn_palo.2da` and `cls_spgn_palv.2da` are **the same
Git object**, `f0ae4a87f9d75a59cc0d9c36ef4ed8a5ce4d1a2e`, whose content hashes to
`md5 6dc3bb4d2957c28268a9a0b6673f3060`. Shared object identity is a stronger
statement than equal checksums, and it is the one to record. That is why
`ObtenerNivelMinimoPerga` can route all five paladin classes through one `switch`
and be right.

An earlier revision of this section gave `md5 41e45562838d`. That is the checksum
of the **working tree** copies, which carry uncommitted changes, not of the blobs
in the reviewed commit. The four are identical in both states, so the conclusion
held, but the fingerprint identified the wrong content. Raised by the audit as
F-003.

Their spell **lists** are not shared. Each carries 39 spells, of which 30 or 31
sit at the same circle as the base paladin and eight or nine are its own; the
exact split per class is in the table below.

The ability requirement in all three blocks read `10 + iPaladin`, from the **base**
`Paladin` column. For a spell that class alone carries, that column is blank,
`StringToInt("")` is 0, and the threshold fell to **10** — the lowest possible.
The defect landed on exactly the spells that make each class distinct, and was
invisible on the 30 or 31 they share, where the base column happens to carry the
same number.

| Class | Spells | Same as base paladin | Its own, threshold was 10 |
|---|--:|--:|--:|
| Paladín Antiguo | 39 | 31 | **8** |
| Paladín Oscuro | 39 | 30 | **9** |
| Paladín Vengador | 39 | 31 | **8** |

The affected spells and the Wisdom each really requires:

| Class | Spell | Circle | Required | Was |
|---|---|--:|--:|--:|
| Antiguo | EspadaAntiguos | 4 | 14 | 10 |
| Antiguo | ZancadaArborea | 4 | 14 | 10 |
| Antiguo | Dominate_Animal | 3 | 13 | 10 |
| Antiguo | Protection_from_Elements | 3 | 13 | 10 |
| Antiguo | Barkskin | 2 | 12 | 10 |
| Antiguo | Charm_Person_or_Animal | 2 | 12 | 10 |
| Antiguo | Ultravision | 1 | 11 | 10 |
| Antiguo | ArmaFeerica | 1 | 11 | 10 |
| Oscuro | EspadaSacrilega | 4 | 14 | 10 |
| Oscuro | Animate_Dead | 4 | 14 | 10 |
| Oscuro | Contagion | 3 | 13 | 10 |
| Oscuro | Protection_from_Elements | 3 | 13 | 10 |
| Oscuro | Darkness | 2 | 12 | 10 |
| Oscuro | Inflict_Moderate_Wounds | 2 | 12 | 10 |
| Oscuro | Fear | 1 | 11 | 10 |
| Oscuro | Inflict_Light_Wounds | 1 | 11 | 10 |
| Oscuro | ArmaMaldita | 1 | 11 | 10 |
| Vengador | EspadaVengadora | 4 | 14 | 10 |
| Vengador | Charm_Monster | 4 | 14 | 10 |
| Vengador | Haste | 3 | 13 | 10 |
| Vengador | Darkfire | 3 | 13 | 10 |
| Vengador | Darkness | 2 | 12 | 10 |
| Vengador | Hold_Person | 2 | 12 | 10 |
| Vengador | Fear | 1 | 11 | 10 |
| Vengador | ArmaCazadora | 1 | 11 | 10 |

The direction is **permissive**: a free pass, not a false refusal. A dark paladin
with Wisdom 11 read his own *Espada Sacrílega* with no ability roll where the
class asks 14.

### 35b. The variables that were meant to do this

`x2_pc_umdcheck.nss` declared `iPaladinAntiguo`, `iPaladinOscuro` and
`iPaladinVengador` from the three custom columns and **never read any of them**.
Each was declared for exactly this check and `iPaladin` was wired in instead.
That is the whole origin of the defect, and the three declarations are removed
with the fix rather than left as a trap for the next reader.

### 35c. The fix

Each of the three blocks now computes the circle once, through
`pbGetSpellCircleForClass` against its own `CLASS_TYPE_*`, before either
requirement, and both the ability check and the caster level check measure
against it — the same shape the domain branch took in section 33.

The fallback `if (iEsferaClase < 0) iEsferaClase = iEsferaConjuro;` cannot fire
inside these blocks: the block is guarded by `if (sPaladinOscuro != "")`, which is
the same `spells.2da` read the function performs, so a non-negative result is
guaranteed. It is kept for uniformity with the other branches.

The base paladin block at line 513 keeps `10 + iPaladin`, which is correct — the
`Paladin` column **is** its own column.

### 35d. Testing these requires pinning the class level

The three requirements are independent flags, so a character below the level the
circle needs fails the **caster level** check first and the ability check is never
the only thing being observed. `ObtenerNivelMinimoPerga` gives the paladin
progression as circle 1 at level 4, circle 2 at 8, circle 3 at 11 and circle 4 at
14, so every fourth-circle test needs a level 14 character with no second casting
class. The audit raised the first version of these tests as F-001 for omitting it.

Useful controls: 27 spells sit at the same circle in all four paladin columns.
*Neutralize_Poison* is circle 4 for every one of them and *Bless* is circle 1, so
either is a clean "nothing changes" case at the matching level.

### 35e. Not changed

`ObtenerNivelMinimoPerga` still routes all five paladin classes through one
`switch`. That is correct and now evidenced by their shared spell gain table
object.


## 36. `domains.2da` decides what a domain spell is, 2026-09-05

The debt recorded in section 33e, paid — but **not** for the reason first written
here. The first version of this section led with a Law and Chaos gap that does not
exist. See 36a.

### 36a. A regex that could not see a two-feat block

The first survey reported that `PB_Ley` and `PB_Caos` had **no block at all** in
`VerSiEsConjuroDeDominio`, so a cleric of either domain received no domain
treatment. That was the headline of the change and of its changelog entry, and it
was false.

The block is at `dominios_inc.nss:181`:

```nwscript
if(GetHasFeat(1288, oPC) || GetHasFeat(1287, oPC)) // Ley o Caos
```

Every other block tests **one** feat. The survey's regex required exactly one
`GetHasFeat(...)` inside the condition, so it skipped this block entirely and
reported its two domains as uncovered. The audit raised it as F-001.

**This is the third measurement in this series broken by the shape of a pattern
rather than by the data**: a substitution that hit 18 sites where only 9 qualified
(section 30), a survey that took a route no character has (32a, F-002), and now a
regex that silently dropped a case. The rule this leaves: **a parser used as
evidence must report how many units it found, and that count must be reconciled
against the file before any conclusion is drawn from it.** 26 blocks exist; the
first parser found 25 and never said so.

Re-measured with a parser that accepts any number of `GetHasFeat` calls in the
condition:

| | |
|---|--:|
| Blocks in the function | **26** |
| Domain rows with no block | **0** |
| Entries the list claims and the table does not grant | **7** |
| Entries the table grants and the list omits | **0** |

The seven over-claims, all `Cleric` circle 9:

| Block | Spell |
|---|---|
| Destruccion | Implosion |
| Curacion | Mass_Heal |
| Animal | Summon_Creature_IX |
| Mal | Summon_Creature_IX |
| Bien | Summon_Creature_IX |
| Gnomo | Summon_Creature_IX |
| Ley o Caos | Summon_Creature_IX |

### 36b. What the change actually does

Two things, neither of them a restoration of missing support.

**The authority moves from the script to the table.** `domains.2da` is what the
game reads; a hand-written list of spell ids is a second copy that can drift, and
has, by seven entries.

**The identity moves from the feat to the domain slot.** The old predicate asked
`GetHasFeat(FEAT_*_DOMAIN_POWER)`; the new one asks `GetDomain`. For a
legitimately built cleric these describe the same choice. They differ for a
character granted a domain power feat without the matching slot, who was served
by the old predicate and is not served by the new one. No such case was found;
`ConjurosDominios` reads those feats to grant items and is a different concern.

`pbGetDomainCircleForSpell(oCreature, iSpellId, iClass)` is new in
`pb_nivellanzador.nss` and answers both questions at once, which is why it
replaces a predicate rather than joining one.
`pbGetSpellCircleForClass` now calls it instead of carrying its own copy of the
loop.

### 36c. The seven are not outcome-neutral, and the first version said they were

They are all circle 9 on the cleric list, so the divine branch above supplies the
same **circle**. It does not always supply the same **requirement**.

That branch picks Cleric or Alma Predilecta by level and asks for the matching
ability — Wisdom or Charisma. The domain branch always asked for **Wisdom**, and
its check is written as `if (...) FALSE; else if (...) TRUE;`, so it could switch
the ability requirement back **on** after the divine branch had cleared it.

The worked case, from the audit:

> **Clérigo 1 / Alma Predilecta 18**, Wisdom 10, Charisma 19, reading *Implosion*
> with the Destruction domain feat. `nChosenDivineClass` is Alma Predilecta, so
> the divine branch checks Charisma: 19 >= 10 + 9, requirement cleared. The old
> domain branch then checked Wisdom: 10 < 19, requirement switched back on. **He
> rolled.** He no longer does.

**Not asking him is right.** He is a Charisma caster, *Implosion* is not in the
Destruction row so it was never his domain spell, and at cleric level 1 he has no
ninth-circle cleric slot to cast it from. But it is a player-visible change to a
multiclass combination, it only removes a requirement, and it was not predicted.
It is the owner's to reverse.

Route selection can differ for the same reason, when the two class routes carry
different effective levels.

### 36d. What was deliberately not done

**`VerSiEsConjuroDeDominio` is not deleted.** It is marked superseded in place,
with the seven discrepancies written above it, and it has no callers.

The reason is that **the seven may be intentional**. Somebody may have wanted
Implosion in the Destruction domain and edited the script instead of the 2DA. If
so the correct repair is to add those rows to `domains.2da`, not to drop them, and
that is the owner's decision. The function is the only record of what was
intended.

`dominios_inc.nss` gained no `#include`. It is included by **eight** scripts and
`pb_nivellanzador.nss` pulls in five further includes; the one caller of
`VerSiEsConjuroDeDominio` already had both, so changing the caller cost nothing.

`ConjurosDominios`, which grants the domain power items, is untouched. It has
**seven** callers, one of which is `wrap_on_ply_lvl.nss:308`, the module level-up
event bound at `src/module/ifo/module.ifo.json:556`. The first version of this
section said six callers and seven includers; the audit raised the miscount as
F-003. That consumer is now in the focused compilation.

### 36e. Still owed

**The decision on the seven.** Either add them to `domains.2da` or accept that
they are not domain spells and delete the superseded function.

**`ConjurosDominiosUOM` is declared at `dominios_inc.nss:5` and never defined.**
A prototype with no definition, unnoticed until this reading.


## 37. One record instead of four locals, in four groups

Three defects in `x2_pc_umdcheck.nss` had the same shape: `iClaseElegida`,
`iNivelLanzadorElegido` and `iEsferaElegida` are one record, written by nineteen
hand-written brace blocks, and each defect was one of them written without the
others.

| Section | What was written without what |
|---|---|
| 31a | class and level set, circle left at its initial 0 |
| 32a | the measurement's circle carried into the difficulty |
| 34 | the level written before knowing whether the route had won |

Each was found by a sweep for a different variable, and a sweep proves only what
it looks for.

`struct pbUMDRoute` and `pbUMDConsiderRoute` replace the brace blocks. The helper
takes the running best and a candidate and returns the winner as one value, so
**a route cannot be half-recorded**: there is no way to set the class without also
setting the level and the circle.

### 37a. Why the four locals stay

`iNLanzadorFaltante` is the running best and is read at all nineteen sites. If the
struct became the storage, a half-migrated file would compare converted routes
against one running best and unconverted ones against another, and the answer
would be wrong. **A partially migrated state would not be safely representable.**

So the helper takes the four locals in and the caller unpacks the result straight
back into them. They stay the single source of truth, converted and unconverted
blocks interoperate exactly, and the migration can be split.

### 37b. The groups

Split 5 / 5 / 5 / 4 by affinity, never across textually identical blocks — the
three assassin sites, the three soldier sites and the three blackguard sites are
each byte-identical, so a text substitution cannot address a subset of one and
splitting them would force line-number edits.

| Group | Blocks | Sites |
|--:|---|--:|
| 1 | assassin ×3, bard, druid | 5 |
| 2 | soldier of light ×3, paladin, ranger | 5 |
| 3 | blackguard ×3, divine, arcane | 5 |
| 4 | paladín antiguo, oscuro, vengador, domain | 4 |

### 37c. Behaviour is unchanged, deliberately

The comparison stays `nDifference < nBestMissing`, strictly less, so the original
first-route-wins tie behaviour is preserved exactly.

The three assassin blocks computed their circle **inside** the winning brace
block; the conversion hoists that lookup above the call, so it now runs on a
losing route too. One extra `Get2DAString` pair on a route that loses, and the
same value either way.

This refactor is not in the changelog. Nothing a player, a DM or a builder can
observe changes, no file moves and nothing about the build changes, which is the
exemption `AGENTS.md` states.

### 37d. How each group is checked

Three counts, before and after, which must always sum to nineteen:

```bash
F=src/shared/nss/x2_pc_umdcheck.nss
grep -ac "else if(iDiferenciaNLanzador < iNLanzadorFaltante)\|else if (iDiferenciaNLanzador < iNLanzadorFaltante)" $F
grep -ac "pbUMDConsiderRoute(iNLanzadorFaltante" $F
grep -ac "iNLanzadorFaltante = stRuta.nMissing" $F
```

`-a` is not optional: the repository contract requires it for NWScript, which
GNU `grep` may classify as binary on these Windows-1252 files.

The second and third must be equal: one call, one unpack, at every converted
site.

| After group | Old-form | Calls | Unpacks |
|--:|--:|--:|--:|
| 1 | 14 | 5 | 5 |
| 2 | 9 | 10 | 10 |
| 3 | 4 | 15 | 15 |
| 4 | **0** | **19** | **19** |

With group 4 in, **every route update goes through `pbUMDConsiderRoute`**, which
is the whole point: there is no longer a place in this file where a class can be
recorded without its level and its circle.

Two bare writes remain, and both are legitimate — they are the declarations that
seed the search:

```
263: int iNLanzadorFaltante = 100;   // any real route beats this
276: int iEsferaElegida = 0;
```

`iClaseElegida` and `iNivelLanzadorElegido` are declared without initialisers on
the shared `int` line above them.

The completeness check must name **all four** fields:

```bash
F=src/shared/nss/x2_pc_umdcheck.nss
grep -an "iNLanzadorFaltante = \|iClaseElegida = \|iNivelLanzadorElegido = \|iEsferaElegida = " $F | grep -v "stRuta\."
```

It returns those two declaration lines and nothing else.

**The first version of this check listed only three fields and omitted
`iNLanzadorFaltante`**, while the sentence above it claimed a result about all
four. The audit of group 4 raised it as its only finding, and it is the same
failure as sections 32a and 36a in a new place: a check that proves less than the
claim it is offered for. `iNLanzadorFaltante = 100` was sitting in plain sight and
the grep could not see it because the grep was not asked.

Each substitution asserts its own occurrence count before writing. The first
attempt at group 1 tried to take two of the three soldier blocks and the
assertion refused, having found three — which is why the groups are by affinity.
That is the rule from section 36a applied before the fact rather than after.


## 38. Guardia Negro and Soldado de la Luz removed from the scroll system

Both classes were withdrawn from the module. Their code in `x2_pc_umdcheck.nss`
could still run for any character who retains levels in them, and one of its
effects was a defect: **any Guardia Negro level cleared `iObjetoArcano` for every
scroll**, so such a character never suffered arcane spell failure from armour, on
any scroll, whether or not it was one of theirs. Soldado de la Luz had the mirror
defect — a divine class in `classes.2da` whose block never cleared that flag at
all.

Removed: 164 lines. The two 80-line class blocks, six of the nineteen route sites,
and `CLASS_TYPE_BLACKGUARD` from the `ObtenerNivelMinimoPerga` switch, which now
routes the assassin alone.

Route counts after removal: **0** old-form blocks, **13** calls, **13** unpacks.
Thirteen routes remain where there were nineteen.

`grep -ac "BLACKGUARD\|SOLDIER_OF_LIGHT"` on the file returns 0.

**The one risk worth stating.** If a live character still carries levels in either
class, their scroll behaviour changes: they lose those routes, and a former
Guardia Negro starts suffering arcane spell failure like everyone else. No
character data was inspected. If such characters exist this is a fix rather than a
regression, but it is visible to them.


## 39. Two roll defects the external design review found

### 39a. `BONO_EXITO_UOM` was a permanent, global, object-independent +2

Set on any successful scroll roll at `x2_pc_umdcheck.nss:829` and `:891`, cleared
only on certain failures at `:834` and `:896`, and stored as a plain local on the
character — no object, no expiry, no cap. Obtain it once from the cheapest scroll
and keep it for every scroll, wand and staff for the rest of the character's life.

The SRD has a +2 for having previously activated **that same item**, and only under
*Activate Blindly*. This was not that.

It was also implemented wrong: read once into `iBonoExitoUom` at `:781`, so a
success on the first roll of an activation could not help the second roll of the
same activation.

Removed entirely. Every scroll roll is two points harder for anyone who had it,
which given how it was obtained is close to everyone.

### 39b. The SRD mishap check could not fail

```nwscript
iTirada = d20() + GetAbilityScore(oPC, ABILITY_WISDOM);
iCD = 5;
```

This is the SRD rule: fail the caster level check, then make a **Wisdom check
against DC 5** or suffer a mishap. Monti placed it correctly. But it added the
whole Wisdom **score** instead of its **modifier**, so a character with Wisdom 10
rolled `d20 + 10` against 5.

**That path into `FracasoEspectacular` was therefore dead from 2013.**

**Correction.** The first version of this section, and the commit message and
changelog entry that went with it, said the table itself had never fired. That is
false, and the full read-through of the file found it. `FracasoEspectacular` has
**three** call sites:

```
832:  if (iResultadoTirada <= -10) FracasoEspectacular(oPC);   // roll 1, emulate class
864:  FracasoEspectacular(oPC);                                // roll 2, the Wisdom mishap
897:  if(iResultadoTirada <= -10) FracasoEspectacular(oPC);    // roll 3, emulate ability
```

Only line 864 was dead. The two margin-of-ten paths on rolls 1 and 3 have always
been live, and a character with little Use Magic Device reading a hard scroll fails
by ten or more routinely — so those are, and were, the frequent ones.

That changes the impact of the repair: the mishap is not being woken from nothing.
It gains a third trigger, on a roll that only happens after a caster level failure,
and its frequency there is bounded by the Wisdom modifier.

Now `GetAbilityModifier(ABILITY_WISDOM, oPC)`. With Wisdom 10 the mishap lands on
roughly one failed caster level roll in five; with Wisdom 18 it cannot land at all.

Every effect in the table is temporary — 10 to 60 seconds — except 3d6 damage. The
worst, petrification, lasts 10 seconds.

**A separate question this raises and does not answer**: the margin-of-ten rule is
not the SRD's. The SRD ties the scroll mishap to the caster level failure followed
by the Wisdom check, and the margin of ten belongs to *Activate Blindly*. Keeping
it is a legitimate PDB choice, but it should be a stated decision rather than an
accident, and it is the most frequent way into the table.

### 39c. Not done here

**The natural 1 is still unimplemented.** The SRD makes a natural 1 always fail the
caster level check and imposes a 24-hour restriction on that item. The code
compares totals only.


## 40. Decisions on the scroll system, 2026-09-06

Taken by the owner after the full read-through of `x2_pc_umdcheck.nss` and the
external design review. Recorded here because several of them are decisions **not**
to change something, and an undocumented non-decision looks identical to an
oversight - which is how most of the defects in sections 31 to 39 came to exist.

### 40a. What was decided

| | Decision | Status |
|---|---|---|
| **D1** | The caster level requirement uses the **scroll's own** caster level, `IPRP_SPELLS.CasterLvl`, not the class level at which the circle becomes available | **Accepted** |
| **D2** | See 40b. Split into a defect and a balance question | **Split** |
| **D3** | The two skill synergies apply to **scrolls only**, not to wands, rods or staves | **Accepted** |
| **D4** | The ability requirement keeps reading the **base** score. Item bonuses do not count | **Rejected — deliberately unchanged** |
| **D5** | Withdrawn as a decision. It is a defect: see 40c | **Withdrawn** |
| **D6** | The margin-of-ten mishap stays. It is PDB flavour, not the SRD's rule | **Accepted, now stated** |

### 40b. D2, and why half of it is deferred

The three requirement flags can each be cleared by a different class. The survey
described this as a hybrid-multiclass advantage worth one to three ability points
across 64 spells.

**The full read-through found it is worse than that, and the worse half is a plain
defect.** The ability check in each class block sits **outside** the guard that
tests whether the character has levels in that class:

```nwscript
if (sBardo != "")                         // the SPELL is on the bard list
{
    int iNivelBardo = GetLevelByClass(CLASS_TYPE_BARD, oPC);
    if (iNivelBardo > 0) { ...; iEmularClase = FALSE; }    // guarded

    if (iVaritas == FALSE)
    {
        if (iEmularCaracteri == TRUE && GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE) >= 10 + iBardo)
            iEmularCaracteri = FALSE;                       // NOT guarded
```

A pure wizard with **zero** bard levels satisfies the ability requirement of any
bard-list spell against his Charisma and the bard's circle. Same shape in the
druid, ranger and paladin blocks.

So D2 splits:

**Piece 1, a defect.** The ability and caster level checks in a class block must
run only when the character has levels in that class. Nobody can defend satisfying
a bard requirement without being a bard. **Not a decision; it is being fixed.**

**Piece 2, the balance question.** Whether one class must satisfy all three
requirements by itself. **Deferred**, for three reasons:

1. **The number that justifies it will move.** The 64-spell, 1-to-3-point figure
   was measured against today's code, which includes every character with zero
   levels in the second class. After piece 1 it counts only characters who really
   invested. Deciding a balance change on a figure that is about to change is the
   mistake this campaign has already made repeatedly - see 32a, 36a and the
   retracted druid measurement in section 3 of the survey.
2. **Piece 1 removes the gross case.** What remains is a genuine hybrid using
   classes he actually has, which is a judgement rather than an error.
3. **PDB requires a minimum of three levels per class.** The cheap one-level dip
   the analysis assumed is not possible here, so the remaining advantage costs a
   real investment.

To be re-measured after piece 1 lands, then decided.

### 40c. D5 withdrawn: it was never a decision

The question asked was which classes should receive Lanzador de conjuros veterano
during a scroll check. The owner rejected the framing, correctly: the feat is not
in scope and is not the problem.

The problem is that **this file computes caster levels by hand instead of asking
the function that exists**. `GetTotalCasterLevel(oPC, iClass)` already accounts for
prestige contributions, Lanzador de conjuros veterano, the hit dice cap and
everything else. `x2_pc_umdcheck.nss` calls it **once**, in the domain branch, and
reconstructs the calculation in the other twelve places.

Three of the defects on the open list are consequences of that and not independent
decisions:

- only the wizard applies Lanzador de conjuros veterano;
- paladin, its three variants, the ranger and the assassin add no prestige
  contribution;
- the druid phantom route, from adding the prestige delta before testing for a
  base class level.

The repair is to use the canonical function, guarded by a real class level -
which is the same guard piece 1 of D2 requires. The two fixes are one piece of
work.

### 40d. D4 rejected, and why the rejection matters

Changing `GetAbilityScore(..., TRUE)` to include item bonuses was recommended in
the survey and rejected on the owner's challenge.

The requirement is `10 + circle`, so **19 at most**, for a ninth-circle spell. A
character with a base 14 and a +6 item reaches 20. Counting equipment would make
the third requirement vacuous for anyone geared.

And it would be inconsistent: neither of the other two requirements can be bought.
Reading the base score leaves all three measuring the **character** rather than the
loadout.

Recorded as a deliberate choice so that the next reader does not repair it.


## 41. The assassin, the artificer and a dead local, 2026-09-06

Five defects, none of them a design question. Group 1 of the work list in §40.

### 41a. One of the assassin's four blocks could never fire

The four blocks select on hardcoded spell ids. The file remaps a sub-radial id to
its master at line 225, **before** those comparisons, and `spells.2da` gives
`Magic_Circle_against_Good` (105) a `Master` of 322. So `iIDConjuro == 105` was
compared against a value that had already become 322 and never matched.

Now `322`, the master row `Magic_Circle_against_Alignment`. **This widens the
block**: rows 103, 104, 105 and 106 all remap to 322, so the assassin now
recognises all four alignment variants where the list named only Good. That is the
only way the block can fire at all, and it is what the remap does for every other
block in the file.

### 41b. Three assassin spells carried the wrong circle

The `Assassin` column of `spells.2da` is **empty for all twenty ids** the blocks
list - the assassin's own rows are separate wrapper spells. So
`pbGetSpellCircleForClass(iIDConjuro, CLASS_TYPE_ASSASSIN)` returned `-1` every
time and the code fell through to `Innate`, which disagrees for three:

| Spell | Block | `Innate` used | Should be |
|---|--:|--:|--:|
| FalsaVida | 3 | 2 | **3** |
| Clairaudience_and_Clairvoyance | 4 | 3 | **4** |
| Poison | 4 | 3 | **4** |

The blocks already know their circle - it is what they select on. They now use it
directly and the lookup is gone.

### 41c. The assassin's contribution to the ability DC was dead code

`458eb71f2` added the assassin to the cheapest-circle calculation behind
`if (iEsferaAsesino >= 0)`, using the same lookup that always returns `-1`. The
guard could never pass.

The circle is now recorded in a local by whichever of the four blocks fires, and
the DC uses that.

**The first attempt recorded it in the wrong place** and the audit caught it. The
assignment sat inside the `else` of the caster level branch, reached only when the
assassin is **below** the required level, and inside `if(iEmularNLanzador == TRUE)`
as well. A level-5 assassin reading *FalsaVida* with low Intelligence therefore
still had `-1` and still fell back to `Innate`. It is now assigned where the block
is entered, beside `iEmularClase = FALSE`, so it is set whenever the block matches
regardless of level or of what another class already satisfied.

### 41d. The artificer reaches circle 1 at class level 1

`ObtenerNivelMinimoPerga` asked class level 2. `cls_spgn_ing` grants circle 1 at
class level 1.

**This is the only drift in the whole switch.** The survey claimed the druid was
two levels out on circles 8 and 9; that was **retracted** - the measurement scanned
for the first non-empty `SpellLevel<N>` column and ignored `NumSpellLevels`, which
bounds the answer. Read the way `GetCasterMaxSpellLevel` reads it - highest filled
column, bounded by `NumSpellLevels - 1` - the druid, both paladins, the three
custom paladins and the assassin all match their tables exactly. Six classes route
to tables PDB does not override and are not checkable from `haks-2da/` alone.

### 41e. `iVeterano`

Declared, never read. Removed.


## 42. Group 2: the arcane route and an ungated optimisation, 2026-09-06

### 42a. The arcane block chose the most levels, not the best route

Wizard, sorcerer and artificer share the `Wiz_Sorc` column, so the spell's circle
is the same for all three. Their **progressions** are not: circle 3 costs the
wizard 5 levels, the sorcerer 6 and the artificer 9.

The block picked the class with the highest level and then evaluated only that one.

> **Mago 5 / Artífice 6**, circle-3 scroll. The wizard already satisfies his
> requirement of 5. The artificer has more levels, so he is selected, and he is
> **three short** of his own requirement of 9. The character rolls.

Now each of the three is measured against **its own** requirement and the smallest
deficit wins, **with a tie broken by the higher level** - which is what the block
selected on outright before. That keeps every previous answer where the deficits
are equal and changes only the case they disagree about.

The first attempt used a strict "smaller deficit wins" and the audit caught two
regressions in it. A Mago 3 / Hechicero 4 on a circle-2 scroll ties at a deficit of
zero; keeping the seeded wizard moved the ability check from Charisma to
Intelligence, so a character with Int 10 and Cha 12 gained a roll he did not have.
And an Artifice 3 with no wizard levels ties at three, so the seeded wizard was
kept - a class he does not have - which contradicted the slice's own invariant.

The ability still follows the chosen class, unchanged.

**Both `PrimaryAbil` and `SpellcastingAbil` were checked** for every casting class
in `classes.2da`: they agree everywhere, and the artificer is `INT`, so the
block's existing default is right. A future table-driven rewrite should read
`SpellcastingAbil`, but nothing depends on the difference today.

### 42b. The class-versus-caster optimisation ran with nothing to compare against

```nwscript
if(iEmularClase == FALSE)
{
    ...
    iCDLanzador = ObtenerNivelMinimoPerga(iClaseElegida, iEsferaElegida) + 1;
    if(iDifUOM < iDifLanzador) iEmularClase = TRUE;
}
```

The intent is kind: if the Use Magic Device roll is cheaper than the caster level
roll, take it. But the comparison ran whenever the character was **of the class**,
including when the level requirement was already met and no route had ever been
recorded. `iClaseElegida` and `iEsferaElegida` are then still `0`, so `iCDLanzador`
is built from class 0 at circle 0 - which is 1 - and a character with a large Use
Magic Device bonus could have a class emulation roll armed when all he lacked was
the ability score.

Now gated on `iEmularNLanzador == TRUE`. If there is no caster level roll to spare,
there is nothing to trade it for.

### 42c. Not done: the seventeen unreachable circles

Fourteen spells carry seventeen entries at a circle their class can never reach:
six Ranger circle-5, four Paladin-family circle-5, five Bard circle-7 and two
Bard circle-8 - seventeen in all. `ObtenerNivelMinimoPerga` has no case for them and returns **0**, so
the requirement becomes zero and any level satisfies it - a Ranger 1 clears the
caster level requirement of *Cure Critical Wounds*.

| Spell | Column | Circle | Class maximum |
|---|---|--:|--:|
| Cure_Critical_Wounds, Death_Ward, Summon_Creature_V, Monstrous_Regeneration, Comunion_Naturaleza, Ira_Naturaleza | `Ranger` | 5 | 4 |
| Geas | `Paladin`, `PaladinAntiguos`, `PaladinOscuro`, `PaladinVengador` | 5 | 4 |
| Jaula_de_Fuerza, Espejismo_Arcano, Proyectar_Imagen, Simbolo, Suenyo_Velo_Azul | `Bard` | 7 | 6 |
| Debilidad_Mental, Labia | `Bard` | 8 | 6 |

**Resolved 2026-09-06: four of the seventeen were live and are removed; thirteen
were never reachable and are untouched.** The three readings below were the
analysis before that split was found; they are kept because the reasoning about
"remove" versus "lower" still applies to the thirteen when they are activated.

### The split that settled it

Only four of the seventeen can reach this system at all:

| | `UserType` | Row in `IPRP_SPELLS` | Can exist as a scroll |
|---|:--:|:--:|:--:|
| The four `Ranger = 5` entries | **1** | **yes** | **yes** |
| The other thirteen | blank | no | **no** |

A blank `UserType` means the engine does not present the row as a player spell,
and **without a row in `IPRP_SPELLS` no Cast Spell item property can exist**, so no
scroll, wand or potion of them can be made. They cannot cause this defect whatever
they are.

The thirteen are the incoming work recorded in §16, and their circles are not
careless copies - they are the correct circles for where they are going. An earlier
version of this section claimed the author had copied one circle across every
column; that reading was wrong and is retracted.

The four are different: PDB **added** them to the `Ranger` column, vanilla has no
Ranger entry for any of them, and all four are scribable. Two tables say so, and an
earlier version of this section credited both facts to the first of them:

| Table | Columns | What it gives |
|---|---|---|
| `des_crft_spells.2da` | `Label IPRP_SpellIndex NoPotion NoWand NoScroll Level CastOnItems` | `NoScroll = 0` for all four |
| `mti_crft_scroll.2da` | `Label ResRef` | the four scroll resrefs |

```
row  31 -> X2_IT_SPDVSCR402
row  38 -> X2_IT_SPDVSCR403
row 179 -> NW_IT_SPARSCR510
row 525 -> X2_IT_SPDVSCR502
```

`des_crft_spells.2da` has no resref column at all. Removed.

| Row | Spell | Was | Now |
|--:|---|--:|---|
| 31 | Cure_Critical_Wounds | Ranger 5 | `****` |
| 38 | Death_Ward | Ranger 5 | `****` |
| 179 | Summon_Creature_V | Ranger 5 | `****` |
| 525 | Monstrous_Regeneration | Ranger 5 | `****` |

Field widths preserved byte for byte; the file is the same size before and after.

Re-measured after the edit: **zero** active entries above their class maximum
remain. Thirteen remain in switched-off rows.

### The original three readings, for the thirteen

Three readings, with different consequences:

1. **Data errors.** The circles should be within reach and the 2DA should be
   corrected, not the code.
2. **Deliberately unobtainable.** The class is listed for flavour and no member can
   ever cast it, in which case the block should not treat the spell as a class
   spell at all and the character should emulate the class like anyone else.
3. **A cap that should be raised.** The class is meant to reach that circle and its
   gain table is what is wrong.

Reading 2 is the only one implementable here, and it is the harshest. Left as a
question for the owner.

There is a related hole this exposes and does not close: **the code assumes a route
exists whenever `iEmularNLanzador` is TRUE.** When none was recorded, the
difficulty is built from class 0 at circle 0 and comes out as 1. 42b removes one
way to reach that state; it does not remove the state.


## 43. Group 3: the class guard, the hand-rolled feat and the wand synergies

### 43a. The class blocks ran for characters without the class

Each block is entered because **the spell** is on that class's list. Whether the
**character** has the class was tested only around `iEmularClase`, so the ability
check and the caster level route below it ran regardless:

```nwscript
if (sBardo != "")                          // the SPELL is a bard spell
{
    int iNivelBardo = GetLevelByClass(CLASS_TYPE_BARD, oPC);
    if (iNivelBardo > 0) { ...; iEmularClase = FALSE; }   // guarded

    if (iVaritas == FALSE)                                 // NOT guarded
    {
        if (iEmularCaracteri == TRUE && GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE) >= 10 + iBardo)
            iEmularCaracteri = FALSE;
```

A pure wizard with **zero** bard levels satisfied the ability requirement of any
bard-list spell against his Charisma and the bard's circle. Nine blocks had the
shape; the assassin blocks and the domain branch were already guarded.

This is piece 1 of D2, recorded in §40b. **Piece 2 - whether one class must satisfy
all three requirements by itself - is still deferred**, and the figure that justifies
it must be re-measured now that this guard exists, because the old count included
characters with no levels in the second class.

**Piece 1 has two sites and the first attempt did only one.** Guarding the class
blocks stops an absent class from *satisfying* the requirement, but the difficulty
of the roll is built separately, in the block added by `458eb71f2`, from the
cheapest circle among **every** class the spell is listed for. A pure wizard was
therefore still priced at the bard's circle. Those nine contributions are now
guarded too, re-reading the class level because the blocks declare theirs locally.
The audit of this slice raised it.

### 43b. The only hand-rolled caster level in the file

**Correction to the first version of this section**, which said every block
computes `GetLevelByClass + pbCLGetPrestigeDelta` and that all thirteen routes now
compute identically. Neither is true, and section 42's own F-E finding already said
so:

| Route | Formula |
|---|---|
| Bard, divine, druid, wizard, sorcerer, artificer | `GetLevelByClass` + `pbCLGetPrestigeDelta` |
| Assassin, paladin, its three variants, ranger | `GetLevelByClass` **only** |
| Domain | `GetTotalCasterLevel(oPC, CLASS_TYPE_CLERIC)` |

Six of thirteen add the prestige contribution, six use the raw class level and one
asks the canonical function. **That divergence is untouched by this slice** and
remains the open item recorded as F-E. What this slice removes is the one thing in
the file that was neither of those three - a feat added by hand:

```nwscript
if (GetHasFeat(1369, oPC)) { iNivelMago += 4; if (iNivelMago > iDG) iNivelMago = iDG; }
```

Lanzador de conjuros veterano, added to the wizard and to nothing else - not the
sorcerer or the artificer in the same branch, not any divine class, and not the
domain branch, which asks `GetTotalCasterLevel` and receives **no** feats because
that function withholds them when the spell comes from an item:

```nwscript
if (GetSpellCastItem() == OBJECT_INVALID && iBaseClass != CLASS_TYPE_INVALID)
{
    // Lanzador de conjuros veterano, Elixir de Conocimiento
}
```

A scroll is an item. So the wizard was the one route in this file carrying the
feat, by hand, against a canonical function that deliberately refuses it - and the
comment beside that refusal gives the reason: an item *"carries its own caster
level"*.

Removed, and `iDG` became unused with it.

**The cost is zero to four levels, not four.** The removed code was
`iNivelMago += 4; if (iNivelMago > iDG) iNivelMago = iDG;`, so what the feat
actually gave was `min(4, hit dice - caster level)`. A **pure** wizard has no
headroom - his hit dice equal his class level - and gained **nothing** from it, so
he loses nothing now. The feat only paid a wizard carrying non-caster hit dice, a
Mago 10 / Guerrero 5 for instance, and there it paid up to its full four.

An earlier version of this section, the handoff and the changelog all claimed a
flat four-level loss. A test built on that would have used a pure wizard and
observed no change at all.

### 43c. The synergies were paying for wands

`GetSkillRank(16)` and `GetSkillRank(29)` are Conocimiento de Conjuros and
Descifrar Escritura; five ranks in each grants +2, up to +4. That is the SRD rule
and it is **scroll-only** - knowing spells and deciphering written magic help you
read a scroll, not point a wand.

They were added whenever they were computed. Now computed only when the item is not
a wand, rod or staff.

**They never reached all three rolls**, which an earlier version of this section
claimed. They land on the class-emulation roll, the ability-emulation roll and the
comparison that chooses between them. The **caster level roll is
`d20 + iNivelLanzadorElegido`** and takes no skill at all, so nothing about it
changes.

### 43d. Still open

**D1**, the scroll's own caster level from `IPRP_SPELLS.CasterLvl`, is unstarted
and is what would settle the question 43b raises: this system compares a character
against a **circle**, where the SRD compares him against the **item's** caster
level.

**D2 piece 2**, and the residual hole from §42c: the code still assumes a route
exists whenever `iEmularNLanzador` is TRUE.
