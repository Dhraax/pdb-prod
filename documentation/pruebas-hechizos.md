# Pruebas de hechizos y clases

Guía para testers. No hace falta saber nada del código.

Escribe **`!test`** en el chat y apareces en la zona de pruebas.

Pensado para pegar en Discord. Los bloques 3, 4, 5, 6 y 10 entran de una vez.
Los bloques 1, 2, 7, 8 y 9 son largos: pégalos apartado por apartado, cada uno
es corto.

## Cómo reportar

Un fallo se reporta con estas cinco cosas:

1. Qué lanzaste.
2. Tu clase y nivel.
3. Sobre qué o quién.
4. Qué esperabas.
5. Qué pasó.

Captura del registro de combate mejor que explicarlo con palabras.

---

# BLOQUE 1 - Hechizos en general

Esto lo puede hacer cualquiera con un lanzador de nivel alto. **Casi nada debe
haber cambiado.** Si algo se comporta distinto a como lo recuerdas, es un fallo.

## 1.1 Salvaciones

**Qué hacer.** Lanza cada uno de estos sobre un enemigo. Repítelo sobre uno duro
y sobre uno flojo.

**Muerte**
- Círculo de muerte
- Dedo de la muerte
- Implosión
- Rematar a los vivos
- Dañar
- Lamento de la banshee

**Mente y miedo**
- Hechizar persona
- Miedo
- Espantar
- Inmovilizar persona
- Inmovilizar monstruo
- Dominar persona
- Confusión

**Fuego y frío**
- Bola de fuego
- Descarga flamígera
- Tormenta de hielo
- Incendiario

**Electricidad y sonido**
- Rayo relampagueante
- Relámpago zigzagueante
- Explosión de sonido
- Bola relampagueante

**Veneno y enfermedad**
- Nube aniquiladora
- Plaga de gusanos

**Qué debe pasar.** Exactamente lo de siempre. El enemigo salva o no salva como
salvaba antes.

**Es un fallo si.** Un enemigo que antes salvaba casi siempre ahora falla casi
siempre, o al revés.

## 1.2 Nubes y áreas

**Qué hacer.** Lanza estos y **quédate dentro varios asaltos**. Luego sal y
vuelve a entrar.

- Nube aniquiladora
- Nube incendiaria
- Nube apestosa
- Bruma ácida
- Telaraña
- Grasa
- Tentáculos negros de Evard
- Muro de fuego
- Barrera de cuchillas
- Enmarañar

**Qué debe pasar.** Te tira salvación cada asalto que estés dentro. Al salir deja
de afectarte.

**Es un fallo si.** La nube deja de hacerte tiradas mientras sigues dentro, o te
las sigue haciendo después de salir.

## 1.3 Nubes lanzadas por otro

**Qué hacer.** Que **otro jugador** lance la nube y tú te metas dentro.

**Qué debe pasar.** La dificultad debe ser la del que la lanzó, no la tuya.

**Es un fallo si.** Un mago con Inteligencia altísima lanza una nube y apenas te
cuesta salvar; o al revés, un mago flojo lanza una y no hay quien salve.

## 1.4 Bruma mental

**Qué hacer.** Lanza Bruma mental. Métete dentro, sal, y vuelve a entrar.

**Qué debe pasar.** Tirada cada asalto dentro. La penalización se aplica dentro y
se quita al salir.

**Es un fallo si.** Sólo te tira una vez y luego nada.

---

# BLOQUE 2 - Resistencias y bonos a salvación

## 2.1 Conocimiento de Conjuros

Necesitas **dos personajes**: uno con 0 rangos y otro con 15 en Conocimiento de
Conjuros. O uno solo que puedas respecar.

**Qué hacer.** Que les lancen encima:

- Un Glifo custodio (písalo)
- La Bazuca de Fuerza de un artífice
- Cualquier conjuro elemental

**Qué debe pasar.** El de 15 rangos resiste **3 puntos mejor** que el de 0.

**Es un fallo si.** Los dos resisten igual.

## 2.2 Defensa Sombría

Necesitas un personaje con **Defensa Sombría I, II o III**.

**Qué hacer.** Que te lancen:

- Ilusión: Asesino fantasmal, Semblante etéreo
- Encantamiento: Hechizar persona, Dominar persona, Inmovilizar persona
- Nigromancia: Dedo de la muerte, Círculo de muerte
- **Y también** Bola de fuego y Rayo relampagueante

**Qué debe pasar.** Con los tres primeros grupos resistes 1, 2 o 3 puntos mejor
según tu nivel de Defensa Sombría. Con Bola de fuego y Relámpago **no debes
notar nada**, porque son evocación.

**Es un fallo si.** Notas la reducción contra Bola de fuego, o **no** la notas
contra Dedo de la muerte.

## 2.3 Tejido Sombrío

Necesitas un mago con **Magia del Tejido Sombrío**.

**Qué hacer.** Que lance Nube incendiaria y Bola de fuego de explosión retardada sobre alguien.
Compara con un mago sin la dote.

**Qué debe pasar.** El del Tejido Sombrío tiene la dificultad **1 punto más
baja**.

**Es un fallo si.** Los dos tienen la misma dificultad.

## 2.4 Que la escuela no se contagie

**Qué hacer.** Con un mago que tenga **Foco de Conjuro** en una escuela - por
ejemplo Nigromancia - lanza **dos conjuros seguidos**:

1. Primero uno de nigromancia: Dedo de la muerte.
2. Justo después uno de otra escuela: Bola de fuego.

**Qué debe pasar.** La Bola de fuego **no** debe llevar el bono de nigromancia.

**Es un fallo si.** El segundo conjuro sale con más dificultad de la que le toca
por haber lanzado antes el primero.

---

# BLOQUE 3 - Disipación

**Qué hacer.**

1. Ponte varios beneficios encima: Piel pétrea, Escudo, Acelerar, Bendecir.
2. Que te lancen **Disipar magia** y **Disipación mayor**.
3. Repite con **Esfera Antimagia** y con **Disyunción de Mordenkainen**.

**Qué debe pasar.** Lo de siempre: te quita beneficios según nivel de lanzador.

**Es un fallo si.** Se comporta distinto a como lo recuerdas.

**Y aparte.** Lanza una nube - Nube aniquiladora, Muro de fuego - y que la disipen.

**Qué debe pasar.** La nube desaparece.

**Es un fallo si.** La nube sigue ahí después de disiparla.

---

# BLOQUE 4 - Efectos retardados

## 4.1 Bola de fuego de explosión retardada

**Qué hacer.** Lánzala y espera a que estalle.

**Qué debe pasar.** Estalla y hace daño normal. Con Evasión, ninguno si salvas.

**Es un fallo si.** Estalla y no hace nada, o hace daño distinto del habitual.

## 4.2 Los otros dos retardados

- **Mano interpuesta de Bigby**
- **Invisibilidad Retribuidora del Brujo** (la explosión al acabarse)

**Qué hacer.** Lánzalos y espera al efecto.

**Qué debe pasar.** El efecto llega y es el de siempre.

**Es un fallo si.** No pasa nada al cumplirse el tiempo.

---

# BLOQUE 5 - Maestría de los Elementos

Necesitas un **archimago con Maestría de los Elementos**.

**Qué hacer.** Elige un elemento distinto al del conjuro y lanza:

- Bola de fuego
- Tormenta de hielo
- Rayo relampagueante
- Incendiario
- Bola relampagueante
- Tromba menor de proyectiles de Isaac
- Tromba mayor de proyectiles de Isaac

Sobre un enemigo con **resistencia al fuego**, y luego sobre uno con resistencia
al elemento que hayas elegido.

**Qué debe pasar.** El daño lo para la resistencia del **elemento elegido**, no
la del fuego.

**Es un fallo si.** Convertiste el conjuro a frío y el que resiste fuego lo sigue
aguantando.

---

# BLOQUE 6 - Glifo custodio

**Qué hacer.** Planta un glifo y que lo pise otro.

Hazlo dos veces: una con un mago **con Magia del Tejido Sombrío** y otra sin ella.

**Qué debe pasar.** El del Tejido Sombrío tiene 1 punto de diferencia.

Y con Conocimiento de Conjuros: el de 15 rangos resiste 3 puntos mejor.

**Es un fallo si.** El glifo se comporta igual en todos los casos.

---

# BLOQUE 7 - Brujo

## 7.1 El reset del DM

**Qué hacer.**

1. Activa una esencia (Azufre, Cáustica, Infernal, Tenebrosa o Impactante).
2. Que un DM te haga el reset de invocaciones.
3. Lanza tu Explosión Sobrenatural.
4. Desconecta, vuelve a entrar y lanza otra vez.

**Qué debe pasar.** La esencia ha desaparecido: ni el tipo de daño, ni el bono,
ni el efecto añadido.

**Es un fallo si.** Después del reset tu explosión sigue haciendo fuego, ácido o
frío en vez de daño mágico.

## 7.2 Más cosas del reset

- **Gasta todas las ranuras de un grado** de invocación, que te reseteen, y abre
  la ventana. El grado debe verse **vacío** y poder elegir otra vez.
- Si tienes **Visión Bruja**, tras el reset **debe seguir ahí**, y sólo una
  ranura oscura libre, no dos.
- **Teletranspórtate con Ruta de las sombras**, que te reseteen, y viaja otra vez
  por cualquier medio. **No debes curarte.**
- **Arma Golpe Horrible con guantes** (sin arma cuerpo a cuerpo), que te reseteen,
  y golpea. No debe salir el golpe.
- Lo mismo armándolo con un arma y **cambiando de arma** después.

## 7.3 Las esencias

**Qué hacer.** Lanza Cono de Eldritch y Explosión de la Perdición **sin esencia**.
Apunta lo que cuesta salvar. Repite **con Azufre activa**.

**Qué debe pasar.** Con Azufre debe costar **igual o más**, nunca menos.

**Es un fallo si.** Con esencia activa es más fácil salvar.

## 7.4 Ráfaga Escalofriante

**Qué hacer.** Lánzala sobre un enemigo con **resistencia a conjuros alta**.

**Qué debe pasar.** Si resiste el conjuro, **no recibe ni daño ni derribo**.

**Es un fallo si.** Resiste y aun así se come el daño.

## 7.5 Devorar Magia y Disipación Voraz

**Qué hacer.** Con un brujo de **nivel 16 o más**, lanza Disipación Voraz.

**Qué debe pasar.** El daño es **15**, no tu nivel.

Con **nivel 21 o más**, lanza Devorar Magia: los puntos temporales son **20**.

## 7.6 Invisibilidad Retribuidora

**Qué hacer.** Vuélvete invisible y **ataca**.

**Qué debe pasar.** Al perder la invisibilidad pierdes también la ocultación.

**Es un fallo si.** Sigues con 50% de ocultación después de atacar.

## 7.7 Cadena de Eldritch

**Qué hacer.** Lánzala a nivel 4 y a nivel 7 contra un grupo.

**Qué debe pasar.** **Un objetivo extra** en los dos casos.

**Es un fallo si.** A nivel bajo salta a más enemigos que a nivel alto.

## 7.8 Cono de Eldritch

**Qué hacer.** Con la esencia **Cáustica** activa, lanza el cono.

**Qué debe pasar.** **A ti no te toca.**

## 7.9 El ardor de las esencias

**Qué hacer.**

1. Quema a una criatura con Azufre o Cáustica.
2. **Desconéctate** mientras le sigue ardiendo.
3. Vuelve y quémala otra vez.

**Qué debe pasar.** Se le puede volver a aplicar.

**Es un fallo si.** Esa criatura ya nunca más se puede quemar con esa esencia.

---

# BLOQUE 8 - Artífice

## 8.1 Bomba de fuego alquímica

**Qué hacer.** Métete en el fuego y **salva**. Luego métete y **falla**.

**Qué debe pasar.** Salvando recibes la mitad. Con Evasión, nada. Fallando,
todo.

**Y quédate cuatro asaltos o más.** El daño **no debe ir bajando** de un asalto
al siguiente.

## 8.2 Bomba de Gas

**Qué hacer.** Métete en el gas y quédate.

**Qué debe pasar.** Fallar la Fortaleza duele **más** que salvarla, y sólo
envenena al fallar.

**Es un fallo si.** Salvar te hace más daño que fallar.

**Y prueba con artífices de nivel 12, 15 y 18.** Debe envenenar en los tres.

## 8.3 Bazuca

**Qué hacer.** Lanza la Bazuca y luego el Lanzallamas sobre lo mismo.

**Qué debe pasar.** La Bazuca hace **unos 7 puntos más** que antes. El
Lanzallamas, igual que siempre.

## 8.4 Bomba de Potenciación

**Qué hacer.** Lánzala donde haya **aliados y enemigos mezclados**.

**Qué debe pasar.** Tus aliados y tú ganáis +2 al ataque y velocidad. **Los
enemigos no ganan nada.**

**Es un fallo si.** Un enemigo empieza a moverse más rápido.

## 8.5 Rociador del Amor

**Qué hacer.** Lánzalo sobre un enemigo que falle la Voluntad.

**Qué debe pasar.** **Deja de atacarte**, pero **no** lucha por ti.

**Es un fallo si.** El enemigo empieza a atacar a sus compañeros.

## 8.6 Rompepiedras

**Qué hacer.** Golpea a un enemigo con **resistencia al sonido**. Sigue hasta
sacar un crítico.

**Qué debe pasar.** La resistencia le protege **también en el crítico**.

## 8.7 El Armero y sus campos

**Qué hacer.**

1. Activa **Campo Antidaño**. Luego activa **Ciborg**.
2. Mírate los efectos.

**Qué debe pasar.** Al activar Ciborg, la reducción de daño **desaparece**.

**Es un fallo si.** Tienes las dos cosas a la vez.

**Repítelo con Campo de Detección**, que es el que más dura: actívalo, cambia de
infusión, y comprueba que **deja de detectar invisibles**.

**Y con Repeler**: con un campo activo, usa Repeler. El campo debe terminarse.

## 8.8 Ciborg

**Qué hacer.** Activa Ciborg, comprueba la velocidad, y **cambia a otra
infusión**. Ahora intenta activar Ciborg otra vez.

**Qué debe pasar.** Puedes volver a activarlo **inmediatamente**.

**Es un fallo si.** Te dice que esperes.

## 8.9 Goma Viscosa

**Qué hacer.** Échasela a alguien y que le **disipen los dos efectos** (el
ralentizado y el penalizador de ataque). Échasela otra vez.

**Qué debe pasar.** Funciona.

**Y el caso contrario**: que le disipen **sólo uno** de los dos. Ahora **no** debe
poder echársele otra vez.

## 8.10 Bazuca de Fuerza y Repeler

**Qué hacer.** Que te alcancen con la **Bazuca de Fuerza** llevando un objeto de
**resistencia al fuego**.

**Qué debe pasar.** La resistencia al fuego **no te ayuda nada**.

**Con Repeler**, llevando resistencia al **sonido**: ahora **sí** te ayuda.

## 8.11 Elixir del Conocimiento

**Qué hacer.** Bébelo. Intenta beberlo otra vez enseguida. Lanza un conjuro con
duración larga mientras dura.

**Qué debe pasar.** No puedes beberlo dos veces. Y tus conjuros salen como si
tuvieras **4 niveles más**: duran más y pegan más.

## 8.12 El Protector

**Qué hacer.** Lánzalo sobre ti o un compañero.

**Qué debe pasar.** Da puntos de golpe temporales durante **tantos asaltos como
tu nivel de artífice**.

## 8.13 Mejorar Artefacto

**Qué hacer.** Con un **alquimista o armero**, lanza tu ataque básico:

- Sin ninguna Mejora de Artefacto.
- Con Mejorar Artefacto I, luego II, luego III.
- Y aparte, con **Nacido en Lantan**.

**Qué debe pasar.** Cada Mejora de Artefacto suma **un dado**. **Nacido en Lantan
no suma daño**, sólo dificultad.

**Es un fallo si.** Nacido en Lantan te sube el daño, o Mejorar Artefacto III no
hace nada.

---

# BLOQUE 9 - Archimago

## 9.1 Fuego Arcano - el más importante

**Hace falta un segundo jugador.**

**Qué hacer.**

1. El archimago activa Fuego Arcano y **no lanza nada**.
2. **El otro jugador** lanza cualquier conjuro, esté donde esté.

**Qué debe pasar.** Al otro jugador le funciona el conjuro **con toda
normalidad**. Y el archimago sigue con el Fuego Arcano cargado.

**Es un fallo si.** El otro jugador gasta el conjuro y no pasa nada.

## 9.2 Dos archimagos

**Hacen falta tres jugadores.**

**Qué hacer.**

1. Archimago A activa Fuego Arcano.
2. Archimago B activa Fuego Arcano.
3. Los dos disparan.
4. **El tercer jugador** lanza un conjuro que necesite componente material.

**Qué debe pasar.** Al tercero le siguen pidiendo el componente.

**Es un fallo si.** De repente los conjuros ya no piden componentes a nadie.

## 9.3 Fuego Arcano y desconexiones

**Qué hacer.**

- Activa Fuego Arcano y **descansa**.
- Activa y **desconecta**. Vuelve a entrar.
- Activa, desconecta, y que **otro lance un conjuro** antes de que vuelvas.

**Qué debe pasar.** En los tres casos, el siguiente conjuro de quien sea funciona
normal.

## 9.4 Fuego Arcano que no puede convertir

**Qué hacer.** Activa Fuego Arcano y luego:

- Lanza un conjuro **desde una varita**.
- Lanza con el **objetivo muerto**.
- Lanza con un **objetivo amistoso**.

**Qué debe pasar.** El conjuro sale **normal** y el Fuego Arcano **sigue
cargado**.

**Es un fallo si.** Pierdes el conjuro y encima pierdes el Fuego Arcano.

## 9.5 Fuego Arcano funcionando

**Qué hacer.** Actívalo y lanza un conjuro de novena esfera sobre un enemigo.
Repite hasta sacar un crítico.

**Qué debe pasar.** Ataque de toque y daño. El crítico hace **el doble**.

## 9.6 El foco de la Aptitud Sortílega

**Qué hacer.**

- Intenta guardar **Detener el Tiempo**. Debe negarse.
- Guarda **otro conjuro de novena** y actívalo. Debe funcionar.
- Con un foco **recién sacado**, que nunca haya guardado nada: actívalo.

**Qué debe pasar.** Con el foco vacío te dice que está vacío y **no lanza nada**.

**Es un fallo si.** Un foco vacío lanza **Bruma ácida**.

---

# BLOQUE 10 - El comando !test

**Qué hacer.** Escribe `!test` en el chat.

**Qué debe pasar.** Apareces en la zona de pruebas y **la palabra no se dice en
voz alta**.

**Pruébalo también:**

- Andando y en combate.
- En decir, gritar, grupo y susurro.
- Escribiendo un libro: empieza a escribir uno y teclea `!test`. **Debes viajar**,
  no escribir la palabra en la página.
- Y comprueba que `!d20` y los demás dados siguen funcionando.

---

# SEGUNDA ETAPA — Nivel de lanzador

Esta parte llega después de la primera y va sola: puedes hacerla sin haber
terminado los bloques anteriores.

**Qué se ha tocado.** Cómo se calcula el nivel de lanzador de un personaje. Es el
número que decide cuánto dura un conjuro, cuánto daña y cuánto aguanta contra una
disipación. Hasta ahora el módulo y el motor del juego llevaban **dos números
distintos** y no siempre coincidían; ahora hay uno solo.

Lo importante: **la mayoría de personajes no deberían notar nada.** Los que sí
son los que llevan una clase de prestigio.

## 11. Lo que se puede probar ya

Estos dos no esperan a nada. Se pueden hacer hoy.

### 11.1 El brujo tenía una celda vacía

**Qué hacer.** Un brujo y un mago **del mismo nivel total**. Cada uno lanza algo
cuya duración dependa de su nivel — al brujo le vale una invocación con duración,
al mago cualquier protección.

Anota cuánto dura cada una.

**Qué debe pasar.** Las duraciones del brujo escalan con su nivel, igual que las
del mago.

**Es un fallo si** al brujo le duran lo mismo tenga el nivel que tenga, o le duran
un suspiro comparado con el mago.

### 11.2 Metamagia dentro de las nubes

Este apartado no comprueba un cambio: comprueba **si hay un fallo que llevamos
años sin ver**. La respuesta decide si hay que arreglarlo.

**Qué hacer.** Lanza **Nube aniquiladora** normal y apunta el daño de **un tick**
— no el golpe de entrada, uno de los daños que va cayendo mientras el enemigo
sigue dentro.

Ahora lánzala **potenciada** y apunta el daño de un tick otra vez. Repite
**maximizada**.

Haz lo mismo con **Bruma ácida** y con **Muro de fuego**.

**Qué debe pasar.** Potenciada, cada tick pega un 50% más. Maximizada, los dados
salen al máximo.

**Es un fallo si** los ticks son idénticos con y sin metamagia, aunque el golpe de
entrada sí cambie. **Dilo aunque te parezca que no pasa nada**: es exactamente el
dato que hace falta.

## 12. Clases de prestigio — esperan a la próxima subida

**Qué hacer.** Personajes con una clase base lanzadora y una de prestigio. Los
cuatro casos que interesan:

- Mago / **Archimago**
- Mago / **Maestro de la lividez**
- Clérigo / **Teúrgo místico**
- Hechicero / **Discípulo de dragón**

Cada uno lanza algo con duración visible y la comparas con un lanzador **de una
sola clase y del mismo nivel total**.

**Qué debe pasar.** Los dos duran lo mismo. Los niveles de la clase de prestigio
cuentan.

**Es un fallo si** el de prestigio dura menos. Antes duraba menos en algunos
conjuros y no en otros, según el conjuro; ahora debe ser parejo en todos.

## 13. Los tentáculos de Evard

**Qué hacer.** Lanza **Tentáculos negros de Evard** y fíjate en cuántos tentáculos
agarran a cada objetivo.

Luego repítelo alejándote mucho del área mientras sigue activa. Y una tercera vez
desconectándote después de lanzarla, con otro entrando en la zona.

**Qué debe pasar.** El número de tentáculos sube con el nivel del que lo lanzó, y
**no cambia** porque te alejes o te desconectes.

**Es un fallo si** agarran poquísimo — antes el conjuro se comportaba como si lo
hubiera lanzado alguien de nivel cero — o si baja de golpe cuando el lanzador se
va.

## 14. Poder de Conjuro del Archimago

**Qué hacer.** Un archimago con **Poder de Conjuro**. Tres pruebas:

1. Lanza un conjuro arcano normal.
2. Lanza el mismo conjuro **desde una varita o un pergamino**.
3. Si tiene lanzamiento divino o invocaciones de brujo, lanza algo de eso.

**Qué debe pasar.** Los niveles extra cuentan **sólo en el primero**.

**Es un fallo si** cuentan en la varita, en el pergamino, en un conjuro divino o
en una invocación.

## 15. Criaturas y DMs

Esto es para DM. Las criaturas también tenían el problema y ninguna lo tenía
arreglado.

**Qué hacer.** Busca o invoca una criatura con clase base lanzadora **y** clase de
prestigio — un Mago / Maestro de la lividez es el caso concreto que estaba roto —
y hazla lanzar algo con duración visible, por ejemplo **Premura**.

Luego, sobre esa misma criatura:

- **súbele un nivel** con el asistente de criaturas y vuelve a mirar la duración;
- **bájale un nivel** y vuelve a mirarla;
- **guárdala y restáurala** con la herramienta de guardar criaturas, y vuelve a
  mirarla.

**Qué debe pasar.** La duración corresponde a su nivel de lanzador completo, no
sólo al de su clase base. Y después de cada una de las tres operaciones **sigue
correspondiendo**.

**Es un fallo si** la duración es la de un lanzador de menos nivel, o si era
correcta y deja de serlo después de subirle, bajarle o restaurarla.

## 16. Lo que NO debe moverse

El apartado más importante de esta etapa. Si algo de aquí cambia, se ha roto algo.

**Qué hacer.** Un **mago puro**, un **clérigo puro**, un **hechicero puro** y un
**brujo puro**, sin clases de prestigio. Que lancen conjuros con duración y daño
visibles y compara con lo que recuerdas.

**Qué debe pasar.** Nada. Exactamente lo de siempre.

**Es un fallo si** cualquiera de ellos nota una diferencia.
