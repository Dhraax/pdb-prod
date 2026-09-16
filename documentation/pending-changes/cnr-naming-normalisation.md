# Normalising the CNR names

**Status: accepted, in progress.** Every resource the CNR owns moves under
`src/cnr/` and takes a `cnr_` name, resref and tag alike, so the system is
self-contained and can be lifted into another module without rebuilding it.

## Why

The catalogue was assembled from three older systems and kept their names. Today
`src/cnr/uti` holds 507 blueprints of which **266 carry no `cnr_` prefix**:
`amu_`, `anillo_`, `bru_`, `sute_`, `cuero_`, `sapo_`, `molde_`, `carpacc_`,
`carplenyo_`, `polvo_`, `pb_`. The material store, which is now CNR's,
was still scattered across `src/shared/`.

That inconsistency has already cost real defects, each found by accident rather
than by a check:

- ten glove recipes asked for `sapo_plnt12_guan` while the template is
  `sapo_plnt12_capu`, so none of the ten could ever be made;
- five materials named a seventeen-character resref, which cannot exist, so they
  could be put into the material store and never taken out;
- four alchemy potion bases were deleted by a prefix sweep because their name
  said `sute_her_`, and the catalogue stopped generating.

## The scheme

A resref is capped at **16 characters**, so the prefix has to be short and the
rest is an abbreviation. Tag and resref are identical, with one owner-approved
kind of exception: several blueprints that must all satisfy one station tool
share that tool's tag. Today that is the four light hammers (`cnr_t_martligero`,
`cnr_t_martlig_2..4`, tag `cnr_t_martligero`) and the two needles
(`cnr_t_aguja`, `cnr_t_aguja_peq`, tag `cnr_t_aguja`).

| Prefix | What | Count |
|--------|------|-------|
| `cnr_b_*` | base item a recipe builds on | 76 |
| `cnr_e_*` | arcane essence | 129 |
| `cnr_c_*` | arcane crystal | 6 |
| `cnr_g_*` | rough gem, out of a vein | 28 |
| `cnr_q_*` | cut gem | 28 |
| `cnr_j_an_*` | ring, one per gem | 28 |
| `cnr_j_am_*` | amulet, one per gem | 28 |
| `cnr_m_*` | material: nugget `pe`, ingot `li`, hide `pi`, leather `cu`, log `le`, plank `ta` | 67 |
| `cnr_p_*` | component and processed stock: plants, reagents, grit `po`, rods `ci`, rings `ar`, chains `ca`, carpentry and smithing parts | 50 |
| `cnr_b_veneno_*` | poison flask bases | 4 |
| `cnr_t_*` | tool, mould `mo`, template `pl`, kit, work gloves `gu`, hammers, needles | 31 |

Metals take the code of the vein that drops them (`oscuro`, `enardec`, `frio`,
`vivo`...), so nugget, ingot and vein agree. Woods and gems take the name the
player sees, not the legacy tag's: `carplenyo_cipres` is shown as cedar and is
now `cnr_m_le_cedro`.

**One exception: the potions.** `sute_her_*` keep their names because
`pb_mod_activate` dispatches on the tag prefix, and renaming them means rewriting
that dispatch. 31 blueprints, all under `src/cnr/uti`.

The generated map is 507 names, all unique, none over 16 characters.

## What it touches

| Where | References |
|-------|-----------|
| `src/module/git` — placed items, shop stock | 470 |
| `src/cnr/uti` — the blueprints themselves | 284 |
| `src/shared/itp` — palette entries and `PaletteID` | 268 |
| `src/**/nss` — scripts | 188 |
| `src/cnr/utp` — node `CNR_MATERIAL` lists | 38 |
| `migration/catalogue/*.json` | 286 |
| `migration/03_catalogue.sql` | 251 names |

**The database needs no hand-written migration.** All thirteen catalogue tables
are generated from `02_seed.sql`, `03_catalogue.sql` and `05_arcane.sql`, which
`build_catalogue.py` and `build_arcane.py` produce from those JSON sources: a
rename is a regenerate plus `db-apply.sh`. No player table holds an item name at
all — `cnr_tradeskill` keeps a profession and a level, `pwdb_character` an
identity — and `db-apply.sh` counts the progress rows before and after and
aborts if they drop.

## The slices

Each one is a commit of its own, with its changelog entry and its audit.

1. **Move into `src/cnr`.** Done. Fifteen blueprints: the three the catalogue
   names that were still in `src/shared/uti` (`martillo_herrero`,
   `sapo_plnt12_capu`, the jeweller's kit), and the twelve `sute_her_*` of the
   alchemy family that were still there while their 22 siblings were already in
   `src/cnr/uti`. Then the eight scripts of the material store and the store
   opener, and the store's two placeables. No name changes, so nothing can
   break: only the path moves. The potions are exempt from the `cnr_` name,
   never from the location. The figure of 152 in the first draft of this
   document was wrong; it came from the material store's old ingredient list,
   which no longer exists.
2. **Rename what is already `cnr_*`.** Done. The 76 bases, 129 essences and 6
   crystals shortened to `cnr_b_*`, `cnr_e_*`, `cnr_c_*`.
3. **Rename the gems and the jewellery.** Done. 28 rough to `cnr_g_*`, 28 cut to
   `cnr_q_*`, 28 rings to `cnr_j_an_*` and 28 amulets to `cnr_j_am_*`. One
   canonical code per gem across the four families, taken from the blueprints'
   own display names: the legacy suffixes disagreed with each other, so the
   rough amethyst was `bru_per` while the ring was `anillo_amatista`, and the
   red tear was `bru_lagrimar` while the king's tear was `bru_lagrey` and
   `anillo_lagrimrey`. Both now read `amat`, `lagroj` and `lagrey` wherever they
   appear.
4. **Rename the materials, components and tools.** Done. 153 blueprints, listed
   one by one in [`cnr-naming-slice4-map.md`](cnr-naming-slice4-map.md). It
   was preceded by three separate commits: the old carpenter's 49 unreachable
   dialogue scripts were deleted, ten module items that had been filed as CNR
   (four named armours and shields with Bioware tags, the module tailor's
   helmet, and five pieces of leather gear) went back to `src/shared/uti`, and
   the catalogue generator's jewellery ordering, left empty by slice 3, was
   repaired. The rename itself also reached scripts outside the trade that name
   its materials: the three spells that consume gem grit, the mortar in
   `pb_mod_activate`, the treasure tables and one NPC.
5. **Close the door.** `build_catalogue.py --check` fails when a CNR blueprint
   has no `cnr_` prefix, a tag that differs from its resref outside the
   documented shared-tool exceptions, a name over 16 characters, or lives
   outside `src/cnr`. It must also cover the failure slices 3 and 4 found: a
   rule that recognises a family by a name prefix, or builds a name by
   concatenation, keeps compiling and silently stops matching after a rename.

## What each slice has to update, every time

- the blueprint file name and its `Tag`;
- `migration/catalogue/*.json`, then regenerate `03_catalogue.sql`;
- the palette entry and the blueprint's `PaletteID`;
- `CNR_MATERIAL` on the node blueprints that drop it;
- the material store: its list in `sapo_cons_alma` **and** a conversion line in
  `sapo_alma_migr`, so what a character has stored follows the rename instead of
  being orphaned;
- any script naming it;
- placed instances and shop stock under `src/module/git`.

## How each slice is verified

- a dangling-reference sweep: no name that disappeared may survive anywhere,
  searched as whole identifiers **and** as prefixes built by concatenation, in
  scripts and in the generators (`"pb_ofi_artdiag" + n`, `row["metal"] + "_aro"`);
- a search of both generators for rules that recognise a family by its name
  (`startswith("bru_")`), because they keep compiling after a rename;
- `python3 migration/build_catalogue.py --check`, which compares against the
  committed catalogue and refuses a recipe that changes identity or is lost. It
  does **not** compare tier, level, DC or XP, so the regenerated SQL is also
  compared with the committed SQL after translating the renamed names, and the
  two must be byte-identical;
- the focused NWScript compilation for whatever `.nss` changed;
- for the store, the check that every entry resolves to a blueprint, that no two
  entries share a persistent key, and that every old key is either converted or
  deliberately dropped.

## Provenance

Agreed 2026-09-16. The naming scheme and the slice order are the owner's;
the counts here were measured against the repository on that date.
