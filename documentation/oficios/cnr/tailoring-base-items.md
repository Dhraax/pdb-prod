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

| Family | Tag (given) | **ResRef (used)** | Profession |
|---|---|---|---|
| Ropas | `NW_CLOTH027` | **`cloth029`** | Sastrería |
| Armadura 1/8 | `NW_AARCL009` | **`aarcl013`** | Peletería |
| Armadura 2/6 | `NW_AARCL001` | **`aarcl004`** | Peletería |
| Armadura 3/5 | `NW_AARCL008` | **`aarcl013`** | Peletería |
| Armadura 4/4 | `NW_AARCL012` | **`aarcl013`** | Peletería |
| Cintos | `cinturndecuero` | **`cinturndecuero`** | Peletería |
| Botas | `botasdecuero` | **`botasdecuero`** | Peletería |
| Brazales | `brazalcuero` | **`brazalcuero`** | Sastrería |
| Capa | `capadepiel` | **`capadepiel002`** | Sastrería |
| Guantes para monje | `guantesdecuero` | **`guantesdecuero`** | Peletería |

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

Not consumed: `retain_on_fail` and `retain_on_success` are both 1 on all 100
recipes.

| Tag | ResRef | Item |
|---|---|---|
| `sapo_plnt12_armd` | `sapo_plnt12_armd` | Plantilla para armadura — the four armour classes and Ropas |
| `sapo_plnt12_bota` | `sapo_plnt12_bota` | Plantilla para botas |
| `sapo_plnt12_bra` | `sapo_plnt12_bra` | Plantilla para brazales |
| `sapo_plnt12_capa` | `sapo_plnt12_capa` | Plantilla para capa |
| `sapo_plnt12_cint` | `sapo_plnt12_cint` | Plantilla para cinto |
| **`sapo_plnt12_guan`** | `sapo_plnt12_capu` | Plantilla para guantes |

The glove template's blueprint was tagged `sapo_plnt12_capu` while being named
"Plantilla para guantes". **Components match by tag**, so a template made from
that blueprint would never have satisfied the ten glove recipes — and station
tools are enforced, so this was not cosmetic. The tag was corrected to
`sapo_plnt12_guan`, matching both its own name and the instance already placed
in `_basefaccione001`. Its resref and file name are unchanged, and nothing else
referenced the old tag.
