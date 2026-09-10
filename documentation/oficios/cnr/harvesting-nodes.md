# Nodos de recolección

Inventario de los ubicados de recolección que ya están puestos en el mapa de
oficios, para no tener que revisarlos uno a uno.

**El sistema será nuevo.** Aquí sólo se recoge qué había: qué ubicados hay, qué
se puede identificar de ellos y qué queda por asignar. Los números que llevan
encima (`DIFICULTAD`, `USOS*`) son del sistema viejo y se documentan como dato
heredado, no como regla.

Peletería queda fuera: sacar pieles se resuelve aparte.

---

## Resumen

| Familia | Ubicados | Qué soltaba |
|---|--:|---|
| Árboles `carp_at1..8` | 8 | los ocho leños |
| Vetas de metal `sute_met_*` | 15 | catorce metales y el carbón |
| Vetas de gema `veta_*` | 8 | las 28 gemas en bruto |
| Plantas `sute_her_p*` | 13 (8 tipos) | las ocho hierbas |
| Canteras `ko_cantera_*` | 2 | otro sistema, ya funciona |

**Todo recuperado del historial.** Los cuatro scripts se borraron en
`dc42be810` y están enteros en `dc42be810^`.

Los 49 ubicados están **todos en `testarea_oficios`**: ninguna otra área del
módulo tiene nodos de estos.

### Aviso antes de replicar desde la paleta

Una instancia colocada **no es una referencia al blueprint**: el `.git` guarda
una copia entera de todo —scripts, variables, apariencia, vida— y sólo conserva
el `TemplateResRef` para saber de dónde salió. Por eso:

- Cambiar el `.utp` **no toca nada** de lo que ya está puesto en el mapa.
- "Replicar a las instancias" empareja por **resref**, no por tag. Cambiar el
  tag del blueprint no rompe el vínculo; cambiar el **resref** sí, y deja
  huérfanas las instancias viejas.
- Al replicar, la instancia **pierde lo que tuviera distinto** del blueprint.

Y aquí eso importa, porque **41 de las 49 instancias difieren del suyo**:

| Diferencia | Dónde |
|---|---|
| `OnMeleeAttacked` = `minero` | las 15 vetas de mineral, con el blueprint vacío |
| `OnMeleeAttacked` = `minerogemas` | las 8 vetas de gema, con el blueprint vacío |
| `OnDeath` = `recolector2` además del `OnMeleeAttacked` | las 18 plantas |

O sea que **las vetas sí tenían script y funcionaban**: lo llevaban en la
instancia, no en el blueprint. Replicar desde la paleta tal como está hoy las
dejaría mudas.

Lo sano al montar el sistema nuevo: poner los scripts y las variables **en el
blueprint**, replicar una vez a las instancias, y a partir de ahí mantener sólo
el blueprint.

---

## Qué daba cada nodo

**Recuperado de los scripts borrados**, que siguen en el historial: el commit
`dc42be810` los eliminó y `dc42be810^` los conserva enteros.

| Script | Qué llevaba |
|---|---|
| `src/shared/nss/recolector.nss` | las plantas, por `TIPOPLANTA` |
| `src/shared/nss/carp_lenyador.nss` | los árboles, por `TIPOARBOL` |
| `src/shared/nss/minero.nss` | las vetas de metal, por `TIPOPIEDRA` |
| `src/shared/nss/minerogemas.nss` | las vetas de gema, por `TIPOPIEDRA` |

Ya no hace falta deducir nada: el tipo que lleva cada ubicado en su `VarTable`
es el índice, y estas son las tablas tal como estaban escritas.

### Árboles — carpintería

| Ubicado | `TIPOARBOL` | Soltaba | Tablón que sale de él | Madera del oficio |
|---|--:|---|---|---|
| `carp_at1` | 1 | `carplenyo_pino` | `carptablon_pino` | Pino |
| `carp_at2` | 2 | `carplenyo_cipres` | `carptablon_cipre` | Cedro |
| `carp_at3` | 3 | `carplenyo_abeto` | `carptablon_abeto` | Abeto |
| `carp_at4` | 4 | `carplenyo_cedro` | `carptablon_cedro` | Roble |
| `carp_at5` | 5 | `carplenyo_alamo` | `carptablon_alamo` | Sombralto |
| `carp_at6` | 6 | `carplenyo_olmo` | `carptablon_olmo` | Leñocaso |
| `carp_at7` | 7 | `carplenyo_roble` | `carptablon_roble` | Zalantar |
| `carp_at8` | 8 | `carplenyo_fresno` | `carptablon_fresn` | Maderadique |

Los ocho, completos. El nombre interno del leño y el de la madera del oficio no
coinciden —el leño de ciprés es la madera "Cedro", el de cedro es "Roble"— pero
la cadena leño → tablón → receta encaja sin huecos, y el tablón es el que ya
usan las recetas de carpintería.

### Vetas de metal — herrería

| Ubicado | `TIPOPIEDRA` | Soltaba |
|---|--:|---|
| `sute_met_m01` | 1 | `pepitaHierro` |
| `sute_met_m02` | 2 | `pepitaCobre` |
| — falta el nodo — | 3 | `pepitaAcero` |
| `sute_met_m04` | 4 | `pepitaPlata` |
| `sute_met_m05` | 5 | `pepitaHierrofrio` |
| `sute_met_m06` | 6 | `pepitaOro` |
| `sute_met_m07` | 7 | `pepitaMithril` |
| `sute_met_m08` | 8 | `pepitaAdamantita` |
| `sute_met_m20` | 10 | `pepitaDlarun` |
| `sute_met_m021` | 11 | `pepitaHizagkuur` |
| `sute_met_m024` | 12 | `pepitaAceroscuro` |
| `sute_met_m023` | 13 | `pepitaPlatino` |
| `sute_met_m025` | 14 | `pepitaArandur` |
| `sute_met_m026` | 15 | `pepitaMetalvivo` |
| `sute_met_m027` | 16 | `pepitaCarbon` |
| `sute_met_m022` | 17 | `pepitaDerretido` |

Los quince ubicados que hay cubren quince entradas. **Falta el tipo 3, el
acero**: no hay nodo en el mapa. Y el tipo 16 es carbón, que no es un metal del
catálogo sino un componente de la fragua, así que de metales hay catorce.

El tipo 9 no aparece en el mapa y en el script comparte salida con el 10.

Las tres pistas que daban los modelos eran correctas y el orden de dificultad
era engañoso: el cristal de hielo de `m05` es **hierrofrío**, la roca de la
Antípoda Oscura de `m024` es **aceroscuro** y el coral de `m026` es **metal
vivo**.

### Vetas de gema — joyería

Cada veta da varias, elegida al azar entre las suyas:

| Ubicado | `TIPOPIEDRA` | Soltaba |
|---|--:|---|
| `veta_meta` | 1 | `bru_cuarzo`, `bru_obs`, `bru_aza`, `bru_per`, `bru_cor` |
| `veta_berilo` | 2 | `bru_per`, `bru_top`, `bru_esme` |
| `veta_opalos` | 3 | `bru_opalo`, `bru_opaloa`, `bru_opalof`, `bru_opalon` |
| `veta_cristal` | 4 | `bru_lagrimar`, `bru_orblen`, `bru_orlo`, `bru_zen` |
| `veta_maravillosa` | 5 | `bru_bel`, `bru_orblen`, `bru_lagrey`, `bru_picara` |
| `veta_costera` | 6 | `bru_jade`, `bru_amar`, `bru_barra` |
| `veta_corindon` | 7 | `bru_zaf`, `bru_rubi`, `bru_jac`, `bru_zafnegro`, `bru_zafestre`, `bru_rubiestre` |
| `veta_diamante` | 8 | `bru_diam` |

Son 28 salidas para 28 gemas del oficio, con `bru_per` y `bru_orblen` en dos
vetas cada una.

### Plantas — herboristería

| Ubicado | `TIPOPLANTA` | Soltaba | Nombre en juego | Condición |
|---|--:|---|---|---|
| `sute_her_p01`, `_1` | 1 | `bayaAcuosa` | Baya Acuosa | |
| `sute_her_p02`, `_2` | 2 | `brisaSusurrante` | Brisa Susurrante | |
| `sute_her_p03`, `_3` | 3 | `resinaSubterranea` | Resina Subterránea | |
| `sute_her_p04`, `_4` | 4 | `ardorDesertico` | Ardor Desértico | |
| `sute_her_p05` | 5 | `raizPetrea` | Raíz Pétrea | |
| `sute_her_p06`, `_6` | 6 | `florLuminosa` | Flor Luminosa | **sólo de día** |
| `sute_her_p07` | 7 | `setaNocturna` | Seta Nocturna | **sólo de noche** |
| `sute_her_p08` | 8 | `frutoFantasma` | Fruto Fantasma | **hay que ver invisible** |

Las ocho, completas, y con las tres condiciones especiales que llevaban.

---

## Cómo funcionaba, por si algo se quiere conservar

Del `recolector`, que es el más completo de los cuatro:

- Exigía **cuchillo o hoz de recolección equipada** (`cuchillorecolector`,
  `hozrecolector`), con usos propios y rotura.
- Un nivel de habilidad aparte, `NIVELRECOLECCION`, guardado en el contenedor,
  y sin él ni se intentaba: *"quizá deberías hablar con algún Maestro de
  Herboristería"*.
- Probabilidad en dos pasos: primero un acceso (25% a nivel 0, hasta 50%),
  después el éxito, con bono de Sabiduría, bono racial (elfo d6, mediano d4,
  humano y semielfo d3) y el rango de una habilidad.
- 3% de **lesión**: envenenamiento, lumbalgia o esguince, con penalizadores
  permanentes.
- El nodo se agotaba con `USOSPLANTA` y **reaparecía a las 12 horas de juego**
  (`DelayCommand(2280.0, ...)`).

---

## Datos heredados del sistema viejo

Por si sirven de referencia al diseñar el nuevo, no como regla:

- Los árboles y las plantas usaban la misma escalera de `DIFICULTAD`:
  80, 145, 205, 270, 330, 395, 455, 520.
- `USOSARBOL` 50 en todos los árboles, `USOSVETA` 50 en metal y 38 en gema,
  `USOSPLANTA` entre 130 y 300.
- Falta un `TIPOPIEDRA` 3 que no está en el mapa ni existe como blueprint.
- Las vetas de gema **repiten los números** de `TIPOPIEDRA` de las de metal —
  hay dos "tipo 1", dos "tipo 2"—, así que ese número no sirve para
  distinguirlas. El sistema nuevo tendrá que mirar otra cosa.

---

## El sistema nuevo

Decidido el 2026-08-18. Lo de arriba es lo que había; esto es lo que se va a
hacer.

### Cómo se pica

1. El jugador **equipa la herramienta** que corresponda y **golpea el nodo**,
   con el ataque normal del juego.
2. **Cada golpe que acierta** tira por material, pero **un nodo sólo tira una
   vez cada diez segundos**: los golpes que caigan en ese hueco no cuentan.
   Es lo que marca el ritmo, y es deliberado — sin ello, quien tenga tres
   ataques por asalto vaciaría el nodo tres veces más rápido, y la recolección
   no debería depender de lo bien que pegues.
3. Lo que sale va **directo al inventario**, sin contenedor de por medio.
4. Tras cierto número de entregas el nodo **se agota**: sigue ahí, visible, pero
   deja de dar nada.
5. **Se recarga a las dos horas.** No desaparece ni se sustituye por otro
   ubicado en ningún momento.

### The trees are named after the wood they give — 2026-08-23

The blueprints keep their legacy tags, which are real-world woods, but a player
never sees a tag. They saw the node's name, and it was the tag's wood rather
than the design's: chopping **Ciprés** yielded a *Leño de cedro*, and five other
trees did the same. Six blueprints and their six placed instances were renamed
to the wood the design names, which is the wood their log and every carpentry
recipe already used.

| Blueprint | Was called | Now |
|---|---|---|
| `cnr_arbol_cipres` | Ciprés | **Cedro** |
| `cnr_arbol_cedro` | Cedro | **Roble** |
| `cnr_arbol_alamo` | Álamo | **Sombralto** |
| `cnr_arbol_olmo` | Olmo | **Leñocaso** |
| `cnr_arbol_roble` | Roble | **Zalantar** |
| `cnr_arbol_fresno` | Fresno | **Maderadique** |

Pino and Abeto already agreed. Only the display name moved: tags, resrefs and
the material each node drops are untouched, so nothing in a chest, a recipe or a
player's pack notices.

Renamed on the blueprint **and** on the instance, as this document's own rule
requires: a placed placeable keeps its own copy, and the instance's name lives
in `LocName` while the blueprint's lives in `LocalizedName`.

### A node cannot be destroyed — 2026-08-20

Point 5 above was a promise the data did not keep. Every node blueprint and
every placed instance carried `Plot = 0` with 10,000 hit points and no
`OnDeath`, so sustained attacks could take a node down, and once down it could
never refill. Since harvesting *is* attacking the node, that was reachable by
ordinary play.

All 44 blueprints in `src/cnr/utp/` and all 49 instances in
`src/module/git/testarea_oficios.git.json` now carry `Plot = 1`.

Two separate engine behaviours make that enough, and neither is obvious, so
both are recorded here:

- a plot object cannot be damaged or destroyed —
  [SetPlotFlag](https://nwnlexicon.com/SetPlotFlag);
- the physical-attack event fires on **being attacked**, not on taking damage,
  so it still runs on a target that takes none —
  [OnPhysicalAttacked](https://nwnlexicon.com/OnPhysicalAttacked).

`OnMeleeAttacked` is the only event the harvesting system uses, so the node
keeps working while becoming impossible to remove. Hit points, `Hardness`,
`Useable` and `Static` were left exactly as they were: the flag is the only
protection, so there is one thing to check rather than four.

Any node added later has to carry it too, on the blueprint **and** on the
instance — a placed placeable keeps its own copy of the field.

**Cuánto aguanta un nodo.** Se tira al cargarse, así que dos vetas del mismo
tipo no rinden lo mismo:

| Tier del nodo | Entregas |
|--:|---|
| 1 y 2 | 8 + `d4` (9-12) |
| 3 | 7 + `d4` (8-11) |
| 4 | 6 + `d4` (7-10) |

Cuenta **entregas**, no golpes: un fallo de la tirada no gasta el nodo.

**Cada entrega vale dos piezas**, con dos excepciones que dan una: los metales
de tier 4, para que lo raro siga siendo raro, y **todas las vetas de gema** —
una receta se come el mineral y los tablones a puñados pero engarza una sola
piedra por anillo, y cada veta reparte además entre tres y seis gemas
distintas, así que da variedad sin necesitar volumen. Ajustado el 2026-08-18 tras la primera prueba
real: una veta de aceroscuro dio 3 pepitas en 41 golpes, que es exactamente el
25 % previsto por tirada, pero se sentía pobre. El enfriamiento se queda en diez
segundos —es lo que evita que el ritmo dependa de los ataques por asalto— y lo
que sube es lo que rinde cada acierto.

Un nodo de mineral, árbol o planta de tier 1 a 3 pasa así a dar entre 16 y 24
piezas antes de agotarse; uno de tier 4 sigue dando entre 7 y 10, y una veta de
gema entre 9 y 12 repartidas entre las suyas.

El sistema viejo cambiaba la veta de mineral agotada por una de gemas. **Eso se
quita**: un nodo es siempre el mismo nodo. Lo que aquello daba se compensa por
otra vía, la tirada de gema de la veta de mineral, que se explica más abajo.

### Qué da cada tipo de nodo

| Nodo | Principal | Adicional |
|---|---|---|
| Veta de mineral | su pepita | **carbón** al entregar, y **gema bruta de su mismo tier** en cada golpe |
| Veta de gema | gema bruta de su lista | — |
| Árbol | su leño | — |
| Planta | su hierba | — |

Las vetas de mineral son las únicas que dan tres cosas: están centradas en su
mineral, y de propina sueltan carbón y alguna gema del tier que les toca.

**Los extras de las vetas de mineral**, tirados aparte del material principal:

| Extra | Cuándo se tira | Probabilidad |
|---|---|--:|
| Una pepita de carbón | en cada entrega | 20 % |
| Una gema bruta de su tier | **en cada golpe que el nodo contesta** | 12 % |
| En las vetas de tier 4, una gema cualquiera de tier 1 a 3 | en cada golpe | 6 % |

La diferencia entre las dos columnas importa. El carbón sale con la pepita, o
sea una vez por entrega: entre 8 y 12 tiradas por veta. La gema se tira **antes
de la prueba de característica**, así que un golpe que no arranca nada puede
aun así descubrir una piedra. Vaciar una veta cuesta entre 20 y 48 golpes
contestados según lo bueno que sea el minero, así que salen entre 2 y 6 gemas
por veta agotada.

Está puesto así a propósito, y no es un detalle de implementación: en el
sistema viejo la veta de mineral agotada **se convertía en una veta de gemas**,
que luego daba de 8 a 11 piedras. De ahí venía casi toda la joyería del
servidor. Al quitar aquello, las gemas quedaban solo en las ocho vetas
dedicadas frente a quince de mineral, y no salían las cuentas. Esta tirada lo
paga, aunque da menos que el sistema viejo: la veta dedicada sigue siendo el
sitio donde se va a por gemas.

El enfriamiento de diez segundos sigue delante de todo, así que esto tampoco
depende de los ataques por asalto. Un golpe que solo da gema **no gasta el
nodo ni la herramienta**: eso sigue atado a las entregas.

### La tirada

Un golpe que acierta no da material por sí solo: tira contra una dificultad que
el jugador no ve.

```
d20 + modificador de característica  contra la DC del nodo
```

| Familia | Característica |
|---|---|
| Vetas de mineral y de gema | **Constitución** |
| Plantas | **Destreza** |
| Árboles | **Fuerza** |

El modificador es el de la **característica base**: no cuentan los objetos que
la suban. `GetAbilityScore(oPC, ABILITY_X, TRUE)` devuelve justamente eso.

**The modifier is floored, not truncated — 2026-08-20.** `(score - 10) / 2` in
NWScript truncates towards zero, so it rounded the wrong way for every odd
score below 10: Constitution 9 produced 0 instead of -1 and 7 produced -1
instead of -2. The weakest harvesters were quietly getting a bonus they had not
earned. `CnrNode_FloorDivide` in `cnr_i_node.nss` now floors it:

| Characteristic | 3 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 18 |
|---|--:|--:|--:|--:|--:|--:|--:|--:|--:|
| Before | -3 | -2 | -1 | -1 | 0 | 0 | 0 | +1 | +4 |
| Now | -4 | -2 | **-2** | -1 | **-1** | 0 | 0 | +1 | +4 |

The crafting include carries the same helper. It is repeated rather than
imported: pulling the whole crafting engine into a node's include chain to
reuse ten lines is the worse trade.

| Tier del nodo | DC | Con +0 | Con +2 | Con +4 |
|--:|--:|--:|--:|--:|
| 1 | 14 | 35 % | 45 % | 55 % |
| 2 | 15 | 30 % | 40 % | 50 % |
| 3 | 16 | 25 % | 35 % | 45 % |
| 4 | 16 | 25 % | 35 % | 45 % |

Un fallo no gasta el nodo ni la herramienta: sólo se pierde el intento.

**De dónde salen estos números.** Cinco minutos de picar son treinta tiradas,
una cada diez segundos. Con esas probabilidades caen entre siete y dieciséis
entregas, y como el nodo se agota antes, en la práctica:

| | En cinco minutos |
|---|---|
| Mala racha y sin bono | siete u ocho piezas, y el nodo aún vivo |
| Racha normal | el nodo agotado cerca del final |
| Buena racha o buen bono | el nodo agotado sobre el minuto tres |

Que es lo pedido: unos cinco minutos por nodo, de ocho a doce piezas, con la
mala suerte pasando factura sin dejar a nadie a cero.

**Tiers, para cruzar mineral con gema:**

| Tier | Metales | Gemas |
|--:|---|--:|
| 1 | Cobre, Hierro, Acero | 10 |
| 2 | Plata, Hierrofrío, Oro, Platino, Hierro Enardecido | 9 |
| 3 | Aceroscuro, Dlarun, Hizagkuur, Arandur | 9 |
| 4 | Metal Vivo, Mithril, Adamantita | ninguna propia: tira de las de abajo, y poco |

**No hay gemas de tier 4 y no las va a haber**: joyería reparte sus 28 gemas en
tres escalones a mano, gema por gema, en `documentation/oficios/joyeria.json`, y
el generador aborta si aparece un tier 4. Subir alguna obligaría a rebalancear
el oficio entero.

Así que las tres vetas de tier 4 —metal vivo, mithril y adamantita— sueltan
gemas **de los tiers de abajo y con probabilidad muy baja**. Se pican por su
metal, no por sus gemas.

### El acero no se pica: se hace

Es el único metal sin veta, y esto cierra el hueco:

```
1 pepita de hierro + 1 pepita de carbón  =  1 pepita de acero
```

Que es además lo que distingue al acero del hierro de verdad. La pepita de
acero sigue fundiéndose como todas: 3 pepitas + 1 carbón = lingote.

### Las herramientas

Las mismas que pedía el sistema viejo, que **siguen existiendo y se venden en la
tienda de oficios** (`_basefaccione001`, la misma área que vende los moldes).
Van equipadas en la mano derecha:

| Nodo | Herramienta | Blueprint |
|---|---|---|
| Vetas de mineral | `picodeminero` o `mazodeminero` | `picodeminero`, `mazodeminero` |
| Vetas de gema | `picodegemas` y nada más | `picodegemas` |
| Árboles | `carp_hl` o `carp_hlp` | hacha de leñador y hacha pequeña |
| Plantas | `cuchillorecolector` o `hozrecolector` | `cuchillorecolect`, `hozrecolector` |

Cada familia tiene dos herramientas: una corriente y otra mejor que aguanta más.
La excepción es la veta de gema, que solo acepta su pico. **Ninguna herramienta
cruza de familia**: el pico de minero no abre una veta de gema y el de gemas no
toca el mineral. Quien quiera picar las dos cosas lleva las dos.

**El desgaste**: cada vez que la herramienta entrega material pierde un punto.
Se gasta al sacar algo, no al golpear en vano.

Lo que hacía el sistema viejo, como referencia: las cargas se tiraban al
estrenar la herramienta —el mazo `13d6`, el pico `20d6`, el cuchillo `6d6`, la
hoz `24d6`— y el gasto por uso subía con el tipo de nodo, `d2`, `d3` o `d4` en
los más duros. Con eso una hoz duraba entre 24 y 144 recolecciones y un cuchillo
entre 6 y 36, que es demasiada diferencia entre estrenar una y estrenar otra.

**Propuesta**, para que no sea ni eterno ni insufrible y no dependa de la
suerte al estrenarla:

| Herramienta | Usos |
|---|--:|
| Corriente | 40 |
| Buena | 80 |

y el gasto por entrega según el tier del nodo: **1** en tier 1 y 2, **2** en
tier 3, **3** en tier 4. Así una herramienta corriente saca unas cuarenta
piezas de material bajo o unas trece de mithril, y la buena el doble.

### Lo que falta decidir

1. Si se conserva algo del sistema viejo: el nivel de recolección aparte, el
   bono racial, y el 3 % de lesiones con penalizadores permanentes.
2. Si la recolección da experiencia de oficio, y cuánta.

---

## Los nodos nuevos

Hechos el 2026-08-18. **Los viejos ya no existen**: sus blueprints se han
borrado de `src/shared/utp/`, la paleta apunta a los nuevos y las 49 instancias
del mapa de pruebas están sustituidas en su mismo sitio.

Cada nodo lleva `tag` = `resref` = nombre de fichero, vive en `src/cnr/utp/`
como el resto del plugin, y guarda en su `VarTable` sólo lo que el sistema
nuevo necesita:

| Variable | Qué es |
|---|---|
| `CNR_NODO` | `arbol`, `veta`, `gema` o `planta` — decide herramienta y característica |
| `CNR_TIER` | 1 a 4 — decide DC, entregas y desgaste |
| `CNR_MATERIAL` | qué suelta; en las vetas de gema, la lista separada por `;` |
| `CNR_CONDICION` | sólo en tres plantas: `dia`, `noche`, `verinvisible` |

**El día y la noche se cuentan por el reloj**, con `GetTimeHour()`, y no con
`GetIsDay()` y `GetIsNight()`. Esas dos no son contrarias: el motor reserva la
hora del alba y la del ocaso para sí, así que a las 06:xx y a las 18:xx ninguna
respondía y **las dos plantas se negaban a la vez**, dos horas muertas de
veinticuatro. Partiendo el reloj no queda ninguna:

| Franja | Horas | Qué se recoge |
|---|---|---|
| Día | 06:00 a 17:59 | flor luminosa |
| Noche | 18:00 a 05:59 | seta nocturna |

El alba y el ocaso del módulo están en `module.ifo` (`Mod_DawnHour` 6,
`Mod_DuskHour` 18) y NWScript no los lee, así que van copiados como constantes
en `cnr_i_node.nss`. Si alguna vez se mueven en el toolset, hay que moverlos
también ahí.

Nada de `DIFICULTAD` ni `USOS*`: eran del sistema viejo y sus valores estaban
en las instancias, que es justo lo que se quería dejar de arrastrar.

Todos llevan `cnr_node_hit` en `OnMeleeAttacked`. Al estar en el blueprint y no
en la instancia, replicar desde la paleta funciona sin perder nada.

### El código

| Fichero | Qué hace |
|---|---|
| `src/cnr/nss/cnr_i_node.nss` | toda la lógica: herramienta, enfriamiento, tirada, entrega, extras, agotamiento y desgaste |
| `src/cnr/nss/cnr_node_hit.nss` | el evento, tres líneas: un golpe, un intento |

Detalles de la implementación que conviene saber:

- **El nodo se carga solo** la primera vez que lo golpean, así que no hay que
  inicializar nada al arrancar el módulo ni al colocar uno nuevo.
- **El enfriamiento va en el nodo, no en el jugador**: dos personas picando la
  misma veta comparten el ritmo, que es lo que impide vaciarla entre varios en
  un minuto.
- **Un fallo no cuesta nada**: ni entrega del nodo ni desgaste de la
  herramienta. Sólo se gastan cuando sale material.
- **Las cargas de la herramienta se sellan al primer uso**, no al comprarla, así
  que las que ya estén en un cofre siguen valiendo.
- La única consulta a la base de datos es la de la gema extra, que saca una al
  azar de `cnr_material` con la profesión de joyería y el tier pedido. Todo lo
  demás lo lleva el nodo encima.
- Ver lo invisible se comprueba **recorriendo los efectos del personaje**, no
  preguntando por un hechizo concreto: vale un conjuro, un objeto o un rasgo
  racial.

| Nuevo | Nombre | Familia | Tier | Suelta | Era |
|---|---|---|--:|---|---|
| `cnr_arbol_abeto` | Abeto | arbol | 2 | `carplenyo_abeto` | `carp_at3` |
| `cnr_arbol_alamo` | Alamo | arbol | 3 | `carplenyo_alamo` | `carp_at5` |
| `cnr_arbol_cedro` | Cedro | arbol | 2 | `carplenyo_cedro` | `carp_at4` |
| `cnr_arbol_cipres` | Cipres | arbol | 1 | `carplenyo_cipres` | `carp_at2` |
| `cnr_arbol_fresno` | Fresno | arbol | 4 | `carplenyo_fresno` | `carp_at8` |
| `cnr_arbol_olmo` | Olmo | arbol | 3 | `carplenyo_olmo` | `carp_at6` |
| `cnr_arbol_pino` | Pino | arbol | 1 | `carplenyo_pino` | `carp_at1` |
| `cnr_arbol_roble` | Roble | arbol | 4 | `carplenyo_roble` | `carp_at7` |
| `cnr_gema_berilo` | Veta de berilos | gema | 2 | `bru_per;bru_top;bru_esme` | `veta_berilo` |
| `cnr_gema_corind` | Veta de corindones | gema | 3 | `bru_zaf;bru_rubi;bru_jac;bru_zafnegro;bru_zafestre;bru_rubiestre` | `veta_corindon` |
| `cnr_gema_costa` | Veta costera | gema | 3 | `bru_jade;bru_amar;bru_barra` | `veta_costera` |
| `cnr_gema_cristal` | Veta de cristal | gema | 2 | `bru_lagrimar;bru_orblen;bru_orlo;bru_zen` | `veta_cristal` |
| `cnr_gema_diaman` | Veta de diamantes | gema | 2 | `bru_diam` | `veta_diamante` |
| `cnr_gema_marav` | Veta maravillosa | gema | 2 | `bru_bel;bru_orblen;bru_lagrey;bru_picara` | `veta_maravillosa` |
| `cnr_gema_meta` | Veta metamorfica | gema | 1 | `bru_cuarzo;bru_obs;bru_aza;bru_per;bru_cor` | `veta_meta` |
| `cnr_gema_opalo` | Veta de opalos | gema | 1 | `bru_opalo;bru_opaloa;bru_opalof;bru_opalon` | `veta_opalos` |
| `cnr_pl_ardor` | Ardor desertico | planta | 2 | `ardorDesertico` | `sute_her_p04` |
| `cnr_pl_ardora` | Ardor desertico | planta | 2 | `ardorDesertico` | `sute_her_p04_4` |
| `cnr_pl_baya` | Baya acuosa | planta | 1 | `bayaAcuosa` | `sute_her_p01` |
| `cnr_pl_bayaa` | Baya acuosa | planta | 1 | `bayaAcuosa` | `sute_her_p01_1` |
| `cnr_pl_brisa` | Brisa susurrante | planta | 1 | `brisaSusurrante` | `sute_her_p02` |
| `cnr_pl_brisaa` | Brisa susurrante | planta | 1 | `brisaSusurrante` | `sute_her_p02_2` |
| `cnr_pl_flor` | Flor luminosa | planta | 3 | `florLuminosa` | `sute_her_p06` |
| `cnr_pl_flora` | Flor luminosa | planta | 3 | `florLuminosa` | `sute_her_p06_6` |
| `cnr_pl_fruto` | Fruto fantasma | planta | 4 | `frutoFantasma` | `sute_her_p08` |
| `cnr_pl_raiz` | Raiz petrea | planta | 3 | `raizPetrea` | `sute_her_p05` |
| `cnr_pl_resina` | Resina subterranea | planta | 2 | `resinaSubterranea` | `sute_her_p03` |
| `cnr_pl_resinaa` | Resina subterranea | planta | 2 | `resinaSubterranea` | `sute_her_p03_3` |
| `cnr_pl_seta` | Seta nocturna | planta | 4 | `setaNocturna` | `sute_her_p07` |
| `cnr_veta_adaman` | Veta de adamantita | veta | 4 | `pepitaAdamantita` | `sute_met_m08` |
| `cnr_veta_arandur` | Veta de arandur | veta | 3 | `pepitaArandur` | `sute_met_m025` |
| `cnr_veta_carbon` | Veta de carbon | veta | 1 | `pepitaCarbon` | `sute_met_m027` |
| `cnr_veta_cobre` | Veta de cobre | veta | 1 | `pepitaCobre` | `sute_met_m02` |
| `cnr_veta_dlarun` | Veta de dlarun | veta | 3 | `pepitaDlarun` | `sute_met_m20` |
| `cnr_veta_enardec` | Veta de hierro enardecido | veta | 2 | `pepitaDerretido` | `sute_met_m022` |
| `cnr_veta_frio` | Veta de hierrofrio | veta | 2 | `pepitaHierrofrio` | `sute_met_m05` |
| `cnr_veta_hierro` | Veta de hierro | veta | 1 | `pepitaHierro` | `sute_met_m01` |
| `cnr_veta_hizag` | Veta de hizagkuur | veta | 3 | `pepitaHizagkuur` | `sute_met_m021` |
| `cnr_veta_mithril` | Veta de mithril | veta | 4 | `pepitaMithril` | `sute_met_m07` |
| `cnr_veta_oro` | Veta de oro | veta | 2 | `pepitaOro` | `sute_met_m06` |
| `cnr_veta_oscuro` | Veta de aceroscuro | veta | 3 | `pepitaAceroscuro` | `sute_met_m024` |
| `cnr_veta_plata` | Veta de plata | veta | 2 | `pepitaPlata` | `sute_met_m04` |
| `cnr_veta_platino` | Veta de platino | veta | 2 | `pepitaPlatino` | `sute_met_m023` |
| `cnr_veta_vivo` | Veta de metal vivo | veta | 4 | `pepitaMetalvivo` | `sute_met_m026` |

**En producción** hay que sustituir los viejos por los nuevos por resref, con
un script que recorra las áreas: la correspondencia es la última columna.
