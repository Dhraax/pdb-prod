# Bonus stacking

How ability, skill, saving throw and regeneration bonuses combine on this
server: what the code does today, where it lets things stack, and what would
have to happen to make that a decision instead of an accident.

**Status: description and analysis. Nothing here is implemented or scheduled.**
Written 2026-08-23 out of a report about one spell; the spell is a symptom and
its own document is
[`../pending-changes/spells-and-effects.md#3-negative-energy-burst-and-nostack_inc`](../pending-changes/spells-and-effects.md#3-negative-energy-burst-and-nostack_inc).

---

## 1. The objective

**Restrictive by default. Only the highest bonus counts, for items and for
spells alike. Anything that stacks does so because somebody decided it should,
and that decision is written down.**

That last sentence is the whole point. The problem today is not that some things
stack — heroism, listen and spot, the alchemy potions and their extra bonuses
are all meant to. The problem is that **nothing distinguishes "stacks because we
chose it" from "stacks because nobody added it to a list"**, and both look
identical from the outside.

---

## 2. How it works today

Everything lives in `src/shared/nss/nostack_inc.nss`: **1231 lines, 45 public
functions**. It predates NWNX:EE having a plugin for this.

### Two halves that behave differently, on purpose

**Items strip each other.** On equip, the lower property is *physically removed*
from the item and its value stashed in a local variable on that item; on unequip
it is put back. Equip a `+3` ring while wearing a `+4` belt and the ring's
property is gone from the ring until you take the belt off.

**Spells top up the difference.** A spell never touches an item's properties. It
subtracts what the gear already gives and applies only the remainder:

```nwscript
sItem = GetHighestBonusItem(oTarget, ITEM_PROPERTY_ABILITY_BONUS, nAbility);
nModifier -= sItem.nScore;                    // item +4, bull's strength +6 -> apply +2
RemoveMagicAbilityBonus(oTarget, nAbility);   // and drop any previous spell bonus
if (nModifier < 1)
    SendMessageToPC(oCaster, "¡El bonificador de característica del objetivo es muy poderoso para este conjuro, no tendrá efecto alguno!");
```

The total lands on the highest of the two, and when the gear already beats the
spell the caster is told so and nothing is applied. That message is the visible
half of the design.

### Where it is wired

| Side | Entry point | Wired? |
|---|---|:-:|
| Items, on equip | `wrap_on_equip_it.nss` → `NoAbilityStackOnEquip`, `NoSkillStackOnEquip`, `NoSavingThrowStackOnEquip`, `NoRegStackOnEquip` | yes |
| Items, on unequip | `wrap_on_uequip_i.nss` → the four `…OnUnEquip` | yes |
| Spells | each spell script calls `DoNoStackAbilityBonus`, `DoNoStackSkillBonus` or `DoNoStackSavingThrowBonus` **if its author remembered** | per script |

The item side is a module hook and therefore total. **The spell side is opt-in,
one script at a time**, and that is the root of everything below.

### The four families are not equally built

| Family | Item side | Spell guard | Guard drops previous spell bonuses? |
|---|:-:|:-:|:-:|
| Ability | yes | `DoNoStackAbilityBonus` | yes — 61 spell ids listed |
| Skill | yes | `DoNoStackSkillBonus` | yes |
| Saving throw | yes | `DoNoStackSavingThrowBonus` | **no** |
| Regeneration | yes | **none exists** | — |

`DoNoStackSavingThrowBonus` subtracts the item bonus and applies — it never calls
`RemoveMagicSavingBonus`. And that function, when something does call it, holds
**one** spell:

```nwscript
case 0: // Salvaciones universales
    RemoveEffectsFromSpell(oPC, 151); // Resistencia
break;
case SAVING_THROW_FORT:
//            RemoveEffectsFromSpell(oPC, 13);      <- commented out
```

So saving throw spells stack with each other without limit. There is no
regeneration guard for spells at all.

---

## 3. Where stacking happens today

Counted by walking every `.nss` in `src/` for a direct
`EffectAbilityIncrease` / `EffectSkillIncrease` / `EffectSavingThrowIncrease`
that never goes through the corresponding guard:

| Family | Scripts using the guard | Scripts bypassing it | of those, real spells |
|---|--:|--:|--:|
| Ability | 22 | **31** | 10 |
| Skill | 14 | **36** | 9 |
| Saving throw | **1** | **61** | 30 |

### By omission — spells that never call the guard

- **Ability:** Barbarian Rage, Frenzy, Defensive Stance, Battle Mastery, Awaken,
  Gate and the three planar bindings, `AuraOfGlory_X2`.
- **Skill:** **heroism**, bard song, medicine domain, prayer, divine trick,
  familiar, the warrior's jumps and seduction, PdK wrath.
- **Saving throw:** thirty of them, including bless, haste, mass haste, prayer,
  aid, holy aura, unholy aura, protection from evil and from good, remove fear.

### By omission — spells that call the guard but are absent from its lists

Eleven apply an ability increase and appear in none of the removal lists, so
nothing cancels them and they cancel nothing:

`63` Gate · `69`/`96`/`128` the planar bindings · `307` Barbarian Rage ·
`363` Awaken · `380` Battle Mastery · `562` AuraOfGlory_X2 — while its sibling
at `429` **is** listed · `1329` Frenzy · `1333` Defensive Stance ·
`1418` the Artificer's Infusion Elixir.

The labels have drifted from the ids too: the entry for `429` is commented
*"Aura de virtud"*, and `429` is `AuraOfGlory` in `spells.2da`.

### By design — the saving throw family

Covered above. Not an oversight in a list; the guard itself does not de-stack.

### Sources that are not spells

Twenty-one `rezar_*` prayers, subraces, mounts, feats, powers, and the alchemy
potions. `pb_potion_inc.nss` applies `EffectSavingThrowIncrease` directly, and
none of these route through a guard.

### The `-1` problem, which cuts across all of the above

Every guard ultimately matches on `GetEffectSpellId`. The installed
`nwscript.nss` is explicit:

> *Returns **-1** if eSpellEffect was applied **outside a spell script**.*

So **any effect applied from a `DelayCommand`, an item-activation script, a
conversation or an event handler carries `-1` and can never be matched**, no
matter how complete the lists get. NWNX's own NoStack README says the same
thing from the other side:

> *scripted effects, unless created from a spellscript, always have an
> INVALID_OBJECT creator and a spellId of -1.*

This is what makes the Negative Energy Burst stack: its Strength bonus is
applied inside a `DelayCommand`, so it is a `-1` effect and spell `370` never
matches it. Two of the twenty-five `DoNoStackAbilityBonus` call sites are
wrapped in a `DelayCommand` — that one, and Aura de Vitalidad.

---

## 4. What is wrong with the shape, not the contents

- **The policy is a hand-kept list of 61 spell ids** across 85 removal calls. It
  is only ever as correct as the last person to remember it.
- **It is already behind** by at least eleven spells and one mislabelled id.
- **It cannot express intent.** A spell that stacks and a spell that was
  forgotten are the same thing in this design.
- **It cannot see `-1` effects at all**, which is most of what the module
  applies outside spell scripts — including every potion.
- **Two of the four families are barely implemented** on the spell side.

---

## 5. What NWNX offers instead

The **NoStack** plugin is pinned at `nwnxee/Plugins/NoStack/` and is **switched
off**: `NWNX_NOSTACK_SKIP=y` in both `config/nwserver.env` and
`config/nwserver.env`. Nothing in `src/` calls it; only its header sits
there unused.

Modes, set per family through `NWNX_NOSTACK_ABILITY`, `_SKILL`,
`_SAVINGTHROW` and `_ATTACKBONUS`:

| Value | Behaviour |
|---:|---|
| 0 | vanilla, everything stacks |
| 1 | nothing stacks — only the highest effect is used |
| 2 | the highest item effect **and** the highest spell effect |
| 3 | only item effects are stopped |
| 4 | per-type, assigned per spell |

### Mode 4, as the code actually computes it

From `nwnxee/Plugins/NoStack/BonusStacking.cpp`. There are **21 buckets**, one
per type. Each effect falls into one:

- an **item** effect → the bucket named by `NWNX_NOSTACK_ITEM_DEFAULT_TYPE`.
  There is no per-item classification; all items share one bucket.
- a **spell** effect → its declared type, or `NWNX_NOSTACK_SPELL_DEFAULT_TYPE`
  if it was never declared.

Then:

```cpp
if (nBonusType == Circumstance)
    bucket[type] += strength;                        // circumstance SUMS
else
    bucket[type] = max(bucket[type], strength);      // everything else takes the HIGHEST
…
return sum of all buckets;                           // different types always stack
```

**Within a type only the highest counts, except circumstance which adds.
Different types always stack with each other.**

### Which side you have to enumerate is your choice

It follows from `SPELL_DEFAULT_TYPE`:

| Default | Undeclared spells | You declare |
|---|---|---|
| `1` Circumstance *(the plugin's own default)* | stack freely | the ones that must **not** stack |
| anything else, e.g. `0` Enhancement | share one bucket, so only the highest of them all counts | the ones that **must** stack |

Either way you enumerate one side, never both. Pick whichever list is shorter
and more stable.

### How the heroism case is expressed

Heroism and greater heroism must not stack **with each other**, but must stack
with everything else. Give them the same non-circumstance type:

```nwscript
NWNX_NoStack_SetSpellBonusType(SPELL_HEROISM,         NWNX_NOSTACK_EFFECT_TYPE_MORALE);
NWNX_NoStack_SetSpellBonusType(SPELL_GREATER_HEROISM, NWNX_NOSTACK_EFFECT_TYPE_MORALE);
```

Same bucket, non-circumstance → the higher wins. A different bucket from
enhancement → still stacks with bull's strength and with gear. Morale is also
what the tabletop rules call heroism's bonus type.

### The traps

- **The `-1` bucket does not go away.** Mode 4 classifies by spell id, so every
  scripted effect still lands in one undifferentiated bucket, governed by
  `NWNX_NOSTACK_SEPARATE_INVALID_OID_EFFECTS`: on, they all stack with each
  other; off, none of them do. **All 58 potion effects live there**, and so does
  the Negative Energy Burst's bonus while it stays inside its `DelayCommand`.
  The only middle ground is the one the README describes — unpack each effect,
  give it a real spell id, and classify it, which needs dummy rows in
  `spells.2da`.
- **Items share one bucket with whatever spell you put in the same type.** Put a
  spell in `ITEM_DEFAULT_TYPE` and it competes with the entire wardrobe.
- **Penalties.** `NWNX_NOSTACK_ALWAYS_STACK_PENALTIES` defaults to `false`, so
  penalties stop stacking too unless that is set deliberately.
- **`NWNX_NOSTACK_IGNORE_SUPERNATURAL_INNATE`** governs the effect type used by
  the Race, SkillRanks and Feat plugins. All three are enabled here and all
  three are called from `src/`.

---

## 6. What a migration would involve

Not one variable, and in this order:

1. **Take bonuses out of `DelayCommand`s** wherever the guard is expected to
   see them. Nothing — plugin or include — can classify a `-1` effect.
2. Decide `NWNX_NOSTACK_ABILITY`, and whether the other three families follow.
3. Decide `SPELL_DEFAULT_TYPE` and `ITEM_DEFAULT_TYPE`, which decides which side
   gets enumerated.
4. **Classify the exceptions.** A module-load script calling
   `NWNX_NoStack_SetSpellBonusType` once per spell. It does not exist, and this
   is where the design work actually is.
5. Decide `SEPARATE_INVALID_OID_EFFECTS`, `ALWAYS_STACK_PENALTIES` and
   `IGNORE_SUPERNATURAL_INNATE`.
6. Retire `nostack_inc.nss` gradually. Its equip and unequip half cannot keep
   running alongside the plugin — two systems stripping and restoring the same
   item properties would fight.

It changes stacking for **every spell, feat and item on the server at once**,
which is a balance change of a different order from any single fix and needs its
own testing pass.

---

## 7. What has to be decided before any of it

**The exception list.** Everything above is mechanism; this is the content, and
it is a design decision rather than a technical one.

The list of 49 bypassing scripts in section 3 is the starting point, and the
first question to ask of each is the one the current design cannot answer:
*was this meant to stack, or was it forgotten?*

Known intentional, from the report that started this:

- heroism and greater heroism — stack with others, **not with each other**
- listen and spot
- the alchemy potions and their extra bonuses
- the Negative Energy Burst — **once**, never with itself

Everything else on that list is unreviewed.
