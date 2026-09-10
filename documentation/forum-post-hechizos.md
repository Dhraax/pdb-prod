[JUSTIFY]
[COLOR=rgb(0, 0, 0)][FONT=Verdana][B]Pruebas de hechizos y clases[/B]

Para participar, entra en el servidor [B]ES) PDB - PGCC[/B] que aparecerá en la lista de servidores.

Se ha revisado a fondo cómo tiran las salvaciones los conjuros, cómo funcionan las nubes y las áreas, la disipación, y las clases Brujo, Artífice y Archimago. Necesitamos comprobar que todo se comporta como debe.

Escribe [B]!test[/B] en el chat y aparecerás en la zona de pruebas.

Casi todo lo del primer bloque [B]no debería notarse[/B]: son conjuros que deben seguir funcionando exactamente igual que siempre. Si algo se comporta distinto a como lo recuerdas, eso es justo lo que buscamos. Lo de las clases sí cambia, y cada apartado dice qué debe pasar ahora.

[B]Cómo reportar[/B]

Un fallo se reporta con estas cinco cosas:

1. Qué lanzaste.
2. Tu clase y nivel.
3. Sobre qué o quién.
4. Qué esperabas.
5. Qué pasó.
Captura del registro de combate mejor que explicarlo con palabras.

[B]BLOQUE 1 - Hechizos en general[/B]

Esto lo puede hacer cualquiera con un lanzador de nivel alto. [B]Casi nada debe haber cambiado.[/B] Si algo se comporta distinto a como lo recuerdas, es un fallo.

[B]1.1 Salvaciones

Qué hacer.[/B] Lanza cada uno de estos sobre un enemigo. Repítelo sobre uno duro y sobre uno flojo.

[B]Muerte[/B]
  - Círculo de muerte
  - Dedo de la muerte
  - Implosión
  - Rematar a los vivos
  - Dañar
  - Lamento de la banshee

[B]Mente y miedo[/B]
  - Hechizar persona
  - Miedo
  - Espantar
  - Inmovilizar persona
  - Inmovilizar monstruo
  - Dominar persona
  - Confusión

[B]Fuego y frío[/B]
  - Bola de fuego
  - Descarga flamígera
  - Tormenta de hielo
  - Incendiario

[B]Electricidad y sonido[/B]
  - Urdimbre Sombria
  - Cadena de Urdimbre Sombrias
  - Explosión de sonido
  - Bola relampagueante

[B]Veneno y enfermedad[/B]
  - Nube aniquiladora
  - Plaga de gusanos

[B]Qué debe pasar.[/B] Exactamente lo de siempre. El enemigo salva o no salva como salvaba antes.

[B]Es un fallo si.[/B] Un enemigo que antes salvaba casi siempre ahora falla casi siempre, o al revés.

[B]1.2 Nubes y áreas

Qué hacer.[/B] Lanza estos y [B]quédate dentro varios asaltos[/B]. Luego sal y vuelve a entrar.

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

[B]Qué debe pasar.[/B] Te tira salvación cada asalto que estés dentro. Al salir deja de afectarte.

[B]Es un fallo si.[/B] La nube deja de hacerte tiradas mientras sigues dentro, o te las sigue haciendo después de salir.

[B]1.3 Nubes lanzadas por otro

Qué hacer.[/B] Que [B]otro jugador[/B] lance la nube y tú te metas dentro.

[B]Qué debe pasar.[/B] La dificultad debe ser la del que la lanzó, no la tuya.

[B]Es un fallo si.[/B] Un mago con Inteligencia altísima lanza una nube y apenas te cuesta salvar; o al revés, un mago flojo lanza una y no hay quien salve.

[B]1.4 Bruma mental

Qué hacer.[/B] Lanza Bruma mental. Métete dentro, sal, y vuelve a entrar.

[B]Qué debe pasar.[/B] Tirada cada asalto dentro. La penalización se aplica dentro y se quita al salir.

[B]Es un fallo si.[/B] Sólo te tira una vez y luego nada.

[B]BLOQUE 2 - Resistencias y bonos a salvación

2.1 Conocimiento de Conjuros[/B]

Necesitas [B]dos personajes[/B]: uno con 0 rangos y otro con 15 en Conocimiento de Conjuros. O uno solo pero toca bajar y subir niveles.

[B]Qué hacer.[/B] Que les lancen encima:

  - Un Glifo custodio (písalo)
  - La Bazuca de Fuerza de un artífice
  - Cualquier conjuro elemental

[B]Qué debe pasar.[/B] El de 15 rangos resiste [B]3 puntos mejor[/B] que el de 0.

[B]Es un fallo si.[/B] Los dos resisten igual.

[B]2.2 Defensa Sombría[/B]

Necesitas un personaje con [B]Defensa Sombría I, II o III[/B].

[B]Qué hacer.[/B] Que te lancen:

  - Ilusión: Asesino fantasmal, Semblante etéreo
  - Encantamiento: Hechizar persona, Dominar persona, Inmovilizar persona
  - Nigromancia: Dedo de la muerte, Círculo de muerte
  - [B]Y también[/B] Bola de fuego y Urdimbre Sombria

[B]Qué debe pasar.[/B] Con los tres primeros grupos resistes 1, 2 o 3 puntos mejor según tu nivel de Defensa Sombría. Con Bola de fuego y Urdimbre Sombria [B]no debes notar nada[/B], porque son evocación.

[B]Es un fallo si.[/B] Notas la reducción contra Bola de fuego, o [B]no[/B] la notas contra Dedo de la muerte.

[B]2.3 Urdimbre Sombria[/B]

Necesitas un mago con [B]Magia de Urdimbre Sombría[/B].

[B]Qué hacer.[/B] Que lance Nube incendiaria y Bola de fuego de explosión retardada sobre alguien. Compara con un mago sin la dote.

[B]Qué debe pasar.[/B] El de Urdimbre Sombria tiene la dificultad [B]1 punto más baja[/B].

[B]Es un fallo si.[/B] Los dos tienen la misma dificultad.

[B]2.4 Que la escuela no se contagie

Qué hacer.[/B] Con un mago que tenga [B]Foco de Conjuro[/B] en una escuela - por ejemplo Nigromancia - lanza [B]dos conjuros seguidos[/B]:

1. Primero uno de nigromancia: Dedo de la muerte.
2. Justo después uno de otra escuela: Bola de fuego.
[B]Qué debe pasar.[/B] La Bola de fuego [B]no[/B] debe llevar el bono de nigromancia.

[B]Es un fallo si.[/B] El segundo conjuro sale con más dificultad de la que le toca por haber lanzado antes el primero.

[B]BLOQUE 3 - Disipación

Qué hacer.[/B]

1. Ponte varios beneficios encima: Piel pétrea, Escudo, Acelerar, Bendecir.
2. Que te lancen [B]Disipar magia[/B] y [B]Disipación mayor[/B].
3. Repite con [B]Esfera Antimagia[/B] y con [B]Disyunción de Mordenkainen[/B].
[B]Qué debe pasar.[/B] Lo de siempre: te quita beneficios según nivel de lanzador.

[B]Es un fallo si.[/B] Se comporta distinto a como lo recuerdas.

[B]Y aparte.[/B] Lanza una nube - Nube aniquiladora, Muro de fuego - y que la disipen.

[B]Qué debe pasar.[/B] La nube desaparece.

[B]Es un fallo si.[/B] La nube sigue ahí después de disiparla.

[B]BLOQUE 4 - Efectos retardados

4.1 Bola de fuego de explosión retardada

Qué hacer.[/B] Lánzala y espera a que estalle.

[B]Qué debe pasar.[/B] Estalla y hace daño normal. Con Evasión, ninguno si salvas.

[B]Es un fallo si.[/B] Estalla y no hace nada, o hace daño distinto del habitual.

[B]4.2 Los otros dos retardados[/B]
  - [B]Mano interpuesta de Bigby[/B]
  - [B]Invisibilidad Retribuidora del Brujo[/B] (la explosión al acabarse)

[B]Qué hacer.[/B] Lánzalos y espera al efecto.

[B]Qué debe pasar.[/B] El efecto llega y es el de siempre.

[B]Es un fallo si.[/B] No pasa nada al cumplirse el tiempo.

[B]BLOQUE 5 - Maestría de los Elementos[/B]

Necesitas un [B]archimago con Maestría de los Elementos[/B].

[B]Qué hacer.[/B] Elige un elemento distinto al del conjuro y lanza:

  - Bola de fuego
  - Tormenta de hielo
  - Urdimbre Sombria
  - Incendiario
  - Bola relampagueante
  - Tromba menor de proyectiles de Isaac
  - Tromba mayor de proyectiles de Isaac

Sobre un enemigo con [B]resistencia al fuego[/B], y luego sobre uno con resistencia al elemento que hayas elegido.

[B]Qué debe pasar.[/B] El daño lo para la resistencia del [B]elemento elegido[/B], no la del fuego.

[B]Es un fallo si.[/B] Convertiste el conjuro a frío y el que resiste fuego lo sigue aguantando.

[B]BLOQUE 6 - Glifo custodio

Qué hacer.[/B] Planta un glifo y que lo pise otro.

Hazlo dos veces: una con un mago [B]con Magia del Urdimbre Sombría[/B] y otra sin ella.

[B]Qué debe pasar.[/B] El del Urdimbre Sombria tiene 1 punto de diferencia.

Y con Conocimiento de Conjuros: el de 15 rangos resiste 3 puntos mejor.

[B]Es un fallo si.[/B] El glifo se comporta igual en todos los casos.

[B]BLOQUE 7 - Brujo

7.1 El reset del DM

Qué hacer.[/B]

1. Activa una esencia (Azufre, Cáustica, Infernal, Tenebrosa o Impactante).
2. Que un DM te haga el reset de invocaciones.
3. Lanza tu Explosión Sobrenatural.
4. Desconecta, vuelve a entrar y lanza otra vez.
[B]Qué debe pasar.[/B] La esencia ha desaparecido: ni el tipo de daño, ni el bono, ni el efecto añadido.

[B]Es un fallo si.[/B] Después del reset tu explosión sigue haciendo fuego, ácido o frío en vez de daño mágico.

[B]7.2 Más cosas del reset[/B]
  - [B]Gasta todas las ranuras de un grado[/B] de invocación, que te reseteen, y abre

la ventana. El grado debe verse [B]vacío[/B] y poder elegir otra vez.

  - Si tienes [B]Visión Bruja[/B], tras el reset [B]debe seguir ahí[/B], y sólo una

ranura oscura libre, no dos.

  - [B]Teletranspórtate con Ruta de las sombras[/B], que te reseteen, y viaja otra vez

por cualquier medio. [B]No debes curarte.[/B]

  - [B]Arma Golpe Horrible con guantes[/B] (sin arma cuerpo a cuerpo), que te reseteen,

y golpea. No debe salir el golpe.

  - Lo mismo armándolo con un arma y [B]cambiando de arma[/B] después.

[B]7.3 Las esencias

Qué hacer.[/B] Lanza Cono de Eldritch y Explosión de la Perdición [B]sin esencia[/B]. Apunta lo que cuesta salvar. Repite [B]con Azufre activa[/B].

[B]Qué debe pasar.[/B] Con Azufre debe costar [B]igual o más[/B], nunca menos.

[B]Es un fallo si.[/B] Con esencia activa es más fácil salvar.

[B]7.4 Ráfaga Escalofriante

Qué hacer.[/B] Lánzala sobre un enemigo con [B]resistencia a conjuros alta[/B].

[B]Qué debe pasar.[/B] Si resiste el conjuro, [B]no recibe ni daño ni derribo[/B].

[B]Es un fallo si.[/B] Resiste y aun así se come el daño.

[B]7.5 Devorar Magia y Disipación Voraz

Qué hacer.[/B] Con un brujo de [B]nivel 16 o más[/B], lanza Disipación Voraz.

[B]Qué debe pasar.[/B] El daño es [B]15[/B], no tu nivel.

Con [B]nivel 21 o más[/B], lanza Devorar Magia: los puntos temporales son [B]20[/B].

[B]7.6 Invisibilidad Retribuidora

Qué hacer.[/B] Vuélvete invisible y [B]ataca[/B].

[B]Qué debe pasar.[/B] Al perder la invisibilidad pierdes también la ocultación.

[B]Es un fallo si.[/B] Sigues con 50% de ocultación después de atacar.

[B]7.7 Cadena de Eldritch

Qué hacer.[/B] Lánzala a nivel 4 y a nivel 7 contra un grupo.

[B]Qué debe pasar.[/B] [B]Un objetivo extra[/B] en los dos casos.

[B]Es un fallo si.[/B] A nivel bajo salta a más enemigos que a nivel alto.

[B]7.8 Cono de Eldritch

Qué hacer.[/B] Con la esencia [B]Cáustica[/B] activa, lanza el cono.

[B]Qué debe pasar.[/B] [B]A ti no te toca.

7.9 El ardor de las esencias

Qué hacer.[/B]

1. Quema a una criatura con Azufre o Cáustica.
2. [B]Desconéctate[/B] mientras le sigue ardiendo.
3. Vuelve y quémala otra vez.
[B]Qué debe pasar.[/B] Se le puede volver a aplicar.

[B]Es un fallo si.[/B] Esa criatura ya nunca más se puede quemar con esa esencia.

[B]BLOQUE 8 - Artífice

8.1 Bomba de fuego alquímica

Qué hacer.[/B] Métete en el fuego y [B]salva[/B]. Luego métete y [B]falla[/B].

[B]Qué debe pasar.[/B] Salvando recibes la mitad. Con Evasión, nada. Fallando, todo.

[B]Y quédate cuatro asaltos o más.[/B] El daño [B]no debe ir bajando[/B] de un asalto al siguiente.

[B]8.2 Bomba de Gas

Qué hacer.[/B] Métete en el gas y quédate.

[B]Qué debe pasar.[/B] Fallar la Fortaleza duele [B]más[/B] que salvarla, y sólo envenena al fallar.

[B]Es un fallo si.[/B] Salvar te hace más daño que fallar.

[B]Y prueba con artífices de nivel 12, 15 y 18.[/B] Debe envenenar en los tres.

[B]8.3 Bazuca

Qué hacer.[/B] Lanza la Bazuca y luego el Lanzallamas sobre lo mismo.

[B]Qué debe pasar.[/B] La Bazuca hace [B]unos 7 puntos más[/B] que antes. El Lanzallamas, igual que siempre.

[B]8.4 Bomba de Potenciación

Qué hacer.[/B] Lánzala donde haya [B]aliados y enemigos mezclados[/B].

[B]Qué debe pasar.[/B] Tus aliados y tú ganáis +2 al ataque y velocidad. [B]Los enemigos no ganan nada.

Es un fallo si.[/B] Un enemigo empieza a moverse más rápido.

[B]8.5 Rociador del Amor

Qué hacer.[/B] Lánzalo sobre un enemigo que falle la Voluntad.

[B]Qué debe pasar.[/B] [B]Deja de atacarte[/B], pero [B]no[/B] lucha por ti.

[B]Es un fallo si.[/B] El enemigo empieza a atacar a sus compañeros.

[B]8.6 Rompepiedras

Qué hacer.[/B] Golpea a un enemigo con [B]resistencia al sonido[/B]. Sigue hasta sacar un crítico.

[B]Qué debe pasar.[/B] La resistencia le protege [B]también en el crítico[/B].

[B]8.7 El Armero y sus campos

Qué hacer.[/B]

1. Activa [B]Campo Antidaño[/B]. Luego activa [B]Ciborg[/B].
2. Mírate los efectos.
[B]Qué debe pasar.[/B] Al activar Ciborg, la reducción de daño [B]desaparece[/B].

[B]Es un fallo si.[/B] Tienes las dos cosas a la vez.

[B]Repítelo con Campo de Detección[/B], que es el que más dura: actívalo, cambia de infusión, y comprueba que [B]deja de detectar invisibles[/B].

[B]Y con Repeler[/B]: con un campo activo, usa Repeler. El campo debe terminarse.

[B]8.8 Ciborg

Qué hacer.[/B] Activa Ciborg, comprueba la velocidad, y [B]cambia a otra infusión[/B]. Ahora intenta activar Ciborg otra vez.

[B]Qué debe pasar.[/B] Puedes volver a activarlo [B]inmediatamente[/B].

[B]Es un fallo si.[/B] Te dice que esperes.

[B]8.9 Goma Viscosa

Qué hacer.[/B] Échasela a alguien y que le [B]disipen los dos efectos[/B] (el ralentizado y el penalizador de ataque). Échasela otra vez.

[B]Qué debe pasar.[/B] Funciona.

[B]Y el caso contrario[/B]: que le disipen [B]sólo uno[/B] de los dos. Ahora [B]no[/B] debe poder echársele otra vez.

[B]8.10 Bazuca de Fuerza y Repeler

Qué hacer.[/B] Que te alcancen con la [B]Bazuca de Fuerza[/B] llevando un objeto de [B]resistencia al fuego[/B].

[B]Qué debe pasar.[/B] La resistencia al fuego [B]no te ayuda nada[/B].

[B]Con Repeler[/B], llevando resistencia al [B]sonido[/B]: ahora [B]sí[/B] te ayuda.

[B]8.11 Elixir del Conocimiento

Qué hacer.[/B] Bébelo. Intenta beberlo otra vez enseguida. Lanza un conjuro con duración larga mientras dura.

[B]Qué debe pasar.[/B] No puedes beberlo dos veces. Y tus conjuros salen como si tuvieras [B]4 niveles más[/B]: duran más y pegan más.

[B]8.12 El Protector

Qué hacer.[/B] Lánzalo sobre ti o un compañero.

[B]Qué debe pasar.[/B] Da puntos de golpe temporales durante [B]tantos asaltos como tu nivel de artífice[/B].

[B]8.13 Mejorar Artefacto

Qué hacer.[/B] Con un [B]alquimista o armero[/B], lanza tu ataque básico:

  - Sin ninguna Mejora de Artefacto.
  - Con Mejorar Artefacto I, luego II, luego III.
  - Y aparte, con [B]Nacido en Lantan[/B].

[B]Qué debe pasar.[/B] Cada Mejora de Artefacto suma [B]un dado[/B]. [B]Nacido en Lantan no suma daño[/B], sólo dificultad.

[B]Es un fallo si.[/B] Nacido en Lantan te sube el daño, o Mejorar Artefacto III no hace nada.

[B]BLOQUE 9 - Archimago

9.1 Fuego Arcano

Hace falta un segundo jugador.

Qué hacer.[/B]

1. El archimago activa Fuego Arcano y [B]no lanza nada[/B].
2. [B]El otro jugador[/B] lanza cualquier conjuro, esté donde esté.
[B]Qué debe pasar.[/B] Al otro jugador le funciona el conjuro [B]con toda normalidad[/B]. Y el archimago sigue con el Fuego Arcano cargado.

[B]Es un fallo si.[/B] El otro jugador gasta el conjuro y no pasa nada.

[B]9.2 Dos archimagos

Hacen falta tres jugadores.

Qué hacer.[/B]

1. Archimago A activa Fuego Arcano.
2. Archimago B activa Fuego Arcano.
3. Los dos disparan.
4. [B]El tercer jugador[/B] lanza un conjuro que necesite componente material.
[B]Qué debe pasar.[/B] Al tercero le siguen pidiendo el componente.

[B]Es un fallo si.[/B] De repente los conjuros ya no piden componentes a nadie.

[B]9.3 Fuego Arcano y desconexiones

Qué hacer.[/B]
  - Activa Fuego Arcano y [B]descansa[/B].
  - Activa y [B]desconecta[/B]. Vuelve a entrar.
  - Activa, desconecta, y que [B]otro lance un conjuro[/B] antes de que vuelvas.

[B]Qué debe pasar.[/B] En los tres casos, el siguiente conjuro de quien sea funciona normal.

[B]9.4 Fuego Arcano que no puede convertir

Qué hacer.[/B] Activa Fuego Arcano y luego:

  - Lanza un conjuro [B]desde una varita[/B].
  - Lanza con el [B]objetivo muerto[/B].
  - Lanza con un [B]objetivo amistoso[/B].

[B]Qué debe pasar.[/B] El conjuro sale [B]normal[/B] y el Fuego Arcano [B]sigue cargado[/B].

[B]Es un fallo si.[/B] Pierdes el conjuro y encima pierdes el Fuego Arcano.

[B]9.5 Fuego Arcano funcionando

Qué hacer.[/B] Actívalo y lanza un conjuro de novena esfera sobre un enemigo. Repite hasta sacar un crítico.

[B]Qué debe pasar.[/B] Ataque de toque y daño. El crítico hace [B]el doble[/B].

[B]9.6 El foco de la Aptitud Sortílega

Qué hacer.[/B]
  - Guarda y actívalo. Debe funcionar.
  - Con un foco [B]recién sacado[/B], que nunca haya guardado nada: actívalo.

[B]Qué debe pasar.[/B] Con el foco vacío te dice que está vacío y [B]no lanza nada[/B].

[B]Es un fallo si.[/B] Un foco vacío lanza [B]Bruma ácida[/B].

[B]El comando !test

Qué hacer.[/B] Escribe [B]!test[/B] en el chat.

[B]Qué debe pasar.[/B] Apareces en la zona de pruebas y [B]la palabra no se dice en voz alta[/B].

[B]Pruébalo también:[/B]
  - Andando y en combate.
  - En decir, gritar, grupo y susurro.
  - Escribiendo un libro: empieza a escribir uno y teclea [B]!test[/B]. [B]Debes viajar[/B],

no escribir la palabra en la página.

  - Y comprueba que [B]!d20[/B] y los demás dados siguen funcionando.

[B]SEGUNDA ETAPA - Nivel de lanzador[/B]

Esta parte llega después de la primera y va sola: puedes hacerla sin haber terminado los bloques anteriores.

Se ha tocado cómo se calcula el nivel de lanzador de un personaje. Es el número que decide cuánto dura un conjuro, cuánto daña y cuánto aguanta contra una disipación. Hasta ahora el módulo y el motor del juego llevaban [B]dos números distintos[/B] y no siempre coincidían; ahora hay uno solo.

Lo importante: [B]la mayoría de personajes no deberían notar nada.[/B] Los que sí son los que llevan una clase de prestigio.

[B]11. Lo que se puede probar ya[/B]

[B]11.1 El brujo tenía una celda vacía.[/B] Un brujo y un mago del mismo nivel total. Cada uno lanza algo cuya duración dependa de su nivel: al brujo le vale una invocación con duración, al mago cualquier protección. Anota cuánto dura cada una.

Las duraciones del brujo deben escalar con su nivel, igual que las del mago. Es un fallo si al brujo le duran lo mismo tenga el nivel que tenga, o le duran un suspiro comparado con el mago.

[B]11.2 Metamagia dentro de las nubes.[/B] Este apartado no comprueba un cambio: comprueba si hay un fallo que llevamos años sin ver, y la respuesta decide si hay que arreglarlo.

Lanza [B]Nube aniquiladora[/B] normal y apunta el daño de un tick, no el golpe de entrada, sino uno de los daños que va cayendo mientras el enemigo sigue dentro. Ahora lánzala potenciada y apunta el daño de un tick otra vez. Repite maximizada. Haz lo mismo con [B]Bruma ácida[/B] y con [B]Muro de fuego[/B].

Potenciada, cada tick debe pegar un 50% más. Maximizada, los dados deben salir al máximo. Es un fallo si los ticks son idénticos con y sin metamagia, aunque el golpe de entrada sí cambie. Dilo aunque te parezca que no pasa nada: es exactamente el dato que hace falta.

[B]12. Clases de prestigio[/B]

Personajes con una clase base lanzadora y una de prestigio. Los cuatro casos que interesan son Mago / Archimago, Mago / Maestro de la lividez, Clérigo / Teúrgo místico, y Hechicero / Discípulo de dragón.

Cada uno lanza algo con duración visible y lo comparas con un lanzador de una sola clase y del mismo nivel total. Los dos deben durar lo mismo: los niveles de la clase de prestigio cuentan. Es un fallo si el de prestigio dura menos. Antes duraba menos en algunos conjuros y no en otros, según el conjuro; ahora debe ser parejo en todos.

[B]13. Los tentáculos de Evard[/B]

Lanza [B]Tentáculos negros de Evard[/B] y fíjate en cuántos tentáculos agarran a cada objetivo. Luego repítelo alejándote mucho del área mientras sigue activa. Y una tercera vez desconectándote después de lanzarla, con otro entrando en la zona.

El número de tentáculos debe subir con el nivel del que lo lanzó, y no debe cambiar porque te alejes o te desconectes. Es un fallo si agarran poquísimo, porque antes el conjuro se comportaba como si lo hubiera lanzado alguien de nivel cero, o si baja de golpe cuando el lanzador se va.

[B]14. Poder de Conjuro del Archimago[/B]

Un archimago con Poder de Conjuro. Tres pruebas: lanza un conjuro arcano normal; lanza el mismo conjuro desde una varita o un pergamino; y si tiene lanzamiento divino o invocaciones de brujo, lanza algo de eso.

Los niveles extra deben contar sólo en el primero. Es un fallo si cuentan en la varita, en el pergamino, en un conjuro divino o en una invocación.

[B]15. Criaturas y DMs[/B]

Esto es para DM. Las criaturas también tenían el problema y ninguna lo tenía arreglado.

Busca o invoca una criatura con clase base lanzadora y clase de prestigio: un Mago / Maestro de la lividez es el caso concreto que estaba roto. Hazla lanzar algo con duración visible, por ejemplo [B]Premura[/B]. Luego, sobre esa misma criatura, súbele un nivel con el asistente de criaturas y vuelve a mirar la duración; bájale un nivel y vuelve a mirarla; y guárdala y restáurala con la herramienta de guardar criaturas, y vuelve a mirarla.

La duración debe corresponder a su nivel de lanzador completo, no sólo al de su clase base, y debe seguir correspondiendo después de cada una de las tres operaciones. Es un fallo si la duración es la de un lanzador de menos nivel, o si era correcta y deja de serlo después de subirle, bajarle o restaurarla.

[B]16. Lo que NO debe moverse[/B]

El apartado más importante de esta etapa. Si algo de aquí cambia, se ha roto algo.

Un mago puro, un clérigo puro, un hechicero puro y un brujo puro, sin clases de prestigio. Que lancen conjuros con duración y daño visibles y compara con lo que recuerdas. No debe pasar nada: exactamente lo de siempre. Es un fallo si cualquiera de ellos nota una diferencia.

[B]Qué NO va en el hilo de errores[/B]

Este hilo no es para sugerencias, quejas ni debates sobre si algo debería funcionar de otra manera. En esta etapa comprobamos si lo que existe ahora hace lo que dice.[/FONT][/COLOR]
[/JUSTIFY]