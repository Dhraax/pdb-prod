# Joyería

Estado 2026-08-14: **implementado y aplicado a la base de datos de DEV**. Sin
validar en juego.

El oficio son tres pasos y tres escalones. La cadena de producción está
construida; lo que queda es jugarla.

Compañero: [`jewellery-exported-items.md`](jewellery-exported-items.md), la
lista de los 99 blueprints que salieron de `contenedor_engar`.

---

## 1. La cadena

```
JOYERÍA   1 cilindro tratado    ->  <metal>_aro / <metal>_cadena      (6 recetas)
JOYERÍA   bru_<gema>            ->  cnr_<gema>  [+ polvo_<gema>]     (28 recetas)
JOYERÍA   aro/cadena + cnr_<gema> -> anillo_<gema> / amu_<gema>      (56 recetas)
```

90 recetas, todas en `cnrJewelersBench`.

**El joyero no depende de ningún otro oficio.** Los aros y cadenas se hacían
en el yunque a partir de lingotes, lo que obligaba a tener Herrería; ahora
salen del propio banco a partir de *Cilindro de cobre / oro / platino tratado*,
que se compran en tienda.

| Herramienta | Alcance | Modo | Rotura |
|---|---|---|---|
| `tall_kittall` | sólo la categoría **Tallado** | inventario | 4% |

Tallar exige el kit; engarzar no. Es el único caso del sistema donde una
herramienta se limita a una categoría, y para eso existe
`cnr_station_tool.category_id`.

---

## 2. El metal es estético; el tier es lo que manda

Todas las piezas salen **vacías**: la propiedad la pone siempre la gema, nunca
el aro. Por eso el metal no da nada y se usa como **puerta de progresión**.

| Tier | Metal | Gemas | DC |
|---|---|---:|---|
| 1 | cobre (`bronce_*`) | 10 | 10–18 |
| 2 | oro | 9 | 19–27 |
| 3 | platino | 9 | 28–35 |

La plata desapareció del oficio como metal, pero **ninguna gema se perdió**:
las 28 conservan su anillo y su colgante.

### Reparto deliberado

Las gemas están mezcladas para que **ningún tier entregue una familia
completa**:

| Familia | Cobre | Oro | Platino |
|---|---|---|---|
| Salvaciones (8) | Frío, Ácido, Fuego | Eléctrico, Energía Positiva, Muerte | Enajenadores, Universal 2 |
| Conjuros (10) | Bardo 2, Bardo 3+4, Hechicero 4, Druida 4 | Clérigo 4, Mago 4 | las cuatro de Esfera 6 |
| Inmunidades (5) | Fuego, Ácido | Eléctrico, Frío | Cortante |
| CA (3) | CA 3 | CA 4 | CA 5 |
| Únicas | — | Resistencia Conjuros 18 | Regeneración 1 |

Consecuencias buscadas: ninguna clase lanzadora se completa dentro de un tier
—Bardo empieza en cobre y su Esfera 6 no existe, Clérigo y Mago no aparecen
hasta oro—, las cuatro inmunidades elementales están 2 y 2 entre cobre y oro,
y la CA sube exactamente un punto por escalón.

**El tier va escrito por gema en `documentation/oficios/joyeria.json`**, no se
deriva de la posición en el fichero. Antes salía de `índice // 7`, y con eso
reordenar el fichero recolocaba las gemas sin avisar. El generador rechaza
cualquier tier que no sea 1, 2 o 3.

---

## 3. Las propiedades viven en `joyeria.json`

Cada gema lleva sus filas explícitas — `type`, `subtype`, `value1`, `value2` —
junto al texto de diseño que implementan. **No se leen del archivo legacy**,
que tenía ocho de las diez clases lanzadoras mal.

`BonusLevelSpell`: `subtype` es la clase (`iprp_classes`: Bardo 1, Clérigo 2,
Druida 3, Hechicero 9, Mago 10), `value1` la esfera y **`value2` cuántos huecos
de esa esfera**. Una gema que da dos esferas distintas lleva dos filas — es el
caso de Piedra pícara, Esfera 3 y Esfera 4.

Las cinco inmunidades usan índice `8` de `iprp_immuncost.2da`, que es **20%** y
lo aporta `pb_2da_v9.hak`. No está en `nwscript.nss`: el 2DA manda sobre las
constantes del juego base, y éste es el único de esas tablas que el servidor
extiende. Ver
[`material-properties-reference.md`](material-properties-reference.md) §2.5.

---

## 4. Identidad propia de las gemas talladas

Las 28 talladas son `cnr_<gema>` en tag y en resref. Los componentes casan por
tag, así que eso es lo que impide que una receta de anillo se cumpla con una
piedra que no sea nuestra. Nada vanilla usaba los nombres anteriores `pu_*`
—comprobado contra los ficheros key del juego y los 60 haks—, así que es una
convención hecha explícita, no una colisión arreglada.

Una pieza engarzada se marca con `CNR_ENGARZADO` al crearse, y tanto el
recuento como el consumo de materiales ignoran cualquier objeto marcado: una
joya terminada no vuelve a ser material de nada.

---

## 5. Lo que queda

- **Validar en juego.** Nada de esto se ha jugado.
- **Las ocho `gema_*`.** Duplicados caros (1200–1500 po frente a 145) de las
  ocho piedras que sueltan arenilla. No las produce ni las consume nadie. Si
  son una talla fina, es diseño por añadir.

La marca `CNR_ENGARZADO` de §4 nació pensando en engarzar objetos de Herrería.
Esa idea está **aparcada**; la marca se queda porque por sí sola ya impide que
una joya terminada vuelva a contar como material.
