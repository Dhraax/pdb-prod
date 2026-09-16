# Arcano — blueprints sin uso

Los `cnr_e_*` / `cnr_c_*` que hay en paleta y **ningún material del diseño reclama**,
una vez `arcano.json` quedó emparejado con la paleta por `material_resref`.

**No se borra nada todavía.** Esta lista existe para tenerlos localizados; el
borrado va al final, cuando el oficio esté montado y probado en juego. Hasta
entonces cualquiera de ellos puede acabar teniendo sitio.

De los 133 blueprints `cnr_e_*` / `cnr_c_*`, el diseño usa **95** y sobran **38**.

Antes de borrar, comprobar por cada uno: que ninguna receta del catálogo lo
nombre, que no esté colocado en ningún contenedor ni tienda, y que no lo cite
ningún script ni diálogo.


## Efectos al golpear (4)

Lo que queda de la familia `efe*` una vez repartidos los cinco efectos que estaban sin material.

| Name | tag | resref |
|---|---|---|
| Concentración de diablo astado | `cnr_e_96` | `cnr_e_96` |
| Órbita ocular de grimórlock | `cnr_e_97` | `cnr_e_97` |
| Crueldad de lamia | `cnr_e_98` | `cnr_e_98` |
| Estallido de diablo de la sima | `cnr_e_99` | `cnr_e_99` |

## Polvos de escuela (8)

Las ocho escuelas de magia. El CSV no los menciona.

| Name | tag | resref |
|---|---|---|
| Polvo de abjuración | `cnr_e_118` | `cnr_e_118` |
| Polvo de conjuración | `cnr_e_119` | `cnr_e_119` |
| Polvo de adivinación | `cnr_e_120` | `cnr_e_120` |
| Polvo de encantamiento | `cnr_e_121` | `cnr_e_121` |
| Polvo de evocación | `cnr_e_122` | `cnr_e_122` |
| Polvo de ilusión | `cnr_e_123` | `cnr_e_123` |
| Polvo de nigromancia | `cnr_e_124` | `cnr_e_124` |
| Polvo de transmutación | `cnr_e_125` | `cnr_e_125` |

## Fragmentos de gólem de gema (7)

Siete gemas. El CSV no los menciona.

| Name | tag | resref |
|---|---|---|
| Fragmento de gólem de zafiro | `cnr_e_100` | `cnr_e_100` |
| Fragmento de gólem de topacio | `cnr_e_101` | `cnr_e_101` |
| Fragmento de gólem de amatista | `cnr_e_102` | `cnr_e_102` |
| Fragmento de gólem de rubí | `cnr_e_103` | `cnr_e_103` |
| Fragmento de gólem de esmeralda | `cnr_e_104` | `cnr_e_104` |
| Fragmento de gólem de citrino | `cnr_e_105` | `cnr_e_105` |
| Fragmento de gólem de diamante | `cnr_e_106` | `cnr_e_106` |

## Habilidades (5)

Restos de la sección de habilidades una vez reducida a 28 filas. Tres de los
que sobraban ahí se reutilizaron para los huecos de conjuro de las clases
propias del servidor.

| Name | tag | resref |
|---|---|---|
| Luz carmesí de liche | `cnr_e_107` | `cnr_e_107` |
| Locura de derro | `cnr_e_108` | `cnr_e_108` |
| Pinzas de glabrezu | `cnr_e_109` | `cnr_e_109` |
| Contrato de kolyarut | `cnr_e_111` | `cnr_e_111` |
| Pata zancuda de aquerena | `cnr_e_110` | `cnr_e_110` |

## Limitadores (4)

Cinco criaturas. El CSV no los menciona.

| Name | tag | resref |
|---|---|---|
| Armazón de siv | `cnr_e_113` | `cnr_e_113` |
| Cáscara de batraco | `cnr_e_114` | `cnr_e_114` |
| Plumas de aarakocra | `cnr_e_115` | `cnr_e_115` |
| Corteza de árbol oscuro | `cnr_e_116` | `cnr_e_116` |

## Cristales urdímbricos (2)

Los seis del diseño existen ya: Quimera y Leviatán se renombraron a Hada y Dragón, y se crearon Contemplador (`poten5`) y Sombra (`poten6`). Estos dos quedan sin reclamar.

| Name | tag | resref |
|---|---|---|
| Cristal urdímbrico de Nishruu | `cnr_c_1` | `cnr_c_1` |
| Cristal urdímbrico de Fénix | `cnr_c_2` | `cnr_c_2` |

## Sueltos (8)

Uno por concepto. El sufijo del resref dice para qué se pensó cada uno.

| Name | tag | resref |
|---|---|---|
| Cuerno de behir | `cnr_e_94` | `cnr_e_94` |
| Cataclismo de tarasca | `cnr_e_95` | `cnr_e_95` |
| Belleza sobrenatural de clangarconte | `cnr_e_112` | `cnr_e_112` |
| Aletas de locathah | `cnr_e_117` | `cnr_e_117` |
| Brasas de azer | `cnr_e_126` | `cnr_e_126` |
| Restos de un objeto | `cnr_e_127` | `cnr_e_127` |
| Vial para infusión de conjuro | `cnr_e_128` | `cnr_e_128` |
| Derribo de sabueso yez | `cnr_e_129` | `cnr_e_129` |

---

**Total: 38.**

Los grupos `polvo`, `gemco`, `lim`, `vial` y `rotura` no parecen sobras
sueltas sino un sistema entero que el CSV no recoge — escuelas de magia,
limitadores, viales de infusión y rotura al fallar. Conviene averiguar si
formaban parte del diseño de arcano antes de darlos por muertos.
