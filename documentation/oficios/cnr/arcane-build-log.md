# Arcano — registro de construcción

Qué está hecho, qué falta y qué hay que comprobar en juego. El **diseño** vive
en [`arcane-plan.md`](arcane-plan.md); esto es el estado de la obra.

Se actualiza en cada tanda. Lo cerrado se borra de "pendiente" y se resume en
"hecho" — el detalle está en los commits.

---

## Hecho

| Etapa | Qué | Commit |
|---|---|---|
| Materiales | 129 esencias `cnr_esen*` y 6 cristales `cnr_cristal*`, tag = resref = fichero | `7123f617a`, `dae7576a1` |
| Estación | `cnrArcaneTable` normalizada, en `src/cnr/utp`, colocada en el área de oficios | `d61061e0e`, `8c5026e12` |
| Extractora | `cnrExtractor` como blueprint, en paleta junto a la mesa. **Sin lógica** | `c3bd8627b` |
| Cofre | `cnrChestArcane` con las 93 esencias del diseño y los 6 cristales | `2af749250` |
| Datos | 4 tablas y `build_arcane.py`: 8 grupos, 105 propiedades, 442 escalones | `9448411c4` |
| Propiedades | 13 ramas nuevas en los dos consumidores; las 105 filas se aplican | `00f0bb4e5`, `ce31ea973` |
| Bastón | `cnr_bastonroble`, un `MAGICSTAFF` limpio para poder encantarlo | `53c6dd086` |
| Base de datos | Esquema, catálogo y arcano aplicados a DEV: 495 recetas, 105 propiedades, 442 escalones | 2026-08-16 |
| Extractora | `cnrExtractor` con lógica, ventana y eventos; el placeable `CAMBIAR` del mapa convertido | — |
| Base de datos | Catálogo regenerado: 513 recetas, 1146 componentes, 647 propiedades | 2026-08-23 |
| DC por escalón | La DC deja de ser de la propiedad y pasa a ser del escalón: la de entrada más uno por peldaño, con tope 35. Once propiedades bajan para caber | `5ef745e23` |
| Marca | Toda pieza encantada se lleva `[Encantado]` en rosa detrás de su nombre | `5383a8bed` |
| Nombre y descripción | El panel derecho de solo lectura pasa a ser dos campos: nombre y descripción, con firma del artesano | `0731396ae` |
| Spell-slot levels | All twelve class properties offer every spell level in their progression; the generated catalogue now has 484 steps | this change |

---

## Pendiente

### Etapa 2 — el script de la mesa

- [x] ~~Prototipo mínimo.~~ Hecho y comprobado en juego, ver abajo.
- [x] ~~`cnr_i_arcane.nss`.~~ Hecho: lee la mesa, resuelve el objeto, consulta
      las cuatro tablas y filtra por tipo base y nivel. No toca NUI.
- [x] ~~Contar material y decir qué falta.~~ `CnrArc_Faltante` devuelve el
      `xx/XX` de esencias y cristales.
- [x] ~~Las consultas no se han probado contra la base de datos.~~ Aplicado y
      jugado: el tester encantó con ellas el 2026-08-23.

### Etapa 3 — la ventana

- [x] ~~Vive en `src/cnr/nui/`.~~ `cnr_arc_nui.nss` y sus tres eventos.
- [x] ~~Redimensionable, propiedades legibles.~~ Dos desplegables: propiedad
      (con su familia y su DC) y cantidad (con las esencias que cuesta).
- [x] ~~No se cierra al abrir el contenedor.~~ Comprobado con el prototipo.
- [x] ~~Confirmación antes de encantar.~~ Encantar se pulsa tres veces: la
      primera dice lo que falta, la segunda avisa de que es definitivo, la
      tercera confirma.
- [x] ~~Panel de detalle.~~ **Retirado el 2026-08-23**: la columna derecha es
      ahora el nombre y la descripción que escribe el jugador. Lo que decía el
      panel se reparte entre el desplegable del poder (valor y DC), la lista de
      propiedades (nivel), y el recuadro de coste (materiales, probabilidad,
      experiencia y tier).
- [x] ~~Ver por encima de tu nivel.~~ Botón "Ver todas", como el interruptor
      del libro de oficios. Sólo cambia lo que se enseña: al encantar se
      comprueba el nivel igual.
- [x] ~~Sin probar en juego.~~ Probada el 2026-08-23: se encantó una espada
      larga con nombre y descripción propios. De ahí salió el fallo de la `r`,
      ya corregido — ver `arcane-fix-plan.md`.
- [ ] **Los cuatro colores de tier no se han visto juntos.** El del tier 4 es
      magenta y la marca es rosa: hay que mirar que se distingan.
- [ ] **Sin medir qué hace el motor con un nombre largo.**

### Etapa 4 — el aplicador

- [x] ~~Rehacer todas las comprobaciones al aplicar.~~ `cnr_i_apply.nss`:
      propiedad, escalón, objeto, tipo base, nivel y material, todo de nuevo.
- [x] ~~Tirada `d20 + nivel + ayuda` contra el DC.~~ Usa
      `CnrCraft_GetRollBonus`, la misma del resto de oficios.
- [x] ~~Marcar el objeto.~~ `CNR_ENCANTADO`, y se pone **después** de aplicar
      la propiedad, no antes.
- [ ] **Sin probar en juego.**

### Después

- [x] ~~La máquina de extracción.~~ Hecha: `cnr_i_extract.nss` con la tabla de
      suelta, ventana NUI con Deshacer y Liberar, y el placeable del mapa
      cableado. **Sin probar en juego.**
- [x] ~~El generador de loot debe estampar una marca propia de "rompible".~~
      `pb_tesoros_inc.nss:1769` pone `CNR_LOOT_TIER` con el tier (rango 2 → 1,
      hasta rango 5 → 4; el gris no lleva marca). La extractora ya no mira
      `CALIDAD_GUARDADA`: **el botín anterior a este cambio no se puede
      romper**, que es justo lo que se buscaba para que nadie vacíe un alijo
      viejo de golpe.
- [ ] **Sin probar en juego**: hay que matar algo, mirar que el objeto nuevo
      lleve la variable y deshacerlo.

---

## Comprobado en juego — 2026-08-16

El prototipo contestó las tres, y las tres a favor:

1. **`OnUsed` abre la ventana al primer uso.** El doble disparo del placeable
   no molesta: como la ventana lleva id, NUI la trata como singleton y el
   segundo uso sólo la encuentra abierta.
2. **La ventana y el inventario conviven.** Son capas distintas y se ven a la
   vez, así que el recorrido de "carga el material sin perder la selección"
   funciona tal cual está diseñado.
3. **`OnInvDisturbed` refresca en vivo.** Al meter un objeto el contador sube
   solo, sin tocar la ventana.

De propina, dos cosas que sólo se ven probando:

- NUI dispara **`open` sobre `__window__`** al abrirse. Sirve para saber cuándo
  la ventana está lista, si alguna vez hace falta.
- **Cerrar la ventana no cierra el inventario**, y el material se queda dentro.
  Es el comportamiento correcto: el jugador retira lo suyo a mano y nada se
  pierde por cerrar sin querer.

El prototipo puede borrarse cuando la ventana de verdad lo sustituya.

---

## Lo que hace `cnr_i_arcane.nss`

Es el único sitio con lógica de arcano. La ventana y el aplicador llaman aquí,
y este fichero no sabe de ninguno de los dos.

| Función | Qué resuelve |
|---|---|
| `CnrArc_IsEnchantable` | `CNR_OFICIO > 0` y sin la marca `CNR_ENCANTADO` |
| `CnrArc_TargetState` | Si hay uno, ninguno, varios, o sólo objetos ya encantados |
| `CnrArc_GetTarget` | El objeto, **sólo si hay exactamente uno** |
| `CnrArc_CountMaterial` | Esencias y cristales dentro de la mesa, contando pilas |
| `CnrArc_ListProperties` | Las que ese objeto admite y el nivel permite |
| `CnrArc_ReadProperty` / `CnrArc_ReadStep` | Los datos de una fila y de un escalón |
| `CnrArc_ListSteps` | Para poblar el selector de poder |
| `CnrArc_CrystalCost` | 1, o 2 en el caso de críticos masivos |
| `CnrArc_Missing` | El `xx/XX` para el chat |

Dos decisiones que están en el código y conviene no deshacer sin pensarlo:

- **Con más de un objeto encantable dentro, no se elige ninguno.** Adivinar
  sería la forma más rápida de encantar el equivocado.
- **Que el escalón exista es toda la validación del valor.** La ventana puede
  pedir "+7 con una esencia" y aquí sencillamente no hay fila que lo respalde,
  sin que haga falta reimplementar las escaleras en NWScript.

---

## Auditoría del 2026-08-16

Dos agujeros de duplicación, encontrados leyendo el código y arreglados en
`95b0a3dff`. Los dos regalaban objetos y los dos habrían llegado al servidor.

**El cofre reponía lo que fuera.** `cnr_chest_inf` copiaba de vuelta cualquier
cosa que saliera del contenedor, sin mirar de quién era: metes un objeto, lo
sacas, y el cofre te deja una copia; sacas la copia y te deja otra. Con
cualquier objeto del juego. Ahora el stock lleva `CNR_STOCK` —250 objetos
marcados en los seis cofres— y sólo se repone lo marcado. Since 2026-08-28 the
replacement copies no arbitrary locals: the script restores only `CNR_STOCK`,
`CNR_OFICIO` and `CNR_LOOT_TIER`, so module acquisition markers cannot become
part of the chest stock.

**La extractora pagaba el mismo objeto muchas veces.** Buscaba el primer
rompible, lo rompía y volvía a buscar. `DestroyObject` no promete que el objeto
haya desaparecido antes de que acabe el script, así que la búsqueda encontraría
el mismo una y otra vez: hasta cincuenta tandas de esencias por un solo objeto.
Ahora recorre el inventario una vez, cogiendo la referencia siguiente antes de
tocar la actual, que es correcto con cualquiera de las dos semánticas.

Y dos guardas que el motor de oficios tiene y el aplicador no: **seguir en la
mesa** y **tener identidad PWDB** antes de tirar o consumir. Sin la segunda,
alguien cuyo progreso no se guarda quemaría el material sin recibir nada,
porque la escritura de experiencia se rechaza más abajo.

Comprobado además: ningún result set de SQL queda abierto mientras se crean o
destruyen objetos, el diálogo sobrevive al ida y vuelta por `nwn_gff` con sus
enlaces y su script, y los nueve scripts compilan.

---

## Tanda del 2026-08-16 (tarde)

### La marca de rompible

`pb_tesoros_inc.nss`, dentro de `FinalizarObjetoCreado`, pone ahora
`CNR_LOOT_TIER` junto a `CALIDAD_GUARDADA`: rango 2 → tier 1, hasta rango 5 →
tier 4. El gris no lleva marca y no da esencias.

`CnrExt_Tier` lee esa variable y nada más. Consecuencia buscada: **lo que ya
estaba en los cofres de los jugadores no se puede deshacer**, sólo el botín
generado a partir de ahora. Las cuatro muestras del cofre de arcano llevan la
marca a mano (`muestra_tier1` … `muestra_tier4`, antes `muestra_loot9..12`).

### Cuánto se puede meter de golpe en la extractora

**Tres objetos, y si hay más no hace nada.** Al pulsar "Deshacerlo todo" la
máquina cuenta lo que hay dentro; si pasa de tres avisa y no toca nada, en vez
de deshacer una parte y dejar el resto. Así el jugador no se encuentra con la
mochila reventada ni con medio trabajo hecho.

Antes de llegar a ese número, tres cosas hacían cara la tanda grande:

1. **Buscar la esencia costaba lo que el pool.** Cada esencia sorteada recorría
   una cadena `resref;resref;…` entera. Cincuenta objetos titánicos son unas
   400 esencias, y cada una paseaba por medio pool: decenas de miles de
   operaciones de cadena, que es como se llega al límite de instrucciones. El
   pool se guarda ahora indexado en el módulo, una variable por esencia más el
   total, y sortear es una lectura.
2. **El chat escupía una línea por objeto.** Ahora sale un solo resumen: cuántos
   objetos y cuántas esencias.
3. **Las esencias no caben.** `miscsmall3`, `miscsmall2` y `miscthin` tienen
   `Stacking 1` en `baseitems.2da`, así que **cada esencia ocupa una casilla**.
   Veinte objetos titánicos serían unas 160 casillas y no entran en la mochila.
   `CnrExt_Hand` ya lee el `Stacking` real de la fila y reparte en pilas de ese
   tamaño, así que el día que se decida apilar no hay que tocar código.

`CNR_EXT_BATCH_CAP = 3` es el tope, y es un "todo o nada". Si además la mochila
se llena a mitad, `CnrExt_Hand` cuenta lo que no cupo y lo dice en vez de
tragárselo en silencio.

### Probado en juego, y lo que se rompió

**El diálogo no se cerraba nunca.** Elegir "Dejarlo como esta" imprimía el
texto y dejaba la ventana puesta; había que salir con escape. El fallo estaba
en un nombre de campo del `.dlg`: en GFF, **una respuesta enlaza con entradas y
ese campo se llama `EntriesList`**; el fichero llevaba `RepliesList`, que es el
campo de las entradas. El motor no lo encontraba y la conversación ni avanzaba
ni terminaba.

Verificado contra una tienda que funciona hoy, `agujas_hondas.dlg`: la opción
de marcharse es `EntriesList` vacío con `Script` vacío, y la de abrir la tienda
es `EntriesList` vacío con script. La extractora tiene ahora las dos formas,
una por opción. De paso la entrada recibió `Speaker` y el `StartingList` perdió
`IsChild` y `LinkComment`, para que la estructura sea la misma que la de
`cnr_c_craft_it.dlg`.

**Y aun cerrando bien, volvía a abrirse solo.** Elegir cualquiera de las dos
opciones cerraba la conversación y arrancaba otra al instante, una y otra vez.
La causa es el patrón de "esperar al segundo `OnUsed`": cuando la charla
termina, el motor acaba de procesar el uso que tenía en cola, eso abre y cierra
el contenedor, y ese par de eventos es justo el que lanza la conversación.

Se corta sellando la máquina **al salir** y no al entrar. `CnrExt_Seal`, en el
include, la deja sorda seis segundos y borra el medio ciclo que el jugador
lleva encima; las dos opciones del diálogo la llaman —`cnr_ext_break` después
de romper y `cnr_ext_leave`, nuevo, sin hacer nada más—, igual que las tiendas
ponen script también en la opción de marcharse. Los eventos del rebote llegan
dentro de esos segundos y se tiran.

El candado que había antes se ponía al abrir la conversación y duraba cuatro
segundos: si el jugador tardaba más en leer, ya había expirado cuando llegaba
el rebote.

**El diálogo se repetía.** Al elegir "Dejarlo como esta" la conversación volvía
a empezar sola. La causa no estaba en el `.dlg`, que termina bien: la acción de
*usar* el contenedor seguía en la cola del jugador, así que al acabar la charla
el motor terminaba de abrir la máquina, y ese par de eventos —abrir y cerrar—
es justo el que lanza la conversación. Ahora `cnr_ext_ou` hace
`ClearAllActions` antes de hablar y pone un candado de cuatro segundos en la
máquina para lo que llegue tarde.

**Los desplegables no abrían.** Con el objeto puesto, el de propiedad enseñaba
`-- HABILIDAD` y al pulsarlo no salía nada. Eran ciento veinte entradas con las
cabeceras de familia compartiendo todas el valor 0, que es lo que un combo usa
para distinguir sus entradas. Rehecho en tres pasos encadenados —**familia**,
**propiedad**, **poder**—, cada entrada con valor propio y ninguna lista de más
de veinte líneas. El nivel sale entre corchetes solo en lo que aún no puedes
hacer, así que la lista normal se lee como una lista de nombres.

**El cuadro de aviso pisaba los botones.** Crecía hasta comerse la fila de
Encantar. Ahora tiene alto propio y lo que sobra se lo lleva un separador.

### Pendiente que sale de aquí

- [ ] **Decidir si las esencias deben apilar.** Hoy no apilan. Aparcado a
      propósito: no es el momento. Cuando toque, hay dos caminos —subir
      `Stacking` en las filas 79 `miscthin`, 211 `miscsmall3` y 311
      `miscsmall2` de `haks-2da/baseitems.2da`, que es una línea por fila pero
      alcanza a cualquier objeto del servidor de esos tipos y obliga a
      reempaquetar el hak; o pasar los 135 blueprints al tipo `gem`, que ya
      apila 10, repasando iconos y las copias que están dentro de los cofres.
- [ ] Repasar en juego que el botín nuevo trae `CNR_LOOT_TIER`.

### La tabla de suelta, rebalanceada

La primera tabla daba, por cada titánico roto, 2,16 esencias de tier 1 y 2,70
de tier 2 contra 0,50 de tier 3 y 0,25 de tier 4: **el 87% de lo que salía del
mejor objeto del juego era material bajo**. Y el tope de 3 estaba puesto en el
tier 1 y no en el 2, así que un titánico daba más material de tier 2 que de
tier 1, al revés de lo que tocaba.

La tabla nueva, ya en `CnrExt_Break`:

| Objeto roto | Tier 1 | Tier 2 | Tier 3 | Tier 4 |
|---|---|---|---|---|
| Azul claro | 1d3, 60% | — | — | — |
| Azul oscuro | 1d3, 50% | 1d3, 60% | — | — |
| Legendario | 1d3, 50% | 1d3, 50% | 1d2, 20% | — |
| Titánico | 1d4, 50% | 1d3, 60% | 1d2, 35% | 1d2, 17% |

| Objeto roto | T1 | T2 | T3 | T4 | Total |
|---|--:|--:|--:|--:|--:|
| Azul claro | 1,20 | — | — | — | 1,20 |
| Azul oscuro | 1,00 | 1,20 | — | — | 2,20 |
| Legendario | 1,00 | 1,00 | 0,30 | — | 2,30 |
| Titánico | 1,25 | 1,20 | 0,53 | 0,26 | 3,23 |

Las tasas que se conservaron a propósito, porque eran las que se querían:
**3,9 titánicos por una esencia titánica**, y esos cuatro dejan de paso ~2 de
tier 3; **3,3 legendarios por una esencia legendaria**. Lo que se cortó a la
mitad es el material bajo que salía de los objetos altos.

Fuera también el tope: con dados de 1d2 a 1d4 no hacía nada, y `CnrExt_Roll`
perdió el parámetro.

### Lo que sigue abierto de balance

- [ ] **La variedad de esencias de tier 1 y 2.** Hay 54 esencias distintas en
      tier 1 y 21 en tier 2, una por propiedad, y cada receta pide varias
      unidades de **una concreta**. Con 1,20 esencias de tier 1 por objeto
      repartidas entre 54 tipos, una unidad concreta sale 1 de cada 45 objetos,
      y un +3 pide tres. En tier 4, con 8 tipos, una unidad concreta sale 1 de
      cada 31 titánicos: **el material común cuesta lo mismo que el titánico**.
      La salida es de datos, no de código: agrupar las esencias por familia
      (una por sección, ~8 en vez de 54) en la columna `material` de
      `arcano.json` y regenerar el SQL. Sin decidir.

### Espadas y escudos que no se podían fabricar

Reportado en juego: tirada 24 contra DC 14, se cobran el lingote de acero y
168 monedas, y sale *"Error al crear el objeto. Avisa a un DM."*

Las 15 recetas de espada larga apuntaban a `wswls002` y las 23 de escudo grande
a `ashlw002`. **Ninguno de los dos existe**, ni en el módulo ni en el juego
base, ni con el prefijo `nw_` ni sin él; comprobado con `nwn_resman_extract`.
Los buenos son `nw_wswls001` (espada larga, base 1) y `nw_ashlw001` (escudo
grande, base 56), los dos vanilla y sin propiedades.

Corregido en el origen —`migration/catalogue/cnranvilsmith.json` y
`cnrcarpsbench.json`— y regenerado `03_catalogue.sql` con `build_catalogue.py`.
Nunca a mano sobre el SQL.

Auditados de paso los 137 `base_resref` y los 8 `extra_resref` del catálogo:
los 122 propios existen como `.uti` en `src/`, los 15 vanilla se extrajeron del
juego para comprobarlo, y ningún `.uti` tiene un `TemplateResRef` distinto de
su nombre de fichero. No queda ninguna otra receta rota.

**Y la causa de que doliera**: el objeto se creaba después de cobrar. Ahora
`CnrCraft_Start` hace una prueba —crea el blueprint en la estación y lo
destruye— **antes de tocar el oro**, y si no existe avisa diciendo que no se ha
gastado nada. Un fallo de datos ya no le cuesta el material a nadie.

### La ventana, repasada

Lo que tenía y estaba flojo: dos desplegables sin etiqueta, el coste escondido
en un párrafo del panel derecho, el botón Encantar siempre activo (te enterabas
de que faltaba material *después* de pulsarlo), y el botón "Ver todas" mentía al
reabrir la ventana porque el estado se guardaba en el jugador y el rótulo no.

Cómo está ahora:

- **Cabecera** con el objeto que hay dentro y tu nivel de arcano, en su grupo.
- **Etiquetas** sobre cada desplegable, "Propiedad" y "Poder", con su tooltip.
  El de poder dice las esencias que cuesta cada escalón en el propio texto de la
  entrada.
- **Caja de coste**, tres líneas alineadas de verdad (etiqueta a la izquierda,
  valor a la derecha, no espacios): esencia `3 de 5`, cristal `1 de 2` y
  **probabilidad de éxito**, en verde o rojo según llegues o no.
- **Encantar se apaga** mientras falte algo — objeto, nivel, poder o material —
  y se enciende solo. Sigue siendo cortesía: el aplicador revalida todo.
- **Panel derecho** con borde y barra de desplazamiento, y con lo que antes no
  decía: que el material se gasta salga bien o mal, y que al fallar el objeto
  no se rompe.
- **La selección ya no se desincroniza**: si cambias el objeto de la mesa o el
  filtro y la propiedad elegida deja de estar en la lista, se suelta la
  elección en vez de dejar el desplegable en blanco describiendo algo que ya no
  se puede hacer.

La probabilidad sale de la misma tirada que usa el aplicador: `d20 + bono` con
20 natural siempre acierto y 1 natural siempre fallo.

---

## Decisiones tomadas, para no volver sobre ellas

- **Arcano no usa `cnr_recipe`.** Tablas propias, porque el motor CNR crea
  objetos por `base_resref` y arcano modifica uno existente.
- **Sin recetas**: la ventana arma la petición y el aplicador la revalida.
- **Filtro por tipo de objeto base**, no por lista de resrefs, más
  `CNR_OFICIO > 0` y no estar encantado.
- **Los escalones son filas**, no una fórmula, porque las escaleras no son
  uniformes.
- **La experiencia va en el escalón** y sube con lo gastado.
- **MySQL**, como el resto del sistema. Nada de SQLite.

---

## Abierto, y hay que decidirlo antes de terminar

1. ~~**Qué esfera concede el hueco de conjuro.**~~ Cerrado: lo dice el diseño
   y ya está en los datos. `cnr_arcane_step` guarda esfera 6 para los
   lanzadores completos y 3 para el resto, sacado de la columna `maximo` del
   JSON.
2. **El camino "modificar, no crear"**: si vive dentro del motor CNR o aparte.
3. **Los parámetros de los efectos al golpear** están puestos como los del
   loot — veneno 0, hiriente 1, el resto 2 — sin que nadie lo haya decidido.
