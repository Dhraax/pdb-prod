# Caster Level

Status: **current static description, reviewed 2026-09-06.** The engine-facing
prestige modifier is implemented and `GetTotalCasterLevel` now consumes it, so
there is one calculation rather than two. **The HAK repack shipped on
2026-09-03**, so the `classes.2da` half is live; the NWScript half waits on a
module build. In-game validation is recorded in the changelog test list.

## Current ownership

**The engine owns the number and the module writes into it.** There is one
calculation, in `inc_casterlevel.nss`, reading `haks-2da/classes.2da`.

| Layer | Owner | Used by |
|-------|-------|---------|
| Engine caster level | `inc_casterlevel.nss` writes per-class prestige deltas through `NWNX_Creature_SetCasterLevelModifier` | Native `GetCasterLevel`, spell resistance and the caster level recorded on created effects |
| Module caster level | `pb_nivellanzador.nss` and `GetTotalCasterLevel`, which **read** the engine value and add only what the engine cannot know | PDB spell scripts and helpers that call the project function |

`GetTotalCasterLevel` resolves in three ordered routes:

1. **No class named** - the ordinary cast - the native `GetCasterLevel`.
2. **A class named** by the caller or by the warlock and artificer feat
   detection, or route 1 returned nothing: `GetLevelByClass` plus
   `pbCLGetPrestigeDelta`, the same function that wrote the engine's modifier, so
   the two routes cannot disagree. Entered only when `classes.2da` marks the
   class a spellcaster.
3. **Still zero**: the native `GetCasterLevel`, reproducing what the removed
   `default:` branch did for any class the old switch did not recognise.

**Inside an area of effect the module's bonuses come from the creator.** Route 1
gives the level the area was created at, but the feats and locals behind Lanzador
Veterano, the Elixir and Poder de Conjuro live on the caster, not on the area, so
they are read from `GetAreaOfEffectCreator`. They were read off the area itself
until 2026-09-04.

This only ever bit a script that **passes the area**. Two do:
`nw_s0_evardsa.nss` and `nw_s0_evardsc.nss`. Every other area script named by
`vfx_persistent.2da` passes `GetAreaOfEffectCreator()` or a named caster and was
always reading the right object.

It then adds the three module bonuses the engine has no way to know about, in a
deliberate order: Lanzador Veterano `+4` **capped at hit dice**, then the Elixir
de Conocimiento `+4` and Poder de Conjuro, both of which are meant to exceed that
cap. Poder de Conjuro is arcane-only and does not apply through an item.

Because route 1 asks the engine, an area-of-effect script gets the caster level
the area was created with rather than zero; the engine has stored it since build
8193.36.

## Where the modifiers are written

`pbCLApplyModifiers` recomputes and writes every casting class's delta. It is
called from four boundaries:

| Boundary | Script |
|---|---|
| **Before every spell cast, by any creature** | `event_castbefore.nss`, on `NWNX_ON_CAST_SPELL_BEFORE` |
| A player entering | `wrap_on_clnt_ent.nss` |
| A player levelling up | `wrap_on_ply_lvl.nss` |
| Any creature levelling down | `event_leveldown.nss`, on `NWNX_ON_LEVEL_DOWN_AFTER` |
| A DM levelling a creature | `zep_cw_levelup.nss`, `zep_cw_leveldown.nss` |

**The cast boundary is the one that guarantees correctness.** The player hooks
alone would leave every NPC without a contribution, and installing lazily from
`GetTotalCasterLevel` would miss the impact scripts that read `GetCasterLevel`
directly and never reach it - eighteen in `src/` and every base-game script.
`OBJECT_SELF` in that event is the caster, so one call covers every creature and
every impact script.

**There is deliberately no "already installed" mark.** A mark has to be
invalidated by everything that changes class levels, and this repository has ten
`LevelUpHenchman` callers outside the creature wizard as well as creature
serialisation, which drops the NWNX modifiers while carrying object locals - see
[`../nwscript/engine-behavior.md`](../nwscript/engine-behavior.md). Recomputing
is cheap, derived entirely from class levels, and cannot go stale.

## Engine-facing prestige levels

`inc_casterlevel.nss` reads the casting and prestige progression columns from
`haks-2da/classes.2da`. For each spellcasting base class on a character, it
computes the compatible prestige contribution and writes a non-persistent NWNX
caster-level modifier.

The creature must have at least one real level in that base class. A prestige
class advances casting the creature already has; it cannot create a wizard,
cleric, druid or other base casting class by itself. This guard applies both to
the engine modifiers and to named-class callers of `GetTotalCasterLevel`.

The modifier is recomputed:

- when the player enters;
- after level up;
- after level down.

A zero delta removes the stored modifier. The value is intentionally not
persisted because class progression is the authority and recomputation prevents
saved state from drifting from the character.

Four classes advance at every class level except their first and cannot be
represented by a divisor alone: the arcane and divine Harper variants, Pale
Master and Eldritch Knight. That exception is owned explicitly by
`pbCLGetSkipsFirstLevel`.

## 2DA responsibilities

The engine-side semantics of these columns are recorded once, in
[`../nwscript/engine-behavior.md`](../nwscript/engine-behavior.md). What follows
is what PDB does with them:

- `ArcSpellLvlMod` and `DivSpellLvlMod` describe prestige spell-slot
  progression and also provide the data from which PDB computes its prestige
  caster-level delta;
- `CLMultiplier` scales a class's own engine caster level;
- the module must not enable the NWNX
  `ADD_PRESTIGECLASS_CASTER_LEVELS` tweak while also writing the same prestige
  contribution through `inc_casterlevel.nss`.

The exact project values live in `haks-2da/classes.2da`. An ignored local vanilla
2DA copy may be used for comparison, but it is not project authority and must be
identified as external evidence.

## The casting gate

`GetCasterCanCast`, called from `cwa_enforcer.nss:30` on every player cast,
decides whether a character may cast a spell at all. It names no class. The
spell's circle comes from the `spells.2da` column that `classes.2da`
`SpellTableColumn` gives for the casting class, and the ceiling from the highest
`SpellLevel` column carrying a value in that class's `SpellGainTable`, **bounded
by that row's `NumSpellLevels`**.

The two disagree in both directions — `cls_spgn_dru` fills `SpellLevel9` at class
level 14 while counting 8, and `cls_spgn_ing` counts more circles than it fills —
so the lower of them wins. **The same ceiling decides whether an item property
granting a bonus spell slot may stay equipped**, through `pb_ip_slots_inc.nss`
from `wrap_on_equip_it.nss:378`, so an unbounded answer let a druid of class
level 14 equip a ninth-circle slot item.

Two rules govern it:

- **It is indexed by the slot level, not the caster level.** Class levels plus
  the prestige advancement, rounded up. Lanzador Veterano, the Elixir and Poder
  de Conjuro raise the caster level and deliberately do not raise the circle a
  character may cast. The `iDotes` parameter is now inert for that reason: the
  answer is unconditionally the one it used to select with `FALSE`.
- **It fails open.** An invalid class, a class with no `SpellGainTable`, or a
  table that resolves to nothing all return 9. A gate may only refuse a cast it
  can positively prove is above the ceiling. The Brujo is the live case, since
  `CLS_SPGN_WARLOK` no longer exists and its invocations are feats that
  `cwa_enforcer` already exempts.

**A readable row whose circle columns are all blank is not an unreadable input.**
It is a class with no spells yet — a paladin or ranger below `MinCastingLevel` —
and returns 0.

**The Brujo has a spell list and no slots.** `spells.2da` gives 98 rows a circle
in its `Warlock` column, but `classes.2da` points its `SpellGainTable` at
`CLS_SPGN_WARLOK`, which no longer exists, so there is no table saying how many
slots he gets. He casts invocations, which are feats, and `cwa_enforcer.nss:30`
discards the gate's verdict for a feat cast — so he never reaches the refusal at
all. The fail-open above protects a path he does not currently take, and becomes
load-bearing if he is ever given a spellbook.

## The character's caster level

`GetCL` answers a different question from `GetTotalCasterLevel`: not "what caster
level is this spell running at" but "how strong a caster is this character",
asked outside any cast. Its four consumers are three thresholds - the golem at
10, the bone-servants scroll at 13, and one at 15 in `pb_mod_activate.nss` - and
the `!ecl` chat command, which prints the number to the player.

**It returns the highest casting class, not the sum of them**, each with its
prestige contribution from `pbCLGetPrestigeDelta`. A Mago 10 / Clérigo 10 is a
tenth-level caster twice over, not a twentieth-level one.

**Which classes count is a named decision, not a data lookup.**
`pbCLGetIsFullCaster` lists the eight this answer has always been built from:
bard, cleric, druid, sorcerer, wizard, Alma Predilecta, Brujo and Artífice.
`classes.2da` marks six more with `SpellCaster = 1` — the four paladins, the
ranger and the assassin — and counting those would take a pure paladin from
nothing to his full class level and across two of the three thresholds.

**Decided 2026-09-04: half-casters do not count.** Paladin, ranger and assassin
are deliberately outside the set, which is the behaviour that has always been in
place.

**One of the three thresholds runs backwards, and the item is not what its name
suggests.** *Atraer la desgracia* is a **self-curse**: after a seven-and-a-half
second cinematic it applies a permanent `EffectCurse(1,1,1,1,1,1)` to the user
**and to every creature in a large sphere around him**, with no faction check, so
allies are included.

`pb_mod_activate.nss:1736` refuses it when `iCasterLevel >= 15`, while the
message says the character lacks the level. The two disagree. The item written
immediately below it, `explotarcadaver`, uses the ordinary shape —
`if (iPlmLevel < 4)` then refuse — which is why the `>=` reads as a typo for `<`.

**Decided 2026-09-04: not fixed.** Two readings are possible and nothing
distinguishes them from the code: either the gate means "a strong enough caster
shrugs this off", in which case the condition is right and the message is wrong,
or it means "you need the level to invoke it", in which case the condition is
wrong. Flipping it either removes the item from everyone above 15 who can use it
today, or keeps letting weaker characters curse themselves.

The consequence of `GetCL` dropping is therefore not a straightforward gain:
**more characters can now curse themselves and everyone standing near them.**

It previously summed every casting class and, for the Brujo, the Alma Predilecta
and the Artífice, added each one's level twice.

## What circle a spell occupies

`pbGetSpellCircleForClass(iSpellId, iClass)` in `pb_nivellanzador.nss` owns that
question for the whole module. It reads the class's `SpellTableColumn` from
`classes.2da`, then that column of `spells.2da`, and returns `-1` when the class
does not have the spell. It names no class.

Both the casting gate and the scroll system call it. They previously asked
separately: the gate read the column, the scroll system used the spell's `Innate`
level, and across the nine `spells.2da` columns the scroll system reads —
`Bard`, `Cleric`, `Druid`, `Paladin`, `Ranger`, `Wiz_Sorc`, `PaladinAntiguos`,
`PaladinOscuro` and `PaladinVengador` — those are different numbers for **104
class-and-spell pairs**, **23** of them stricter than the class's own list, so a
cleric with exactly the level for *Control de muertos vivientes* was still asked
to roll. The remaining 81 were looser.

An earlier revision of this document gave 86 and 20. That survey covered only the
six stock columns and dropped rows whose cell is `*****` rather than `****`; it
also counted sub-radial rows the file remaps through `Master` before looking
anything up. The numbers above are measured over exactly the nine columns the
code reads, on master rows only.

**Domains are part of the same lookup.** Passing the creature makes
`pbGetSpellCircleForClass` read its domains as well, and return **the minimum** of
the routes that exist — the class list and each of the two domain slots. A domain
is a second way to reach the same spell at a slot of its own, so the requirement
is the cheapest slot the character could really spend.

The minimum matters in both directions. Over the 160 `Level_N` entries in
`domains.2da`, the domain level equals the spell's `Innate` level for 90, sits
**below** it for 50 — the ordinary case, a domain is a discount — and **above** it
for 20, where the domain places the spell in a more expensive slot than its
innate power suggests.

Driven by `classes.2da:PickDomains`, so the function still names no class; only
row 2 carries it, and `GetDomain` accepts index 1 or 2 only
(`nwscript.nss:12140`).

`GetCasterCanCast` no longer walks `domains.2da` itself. Its loop searched the
second domain only when the first held no match, so **slot order decided the
answer**; ten spells sit in more than one domain at different levels, so this was
a live difference and not a hypothetical one. It also overwrote the class circle
with the domain one rather than taking the cheaper, which agrees with the minimum
only because no domain places a spell above the **cleric list** — a narrower
statement than the `Innate` comparison above, and one a table edit could break.

`VerSiEsConjuroDeDominio` in `dominios_inc.nss` still decides *whether* a spell is
a domain spell for a character, from a hand-written per-feat list of spell ids,
and produces no level. It is a fourth copy of a related question and is unchanged;
the feats it tests are the `FEAT_*_DOMAIN_POWER` granted by picking a domain, so
it and `GetDomain` describe the same choice from two directions.

The live scroll path no longer calls it. `x2_pc_umdcheck.nss` asks
`pbGetDomainCircleForSpell` directly, so `domains.2da` decides both whether the
route exists and its circle. Its three UMD requirements are independent and
monotonic: once one valid class route satisfies the ability requirement, a
second domain route with a worse ability score cannot turn the requirement back
on.

If an ability-emulation roll is still needed, its DC is `15 + required ability
score`, where the required score is `10 + the cheapest real class or domain
circle` available for that spell. The spell's `Innate` value is only a fallback
for malformed or otherwise unclassified rows; it is not used in place of a
known class circle.

## Known limitations

- A character with two compatible base casting classes receives a prestige
  class's progression when casting as either one. The engine evaluates only the
  selected casting class, so the value is not added twice to one cast, but PDB
  does not persist the 3.5 choice of which base class a prestige class advances.
- `GetTotalCasterLevel`, `GetCasterMaxSpellLevel`, `GetCasterCanCast` and
  `GetCL` are consolidated and read their rules from `classes.2da`. None of the
  four carries a class list any more.
- `GetSpecialCasterLevel` now has **no live caller**. It had one, not two:
  `pb_ip_slots_inc.nss` looked like a consumer but its calls are inside a
  commented-out block, and `x2_pc_umdcheck.nss` was converted on 2026-09-04. It
  is dead code awaiting deletion.
- The four classes that advance at every level but their first keep **full** slot
  progression, because `ArcSpellLvlMod` is a divisor and cannot express an offset.
  Only their caster level is `level - 1`.
- The prestige contribution depends on the NWNX Creature plugin. If
  `NWNX_CREATURE_SKIP` were ever set, prestige caster levels would disappear
  silently. There is no startup assertion for it.
- Metamagic context inside area scripts is not established by the native caster
  level and class accessors and still requires a focused probe.

## Evidence and remaining work

- Current implementation: `src/shared/nss/inc_casterlevel.nss`,
  `pb_nivellanzador.nss`, `event_castbefore.nss`, `wrap_on_clnt_ent.nss`,
  `wrap_on_ply_lvl.nss`, `event_leveldown.nss`, `zep_cw_levelup.nss` and
  `zep_cw_leveldown.nss`.
- Current project data: `haks-2da/classes.2da`.
- Native engine context:
  [`../nwscript/engine-behavior.md`](../nwscript/engine-behavior.md).
- Implementation research, corrected assumptions and remaining slices:
  [`../pending-changes/caster-level.md`](../pending-changes/caster-level.md).
- Player-visible change and tests:
  [`../changelog/modulo/2026-09.md`](../changelog/modulo/2026-09.md).
