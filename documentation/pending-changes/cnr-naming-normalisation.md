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
rest is an abbreviation. Tag and resref are always identical from now on.

| Prefix | What | Count |
|--------|------|-------|
| `cnr_b_*` | base item a recipe builds on | 76 |
| `cnr_e_*` | arcane essence | 129 |
| `cnr_c_*` | arcane crystal | 6 |
| `cnr_g_*` | rough gem, out of a vein | 28 |
| `cnr_q_*` | cut gem | 28 |
| `cnr_j_an_*` | ring, one per gem | 28 |
| `cnr_j_am_*` | amulet, one per gem | 28 |
| `cnr_m_*` | material: ingot, nugget, log, plank, hide, leather | 67 |
| `cnr_p_*` | component and processed stock | 71 |
| `cnr_t_*` | tool, mould, template | 24 |

**One exception: the potions.** `sute_her_*` keep their names because
`pb_mod_activate` dispatches on the tag prefix, and renaming them means rewriting
that dispatch. 22 blueprints.

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

1. **Move into `src/cnr`.** Done. Three blueprints the catalogue needs
   (`martillo_herrero`, `sapo_plnt12_capu`, the jeweller's kit), the eight
   scripts of the material store and the store opener, and the store's two
   placeables. No name changes, so nothing can break: only the path moves.
   The figure of 152 in the first draft of this document was wrong; it came
   from the material store's old ingredient list, which no longer exists.
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
4. **Rename the materials, components and tools**: 162.
5. **Close the door.** `build_catalogue.py --check` fails when a CNR blueprint
   has no `cnr_` prefix, a tag that differs from its resref, a name over 16
   characters, or lives outside `src/cnr`.

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

- a dangling-reference sweep: no name that disappeared may survive anywhere;
- `python3 migration/build_catalogue.py --check`, which compares against the
  committed catalogue and refuses a recipe that changes identity or is lost;
- the focused NWScript compilation for whatever `.nss` changed;
- for the store, the check that every entry resolves to a blueprint, that no two
  entries share a persistent key, and that every old key is either converted or
  deliberately dropped.

## Provenance

Agreed 2026-09-16. The naming scheme and the slice order are the owner's;
the counts here were measured against the repository on that date.
