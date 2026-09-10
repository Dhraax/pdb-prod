# The spell effect library — `inc_spells.nss`

What applies and removes spell effects on this server, what is wrong with it,
and the order in which to fix it.

**Status: active implementation record, reviewed through 2026-08-26.** The
library split, ownership API, darkness, web, invisibility sphere, mind fog,
effectiveness removal and the first identity migration are implemented in the
completed slices below. Slices 6, 7 and the unfinished parts of 8 remain open.
This document preserves the evidence and remaining plan; its early findings are
not a current-state summary when a later slice explicitly retracts or closes
them.

---

## 1. What the library is for

`src/shared/nss/inc_spells.nss`, 856 lines. Four jobs:

| Job | Function |
|---|---|
| Decide whether a target is a legal one | `gsSPGetIsAffected` |
| Roll spell resistance and report it | `gsSPResistSpell` |
| Apply an effect | `gsSPApplyEffect` |
| Remove effects again | `gsSPRemoveEffect`, `gsSPfindEffect` |

Plus an area-of-effect helper set (`CreateNonStackingPersistentAoE` and the
`AoE*` accessors), a memorised-spell helper, and three functions bolted on at
the end that are discussed in finding 6.

**50 files call into it**: 13 base-game spells, 18 PDB feats and spells, 10
class scripts, the potion include, and eight others including the DM console and
the client-enter wrapper.

---

## 2. Findings

### F1. The whole "spell effectiveness" machinery is dead code

`gsSPApplyEffect` does this on **every one of its 63 call sites**:

1. walks the target's **entire** effect list, counting;
2. reads current hit points;
3. applies the effect;
4. walks the **entire** effect list again, counting;
5. compares, and calls `gsC2AdjustSpellEffectiveness`.

Which does:

```nwscript
string sString = GS_C2_SPELL_EFFECTIVENESS + IntToString(nSpell);   // "GS_C2_SE_123"
nEffectiveness += nEffective ? -3 : 1;
SetLocalInt(oCreature, sString, nEffectiveness);
```

**Nothing reads that variable.** Searching all of `src/` for the constant and for
its literal `"GS_C2_SE_"` returns two hits, both inside `inc_spells.nss`: the
declaration, and that write. `gsSPResistSpell` feeds the same counter.

So two full effect-list walks per effect applied, to maintain a number nobody
consults.

### F2. And the measurement would not be trustworthy even if something read it

Counting effects before and after is not a sound test of "did the spell land":

- an effect that **replaces** one of the same type leaves the count unchanged;
- a **linked** effect counts as several entries;
- an unrelated effect expiring between the two counts moves the number on its
  own;
- `GetHasSpellEffect(nSpell, oTarget)` answers TRUE for an effect from an
  **earlier cast or another caster**, so it is a false positive by design;
- the hit-point comparison fails against immunity, and succeeds by accident when
  regeneration or a poison ticks between the two reads.

### F3. ~~Removing an effect while iterating skips effects~~ — **wrong, retracted**

An earlier version of this document claimed that `RemoveEffect` inside a
`GetFirstEffect`/`GetNextEffect` loop skips entries, reasoning that
`CNWSObject::m_appliedEffects` is a `CExoArrayList` and removal shifts it.

**That is not how the engine works.** Removal is deferred: the object carries

```cpp
CExoArrayList<CGameEffect *> m_appliedEffects;
…
BOOL m_bPendingEffectRemoval;
```

(`nwnxee/NWNXLib/API/API/CNWSObject.hpp:95-98`). An effect removed from a script
is marked and cleaned up afterwards, so the list does not shrink under the
cursor and the loop visits every entry. The NWN Lexicon documents the same
behaviour and uses that exact loop as its example.

The claim came from reading the container type and stopping there. It is
retracted, and with it the finding that darkness's enter script leaves its
second effect behind — see F7.

`RemoveEffectsFromSpell` in `nw_i0_spells.nss` uses the same loop and is
therefore also fine. It was named as suspect here and is cleared;
[`bonus-stacking.md`](bonus-stacking.md) never made the claim.

### F4. It matches on a spell id that half the module cannot produce

Every filter goes through `GetEffectSpellId`. The installed `nwscript.nss`:

> *Returns **-1** if eSpellEffect was applied **outside a spell script**.*

So an effect applied from an item activation, a conversation, an event handler
or a `DelayCommand` carries `-1` and can never be matched by spell id. This is
the same root cause behind the bonus-stacking problems in
[`bonus-stacking.md`](bonus-stacking.md) and the Negative Energy Burst report.

**Area-of-effect scripts are not affected**, which was an open question until
`nwscript.nss` answered it under `GetSpellId`:

> *If used in an **Area of Effect script** it will return the ID of the spell
> that generated the AOE effect.*

An AoE script carries a spell context, so effects applied there are tagged with
the spell that created the area. That is why BioWare's own darkness exit script
matches on spell id at all. The `-1` problem is real everywhere else.

### F5. `gsSPRemoveEffect`'s default removes everything

```nwscript
int gsSPRemoveEffect(object oTarget, int nSpell = -1, …)
```

`nSpell = -1` means "any spell", so `gsSPRemoveEffect(oTarget)` strips every
effect that is not Supernatural or Unyielding. All 52 call sites currently pass
a spell explicitly, so nothing is broken today — it is a loaded gun rather than
a wound.

### F6. Three functions were bolted onto the end, and they duplicate the library

Lines 814-854 hold `PJ_EfectoBuscarTag`, `PJ_EfectoQuitar` and
`PJ_EfectoQuitarTag`. They break the project's conventions and duplicate what
is already there:

| Bolted-on | Already exists as |
|---|---|
| `PJ_EfectoBuscarTag(oPJ, sTag)` | `gsSPfindEffect(…, sTag)` |
| `PJ_EfectoQuitarTag(oPJ, sTag)` | `gsSPRemoveEffect(oTarget, -1, OBJECT_INVALID, sTag)` |
| `PJ_EfectoQuitar(oPJ)` | `gsSPRemoveEffect(oTarget)` |

They also carry prototype and definition adjacent instead of in the file's two
sections, Spanish comments with no `@brief` block, and no author marker — all
against `AGENTS.md`.

**And they are worse than what they duplicate.** `PJ_EfectoQuitar` has no
Supernatural or Unyielding guard, so it strips racial and class effects that
`gsSPRemoveEffect` deliberately protects. It has **zero callers**, which is the
only reason that has not bitten.

`PJ_EfectoQuitarTag` has **12 callers** — the chat bubbles, haste, mass haste
and the potion include — and `PJ_EfectoBuscarTag` has two, both in the DM
console.

### F7. Darkness: one proven fault, and one open question

Reported as *"siempre está bug, te quedas con el efecto pegado"*. Partly
confirmed — see the retraction inside.

**Fault 1 — seven spells, two removals.** `vfx_persistent.2da` row 11 gives
`VFX_PER_DARKNESS` the scripts `NW_S0_DarknessA` on enter and `NW_S0_DarknessB`
on exit. **Those two scripts are hard-wired there for every darkness area,
whatever cast it** — the variants are not separate implementations, they are
separate `spells.2da` rows reaching the same pair:

| Id | Spell | Reached from | Removed on exit? |
|---:|---|---|:-:|
| 36 | Darkness | the spell | yes |
| 345 | SHADOW_CON_Darkness | shadow conjuration | yes |
| 606 | ASDarkness | feat 469, `FEAT_PRESTIGE_DARKNESS` | **no** |
| 1203 | Blig_Darkness | blighter | **no** |
| 1529 | MMF_Darkness | | **no** |
| 2935 | DROW_OSCURIDAD | feat 4512, granted by `cls_feat_*.2da` | **no** |
| 3062 | ONI_OSCURIDAD | feat 4747, granted by `cls_feat_*.2da` | **no** |

`nw_s0_darknessb.nss` removes `SPELL_DARKNESS` (36) and
`SPELL_SHADOW_CONJURATION_DARKNESS` (345) and nothing else. **Five of the seven
darknesses on this server apply an effect that is never removed** — and slice 1
measured those effects as `DURATION_TYPE_PERMANENT`, so nothing else expires
them either.

**This is not a routing problem.** Every route already calls one enter script and
one exit script; there is nothing to unify. The fault is that the one exit script
asks *which spell row applied this* instead of *what is this effect and who owns
it*, which is 3b in miniature.

**~~Fault 2 — two effects, one removal pass.~~** Retracted with F3. Removal is
deferred, so the pass does visit both effects and takes both.

**What is left, and what is now unexplained.** Fault 1 is solid and accounts for
five of the seven darknesses — `ASDarkness`, `Blig_Darkness`, `MMF_Darkness`,
`DROW_OSCURIDAD` and `ONI_OSCURIDAD` apply a permanent effect that
`nw_s0_darknessb.nss` never removes. It does **not** explain a plain `Darkness` (36) sticking, and the report
says *"siempre"*.

**And a safety net already exists, with the same blind spot.**
`wrap_on_clnt_ent.nss` carries `RemoveStuckDarknessEffects`, which on login
checks whether the player has darkness and is not standing in one, and strips it
if so. It was added precisely because the effect was getting stuck.

It only knows `SPELL_DARKNESS`. `GetHasSpellEffect(36, oPC)` is false for a drow
darkness, and `GetAoEId(oAreaEffect) == 36` never matches a drow area, so the net
does not catch the five rows that need it most.

It also has two faults of its own:

- **The scan stops after the first area.** Line 63 calls
  `GetNextObjectInShape(SHAPE_SPHERE, 6.0, GetLocation(oPC))` without the object
  filter, and `nObjectFilter` **defaults to `OBJECT_TYPE_CREATURE`**. After the
  first area object the loop is walking creatures, and `GetAoEId` never matches
  again — so if any other AoE is nearer, the darkness area is never found and the
  effect is stripped while the player is still standing in it.
- **The search sphere is smaller than the area.** It looks 6.0 metres out for an
  area whose radius is 6.7, so a player at the edge of a darkness can be judged
  outside it.

That the effect *does* usually go away in testing is consistent with all of this:
row 36 is removed on exit as designed, and the login net catches some of the rest.

**Instrument it anyway**: cast from row 36 and from 2935, walk in and out, and
read the target's effects with their spell ids on each side. Two casts tell you
whether the exit path is sound and the problem is only the four unhandled rows.

**Why nobody noticed for years.** The extra rows carried a visual and not a
working darkness, so there was nothing to dispel. The spell was fixed; the
six-way split was not.

**The same shape exists elsewhere.** Every persistent AoE whose parent spell has
more than one row in `spells.2da`:

| AoE | Parent | Ids | Not removed on exit |
|---|---|---|---|
| `VFX_PER_DARKNESS` | `nw_s0_darkness` | 36, 345, 606, 1203, 2935, 3062 | 606, 1203, 2935, 3062 |
| `VFX_MOB_CIRCEVIL` | `nw_s0_circgood` | 105, 1014 | 1014 |
| `VFX_PER_FOGACID` | `nw_s0_acidfog` | 0, 1241 | exit script not in `src/` |
| `VFX_PER_FOGFIRE` | `nw_s0_inccloud` | 89, 1259 | exit script not in `src/` |
| `VFX_PER_FOGSTINK` | `nw_s0_stinkcld` | 171, 1220 | **no exit script at all** |
| `VFX_PER_WALLFIRE` | `nw_s0_wallfire` | 191, 343, 1234 | removes nothing by id — may be correct for a damage AoE |

The eighteen `dote_aura*` scripts follow the same three-script shape and are
unreviewed.

### F8. Smaller things

- `IntDivisionRounding` rounds toward zero for negatives: −7/2 gives −3, not −4.
  Whether that matters depends on whether it is ever handed a negative.
- `gsSPfindEffect` returns `GetFirstEffect(OBJECT_INVALID)` as a null effect. It
  works, and it is worth a comment rather than a rediscovery.
- `ApplyTaggedEffectToObject` silently makes every non-supernatural effect
  **Extraordinary**, which changes what dispels and rest can strip. That is a
  design decision buried in a utility.

---

### F9. Areas of the same type stack, and the guard against it only half exists

`CreateNonStackingPersistentAoE` is the module's answer to overlapping areas.
It has two holes and one wrong key.

**It only handles spheres.** The `switch(GetAoEShape(nAreaEffectId))` has a
`case SHAPE_CUBE:` whose entire body is the comment *"Logic for blade barrier
and wall of fire would go here."* Walls of fire and blade barriers therefore
never de-duplicate at all. The centre-distance test the sphere branch uses does
not transfer to them either: two walls can overlap along their length while
their centres sit far apart.

**It only de-duplicates against yourself.** The guard is

```nwscript
if(GetAreaOfEffectCreator(oNearestAoE) == oCreator && GetAoEId(oNearestAoE) == nSpellId)
```

so a second caster's darkness sits happily on top of the first. That is the
overlap case in 3c, and it is the reason the exit script has to remove
*regardless of caster* and takes both.

**And "same type" is keyed on the spell id**, which is F4 again in another
place. `GetAoEId` does not return an area of effect id despite its name: it
returns a `spells.2da` row, read from a local the library wrote as
`NonStackingAoEId`. So darkness from row 36, from row 2935, from the warlock
invocation and from the drow ability are four different types as far as this
function is concerned, and all four stack with each other.

The type of an area is the row of `vfx_persistent.2da` it was built from — the
`AOE_PER_*` constant `EffectAreaOfEffect` takes, which is already the argument
`nAreaEffectId` of this very function. It is simply never stored.

**The rule, set 2026-08-25:** *no two areas of the same type stack,
whoever cast them; different types stack freely.* That is a stronger guard than
the code has, and it is worth noticing that it **dissolves the overlap problem
rather than solving it** — if two darknesses can never coexist, removing on exit
regardless of caster is correct again.

The cost is a lever: casting your own area on top of an enemy's deletes theirs.
For darkness and wall of fire that is a real PvP consideration, and a ruleset
call rather than a library one.

### F10. Four incompatible answers to "should this area stack?"

**Eighty scripts create an area of effect.** Four different rules are in force
among them, none written down anywhere, and seventy-four scripts follow no rule
at all.

| Mechanism | Scripts | What it actually means |
|-----------|--------:|------------------------|
| `CreateNonStackingPersistentAoE` | 4, all darkness | Same caster **and** same `spells.2da` row **and** centres within one radius → destroy the older. Spheres only: `case SHAPE_CUBE:` is an empty stub |
| `BorrarAreasEfecto` | 2 files, 5 bombs | Same caster **and** same object tag, anywhere in the area → destroy. **Not about overlap at all**: one instance per caster, full stop |
| A per-victim counter | wall of fire, and the warlock's | The areas coexist; a creature already inside one **takes nothing from the second** |
| Nothing | **74** | Free stacking |

Three cases read cleanly against this table, and all three
are explained by a different row of it.

**Wall of fire "does not work" when overlapped.** `nw_s0_wallfire.nss` has no
placement control whatsoever — it is a plain `ApplyEffectAtLocation`. The second
wall is created and does exist. What stops it is `nw_s0_wallfirea.nss:55`:

```nwscript
int nMuroFuego = GetLocalInt(oTarget, "AOE_" + IntToString(AOE_PER_WALLFIRE));
if (nMuroFuego > 0)
{
    SetLocalInt(oTarget, "AOE_" + IntToString(AOE_PER_WALLFIRE), nMuroFuego + 1);
    return;
}
```

Already burning, so the second wall starts no damage loop. The perception is
"the wall does nothing"; the reality is that the *participation* rule fired,
not a placement rule.

**Incendiary cloud stacks.** `nw_s0_inccloud.nss` is in the seventy-four. No
placement rule, no participation rule, no counter.

**The alchemist's gas and fire cannot be placed on each other.**
`cls_ing_item4.nss` calls `BorrarAreasEfecto(oPC, "VFX_PER_BOMBAGAS")` before
creating. That is not a no-overlap rule: it destroys **every** area of that tag
the caster owns anywhere in the current area, so what looks like "they do not
overlap" is really "you may only have one".

**And the counter leaks, in the same way darkness does.**
`nw_s0_wallfireb.nss` is four lines and decrements unconditionally, with no
floor at zero, and it is the only thing that ever decrements. Leave the wall by
any route that skips the exit script — logging out inside it, the area expiring
under you, an area transition — and the counter stays above zero. That creature
is then **immune to every wall of fire** until it happens to enter and exit
cleanly enough times to unwind it. Over-decrement instead and the counter goes
negative, and every wall damages afresh.

This is F7 wearing different clothes. An exit script is the sole owner of a
piece of state, nothing backs it up, and the state outlives the thing it
described. That the state is an integer rather than an effect changes nothing.

### F11. The library was imported without its callers

`cow-scripts/` is **a different module by the same author**, not an earlier PDB.
There is no shared history and nothing was "lost": `inc_spells.nss` was taken
from it because it worked, and things are still being migrated across one at a
time when they earn it.

It sits untracked at the repository root and is gitignored — a reference to
migrate from, not part of this project.

What the comparison shows is which parts came over. Its `inc_spells.nss` carries
`CreateNonStackingPersistentAoE` and **twenty-three of its scripts call it**. In PDB, **one** does.

| | Source module | PDB |
|---|---:|---:|
| Scripts calling `CreateNonStackingPersistentAoE` | 23 | 4 (all darkness, 3 of them PDB's own) |
| Of those 23, routed in PDB | — | **1** (`nw_s0_darkness.nss`) |
| Of those 23, present in PDB but unrouted | — | **20** |

The twenty: `acidfog`, `bladebar`, `cloudkill`, `crpdoom`, `delfirebal`,
`entangle`, `evards`, `grease`, `healcirc`, `inccloud`, `mindfog`, `stinkcld`,
`stormveng`, `wallfire`, `web`, `cldbewld`, `stnehold` and the three vine mines.
All twenty exist here as the stock BioWare script.

**The function itself is unchanged.** Byte for byte the same in both, empty
`case SHAPE_CUBE:` stub included — so the rectangle gap was never written
anywhere, and is not something PDB broke. The migration brought the tool and has
not yet brought the twenty spells that use it. That is a job queued, not a
regression.

**And the call bought more than placement.** Its tail is

```nwscript
DelayCommand(0.01, _UpdateAoEDataAtLocation(lLocation, nSpellId, oStaticVFX,
                                            nCasterLevel, nCasterClass,
                                            fDuration - 0.01, nMetaMagic));
```

Caster level, caster class and metamagic recorded **at the location**, so the
enter and heartbeat scripts read what the spell was cast with instead of
interrogating a caster who may since have died, logged out or levelled. Every
one of the twenty now asks the creature directly. `nw_s0_wallfirea.nss` calls
`GetTotalCasterLevel(GetAreaOfEffectCreator())` on a creature that may not exist;
COW's version checked and logged when it did not:

```nwscript
if (!GetIsObjectValid(oCaster))
{
  WriteTimestampedLogEntry("ERROR - Wall of Fire couldn't find the effect creator!");
  return;
}
```

That guard is gone in PDB too.

#### What replaced it, in wall of fire's case

COW ships `nw_s0_wallfire.nss`, `nw_s0_wallfirea.nss` and `nw_s0_wallfirec.nss`
— cast, enter, **heartbeat**. There is no `nw_s0_wallfireb.nss` and there is no
counter.

PDB ships a `b`, and its cast script reads

```nwscript
effect eAOE = EffectAreaOfEffect(AOE_PER_WALLFIRE, "nw_s0_wallfirea", "", "nw_s0_wallfireb");
```

**The heartbeat argument is empty.** PDB turned off the engine's per-round tick
and replaced it with `DelayCommand(6.0, MuroFuego(oTarget))` chained on the
victim, guarded by the `AOE_<id>` counter of F10, and added an exit script whose
only job is to decrement it.

That is the whole regression in one line. **The heartbeat is owned by the area
object and dies with it. A `DelayCommand` chain and a local int are owned by the
victim and do not.**

#### The law worth writing down

Darkness leaves a permanent effect because the exit script is its only owner.
Wall of fire leaves a counter because the exit script is its only owner. Both
are the same shape: **state that describes an area was put somewhere the area
cannot reach when it dies.**

The counter is not a bad idea badly executed. It answers the right question —
*do not burn twice* — and at the time it was the available answer. What it
carries is an unstated requirement: the exit script must always run, exactly
once per entry, and be the only thing that decrements. Nothing enforces any of
those three, and **the consequence is confirmed in play: changing that exit
script left walls of fire burning people to death after they had walked out**,
because the counter is not only a stacking guard, it is the stop condition of
the damage loop.

Every function in 3c and 3d exists to make that mistake hard to write.

### F12. Not everything with a shape is an area

Worth stating before any of the above is applied too widely. `nw_s0_icestorm.nss`
and `nw_s0_firestrm.nss` — **identical in COW and PDB** — create no area of
effect object at all. They are `GetFirstObjectInShape` sweeps repeated by
`DelayCommand` for a fixed number of ticks. Meteor variants in `me_*.nss` are
the same shape of thing.

Nothing persists, so nothing stacks, and neither placement nor participation
policy has anything to govern. They are excluded from all of it.

They do share one hazard with wall of fire: a `DelayCommand` chain outlives its
caster and its area. For a two-tick sweep that is a bounded problem, and it is
not this plan's.

### F13. The effect event is already subscribed, and pays for data it discards

3e treated `NWNX_ON_EFFECT_REMOVED_AFTER` as something to consider adopting.
It was adopted long ago. `wrap_on_mod_load.nss:90`:

```nwscript
NWNX_Events_SubscribeEvent("NWNX_ON_EFFECT_REMOVED_AFTER", "event_effects");
```

So the question is not whether the module can afford that event. It is paying
for it on every effect removal on the server, right now, and has been.

**What it pays for.** `event_effects.nss` is thirty-seven lines and runs for
every effect leaving every object. Before it looks at anything it does:

```nwscript
string sCurrentEvent = NWNX_Events_GetCurrentEvent();
object oCreador = StringToObject(NWNX_Events_GetEventData("CREATOR"));
object oPC = OBJECT_SELF;
int iConjuro = StringToInt(NWNX_Events_GetEventData("SPELL_ID"));
```

Then it compares `iConjuro` against one spell id — the artificer's berserker
infusion — and for every other effect in the game does nothing at all.

`oCreador` is **never read**. Two event-data reads and a `StringToObject` on the
hottest path the module has, for a value nothing uses.

Of its three includes, `mti_libreria` **is** needed — it supplies
`ObtenerIntPersistente` and `ObtenerFloatPersistente`, which the berserker branch
calls. `x0_i0_match` is not used at all.

**This reframes the whole cost question.** The fixed cost of being called is
already sunk. What the library would add is logic inside a handler that already
exists, and the marginal cost of that is measured against a baseline that is
already paying more than it needs to. Removing the dead `CREATOR` read may well
buy more than the sweep costs.

None of that is worth asserting without numbers, which is what the measurement
slice is for.

### F14. A third tag vocabulary, written into the same field as the other two

An effect has one tag. `inc_spells.nss` writes two different languages into it.

The string language is the one every caller speaks. `gsSPRemoveEffect`,
`gsSPfindEffect` and `gsSPHasEffect` filter on it, and the module writes it by
hand in fourteen files: `"DM_INMOVILIZADO"`, `"VFX_DUR_CHAT_BUBBLE"`,
`"SPELL_ACELERAR"`, `"POCION_SIDRAPERA"`, `"MMF_MOV_SPEED"`. The instance tags
this plan added are the same language with a reserved prefix.

The integer language belongs to one function:

```nwscript
// All effect tags are ints.  But stored as strings.
// Use bitwise flags to allow us to apply multiple tags.
int nCurrentTag = StringToInt(sEffectTag);
eEffect = TagEffect(eEffect, IntToString(nCurrentTag | nEffectTag));
```

`gsSPApplyTaggedEffectToObject`, dated February 2016. Its comment states the
premise the rest of the file contradicts: all effect tags are ints. They are not,
and were not when it was written.

The two cannot coexist safely in one field, and one direction of that is already
provable without any probe: `TagEffect` overwrites the tag it is given, so a
caller-supplied string tag does not survive a trip through this function
whatever `StringToInt` makes of it. The tag that comes out is whatever
`IntToString` produced.

**What `StringToInt` returns for a non-numeric string is not established here.**
`nwscript.nss:8015` says only "Convert sNumber into an integer"; it does
not define the non-numeric case, and no probe has been run against this build.
So the reverse direction - whether a string tag is silently read as some
particular number - is an open question, not a claim. It does not need settling
for F14 to stand: a numeric tag is an ordinary string, so a caller asking for
`"4"` matches one either way, and the overwrite above is enough on its own.

**In practice nothing collides, because the integer language has one speaker.**
There is one flag, `EFFECT_TAG_DURATION_MARKER = 0x00000004`; one caller,
`_UpdateAoEDataAtLocation`, private to the library; and one application, an
`EffectCutsceneGhost` on the area object itself, never on a creature. No script
in `src/` reads that flag back. It is written and never read.

**It is orphaned because the import stopped halfway.** The function comes from
COW, where it is one quarter of a complete API in `cow-scripts/inc_effect.nss`:
`ApplyTaggedEffectToObject` writes, `GetIsTaggedEffect` tests one effect,
`GetHasTaggedEffect` tests a creature, and `RemoveTaggedEffects` removes, with an
optional creator filter. The flags live in a file of their own,
`cow-scripts/inc_effecttags.nss` - thirty-two of them, `EFFECT_TAG_POISON`,
`EFFECT_TAG_AURA`, `EFFECT_TAG_DOT`, `EFFECT_TAG_SUBDUAL` and the rest, with
three `EMPTY` slots left.

PDB took the writer and one flag. The three readers and the constants file stayed
behind. That is why `src/` contains a tag nothing reads: not an accident of
disuse, half an import.

**And it answers a different question from ours.** A bitmask says what *kind* of
thing an effect is - is this a poison, is it an aura - and one effect can carry
several kinds at once, which is what the bitwise `|` and `&` are for. It cannot
say *which* poison cloud applied it: there is no room in thirty-two flags for an
object id, and no version of that design would have solved F9. The two
vocabularies are not rivals; they answer different questions, and only one of
them is answered anywhere in `src/`.

**Settled 2026-08-26, and the second vocabulary is gone.** The Extraordinary
coercion turned out not to be a separate question at all: it was making every
non-stacking area undispellable, which F18 traces and which was confirmed in
play. The cutscene ghost is now applied plainly, that was the function's only
caller in `src/`, and `gsSPApplyTaggedEffectToObject`,
`EFFECT_TAG_DURATION_MARKER` and `EFFECT_TAG_UNDEFINED` are deleted with it.

The module now has **one** effect-tag vocabulary: strings, chosen by the caller,
with `gsAoE#<objid>` reserved for area instances.

### F15. The engine grew the handles this plan built by hand

Checked against `documentation/nwscript/reference/nwscript.nss` on 2026-08-26.
Every one of these is **native**. None needs NWNX.

| Native | Line | Engine's own comment |
|---|--:|---|
| `SetEffectCreator(effect, object)` | 13594 | "Sets the effect creator. oCreator: The creator of the effect. Can be OBJECT_INVALID." |
| `SetEffectSpellId(effect, int)` | 13602 | "The spell id **for the purposes of effect stacking**, dispel magic and GetEffectSpellId" |
| `SetEffectCasterLevel(effect, int)` | 13598 | "for the purposes of dispel magic and GetEffectCasterlevel" |
| `GetEffectLinkId(effect)` | 13409 | "no guarantees about this identifier other than it is **unique and the same for all effects linked to it**" |
| `GetEffectDurationRemaining(effect)` | 11794 | — |
| `GetEffectInteger/Float/String/Object` | 12375-12393 | typed payload read off an effect |
| `HideEffectIcon(effect)` | 12488 | — |
| `GetSpellFeatId()` | 13405 | "In an Area of Effect script returns the feat used to generate it" |

Three of them settle open questions in this document.

**`SetEffectSpellId` is the native route for the potion, and it is not settled.**
The engine's comment says the spell id is what drives *effect stacking*, so a
potion applying from an item activation could declare the row it should stack
against and `GetHasSpellEffect`, `RemoveSpellEffects` and dispel would start
seeing it.

**It reaches every effect in a link. Measured in play, 2026-08-26.**
`gsSPApplyEffect` sets the row on the effect it is handed, and `pb_dbg_fxowner`
read the result off the target:

    fx[0] type=74 spell=36  tag='gsAoE#e93'   darkness, two casters overlapping
    fx[4] type=58 spell=36  tag='gsAoE#e93'
    fx[6] type=72 spell=36  tag='gsAoE#e93'
    fx[0] type=11 spell=192 tag='gsAoE#e95'   web
    fx[1] type=49 spell=192 tag='gsAoE#e95'
    fx[0] type=24 spell=1401 tag='gsAoE#eab'  humidifier
    fx[1] type=67 spell=1401 tag='gsAoE#eab'

Eight darkness effects came from four calls, so each call applied a link of two,
and **both members of every link carry the row**. 36 is `SPELL_DARKNESS`, 192 is
`SPELL_WEB`, 1401 the humidifier. Every one of these is applied from an area
script, where the engine records `-1` and where slice 1 measured `-1` before this
change. The row is now true for `GetHasSpellEffect`, for dispel magic and for
this library's own spell filter, on effects the module applies from outside a
spell script.

**The caster level had to follow, and it was found by testing.** A wand of lesser
dispel stripped a darkness effect off a creature standing inside the area. That
is new: before the row was written the effect was not dispellable at all. But the
row was going out with no level behind it, and dispel magic compares levels, so
declaring the row alone made an area effect dispellable by anyone.

`gsSPApplyAoEEffect` now writes it, and the source is not a guess:
`nwscript.nss:7173` says of `GetCasterLevel` that *"An Area of Effect object will
return the caster level that was used to create the Area of Effect."* It returns
`0` on error and `0` is not a level, so only a real answer is written.

**The area itself is untouched by dispel, and that is correct.** Dispelling a
creature removes what is on the creature; the area object is a separate thing and
re-applies on the next enter. Stepping out and back in restores the effect, as it
should.

### F17. Mind fog's lingering penalty stacks with the fog itself on re-entry

Measured 2026-08-26, inside the fog:

    fx[0] type=51 spell=118 tag='MINDFOG_LINGER' dur=1
    fx[1] type=51 spell=118 tag='gsAoE#eac'      dur=2

Two `SAVING_THROW_DECREASE` effects at once, `-10` Will each. The lingering
penalty runs for 2d6 rounds after leaving; walking back in before it expires adds
the fog's own `-10` on top of it, for `-20` while both stand.

**This is not a regression from slice 4d.** The old code applied the same two
effects in the same order; the difference is only that the instance tag now makes
them legible. On exit the refresh works exactly as intended - one linger, never
two - which is what slice 4e was for and what the second probe confirms.

Whether re-entering should clear the leftover is a ruleset question: the penalty
is defined as lasting *after leaving*, and someone who has not left is not in
that state. Recorded, not decided, and not touched.

**`SetEffectCreator` settles the ownership handle, if the creator may be an
area.** Slice 1 measured `GetEffectCreator` returning the caster and this plan
answered with a tag encoding the area's object id. An area script can now write
the field directly. The warning recorded in 3e still applies and applies harder
now that it is one line away: the creator field is read by the engine for dispel,
faction and attribution, and an area object in it is a state nothing else was
written to expect. It needs a probe.

**`GetEffectLinkId` is a better identity than `ObjectToString`.** It is the
engine's own, it is guaranteed unique, it is the same across a link, and it needs
no prefix, no separator, no hex validation and no recycled-object-id check -
three of which `gsSPGetAoEInstanceTag`, `_AoEInstanceTagId` and
`gsSPGetAoEInstanceIsAlive` exist only to provide.

**NWNX duplicates all of this and adds nothing here.** `NWNX_Effect_SetEffectCreator`
mirrors a native. `NWNX_Effect_UnpackEffect`'s `nSpellId` mirrors a native.
`gsFXRemoveEffectIcon` in COW unpacks and repacks an effect through NWNX to clear
an icon; `HideEffectIcon` is a native that does it. What NWNX still owns alone is
the applied/removed **event stream**, whose cost 3e says must be measured before
it is taken. That has not changed.

### F16. A modern implementation was already in the module, and this plan never read it

`nw_s0_mgcconvla.nss` and `nw_s0_mgcconvlb.nss`, Magic Convalescence, written in
June 2024 by another author. It is the one area-of-effect spell in `src/` built
the way the engine now allows, and slices 1 through 4 solved its problem again
from scratch without looking at it.

What it does:

```nwscript
eEffect = SetEffectCreator(eEffect, oCreator);
eEffect = SetEffectSpellId(eEffect, SPELL_MAGIC_CONVAL_ID);
...
eAOE       = gsSPfindEffect(SPELL_MAGIC_CONVAL_ID, oCreator, oCreator);
sEffectID  = GetEffectLinkId(eAOE);
eEffect    = TagEffect(eEffect, sEffectID);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget,
                    IntToFloat(GetEffectDurationRemaining(eAOE)));
```

It finds the area's own effect on the caster, takes the engine's link id from it,
and tags what it applies with that. The exit script recomputes the same id and
removes only what matches. Same instance scoping this plan built, from an engine
identity instead of a parsed string.

**It records a race this plan had not considered, and the link id is not what
handles it.** Recasting removes the old area, and `nw_s0_mgcconvl.nss:79-90`
states what the author observed: *"the OnEnter of the new effect was executed
before the OnExit of the old effect ... therefore, we enforce the removal here"*.
The cast script sweeps the location itself, before applying, precisely because
the link id does not save it.

It cannot. `nw_s0_mgcconvlb.nss:35-38` does **not** keep the exiting area's id -
it calls `gsSPfindEffect` on the caster at exit time and takes whatever matches
then, which after a recast is the **new** area's effect. The identity it computes
names the wrong instance. What actually keeps the new effects alive is the
proactive sweep in the cast script, plus the distance guard at
`nw_s0_mgcconvlb.nss:45`.

So this is not a proven pattern for per-instance race safety, and it must not be
cited as one. **Nor is this plan's instance tag proven against that race.** A new
area is a new object id, which is the reason to expect it to hold, but expecting
is not measuring and no test has been run. Recast ordering goes on the probe
list.

**And it is better than this plan's answer in one way that matters.** Its effects
are `DURATION_TYPE_TEMPORARY` for `GetEffectDurationRemaining(eAOE)` - they carry
the parent's remaining life and **expire on their own**. This plan applies
`GS_SP_DURATION_PERMANENT` and depends on an exit script running, with
`gsSPSweepOrphans` as a backstop for when it does not. An effect that cannot
outlive its parent needs no backstop at all.

**Where the instance tag is still needed.** Magic Convalescence's identity is
reachable only because the area's own effect sits on the caster and carries the
spell row, so `gsSPfindEffect` can find it. An area whose caster has logged out,
died, or never carried the effect has no such anchor, and `OBJECT_SELF` inside
the area script does. Neither mechanism dominates. The library should offer both
and say when each applies.

### F18. Every non-stacking area was undispellable — **confirmed and fixed, 2026-08-26**

**Reported, diagnosed, retracted on bad evidence, then confirmed by a clean
test.** The retraction is left described below because the reason it was wrong
matters more than the fact.

**The fault.** `nw_s0_darkness.nss:42` builds its area with
`gsSPCreateNonStackingPersistentAoE`. That reaches `_UpdateAoEDataAtLocation`,
which applied an `EffectCutsceneGhost` to the **area object** through
`gsSPApplyTaggedEffectToObject`, and that function coerces anything not
Supernatural to Extraordinary. `cerr_newdispel.nss:474` then reads the area's
first effect and returns before rolling when its subtype is set and is not
`MAGICAL`:

```nwscript
effect eSearch = GetFirstEffect(oTargetAoE);
int nSubType = GetEffectSubType(eSearch);
if(nSubType && nSubType != SUBTYPE_MAGICAL) return;
```

So the area was not merely hard to dispel. It was **never rolled for**, and the
player was told nothing at all, because both messages sit after that return.

**The controlled test.** Darkness cast repeatedly and attacked with Greater
Dispelling from a high-level caster on a low-level one, a low-level caster on a
high-level one, and wands and rods of lesser and greater: **no message of any
kind**. Web, in the same session, immediately produced `* Area of effect
dispelled *`. Web calls `EffectAreaOfEffect` directly, has no such effect, and
its probe reports `aoeid=-1` against darkness's `36`.

**The fix.** The ghost is applied plainly. Its job is to stop the area object
blocking movement; it needs no subtype for that, and the tag it carried was read
by nothing, which is F14. That leaves `gsSPApplyTaggedEffectToObject` with no
caller anywhere in `src/`.

**Why the retraction happened, since it cost a round trip.** The first evidence
was a log showing `* Area of effect not dispelled *` beside wand use, which
proves the function reached its end - and it did, for whatever area those wands
were aimed at. It was read as proof about darkness, which it never was. The
finding had also been written with a four-step source trace whose fourth step -
that `GetFirstEffect` returns the ghost - was assumed rather than read, so when
one piece of evidence contradicted it the whole thing was dropped instead of the
one unverified step being tested. The one-minute test that settles it, web
against darkness, was proposed in the original finding and skipped in both
directions.

### F19. The web's double saving throw is the same roll reported twice

Not a bug. Standing in your own web the log shows two identical lines - same
roll, same total, same DC - and a second creature in the same web produces one.
The probe reports one area and one effect. The engine reports a saving throw to
the target and to the source of what caused it; when the caster stands in their
own area those are the same creature, so the client prints it twice.

Recorded so it is not investigated again.

## 6. The architecture, decided 2026-08-26

### Splitting the include costs nothing at runtime, and this is measured

The compiler emits only reachable functions; an unused function in an include
does not reach the `.ncs`. Measured on the artifacts in `.nasher/cache/default/`,
compiled 2026-08-25:

| Script | Includes | `.ncs` |
|---|---|--:|
| `cls_ing_humib.ncs` | `inc_spells` + `x2_inc_spellhook` + `nw_i0_spells` | 1135 B |
| `nw_s0_darknessb.ncs` | `inc_spells` | 1221 B |
| `nw_s0_mindfogb.ncs` | `inc_spells` + `X0_I0_SPELLS` | 2554 B |

`inc_spells.nss` alone is 1227 lines. If inclusion cost what it textually
contains, none of these could be one or two kilobytes.

**So the number of includes is a question about people, not about the engine.**
`AGENTS.md` asks for shallow dependency chains, and that is the constraint that
matters: a file that includes a file that includes a file is hard to reason
about, not slow.

### The split

`inc_spells.nss` is 1227 lines holding three unrelated subjects. It becomes
three files with one dependency edge each, and no consumer changes.

| File | Holds | Depends on |
|---|---|---|
| `inc_effects.nss` | apply, remove, find, has; tags; the subtype policy; `gsSPApplyTaggedEffectToObject` until F14 is settled | nothing, **once the coupling below is cut** |
| `inc_spellaoe.nss` | instance identity, the sweep, `gsSPCreateNonStackingPersistentAoE`, every `gsSPGetAoE*` and `gsSPSetAoE*`, the static VFX partner | `inc_effects` |
| `inc_spellschool.nss` | spell-school lookup and the Shadow Weave and Mastery of Elements rules | nothing |
| `inc_spells.nss` | the public casting facade: targeting, resistance, saving throws and memorised spells | `inc_spellaoe`, `inc_spellschool`, `pb_nivellanzador` |

`inc_spells.nss` keeps including the other two, so its **64 consumers compile
unchanged** and the split can happen in one commit without touching them. A
script that only needs effects may then include `inc_effects` directly; nothing
forces it to.

`pb_nivellanzador.nss` remains a compatibility adapter for its existing callers.
It includes the leaf `inc_spellschool.nss` because `GetChangesToSaveDC` and
`ChangedElementalDamage` keep their public signatures while delegating their
rules. New spell code includes `inc_spells.nss`; it does not add another direct
dependency on the legacy caster-level file. The dependency graph is acyclic:
the facade points down to the specialised includes, and none points back to the
facade.

`gsSPSavingThrow` is the facade's save boundary. Its caster and spell-id
arguments are mandatory because an area script's `OBJECT_SELF` is the area,
not its creator. It resolves the school once, delegates the Shadow Weave DC
arithmetic to `inc_spellschool`, and passes the same answer explicitly to
`MySavingThrow` for Shadow Defence. Legacy `MySavingThrow` callers resolve
their own `GetSpellId()` through the same include. Neither path reads or writes
mutable school state.

`gsSPIntDivisionRounding` is arithmetic and belongs in none of the three. It
stays where it is until something else needs it.

**The split is not mechanical yet, and slice 5 is what makes it so.**
`gsSPApplyEffect` calls `gsC2AdjustSpellEffectiveness` at `inc_spells.nss:465`
and `:472`. Effectiveness is a casting concern and belongs in `inc_spells.nss`;
apply is an effect concern and belongs in `inc_effects.nss`. As written, the
lower file would call into the higher one and `inc_effects.nss` would not stand
alone.

There is no clever way around it and it should not be papered over:

- Putting effectiveness in `inc_effects.nss` puts a casting concern in the
  effects file and makes the boundary meaningless.
- Making `inc_effects.nss` include `inc_spells.nss` inverts the dependency.
- Editing `gsSPApplyEffect` to drop the calls is a behaviour change, which slice
  8a promises not to make.

So **slice 5 comes first**. F1 already records that the effectiveness result is
filed in a local integer nothing in the module reads, and the recommendation
there is to delete the machinery. Deleting it removes the only edge between the
two files and the split becomes the pure move slice 8a describes. If slice 5
decides to keep effectiveness instead, the split has to be redesigned around it,
not forced.

**Names keep the `gsSP` prefix.** It marks what the module owns, which is the
rule settled in slice 0b, and renaming 64 consumers to gain nothing is the
opposite of what this split is for.

### No central table of effect tags

COW has one - `cow-scripts/inc_effecttags.nss`, thirty-two bitwise flags - and it
should not be copied.

- **It answers a different question.** A flag says what *kind* of thing an effect
  is: poison, aura, damage over time. Ours say *which instance* or *which
  identity*. A bitmask has no room for either.
- **It has a hard ceiling of thirty-two**, and COW had used twenty-nine.
- **It recreates what section 3g removed.** One constant per spell in a shared
  file is the growth the kind field was deleted for, whether the file is called
  `inc_spells.nss` or `inc_effecttags.nss`.

**A tag belongs to the file that writes it**, which is what `lib_dm_vfx.nss`
already does and what `nw_s0_mindfogb.nss` now does.

**The one exception is an identity with more than one writer.** `"SPELL_ACELERAR"`
is written by `nw_s0_haste.nss`, `nw_s0_mashaste.nss` and `pb_potion_inc.nss`,
and three copies of a string literal will drift. Those - and only those - get a
declaration they can share. There is one such group today. It is not a table of
every tag in the module; it is the list of identities that span files, and it
stays empty until a tag has a second writer.

### The build gap that must be closed first

The vendored `nwscript.nss` comes from the local install, whose binaries are
dated **2025-10-06** (`bin/win32/build.txt`). The server runs
`nwnxee/unified:build8193.37`. Every native in F15 sits at the end of the file,
which is where the engine appends new ones.

**A script calling a native the server's build does not have compiles here and
fails there**, because the mandatory check validates against the local install
and nothing validates against the container. Before any of F15 is adopted, the
server's build must be read from its own startup banner and compared. Until then
F15 is a design input, not a licence.

`nw_s0_mgcconvla.nss` has been in the module since June 2024 and calls three of
them, which is evidence and not proof: nobody has recorded it running.

## 3. What NWNX offers instead

The **Effect** plugin is enabled (`NWNX_EFFECT_SKIP=n`) and is not used by this
library at all:

| Need | Today | Available |
|---|---|---|
| Count effects | full list walk, twice | `NWNX_Effect_GetTrueEffectCount` |
| Reach the nth effect | sequential cursor | `NWNX_Effect_GetAppliedEffect(o, n)` |
| Remove one specific effect | remove while iterating | `NWNX_Effect_RemoveEffectById` |
| Replace an effect | remove then re-apply | `NWNX_Effect_ReplaceEffect` |

The counting is what matters here: `GetTrueEffectCount` replaces the two full
list walks F1 describes. Removal by id is **not** needed — F3 was wrong and
removal is deferred, so the ordinary loop is correct as written.

---

## 3b. The rule the library should enforce

Decided 2026-08-25, and it is the thing every slice below serves:

> **An effect this module applies is dispelled when it should be — on leaving
> the area, on expiry, on the source ending — and that does not depend on which
> spell row applied it or on which script is running when it is removed.**

Four things follow, and together they are the design:

**1. Every applied effect has an identity that survives its context.** A tag,
not a spell id. A tag is the same string whether the effect came from a spell,
an item, a conversation or a delayed command, and it does not multiply when a
second `spells.2da` row is added.

**2. Every applied effect has exactly one owner** — one place responsible for
taking it off. For an area effect that is the exit script; for a timed buff, the
duration; for a toggled state, whatever toggles it off.

**3. There is a backstop for when the owner never runs.** A player logs out
inside an area, the area is destroyed, the caster dies. `RemoveStuckDarknessEffects`
is a backstop written by hand for one spell; the library should carry **one**
generic sweep — "this effect belongs to an area, is the area still there?" —
so a new area spell inherits it instead of needing its own. What the effect
holds that lets the sweep answer that question is not the tag and is not settled;
see *The ownership handle* in 3c.

**4. Removal is asked for by intent, not by force.** Which is the next section.

## 3c. The API this needs

Answering the question directly: **viable, and it needs one new function, one
change of semantics, one parameter that replaces a boolean, and one fact about
the engine that only a probe can supply.** Not a new library — but the last
item is a precondition, not a detail, and it has its own section below.

### `bForceRemove` becomes a subtype policy

The boolean conflates two different intentions. "Take the chat bubble, which is
Unyielding because the module made it so" and "take everything including racial
and class effects" are not the same request, and today both are `TRUE`.

```nwscript
/// Which effect subtypes a removal is allowed to take.
const int FX_SUBTYPE_SAFE       = 0;  ///< skips Supernatural and Unyielding — the default
const int FX_SUBTYPE_UNYIELDING = 1;  ///< also takes Unyielding: the module's own UI and state effects
const int FX_SUBTYPE_ALL        = 2;  ///< takes everything: DM tools and cleanup only
```

The chat bubble asks for `UNYIELDING` and says so at the call site. Nothing has
to pass `ALL` to get a satellite effect off, which is what makes the current
`bForceRemove = TRUE` dangerous: it is the only door, so everyone walks through
it.

### `gsSPfindEffect` gains wildcards

Today it returns early on `nSpellID < 0` and demands an exact creator before it
looks at the tag, so it cannot answer *"does this target carry this tag"* — which
is the only question a tag convention ever asks.

`nSpellID = -1` means any spell; `oCreator = OBJECT_INVALID` means any creator.
Both documented, both matching what `gsSPRemoveEffect` already does with the same
values.

### One new function: the predicate

```nwscript
/// @brief Does oTarget carry an effect matching this tag?
int gsSPHasEffect(object oTarget, string sTag, int nSpell = -1, object oCreator = OBJECT_INVALID);
```

That is what `PJ_EfectoBuscarTag` was for, with a contract and the wildcards
written down. Its two callers move onto it directly.

### The ownership handle: measured, 2026-08-25

A second external review of this plan found that 3b point 3 asks for a sweep
that answers *"does this effect belong to an area, and is that area still
there?"* while nothing said what the effect is holding that would let it answer.
That was correct, and rather than invent a scheme the question was put to the
engine.

**The probe.** `pb_dbg_fxowner.nss`, run through the DM console as `dm_efectos`
on a player character standing 0.95 m inside a darkness area of radius 6.7:

```
fx[0] type=74 spell=36 tag='' sub=MAGICAL dur=2 | creator=CREATURE name='Ertai Crowley' valid=1
fx[1] type=74 spell=36 tag='' sub=MAGICAL dur=2 | creator=CREATURE name='Ertai Crowley' valid=1
fx[2] type=58 spell=36 tag='' sub=MAGICAL dur=2 | creator=CREATURE name='Ertai Crowley' valid=1
fx[3] type=72 spell=36 tag='' sub=MAGICAL dur=2 | creator=CREATURE name='Ertai Crowley' valid=1
aoe[0] tag='VFX_PER_DARKNESS' aoeCreator='Ertai Crowley' dist=0.95
```

Reading it against `nwscript.nss`: `74` is `EFFECT_TYPE_VISUALEFFECT` twice,
`58` is `EFFECT_TYPE_DARKNESS`, `72` is `EFFECT_TYPE_CONCEALMENT`, and `dur=2`
is `DURATION_TYPE_PERMANENT` for all four — the two links the enter script
builds, flattened.

**The answer is the caster.** `GetEffectCreator` on an effect applied from an
area of effect enter script returns the creature that cast the spell, not the
area object. So the free version of the backstop does not exist: **the area
instance is not recoverable from the effect**, and asking whether it still lives
is impossible without something written in at application time.

Three further facts the same reading settles:

- **Every effect is `PERMANENT`.** Nothing expires them. The exit script is the
  only thing in the game that removes them, which is precisely why a route it
  does not name leaves them forever.
- **Every tag is empty.** The spell id is the only handle any of this has today,
  and F4 already establishes how little that is worth.
- **A DM cannot reproduce any of it.** `nw_s0_darknessa.nss:27` returns before
  applying anything to an unpossessed DM. The first probe run was pointed at a
  DM avatar and reported no darkness at all from 1.22 m inside the area, which
  reads exactly like the bug being hunted. The probe now warns about this.

### The handle goes in the tag

Given the creator is the caster, the instance has to be written down. It goes in
the effect tag, which is free, already present, and currently empty:

```nwscript
// In an area of effect script, OBJECT_SELF is the area object.
effect eTagged = TagEffect(eLinked, FX_TAG_DARKNESS + "_" + ObjectToString(OBJECT_SELF));
```

`TagEffect` overwrites any tag in the link, so one call tags the whole link and
all four effects come back carrying it. `ObjectToString` gives the area object's
id; `StringToObject` turns it back.

That one string then answers both questions the design needs:

**Which instance owns this effect** — the exit script removes only effects whose
tag names the area running it, so two casters' darknesses stop cancelling each
other, without waiting for slice 7 to forbid the overlap.

**Is the owner still alive** — the generic sweep splits the tag, calls
`StringToObject`, and removes the effect when the object is gone. That is exact,
cheap, and inherited: any area effect tagged this way gets the backstop for free
and no new spell needs its own `RemoveStuckDarknessEffects`.

**Still no NWNX dependency.** `NWNX_Effect` can attach integer parameters to an
effect, which would be a tidier home for an object id than a string — and it
would be a new dependency to carry twenty characters the native API already
carries.

**Overlapping areas.** `CreateNonStackingPersistentAoE` destroys a neighbouring
area only when `GetAreaOfEffectCreator(oNearestAoE) == oCreator` and the spell
id matches, so **two casters' darkness can overlap by design** (F9). Today's
exit script then strips both — `gsSPRemoveEffect(oExiting, SPELL_DARKNESS,
OBJECT_INVALID, "", TRUE)`, and its own header says *"regardless of caster"*.
The tag above is what fixes that; slice 7 is then a second line of defence
rather than the only one.

**Where the backstop runs.** `RemoveStuckDarknessEffects` is called from
`wrap_on_clnt_ent.nss` and nowhere else, which covers exactly one of the three
ways an owner fails to run. The generic sweep needs three:

| Trigger | Covers |
|---------|--------|
| Client enter | Logged out inside the area, or crashed |
| Area enter | Transitioned out while inside — the exit script never fires |
| AoE heartbeat / `OnDisappear` | The area expired or its caster died under someone |

The third is where the effect's owner can remove it while it still knows who it
is, and it is the one that makes the other two rare rather than load-bearing.

### 3d. Areas: the three questions worth keeping apart

F10 exists because one question was asked in four different ways. There are
really three, and a spell should answer each of them explicitly:

**1. Placement — may this area exist here?**

```nwscript
const int AOE_STACK_FREELY    = 0;  ///< a delay blast fireball may sit anywhere
const int AOE_ONE_PER_CASTER  = 1;  ///< BorrarAreasEfecto's rule, given a name
const int AOE_NO_OVERLAP_SELF = 2;  ///< CreateNonStackingPersistentAoE's rule
const int AOE_NO_OVERLAP_ANY  = 3;  ///< no two of these on the same ground, whoever cast them
```

**2. Participation — does a creature already under this kind of area take a
second helping?**

```nwscript
const int AOE_EFFECT_STACKS    = 0;
const int AOE_EFFECT_ONCE_ONLY = 1;  ///< the wall of fire rule, managed
```

Keeping these apart is what the module is missing. Wall of fire wants
`STACK_FREELY` placement with `ONCE_ONLY` participation — two walls may cross,
but you do not burn twice. Darkness wants `NO_OVERLAP_ANY` placement, since two
overlapping darknesses are indistinguishable and only cause the removal problem
of F9. The alchemist's bombs want `ONE_PER_CASTER`, which is what they already
have.

**3. Cleanup — who owns the effects inside?** That is 3c's instance tag, and it
is the same answer for every area.

#### Identity is the `AOE_PER_*` row, never the spell id

The row of `vfx_persistent.2da` is what defines the shape, the radius and the
enter and exit scripts. It is already the argument every one of these functions
receives, and it does not multiply when somebody adds a seventh darkness. Keying
on `spells.2da` instead is F4 and F9 in one mistake, and it is why
`CreateNonStackingPersistentAoE` lets a drow darkness sit inside a wizard's.

#### The rectangle is not a circle

`GetAoEShape` already distinguishes `C` from `R`, and `CreateNonStackingPersistentAoE`
handles only the first. A centre-distance test cannot be transplanted:
`VFX_PER_WALLFIRE` is 10 wide by 2 long and is laid out along the caster's
facing, so two walls can overlap along their length with their centres far
apart.

First pass: a bounding circle of `sqrt((w/2)^2 + (l/2)^2)`, which is 5.10 for a
wall. It is **conservative** — it refuses some placements that are legally
disjoint — and that is the honest trade for not writing an oriented-rectangle
intersection today. If the conservatism is felt in play, the separating-axis
test is the follow-up, and the policy constant does not change.

#### Participation should be derived, not counted

The wall of fire counter leaks because it is remembered. Nothing needs to be
remembered: *"is this creature already inside another area of this
`AOE_PER_*` row?"* is answerable from the world at the moment the question is
asked, by looking at the areas around the creature and testing containment. A
derived answer cannot go stale, cannot be double-decremented, and cannot
survive a logout — so the immunity bug above stops being possible rather than
being fixed.

The cost is a bounded scan on an enter event instead of one `GetLocalInt`. That
is the right trade for state that currently makes players permanently immune to
a spell.

#### What the library gains

```nwscript
/// @brief Creates a persistent area, honouring a placement policy.
object gsSPCreateAoE(int nAreaEffectId, location lWhere, float fDuration,
                    int nPlacement = AOE_NO_OVERLAP_SELF,
                    object oCreator = OBJECT_SELF);

/// @brief Is oCreature already inside another area of this kind?
int gsSPGetIsInsideAoE(object oCreature, int nAreaEffectId,
                             object oThisAoE = OBJECT_SELF);

/// @brief The instance tag of 3c, for effects this area applies.
string gsSPGetAoEInstanceTag(string sKind, object oAoE = OBJECT_SELF);

/// @brief Applies an effect owned by this area instance.
void gsSPApplyAoEEffect(object oTarget, effect eEffect, string sKind,
                       float fDuration = 0.0);

/// @brief Removes only what this area instance applied. For the exit script.
int gsSPRemoveAoEEffects(object oTarget, string sKind, object oAoE = OBJECT_SELF);

/// @brief The generic backstop: removes effects whose owning area is gone.
int gsSPSweepOrphans(object oTarget);
```

Six functions, and a new area spell that uses them is correct by construction
instead of by remembering which of four traditions to copy.

### 3e. What NWNX does natively, and what it will never do

Asked directly: *does NWNX solve this closer to the engine, so the module stops
needing a library and a guardrail for everything?* **Partly, and the part it
solves is the part that keeps breaking.** Checked against the pinned submodule,
not from memory.

#### It gives effects a real lifecycle

`NWNX_ON_EFFECT_APPLIED_BEFORE|AFTER` and `NWNX_ON_EFFECT_REMOVED_BEFORE|AFTER`
fire whenever any effect is applied to or removed from any object, **for any
reason** — expiry, dispel, death, an explicit `RemoveEffect`. `OBJECT_SELF` is
the target, and the event carries:

| Data | Meaning |
|------|---------|
| `UNIQUE_ID` | The engine's own per-effect identity |
| `CREATOR`, `SPELL_ID`, `CASTER_LEVEL` | What applied it |
| `TYPE`, `SUB_TYPE`, `DURATION_TYPE`, `DURATION` | What it is |
| `CUSTOM_TAG` | The effect tag |
| `INT_PARAM_1..8`, `FLOAT_PARAM_1..4`, `STRING_PARAM_1..6`, **`OBJECT_PARAM_1..4`** | Arbitrary payload carried on the effect |

Two of those change decisions made above.

**`OBJECT_PARAM_*` is the ownership handle, natively.** Slice 1 established that
`GetEffectCreator` returns the caster, and 3c proposed encoding the area object
id into the tag string. `NWNX_Effect_UnpackEffect` → set an object parameter to
the area → `NWNX_Effect_PackEffect` stores it as a typed object field instead.
No string to build, split and parse, and the tag stays free for what it is for.

**And there is a blunter route, not named when this section was written.**
`NWNX_Effect_SetEffectCreator(effect, object)` returns the effect with its
creator field set to anything, so an area script could hand its effects
`OBJECT_SELF` and `GetEffectCreator` would answer "the area" - the question slice
1 measured it answering wrongly. `gsSPRemoveEffect(oTarget, -1, oAoE)` would then
scope to the instance with no tag at all.

**It is not obviously safe, and it is not adopted.** The creator field is not
private to this library: the engine reads it for dispel, for faction and for
attribution of what an effect does. An effect whose creator is an area object
rather than a creature is a state nothing else in the module was written to
expect, and the failure would show up somewhere other than here. `OBJECT_PARAM_*`
adds a field; this one overwrites a field the engine already uses. If the tag is
ever traded for an NWNX handle, that is the difference to weigh, and it needs a
probe before either.

**`NWNX_ON_EFFECT_REMOVED_AFTER` is the satellite-effect hook.** The chat bubble
case — an effect that should die when the thing it decorates dies — stops
needing every system to remember to clean up. One subscriber, one place, keyed
on the parent's `UNIQUE_ID`.

**`UNIQUE_ID` with `NWNX_Effect_RemoveEffectById`** removes exactly one effect by
identity, rather than by matching fields and hoping nothing else matches.

#### What it does not solve, and cannot

**Placement policy.** No plugin knows whether two clouds of poison ought to
overlap. That is a ruleset decision, and it stays library code whatever NWNX
offers.

**Geometry.** Nothing in NWNX intersects two oriented rectangles.

**The wall of fire loop.** The fix there is passing a heartbeat script name to
`EffectAreaOfEffect` again, so the tick belongs to the area and dies with it.
NWNX has nothing to add and nothing to fix.

#### The honest cost

`NWNX_ON_EFFECT_APPLIED|REMOVED` fires for **every** effect on **every** object,
including item properties and combat effects. That is a hot path, and
subscribing to it is a decision about server load, not a free win. Before it is
adopted, the applied/removed rate on a populated server must be measured. The
Profiler plugin exists for exactly that.

#### So the split is

NWNX removes the need for **guardrails on effect lifetime** — the class of bug
where state outlives the thing it described, which is F7, F10 and the wall of
fire all at once. It does not remove the need for **a library of design rules**,
because those are the module's rules and no engine can guess them.

That is the shape worth aiming at: a smaller library that states rules, sitting
on engine events that enforce lifetime, instead of a growing pile of hand-rolled
cleanups each patching the hole left by the last.

### Where NWNX belongs, and where it does not

**Not in removal.** Removal is deferred (F3), so the ordinary
`GetFirstEffect`/`GetNextEffect` loop is correct, and
`NWNX_Effect_RemoveEffectById` would add a dependency to replace something that
already works.

**In counting, if anything still needs to count.**
`NWNX_Effect_GetTrueEffectCount` replaces the two full list walks in F1 with one
call — but only matters if the effectiveness machinery survives slice 5, and the
recommendation is that it does not.

**In reading what the native API hides**, such as item properties as effects.
Nothing in this library needs that today.

So: **no new NWNX dependency for this work.** The plugin is enabled and
available if a later need is real; taking it now would be taking it for its own
sake.

## 3g. The kind field was a mistake, and it is gone

Written into the API in slice 2, used by five spells in slice 4, and removed the
same day it was challenged.

**What it was.** The instance tag was `gsAoE#KIND#7f00001a`, and the library
declared a constant per area: `FX_KIND_DARKNESS`, `FX_KIND_WEB`,
`FX_KIND_INVIS_SPHERE`, `FX_KIND_MIND_FOG`, `FX_KIND_HUMIDIFIER`.

**Why it was wrong, and it is not a matter of taste.**

*It does not scale.* One constant per area means the library grows by a line
every time a spell is written. At five it looks tidy. At seventy-four it is a
registry, and a registry of names that only exist to be matched against
themselves.

*It is redundant.* `ObjectToString(oAoE)` already identifies the instance
uniquely — two areas cannot share an object id. The kind narrowed nothing that
the id had not already narrowed.

*It created the bug it was meant to prevent.* An enter script and its exit
script had to name the same constant, so they could disagree — and a checker was
being written to detect exactly that. The library had invented a
synchronisation problem and then tooling to police it.

**What it is now.** The tag is `gsAoE#7f00001a`. Enter and exit agree by sharing
`OBJECT_SELF`, which they already do by being scripts of the same area. Nothing
is registered, nothing is kept in sync, and a spell adopting the library declares
nothing:

```nwscript
gsSPApplyAoEEffect(oTarget, eEffect, nSpell, GS_SP_DURATION_PERMANENT);
gsSPRemoveAoEEffects(oExiting, OBJECT_SELF, FX_SUBTYPE_SAFE);
```

An area that ever needs to tell its own effects apart passes an optional
`sKind` **from the spell**, and removal matches on the instance prefix so an
area with no sub-kinds still takes everything it applied.

#### Why not the spell id, since spells already have one

Asked, and it deserves the answer written down. The spell id says **which
spell**. An exit script needs **which area**.

- Nine `spells.2da` rows produce a darkness (F4), so the id does not even
  identify the effect reliably.
- Worse, two casters produce two areas from the **same** row (F9), and no spell
  id can separate them. That is the bug this whole mechanism exists to fix.
- `GetEffectCreator` returns the caster, not the area, measured in slice 1.

The area object id is the only thing on hand that answers the question actually
being asked, and the effect tag is the only native field that will hold it.

## 4. The plan

Revised twice: once after an external review of the plan retracted its
foundation, once after the rule in 3b was settled. Each slice is a commit
and an audit.

### Slice 0 — Measure, before the API is written

Cheap, reversible, touches no spell. It exists because F13 changed the question:
the effect event is already subscribed, so what matters is not *can we afford
it* but *what does it cost now, and what would the library add*.

**What was turned on.** `NWNX_PROFILER_SKIP` and `NWNX_METRICS_INFLUXDB_SKIP`
were both set to skip in `config/nwserver-dev.env`, so InfluxDB and Grafana were
running with nothing to show. Both are now off.

**Which switch gives which number**, read from `Plugins/Profiler/Profiler.cpp`
rather than guessed:

| Switch | Installs | Measures |
|--------|----------|----------|
| `ENABLE_SCRIPTS` (default on) | `Scripts` | **Per-script time. This is the number this slice needs** — `event_effects`, `pb_prof_fxrate`, the darkness scripts, `nw_s0_wallfirea` |
| `SCRIPTS_AREA_TIMINGS`, `SCRIPTS_TYPE_TIMINGS` | — | The same, broken down by module area and by event type |
| `ENABLE_OBJECT_EVENT_HANDLERS` (default off) | `ObjectEventHandlers` | Time in the **engine's** native object handlers, not in NWNX subscriber scripts. Context, not the target |
| `ENABLE_TICKRATE`, `ENABLE_MAIN_LOOP` | — | Whether any of it is hurting the server |

Reading an object-event-handler figure as the cost of a subscriber script would
be the easy mistake here, and it is a different measurement entirely.

**Dev only.** `config/nwserver.env` was not touched.

**The counter.** `pb_prof_fxrate.nss`, subscribed on demand from the DM console,
counts applications and removals separately. Two modes so one session yields
both numbers:

| Mode | Work per event | Answers |
|------|----------------|---------|
| `light` | One `GetCurrentEvent`, one `GetLocalInt`, one `SetLocalInt` | The floor: what any subscriber costs before doing anything |
| `heavy` | The same, plus the `CREATOR` and `SPELL_ID` reads | What `event_effects.nss` pays today, and what reading event data actually costs |

```
dm_fxprof on       start counting, light
dm_fxprof heavy    start counting, and also read the event data
dm_fxprof stat     counts, elapsed seconds, per-second rates, player count
dm_fxprof off      unsubscribe
```

**The procedure.** With players on and combat happening, run `light` for a few
minutes and read `stat`; then `heavy` for the same span; then read Grafana for
tick rate and for the **per-script** timings (`ENABLE_SCRIPTS`, not the object
handler metric) of `event_effects`, the darkness enter and exit scripts, and
`nw_s0_wallfirea`. Record all of it here with the player
count it was taken at, because a rate without a population is not a number.

**What it decides.**

- Whether the generic orphan sweep belongs in the effect-removed handler or on
  the three triggers of 3c.
- Whether `OBJECT_PARAM_*` via `NWNX_Effect_UnpackEffect`/`PackEffect` is
  affordable on every application, or whether the tag string of 3c stays.
- Whether restoring the wall of fire heartbeat costs anything worth naming.
- Which of the 152 hand-rolled effect loops and 183 shape sweeps are actually
  hot, so slice 6 spends its effort where it matters.

**`pb_prof_fxrate.nss` and the `dm_fxprof` console branch are temporary** and go
once the numbers are recorded, along with `pb_dbg_fxowner.nss` and `dm_efectos`.

### Slice 0b — Naming: the `gs` prefix stays, and spreads

Considered and rejected on evidence, 2026-08-25. Stripping the inherited `gsSP`
would give the two most-used functions names the compiler refuses:

```
zz_probe_shadow.nss: ERROR: DUPLICATE FUNCTION IMPLEMENTATION (RemoveEffect)
```

`RemoveEffect` and `ResistSpell` are both natives in `nwscript.nss`, and a probe
confirms a script cannot shadow one. The prefix is not decoration; on those two
it is what makes the name legal. Renaming would also touch **159 call sites
across 45 files** for no behavioural gain.

#### But new functions do take the prefix

Reversed on evidence the same day, on reviewing whether they should.

**A bare name is a bet against Beamdog.** `nwscript.nss` appends new natives at
the end, so position dates them: **227** functions are declared before line 8000,
the original block, and **445** after line 11000, added during Enhanced Edition
and still coming. The last six are `SpellImmunityCheck`,
`SpellAbsorptionLimitedCheck`, `SpellAbsorptionUnlimitedCheck`,
`GetPlayerNetworkLatency`, `GetBodyBag`, `SetBodyBag` — exactly the register of
name a library would also want. `GetAoERadius` is precisely the kind of name a
patch could take.

And a collision is not a warning. The probe above shows what happens: the whole
file stops compiling, and it stops compiling the day the game updates, on
somebody else's schedule.

Three characters buys immunity from that, plus one `grep -a gsSP` that finds the
library. `gs` means nothing in this project and that is fine: it is a namespace
marker, not an abbreviation, and inventing a second one would put three
conventions in a file that already has two.

**So: everything new in this library is `gsSP*`.**

| Proposed | Becomes |
|----------|---------|
| `CreatePersistentAoE` | `gsSPCreateAoE` |
| `GetIsInsideAoEOfType` | `gsSPGetIsInsideAoE` |
| `GetAoEInstanceTag` | `gsSPGetAoEInstanceTag` |
| `ApplyAoEEffect` | `gsSPApplyAoEEffect` |
| `RemoveAoEEffects` | `gsSPRemoveAoEEffects` |
| `SweepOrphanedEffects` | `gsSPSweepOrphans` |
| `HasEffect` | `gsSPHasEffect` |

#### And the bare ones were renamed too — **done, 2026-08-25**

The case against was a churn estimate of 45 files. **It churns eleven.**

Measured exactly, the fifteen former bare exports have **27 external call sites
across 16 files**, and those split cleanly:

| | Call sites | Files |
|---|---:|---:|
| The twelve functions renamed here | **13** | 10 |
| The `PJ_*` triplet, excluded below | 14 | 6 |

So the rename touched eleven files, the ten callers plus `inc_spells.nss`
itself.

The second reason is the stronger one, and it is not collision avoidance:
**`gs` marks a native that has been wrapped to give it guardrails.**
`gsSPRemoveEffect` is exactly that — `RemoveEffect` with a subtype policy and a
creator filter. A reader seeing `gs` knows the module owns the behaviour; a bare
name says the engine does. Two conventions in one library destroy that signal,
and the signal is worth more than the rename costs.

| Was | Is |
|-----|-----|
| `IntDivisionRounding` | `gsSPIntDivisionRounding` |
| `GetAoEId` | `gsSPGetAoEId` |
| `GetAoERadius` | `gsSPGetAoERadius` |
| `GetAoEShape` | `gsSPGetAoEShape` |
| `GetAoEPartner` | `gsSPGetAoEPartner` |
| `SetAoECastClass` | `gsSPSetAoECastClass` |
| `SetAoECasterLevel` | `gsSPSetAoECasterLevel` |
| `SetAoEId` | `gsSPSetAoEId` |
| `SetAoEMetaMagic` | `gsSPSetAoEMetaMagic` |
| `CreateNonStackingPersistentAoE` | `gsSPCreateNonStackingPersistentAoE` |
| `ApplyTaggedEffectToObject` | `gsSPApplyTaggedEffectToObject` |
| `ReadySingleMemorizedSpell` | `gsSPReadySingleMemorizedSpell` |

**`PJ_EfectoQuitar`, `PJ_EfectoBuscarTag` and `PJ_EfectoQuitarTag` are
deliberately not renamed.** Slice 3 deletes them; renaming something on its way
out is waste, and the odd prefix keeps them visible until it does.

The four file-private helpers keep their leading underscore. Beamdog does not
ship names beginning with `_`.

### Slice 1 — Settle the ownership handle in game — **done, 2026-08-25**

Answered: `GetEffectCreator` returns the caster, every darkness effect is
`PERMANENT` and untagged, and a DM cannot reproduce the bug. The evidence and
what follows from it are in 3c.

**Two questions the same session did not settle**, and neither blocks slice 2:

- **Does the exit path work for row 36?** Not re-measured on a player character
  after the DM run was discarded. The static reading says it does.
- **Do two casters' areas coexist?** Every reading with two casters listed one
  area, and the creator changed between readings, which
  `CreateNonStackingPersistentAoE` should not do across different casters. The
  probe now resolves its shape location once and cross-checks the walk against
  an independent `GetFirstObjectInArea` scan, printing both counts — but that
  build has not been run. Until it is, it is unknown whether the shape walk
  loses an area or the module destroys one.

**`pb_dbg_fxowner.nss` and the `dm_efectos` branch of `chat_consoladm.nss` are
still temporary.** They stay only until the two questions above are answered,
then both are deleted.

### Slice 2 — The API of 3c — **done, 2026-08-25**

Library only. **No behaviour changed**, by construction.

**`bForceRemove` became `nSubTypePolicy`.** Only **five** call sites passed
`TRUE` and fifty-six omitted it, so the migration was small enough to do
honestly rather than by renumbering the constants to make `TRUE` mean `ALL`:

| Call site | Now |
|-----------|-----|
| `chat_consoladm.nss` ×2, `DM_INMOVILIZADO` | `FX_SUBTYPE_ALL` |
| `nw_s0_darknessb.nss` ×2 | `FX_SUBTYPE_ALL` |
| `wrap_on_clnt_ent.nss` ×1 | `FX_SUBTYPE_ALL` |

`FX_SUBTYPE_SAFE` is `0`, so the fifty-six that omitted the argument keep the
behaviour they had.

**Three of those five almost certainly want `SAFE`.** Slice 1 measured every
darkness effect as `sub=MAGICAL`, which `SAFE` removes; the force is doing
nothing there but licensing more than the script needs. It was left alone on
purpose — narrowing it is a behaviour change, and this slice promises none.
Slice 4 decides it.

**`gsSPfindEffect` gained the wildcards `gsSPRemoveEffect` always had.** A
negative spell id now means any spell and an invalid creator means any creator;
before, a negative id returned nothing, so a caller that knew the tag but not
the spell had no way to ask. The six existing call sites all pass a real spell
id and a real creator, so none is affected.

**New:**

| Function | For |
|----------|-----|
| `gsSPHasEffect` | The documented replacement for `PJ_EfectoBuscarTag` |
| `gsSPGetAoEInstanceTag` | Builds `gsAoE#7f00001a` from the area object |
| `gsSPGetAoEInstanceIsAlive` | Splits that tag and asks whether the area still exists |
| `gsSPApplyAoEEffect` | Applies an effect owned by one area instance |
| `gsSPRemoveAoEEffects` | Removes only what this instance applied — for exit scripts |
| `gsSPSweepOrphans` | The generic backstop: tagged effects whose area is gone |

`gsSPSweepOrphans` does not consult subtype. An effect carrying an instance tag
was applied by this module, so this module may take it back; and an untagged
effect is never a candidate however old it is.

**Nothing calls the five new AoE functions yet.** They are the foundation slices
4 and 7 build on.

**And the sweep's home is settled without measuring it.** The question was
whether `NWNX_ON_EFFECT_REMOVED_AFTER` could afford a subscriber. It already has
one: `event_effects` has run on every effect removal on this server for months,
doing two `GetEventData` reads and a `StringToObject` before it looks at
anything. `gsSPSweepOrphans` reads one tag and compares a prefix — less than
what is already being paid. Profiler data agrees, with the caveat that it
was an unbounded query on an idle server and so is qualitative only:
`event_effects` does not appear among the costly scripts, while `nw_c2_default1`
and `hcr_l_plugin` dominate. Those figures are seconds of activity and totals,
not call counts — see
[`../repository/performance-measurement.md`](../repository/performance-measurement.md).

### Slice 3 — One library, no private copies — **done, 2026-08-25**

**The rule, restated by the owner: everything that touches effects or areas goes
through `inc_spells`. A system that needs a variation asks for it there; it does
not keep its own.**

**The bolted-on triplet is gone.**

| Was | Callers | Now |
|-----|--------:|-----|
| `PJ_EfectoQuitar` | 0 | deleted |
| `PJ_EfectoBuscarTag` | 2 | `gsSPHasEffect` |
| `PJ_EfectoQuitarTag` | 12 | `gsSPRemoveEffect`, one policy per tag |

`PJ_EfectoQuitarTag` had **no subtype filter at all**, so a faithful migration
would have been `FX_SUBTYPE_ALL` everywhere. Instead each tag was traced to what
applies it, which is what the API exists for:

| Tag | Applied as | Policy | Where |
|-----|-----------|--------|-------|
| `VFX_DUR_CHAT_BUBBLE` | `UnyieldingEffect` | `FX_SUBTYPE_UNYIELDING` | `event_guimod.nss:21` |
| `POCION_SIDRAPERA` | plain, so Magical | `FX_SUBTYPE_SAFE` | `pb_mod_activate.nss:1041` |
| `SPELL_ACELERAR` | plain | `FX_SUBTYPE_SAFE` | three haste scripts |
| `SPELL_ACELERARVISUAL` | plain | `FX_SUBTYPE_SAFE` | three haste scripts |
| `DM_INMOVILIZADO` | `SupernaturalEffect` | `FX_SUBTYPE_ALL` | `chat_consoladm.nss:809` |

Every one still removes the effect it was written to remove, because the policy
matches the subtype that was applied. What changed is that a haste removal can
no longer take a Supernatural or Unyielding effect that happens to share a tag —
which is the whole point of the parameter.

**`BorrarAreasEfecto` is gone too**, and with it the fourth private spelling of
an area rule. Its four callers now use `gsSPRemoveOwnAoE(oCreator, nAreaEffectId)`
in the library.

The new function keys on the **`vfx_persistent.2da` row**, not on a tag string
and not on a `spells.2da` row, per the identity rule of 3d. The row's `LABEL` is
the tag the engine gives the area object, which is what makes the match work. It
also destroys the area's partner — the static visual object — which
`BorrarAreasEfecto` never did. Nothing it removed had one, so that is a
correctness fix with no present effect.

**And the constants already existed.** `pb_constantes.nss` has declared
`AOE_PER_ING_HUMIFICADOR`, `AOE_PER_ING_BOMBARAICES`, `AOE_PER_ING_BOMBAGAS` and
`AOE_PER_ING_FUEGOALQUIMISTA` all along; the alchemist scripts were passing `67`,
`68`, `69` and `70` as literals. Both the new calls and the neighbouring
`EffectAreaOfEffect` calls now use the names.

**What this slice does not do.** `gsSPRemoveOwnAoE` is *one instance per caster*,
which is what those four bombs mean today. It is not the placement policy of 3d
and does not decide whether two areas may overlap. Slice 7 gives it
`AOE_ONE_PER_CASTER` as one option among four.

### Slice 4a — Darkness by instance, and the backstop — **done, 2026-08-25**

**The humidifier's exit script had never run.** `vfx_persistent.2da` row 67
named `cls_ing_humiab`; the file is `cls_ing_humib`, and nothing by the first
name exists anywhere — it is custom content, so the base game does not supply a
fallback either. Meanwhile `cls_ing_humia.nss:77` applies
`EffectConcealment(50)` with `GS_SP_DURATION_PERMANENT`, under the comment *"la
ocultación la da siempre que entres"*.

Anyone who walked through the artificer's humidifier kept **50% concealment
until they died**. One character in the 2DA fixed it.

A sweep of `vfx_persistent.2da` for custom scripts that do not exist found one
other, row 46 `VFX_MOB_NIGHTMARE_SMOKE`, heartbeat `DLA_S1_NMSMOKEC`. That
prefix belongs to an external content pack and was not traced; it is recorded,
not fixed.

**Darkness now applies and removes by instance.**

```nwscript
// enter
gsSPApplyAoEEffect(oTarget, eEffectDarkness, FX_KIND_DARKNESS, nSpell, GS_SP_DURATION_PERMANENT);
// exit
gsSPRemoveAoEEffects(oExiting, FX_KIND_DARKNESS, OBJECT_SELF, FX_SUBTYPE_SAFE);
```

Three things follow.

**The count of routes stops mattering, which is just as well, because it was
never seven.** Every earlier estimate in this document was low. Traced by
finding every script that creates `AOE_PER_DARKNESS` and then every
`spells.2da` row whose `ImpactScript` is one of them:

| Row | Spell | Through |
|----:|-------|---------|
| 36 | Darkness | `nw_s0_darkness` |
| 345 | SHADOW_CON_Darkness | `nw_s0_darkness` |
| 606 | ASDarkness | `nw_s0_darkness` |
| 688 | GWildShape_DriderDarkness | `x2_s1_driderdark` |
| 1011 | ConjAssNvl2_Oscuridad | `conj_oscuridad` |
| 1203 | Blig_Darkness | `nw_s0_darkness` |
| 1529 | MMF_Darkness | `mmf_s3_skills` |
| 2935 | DROW_OSCURIDAD | `nw_s0_darkness` |
| 3062 | ONI_OSCURIDAD | `nw_s0_darkness` |

**Nine rows**, through five different impact scripts — and two more creators that
are not spells at all: `q_spellhook.nss:259` and `shar_estatuas2.nss:17` build
the same area directly with `EffectAreaOfEffect(AOE_PER_DARKNESS)`.

The exit script named two of them. That is the whole finding, and it is why
counting was the wrong approach: the tag does not care how many there are.

**Two casters overlapping stop cancelling each other**, because the exit removes
only what its own area applied. And the policy narrows from `ALL` to `SAFE`,
which slice 2 flagged and this slice acts on: the enter script applies plain
effects, and slice 1's probe read all four back as `sub=MAGICAL`.

**The backstop refuses to run when it cannot trust itself.** `gsSPSweepOrphans`
decides an effect is orphaned because `StringToObject` could not resolve the
area that applied it. If that conversion were broken, every tagged effect would
look orphaned and live effects would be stripped — so it first checks that
`StringToObject(ObjectToString(oTarget)) == oTarget` on an object already in
hand, and returns 0 when it does not hold. The failure mode is then "the exit
scripts remain the only owner", which is the behaviour that existed before.

That check also removes the need for the round-trip test this slice was
supposed to start with. The code proves it at runtime instead of a person
proving it once.

**Where it runs.** `wrap_on_clnt_ent.nss`, on login — and **early**, right after
identity is resolved, not at the end. `main()` returns on several authorized
paths: the DM branch, subrace initialisation, dragonborn lineage. Each continues
the session without another client-enter event, so a sweep at the end would
never run for those players. It needs no location and no world state, only the
effects already on the character.

`RemoveStuckDarknessEffects` stays at the end where it was, because it *does*
depend on location — it asks whether the player is standing in a darkness — and
moving it would change its behaviour for no reason. It is marked transitional: darkness effects applied before instance
tags existed carry no tag and are invisible to the sweep. It can go once none
remain, and since effects do not survive death, that is a matter of time rather
than of migration.

**Still open: the area transition.** Whether an area of effect's exit script
fires when a creature transitions out of the area is untested. If it does not,
`NWNX_ON_SERVER_SEND_AREA_AFTER` is the hook, and the module has no subscriber
for it today.

### Slice 4b — Web, and where it stopped — **partial, 2026-08-25**

**Web is done.** Its exit script was a hand-written effect walk keyed on the
caster and on two `spells.2da` rows, `SPELL_WEB` and `1544`. It took a second
web from the same caster as readily as its own, and knew nothing of any third
row. Both are now the one call:

```nwscript
gsSPRemoveAoEEffects(oTarget, FX_KIND_WEB, OBJECT_SELF, FX_SUBTYPE_SAFE);
```

The enter script tags all four of its applications — the entangle link and the
permanent movement penalty, which is the one that stranded — and so does
**`nw_s0_webc.nss`, the heartbeat**, which reapplies the entangle and its visual
every round.

That heartbeat was missed on the first pass and it mattered: the old exit walked
effects by creator and spell id and so caught them, while a tag-only exit could
not see them at all. A creature leaving a web shortly after a heartbeat would
have stayed entangled for up to a round.

**The lesson generalises: an area has three scripts, not two.** Darkness happens
to have no heartbeat — `vfx_persistent.2da` row 11 carries `****` in that column
— which is why it never came up. Row 8 carries `NW_S0_WebC`. Any future
conversion must read all three columns, and a check that every script named by
the row applies zero raw effects is now the way this is confirmed:

| Kind | Script | Raw applications | Tagged |
|------|--------|-----------------:|-------:|
| Darkness | `nw_s0_darknessa` | 0 | 2 |
| Darkness | `nw_s0_darknessb` | 0 | — |
| Web | `nw_s0_weba` | 0 | 4 |
| Web | `nw_s0_webb` | 0 | — |
| Web | `nw_s0_webc` | 0 | 4 |

**`gsSPApplyAoEEffect` stopped routing through `gsSPApplyEffect`.** Web,
invisibility sphere and mind fog all apply with a plain `ApplyEffectToObject`,
so adopting the helper as written would have added two full effect-list walks
per application to an area enter — the dead effectiveness machinery of F1,
filing a number nothing reads. Confirmed: `GS_C2_SPELL_EFFECTIVENESS` is written
by `gsC2AdjustSpellEffectiveness` and read by **nothing** in the module.

The helper now tags and applies directly. The machinery is not removed — slice 5
still owns that — this path simply does not feed it, which is what lets an enter
script adopt tagging without paying for it. Darkness gets the saving too.

### Slice 4 validated in play — 2026-08-25

Every assumption the audits flagged as untested was measured. Readings from
`dm_efectos` on live characters.

**`TagEffect` tags the whole link.** All four darkness effects carry the same
instance tag, across two separate links:

```
fx[1] type=74 VISUALEFFECT  tag='gsAoE#DARKNESS#e08'  creator='Ertai Crowley'
fx[2] type=74 VISUALEFFECT  tag='gsAoE#DARKNESS#e08'
fx[6] type=58 DARKNESS      tag='gsAoE#DARKNESS#e08'
fx[7] type=72 CONCEALMENT   tag='gsAoE#DARKNESS#e08'
```

This was the single assumption the whole design rested on. It holds.

**Two casters' areas coexist, and each instance is distinct.** Standing where two
darknesses overlap:

```
8 effects: four tagged #e56 (Gustan Welm), four tagged #e55 (Ertai Crowley)
2 areas by shape, 2 areas by area scan
```

**And leaving one keeps the other.** Moving out of Gustan's area while remaining
inside Ertai's:

```
fx[0..3]  all tag='gsAoE#DARKNESS#e55'  creator='Ertai Crowley'
=== END: 4 effects, 1 areas by shape, 1 areas by area scan ===
```

Four removed, four kept, correctly sorted. Under the previous code all eight
went, leaving a character standing inside a darkness with no darkness on them —
F9 in its purest form, now gone.

**The subtype narrowing shows.** After leaving a darkness entirely, the character
retains one `MOVEMENT_SPEED_DECREASE` and three `SKILL_INCREASE`, all
`spell=-1`, `sub=SUPERNATURAL`, creator himself — his own racial and class
effects. `FX_SUBTYPE_SAFE` left them; the old `FX_SUBTYPE_ALL` need not have.

**`GetFirstObjectInShape` does not lose areas.** Every reading agrees with the
independent area scan, including the two-area case. This closes the question
opened in slice 1 and affecting the 183 scripts that sweep by shape. No bug.

**The humidifier lets go.** On a hostile target inside: a permanent visual, three
`BLINDNESS`, and a permanent `CONCEALMENT`. On leaving: `fx: none`. That
concealment is what used to last until death.

**Web's heartbeat tags.** Inside a web: `ENTANGLE`, `MOVEMENT_SPEED_DECREASE`
(permanent — the one that stranded) and its visual, all carrying
`gsAoE#WEB#e3f`.

#### What the readings also settled about scope

The humidifier and web both gate on hostility —
`gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, ...)` returns FALSE for the
caster and for anyone not hostile. So the humidifier's permanent concealment only
ever affected **hostile targets**, not everyone who walked through, which is
narrower than this document first claimed.

**And it raises a design question, deferred by the owner:** gassing an enemy
grants *them* 50% concealment. Blinding them fits a smoke cloud; concealing them
helps them. Recorded, not acted on.

### Slice 4c — Invisibility sphere — **done, 2026-08-25**

Done once the mechanism was measured in play rather than assumed.

**Its exit script carried F9, written out by hand in 2003.** The loop removed
exactly one effect and returned, with the previous author explaining why:

```
//only dispell one, this is to prevent a stacked group of
//AoEs all being dispelled by exiting one.
```

The workaround does not hold. It removes the **first match found**, which may
belong to a sphere the creature is still standing in — leaving on them the one
they just left. It made the symptom rarer and the cause worse.

The instance tag makes the question answerable rather than guessed:

```nwscript
gsSPRemoveAoEEffects(oTarget, FX_KIND_INVIS_SPHERE, OBJECT_SELF, FX_SUBTYPE_SAFE);
```

**Two guards were kept.** `oInvisSphereSource == oTarget` on exit — the sphere is
centred on its caster, who cannot leave it, so an exit event for them is
spurious. And the enter script's check that a creature is not carrying its own
sphere's invisibility. Neither is made wrong by tagging; only the "dispel one"
hack was, and only that was removed.

A `DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR")` lived inside the
deleted loop and was preserved beside the new call.

### Slice 4d — Mind fog — **done, 2026-08-25**

An earlier draft of this section called mind fog a special case needing a slice
of its own. It was wrong, and the owner said so: **it is the same shape as every
other area here, plus one line.**

Checking the reference settled it. `cow-scripts/` has its own mind fog, but it is
a **different design** — blindness and ability drain, and its exit applies
nothing lingering — so it is not the model for this one.

The 3.5 SRD confirms the lingering `2d6` rounds is the spell rather than an
oddity to design around, so the behaviour stays exactly as it was. Apply on
enter, remove on exit, then one extra line.

One separate ruleset question the SRD raised is recorded in
[`../pending-changes/spells-and-effects.md#4-mind-fog-the-repeated-save`](../pending-changes/spells-and-effects.md#4-mind-fog-the-repeated-save)
and **nothing was changed for it**.

#### The refresh that nearly went missing

The first conversion changed the spell, and the diff review caught it.

The old exit script opened with
`gsSPRemoveEffect(oExiting, GetSpellId(), GetAreaOfEffectCreator())`, and the
lingering penalty was applied with `gsSPApplyEffect(..., GetSpellId(), ...)` —
**same spell id, same creator**. So that first call removed any lingering penalty
from a previous exit before applying a new one. Leaving twice refreshed the
penalty; it did not stack.

Scoping removal to the area instance lost that, because the lingering effect is
deliberately not the area's. Two exits would have meant **-20 to Will**.

The refresh is restored with a plain tag:

```nwscript
gsSPRemoveEffect(oExiting, SPELL_INVALID, GetAreaOfEffectCreator(),
                 FX_TAG_MIND_FOG_LINGER, FX_SUBTYPE_SAFE);
```

**And the distinction is worth keeping.** An effect that outlives its area gets a
**plain tag**, not an instance tag: it does not belong to the area, so
`gsSPSweepOrphans` must never see it as an orphan. The tag exists only so the
next application can replace it instead of stacking on it. Caster scoping is
kept, as the old code had it.

**Three identical hand-written walks are gone** — one in the enter script, one in
its internal `HeartBeat`, one in the exit — each naming `SPELL_MIND_FOG` and
`1547` and filtering on the caster. All four applications are tagged.

**One thing left for slice 7, not because mind fog is special but because it is
not.** `nw_s0_mindfoga.nss` re-arms an internal `HeartBeat` with
`DelayCommand(6.0, ...)` rather than using an engine heartbeat —
`vfx_persistent.2da` row 4 carries `****` in that column. It is milder than wall
of fire's version, since it is gated on a local read from the area object and so
stops when the area dies. It belongs with wall of fire's chain in slice 7, where
that pattern is the subject.

### Slice 4e — One tag vocabulary, and one name for an int — **done, 2026-08-26**

What slices 2 to 4d left inconsistent, closed before slice 5 opens.

**`gsSPApplyEffect` takes no tag, and the two functions that do write one each
choose it themselves.** `sTag` is a filter on `gsSPRemoveEffect` and
`gsSPfindEffect` and predates this plan; `gsSPHasEffect` inherited it in slice 2.
On the write side the library has exactly two doors, and neither accepts a tag
from the caller:

- `gsSPApplyAoEEffect`, added in slice 2, builds `gsAoE#<objid>` itself. It names
  an area object, so it cannot serve an effect meant to outlive its area - which
  is what mind fog's lingering penalty is.
- `gsSPApplyTaggedEffectToObject`, from 2016, takes an `int` flag and renders it
  as a decimal string. That is F14's second vocabulary, and it also coerces the
  effect to Extraordinary.

So a caller that wants a plain string tag of its own choosing has no route
through the library, and thirteen files build one by hand with `TagEffect` and a
raw `ApplyEffectToObject`. `nw_s0_mindfogb.nss` is one of the thirteen: slice 4d
did not add a new hand-tagging site, it moved one, replacing an untagged
application with a tagged one written the same hand-rolled way.

**Constants for one caller do not belong in a shared include.**
`FX_TAG_MIND_FOG_LINGER` is used by one script. `lib_dm_vfx.nss` already shows
the convention this module actually follows — `EYES_VFX_DM_TAG`,
`HELM_VFX_DM_TAG`, `HORNS_VFX_DM_TAG` and `HAIR_VFX_DM_TAG` are declared in the
file that uses them. One constant per spell in `inc_spells.nss` is the same
growth the kind field was removed for in section 3g.

**Steps.**

1. `gsSPApplyEffect` gains a trailing `string sTag = ""`. Empty means the
   effect is applied exactly as today, with no `TagEffect` call, so a caller
   that tagged the effect itself keeps its tag. Non-empty tags before applying.
   No existing call site changes.
2. `nw_s0_mindfogb.nss` declares its own `MIND_FOG_LINGER` and applies the
   lingering penalty through `gsSPApplyEffect`. Its raw `ApplyEffectToObject`
   goes.
3. `FX_TAG_MIND_FOG_LINGER` is deleted from `inc_spells.nss`.
4. `inc_spells.nss` is renamed to one integer prefix throughout.

**No `gsSPGetSpellTag`, and the reason is that the engine already stores it.**
`GetEffectSpellId` returns the row that applied an effect, and both
`gsSPRemoveEffect` and `gsSPfindEffect` already filter on it. A tag carrying the
spell id would be a second copy of a fact the engine keeps, in the one field an
effect has, and `TagEffect` overwrites that field for every effect in a link.
A spell-id default on `gsSPApplyEffect` would silently overwrite the tags
`nw_s0_haste.nss` and `pb_potion_inc.nss` set before calling — the tags their own
removals then look for. The tag is for identity the engine cannot express: a
sub-identity within one spell, such as mind fog's lingering penalty, or an effect
applied from a context that produces no spell id at all.

**The rename.** `AGENTS.md` requires `i` for `int`; the file is 1212 lines and
uses `n` for 37 identifiers across roughly 275 occurrences, against 5 that use
`i`. Three of those names are the same concept — `nSpell` (28), `nSpellId` (14)
and `nSpellID` (5) — and collapse to `iSpellId`, which is the name commit
`1968899c8` settled on for the converted spells. No occurrence falls inside a
string literal, and NWScript has no named arguments, so no caller of any of these
functions changes. Prototypes, definitions and `@param` lines move together.

**Not in this slice.** The twelve files that still tag by hand after step 2 are
slice 6, where every caller is re-reviewed; adopting the new parameter is a
caller decision, not a library one.

The count, so slice 6 inherits a number rather than a guess: eleven files under
`src/shared/nss` and two under `src/nui` call `TagEffect` outside the library -
`chat_consoladm`, `event_guimod`, `lib_dm_vfx`, `nw_s0_haste`, `nw_s0_mashaste`,
`nw_s0_mgcconvla`, `nw_s0_mindfogb`, `pb_inc_mmf`, `pb_masfor_test`,
`pb_mod_activate`, `pb_potion_inc`, `nui_body_event` and `sw_inc_vfx`. Thirteen,
twelve once mind fog moves. `nwnx.nss` and `nwnx_deprecated.nss` also call
`TagEffect` and are not counted: there it is NWNX argument plumbing, not a tag. F14's integer tag vocabulary is recorded, not removed: dropping
the argument from `_UpdateAoEDataAtLocation` changes what the area object
carries, and belongs with the Extraordinary question in section 5.

**Verification, 2026-08-26.** `./linux_build-dev.sh --check` over 29 scripts in
two runs: the changed `nw_s0_mindfogb.nss`, the five converted areas, and a
consumer of every function the rename touched, including
`gsSPCreateNonStackingPersistentAoE`, `gsSPReadySingleMemorizedSpell`,
`gsSPfindEffect` and `gsSPGetAoEId`. 29 successful, 0 skipped, 0 errored.
`scripts/check_aoe_wiring.py`: all invariants hold, 5 converted, 66 not yet.

**One thing the rename needed that the plan had not foreseen.** Inside
`gsSPRemoveEffect` the local holding the examined effect's spell id was already
called `iSpellId`, and the parameter holding the row to match against would have
taken the same name. The local is now `iEffectSpellId`; without that the two
would have collided and line 519 would have compared a value with itself.

Not run: nothing was packed, deployed or played. The tagged application is
exercised by leaving a mind fog twice, which is the check slice 4d already
owed.

### Slice 8 — The split, and the engine's own handles — **8a done, 2026-08-26**

Ordered after slice 4e and before slice 6, because slice 6 walks every caller and
should walk them once, against the shape they will keep.

**8a. Split the include — done.** Slice 5 removed the blocker on the same day:
with the effectiveness calls gone, `gsSPApplyEffect` depends on nothing above it
and `inc_effects.nss` stands alone.

The constants were **not** placed by judgement. Each block was assigned to the
lowest layer that any function actually referencing it lives in, computed rather
than chosen, which is how `SPELL_ID_UNDEFINED` ended up in `inc_effects.nss` and
`CLASS_TYPE_ANY` in `inc_spellaoe.nss` - both against what a first reading would
have guessed. Nothing is duplicated across the three files.

Two attempts were thrown away before this one: the first cut function bodies that
contain blank lines, the second cut a `/* */` header in half. Both were caught by
the compiler, which is the point of the gate.

**Original text.** Three files as in section 6,
`inc_spells.nss` keeping the other two so no consumer changes. Mechanical move,
no logic edited, no function renamed - which it can only be once
`gsSPApplyEffect` stops calling `gsC2AdjustSpellEffectiveness`. See section 6.
Verified by compiling a consumer of every function moved, and one that includes
`inc_effects.nss` alone.

**8b. Read the server's build.** Start the stack, read the version it reports,
compare with the local install's `bin/win32/build.txt`. One line recorded here.
Everything below is blocked on it.

**8c. Probe `SetEffectCreator` with an area as the creator.** Apply an effect from
an area script with `SetEffectCreator(eEffect, OBJECT_SELF)`, then read back
`GetEffectCreator`, and check what the engine does with an area object in a field
it uses for dispel, faction and attribution. If it holds, instance scoping needs
no tag at all and three functions in this library stop being needed. If it does
not, the tag stays and this is written down as settled.

**8d. Give effects the parent's remaining duration.** F16's one durable point -
its identity handling is not a pattern to copy, see F16 - and the one that
removes a whole class of orphan rather than sweeping it up afterwards. Where
an area script can reach its own effect, apply children as
`DURATION_TYPE_TEMPORARY` for `GetEffectDurationRemaining` of the parent instead
of `GS_SP_DURATION_PERMANENT`. `gsSPSweepOrphans` stays for the cases that cannot.

**8e. One identity per area, chosen once - not a fallback.** An earlier draft of
this slice proposed a library call returning the engine's link id when the
caster's anchor effect could be found and the area's object id otherwise. **That
is a bug, not a convenience.** The anchor can disappear between enter and exit -
the caster logs out, dies, or drops the effect, which this document says six
paragraphs above - so an enter could tag with a link id and the matching exit
compute an object id. Removal would search for an identity that was never
applied, and the effects would stay on the creature. A link id would also be
invisible to `gsSPSweepOrphans`, which validates the object-id format.

**The area's object id stays the identity.** Inside an area script `OBJECT_SELF`
is the area, it is available in enter, heartbeat and exit alike, and it does not
depend on anything surviving elsewhere. That is the property the identity needs
and the only one of the two that has it.

`GetEffectLinkId` is recorded as the better answer **for a caller that has no
area object** - the case Magic Convalescence is in, applying from the cast script
rather than from inside the area. If such a caller is ever added here, it chooses
its identity once, writes it on the area, and every later call reads it back
rather than recomputing.

**8f. `SetEffectSpellId` for the potions.** Moves
`documentation/pending-changes/spells-and-effects.md#2-potion-effect-stacking` off NWNX entirely. Not
part of the library work: it is a ruleset decision about which row each potion
should stack against, and it belongs to that document.

**8g. The probe list this revision opened.** None of these is answered anywhere:
does `SetEffectSpellId` reach every effect in a link; does `SetEffectCreator`
accept an area object without disturbing dispel, faction or attribution; and does
this library's instance tag actually survive a recast, given that the one script
in the module that met that race handled it with a proactive sweep instead.

**What this slice does not do.** It takes no NWNX dependency. Every native above
is in `nwscript.nss`, and the only thing NWNX still owns alone is the
applied/removed event stream, whose cost 3e requires measuring first.

### Slice 5 — The effectiveness machinery is deleted — **done, 2026-08-26**

Decided by looking at what it was for.

In COW it is not a spell mechanic at all. `inc_combat2.nss:752` holds the reader,
`gsC2GetIsSpellEffective`, which returns `Random(11) > counter`, and its only
consumer is `gsC3VerifySpell` in `inc_combat3.nss:64` - COW's creature AI
deciding whether to bother casting a spell on a target it has already failed
against. The counter climbs on failure and drops by three on success, clamped to
0..9. Monster AI, nothing more.

**PDB has neither file.** No `inc_combat2`, no `inc_combat3`, no
`gsC3VerifySpell`, no `gsC2GetIsSpellEffective`. PDB uses `hench_*_ai` and the
stock `nw_c2_default*`. What was imported is the tail of an amputated system: the
counter was written on every application and read by nothing, which is F1.

So it is deleted, not finished. Importing it means importing COW's combat AI, and
that is a different project with a different owner. If PDB ever wants monsters to
stop repeating a spell that does not work, it starts there, not here.

**What that bought.** `gsSPApplyEffect` walked the target's entire effect list
twice on every call - before and after applying - to decide whether the count had
changed. Both walks are gone. `gsSPApplyAoEEffect` existed partly to avoid paying
for them and now simply calls `gsSPApplyEffect`, so the library has one apply path
again.

### Slice 6 — One identity, one tag, both directions — **planned 2026-08-26**

The caller re-review this plan exists for. `pb_potion_inc.nss` was walked case by
case first, because it is the worst of it and because it shows the whole problem
in one file.

#### What is actually there

**Ninety-four cases apply an effect**, and they divide three ways before any
question of stacking arises:

| | Cases | |
|---|--:|---|
| Buff or utility potions | 73 | the stacking question applies |
| Cure potions, effect-type walks | 9 | not a stacking guard at all |
| Thrown poison and disease | 12 | cases 129-140, applied `DURATION_TYPE_PERMANENT` by the shared tail at lines 1431-1446, not through the switch |

Of the 73, **17 guard against stacking** and 56 do not. The 17 do it in **five
different ways**, and 16 of them only work in one direction.

| Idiom | Cases | What it does | Both ways? |
|---|--:|---|---|
| **A** remove-then-apply | 9 | `RemoveEffectsFromSpell(oPC, SPELL_X)` before applying | **no** |
| **B+A+E** | 3 | refuse if the spell is present, remove three other rows, then `DoNoStackSkillBonus` | **no** |
| **C+A** tag written | 2 | as A, and writes a tag nothing reads | **no** |
| **B** refuse | 1 | `if (GetHasSpellEffect(SPELL_HASTE, oPC)) return;` | **no** |
| **B+A** | 1 | refuse, then remove one row | **no** |
| **C+B** tag both ends | 1 | the Volátil | **yes** |
| **F** none | 56 | nothing at all | — |

Cases: A is 4, 9, 21, 55, 61, 67, 72, 74, 94. B+A+E is 10, 70, 89. C+A is 97 and
100. B alone is 45. B+A is 109. C+B is 98. The nine cure walks are 15, 20, 41,
46, 62, 66, 93, 102, 103; the twelve thrown are 129-140.

**One of the seventeen behaves.** The Volátil replaces haste and haste replaces
the Volátil, because somebody wrote the tag on both ends -
`nw_s0_haste.nss:117-119` and `nw_s0_mashaste.nss:105-107` remove
`SPELL_ACELERAR`, `POCION_SIDRAPERA` and `SPELL_ACELERARVISUAL` before applying.

**The other sixteen guard one order of events out of two, and it is the wrong one
that is left open.** The removal or the refusal runs *while the potion is drunk*,
so **cast then drink** is handled: the potion finds the spell's effects and takes
them. **Drink then cast** is not, because the spell has never heard of the potion
and applies on top. The potions were not forgotten - somebody thought about
seventeen of them - but a rule written on one side only covers one direction, and
the direction it covers is the one the player is less likely to use.

#### `nostack_inc.nss` is not one of the six and is not in scope

`DoNoStackAbilityBonus`, `DoNoStackSkillBonus` and `DoNoStackSavingThrowBonus`
answer a different question: **which numeric bonus wins** when several apply to
the same ability, skill or save. That is a rule about magnitudes, not about
ownership, and it is used by a dozen scripts outside the potions. It stays where
it is and this slice does not touch it.

#### The rule

**An identity has one key per kind of source, and every source removes every key
it does not own.**

The engine already identifies a spell: it stamps the spells.2da row on what a
spell script applies, and `RemoveEffectsFromSpell` finds it. What it cannot
identify is a source that is not a spell - a potion drunk from an item activation
records row `-1`. That is what a tag is for, and it is the only thing it is for.

So a group has two keys and each side removes the other's:

| | owns | removes |
|---|---|---|
| the spell | its spells.2da row | the potion's tag |
| the potion | its tag | the spell's row |

**A stock spell script is not rewritten to carry a tag it does not need.** It
gains one removal and nothing else. Making every spell apply through the library
so that it could carry a tag would edit dozens of BioWare scripts to reproduce an
identity the engine already provides, and it would buy nothing.

**The exception is a group where no source has a usable row**, and there is
exactly one: SPEED. Three of its five sources apply from an item activation, so
the tag is the only key there and every source carries it - which is why that
group, and only that group, has every source applying through the library.

```nwscript
const string FX_ID_ACELERAR = "SPELL_ACELERAR";   // declared by the file that writes it
...
gsSPRemoveEffect(oTarget, SPELL_INVALID, OBJECT_INVALID, FX_ID_ACELERAR, FX_SUBTYPE_SAFE);
gsSPApplyEffect(oTarget, eLink, SPELL_INVALID, fDuration, FX_ID_ACELERAR);
```

Nothing else. No raw `TagEffect`, no `ApplyEffectToObject` beside it, no refusal
by `GetHasSpellEffect`, no removal by spell row where an identity exists.

`SPELL_INVALID` as the row is deliberate: writing a real row would make the
potion dispellable as that spell, which is a ruleset change and is not what this
slice is for.

**An identity shared by more than one file gets one declaration they share**, in
`inc_effect_ids.nss`. That is the single exception to "the tag belongs to the
file that writes it". As of 2026-08-26 there are **thirteen** such groups: SPEED,
the four damage shields, and the eight closed in step 3.

#### How this is kept true

A document saying the job is done is worth nothing: `AGENTS.md` records a
paragraph in this repository that claimed a conversion was finished while nine
types were still borrowing, and it was believed for six days because nothing
tested it. `scripts/check_aoe_wiring.py` exists for exactly that reason and
caught a real regression in slice 4b.

So this slice ships with **`scripts/check_effect_identity.py`**, which fails on:

1. **A `TagEffect` call outside the library.** Applying a tagged effect goes
   through `gsSPApplyEffect`; there is now no other supported way.
2. **A one-sided identity, counted per application site and not per file.** This
   is the part that has to be got right. A file-level check - collect the files
   that write an identity, collect the files that remove it, complain when a
   writer is not a remover - **passes on the exact defect it is meant to catch**:
   `pb_potion_inc.nss` holds dozens of independent sources in separate `case`
   branches, so one case that writes and removes puts the whole file in both sets
   and covers for every other case that only writes. The unit is the
   `gsSPApplyEffect` call and the block it sits in: every call that passes a
   non-empty tag must be preceded, in the same block, by a `gsSPRemoveEffect`
   for that identity.
3. **A tag literal appearing in more than one file without a shared
   declaration**, which is how three copies of `"SPELL_ACELERAR"` drift apart.

Exemptions are declared in the script with a reason, as the AoE checker does.
**The checker is proven before it is trusted**, and the proof is specifically the
case in point 2: take two potions in `pb_potion_inc.nss` that share an identity,
remove the guard from one of them, and confirm the check fails. A checker that
only proves itself on a cross-file defect proves nothing about this file.

#### Order

1. The checker, with every current defect listed as a known exemption, so it
   passes on today's tree and the list is the work queue.
2. The speed group, which already has both ends and only needs routing through
   the library plus the two holes closed - Agitada (45) and Sidra de Pera.
3. The eleven one-way groups, potion side and spell side together. **Thirteen
   spell scripts are edited, several of them stock, and that needs a decision
   before it starts.**
4. The nine D-walk cure potions, which are not a stacking problem at all but are
   the last private removal walks in the module.
5. The fifty-six with no identity: decide per potion whether it has one worth
   naming. Most will not.
6. The twelve thrown poison and disease cases, 129-140. They are not a stacking
   question - nothing else in the module grants those - but they apply
   `DURATION_TYPE_PERMANENT` from a shared tail outside the switch, with no
   identity and no owner, and the checker has to say explicitly whether they are
   in scope rather than silently omitting them. **The first survey omitted them,
   which is how a "case by case" walk reported 82 of 94 cases.**

### Slice 6 step 3b — the trio, and why `nostack_inc` wins — **decided 2026-08-26**

Acústica (10), Consciente (70) and de Verdad (89) were left out of step 3 because
they do three things at once. Settled by reading `nostack_inc.nss`, which turns
out to be the best-behaved identity system in the module.

**It is already two-directional, and at scale.** `DoNoStackSkillBonus` subtracts
the target's highest matching item bonus before applying, so a `+20` spell over a
`+20` item grants nothing - the D&D rule that same-type bonuses do not stack and
the highest wins. Then `RemoveMagicSkillBonus` removes every *other* spell row
that grants that skill, from a table of **61 rows across 17 skills, abilities and
saves**, and **37 files call it**. Every source removes the others because every
source goes through the same door. That is exactly what slice 6 is trying to
build, built already, for numbers.

**So it wins for its dimension and is not touched.** Skill, ability and saving
throw magnitudes are its business. It is not folded into `inc_effects`, not
duplicated, and not wrapped. The two answer different questions: `nostack_inc`
decides *how much*, this library decides *whose*.

**What the trio still needs is an identity for what `nostack_inc` does not
cover**: de Verdad's ultravision, see-invisible and spell immunity; Consciente's
magical sight; Acústica's visual. Those are ownership, not magnitude.

**And two defects found while reading them, neither introduced here.**

- `pb_potion_inc.nss` case 10 applies `eLink` without ever assigning it in that
  branch - the two lines that would build it are commented out - so the
  application is a no-op and the potion's real work is the `DoNoStackSkillBonus`
  call beside it.
- Case 70 builds `eLink = EffectLinkEffects(eLink, eVis);` reading `eLink` before
  it holds anything, which is the same defect as `pb_mod_activate.nss:1038`.

Both are recorded and not fixed here: changing what these potions apply is a
ruleset decision, not plumbing.

### Slice 9 — the spells: what is wrong, and what "under control" means

**The scale first, because it decides the strategy.** Across `nw_s0_*`,
`x0_s0_*`, `x2_s0_*`, `conj_*` and `dote_*`, **431 scripts apply an effect**:

| | Scripts |
|---|--:|
| Remove by spells.2da row | 70 |
| Hand-written `GetFirstEffect` walk | 41 |
| Create an area of effect | 34 |
| Use `nostack_inc` for numeric bonuses | 25 |
| Write an effect tag | 1 |
| **Apply through this library** | **3** |

Three of four hundred and thirty-one. Converting them all is not a plan, it is a
rewrite of the module, and it is not proposed.

**"Under control" is not "rewritten".** A spell is under control when it applies
through `gsSPApplyEffect` and declares an identity **if it shares one**. A spell
that grants something no other source grants needs no identity and gains nothing
from conversion. Most of the 431 are in that position and should be left alone.

#### The four classes, by what is actually wrong

**1. The 41 hand-written effect walks.** Each is a private opinion about what "an
effect of this spell" means, and they disagree: some filter by creator, some by
spell row, some by effect type, none by subtype. This is the class the library
was written to replace, and it is where a removal quietly takes something it
should not - which is how the invisibility sphere came to dispel one effect and
leave the rest. **Highest value per file changed.**

**2. The 34 areas, of which 29 are unconverted.** Slice 7 owns this and it is
where the observable damage is: wall of fire's `DelayCommand` chain lives on the
victim rather than the area, which is the bug that left a wall running after the
area died. Five are converted and hold in play.

**3. The 70 that remove by spells.2da row.** Correct whenever every source of the
benefit is a spell, and wrong the moment one is not - which is the entire finding
of slice 6. They are only worth touching when a second, non-spell source exists.
`inc_effect_ids.nss` is the register of the ones that do.

**4. The 25 that use `nostack_inc`.** Already right. Documented as such so that a
later pass does not "convert" them and lose the highest-wins rule.

#### Order, and it is not by count

1. **Slice 7 first**, because it is the only class with damage a player can see
   today. Wall of fire, the `SHAPE_CUBE` stub, and areas of the same type
   stacking.
2. **The 41 walks second**, in order of how much each removes: a walk that
   deletes by effect type is more dangerous than one that matches a spell row.
3. **The 70 row-removals last, and only where `inc_effect_ids` says a second
   source exists.** The rest stay as they are.

#### Two systems that are out of scope, decided rather than open

Both are recorded in `inc_effect_ids.nss` itself, in a comment beside the
identities they would otherwise belong to, so that the next person to open that
file reads the exclusion before wondering why they are missing.

- **`sw_inc_vfx.nss`**, under `src/nui`, is a third effect-by-tag library with
  its own callers. **Not touched.** It is not merged, not converted and not
  listed as a source of anything.
- **The shifter**, `mmf_s3_skills.nss`. **Not touched.** It grants rows 1540,
  1541 and 1542 - mage armour, elemental shield, acid sheath - which are the
  same benefits as three identities here, and it is deliberately not a source of
  any of them. If it is ever brought in, the change is to its parameters and
  never to how it behaves.

### F20. RETRACTED — an explicit `""` is exactly what the default is

The finding claimed that `EffectAreaOfEffect(id, "enter", "", "exit")` overrides
the `vfx_persistent` row with an empty heartbeat, while omitting the argument
defers to the row. **It is false, and the declaration says so:**

```nwscript
effect EffectAreaOfEffect(int nAreaEffectId, string sOnEnterScript="",
                          string sHeartbeatScript="", string sOnExitScript="");
```

The defaults **are** `""`. NWScript fills a defaulted argument in at the call
site, so `EffectAreaOfEffect(AOE_PER_WARLOCK_WALLFIRE)` and
`EffectAreaOfEffect(AOE_PER_WARLOCK_WALLFIRE, "", "", "")` compile to the same
bytecode - three `CONST.S ""` pushes before the `ACTION`. The engine cannot
distinguish them because by the time it runs there is nothing left to
distinguish. `""` is the sentinel that means "use the row", not an override of
it.

**What follows from the retraction.**

- Wall of fire has no heartbeat because `vfx_persistent.2da` row 5 carries
  `****` in that column, and for no other reason.
- The 2da change made and reverted on 2026-08-26 **would have worked**. The claim
  that it was inert until the call site changed, and the commit made to "fix"
  that call site, were both built on this error.
- The eight call sites this finding listed - mind fog, the shifter's copy, the
  humidifier, the three alchemist bombs and entangle - are not affected by
  anything. Any of them can be given a heartbeat by filling in its row.

**Why it was believed.** The engine's own comment says default scripts are used
when the scripts "are not specified", and "not specified" was read as "omitted"
without checking what the declaration's defaults were. They were on the next line
of the same file.


### The two wall-of-fire leftovers, and what to do about them

Both were listed to the repository owner on 2026-08-26 and both were left alone.
This is the proposal for each, written so the decision does not have to be
reconstructed later.

#### `nw_s0_wallfirec.nss`: a dead file that now lies

It is named for a heartbeat and contains a copy of the **exit** script. Nothing
references it: `vfx_persistent.2da` row 5 names `NW_S0_WallFireA` and
`NW_S0_WallFireB` and carries `****` where a heartbeat would go, and
`nw_s0_wallfire.nss` passes `""` for that argument as well.

**What it actually contains.** Two copies of an exit script, one commented out
above the other, and they use **the same** floored arithmetic - an earlier
version of this section said they differed in the floor, and they do not. The
live copy wraps it in `if (nMuroFuego > 0)` and then adds:

```nwscript
if (nMuroFuego > 0)
{
    SetLocalInt(oTarget, "AOE_" + ..., nMuroFuego <= 0 ? 0 : nMuroFuego - 1);

    if (nMuroFuego == 0)          // unreachable
    {
        DeleteLocalInt(oTarget, "AOE_" + ...);
        DeleteLocalInt(oTarget, "MuroFuegoActive");
    }
}
```

`nMuroFuego` is read once before the `SetLocalInt` and never updated, so inside a
branch that requires it to be above zero it can never equal zero. The cleanup
never runs, and `MuroFuegoActive` is a flag nothing else in the module sets or
reads.

So a reader who opens the file named `C` looking for the heartbeat finds an exit
script, in two versions, neither of which runs, one of which contains dead code
guarding a flag that does not exist.

**Three options.**

1. **Delete it.** Nothing references it and Nasher packs by resref, so removing
   it removes a resource from the module. Cheapest, and loses the only written
   trace that somebody once tried to write a heartbeat here.
2. **Empty it to a comment.** Keep the file, replace the body with a note saying
   what the name was for, that row 5 has no heartbeat, and that
   `nw_s0_wallfire.nss:31` would override it anyway. Costs a resource that does
   nothing and buys a signpost at the place somebody will look.
3. **Leave it.** Free, and the next reader spends the same twenty minutes this
   one did working out which of the three exit scripts is real.

**Decided 2026-08-26: keep it, and document it in its own header.**

The recommendation moved twice before the decision. The first draft said empty it
to a comment; the reviewer argued for deleting it, on the grounds that this
document already carries the reason there is no heartbeat, so the file's value as
a signpost was gone while its executable code still misled. The repository owner
decided to keep it, on the grounds that it costs nothing.

**What it costs, measured rather than argued:** no reference in any 2da, script,
dialogue or blueprint; 306 bytes compiled; never executed. The reviewer's own
words were that leaving it is "runtime-harmless".

So the objection was never that it does something. It was that it reads as if it
might. That is answered where the confusion happens - the file now opens with a
header saying it is dead, that its name says heartbeat and its contents are an
exit script, which exit script actually runs, that the `if (nMuroFuego == 0)`
branch is unreachable, and that `MuroFuegoActive` is written by that unreachable
branch and read by nothing in the module.

**Nothing below that header was edited.** A dead file that is honest about being
dead is not a trap, and this one is now the only place the attempt to give this
wall a heartbeat is still visible.

#### F20: retracted, and there is nothing here to decide

`nw_s0_wallfire.nss:31` passes `""` for the heartbeat, and that is **the same
thing as leaving the argument out** - the declaration's defaults are `""`. See
F20 above, which is retracted in full.

**So there is no leftover.** The line is correct as written, changing it would
change nothing, and a heartbeat for wall of fire needs only its row filled in.

### Slice 7 — Areas of the same type stop stacking

F9, and independent of everything above except that it shares the identity
problem.

- Store the `AOE_PER_*` id the area was built from, alongside the spell id the
  library already stores, and de-duplicate on it.
- Drop the caster from the guard: same type, any caster, one area.
- Give `SHAPE_CUBE` a real body, with a containment test that suits a wall
  rather than a centre-distance one.
- Re-check every caller of `CreateNonStackingPersistentAoE` for an area that is
  *meant* to stack, and exempt it explicitly rather than by omission.

**Ordering:** after slice 2, because it wants the same identity discipline, and
before or after slice 4 without preference — but if it lands first, slice 4's
instance-scoped removal stops being load-bearing.

### What is no longer in the plan

An earlier version opened by rewriting `gsSPRemoveEffect` to collect-then-remove,
because removing during iteration was thought to skip entries. **Removal is
deferred and nothing is skipped** (F3), so that rewrite is dropped and no NWNX
dependency is taken for it.

---

## 4b. Audit log, by slice

What each gate found, so a later reader does not have to reconstruct it from
`.audit/`. Findings are the reviewer's; dispositions are recorded here.

| Candidate | Slice | Verdict | Findings and outcome |
|---|---|---|---|
| `8c1016bf9` | 4e, plan | BLOCKED | F-001 the library does write tags, two functions do, and the file count was 13 not 14 with mind fog among them. F-002 asserted `StringToInt`'s non-numeric result without a probe. Both fixed in `b746904bc`. |
| `3ea122f27` | 4e, code | **PASS** | None. |
| `77e84b9ea` | 6, 8, plan | BLOCKED | F-001 the split cannot be mechanical while `gsSPApplyEffect` calls `gsC2AdjustSpellEffectiveness`. F-002 the link-id/object-id fallback was a bug: enter could tag with one identity and exit compute the other. F-003 F16 misread its own reference - `nw_s0_mgcconvlb` does not keep the exiting area's id, and a proactive sweep in the cast script is what handles the recast. F-004 `SetEffectSpellId` was called a one-call answer with link propagation unproven. F-005 line count stale. All fixed in `af59030c5`. |
| `381932565` | 5, 8a | BLOCKED | F-001 the spell row was written without the caster level, making area effects dispellable by anyone - already corrected in `34e04ffb8` before the review ran. F-002 the handoff named the wrong first parent, `37a067f53` instead of `af59030c5`, and pinned its census to `HEAD~`; the census was re-run against the true parent with an unchanged result. F-003 `gsSPApplyAoEEffect` still documented `iSpellId` as unused. Fixed. |

| `eea15842c` | saving throws, step 1 | BLOCKED | F-001 `IMMUNITY_TYPE_PARALYSIS` and `SAVING_THROW_TYPE_ACID` are both 6, so the root bomb's save was an acid save and converting it took acid modifiers away - named `_ACID` and left out of the slice. F-002 two of the owner's uncommitted files were swept in by `git add -A documentation/`. F-003 fifteen converted calls pass the area where the natives require the creator, not five. All fixed in `32d018e5c`; not finalisable, see below. |

### The gate only works at the tip

`agents-config/scripts/agent_audit.sh:370` requires the final state to be the
candidate itself or **one** direct remediation commit on top of it. A candidate
with five commits already on it cannot be closed, which is what happened to
`381932565`: reviewed, findings accepted and resolved, and not finalizable
because the branch had moved on.

**So a code slice is audited before the next one starts, not afterwards.**

**And nothing may be committed between the candidate and its remediation.** Three
audits have now failed to close for the same reason: a one-line follow-up commit
writing the real commit id into a changelog entry that said `PENDING`. That
follow-up puts the remediation two commits from the candidate and the finalizer
refuses it.

The changelog entry and the code go in **one** commit. Its id is not known while
it is being written, so the entry either omits the id and is amended into the
same commit, or the id is filled in by the remediation commit if there is one.
Never by a commit of its own. That
also answers the question this plan carried for two days about how to audit
forty-three commits at once: it cannot be done, and the fix is not a bigger
boundary but a smaller gap between finishing and reviewing.

## 5. What must be decided

### Spell effectiveness: finish it or delete it

The counter is `+1` when a spell is judged ineffective, `-3` when effective,
clamped to 0..9, kept per creature and per spell. That shape only makes sense as
an **AI aid**: a caster that stops throwing hold person at the elf who keeps
shrugging it off.

It is a reasonable feature. But the version that exists cannot be finished as it
stands, because what it measures does not answer the question — counting effects
before and after cannot tell "landed" from "replaced something", and the
hit-point check cannot tell "immune" from "already at full health" (F2).

If the feature is wanted, the honest version records the outcome **where the
outcome is known**: the saving throw result, the resistance roll, the immunity
check. `gsSPResistSpell` already sits on one of those. That is a different piece
of work from what is there, and what is there should go either way — two full
effect-list walks on 63 call sites is a real cost for a variable nothing reads.

**Recommendation: delete it in slice 5, and open a separate proposal if the AI
aid is wanted.** Not decided.

### `ApplyTaggedEffectToObject` making effects Extraordinary

```nwscript
if(GetEffectSubType(eEffect) != SUBTYPE_SUPERNATURAL)
    eEffect = ExtraordinaryEffect(eEffect);
```

Every effect that goes through it becomes Extraordinary, which changes what
dispel magic and resting can strip. Buried in a utility rather than stated at
each call site. Deliberate or inherited is not established here.
