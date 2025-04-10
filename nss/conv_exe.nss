#include "mti_libreria"

void MemorizarConjuro(string sConjuro, string sCriatura, string sVariable, string sResref, int iEfectoVisual)
{
  SendMessageToPC(OBJECT_SELF, "<c4~ø>Has memorizado la criatura <c4ó©>[" + sCriatura + "]<c4~ø> para el conjuro <c4ó©>[" + sConjuro + "]<c4~ø>. La próxima vez que lances el mencionado conjuro convocarás a esta criatura.</c></c></c></c></c>" );
  GuardarStringPersistente(OBJECT_SELF, sVariable, sResref);
  GuardarStringPersistente(OBJECT_SELF, sVariable + "NOMBRE", sCriatura);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(iEfectoVisual), OBJECT_SELF);
}

void main()
{
  string sSerie = GetLocalString(OBJECT_SELF, "CONVSERIE");
  string sNombreCriatura;

  // CONVOCAR CRIATURA I
  if(sSerie == "11") MemorizarConjuro("Convocar criatura I", "Lamparconte", "CONV1", "conv_lamparconte", 52);
  else if(sSerie == "12") MemorizarConjuro("Convocar criatura I", "Nixi", "CONV1", "conv_nixi", 52);
  else if(sSerie == "13") MemorizarConjuro("Convocar criatura I", "Águila", "CONV1", "conv_aguila", 52);
  else if(sSerie == "14") MemorizarConjuro("Convocar criatura I", "Víbora pequeña", "CONV1", "conv_viborapeq", 52);
  else if(sSerie == "15") MemorizarConjuro("Convocar criatura I", "Fuego fatuo menor", "CONV1", "conv_ffatuo", 52);
  else if(sSerie == "16") MemorizarConjuro("Convocar criatura I", "Tejón terrible", "CONV1", "NW_S_badgerdire", 52);

  // CONVOCAR CRIATURA II
  else if(sSerie == "21") MemorizarConjuro("Convocar criatura II", "Perro intermitente", "CONV2", "conv_perroint", 52);
  else if(sSerie == "22") MemorizarConjuro("Convocar criatura II", "Hipogrifo", "CONV2", "conv_hipogrifo", 52);
  else if(sSerie == "23") MemorizarConjuro("Convocar criatura II", "Bisonte", "CONV2", "conv_bisonte", 52);
  else if(sSerie == "24") MemorizarConjuro("Convocar criatura II", "Glotón", "CONV2", "conv_gloton", 52);
  else if(sSerie == "25") MemorizarConjuro("Convocar criatura II", "Diablillo", "CONV2", "conv_diablillo", 52);
  else if(sSerie == "26") MemorizarConjuro("Convocar criatura II", "Jabalí terrible", "CONV2", "NW_S_BOARDIRE", 52);

  // CONVOCAR CRIATURA III
  else if(sSerie == "31") MemorizarConjuro("Convocar criatura III", "Oso negro celestial", "CONV3", "conv_osoncel", 52);
  else if(sSerie == "321") MemorizarConjuro("Convocar criatura III", "Elemental de agua pequeño", "CONV3", "conv_eleagupeq", 52);
  else if(sSerie == "322") MemorizarConjuro("Convocar criatura III", "Elemental de aire pequeño", "CONV3", "conv_eleairpeq", 52);
  else if(sSerie == "323") MemorizarConjuro("Convocar criatura III", "Elemental de fuego pequeño", "CONV3", "conv_elefuepeq", 52);
  else if(sSerie == "324") MemorizarConjuro("Convocar criatura III", "Elemental de tierra pequeño", "CONV3", "conv_eletiepeq", 52);
  else if(sSerie == "33") MemorizarConjuro("Convocar criatura III", "León", "CONV3", "conv_leon", 52);
  else if(sSerie == "34") MemorizarConjuro("Convocar criatura III", "Lobo terrible", "CONV3", "NW_S_WOLFDIRE", 52);
  else if(sSerie == "35") MemorizarConjuro("Convocar criatura III", "Can del infierno", "CONV3", "conv_caninf", 52);

  // CONVOCAR CRIATURA IV
  else if(sSerie == "41") MemorizarConjuro("Convocar criatura IV", "Canarconte", "CONV4", "conv_canarconte", 52);
  else if(sSerie == "421") MemorizarConjuro("Convocar criatura IV", "Méfit de magma", "CONV4", "conv_mefitmag", 52);
  else if(sSerie == "422") MemorizarConjuro("Convocar criatura IV", "Méfit de polvo", "CONV4", "conv_mefitpol", 52);
  else if(sSerie == "423") MemorizarConjuro("Convocar criatura IV", "Méfit de sal", "CONV4", "conv_mefitsal", 52);
  else if(sSerie == "424") MemorizarConjuro("Convocar criatura IV", "Méfit de vapor", "CONV4", "conv_mefitvap", 52);
  else if(sSerie == "43") MemorizarConjuro("Convocar criatura IV", "Tigre", "CONV4", "conv_tigre", 52);
  else if(sSerie == "44") MemorizarConjuro("Convocar criatura IV", "Araña terrible", "CONV4", "NW_S_SPIDDIRE", 52);
  else if(sSerie == "45") MemorizarConjuro("Convocar criatura IV", "Salamandra flámico", "CONV4", "conv_sal1", 52);
  else if(sSerie == "46") MemorizarConjuro("Convocar criatura IV", "Avispa gigante infernal", "CONV4", "conv_avispainf", 52);

  // CONVOCAR CRIATURA V
  else if(sSerie == "51") MemorizarConjuro("Convocar criatura V", "Lilenda", "CONV5", "conv_lilenda", 52);
  else if(sSerie == "52") MemorizarConjuro("Convocar criatura V", "Oso polar", "CONV5", "conv_osopolar", 52);
  else if(sSerie == "53") MemorizarConjuro("Convocar criatura V", "Basilisco", "CONV5", "conv_basilisco", 52);
  else if(sSerie == "54") MemorizarConjuro("Convocar criatura V", "Oso terrible", "CONV5", "NW_S_beardire", 52);
  else if(sSerie == "55") MemorizarConjuro("Convocar criatura V", "Lobo invernal", "CONV5", "conv_loboinv", 52);
  else if(sSerie == "56") MemorizarConjuro("Convocar criatura V", "Mastín sombrío", "CONV5", "conv_mastinsom", 52);
  else if(sSerie == "57") MemorizarConjuro("Convocar criatura V", "Sátiro", "CONV5", "conv_satiro", 52);

  // CONVOCAR CRIATURA VI
  else if(sSerie == "61") MemorizarConjuro("Convocar criatura VI", "Bralani", "CONV6", "conv_bralani", 52);
  else if(sSerie == "62") MemorizarConjuro("Convocar criatura VI", "Escorpión enorme", "CONV6", "conv_esceno", 52);
  else if(sSerie == "63") MemorizarConjuro("Convocar criatura VI", "Draco", "CONV6", "conv_draco", 52);
  else if(sSerie == "64") MemorizarConjuro("Convocar criatura VI", "Tigre terrible", "CONV6", "NW_S_diretiger", 52);
  else if(sSerie == "65") MemorizarConjuro("Convocar criatura VI", "Slaad rojo", "CONV6", "conv_slaadrojo", 52);
  else if(sSerie == "66") MemorizarConjuro("Convocar criatura VI", "Fuego fatuo", "CONV6", "conv_ffatuo2", 52);
  else if(sSerie == "67") MemorizarConjuro("Convocar criatura VI", "Pixi", "CONV6", "conv_pixi", 52);

  // CONVOCAR CRIATURA VII
  else if(sSerie == "71") MemorizarConjuro("Convocar criatura VII", "Lamasu", "CONV7", "conv_lamasu", 52);
  else if(sSerie == "72") MemorizarConjuro("Convocar criatura VII", "Ent", "CONV7", "conv_ent", 52);
  else if(sSerie == "73") MemorizarConjuro("Convocar criatura VII", "Formícida capataz", "CONV7", "conv_formicidaca", 52);
  else if(sSerie == "741") MemorizarConjuro("Convocar criatura VII", "Elemental de agua enorme", "CONV7", "NW_S_WATERHUGE", 52);
  else if(sSerie == "742") MemorizarConjuro("Convocar criatura VII", "Elemental de aire enorme", "CONV7", "NW_S_AIRHUGE", 52);
  else if(sSerie == "743") MemorizarConjuro("Convocar criatura VII", "Elemental de fuego enorme", "CONV7", "NW_S_FIREHUGE", 52);
  else if(sSerie == "744") MemorizarConjuro("Convocar criatura VII", "Elemental de tierra enorme", "CONV7", "conv_eletieeno", 52);
  else if(sSerie == "75") MemorizarConjuro("Convocar criatura VII", "Slaad azul", "CONV7", "conv_slaadazul", 52);
  else if(sSerie == "76") MemorizarConjuro("Convocar criatura VII", "Hamatula", "CONV7", "conv_hamatula", 52);
  else if(sSerie == "77") MemorizarConjuro("Convocar criatura VII", "Tricerátopo", "CONV7", "conv_triceratops", 52);

  // CONVOCAR CRIATURA VIII
  else if(sSerie == "81") MemorizarConjuro("Convocar criatura VIII", "Djinni", "CONV8", "conv_djinni", 52);
  else if(sSerie == "821") MemorizarConjuro("Convocar criatura VIII", "Elemental de agua mayor", "CONV8", "NW_S_WATERGREAT", 52);
  else if(sSerie == "822") MemorizarConjuro("Convocar criatura VIII", "Elemental de aire mayor", "CONV8", "NW_S_AIRGREAT", 52);
  else if(sSerie == "823") MemorizarConjuro("Convocar criatura VIII", "Elemental de fuego mayor", "CONV8", "NW_S_FIREGREAT", 52);
  else if(sSerie == "824") MemorizarConjuro("Convocar criatura VIII", "Elemental de tierra mayor", "CONV8", "conv_eletiemay", 52);
  else if(sSerie == "83") MemorizarConjuro("Convocar criatura VIII", "Slaad verde", "CONV8", "conv_slaadverde", 52);
  else if(sSerie == "84") MemorizarConjuro("Convocar criatura VIII", "Rakshasa", "CONV8", "conv_rakasha", 52);
  else if(sSerie == "85") MemorizarConjuro("Convocar criatura VIII", "Salamandra noble", "CONV8", "conv_salnob", 52);
  else if(sSerie == "86") MemorizarConjuro("Convocar criatura VIII", "Bébilith", "CONV8", "conv_bebilith", 52);
  else if(sSerie == "87") MemorizarConjuro("Convocar criatura VIII", "Tiranosaurio", "CONV8", "conv_tiranosauri", 52);

  // CONVOCAR CRIATURA IX
  else if(sSerie == "91") MemorizarConjuro("Convocar criatura IX", "Leonal", "CONV9", "conv_leonal", 52);
  else if(sSerie == "92") MemorizarConjuro("Convocar criatura IX", "Formícida myrmarca", "CONV9", "conv_formyr", 52);
  else if(sSerie == "931") MemorizarConjuro("Convocar criatura IX", "Elemental de agua anciano", "CONV9", "NW_S_WATERELDER", 52);
  else if(sSerie == "932") MemorizarConjuro("Convocar criatura IX", "Elemental de aire anciano", "CONV9", "NW_S_AIRELDER", 52);
  else if(sSerie == "933") MemorizarConjuro("Convocar criatura IX", "Elemental de fuego anciano", "CONV9", "NW_S_FIREELDER", 52);
  else if(sSerie == "934") MemorizarConjuro("Convocar criatura IX", "Elemental de tierra anciano", "CONV9", "conv_eletieanc", 52);
  else if(sSerie == "94") MemorizarConjuro("Convocar criatura IX", "Golem de arcilla", "CONV9", "conv_golarc", 52);
  else if(sSerie == "95") MemorizarConjuro("Convocar criatura IX", "Slaad gris", "CONV9", "conv_slaadgris", 52);
  else if(sSerie == "96") MemorizarConjuro("Convocar criatura IX", "Cornugón", "CONV9", "conv_cornugon", 52);
  else if(sSerie == "97") MemorizarConjuro("Convocar criatura IX", "Unicornio celestial", "CONV9", "conv_unicornioce", 52);


  // REANIMAR A LOS MUERTOS
  else if(sSerie == "1001") MemorizarConjuro("Reanimar a los muertos", "Esqueleto", "CONV10", "conv_esqueleto", 52);
  else if(sSerie == "1002") MemorizarConjuro("Reanimar a los muertos", "Zombi", "CONV10", "conv_zombi", 52);
  else if(sSerie == "1003") MemorizarConjuro("Reanimar a los muertos", "Zombi de la Bruma Tirana", "CONV10", "NW_S_ZOMBTYRANT", 52);
  else if(sSerie == "1004") MemorizarConjuro("Reanimar a los muertos", "Combatiente esqueleto", "CONV10", "NW_S_SKELWARR", 52);
  else if(sSerie == "1005") MemorizarConjuro("Reanimar a los muertos", "Alip", "CONV10", "conv_alip", 52);
  else if(sSerie == "1006") MemorizarConjuro("Reanimar a los muertos", "Jefe esqueleto", "CONV10", "NW_S_SKELCHIEF", 52);
  else if(sSerie == "1007") MemorizarConjuro("Reanimar a los muertos", "Engendro vampírico", "CONV10", "conv_engendro", 52);
  else if(sSerie == "1008") MemorizarConjuro("Reanimar a los muertos", "Llama lúgubre", "CONV10", "conv_llalug", 52);
  else if(sSerie == "1009") MemorizarConjuro("Reanimar a los muertos", "Fantasma quejumbroso", "CONV10", "conv_fanque", 52);
  else if(sSerie == "100100") MemorizarConjuro("Reanimar a los muertos", "Esqueleto de enano", "CONV10", "conv_esqena", 52);
  else if(sSerie == "100110") MemorizarConjuro("Reanimar a los muertos", "Murciélago esquelético", "CONV10", "conv_muresq", 52);
  else if(sSerie == "100120") MemorizarConjuro("Reanimar a los muertos", "Zombi descompuesto", "CONV10", "conv_zomdes", 52);
  else if(sSerie == "100130") MemorizarConjuro("Reanimar a los muertos", "Mágico esqueleto", "CONV10", "conv_magesq", 52);
  else if(sSerie == "100140") MemorizarConjuro("Reanimar a los muertos", "Sacerdote esqueleto", "CONV10", "conv_sacesq", 52);

  // CREAR MUERTOS VIVIENTES
  else if(sSerie == "1101") MemorizarConjuro("Crear muertos vivientes", "Esqueleto de ogro", "CONV11", "conv_esqogr", 52);
  else if(sSerie == "1102") MemorizarConjuro("Crear muertos vivientes", "Necrófago", "CONV11", "NW_S_GHOUL", 52);
  else if(sSerie == "1103") MemorizarConjuro("Crear muertos vivientes", "Esqueleto ígneo", "CONV11", "conv_esqign", 52);
  else if(sSerie == "1104") MemorizarConjuro("Crear muertos vivientes", "Esqueleto gélido", "CONV11", "conv_esqgel", 52);
  else if(sSerie == "1105") MemorizarConjuro("Crear muertos vivientes", "Esqueleto eléctrico", "CONV11", "conv_esqele", 52);
  else if(sSerie == "1106") MemorizarConjuro("Crear muertos vivientes", "Esqueleto cáustico", "CONV11", "conv_esqcau", 52);
  else if(sSerie == "1107") MemorizarConjuro("Crear muertos vivientes", "Esqueleto dañino", "CONV11", "conv_esqdan", 52);
  else if(sSerie == "1108") MemorizarConjuro("Crear muertos vivientes", "Necrario", "CONV11", "NW_S_GHAST", 52);
  else if(sSerie == "1109") MemorizarConjuro("Crear muertos vivientes", "Tumulario", "CONV11", "NW_S_WIGHT", 52);
  else if(sSerie == "110100") MemorizarConjuro("Crear muertos vivientes", "Señor de los zombis", "CONV11", "conv_senzom", 52);
  else if(sSerie == "110110") MemorizarConjuro("Crear muertos vivientes", "Momia", "CONV11", "conv_momia", 52);
  else if(sSerie == "110120") MemorizarConjuro("Crear muertos vivientes", "Espectro", "CONV11", "NW_S_SPECTRE", 52);
  else if(sSerie == "110130") MemorizarConjuro("Crear muertos vivientes", "Mohrg", "CONV11", "conv_mohrg", 52);

  // CREAR MUERTOS VIVIENTES MAYORES
  else if(sSerie == "1201") MemorizarConjuro("Crear muertos vivientes mayores", "Sacerdote Vampira", "CONV12", "convampiro", 52);
  else if(sSerie == "1202") MemorizarConjuro("Crear muertos vivientes mayores", "Sombra", "CONV12", "X1_S_SHADOW", 52);
  else if(sSerie == "1203") MemorizarConjuro("Crear muertos vivientes mayores", "Guerrera vampira", "CONV12", "conv_guevam", 52);
  else if(sSerie == "1204") MemorizarConjuro("Crear muertos vivientes mayores", "Bódak", "CONV12", "conv_bodak", 52);
  else if(sSerie == "1205") MemorizarConjuro("Crear muertos vivientes mayores", "Alhún", "CONV12", "conv_alhun", 52);
  else if(sSerie == "1206") MemorizarConjuro("Crear muertos vivientes mayores", "Caballero condenado", "CONV12", "NW_S_DOOMKGHT", 52);
  else if(sSerie == "1207") MemorizarConjuro("Crear muertos vivientes mayores", "Incorpóreo", "CONV12", "X2_S_WRAITH", 52);
  else if(sSerie == "1208") MemorizarConjuro("Crear muertos vivientes mayores", "Liche", "CONV12", "x2_s_lich_20", 52);
  else if(sSerie == "1209") MemorizarConjuro("Crear muertos vivientes mayores", "Espectro", "CONV12", "X2_S_SPECTRE_10", 52);
  else if(sSerie == "120100") MemorizarConjuro("Crear muertos vivientes mayores", "Momia mayor", "CONV12", "NW_S_MUMCLERIC", 52);
  else if(sSerie == "120110") MemorizarConjuro("Crear muertos vivientes mayores", "Devorador óseo", "CONV12", "conv_devose", 52);
  else if(sSerie == "120120") MemorizarConjuro("Crear muertos vivientes mayores", "Liche nigromante", "CONV12", "conv_licnig", 52);
  else if(sSerie == "120130") MemorizarConjuro("Crear muertos vivientes mayores", "Gólem de hueso", "CONV12", "conv_golhue", 52);

  // CONVOCAR MUERTOS VIVIENTES
  else if(sSerie == "1301") MemorizarConjuro("Convocar muertos vivientes", "Necrófago", "CONV13", "NW_S_GHOUL", 52);
  else if(sSerie == "1302") MemorizarConjuro("Convocar muertos vivientes", "Sombra", "CONV13", "NW_S_SHADOW", 52);
  else if(sSerie == "1303") MemorizarConjuro("Convocar muertos vivientes", "Momia", "CONV13", "conv_momia", 52);
  else if(sSerie == "1304") MemorizarConjuro("Convocar muertos vivientes", "Necrario", "CONV13", "NW_S_GHAST", 52);
  else if(sSerie == "1305") MemorizarConjuro("Convocar muertos vivientes", "Tumulario", "CONV13", "NW_S_WIGHT", 52);
  else if(sSerie == "1306") MemorizarConjuro("Convocar muertos vivientes", "Incorpóreo", "CONV13", "X2_S_WRAITH", 52);
  else if(sSerie == "1307") MemorizarConjuro("Convocar muertos vivientes", "Mohrg", "CONV13", "conv_mohrg", 52);
  else if(sSerie == "1308") MemorizarConjuro("Convocar muertos vivientes", "Esqueleto de ogro", "CONV13", "conv_esqogr", 52);
  else if(sSerie == "1309") MemorizarConjuro("Convocar muertos vivientes", "Esqueleto ígneo", "CONV13", "conv_esqign", 52);
  else if(sSerie == "130100") MemorizarConjuro("Convocar muertos vivientes", "Esqueleto gélido", "CONV13", "conv_esqgel", 52);
  else if(sSerie == "130110") MemorizarConjuro("Convocar muertos vivientes", "Esqueleto eléctrico", "CONV13", "conv_esqele", 52);
  else if(sSerie == "130120") MemorizarConjuro("Convocar muertos vivientes", "Esqueleto cáustico", "CONV13", "conv_esqcau", 52);
  else if(sSerie == "130130") MemorizarConjuro("Convocar muertos vivientes", "Esqueleto dañino", "CONV13", "conv_esqdan", 52);
  else if(sSerie == "130140") MemorizarConjuro("Convocar muertos vivientes", "Señor de los zombis", "CONV13", "conv_senzom", 52);

  // CONVOCAR MUERTOS VIVIENTES MAYORES
  else if(sSerie == "1401") MemorizarConjuro("Convocar muertos vivientes mayores", "Sacerdote Vampira", "CONV14", "convampiro", 52);
  else if(sSerie == "1402") MemorizarConjuro("Convocar muertos vivientes mayores", "Caballero condenado", "CONV14", "NW_S_DOOMKGHT", 52);
  else if(sSerie == "1403") MemorizarConjuro("Convocar muertos vivientes mayores", "Liche", "CONV14", "x2_s_lich_20", 52); // NW_S_LICH
  else if(sSerie == "1404") MemorizarConjuro("Convocar muertos vivientes mayores", "Momia combatiente", "CONV14", "X2_S_MUMMY_9", 52);
  else if(sSerie == "1405") MemorizarConjuro("Convocar muertos vivientes mayores", "Momia mayor", "CONV14", "NW_S_MUMCLERIC", 52);
  else if(sSerie == "1406") MemorizarConjuro("Convocar muertos vivientes mayores", "Espectro", "CONV14", "X2_S_SPECTRE_10", 52);
  else if(sSerie == "1407") MemorizarConjuro("Convocar muertos vivientes mayores", "Devorador óseo", "CONV14", "conv_devose", 52);
  else if(sSerie == "140100") MemorizarConjuro("Convocar muertos vivientes mayores", "Guerrera vampira", "CONV14", "conv_guevam", 52);
  else if(sSerie == "140110") MemorizarConjuro("Convocar muertos vivientes mayores", "Bódak", "CONV14", "conv_bodak", 52);
  else if(sSerie == "140120") MemorizarConjuro("Convocar muertos vivientes mayores", "Alhún", "CONV14", "conv_alhun", 52);
  else if(sSerie == "140130") MemorizarConjuro("Convocar muertos vivientes mayores", "Liche nigromante", "CONV14", "conv_licnig", 52);
  else if(sSerie == "140140") MemorizarConjuro("Convocar muertos vivientes mayores", "Gólem de hueso", "CONV14", "conv_golhue", 52);
  else if(sSerie == "1408") MemorizarConjuro("Convocar muertos vivientes mayores", "Pícaro vampiro", "CONV14", "X2_S_VAMP_10", 52);
  else if(sSerie == "1409") MemorizarConjuro("Convocar muertos vivientes mayores", "Bodak mayor", "CONV14", "X2_S_BODAK_14", 52);

  // UMBRAL
  else if(sSerie == "1501") MemorizarConjuro("Umbral", "Deva astral", "CONV15", "asy_solarconv", 52);
  else if(sSerie == "1502") MemorizarConjuro("Umbral", "Asesino concordante", "CONV15", "con_asecon", 52);
  else if(sSerie == "1503") MemorizarConjuro("Umbral", "Bálor", "CONV15", "conv_balor", 52);
}
