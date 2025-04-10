#include "x0_i0_spells"
#include "mti_libreria"
#include "lib_disguise"

// Cambia la apariencia al jugador guardando la antigua
// iNuevaApariencia: nueva apariencia a tomar
// iEfectoVisual: efecto visual que se reproduce, por defecto 85
// iMilCaras: si la habilidad es Mil Caras o no, por defecto no lo es
void CambiarApariencia(int iNuevaApariencia, string sNombre = "", int iEfectoVisual = 85, int iMilCaras = FALSE);

void CambiarApariencia(int iNuevaApariencia, string sNombre = "", int iEfectoVisual = 85, int iMilCaras = FALSE)
{
  // No en el mar
  string sNombreArea = GetName(GetArea(OBJECT_SELF));
  if(sNombreArea == "Mar de las Espadas"|| sNombreArea == "Mar Impenetrable")
  {
      FloatingTextStringOnCreature("<cþ<<>¡No puedes transformar tu barco!</c>", OBJECT_SELF, FALSE);
      return;
  }

  // No polimorfado
  if(GetHasEffect(EFFECT_TYPE_POLYMORPH) || ObtenerIntPersistente(OBJECT_SELF,"POLYMORPHED"))
  {
      FloatingTextStringOnCreature("<cþ<<>* Esta aptitud no se puede activar polimorfado *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // No funciona montado en montura
  if(ObtenerIntPersistente(OBJECT_SELF, "CAB_MONTADO") > 0)
  {
      FloatingTextStringOnCreature("<cþ<<>* Esta aptitud no se puede activar montado en montura *</c>", OBJECT_SELF, FALSE);
      return;
  }

  //Si es mujer en apariencia humano
  if(iNuevaApariencia == 6 && GetGender(OBJECT_SELF) == 1) sNombre = "Mujer";

  GuardarIntPersistente(OBJECT_SELF, "APA_CAMBIADA", TRUE);
  GuardarIntPersistente(OBJECT_SELF, "APA_MEMORIZADA", GetAppearanceType(OBJECT_SELF));
  SetCreatureAppearanceType(OBJECT_SELF, iNuevaApariencia);
  //Aplicamos el nombre que toque
  PB_Disguise_SetNameOverride(OBJECT_SELF, sNombre, NWNX_RENAME_PLAYERNAME_OVERRIDE);
  SetLocalInt(OBJECT_SELF, "POLY_ON", 1);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(iEfectoVisual), OBJECT_SELF);

  if(iNuevaApariencia == 2560)
  {
      GuardarIntPersistente(OBJECT_SELF, "ALAS_CAMBIADAS", TRUE);
      GuardarIntPersistente(OBJECT_SELF, "ALAS_MEMORIZADAS", GetCreatureWingType(OBJECT_SELF));

      SetCreatureWingType(6, OBJECT_SELF);
  }

  if(iMilCaras == FALSE)
  {
      if(GetLevelByClass(51) > 0) { //Asolador
          if(GetHasFeat(1402, OBJECT_SELF) == TRUE) DecrementRemainingFeatUses(OBJECT_SELF, 1402);
      } else { //Druida
          if(GetHasFeat(FEAT_WILD_SHAPE, OBJECT_SELF) == TRUE) DecrementRemainingFeatUses(OBJECT_SELF, FEAT_WILD_SHAPE);
          else if(GetHasFeat(FEAT_GREATER_WILDSHAPE_1, OBJECT_SELF) == TRUE) DecrementRemainingFeatUses(OBJECT_SELF, FEAT_GREATER_WILDSHAPE_1);
          else if(GetHasFeat(FEAT_GREATER_WILDSHAPE_2, OBJECT_SELF) == TRUE) DecrementRemainingFeatUses(OBJECT_SELF, FEAT_GREATER_WILDSHAPE_2);
          else if(GetHasFeat(FEAT_GREATER_WILDSHAPE_3, OBJECT_SELF) == TRUE) DecrementRemainingFeatUses(OBJECT_SELF, FEAT_GREATER_WILDSHAPE_3);
          else if(GetHasFeat(FEAT_GREATER_WILDSHAPE_4, OBJECT_SELF) == TRUE) DecrementRemainingFeatUses(OBJECT_SELF, FEAT_GREATER_WILDSHAPE_4);
      }
  }
}

void main()
{
  string sSerie = GetLocalString(OBJECT_SELF, "FDRUIDASSERIE");

  // 1. CANIDOS
       if(sSerie == "111") CambiarApariencia(2392, "Perro"); //1391
  else if(sSerie == "112") CambiarApariencia(2393, "Perro"); //1392
  else if(sSerie == "113") CambiarApariencia(2394, "Perro"); //1393
  else if(sSerie == "114") CambiarApariencia(2397, "Perro"); //1396
  else if(sSerie == "115") CambiarApariencia(2398, "Perro"); //1397
  else if(sSerie == "116") CambiarApariencia(2395, "Perro"); //1394
  else if(sSerie == "1171") CambiarApariencia(2401, "Perro"); //1400
  else if(sSerie == "1172") CambiarApariencia(2400, "Perro");  //1399
  else if(sSerie == "1173") CambiarApariencia(2402, "Perro");  //1401
  else if(sSerie == "1174") CambiarApariencia(2404, "Perro");  //1403
  else if(sSerie == "1175") CambiarApariencia(2405, "Perro");  //1404
  else if(sSerie == "1176") CambiarApariencia(2403, "Perro");  //1402
  else if(sSerie == "12") CambiarApariencia(181, "Mastin Sombrio");
  else if(sSerie == "13") CambiarApariencia(184, "Lobo Invernal");
  else if(sSerie == "14") CambiarApariencia(185, "Worg");
  else if(sSerie == "15") CambiarApariencia(2821, "Perro");  //1820

  // 2. FELINOS
  else if(sSerie == "211") CambiarApariencia(2407, "Gato"); //1406
  else if(sSerie == "212") CambiarApariencia(2410, "Gato"); //1409
  else if(sSerie == "213") CambiarApariencia(2408, "Gato"); //1407
  else if(sSerie == "214") CambiarApariencia(2409, "Gato"); //1408
  else if(sSerie == "2151") CambiarApariencia(2412, "Gato"); //1411
  else if(sSerie == "2152") CambiarApariencia(2411, "Gato"); //1410
  else if(sSerie == "22") CambiarApariencia(202, "Pantera");
  else if(sSerie == "23") CambiarApariencia(203, "Puma");
  else if(sSerie == "24") CambiarApariencia(98, "Jaguar");
  else if(sSerie == "25") CambiarApariencia(93, "Leopardo");
  else if(sSerie == "26") CambiarApariencia(2303, "Gato"); //1302
  else if(sSerie == "27") CambiarApariencia(97, "Leon");
  else if(sSerie == "28") CambiarApariencia(2300, "Tigre"); //1299
  else if(sSerie == "29") CambiarApariencia(2301, "Tigre Blanco"); //1300
  else if(sSerie == "2100") CambiarApariencia(306, "Pantera de Malar");
  else if(sSerie == "2110") CambiarApariencia(2932, "Dientes de Sable"); //1931

  // 3. OSOS
  else if(sSerie == "31") CambiarApariencia(12, "Oso Negro");
  else if(sSerie == "32") CambiarApariencia(13, "Oso Pardo");
  else if(sSerie == "33") CambiarApariencia(204, "Oso Grizzly");
  else if(sSerie == "34") CambiarApariencia(14, "Oso Polar");
  else if(sSerie == "35") CambiarApariencia(2296, "Oso Panda"); //1295
  else if(sSerie == "36") CambiarApariencia(2295, "Oso"); //1294
  else if(sSerie == "37") CambiarApariencia(2823, "Oso Legendario"); //1822

  // 4. SERPIENTES
  else if(sSerie == "41") CambiarApariencia(2237, "Serpiente"); //1236
  else if(sSerie == "42") CambiarApariencia(2234, "Serpiente"); //1233
  else if(sSerie == "43") CambiarApariencia(2236, "Serpiente"); //1235
  else if(sSerie == "44") CambiarApariencia(2233, "Serpiente"); //1232
  else if(sSerie == "45") CambiarApariencia(183, "Cobra");
  else if(sSerie == "46") CambiarApariencia(178, "Cobra Negra");
  else if(sSerie == "47") CambiarApariencia(194, "Cobra");
  else if(sSerie == "48") CambiarApariencia(2235, "Serpiente"); //1234
  else if(sSerie == "49") CambiarApariencia(2232, "Serpiente"); //1231

  // 5. INSECTOS
  else if(sSerie == "51") CambiarApariencia(4215, "Mosca");   // Mosca   3214
  else if(sSerie == "52") CambiarApariencia(2989, "Libelula");   // Libelula 1988
  else if(sSerie == "53") CambiarApariencia(2182, "Escorpion");   // Escorpion pequenyo 1181
  else if(sSerie == "54") CambiarApariencia(2895, "Araña Pequeña");   // Aranya pequenya    1894
  else if(sSerie == "55") CambiarApariencia(2193, "Escarabajo Pequeño");   // Escarabajo pequenyo 1192
  else if(sSerie == "56") CambiarApariencia(2990, "Cienpies");   // Cienpies pequenyo   1989
  else if(sSerie == "57") CambiarApariencia(2178, "Escorpion");   // Escorpion           1177
  else if(sSerie == "58") CambiarApariencia(2910, "Araña");   // Aranya              1909
  else if(sSerie == "59") CambiarApariencia(19, "Escarabajo");     // Escarabajo
  else if(sSerie == "5100") CambiarApariencia(2126, "Cienpies"); // Cienpies            1125
  else if(sSerie == "5110") CambiarApariencia(2174, "Escorpion Enorme"); // Escorpion enorme    1173
  else if(sSerie == "5120") CambiarApariencia(2917, "Araña Enorme"); // Aranya enorme       1916
  else if(sSerie == "5130") CambiarApariencia(2194, "Escarabajo Enorme"); // Escarabajo enorme   1193
  else if(sSerie == "5140") CambiarApariencia(2495, "Avispa Enorme"); // Avispa enorme       1494
  else if(sSerie == "5150") CambiarApariencia(2170, "Hormiga Enorme"); // Hormiga enorme      1169

  // 6. AVES
  else if(sSerie == "61") CambiarApariencia(3507, "Cuervo");  //2506
  else if(sSerie == "62") CambiarApariencia(144, "Halcon");
  else if(sSerie == "63") CambiarApariencia(291, "Pajaro");
  else if(sSerie == "64") CambiarApariencia(2980, "Pajaro"); //1979
  else if(sSerie == "65") CambiarApariencia(2976, "Loro Azul"); //1975
  else if(sSerie == "66") CambiarApariencia(2951, "Pajaro"); //1950
  else if(sSerie == "67") CambiarApariencia(7, "Pajaro");
  else if(sSerie == "68") CambiarApariencia(2276, "Aguila"); //1275

  // 7. ANIMALES DE BOSQUE
  else if(sSerie == "71") CambiarApariencia(2309, "Raton"); //1308
  else if(sSerie == "72") CambiarApariencia(10, "Murcielago");
  else if(sSerie == "73") CambiarApariencia(386, "Rata");
  else if(sSerie == "74") CambiarApariencia(2984, "Rata"); //1983
  else if(sSerie == "75") CambiarApariencia(2329, "Mapache"); //1328
  else if(sSerie == "76") CambiarApariencia(4238, "Conejo"); //3237
  else if(sSerie == "77") CambiarApariencia(2342, "Hurón"); //1341
  else if(sSerie == "78") CambiarApariencia(2336, "Nutria"); //1335
  else if(sSerie == "79") CambiarApariencia(8, "Tejón");
  else if(sSerie == "7100") CambiarApariencia(2339, "Zorrillo"); //1338
  else if(sSerie == "7110") CambiarApariencia(21, "Jabali");
  else if(sSerie == "7120") CambiarApariencia(2885, "Jabali"); //1884
  else if(sSerie == "7130") CambiarApariencia(35, "Ciervo");
  else if(sSerie == "7140") CambiarApariencia(37, "Ciervo");
  else if(sSerie == "7150") CambiarApariencia(2334, "Antilope"); //1333
  else if(sSerie == "7160") CambiarApariencia(2750, "Mono Marron"); //1749
  else if(sSerie == "7170") CambiarApariencia(4146, "Gorila"); //3145
  else if(sSerie == "7180") CambiarApariencia(2822, "Jabali Legendario"); //1821

  // 8. ANIMALES DE GRANJA
  else if(sSerie == "81") CambiarApariencia(31, "Gallina");    // gallina
  else if(sSerie == "82") CambiarApariencia(2026, "Cerdo");  // cerdo 1025
  else if(sSerie == "83") CambiarApariencia(34, "Vaca");    // vaca
  else if(sSerie == "84") CambiarApariencia(142, "Buey");   // buey
  else if(sSerie == "85") CambiarApariencia(2019, "Toro");  // toro  1018
  else if(sSerie == "86") CambiarApariencia(2009, "Ganado");  // ganado 1008

  // 9. ANIMALES ACUATICOS
  else if(sSerie == "91") CambiarApariencia(206, "Pinguino");    // pinguino
  else if(sSerie == "92") CambiarApariencia(2431, "Cangrejo");   // cangrejo  1430
  else if(sSerie == "93") CambiarApariencia(4471, "Langosta");   // langosta  1981
  else if(sSerie == "94") CambiarApariencia(4210, "Sapo");   // sapo      3209
  else if(sSerie == "95") CambiarApariencia(4198, "Rana");   // rana      3200
  else if(sSerie == "96") CambiarApariencia(7524, "Tortuga");   // tortuga   3261
  else if(sSerie == "97") CambiarApariencia(447, "Tibueron");    // tiburon
  else if(sSerie == "98") CambiarApariencia(2880, "Tiburon Enorme");   // tiburon enorme 1880
  else if(sSerie == "99") CambiarApariencia(2430, "Cangrejo Enorme");   // cangrejo enorme  1429
  else if(sSerie == "9100") CambiarApariencia(4175, "Cocodrilo"); // cocodrilo   3171
  else if(sSerie == "9110") CambiarApariencia(4225, "Leviatan"); // leviatan    3224

  // 10. CABALLOS
  else if(sSerie == "1001") CambiarApariencia(2797, "Burro");   // burro  1796
  else if(sSerie == "1002") CambiarApariencia(496, "Caballo Marron");    // caballo marron
  else if(sSerie == "1003") CambiarApariencia(522, "Caballo Moteado");    // caballo moteado
  else if(sSerie == "1004") CambiarApariencia(3590, "Caballo Blanco");   // caballo blanco 2589
  else if(sSerie == "1005") CambiarApariencia(535, "Caballo Negro");    // caballo negro
  else if(sSerie == "1006") CambiarApariencia(509, "Caballo Gris");    // caballo gris
  else if(sSerie == "1007") CambiarApariencia(3534, "Unicornio Blanco");   // unicornio blanco  2533
  else if(sSerie == "1008") CambiarApariencia(3519, "Unicornio Negro");   // unicornio negro   2518
  else if(sSerie == "1009") CambiarApariencia(3560, "Pegaso Blanco");   // pegaso blanco     2559
  else if(sSerie == "100100") CambiarApariencia(3561, "Pegaso Marron"); // pegaso marron     2560

  // 11. VEGETALES
  else if(sSerie == "1101") CambiarApariencia(2497, "Raices Horizonteales"); // raices horizontales 1496
  else if(sSerie == "1102") CambiarApariencia(2498, "Raices Verticales"); // raices verticales   1497
  else if(sSerie == "1103") CambiarApariencia(2056, "Miconido"); // miconido            1055
  else if(sSerie == "1104") CambiarApariencia(2057, "Brote Miconido"); // miconido brote      1056
  else if(sSerie == "1105") CambiarApariencia(2058, "Miconido Anciano"); // miconido anciano    1057
  else if(sSerie == "1106") CambiarApariencia(2061, "Vegepigmeo"); // Vegepigmeo          1060
  else if(sSerie == "1107") CambiarApariencia(2062, "Espinoso"); // Espinoso            1061
  else if(sSerie == "1108") CambiarApariencia(3598, "Ent Pequeño"); // Ent pequenyo        2597
  else if(sSerie == "1109") CambiarApariencia(2493, "Ent"); // Ent                 1492

  // LAS MIL CARAS
  // 12. ELFOS / NINFAS / DRIADAS
  else if(sSerie == "1201") CambiarApariencia(1, "Elfo", 200, TRUE);    // Elfo basico
  else if(sSerie == "1202") CambiarApariencia(246, "Elfo", 200, TRUE);  // Elfo urbano
  else if(sSerie == "1203") CambiarApariencia(4020, "Elfa", 200, TRUE); // Elfa oriental 3019
  else if(sSerie == "1204") CambiarApariencia(247, "Elfo del Bosque", 200, TRUE);  // Elfo del bosque
  else if(sSerie == "1205") CambiarApariencia(245, "Elfa del Bosque", 200, TRUE);  // Elfa del bosque
  else if(sSerie == "1206") CambiarApariencia(51, "Driada", 200, TRUE);   // Driada
  else if(sSerie == "1207") CambiarApariencia(126, "Ninfa", 200, TRUE);  // Ninfa
  else if(sSerie == "1208") CambiarApariencia(476, "Drow Guerrero", 200, TRUE);  // Drow guerrero
  else if(sSerie == "1209") CambiarApariencia(410, "Sacerdotisa Drow", 200, TRUE);  // Drow sacerdotisa

  // 13. HUMANOS
  else if(sSerie == "1301") CambiarApariencia(6, "Hombre", 200, TRUE);    // Humano basico
  else if(sSerie == "1302") CambiarApariencia(239, "Anciano", 200, TRUE);  // Anciano urbano
  else if(sSerie == "1303") CambiarApariencia(4023, "Campesino Anciano", 200, TRUE); // Anciano campesino 3022
  else if(sSerie == "1304") CambiarApariencia(4005, "Hombre Misterioso", 200, TRUE); // Adulto tunica negra  3004
  else if(sSerie == "1305") CambiarApariencia(4006, "Hombre Encapuchado", 200, TRUE); // Tunica negra encapuchado 3005
  else if(sSerie == "1306") CambiarApariencia(450, "Mujer Noble", 200, TRUE);  // Mujer noble
  else if(sSerie == "1307") CambiarApariencia(4007, "Mujer Aventurera", 200, TRUE); // Mujer aventurera  3006
  else if(sSerie == "1308") CambiarApariencia(233, "Apuesto Joven", 200, TRUE);  // Apuesto joven
  else if(sSerie == "1309") CambiarApariencia(235, "Jovencita", 200, TRUE);  // Apuesta joven

  // 14. ENANOS
  else if(sSerie == "1401") CambiarApariencia(0, "Enano", 200, TRUE);   // Enano basico
  else if(sSerie == "1402") CambiarApariencia(411, "Duergar", 200, TRUE); // Duergar varon
  else if(sSerie == "1403") CambiarApariencia(412, "Duergar", 200, TRUE); // Duergar hembra

  // 15. MEDIANOS / GNOMOS / NIÑOS HUMANOS
  else if(sSerie == "1501") CambiarApariencia(3, "Hin", 200, TRUE);    // Mediano basico
  else if(sSerie == "1502") CambiarApariencia(2, "Gnomo", 200, TRUE);    // Gnomo basico
  else if(sSerie == "1503") CambiarApariencia(243, "Gnoma", 200, TRUE);  // Gnoma urbana
  else if(sSerie == "1504") CambiarApariencia(244, "Gnomo", 200, TRUE);  // Gnomo urbano
  else if(sSerie == "1505") CambiarApariencia(241, "Niño", 200, TRUE);  // Ninyo humano
  else if(sSerie == "1506") CambiarApariencia(4024, "Niño Pobre", 200, TRUE); // Ninyo humano pobre 3023
  else if(sSerie == "1507") CambiarApariencia(423, "Svirfneblin", 200, TRUE);  // Svirfneblin varon
  else if(sSerie == "1508") CambiarApariencia(424, "Svirfnablin", 200, TRUE);  // Svirfnablin hembra

  // 16. TRASGOS
  else if(sSerie == "1601") CambiarApariencia(86, "Trasgo", 200, TRUE);   // Trasgo
  else if(sSerie == "1602") CambiarApariencia(84, "Trasgo Chaman", 200, TRUE);   // Trasgo chaman
  else if(sSerie == "1603") CambiarApariencia(83, "Trasgo de Elite", 200, TRUE);   // Trasgo de elite
  else if(sSerie == "1604") CambiarApariencia(2158, "Trasgo de las Nieves", 200, TRUE); // Trasgo de las nieves   1157

  // 17. ORCOS / OSGOS
  else if(sSerie == "1701") CambiarApariencia(5, "Semiorco", 200, TRUE);    // Semiorco basico
  else if(sSerie == "1702") CambiarApariencia(140, "Orco", 200, TRUE);  // Orco
  else if(sSerie == "1703") CambiarApariencia(138, "Orco Chaman", 200, TRUE);  // Orco chaman
  else if(sSerie == "1704") CambiarApariencia(2145, "Orco de Armadura Negra", 200, TRUE); // Orco armadura negra  1144
  else if(sSerie == "1705") CambiarApariencia(136, "Orco Cacique", 200, TRUE);  // Orco cacique
  else if(sSerie == "1706") CambiarApariencia(27, "Osgo", 200, TRUE);   // Osgo
  else if(sSerie == "1707") CambiarApariencia(2584, "Osgo de Guerra", 200, TRUE); // Osgo de guerra 1583

  // 18. OGROS / MINOTAUROS
  else if(sSerie == "1801") CambiarApariencia(2536, "Ogro", 200, TRUE); // Ogro 1535
  else if(sSerie == "1802") CambiarApariencia(129, "Ogro Hechicero", 200, TRUE);  // Ogro hechicero
  else if(sSerie == "1803") CambiarApariencia(128, "Ogro Cacique", 200, TRUE);  // Ogro cacique
  else if(sSerie == "1804") CambiarApariencia(122, "Minotauro Chaman", 200, TRUE);  // Minotauro chaman
  else if(sSerie == "1805") CambiarApariencia(121, "Minotauro Cacique", 200, TRUE);  // Minotauro cacique
}
