# Objetos base del CNR

Esta es la lista de la que hay que tirar **siempre** que una receta fabrique un
arma, una armadura, un escudo o munición. Nada de buscar un `nw_*` del juego ni
reutilizar un objeto suelto de la paleta: cada tipo tiene aquí su blueprint, y
es el único que se usa.

Los blueprints viven en `src/cnr/uti/` y están en la paleta custom de objetos,
en la misma sección que el resto del material del CNR.

---

## La lista

| Resref = tag | Qué es | Tipo base | Recetas | Ejemplo |
|---|---|---|--:|---|
| `cnr_b_lsword` | Espada larga | 1 `longsword` | 15 | Espada larga de hierro |
| `cnr_b_club` | Clava | 28 `club` | 8 | Clava de Pino |
| `cnr_b_qstaff` | Bastón | 50 `quarterstaff` | 8 | Bastón de Pino |
| `cnr_b_lshield` | Escudo grande | 56 `largeshield` | 23 | Escudo grande de hierro |
| `cnr_b_sshield` | Escudo pequeño | 14 `smallshield` | 8 | Escudo pequeño de Pino |
| `cnr_b_sbow` | Arco corto | 11 `shortbow` | 8 | Arco corto de Pino |
| `cnr_b_lbow` | Arco largo | 8 `longbow` | 8 | Arco largo de Pino |
| `cnr_b_lxbow` | Ballesta ligera | 7 `lightcrossbow` | 8 | Ballesta ligera de Pino |
| `cnr_b_hxbow` | Ballesta pesada | 6 `heavycrossbow` | 8 | Ballesta pesada de Pino |
| `cnr_b_arrow` | Flechas | 20 `arrow` | 7 | Flechas de Pino |
| `cnr_b_bolt` | Virotes | 25 `bolt` | 7 | Virotes de Pino |
| `cnr_b_bullet` | Balas | 27 `bullet` | 15 | Bala de hierro |
| `cnr_b_cloth` | Ropa | 16 `armor`, **CA 0** | 10 | Ropa de cuero de roedor |
| `cnr_b_padded` | Armadura acolchada | 16 `armor`, **CA 1** | 10 | Armadura acolchada de cuero de roedor |
| `cnr_b_leather` | Armadura de cuero | 16 `armor`, **CA 2** | 10 | Armadura de cuero de roedor |
| `cnr_b_studded` | Armadura intermedia | 16 `armor`, **CA 3** | 10 | Armadura intermedia de cuero de roedor |
| `cnr_b_hide` | Armadura reforzada | 16 `armor`, **CA 4** | 10 | Armadura reforzada de cuero de roedor |

Ésos fueron los diecisiete primeros, los que sustituyeron a un blueprint del
juego en 173 recetas. Los de arma ya no se nombran desde la receta sino desde
la lista de variantes, que es lo que explica la sección siguiente.

Los cinco de armadura salen del mismo modelo y sólo se diferencian en la pieza
del torso, que es de donde sale la CA (`parts_chest.2da`, columna `ACBONUS`):

| Blueprint | `ArmorPart_Torso` | CA |
|---|--:|--:|
| `cnr_b_cloth` | 1 | 0 |
| `cnr_b_padded` | 20 | 1 |
| `cnr_b_leather` | 10 | 2 |
| `cnr_b_studded` | 22 | 3 |
| `cnr_b_hide` | 4 | 4 |

**Todos van sin propiedades y sin nombre propio.** El nombre lo pone la receta
y las propiedades salen de `cnr_recipe_property`. Un blueprint base con algo
encima regala ese algo a todas las recetas que lo usen.

### The ten types the first sweep did not see — 2026-08-23

That sweep looked for recipes naming a blueprint **of the game's**, because
those were the ones failing. **Ten item types** named blueprints of **PDB's
own** -- clean, with the right base item -- so they tripped nothing and were
left out: the scale mail, the full plate, the pavise, the small shield and the
helmet of smithing, and the gloves, boots, belt, bracers and cloak of
leatherworking and tailoring. **Nine new blueprints** cover them, because the
small shield already had a canonical base in `cnr_b_sshield`.

They were not broken, but they shared their identity with the rest of the
module. A crafted accessory carries no `output_tag`, so it inherited the
blueprint's, and those tags live outside the trade: `guantesdecuero` is handed
out by the treasure scripts (`pb_tesoros_inc.nss`, `pb_tesoro_ccweap.nss`) and
`capadepiel` is worn by four NPCs. Editing that blueprint for the trade changed
what dropped as loot.

There are now `cnr_b_scale`, `cnr_b_plate`, `cnr_b_tshield`,
`cnr_b_helmet`, `cnr_b_gloves`, `cnr_b_boots`, `cnr_b_belt`,
`cnr_b_bracer` and `cnr_b_cloak`, and the small shield uses the
`cnr_b_sshield` that already existed. Eight of the nine are copies field for
field: only the name and the tag change. The small shield is the exception and
does change model, for the reason given further down. 140 recipes repointed
without moving a single `public_id` or a single `output_tag`.

### The sweep, trade by trade — 2026-08-23

Once the ten types were closed, all 513 recipes and all 51 variants were crossed
against the base item of the blueprint each one names:

| Trade | Result |
|---|---|
| Smithing (anvil and forge) | Every piece of equipment on `cnr_b_*`. The fifteen ingots are the forge's own product |
| Leatherworking (tub and table) | The five armours and the three accessories on `cnr_b_*`. The ten leathers are its own product |
| Tailoring | Clothing, bracers and cloak on `cnr_b_*` |
| Carpentry (saw and bench) | Weapons and shields on `cnr_b_*`; the eight planks are its own product. `cnr_bastonroble` is base item 45 `magicstaff`, not 50 `quarterstaff`: it is the staff arcane enchants, not a variant |
| Alchemy (table and cauldron) | Potions and poisons share a blueprint on purpose, and the essences are their own product |
| Jewellery | One blueprint per gem and per metal, each with its own look. None shared |

**No recipe uses a different blueprint while a `cnr_base_` of that type
exists.** All 51 variants point at a `cnr_b_*` that is on disk, and no two
variants share a base item type.

One thing noted and left alone:

- **The ingots and the planks are split between base items 29 `miscmedium` and
  307 `miscmedium2`.** Both occupy 2x2 and stack to 10, so the difference is the
  icon family and nothing else.

The generator also checks that every `cnr_b_*` on disk is in
`itempalcus.itp` and the other way round, because the palette is the step that
breaks nothing when forgotten: the recipes keep working and the builder simply
cannot find the blueprint.

---

## Cómo se fabrica un arma: una receta por material

El oficio no tiene una receta por arma. Tiene **una por material**, y el jugador
elige qué arma quiere con ese material:

| Oficio | Recetas | Variantes | Combinaciones |
|---|--:|--:|--:|
| Herrería, armas | 15 metales | 49 | 735 |
| Carpintería, armas de mano | 8 maderas | 2 | 16 |

**The whip is a smith's weapon, not a leather garment.** It had ten recipes of
its own on `cnrTailorsTable` and every one of them came out plain: leather
properties are looked up by garment type, and a whip is not a garment. On
2026-08-23 it became the forty-ninth variant of `smith_weapon`, so it takes an
ingot, a mould and the metal's properties like any other weapon. Peleteria drops
to 70 recipes.

**Qué no es variante de carpintería, y por qué.** El bastón se quitó del grupo
el 2026-08-18: tiene sus nueve recetas propias y **no es la misma receta** —
lleva dos tablones y aros, mientras que la clava lleva dos tablones y mango—,
así que ofrecerlo como variante lo fabricaba por dos vías distintas con los
componentes de la otra. Lo reportaron los testers comparando las recetas 2055 y
2063. Las hondas salieron del oficio entero por decisión de diseño.

La razón es que entre "Daga de acero" y "Maza de acero" no cambia nada: mismo
lingote, mismo molde, mismo nivel, dificultad, experiencia, oro y **las mismas
propiedades**, porque las da el metal. Escribirlo como 705 filas era escribir
quince recetas setecientas cinco veces.

En el menú: eliges la categoría, eliges el metal, y entonces el oficio pregunta
qué fabricar. Con las recetas de producto fijo —armaduras, escudos, munición,
joyería— esa pantalla no aparece y todo sigue como estaba.

**El daño opuesto es lo único que depende del arma, y sale del código.** Los
metales que dan daño físico usan la propiedad `DamageBonusOpposite`, y
`CnrProp_GetOppositeDamage` mira el arma cuando la crea:

| Arma | Daño que ya hace | Daño que recibe |
|---|---|---|
| Espada larga, cimitarra… | cortante | contundente |
| Maza, martillo, mazo… | contundente | perforante |
| Estoque, lanza… | perforante | cortante |
| Espada corta, alabarda… | perforante **y** cortante | contundente |
| Maza terrible… | contundente **y** perforante | cortante |

Las dos últimas filas son la corrección del 2026-08-17: once armas del servidor
hacen dos tipos de daño, y el código se quedaba con el primero que declara el
2DA, así que a una espada corta le añadía cortante, que ya tenía. Ahora recibe
**el tercero**, el que le falta.

### Ammunition, and the subtype that silently does nothing — 2026-08-20

Two corrections from the same report, both on recipes whose design clause reads
"Daño Físico".

**"Físico" does not name a damage type.** The engine only understands a concrete
one; the design word means the physical type the weapon does not already deal,
which is precisely what `DamageBonusOpposite` resolves at craft time. The seed
and the generator translated it instead into `DamageBonus` with subtype 4, the
`Fisico` row of `iprp_damagetype.2da`. That row carries **no cost**, here and in
the base game, so the property came out invalid and `AddItemProperty` discarded
it without a word: the weapon reached the player with its enhancement bonus
alone and the ammunition with nothing at all.

Fifteen recipes were corrected — seven smithing rows in
`migration/legacy-catalogue-seed.sql` and eight carpentry ones, which arrived
through `CARP_DANO['fisico']` in `build_catalogue.py`. The generated catalogue
now holds sixteen `DamageBonusOpposite` rows: those fifteen plus the adamantite
weapon, which had been written correctly from the start and is what proved the
property works.

`'fisico'` is no longer a key in `CARP_DANO`, so it cannot be mapped to a number
again. The only valid translation is `DamageBonusOpposite`.

**Ammunition carries no `WeaponType`.** The 2da leaves the column at 0 for
arrows, bolts and bullets, because what they strike with belongs to the
launcher, so the opposite could not be resolved and the five ammunition recipes
would still have received nothing. `CnrProp_GetOppositeDamage` now falls back to
the base item and applies the same rotation:

| Ammunition | Deals | Receives |
|---|---|---|
| Arrow, bolt | piercing | slashing |
| Bullet | bludgeoning | piercing |

For reference, rows 15 to 18 of the 2da — `Fisico`, `Fuerza`, `Veneno`,
`Psiquico` — are the ones this server added and they do carry a cost. The last
three have their constant in `pb_constantes.nss` and the loot generator uses
them. Row 15 was left without a name and without a constant, and nothing uses
it.

Los látigos siguen siendo diez recetas propias porque son una sola arma, y salen
sin propiedades: las de peletería se buscan por tipo de prenda y un látigo no es
una.

**Pendiente**: todas las armas de herrería usan `molde_esplarga`, el molde que
se vende en `tienda_herreria`. Funciona, pero un molde por familia —espadas,
hachas, contundentes, astas— sería lo suyo.

---

## The light tier-4 pieces: why a metal forges two armours

The design CSV gives the three tier-4 metals -- metal vivo, mithril and
adamantita -- **"4 o 5 CA"** with the *same* second property. Only the 5 AC
piece had ever been written, so half of that design row could not be crafted.
On 2026-08-23 the eighteen missing recipes were added: scale mail, full plate,
small shield, large shield, pavise and helmet, for each of the three metals.

The light piece is **not a variant**: it is a recipe of its own, because what it
costs and what it grants both change. It takes one ingot less and grants 4 AC
instead of 5, keeping the metal's second property -- regeneration 1, the spell
failure reduction, or the matching damage resistance. Its name adds
"ligera"/"ligero" to the name of the ordinary piece.

Its properties come from three new `material_properties` item types --
`Armadura CA4`, `Escudo CA4` and `Casco CA4` -- rather than from the existing
ones. Reusing `Armadura` would have moved the 5 AC piece as well, since the key
is `(material, type, gem)`.

At the same time, and from the same table, **the 5 AC pieces of tier 4 went up
by one ingot**, and the weapons and ammunition of those three metals went from
one to two. The light piece costs what the ordinary one cost before that rise.

| Metal | Second property | Armour | Shield | Helmet |
|---|---|---|---|---|
| Metal vivo | Regeneration 1 | yes | yes | yes |
| Mithril | -30% / -25% arcane spell failure | yes | yes | 15% slashing¹ |
| Adamantita | 20% slashing / bludgeoning / piercing | yes | yes | yes |

¹ The helmet cannot carry spell failure reduction: `itemprops.2da` row 84 leaves
column `7_Helm` empty and the engine discards the property. It carries 15%
slashing resistance instead, exactly like its 5 AC counterpart.

**Smithing armour got its own base blueprints in the same change.** Until
2026-08-23 the scale mail, the full plate, the pavise, the small shield and the
helmet were built from `pb_carestarmor05`, `pb_armllanoaven1`,
`pb_athgemescud01`, `pb_cammolescudo2` and `mil_clothing669` -- named pieces
that carry the stock tag, so they won the lookup by tag before `CNR_BASE_ITEMS`
could map the stock resref. Ninety recipes now point at `cnr_b_scale`,
`cnr_b_plate`, `cnr_b_tshield`, `cnr_b_sshield` and `cnr_b_helmet`
instead.

Four of the five are copies, field for field: `cnr_b_scale`,
`cnr_b_plate`, `cnr_b_tshield` and `cnr_b_helmet` carry every
`ArmorPart_*` and every `ModelPart*` of the blueprint they replace, so no model
and no base armour class moves. Only `PaletteID` differs, and that is toolset
classification.

**The small shield is the exception, and it does change model.**
`pb_cammolescudo2` was `ModelPart1` 88; `cnr_b_sshield`, which already
existed and which carpentry's eight small shields already used, is `ModelPart1`
11. Making a second small-shield base to keep model 88 would have given the
trade two blueprints for one type, which is the thing this whole change exists
to stop, and the eight carpentry shields would still have looked different from
the eighteen smithing ones. One base per type wins; the appearance is the
mannequin's business afterwards. **The commit message of `12d98dd0f` says no
appearance value changed. That is wrong, and this paragraph is the correction.**

## Catálogo completo: los 75 objetos base

Todo tipo de objeto que el CNR fabrica más de una vez. La última columna dice
cómo se llega a él: con recetas propias, o como **variante** de un grupo — un
producto que el jugador elige después de escoger el material.

**This table is no longer a promise, it is a consequence.** Between 17 and 23
August it said «todo lo que el CNR puede fabricar» and that was false: ten types
were missing. `build_catalogue.py` now refuses to generate the catalogue when a
blueprint is the base of **more than one** recipe and is not the trade's own,
and when **any variant** names one, since a group's product is offered by every
material recipe in that group. So the list cannot fall short again without the
build failing. Consumables -- potions and grenades, base items 49 and 81 -- are
exempt on purpose: they share a handful of blueprints and differ only in name
and effect.

Cada uno se copió del blueprint que **este servidor** usa para ese tipo, no del
vanilla, porque muchas de estas armas son propias de PDB o vienen del CEP. La
copia se queda sin propiedades, sin descripción y con `tag` = `resref`. Los que
no dicen de dónde vienen son los diecisiete originales.

**Las modificaciones de armas de PDB no están en el blueprint, están en
`baseitems.2da`**: dados, crítico, tamaño, competencia y las marcas de arma de
monje o de Sutileza. Copiar el blueprint del tipo correcto ya hereda todo eso,
y por eso lo único que hay que acertar es el tipo base.

| Arma | Resref del CNR | Tipo base | Copiado de | Cómo se fabrica |
|---|---|---|---|---|
| Alabarda | `cnr_b_halberd` | 10 `halberd` | `halberd` | variante de `smith_weapon` |
| Alfanje | `cnr_b_falchn` | 305 `falchion` | `alfanje` | variante de `smith_weapon` |
| Arco corto | `cnr_b_sbow` | 11 `shortbow` | — | 8 recetas |
| Arco largo | `cnr_b_lbow` | 8 `longbow` | — | 8 recetas |
| Armadura acolchada | `cnr_b_padded` | 16 `armor` | — | 10 recetas |
| Armadura completa | `cnr_b_plate` | 16 `armor` | `pb_armllanoaven1` | 18 recetas |
| Armadura de cuero | `cnr_b_leather` | 16 `armor` | — | 10 recetas |
| Armadura intermedia | `cnr_b_studded` | 16 `armor` | — | 10 recetas |
| Armadura reforzada | `cnr_b_hide` | 16 `armor` | — | 10 recetas |
| Balas | `cnr_b_bullet` | 27 `bullet` | — | 15 recetas |
| Ballesta ligera | `cnr_b_lxbow` | 7 `lightcrossbow` | — | 8 recetas |
| Ballesta pesada | `cnr_b_hxbow` | 6 `heavycrossbow` | — | 8 recetas |
| Baston | `cnr_b_qstaff` | 50 `quarterstaff` | — | variante de `wood_weapon` |
| Botas | `cnr_b_boots` | 26 `boots` | `botasdecuero` | 10 recetas |
| Brazales | `cnr_b_bracer` | 78 `bracer` | `brazalcuero` | 10 recetas |
| Capa | `cnr_b_cloak` | 80 `cloak` | `capadepiel002` | 10 recetas |
| Cimitarra | `cnr_b_scim` | 53 `scimitar` | `cimitarra` | variante de `smith_weapon` |
| Cimitarra doble | `cnr_b_dscim` | 321 `scimitar_double` | `cimitarradoble` | variante de `smith_weapon` |
| Cinturon | `cnr_b_belt` | 361 `belt` | `cinturndecuero` | 10 recetas |
| Clava | `cnr_b_club` | 28 `club` | — | variante de `wood_weapon` |
| Cota de escamas | `cnr_b_scale` | 16 `armor` | `pb_carestarmor05` | 18 recetas |
| Daga | `cnr_b_dagger` | 22 `dagger` | `daga` | variante de `smith_weapon` |
| Daga de asesino | `cnr_b_adagger` | 309 `daggerassn` | `zep_assassind003` | variante de `smith_weapon` |
| Daga de hechiceria | `cnr_b_sdagger` | 514 `SorcererDagger` | `item_dagahechi` | variante de `smith_weapon` |
| Dardo | `cnr_b_dart` | 31 `dart` | `dardo` | variante de `smith_weapon` |
| Escudo grande | `cnr_b_lshield` | 56 `largeshield` | — | 23 recetas |
| Escudo pequeno | `cnr_b_sshield` | 14 `smallshield` | — | 8 recetas |
| Espada bastarda | `cnr_b_bsword` | 3 `bastardsword` | `espadabastarda` | variante de `smith_weapon` |
| Espada corta | `cnr_b_ssword` | 0 `shortsword` | `espadacorta` | variante de `smith_weapon` |
| Espada de doble hoja | `cnr_b_2bsword` | 12 `twobladedsword` | `espadadedoblehoj` | variante de `smith_weapon` |
| Espada de dos hojas maug | `cnr_b_maugsw` | 324 `maugdoublesword` | `espadadedoshojas` | variante de `smith_weapon` |
| Espada larga | `cnr_b_lsword` | 1 `longsword` | — | variante de `smith_weapon` |
| Espadon | `cnr_b_gsword` | 13 `greatsword` | `zep_wpngsw_001` | variante de `smith_weapon` |
| Espadon enorme | `cnr_b_hgsword` | 511 `Hgreatsword` | `item_espadonen` | variante de `smith_weapon` |
| Estoque | `cnr_b_rapier` | 51 `rapier` | `pb_murnorespa03` | variante de `smith_weapon` |
| Flechas | `cnr_b_arrow` | 20 `arrow` | — | 7 recetas |
| Gran hacha | `cnr_b_gaxe` | 18 `greataxe` | `granhacha` | variante de `smith_weapon` |
| Guadana | `cnr_b_scythe` | 55 `scythe` | `scyte` | variante de `smith_weapon` |
| Guantes | `cnr_b_gloves` | 36 `gloves` | `guantesdecuero` | 10 recetas |
| Hacha arrojadiza | `cnr_b_taxe` | 63 `throwingaxe` | `hachaarrojadiza` | variante de `smith_weapon` |
| Hacha de batalla | `cnr_b_baxe` | 2 `battleaxe` | `hachadebatalla` | variante de `smith_weapon` |
| Hacha de guerra enana | `cnr_b_dwaxe` | 108 `dwarvenwaraxe` | `hachadeguerraena` | variante de `smith_weapon` |
| Hacha de mano | `cnr_b_haxe` | 38 `handaxe` | `hachademano` | variante de `smith_weapon` |
| Hacha doble | `cnr_b_daxe` | 33 `doubleaxe` | `hachadoble` | variante de `smith_weapon` |
| Hacha enorme | `cnr_b_hgaxe` | 512 `Hgreataxe` | `item_ghachaen` | variante de `smith_weapon` |
| Hoz | `cnr_b_sickle` | 60 `sickle` | `pb_inmhoz01` | variante de `smith_weapon` |
| Kama | `cnr_b_kama` | 40 `kama` | `kama` | variante de `smith_weapon` |
| Katana | `cnr_b_katana` | 41 `katana` | `katana` | variante de `smith_weapon` |
| Katar | `cnr_b_katar` | 310 `katar` | `zep_katar` | variante de `smith_weapon` |
| Kukri | `cnr_b_kukri` | 42 `kukri` | `kukri` | variante de `smith_weapon` |
| Lanza corta | `cnr_b_sspear` | 210 `shortspear` | `item_lanzacorta` | variante de `smith_weapon` |
| Lanza de guerra | `cnr_b_wspear` | 58 `warspear` | `lanza` | variante de `smith_weapon` |
| Lanza larga | `cnr_b_lspear` | 513 `Longspear` | `item_lanzaen` | variante de `smith_weapon` |
| Latigo | `cnr_b_whip` | 111 `Whip` | `whip` | variante de `smith_weapon` |
| Mangual ligero | `cnr_b_lflail` | 4 `lightflail` | `mangualligero` | variante de `smith_weapon` |
| Mangual pesado | `cnr_b_hflail` | 35 `heavyflail` | `heavyflail` | variante de `smith_weapon` |
| Martillo de guerra | `cnr_b_whammer` | 5 `warhammer` | `martillodeguerra` | variante de `smith_weapon` |
| Martillo ligero | `cnr_b_lhammer` | 37 `lighthammer` | `martilloligero` | variante de `smith_weapon` |
| Maza | `cnr_b_lmace` | 9 `lightmace` | `maza` | variante de `smith_weapon` |
| Maza de armas | `cnr_b_mstar` | 47 `morningstar` | `hen_maza_trasgo` | variante de `smith_weapon` |
| Maza pesada | `cnr_b_hmace` | 317 `heavy_mace` | `mazapesada` | variante de `smith_weapon` |
| Maza terrible | `cnr_b_dmace` | 32 `diremace` | `mazagrande` | variante de `smith_weapon` |
| Mazo | `cnr_b_maul` | 318 `maul` | `mazo` | variante de `smith_weapon` |
| Mazo enorme | `cnr_b_hmaul` | 510 `Hmaul` | `item_mazoen` | variante de `smith_weapon` |
| Nunchaku | `cnr_b_nunchak` | 304 `nunchaku` | `zep_nunchaku` | variante de `wood_weapon` |
| Paves | `cnr_b_tshield` | 57 `towershield` | `pb_athgemescud01` | 18 recetas |
| Pico ligero | `cnr_b_lpick` | 302 `lightpick` | `zep_lightpick` | variante de `smith_weapon` |
| Pico pesado | `cnr_b_hpick` | 301 `heavypick` | `picopesao` | variante de `smith_weapon` |
| Ropa | `cnr_b_cloth` | 16 `armor` | — | 10 recetas |
| Rueda de fuego y viento | `cnr_b_wfwheel` | 323 `windfirewheel` | `zep_windfire` | variante de `smith_weapon` |
| Sai | `cnr_b_sai` | 303 `sai` | `zep_jitte` | variante de `smith_weapon` |
| Shuriken | `cnr_b_shurik` | 59 `shuriken` | `nw_wthmsh002` | variante de `smith_weapon` |
| Tridente | `cnr_b_trident` | 95 `trident` | `tridente` | variante de `smith_weapon` |
| Tridente ligero | `cnr_b_trid1h` | 300 `trident_1h` | `item_tridentecep` | variante de `smith_weapon` |
| Virotes | `cnr_b_bolt` | 25 `bolt` | — | 7 recetas |
| Yelmo | `cnr_b_helmet` | 17 `helmet` | `mil_clothing669` | 18 recetas |

Notas de la tanda que trajo los cincuenta nuevos:

- **Los tres tipos vacíos del generador ya tienen blueprint.** Los `case` 17
  (doble-hacha), 25 (manguales ligeros) y 29 (mazas ligeras y pesadas) están
  declarados en `IniciarObjetoCreado` y **no sueltan nada**. Se han creado
  igualmente, porque el oficio sí las fabrica aunque el botín no las dé.
- **El nombre del `case` no siempre dice la verdad.** El 15, "SAI", suelta una
  cimitarra doble (tipo 321); el 3, "Dagas", una daga de hechicero (514). Por
  eso los blueprints se eligieron por **tipo base** y no por el nombre del case.
- **Sólo el shuriken no existía en el módulo**: se sacó del juego
  (`nw_wthmsh002`) y se limpió.
- Las lanzas son tres tipos distintos: corta (210), larga (513) y de guerra
  (58, la que PDB renombró desde la lanza sencilla).
- Las tres armas enormes de PDB —mazo, espadón y hacha, 3d6— tienen tipo propio
  (510, 511, 512) y su blueprint.
- **La daga de hechicería entró al oficio el 2026-08-27, revirtiendo la
  decisión del 2026-08-17.** `item_dagahechi`, base 514 `SorcererDagger`, se
  había dejado fuera por ser un foco de conjuros y no un arma: mismo 1d4 que una
  daga, pero amenaza sólo con 20 y no se lleva en la mano izquierda. Lo que
  cambió no es el objeto sino para qué sirve. La mesa arcana sólo admite lo que
  un oficio ha fabricado —`CnrArc_IsEnchantable` exige la marca `CNR_OFICIO`, que
  `cnr_i_craft` estampa al craftear y nada más lo hace—, así que mientras la daga
  fuese sólo botín ningún mago podía encantarla, y la 514 es precisamente lo que
  libera al lanzador de ir con bastón. `cnr_b_sdagger` es su blueprint propio,
  limpio de propiedades, y entra como variante de `smith_weapon`: la de cobre
  sale sin propiedades, como el bastón de roble del carpintero, y las de metal
  salen con las dos del metal, que dejan sitio de sobra bajo el tope de ocho.

---

## Cómo se aplica

`migration/build_catalogue.py` tiene el diccionario `CNR_BASE_ITEMS`, que
traduce un blueprint del juego al nuestro, y lo aplica en el punto por el que
pasan **todas** las rutas que nombran un blueprint: la receta escrita a mano en
`migration/catalogue/*.json`, el `literal_resref`, y la fila de metadatos
heredada de `legacy-catalogue-seed.sql`. Ninguna vía puede colar un blueprint
del juego sin querer.

Aviso para quien lo edite: el mapa compara en minúsculas y **no** con
`normalize()`, que se come el guión bajo de `nw_wambu001` y no casaría nunca.

## Añadir un tipo nuevo

1. Sacar el blueprint del juego con `nwn_resman_extract -p <resref>`.
2. Pasarlo a JSON con `nwn_gff`, dejarlo sin propiedades, con
   `Tag = TemplateResRef = cnr_base_<tipo>` y su nombre en castellano.
3. Guardarlo en `src/cnr/uti/cnr_base_<tipo>.uti.json`.
4. Añadirlo a la paleta custom de objetos, junto al resto del CNR.
5. Añadir la línea a `CNR_BASE_ITEMS` y regenerar con `build_catalogue.py`.
6. Añadirlo a la tabla de arriba.

---

## Por qué existe este documento

Tres fallos distintos, todos de lo mismo, todos encontrados en juego o
midiendo:

1. **Las espadas y los escudos no se podían fabricar.** 15 recetas apuntaban a
   `wswls002` y 23 a `ashlw002`, que no existen en ninguna parte. La tirada
   salía bien, se cobraba el material y el oro, y saltaba *"Error al crear el
   objeto"*.
2. **La armadura de cuero daba CA 5.** `nw_aarcl004` lleva el torso 32, que es
   cota de mallas. Se llamaba armadura de cuero y protegía como una cota.
3. **Treinta recetas de armadura fabricaban una capa mágica.** `nw_aarcl013` no
   es una armadura: es una capa (tipo 80) **con siete propiedades encima**.
   Acolchada, intermedia y reforzada compartían ese blueprint, así que las tres
   salían encantadas de fábrica y ninguna daba CA de armadura.

Los tres se arreglan solos si la regla se respeta: **el objeto base sale de esta
lista, y de ningún otro sitio**.
