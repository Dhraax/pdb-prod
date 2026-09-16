# Una receta por material, no por arma

**Hecho el 2026-08-17.** Lo que sigue es el plan tal como se escribió, y al
final está lo que se desvió de él. La documentación de referencia es
[`base-items.md`](base-items.md) para las armas,
[`crafting-system.md`](crafting-system.md) §4b para el menú y
[`schema.md`](schema.md) para las tablas.

---

## 1. El problema

El bulk de armas dejó 731 recetas nuevas: 47 armas × 15 metales, más nunchaku y
honda × 8 maderas, más el látigo × 10 cueros. El catálogo pasó de 495 a 1226
filas.

Y son todas la misma receta. Entre "Daga de acero" y "Maza de acero" no cambia
nada: mismo lingote, mismo molde, mismo nivel, la misma dificultad, la misma
experiencia, el mismo oro y **las mismas propiedades**, porque las propiedades
las da el metal y no el objeto.

Lo único que depende del arma es el daño opuesto, y eso ya se calcula en el
código al crear el objeto, mirando el arma. No hace falta una fila por arma
para eso.

## 2. Lo que se hace en su lugar

Una receta por material, con una lista de **variantes** de producto que el
jugador elige antes de fabricar.

| Oficio | Antes | Después |
|---|--:|--:|
| Herrería, armas | 705 | 15 recetas × 47 variantes |
| Carpintería, armas | 16 | 8 recetas × 2 variantes |
| Peletería, látigo | 10 | 10 (se quedan como están: una sola arma) |

Catálogo: **1226 → 528 filas**. El menú deja de tener 47 submenús de quince
entradas y pasa a tener uno de quince más un selector de arma.

## 2 bis. El resto del catálogo tiene el mismo patrón

Medido sobre las 495 recetas anteriores al bulk, agrupando por material,
propiedades, dificultad, experiencia y componentes sin contar el molde:

| Estación | Recetas | Colapsables | Quedarían |
|---|--:|--:|--:|
| cnrAnvilSmith | 120 | 71 | 49 |
| cnrCarpsBench | 79 | 46 | 33 |
| cnrTailorsTable | 70 | 43 | 27 |
| cnrJewelersBench | 90 | 29 | 61 |
| cnrSewingTable | 30 | 13 | 17 |
| cnrAlchemyTable | 65 | 2 | 63 |
| cnrCuringTub, cnrForgePublic, cnrHebCauldron, cnrSawTable | 41 | 0 | 41 |
| **Total** | **495** | **204** | **291** |

El caso más claro es la herrería: para cada metal, el escudo grande, el escudo
pequeño, el pavés, el yelmo, la armadura completa y la cota de escamas son la
misma receta con distinto producto y distinto molde. Seis filas por metal, y
noventa en total, que serían quince.

Por eso la tabla de variantes se define con un `group_code` genérico y no con
nada específico de armas: el mecanismo sirve para todo el catálogo.

**La migración va por etapas, no de golpe:**

1. Las armas del bulk, que es lo que sobra ahora mismo y no tiene a nadie
   usándolo: 731 filas a 23.
2. Con el mecanismo ya probado en juego, los grupos de la herrería y la
   carpintería que existían de antes.
3. Peletería, sastrería y joyería al final, que es donde las propiedades
   dependen del tipo de producto y hay que mirar cada grupo antes de tocarlo.

Nada de la etapa 2 y 3 se toca hasta que la 1 esté validada por los testers.

## 3. Modelo de datos

Tabla nueva, en `migration/01_schema.sql`:

```sql
CREATE TABLE cnr_variant (
  variant_id   INT          NOT NULL AUTO_INCREMENT,
  group_code   VARCHAR(32)  NOT NULL,   -- 'smith_weapon', 'wood_weapon'
  base_resref  VARCHAR(16)  NOT NULL,   -- cnr_b_dagger
  display_name VARCHAR(64)  NOT NULL,   -- 'Daga'
  sort_order   INT          NOT NULL DEFAULT 0,
  PRIMARY KEY (variant_id),
  KEY idx_variant_group (group_code, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Y una columna en `cnr_recipe`:

```sql
variant_group VARCHAR(32) NULL   -- NULL = producto fijo, como hasta ahora
```

Una receta con `variant_group` no usa su `base_resref` como producto: usa el de
la variante elegida. Se le deja igualmente un `base_resref` válido, el de la
primera variante del grupo, para que ninguna consulta antigua reciba un vacío.

**El resref es el índice**, como pediste: la variante se resuelve por
`variant_id` y de ahí sale el `base_resref` que crea el objeto. El cliente
nunca envía un resref.

**Ordering note — 2026-08-20.** That fallback is assigned in
`build_catalogue.py` before any recipe row is serialized. It used to be assigned
afterwards, so the mutation never reached the emitted SQL; nobody noticed
because the sources happen to name the same resref as the first variant of the
group. The first time a variant list was reordered, the catalogue would have
shipped the wrong fallback in silence. Reordering the first variant of a group
now changes the emitted `base_resref` with it, which is how the fix was
verified.

## 4. Cambios de código, fichero a fichero

### `cnr_i_craft.nss`

- Constante nueva `CNR_VAR_VARIANT = "CNR_VARIANT_ID"`, la elección del jugador,
  guardada en el PC como todo lo demás del menú.
- `CnrCraft_SelectRecipe` lee también `variant_group` y lo guarda; al cambiar de
  receta se borra la variante elegida.
- Función nueva `CnrCraft_ResolveProduct(oPC, nRecipe)`: devuelve el resref y el
  nombre del producto.
  - Sin `variant_group`: los de la receta, como hoy.
  - Con `variant_group`: **una consulta que une variante y receta**, para que la
    variante tenga que pertenecer al grupo de esa receta. Si no pertenece, o no
    hay ninguna elegida, se rechaza el intento antes de cobrar nada.
- `CnrCraft_Start` llama a esa función y usa lo que devuelve, tanto para la
  prueba del blueprint que ya se hace antes de cobrar como para pasarle el
  resref a `CnrCraft_Finish`.
- El nombre del producto se compone `"<variante> de <material>"`, sacando el
  material de `cnr_material.display_name` por el `material_id` de la receta.

### El menú, en el diálogo de estación

- Un paso más entre elegir receta y fabricar, sólo cuando la receta tiene grupo:
  la lista de variantes, paginada con el mismo mecanismo de `CNR_VAR_ITEM` que
  usan categorías y productos.
- `cnr_a_pick` distingue tres niveles en vez de dos: categoría, receta,
  variante.
- La pantalla de detalle muestra el arma elegida, y **Crear no se ofrece hasta
  que hay una**.
- Un nodo de condición nuevo, al estilo de `cnr_c_prod`, para decidir cuándo se
  enseña la lista de variantes.

### `cnr_i_prop.nss` y `cnr_apply_prop.nss` — el daño opuesto

Hoy `CnrProp_GetWeaponPhysicalType` devuelve un solo tipo y, cuando el arma
tiene dos, se queda con el primero que declara el 2DA. Eso da el fallo que
señalaste: una espada corta es perforante **y** cortante, el código ve
perforante, y el opuesto que calcula es cortante, que el arma ya tiene.

Regla nueva, en código y no en la base de datos:

| `WeaponType` en `baseitems.2da` | Daño del arma | Opuesto que se aplica |
|---|---|---|
| 1 | perforante | cortante |
| 2 | contundente | perforante |
| 3 | cortante | contundente |
| 4 | perforante y cortante | **contundente** |
| 5 | contundente y perforante | **cortante** |

Es decir: con un solo tipo se rota cortante → contundente → perforante →
cortante; **con dos tipos se aplica el tercero**, el que le falta. Once armas
del servidor están en ese caso.

Las dos copias de la función tienen que quedar idénticas: `build_catalogue.py`
compara los cuerpos y aborta si difieren.

### Saneamiento de consultas

Se repasan todas las de `cnr_i_craft.nss` y las nuevas:

- Todo por `NWNX_SQL_Prepared*`. Ningún valor que venga del jugador concatenado
  a una consulta.
- Ningún result set abierto mientras se crean o destruyen objetos: se leen los
  datos a variables primero, como ya hace el resto del fichero.
- Cada consulta que decide algo comprueba **estación y receta a la vez**, que es
  lo que impide fabricar en una mesa lo de otra.
- La consulta de la variante une contra la receta: no basta con que el
  `variant_id` exista.

## 5. Migración del catálogo

- `migration/catalogue/cnranvilsmith.json`: se borran las 705 recetas de arma y
  se dejan las quince del metal con su `variant_group`.
- `migration/catalogue/cnrcarpsbench.json`: igual con las 16.
- Fichero nuevo `migration/catalogue/variants.json` con las 49 variantes, que es
  lo que genera la tabla. Son 50 desde el 2026-08-27: la daga de hechicería
  (`cnr_b_sdagger`, base 514) entró al grupo para que la mesa arcana pudiera
  aceptarla, y añadir un producto al grupo no crea ninguna receta ni mueve un
  solo `public_id`.
- `build_catalogue.py` emite `cnr_variant` y la columna nueva, y se actualizan
  las tres guardas de inventario que ya se tocaron para el bulk.
- Se comprueba, como con el bulk, que **las 495 recetas anteriores no cambian
  ni un valor**, propiedades incluidas.

## 6. Qué hay que probar

1. Fabricar un arma de cada familia y mirar que sale el objeto correcto con el
   nombre correcto.
2. Una espada corta de adamantita: el daño opuesto tiene que ser contundente.
3. Una maza de adamantita: perforante.
4. Elegir receta, no elegir arma y darle a crear: tiene que rechazar sin cobrar.
5. Cambiar de receta después de elegir arma: la elección se suelta.
6. Que las recetas de siempre —armaduras, escudos, munición, joyería— siguen
   funcionando igual.

## 7. Documentación que se reescribe al terminar

Esto es parte del trabajo, no un añadido:

- **`base-items.md`**: la sección del bulk se sustituye por la del modelo de
  variantes, con la tabla de recetas actualizada.
- **`crafting-system.md`**: el recorrido del menú pasa a tener tres niveles;
  hay que rehacer esa parte y documentar `cnr_variant` y `variant_group`.
- **`schema.md`**: la tabla nueva y la columna nueva.
- **`plan-de-pruebas.md`**: los testers necesitan saber que ahora se elige el
  arma después de la receta.
- **`open-issues.md`**: cerrar lo que este cambio cierre y anotar lo que deje
  abierto, como el molde único.
- **Este documento**: pasa de plan a registro de lo hecho, con lo que se
  desviara del plan.
- **`AGENTS.md`**: si el modelo de variantes se vuelve la forma normal de
  añadir productos, la regla de `base-items.md` tiene que decirlo.

---

## 8. Lo que se desvió del plan

- **La espada larga y la clava se convirtieron en variantes**, no sólo las
  armas nuevas. Sus recetas pasaron a llamarse "Arma de \<metal\>" y "Arma de
  mano de \<madera\>", y ellas son la primera variante de su grupo. Eran ya la
  misma receta que las demás; dejarlas aparte habría sido mantener dos modelos.
- **Los látigos se quedaron como diez recetas propias**, como decía el plan, y
  sin propiedades, porque las de peletería se buscan por tipo de prenda.
- **El menú no necesitó una pantalla nueva de cero**: la de productos es la de
  recetas con otro texto y otra condición, y las respuestas de lista, la
  paginación y el volver funcionan sin tocarlos.
- **`CnrProp_GetWeaponPhysicalType` y `CnrProp_GetOppositePhysical` siguen
  existiendo** pero ya no las usa la rama del daño opuesto: la sustituye
  `CnrProp_GetOppositeDamage`, que mira el arma entera en vez de un solo tipo.
- Medir el catálogo reveló que **88 recetas más tienen el mismo patrón**, casi
  todas de herrería. No se han tocado: están en `open-issues.md` como etapa
  siguiente, junto con lo que falta para poder hacerlo — que la variante pueda
  pedir su propio molde. La primera medición dijo 204 porque contaba peletería
  y sastrería sin leer sus componentes; allí las prendas sí difieren.
