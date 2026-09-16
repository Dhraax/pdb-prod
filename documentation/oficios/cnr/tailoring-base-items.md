# Base items supplied for the crafting recipes

Provenance note: **every resref below was supplied by the user**, not derived
from the repository. Several are base game blueprints absent from
`src/shared/uti`, so their contents cannot be inspected here and **none has been
verified in game**.


Working note. The base objects each recipe family creates, as supplied. This
is the authority for what each recipe creates.

Each entry was given as **name, then tag, then resref**.

---

## Smithing — unified 2026-08-11

One resref per item type, no exceptions:

| Item | ResRef | Recipes | Replaced |
|---|---|---:|---|
| Long sword | **`wswls002`** | 15 | `pb_athgemespa01` — *Espada - Caballero de Mañana*, **Holy Avenger** |
| Large shield | **`ashlw002`** | 23 | `pb_athtemescudo2` (**Armor +3**) and carpentry's `nw_ashlw001` |

Large shields are shared with carpentry: `ashlw002` is the only large-shield
resref in the catalogue.

Equipment carries **no `output_tag`**. The resref decides what is created and
nothing renames its tag afterwards; only alchemy's 65 potion and poison recipes
set one.

---

## Peletería / Sastrería

| Family | Tag (given) | Originally built from | **ResRef (used)** | Profession |
|---|---|---|---|---|
| Ropas | `NW_CLOTH027` | `cloth029` | **`cnr_b_cloth`** | Sastrería |
| Armadura 1/8 | `NW_AARCL009` | `aarcl013` | **`cnr_b_padded`** | Peletería |
| Armadura 2/6 | `NW_AARCL001` | `aarcl004` | **`cnr_b_leather`** | Peletería |
| Armadura 3/5 | `NW_AARCL008` | `aarcl013` | **`cnr_b_studded`** | Peletería |
| Armadura 4/4 | `NW_AARCL012` | `aarcl013` | **`cnr_b_hide`** | Peletería |
| Cintos | `cinturndecuero` | `cinturndecuero` | **`cnr_b_belt`** | Peletería |
| Botas | `botasdecuero` | `botasdecuero` | **`cnr_b_boots`** | Peletería |
| Brazales | `brazalcuero` | `brazalcuero` | **`cnr_b_bracer`** | Sastrería |
| Capa | `capadepiel` | `capadepiel002` | **`cnr_b_cloak`** | Sastrería |
| Guantes para monje | `guantesdecuero` | `guantesdecuero` | **`cnr_b_gloves`** | Peletería |

Every family now builds on the trade's own `cnr_b_*` blueprint; see
[`base-items.md`](base-items.md). The named pieces in the middle column are
module items, not the trade's: `cinturndecuero`, `botasdecuero`, `brazalcuero`,
`capadepiel002` and `guantesdecuero` live in `src/shared/uti/`, where treasure
tables and NPCs use them.

`1/8`, `2/6`, `3/5`, `4/4` read as AC bonus / max dexterity — padded, leather,
studded leather and the next step up.

---

## The recipes use the **resref**, never the tag

`cnr_recipe.base_resref` is what `CreateItemOnObject` takes, and it must be
stated literally so nothing resolves it. On this server the tags are worthless
as identifiers:

| Tag | Distinct blueprints carrying it |
|---|---:|
| `NW_AARCL001` | **27** |
| `NW_AARCL009` | 10 |
| `NW_AARCL008` | 7 |
| `NW_CLOTH027` | 4 |
| `NW_AARCL012` | 1 |

`NW_AARCL001` alone is shared by *Armadura élfica*, *Atuendo de Caerdrath*,
*Armadura - Arquero de Su Majestad* and two dozen more. A recipe resolving that
tag would craft one of them — an arbitrary unique magic item — and every count
would still look right.

This is the trap carpentry already hit: `nw_wbwln001` resolved to *Arco de
Anirin*. Here it is twenty-seven times worse. See
[`schema.md`](schema.md) §3.5.

So every recipe in this split declares `base_resref` in its catalogue JSON,
which the generator uses verbatim.

---

## Decided

- **Guantes para monje → Peletería.**
- **`aarcl013` is used as given** for armours 1/8, 3/5 and 4/4.

`cloth029`, `aarcl013` and `aarcl004` are base game blueprints, not present in
`src/shared/uti`. Recipes state them as literal `base_resref`, exactly as
carpentry does with `nw_wbwln001`.

---

## Sewing templates

A template survives a failed attempt and is consumed by a successful one:
`retain_on_fail` is 1 and `retain_on_success` is 0 on all 100 recipes, in both
`cnrTailorsTable` and `cnrSewingTable`.

| Tag | ResRef | Item |
|---|---|---|
| `cnr_t_pl_armad` | `cnr_t_pl_armad` | Plantilla para armadura — the four armour classes and Ropas |
| `cnr_t_pl_botas` | `cnr_t_pl_botas` | Plantilla para botas |
| `cnr_t_pl_braz` | `cnr_t_pl_braz` | Plantilla para brazales |
| `cnr_t_pl_capa` | `cnr_t_pl_capa` | Plantilla para capa |
| `cnr_t_pl_cinto` | `cnr_t_pl_cinto` | Plantilla para cinto |
| `cnr_t_pl_guantes` | `cnr_t_pl_guantes` | Plantilla para guantes |

The glove template's blueprint is tagged `cnr_t_pl_guantes`, the same as its
resref, while being named "Plantilla para guantes". The ten glove recipes asked
for `sapo_plnt12_guan`, which no blueprint and no placed item carries, and
**components match by tag**, so none of the ten gloves could be made; the
leatherworker's shop offered the same missing tag. The recipes and the shop
entry in `_basefaccione001` were corrected to `cnr_t_pl_guantes`. The blueprint
was left as it is on purpose: renaming its tag would have stranded any template
already in an inventory or on a shelf.
