# Arcano — diseño

Current design of the Arcane profession. Implementation status and outstanding
runtime checks live in [`arcane-build-log.md`](arcane-build-log.md); this file
owns the intended mechanics rather than the construction chronology.

Fuente de datos: `documentation/oficios/arcano.json` (105 filas) y su CSV
hermano. Lo que falta por decidir está al final, marcado como abierto.

---

## 0. Implementation boundary

The materials, station, extractor, catalogue, property application and NUI are
implemented. The build log is authoritative for incomplete work and in-game
validation; avoid copying its volatile counts here.

| Recurso | Estado |
|---|---|
| **129 esencias** `cnr_e_1..129` | En paleta, tag = resref = fichero. 93 en alguna bolsa, 36 sin uso |
| **6 cristales** `cnr_c_1..6` | Nishruu, Fénix, Hada, Dragón, Contemplador, Sombra. Los dos últimos creados; Hada y Dragón eran Quimera y Leviatán |
| **La mesa** `cnrArcaneTable` | Blueprint normalizado, colocado y cableado al runtime de Arcano |
| **La máquina de extracción** | Implementada como `cnrExtractor`; sus comprobaciones pendientes viven en el build log |
| `documentation/oficios/arcano.json` | 105 filas con `tier`, `orden`, `dc`, `min_level`, `xp`, el contrato numérico de la propiedad, y `material_tag`/`material_resref` de cada esencia |
| El CSV hermano | Mismos datos, formato del diseñador |
| El catálogo y el runtime | Implementados; `arcane-build-log.md` registra el estado verificable y las pruebas pendientes |

Dos cosas del diseño original se reescribieron para que casen con este
servidor. Las **habilidades** venían de 5e y ahora son las 28 que aceptan bono
de objeto, con tope 7 en vez de 4. Y los **huecos de conjuro** perdieron al
brujo —no tiene huecos aquí— y ganaron las clases propias: alma predilecta,
paladín de los antiguos, paladín oscuro, paladín vengador y artífice.

Los blueprints que ningún material del diseño reclama están listados en
[`arcane-unused-blueprints.md`](arcane-unused-blueprints.md), para borrarlos
cuando el oficio funcione y no antes.

---

## 1. La mecánica

Arcano no fabrica: **coge un objeto ya hecho y le añade una propiedad**.

Una tirada son tres cosas:

```
1 cristal  +  N esencias  +  el objeto a encantar
```

- **El cristal es el catalizador.** Uno por intento. Hace el papel del molde en
  los otros oficios, con una diferencia importante: **se pierde tanto al
  acertar como al fallar**. En CNR el molde sobrevive al fracaso; aquí no.
  Sólo sale de loot, nunca de tienda ni de receta.
- **Las esencias son la cantidad.** Todas del mismo material, y cuantas más se
  metan, mayor es el valor de la propiedad. La tabla de la sección 2 dice
  cuántas hacen falta para cada escalón.
- **El objeto** tiene que ser de los tipos que la fila permite — la columna
  `equipo` del diseño: armadura, escudo, yelmo, bastón, colgante, anillo, o
  las armas según el caso.

**Un objeto se encanta una sola vez.** La elección es definitiva, aunque se
haya quedado por debajo del máximo: no se mejora después ni se sustituye. El
objeto queda **marcado al encantarse**, y la marca es lo que hace imposible
volver a encantarlo — la misma mecánica con la que `CNR_ENGARZADO` impide que
una joya terminada vuelva a contar como material.

---

## 2. Cuántas esencias por escalón

| Familia | Escala | Tope |
|---|---|---|
| Habilidades | 1 esencia = +1 | 7 |
| Características | 1 esencia = +1 | 6 |
| Salvaciones | 1 esencia = +1 | 3 (universal 2) |
| Inmunidad al daño | 1 esencia = 5% | 4 esencias = 20% |
| Daño de armas | escalera propia, ver abajo | 1d8 |
| CD al golpear | 3 esencias, valor fijo | CD 16 |
| Spell slots | one slot per step | levels 1–6 cost 1–6 essences; truncated progressions use levels 1–3 at 2–4 essences, preserving the reviewed top costs |
| Afiladura | 3 esencias, sin valor | — |
| Otros | la misma lógica, según el máximo de su fila | 5, 4 o 1 |

### La escalera del daño

NWN no tiene bonos de daño de 1d2 ni de 1d3, así que la progresión salta los
escalones que no existen en `IP_CONST_DAMAGEBONUS_*`:

| Esencias | Daño |
|---:|---|
| 1 | +1 |
| 2 | +2 |
| 4 | 1d4 |
| 6 | 1d6 |
| 8 | 1d8 |

**3, 5 y 7 no se pueden comprar**: no hay valor al que correspondan. El número
de esencias coincide con el tamaño del dado a partir de 1d4, que es lo que
hace la regla fácil de recordar.

Críticos masivos usa la misma tabla del motor, así que hereda esta escalera.

### Las inmunidades

Los cuatro escalones existen gracias a que este servidor extiende
`iprp_immuncost.2da`: 5% es el índice `1`, 10% el `2`, **15% el `9`** y **20%
el `8`**. Los dos últimos son de PDB, los mismos que usan las gemas de
joyería. Sin ese hak, de 5 en 5 no se podría.

---

## 3. El tier sale del loot

El oficio no tiene tiers propios: los hereda de **dónde cae la esencia**,
porque las esencias salen de romper objetos de loot. La columna `ubicacion`
del diseño ya escala así, y `arcano.json` lo lleva resuelto en el campo
`tier`:

| Tier | Loot | Criaturas | Filas |
|---:|---|---|---:|
| 1 | Azul claro | nivel 10 o menos | 54 |
| 2 | Azul oscuro | nivel 11 a 15 | 21 |
| 3 | Legendario | nivel 16 a 20 | 18 |
| 4 | Titánico | nivel +20 | 12 |

El reparto por familias no es casual y conviene tenerlo presente al fijar los
DC: las 28 habilidades y los 12 huecos de conjuro son todos de tier 1, las
características e inmunidades de tier 2, y el daño de armas y los efectos al
golpear viven en tiers 3 y 4.

---

## 4. Las propiedades: las 105 ya se aplican

De las 105 filas, **las 105** usan propiedades que el aplicador reconoce. Hasta
el 16-08 eran 58: faltaban trece ramas, que se añadieron a los **dos**
consumidores a la vez —`cnr_i_prop.nss` y `cnr_apply_prop.nss`, que
`build_catalogue.py` obliga a mantener idénticos—.

| Rama nueva | Función de NWScript | Cubre |
|---|---|---|
| `SkillBonus` | `ItemPropertySkillBonus` | las 28 habilidades |
| `AbilityBonus` | `ItemPropertyAbilityBonus` | las 6 características |
| `SavingThrowBonus` | `ItemPropertyBonusSavingThrow` | Fortaleza, Voluntad y Reflejos |
| `OnHitPoison`, `OnHitWounding`, `OnHitHold`, `OnHitDeafness`, `OnHitConfusion`, `OnHitSleep`, `OnHitFear` | `ItemPropertyOnHitProps` | los 7 efectos que faltaban |
| `Light` | `ItemPropertyLight` | Luz |
| `DamageReduction` | `ItemPropertyDamageReduction` | Reducción de daño |
| `WeightReduction` | `ItemPropertyWeightReduction` | Reducción de peso |

Nada de esto se inventó: el generador de loot ya usaba las mismas funciones
—`pb_tesoros_inc.nss:1425` para habilidades, `:1537` para características, y la
tabla de efectos al golpear de `:1710`— así que había código funcionando del
que copiar. Los tres ficheros compilan.

**`SkillBonus` sólo alcanza a las habilidades 0-27.** Las once propias del
servidor no tienen fila en `iprp_skills.2da` y no pueden llevar bono de objeto;
por eso la sección se remapeó a las 28 que sí.

El parámetro propio de cada efecto al golpear queda como el del loot —veneno 0,
hiriente 1, el resto 2— hasta que alguien decida otra cosa.

La **reducción de daño** fue el único caso que necesitó tocar el esquema. Se lee
"5/+1,+2,+3": lo absorbido no se mueve y lo que sube es el refuerzo que hace
falta para atravesarla. Como eso vive en el *subtipo* y no en el valor,
`cnr_arcane_step` ganó una columna `subtype` que, cuando no es nula, pisa la de
la propiedad. Una esencia da 5/+1 y cuatro dan 5/+4.

De paso apareció un número mal puesto: el segundo argumento de
`ItemPropertyDamageReduction` no es la cantidad absorbida sino un índice a
`iprp_soakcost.2da`, **donde la fila 0 es "aleatorio" y absorber 5 es la fila
1**. Estaba a 5, que en esa tabla es absorber 30.

---

## 5. Y el nudo de fondo

**El motor CNR crea objetos, no los modifica.** `CnrCraft_Finish` llama a
`CreateItemOnObject` con el `base_resref` de la receta. Arcano necesita lo
contrario: leer el objeto que el jugador metió en la mesa, comprobar que su
tipo está permitido, añadirle la propiedad y devolvérselo.

Eso es un camino nuevo en el motor, no una receta más. Decidirlo es el primer
paso de la implementación, y de ahí cuelga todo lo demás.

---

## 6. DC, nivel y experiencia

Arcano usa la **misma maquinaria que el resto del catálogo**: cada receta ocupa
una posición en un orden autorizado y `progression_value()` reparte sobre ella
DC 10→35 y nivel 1→20.

La experiencia sí es propia: **20→82**, un 70% por encima de la del resto de
oficios, que va de 16 a 62. La razón es el coste por intento. Un intento de
arcano gasta un cristal que sólo cae de loot y hasta ocho esencias sacadas de
romper objetos; una receta de herrería gasta lingotes que se compran o se
recolectan. Con la misma experiencia, arcano costaría lo mismo en tiempo y
mucho más en material.

El orden va **por tier, y dentro de cada tier alternando familias**, para que
cada nivel abra variedad en vez de veinte habilidades seguidas. Resultado:

| Tier | Filas | Niveles | DC | XP |
|---:|---:|---|---|---|
| 1 | 54 | 1–6 | 10–23 | 20–52 |
| 2 | 21 | 7–11 | 23–28 | 52–64 |
| 3 | 18 | 12–16 | 28–32 | 65–75 |
| 4 | 12 | 17–20 | 32–35 | 75–82 |

Contra la curva de `cnr_trade_init.nss`, que pide **43.000 XP para el nivel
20**, eso son **764 encantamientos acertados** usando siempre la mejor receta
disponible. Con la experiencia anterior eran 1.294.

Entre **5 y 6 recetas por nivel**, sin saltos. El nivel 1 abre tres cosas de
tres familias distintas — Piruetas, TS relámpago y Huecos de clérigo — y a
partir del 8 el tier 1 ya sólo tiene habilidades que ofrecer, porque las otras
familias de ese tier se agotan antes.

`arcano.json` lleva los cuatro campos calculados: `orden`, `dc`, `min_level` y
`xp`.

**Niveles realineados el 2026-09-24.** La experiencia de los oficios pasó a ir
por tramos de nivel (1–6, 7–11, 12–16 y 17–20; ver `crafting-system.md`,
sección 4c), y cada tier tiene que abrir dentro de su tramo. Los niveles de la
tabla de arriba son los nuevos: las propiedades de cada tier se repartieron por
su tramo conservando el `orden`, 96 de 105 cambiaron de nivel y la DC y la XP no
cambiaron. El tier 1 abre ahora 9 propiedades por nivel entre el 1 y el 6, en
lugar de 5–6 por nivel hasta el 11. `build_arcane.py` rechaza una propiedad
fuera del tramo de su tier.

La mitad del oficio vive en tier 1, y eso es lo que hay: las 28 habilidades,
los 12 huecos de conjuro y 12 salvaciones caen todas ahí. El equilibrio de los
primeros once niveles depende por completo de que esas 54 rindan.

---

## 7. La máquina de extracción

Las esencias no se compran ni se recolectan: **salen de destruir objetos de
loot**. Eso lo hace una máquina propia, separada de la mesa de encantar.

### Cómo se usa

1. El jugador mete **un objeto** en la máquina. Uno solo.
2. Cierra el contenedor, que **queda bloqueado**.
3. Se abre una conversación con dos salidas: **romper** o **liberar**.
4. *Liberar* desbloquea y ya está: **el objeto se queda dentro**, intacto. La
   máquina no lo toca hasta que se decide romperlo.
5. *Romper* destruye el objeto, y **las esencias van al inventario del
   jugador**, no al contenedor.

### Qué se puede romper, y qué no

La máquina sólo acepta objetos generados por el sistema de loot, y para eso
**el generador tiene que marcarlos**: de aquí en adelante, cada objeto que
cree lleva una marca oculta que dice que es rompible y de qué tier. Sin esa
marca no entra, y así no hay trampa posible.

Hoy ya sella algo parecido — `pb_tesoros_inc.nss:1767` guarda
`CALIDAD_GUARDADA` — y ese rango es el que da el tier:

| Rango del loot | Nombre que recibe | `CALIDAD_GUARDADA` | Tier |
|---:|---|---|---:|
| 1 | superior | `IP_CONST_QUALITY_ABOVE_AVERAGE` | — |
| 2 | encantado/a | `IP_CONST_QUALITY_VERY_GOOD` | 1 |
| 3 | poderoso/a | `IP_CONST_QUALITY_EXCELLENT` | 2 |
| 4 | legendario/a | `IP_CONST_QUALITY_MASTERWORK` | 3 |
| 5 | titánico/a | `IP_CONST_QUALITY_GOD_LIKE` | 4 |

Un objeto sin la marca —fabricado, comprado, de quest, o anterior a este
cambio— **no es rompible**. El rango 1, el gris, tampoco entra en la
extracción: la máquina empieza en el azul claro.

**Un objeto ya encantado no se puede romper.** Terminado es terminado: ni se
recicla, ni se reencanta, ni se mejora.

### Qué suelta

Un objeto nunca da esencias por encima de su propio tier. Del suyo propio da
poco cuando el tier es alto, y de los de abajo da cantidades modestas: romper
basura no puede ser una fábrica de material.

| Objeto roto | Tier 1 | Tier 2 | Tier 3 | Tier 4 |
|---|---|---|---|---|
| **Azul claro** | 1d3, 60% cada una | — | — | — |
| **Azul oscuro** | 1d3, 50% | 1d3, 60% | — | — |
| **Legendario** | 1d3, 50% | 1d3, 50% | 1d2, 20% | — |
| **Titánico** | 1d4, 50% | 1d3, 60% | 1d2, 35% | 1d2, 17% |

Se lee así: se tira el dado para saber cuántas *podrían* salir, y cada una de
esas se juega su porcentaje por separado. No hay tope: con dados tan pequeños
no haría nada.

> **Dónde se toca esta tabla**: `src/cnr/nss/cnr_i_extract.nss`, en el
> `switch (iTier)` de `CnrExt_Break`, y en ningún otro sitio. Una llamada a
> `CnrExt_Roll(oPC, bolsa, dado, probabilidad)` por casilla de la tabla:
>
> ```nwscript
> case 4:
>     iTotal += CnrExt_Roll(oPC, 1, 4, 50);   // 1d4 al 50% de la bolsa 1
>     iTotal += CnrExt_Roll(oPC, 2, 3, 60);
>     iTotal += CnrExt_Roll(oPC, 3, 2, 35);
>     iTotal += CnrExt_Roll(oPC, 4, 2, 17);
>     break;
> ```
>
> La media de una línea es `(dado + 1) / 2 × probabilidad`, y la probabilidad
> de sacar al menos una es `1 - media_n(q^n)` con `q = 1 - probabilidad`. La
> cabecera del fichero lleva copia de la tabla y de las medias: **si se cambia
> una, hay que cambiar la otra**.

Rendimiento medio por objeto roto, y probabilidad de sacar al menos una:

| Objeto roto | T1 | T2 | T3 | T4 | Total |
|---|--:|--:|--:|--:|--:|
| Azul claro | 1,20 | — | — | — | 1,20 |
| Azul oscuro | 1,00 | 1,20 | — | — | 2,20 |
| Legendario | 1,00 | 1,00 | 0,30 | — | 2,30 |
| Titánico | 1,25 | 1,20 | 0,53 | 0,26 | 3,23 |

| Objeto roto | 1+ de T1 | 1+ de T2 | 1+ de T3 | 1+ de T4 |
|---|--:|--:|--:|--:|
| Azul claro | 79,2% | — | — | — |
| Azul oscuro | 70,8% | 79,2% | — | — |
| Legendario | 70,8% | 70,8% | 28,0% | — |
| Titánico | 76,6% | 79,2% | 46,4% | 24,1% |

De donde sale lo que cuesta cada esencia: **una de tier 4 son 3,9 objetos
titánicos**, y esos mismos cuatro titánicos dejan de paso unas dos de tier 3.
Una de tier 3 son 3,3 legendarios. Las de tier 1 y 2 caen de todo lo que se
rompa, en torno a una por objeto.

Esta tabla sustituye a la primera, que daba 2,16 de tier 1 y 2,70 de tier 2 por
cada titánico: **el 87% de lo que salía de lo mejor del juego era material
bajo**, y encima el tope de 3 se lo aplicaba al tier 1 y no al 2, así que un
titánico daba más material de tier 2 que de tier 1. Las tasas de tier 3 y 4 se
han conservado a propósito; lo que se ha cortado a la mitad es el chorro de
material bajo desde los objetos altos.

### Qué esencia concreta sale

**El tier lo tienen las bolsas, no las esencias.** Cuando la tabla dice "1d4
del tier 2", se saca al azar de la bolsa de tier 2. Nada impide que una misma
esencia esté en dos bolsas.

| Bolsa | Esencias distintas |
|---|---:|
| Tier 1 | 54 |
| Tier 2 | 21 |
| Tier 3 | 18 |
| Tier 4 | 8 |

Ocho esencias están en las bolsas 2 y 3 a la vez: las elementales —Escama de
asabi, Gotas de ábalin, Espolón de dragónido, Claridad de nyzh, Hálito de
dragón del canto, Pesuño de bestia de Málar, Colmillo de abishái y Vellosidad
de alaghi—, porque el diseño las usa para la inmunidad a un elemento y para el
daño de ese mismo elemento, y cada sección cae de un loot distinto.

Eso no es un conflicto: **salen por las dos vías y por tanto son más
frecuentes**, que es justo lo que corresponde, porque también son las que
demandan dos familias de recetas en vez de una.

En total, 93 de los 129 blueprints `cnr_e_*` están en alguna bolsa.

Que la esencia salga al azar dentro de su bolsa es lo que empuja el comercio:
un jugador que busca *Piruetas* romperá objetos y le irán saliendo *Saltar* y
*Sanar*, y el sobrante acaba en el mercado.

### Los cristales

Salen del mismo sitio, en el mismo acto: **cada objeto roto tiene un 20% de
soltar además un cristal**, elegido al azar entre los seis. No depende de la
rareza del objeto.

Con eso los números cerraban de sobra ya con la tabla vieja: 764 cristales para
llegar a nivel 20, uno por intento, contra los ~1.374 que dejaban los ~6.900
objetos que había que romper para gastar el máximo de cada receta.

Con la tabla de ahora cada objeto rinde menos esencias, así que hacen falta
**más** objetos rotos para lo mismo, y por tanto salen **más** cristales. El
20% sigue holgado; lo que hay que vigilar es lo contrario, que no sobren tantos
que dejen de valer nada.

Un cristal cada cinco objetos rotos vale igual rompiendo basura que rompiendo
titánicos: **el cristal es el único material que no mira el tier**. Para las
propiedades que piden dos, es el cuello real de los encantamientos baratos.

### Sin riesgo de perderlo todo

Se valoró que la extracción pudiera fallar y no devolver nada. **Descartado**:
las esencias de arriba ya salen con probabilidad baja, y sumarle un fallo seco
encima castiga dos veces lo mismo. Si en pruebas se ve que sale demasiado
material, se ajustan los porcentajes de la tabla, que es una palanca más fina.

---

## 8. La mesa: un NUI, y sin recetas

La mesa de arcano no usa el menú de conversación del resto de oficios. Es una
**ventana NUI**, redimensionable, que presenta las 105 propiedades del diseño
repartidas de forma legible.

Y el cambio de fondo: **no hay recetas**. En los otros oficios el jugador elige
una fila del catálogo y el motor la ejecuta. Aquí el jugador **arma la petición
en la ventana** —qué objeto, qué propiedad, qué valor— y el script recibe todo
lo necesario para aplicarla. El catálogo de arcano no es un menú, es una tabla
de referencia que dice qué es legal y a qué precio.

### El recorrido

1. El jugador **elige el objeto** a encantar.
2. La ventana **habilita sólo las propiedades que ese objeto admite**, según la
   columna `equipo` de la fila.
3. Choose the property and then its **value between minimum and maximum**.
   Spell slots offer every level in the class progression; Keen is the only
   fixed-value choice.
4. Pulsa **Encantar**. La ventana no fabrica nada todavía: **escribe en el chat
   de combate qué materiales hacen falta y cuántos tiene**, en formato `xx/XX`,
   con color y bien tipado.
5. El jugador abre el contenedor y mete el material. **La ventana no se cierra
   ni pierde lo seleccionado** mientras tanto.
6. Pulsa **Encantar** otra vez. Si ahora está todo, sale un **popup de
   confirmación** con el nombre del objeto y la propiedad con su valor.
7. Al confirmar, **se bloquea el contenedor**, se vuelve a verificar todo, y se
   encanta.

El éxito o el fallo se resuelven como en el resto de oficios: `d20 + nivel de
oficio + bono de ayuda` contra el DC de la fila.

### Qué objeto acepta la mesa

El objeto a encantar **va dentro del contenedor, junto al material**. La mesa
analiza lo que hay en ella; no se elige nada del inventario.

Dos condiciones deciden si un objeto entra, y ninguna mira el resref:

1. **`CNR_OFICIO > 0`** — lo hizo Herrería, Peletería, Sastrería, Joyería o
   Carpintería. Es la marca que ya estampan las 354 recetas, puesta
   exactamente para esto.
2. **No está encantado.** La marca que deja el propio encantamiento, y que se
   comprueba antes que nada.

Cumplidas ésas, el objeto es válido *sea lo que sea*. Lo que decide después es
el **filtro de propiedades**: la ventana habilita sólo las que su tipo de
objeto base admite.

### Los ocho grupos de equipo

El filtro va por **tipo de objeto base**, no por lista de resrefs. Se lee con
`GetBaseItemType()` y se compara contra una tabla corta que dice qué tipos
entran en cada grupo. Una lista de resrefs habría que mantenerla, y se queda
obsoleta en cuanto alguien crea un blueprint y olvida apuntarlo; los tipos base
no cambian, así que una espada nueva de herrería entra sola en el grupo de
armas.

Lo que los oficios producen hoy son **once tipos base**, sacados de las 354
recetas marcadas: `AMULET` (28 resrefs), `RING` (28), `ARMOR` (2), y uno de
cada de `SMALLSHIELD`, `TOWERSHIELD`, `HELMET`, `BOOTS`, `GLOVES`, `BRACER`,
`CLOAK` y el **361**, un objeto base propio del servidor que es el cinto de
cuero. Las armas y algunas armaduras usan resrefs del juego base
(`wswls002`, `nw_wblcl001`, `nw_wdbqs001`…), que no cambia nada: su tipo base
se lee igual.

Al escribir la tabla de tipos, dos que no son obvios:

- **"Bastón" eran dos objetos base, y desde el 2026-08-27 el grupo admite tres
  cosas donde el diseño escribía una.** Los ocho bastones de carpintería usan
  `nw_wdbqs001`, que es un `QUARTERSTAFF` (50), un arma de combate. Para que
  las 76 filas que piden bastón tengan también un bastón de lanzador se añadió
  a carpintería **una receta única**, *Bastón de roble para mago*
  (`cnr_bastonroble`), un `MAGICSTAFF` (45) sin propiedades, a nivel 9. El
  tercero es la **daga de hechicería** (`SorcererDagger`, 514), que entró para
  que un lanzador no esté obligado a ir con bastón.

  Una palabra del diseño que significaba tres tipos base distintos es
  exactamente cómo el diseño y la tabla se separan sin que nadie lo note, así
  que la etiqueta `equipo` ya no dice "baston" a secas: dice **"Armadura,
  escudo, yelmo, baston, baston de mago, daga de mago, colgante, anillo"**, en
  el CSV, en `arcano.json` y en la clave de `GROUPS`. Las tres son cosas
  distintas y ahora se llaman distinto.

- **La daga de hechicería tuvo que hacerse fabricable primero.** La mesa sólo
  admite lo que lleva la marca `CNR_OFICIO`, y `cnr_i_craft` la estampa al
  craftear; nada más la pone. `item_dagahechi` es botín, así que meter la 514 en
  el grupo no habría bastado: la mesa habría seguido rechazando la daga que el
  jugador trae. Entró como producto número 50 de `smith_weapon`, con blueprint
  propio `cnr_b_sdagger` limpio de propiedades. Añadir un producto a un grupo
  de variantes no crea ninguna receta ni mueve un `public_id`. Ver
  [`base-items.md`](base-items.md), que registra la decisión que esto revierte.

- **El cinto de cuero usa el objeto base `361`**, propio de PDB y sin constante
  en `nwscript.nss`. **No está en la tabla**, pese a lo que decía este párrafo:
  `WEARABLE` en `build_arcane.py` nombra el 361 en un comentario y lo deja fuera
  de la lista, así que los diez cintos de peletería no se pueden encantar. El
  diseño tampoco los nombra en `equipo` —ni las botas, ni los guantes, ni los
  brazales, ni las capas, otros cuarenta objetos—, de modo que es una decisión
  pendiente y no un descuido del generador. Abierto a 2026-08-27.

La columna `equipo` es texto libre. Sólo hay ocho combinaciones distintas:

| Grupo | Filas |
|---|--:|
| Armadura, escudo, yelmo, bastón, bastón de mago, daga de mago, colgante, anillo | 76 |
| Arma cuerpo a cuerpo y a distancia | 12 |
| Todas las armas | 11 |
| Colgante, anillo | 2 |
| Armas cuerpo a cuerpo | 1 |
| Armas a distancia | 1 |
| Todos los objetos | 1 |
| Todas las armas, con estoques, kukris y cimitarras a **2 cristales** | 1 |

La última es Críticos masivos, y es el único caso donde el coste en cristales
cambia según el arma.

### Lo que hay que verificar en el servidor, sí o sí

Una ventana NUI la controla el cliente. **Nada de lo que llega desde ella es de
fiar**: ni la propiedad elegida, ni el valor, ni el objeto. Un cliente
modificado puede pedir "+7 con cero esencias".

Por eso el script que encanta tiene que **rehacer todas las comprobaciones en
el momento de aplicar**, sin apoyarse en lo que dijo la ventana:

- que la propiedad y el valor existen en la tabla y el valor está entre el
  mínimo y el máximo de esa fila;
- que el objeto sigue ahí, es del tipo que la fila permite, y **no está ya
  encantado**;
- que el material está **en ese instante** en el contenedor, contado de nuevo;
- que el jugador tiene el nivel de oficio que pide la fila.

Es la misma lección que el resto del sistema: contar y consumir dentro de la
misma ejecución, sin huecos.

Dos cosas más que arrastramos de lo aprendido:

- **El estado va en el jugador**, nunca en el placeable. Cada uno tiene su
  ventana y su selección; el contenedor es compartido como en las demás mesas.
- **El contenedor es de todos.** Dos jugadores en la misma mesa comparten
  material, así que la verificación del punto anterior es lo único que impide
  que uno encante con lo que puso el otro.

### Sin recetas, pero con tabla — **hecho**

Que no haya recetas no significa que no haya datos. Las 105 filas viven en
cuatro tablas propias, no en `cnr_recipe`, porque ninguna de sus columnas
encaja con "modificar en vez de crear":

| Tabla | Qué guarda |
|---|---|
| `cnr_arcane_group` | Los 8 grupos de equipo |
| `cnr_arcane_group_base` | Qué objetos base entran en cada grupo, y cuántos cristales cuesta |
| `cnr_arcane_property` | Las 105 filas: sección, grupo, tier, esencia, cristal, contrato de la propiedad, nivel, DC y si el motor la aplica |
| `cnr_arcane_step` | **484 steps**: for each property, how many essences buy each value and how much experience it grants |

Los escalones son filas y no una fórmula porque las escaleras no son
uniformes: las habilidades van de una en una, las inmunidades de cinco en
cinco, y el daño de arma salta los valores que NWN no tiene. Así la ventana
sólo tiene que listar lo que hay, y el aplicador sólo tiene que comprobar que
el escalón existe.

**La experiencia va en el escalón**, proporcional a lo gastado: una habilidad
a +1 da 4 y a +7 da 26. Encantar barato ya no es forma de subir.

Lo genera `migration/build_arcane.py` desde `arcano.json`, y el esquema está en
`01_schema.sql`.

---

## 9. Abierto

1. **Cuánta experiencia da un encantamiento.** Ya no hay recetas, así que la
   experiencia no puede ir por receta: si va por intento, lo rentable es meter
   una esencia. Lo natural es que **escale con lo que has gastado**, pero hay
   que fijar cómo.
2. **Si arcano vive dentro de CNR o en paralelo.** De ahí cuelgan las otras
   dos: dónde van las ramas que faltan de la sección 4, y quién implementa el
   camino de la sección 5.
3. **Las 52 filas sin propiedad**, en el aplicador que corresponda.
4. **El camino "modificar, no crear"**.
