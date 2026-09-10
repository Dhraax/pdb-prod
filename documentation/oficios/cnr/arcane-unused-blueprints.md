# Arcano — blueprints sin uso

Los `cnr_esen*` / `cnr_cristal*` que hay en paleta y **ningún material del diseño reclama**,
una vez `arcano.json` quedó emparejado con la paleta por `material_resref`.

**No se borra nada todavía.** Esta lista existe para tenerlos localizados; el
borrado va al final, cuando el oficio esté montado y probado en juego. Hasta
entonces cualquiera de ellos puede acabar teniendo sitio.

De los 133 blueprints `cnr_esen*` / `cnr_cristal*`, el diseño usa **95** y sobran **38**.

Antes de borrar, comprobar por cada uno: que ninguna receta del catálogo lo
nombre, que no esté colocado en ningún contenedor ni tienda, y que no lo cite
ningún script ni diálogo.


## Efectos al golpear (4)

Lo que queda de la familia `efe*` una vez repartidos los cinco efectos que estaban sin material.

| Name | tag | resref |
|---|---|---|
| Concentración de diablo astado | `cnr_esen96` | `cnr_esen96` |
| Órbita ocular de grimórlock | `cnr_esen97` | `cnr_esen97` |
| Crueldad de lamia | `cnr_esen98` | `cnr_esen98` |
| Estallido de diablo de la sima | `cnr_esen99` | `cnr_esen99` |

## Polvos de escuela (8)

Las ocho escuelas de magia. El CSV no los menciona.

| Name | tag | resref |
|---|---|---|
| Polvo de abjuración | `cnr_esen118` | `cnr_esen118` |
| Polvo de conjuración | `cnr_esen119` | `cnr_esen119` |
| Polvo de adivinación | `cnr_esen120` | `cnr_esen120` |
| Polvo de encantamiento | `cnr_esen121` | `cnr_esen121` |
| Polvo de evocación | `cnr_esen122` | `cnr_esen122` |
| Polvo de ilusión | `cnr_esen123` | `cnr_esen123` |
| Polvo de nigromancia | `cnr_esen124` | `cnr_esen124` |
| Polvo de transmutación | `cnr_esen125` | `cnr_esen125` |

## Fragmentos de gólem de gema (7)

Siete gemas. El CSV no los menciona.

| Name | tag | resref |
|---|---|---|
| Fragmento de gólem de zafiro | `cnr_esen100` | `cnr_esen100` |
| Fragmento de gólem de topacio | `cnr_esen101` | `cnr_esen101` |
| Fragmento de gólem de amatista | `cnr_esen102` | `cnr_esen102` |
| Fragmento de gólem de rubí | `cnr_esen103` | `cnr_esen103` |
| Fragmento de gólem de esmeralda | `cnr_esen104` | `cnr_esen104` |
| Fragmento de gólem de citrino | `cnr_esen105` | `cnr_esen105` |
| Fragmento de gólem de diamante | `cnr_esen106` | `cnr_esen106` |

## Habilidades (5)

Restos de la sección de habilidades una vez reducida a 28 filas. Tres de los
que sobraban ahí se reutilizaron para los huecos de conjuro de las clases
propias del servidor.

| Name | tag | resref |
|---|---|---|
| Luz carmesí de liche | `cnr_esen107` | `cnr_esen107` |
| Locura de derro | `cnr_esen108` | `cnr_esen108` |
| Pinzas de glabrezu | `cnr_esen109` | `cnr_esen109` |
| Contrato de kolyarut | `cnr_esen111` | `cnr_esen111` |
| Pata zancuda de aquerena | `cnr_esen110` | `cnr_esen110` |

## Limitadores (4)

Cinco criaturas. El CSV no los menciona.

| Name | tag | resref |
|---|---|---|
| Armazón de siv | `cnr_esen113` | `cnr_esen113` |
| Cáscara de batraco | `cnr_esen114` | `cnr_esen114` |
| Plumas de aarakocra | `cnr_esen115` | `cnr_esen115` |
| Corteza de árbol oscuro | `cnr_esen116` | `cnr_esen116` |

## Cristales urdímbricos (2)

Los seis del diseño existen ya: Quimera y Leviatán se renombraron a Hada y Dragón, y se crearon Contemplador (`poten5`) y Sombra (`poten6`). Estos dos quedan sin reclamar.

| Name | tag | resref |
|---|---|---|
| Cristal urdímbrico de Nishruu | `cnr_cristal1` | `cnr_cristal1` |
| Cristal urdímbrico de Fénix | `cnr_cristal2` | `cnr_cristal2` |

## Sueltos (8)

Uno por concepto. El sufijo del resref dice para qué se pensó cada uno.

| Name | tag | resref |
|---|---|---|
| Cuerno de behir | `cnr_esen94` | `cnr_esen94` |
| Cataclismo de tarasca | `cnr_esen95` | `cnr_esen95` |
| Belleza sobrenatural de clangarconte | `cnr_esen112` | `cnr_esen112` |
| Aletas de locathah | `cnr_esen117` | `cnr_esen117` |
| Brasas de azer | `cnr_esen126` | `cnr_esen126` |
| Restos de un objeto | `cnr_esen127` | `cnr_esen127` |
| Vial para infusión de conjuro | `cnr_esen128` | `cnr_esen128` |
| Derribo de sabueso yez | `cnr_esen129` | `cnr_esen129` |

---

**Total: 38.**

Los grupos `polvo`, `gemco`, `lim`, `vial` y `rotura` no parecen sobras
sueltas sino un sistema entero que el CSV no recoge — escuelas de magia,
limitadores, viales de infusión y rotura al fallar. Conviene averiguar si
formaban parte del diseño de arcano antes de darlos por muertos.
