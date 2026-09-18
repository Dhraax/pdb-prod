# Inventario de desollado: que suelta cada criatura

## Current implementation - existing corpse, 2026-09-18

Skinning now marks the original dead creature instead of creating `cnr_cadaver`.
Its appearance, inventory and loot remain owned by the existing corpse system.
`zep_goblin` (ordinary) and `bandidocacique` (boss), neither carrying PIEL, were
used as source comparisons; the goblin appears in the encounter lists in
`src/module/git/wel_cc_cueva.git.json`. `nw_c2_default7` calls
`corpse_InitializeCorpse`,
and the JEFAZO branch separately creates `cofreboss`. Those loot/quest and boss
branches are unchanged. Historical September-13 behavior below is superseded.

A valid PIEL initializes material, tier and three deliveries on that same
creature and installs `cnr_skin_hit` through its melee-attacked event. The
previous handler is preserved and delegated to if the creature is raised.
Depleting skins does not destroy the corpse or its loot. Emptying the bodybag
also keeps the corpse selectable while hides remain; existing decay still owns
its lifetime. Non-PIEL creatures retain their existing death/loot behavior.

Provenance: native `GetEventScript`, `SetEventScript`,
`EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED` and `SetIsDestroyable` from the
accepted native MCP reference (nwscript.nss SHA256
`c14098d0181f921618622f379ff5cb682b8656d5293f218392531eef7a8478ad`).
Selectable-when-dead and event installation are declared API capabilities;
delivery of melee attacks to the dead creature is not established by that
reference and remains a required host test. No runtime probe was performed.

Levantado el 2026-09-13 sobre `src/shared/utc/` de este repositorio, antes de
centralizar el desollado en el CNR. Son 3.320 criaturas en total.

## Lo que hace hoy el sistema viejo

`nw_c2_default5.nss`, colgado del evento `ScriptAttacked` de 1.229 criaturas,
reparte segun la variable local `PIEL`. **El reparto esta roto**: solo el valor
1 entrega una piel; del 2 al 10 entrega pepitas de mineria, con el mensaje de
piel correspondiente. Desollar un ciervo da cobre.

## Las 123 criaturas con variable PIEL

La variable ya codifica el material correcto del CNR: los diez valores de PIEL
corresponden uno a uno, y en orden, con las diez pieles de peleteria. El cadaver
entrega la **piel**; la tina de curtido la convierte en el cuero de la misma
fila. La columna "Entrega hoy" es lo que daba el script viejo antes del CNR.

| PIEL | Piel que entrega | Tag | Cuero que sale en la tina | Tier | Criaturas | Entrega hoy |
|------|------------------|-----|---------------------------|------|-----------|-------------|
| 1 | Piel de roedor | `cnr_m_pi_roedor` | Cuero de roedor | 1 | 11 | `pellejoderata` |
| 2 | Piel de herbivoro | `cnr_m_pi_herbiv` | Cuero de herbivoro | 1 | 14 | `cnr_m_pe_cobre` |
| 3 | Piel de bestia | `cnr_m_pi_bestia` | Cuero de bestia salvaje | 2 | 27 | `cnr_m_pe_acero` |
| 4 | Piel de bestia grande | `cnr_m_pi_bestiag` | Cuero de bestia salvaje grande | 2 | 10 | `cnr_m_pe_plata` |
| 5 | Piel de bestia mitica | `cnr_m_pi_mitica` | Cuero de bestia mitica | 3 | 22 | `cnr_m_pe_frio` |
| 6 | Piel de bestia mitica gruesa | `cnr_m_pi_miticag` | Cuero de bestia mitica gruesa | 3 | 14 | `cnr_m_pe_oro` |
| 7 | Piel de draco de fuego | `cnr_m_pi_dracof` | Cuero de dragon de fuego | 4 | 6 | `cnr_m_pe_mithril` |
| 8 | Piel de draco de hielo | `cnr_m_pi_dracoh` | Cuero de dragon de hielo | 4 | 6 | `cnr_m_pe_adaman` |
| 9 | Piel de draco de acido | `cnr_m_pi_dracoa` | Cuero de dragon de acido | 4 | 7 | `cnr_m_pe_adaman` |
| 10 | Piel de draco de rayo | `cnr_m_pi_dracor` | Cuero de dragon de rayo | 4 | 6 | `cnr_m_pe_adaman` |

### Detalle por valor

**PIEL 1 - Piel de roedor (tier 1), 11 criaturas**

- Bat, Leaf-Nosed (`zep_bat_004`, CR 1.0)
- Bat, Leaf-Nosed (`zep_bat_005`, CR 7.0)
- Hurón (`zep_ferret001`, CR 0.5)
- Madre de las Ratas de Murann (`ratdire002`, CR 9.0)
- Pig (`qc_pig002`, CR 0.25)
- Rata (`asy_rata`, CR 0.125)
- Rata (`pb_prirata`, CR 0.125)
- Rata (`plagadeesmeltara`, CR 1.0)
- Rata (`ratamurann`, CR 1.0)
- Rata terrible (`ratainvernal`, CR 3.0)
- Vampire Bat (`q1_vbat`, CR 2.0)

**PIEL 2 - Piel de herbivoro (tier 1), 14 criaturas**

- Camel (`q1_camel002`, CR 2.0)
- Camel, armored (`q1_camel001`, CR 2.0)
- Ciervo (`pb_venadocaza02`, CR 0.3333)
- Ciervo blanco (`ciervo_con_piel`, CR 0.3333)
- Goat (`q1_goat001`, CR 0.3333)
- Goat (`q1_goat002`, CR 0.3333)
- Goat (`q1_goat003`, CR 0.3333)
- Goat (`q1_goat004`, CR 0.3333)
- Lobo (`bison`, CR 7.0)
- Lobo (`bison001`, CR 6.0)
- Lobo (`bongo`, CR 1.0)
- Lobo (`mono`, CR 8.0)
- Moose (`q1_moose001`, CR 5.0)
- Sheep, White (`zep_sheep_003`, CR 0.5)

**PIEL 3 - Piel de bestia (tier 2), 27 criaturas**

- Cobra cormyta dorada (`goldcobra002`, CR 3.0)
- Cobra cormyta negra (`blckcobra002`, CR 2.0)
- Cobra escupidora (`spitcobra002`, CR 3.0)
- Felino montañés (`cougar001`, CR 2.0)
- Hiena (`wolf001`, CR 1.0)
- Huargo (`huargo_nask`, CR 8.0)
- Jaguar (`jaguar`, CR 6.0)
- Krénshar (`krnshar`, CR 6.0)
- Leona (`leona`, CR 10.0)
- Leopardo (`cat001`, CR 6.0)
- León (`leona001`, CR 10.0)
- Lince (`cougar005`, CR 4.0)
- Lobo (`asy_lobo`, CR 0.25)
- Lobo (`gorila`, CR 9.0)
- Lobo (`lobo_con_piel`, CR 1.0)
- Lobo (`lobo_con_piel001`, CR 1.0)
- Lobo invernal (`loboinvernal`, CR 7.0)
- Lobo invernal (`wolfwint001`, CR 4.0)
- Mastiff (`qc_mastiff`, CR 1.0)
- Pantera (`pantera`, CR 8.0)
- Perro intermitente (`perrointermiten`, CR 8.0)
- Puma (`cougar002`, CR 2.0)
- Serpiente (`serpiente_bs`, CR 5.0)
- Tiger (`q1_tiger`, CR 6.0)
- White Tiger (`q1_tiger001`, CR 6.0)
- Wild Boar (`q1_boar001`, CR 2.0)
- Wild Boar (`q1_boar002`, CR 2.0)

**PIEL 4 - Piel de bestia grande (tier 2), 10 criaturas**

- Elephant (`q1_elephant`, CR 11.0)
- Jabalí terrible (`jabali_frutas`, CR 9.0)
- Lobo (`gorila2`, CR 11.0)
- Lobo (`rinoceronte`, CR 12.0)
- Lobo terrible (`direwolf001`, CR 9.0)
- Mammoth (`q1_mammoth`, CR 9.0)
- Oso lechuza  (`zep_elemicel001`, CR 11.0)
- Oso negro (`bearblck001`, CR 6.0)
- Oso pardo (`osopardo`, CR 6.0)
- Oso terrible (`bearkodiak001`, CR 18.0)

**PIEL 5 - Piel de bestia mitica (tier 3), 22 criaturas**

- Androesfinge (`androesfinge`, CR 24.0)
- Ankheg (`ankheg`, CR 10.0)
- Ankheg grande (`ankheg001`, CR 13.0)
- Basilisco (`gran_basilisco`, CR 13.0)
- Bestia desplazadora (`bestiadesplazado`, CR 12.0)
- Crioesfinge (`androesfinge001`, CR 16.0)
- Desgarrador gris (`desgarradorgris`, CR 17.0)
- Ginoesfinge (`crioesfinge`, CR 18.0)
- Gárgola (`q2_gargoyle`, CR 11.0)
- Hieracoesfinge (`hieracoesfinge`, CR 13.0)
- Lamasu (`lamasu`, CR 21.0)
- Lamasu Protector Dorado (`protectordorado`, CR 28.0)
- León marino (`lenmarino`, CR 11.0)
- Lobo (`girallon`, CR 14.0)
- Mantícora (`q1_manticore`, CR 15.0)
- Pack Horse (`grifo`, CR 11.0)
- Pack Horse (`hipogrifo`, CR 10.0)
- Pack Horse (`pegasus`, CR 11.0)
- Pack Horse (`unicornio`, CR 14.0)
- Pig (`espanioso`, CR 16.0)
- Pig (`espanioso001`, CR 16.0)
- Quimera (`quimera`, CR 16.0)

**PIEL 6 - Piel de bestia mitica gruesa (tier 3), 14 criaturas**

- Bestia desplazadora líder de la manada (`doralderdela`, CR 25.0)
- Draco adulto (`draco001`, CR 14.0)
- Draco grande (`draco`, CR 17.0)
- Kraken (`kraken`, CR 31.0)
- Kraken gigantesco (`boss_irphong`, CR 32.0)
- Legendary Bear (`simiolegendario`, CR 54.0)
- Legendary Bear (`uri_osolegendari`, CR 45.0)
- Oso lechuza enorme (`zep_elemicel002`, CR 16.0)
- Purple Worm (`q1_purpleworm`, CR 24.0)
- Remorhaz (`dradediezcabe`, CR 14.0)
- Remorhaz (`q1_remorhaz`, CR 15.0)
- Terrarón de Nashkell (`gofterraron`, CR 16.0)
- Tiranosaurio (`tiranosaurio`, CR 22.0)
- Tricerátopo (`tiranosaurio001`, CR 18.0)

**PIEL 7 - Piel de draco de fuego (tier 4), 6 criaturas**

- Dragón de oro adulto (`dragnrojoadul001`, CR 39.0)
- Dragón de oro sierpe (`dragndeorosi`, CR 63.0)
- Dragón de oropel adulto (`dragndeoropel`, CR 29.0)
- Dragón de oropel sierpe (`dragndeoropesier`, CR 43.0)
- Dragón rojo adulto (`dragnrojoadul`, CR 37.0)
- Dragón rojo sierpe (`dragnrojosier`, CR 59.0)

**PIEL 8 - Piel de draco de hielo (tier 4), 6 criaturas**

- Dragón blanco adulto (`dragnblancoad`, CR 26.0)
- Dragón blanco sierpe (`dragnblancoad001`, CR 40.0)
- Dragón de plata adulto (`eplataadulto`, CR 35.0)
- Dragón de plata sierpe (`eplataadulto001`, CR 58.0)
- Icehauptannarthanyx (`uri_drgwhite004`, CR 156.0)
- Silver Dragon Ancient (`uri_adalon`, CR 102.0)

**PIEL 9 - Piel de draco de acido (tier 4), 7 criaturas**

- Dragón de cobre adulto (`dragndecobre`, CR 32.0)
- Dragón de cobre sierpe (`dragndecobsierp`, CR 48.0)
- Dragón negro adulto (`dragnnegroadu`, CR 28.0)
- Dragón negro sierpe (`dragnnegroadu001`, CR 45.0)
- Dragón verde adulto (`dragonverdedulto`, CR 30.0)
- Dragón verde sierpe (`dragnverdesie`, CR 47.0)
- Sarvhylarewanyn (`asy_dragonanegra`, CR 83.0)

**PIEL 10 - Piel de draco de rayo (tier 4), 6 criaturas**

- Blue Dragon Ancient (`uri_iryklathagra`, CR 127.0)
- Dragón azul adulto (`drgblue003`, CR 32.0)
- Dragón azul sierpe (`dragnazulsier`, CR 50.0)
- Dragón de bronce adulto (`dragnbroncead`, CR 32.0)
- Dragón de bronce sierpe (`dragndebronsierp`, CR 49.0)
- Dragón tortuga (`dragontortuga`, CR 17.0)

## Las 26 criaturas que sueltan piel como botin

Llevaban el objeto en su inventario, asi que la piel caia al morir sin desollar
y sin herramienta.

**Quince de las veintiseis ya eran desollables**: `bison`, `bongo`, `draco`,
`draco001`, `girallon`, `gorila`, `gorila2`, `huargo_nask`, `loboinvernal`,
`mono`, `uri_osolegendari`, `wolf001`, `wolfwint001`, `zep_bat_004` y
`zep_bat_005` ya llevaban `PIEL`, asi que cobraban dos veces. Los conjuntos se
solapan, y la union son **134 criaturas distintas**, no 149.

**Las once restantes no tenian `PIEL`** y se habrian quedado sin piel y sin
cadaver: `avestruz`, `gaviota2`, `hellhound001`, `mano001`, `mano002`, `pb_lobo`,
`pb_loboinv`, `pb_oso`, `pb_osolegendario`, `pb_welclalobo01` y `wyvern004`. Se
les asigna el `PIEL` que implica la piel que soltaban: 3 para las de lobo,
lobo invernal y can, y 6 para las de oso y wyrm. Tres de ellas corrian
`x2_def_ondeath` y pasan a su envoltorio.

| Criatura | Blueprint | CR | Piel en el inventario |
|----------|-----------|----|----------------------|
| Bat, Leaf-Nosed | `zep_bat_004` | 1.0 | `pieldemurci` |
| Bat, Leaf-Nosed | `zep_bat_005` | 7.0 | `pieldemurci` |
| Bestia de Xvim Can del infierno | `hellhound001` | 12.0 | `pieldecani` |
| Draco adulto | `draco001` | 14.0 | `pieldewyrm` |
| Draco grande | `draco` | 17.0 | `pieldewyrm` |
| Hiena | `wolf001` | 1.0 | `pieldelobo` |
| Huargo | `huargo_nask` | 8.0 | `pieldelobo` |
| Legendary Bear | `pb_osolegendario` | 0.125 | `pieldeoso` |
| Legendary Bear | `uri_osolegendari` | 45.0 | `pieldeoso` |
| Lobo | `avestruz` | 9.0 | `pieldelobo` |
| Lobo | `bison` | 7.0 | `pieldelobo` |
| Lobo | `bongo` | 1.0 | `pieldelobo` |
| Lobo | `gaviota2` | 7.0 | `pieldelobo` |
| Lobo | `girallon` | 14.0 | `pieldeoso` |
| Lobo | `gorila` | 9.0 | `pieldelobo` |
| Lobo | `gorila2` | 11.0 | `pieldeoso` |
| Lobo | `mano001` | 4.0 | `pieldelobo` |
| Lobo | `mano002` | 1.0 | `pieldelobo` |
| Lobo | `mono` | 8.0 | `pieldelobo` |
| Lobo | `pb_lobo` | 1.0 | `pieldelobo` |
| Lobo | `pb_loboinv` | 1.0 | `pieldeloboinvern` |
| Lobo de la Manada | `pb_welclalobo01` | 6.0 | `pieldeloboinvern` |
| Lobo invernal | `loboinvernal` | 7.0 | `pieldeloboinvern` |
| Lobo invernal | `wolfwint001` | 4.0 | `pieldeloboinvern` |
| Poni | `pb_oso` | 1.0 | `pieldeoso` |
| Wyverno joven | `wyvern004` | 6.0 | `pieldewyrm` |


## Lo que cambio el 2026-09-13

El desollado pasa al CNR y se comporta como un nodo: el cadaver lleva encima su
tier y su material, exige el cuchillo `cnr_t_desollador`, responde una vez cada
diez segundos, da tres entregas y se agota. No da experiencia ni pide nivel de
oficio, igual que picar o talar. El reparto es 1d4 por intento en tier 1 y 2,
2d4 en tier 3 y 3d4 en tier 4, y el cuchillo se gasta como cualquier otra
herramienta: 40 usos, menos 1, 2 o 3 por entrega segun el tier.

### Manejadores de muerte reasignados

Las 90 criaturas que corren `nw_c2_default7` no se tocan: el enganche esta en el
propio script, que solo deja cadaver cuando la criatura lleva `PIEL`. Las otras
33 llevaban un manejador distinto y se les cambio el suyo por un envoltorio que
deja el cadaver y despues cede al original.

| Manejador anterior | Criaturas | Pasa a |
|---|---|---|
| `x2_def_ondeath` | 28 | `cnr_skin_dth_x2` |
| `nw_ch_ac7` | 4 | `cnr_skin_dth_ch` |
| ninguno | 1 | `cnr_skin_death` |

### Pieles retiradas del botin

Treinta objetos en veintiseis criaturas. La piel ya no cae sola: se desuella o
no se consigue.

| Criatura | Blueprint | Objetos retirados |
|---|---|---|
| Bat, Leaf-Nosed | `zep_bat_004` | `pieldemurci` |
| Bat, Leaf-Nosed | `zep_bat_005` | `pieldemurci` |
| Bestia de Xvim Can del infierno | `hellhound001` | `pieldecani` |
| Draco adulto | `draco001` | `pieldewyrm` |
| Draco grande | `draco` | `pieldewyrm`, `pieldewyrm` |
| Hiena | `wolf001` | `pieldelobo` |
| Huargo | `huargo_nask` | `pieldelobo` |
| Legendary Bear | `pb_osolegendario` | `pieldeoso` |
| Legendary Bear | `uri_osolegendari` | `pieldeoso`, `pieldeoso`, `pieldeoso`, `pieldeoso` |
| Lobo | `avestruz` | `pieldelobo` |
| Lobo | `bison` | `pieldelobo` |
| Lobo | `bongo` | `pieldelobo` |
| Lobo | `gaviota2` | `pieldelobo` |
| Lobo | `girallon` | `pieldeoso` |
| Lobo | `gorila` | `pieldelobo` |
| Lobo | `gorila2` | `pieldeoso` |
| Lobo | `mano001` | `pieldelobo` |
| Lobo | `mano002` | `pieldelobo` |
| Lobo | `mono` | `pieldelobo` |
| Lobo | `pb_lobo` | `pieldelobo` |
| Lobo | `pb_loboinv` | `pieldeloboinvern` |
| Lobo de la Manada | `pb_welclalobo01` | `pieldeloboinvern` |
| Lobo invernal | `loboinvernal` | `pieldeloboinvern` |
| Lobo invernal | `wolfwint001` | `pieldeloboinvern` |
| Poni | `pb_oso` | `pieldeoso` |
| Wyverno joven | `wyvern004` | `pieldewyrm` |

