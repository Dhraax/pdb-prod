//::////////////////////////////////////////////////////////////////////////////
//:: PUERTA DE BALDUR I (www.puertadebaldur.net)
//:: SCRIPT: LIBRERIA DEL SISTEMA DE REGENERACION DE TESOROS EN COFRES Y PNJS
//:: Creado por: Monti
//:: Creado el: 20/09/11
//::////////////////////////////////////////////////////////////////////////////

#include "x2_inc_itemprop"
#include "pb_constantes"

// Esta funcion debera ir en el OnSpawn de la criatura
// Crea objetos a la criatura. Porcentages configurables en la funcion
// El tipo de tesoro viene determinado por el VD de la criatura (rango 1-5)
// Criaturas epicas o jefazos tienen tesoro especial determinado por una variable
// Criaturas diminutas, animales, o con variable especial no tienen tesoro
void GenerarTesoroEnCriaturas();

// Esta funcion debera ir en el OnOpen del ubicado
// Crea objetos en el ubicado. Porcentages configurables en la funcion
// En los ubicados los objetos generados pueden ser de 3 tipos de calidad:
// 1 : Calidad baja  (rango 1-2)
// 2 : Calidad media (rango 2-3)
// 3 : Calidad alta  (rango 3-4)
void GenerarTesoroEnUbicados(object oPC, int iCalidad=1);

// Debug: Funcion para comprobar fallos. Comprueba si un objeto tiene o no la
// propiedad que acaba de anyadir
void DebugComprobarCorrectaAplicacionPropiedad(object oObjetoCreado, int iPropiedad, int iTipoEfecto=0, int iCD=0, int iEspecial=0)
{
  if(GetItemHasItemProperty(oObjetoCreado, iPropiedad) == FALSE)
  {
      WriteTimestampedLogEntry("[SISTEMA DE TESOROS] Error de aplicaciÛn de propiedad en objeto. Propiedad no aplicada "+IntToString(iPropiedad)+". Resref del objeto "+GetResRef(oObjetoCreado)+". Nombre del objeto "+GetName(oObjetoCreado)+".");
      if(iPropiedad == 48) WriteTimestampedLogEntry("[SISTEMA DE TESOROS] An·lisis propiedad 48. iTipoEfecto: "+IntToString(iTipoEfecto)+"; iCD: "+IntToString(iCD)+"; iEspecial: "+IntToString(iEspecial));
  }
}

const string COLORTOKEN ="     !##$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]]^_`abcdefghijklmnopqrstuvwxyz{|}~ÄùÇÉÑÖÜáàâäãåùéùùëíìîïñóòôöõúùûü†°¢£§•¶ß®©™´¨≠ÆØ∞±≤≥¥µ∂∑∏π∫ªºΩæø¿¡¬√ƒ≈∆«»… ÀÃÕŒœ–—“”‘’÷◊ÿŸ⁄€‹›ﬁﬂ‡·‚„‰ÂÊÁËÈÍÎÏÌÓÔÒÚÛÙıˆ˜¯˘˙˚¸˝˛˛";

string ColorString(string sText, int nRed=255, int nGreen=255, int nBlue=255)
{
    return "<c" + GetSubString(COLORTOKEN, nRed, 1) + GetSubString(COLORTOKEN, nGreen, 1) + GetSubString(COLORTOKEN, nBlue, 1) + ">" + sText + "</c>";
}

void CrearOro(object oObjetivo, int iRango, int iCofre=FALSE)
{
  int iCantidadOro;
  switch(iRango)
  {
      case 1:  iCantidadOro= Random(50) + 10; break;      //Random(50) + 10
      case 2:  iCantidadOro = Random(10); break;    //Random(100) + 100
      case 3:  iCantidadOro = Random(20); break;    //Random(200) + 100
      case 4:  iCantidadOro = Random(40); break;    //Random(400) + 100
      case 5:  iCantidadOro = Random(50); break;    //Random(500) + 20
      case 6:  iCantidadOro = Random(200); break;   //Random(5000) + 5000;
      case 7:  iCantidadOro = Random(400); break;   //Random(10000) + 10000;
      case 8:  iCantidadOro = Random(600); break;   //Random(20000) + 20000;
      case 9:  iCantidadOro = Random(1000); break;  //Random(40000) + 40000;
      case 10: iCantidadOro = Random(2000); break;  //Random(40000) + 40000;
  }

  if(d100() <= 5) iCantidadOro = iCantidadOro * iRango;

  if(iCofre == TRUE) iCantidadOro = iCantidadOro * d2(2);

  CreateItemOnObject("NW_IT_GOLD001", oObjetivo, iCantidadOro);
}

string ObtenerResrefPergaminoNivelCeroAleatorio()
{
  string sResref;

  switch(Random(11)+1)
  {
      // Pergas nivel 0
      case 1:  sResref = "x1_it_sparscr002";break;
      case 2:  sResref = "x2_it_spdvscr001";break;
      case 3:  sResref = "nw_it_sparscr003";break;
      case 4:  sResref = "x1_it_sparscr003";break;
      case 5:  sResref = "x1_it_sparscr001";break;
      case 6:  sResref = "x1_it_spdvscr001";break;
      case 7:  sResref = "nw_it_sparscr004";break;
      case 8:  sResref = "nw_it_sparscr002";break;
      case 9:  sResref = "nw_it_sparscr001";break;
      case 10: sResref = "x2_it_spdvscr002";break;
      case 11: sResref = "perga_creagu3";break;
  }

  return sResref;
}

string ObtenerResrefPergaminoNivelUnoAleatorio(int iTienda = FALSE)
{
  string sResref;
  int iTirada;

  if(iTienda == FALSE) iTirada = Random(53)+1;
  else iTirada = Random(50)+4;

  switch(iTirada)
  {
      // Pergas nivel 1
      case 1:  sResref = "x2_it_spdvscr102";break; // Bendecir arma
      case 2:  sResref = "x2_it_spdvscr101";break; // TaÒido ensordecedor
      case 3:  sResref = "x1_it_sparscr104";break; // Impacto verdadero

      case 4:  sResref = "x2_it_spdvscr103";break;
      case 5:  sResref = "nw_it_sparscr112";break;
      case 6:  sResref = "x1_it_spdvscr107";break;
      case 7:  sResref = "nw_it_sparscr107";break;
      case 8:  sResref = "nw_it_sparscr110";break;
      case 9:  sResref = "x2_it_spdvscr104";break;
      case 10: sResref = "x1_it_sparscr102";break;
      case 11: sResref = "x1_it_spdvscr102";break;
      case 12: sResref = "x2_it_spdvscr105";break;
      case 13: sResref = "x2_it_spdvscr106";break;
      case 14: sResref = "x1_it_spdvscr103";break;
      case 15: sResref = "x1_it_sparscr101";break;
      case 16: sResref = "nw_it_sparscr103";break;
      case 17: sResref = "x2_it_sparscr101";break;
      case 18: sResref = "x2_it_sparscr104";break;
      case 19: sResref = "nw_it_sparscr106";break;
      case 20: sResref = "x1_it_spdvscr104";break;
      case 21: sResref = "x2_it_sparscr102";break;
      case 22: sResref = "nw_it_sparscr218";break;
      case 23: sResref = "nw_it_sparscr104";break;
      case 24: sResref = "x1_it_spdvscr106";break;
      case 25: sResref = "nw_it_sparscr109";break;
      case 26: sResref = "x2_it_sparscr105";break;
      case 27: sResref = "nw_it_sparscr113";break;
      case 28: sResref = "nw_it_sparscr102";break;
      case 29: sResref = "x2_it_sparscral";break;
      case 30: sResref = "nw_it_sparscr111";break;
      case 31: sResref = "x2_it_spdvscr107";break;
      case 32: sResref = "x2_it_spdvscr108";break;
      case 33: sResref = "nw_it_sparscr210";break;
      case 34: sResref = "x2_it_sparscr103";break;
      case 35: sResref = "x1_it_sparscr103";break;
      case 36: sResref = "x1_it_spdvscr105";break;
      case 37: sResref = "nw_it_sparscr108";break;
      case 38: sResref = "nw_it_sparscr105";break;
      case 39: sResref = "x1_it_spdvscr101";break;
      case 40: sResref = "perga_lacidorb2";break;
      case 41: sResref = "perga_lcoldorb2";break;
      case 42: sResref = "perga_lelecorb2";break;
      case 43: sResref = "perga_lfireorb2";break;
      case 44: sResref = "perga_lsonicorb2";break;
      case 45: sResref = "perga_benitrans2";break;
      case 46: sResref = "perga_detmue2";break;
      case 47: sResref = "perga_psinrastr2";break;
      case 48: sResref = "perga_salto2";break;
      case 49: sResref = "perga_cmpidioma2";break;
      case 50: sResref = "perga_fuegofee2";break;
      case 51: sResref = "perga_detali2";break;
      case 52: sResref = "perga_nieblaobs2";break;
      case 53: sResref = "perga_disfrazar2";break;
  }

  return sResref;
}

string ObtenerResrefPergaminoNivelDosAleatorio(int iTienda = FALSE) // 3
{
  string sResref;
  int iTirada;

  if(iTienda == FALSE) iTirada = Random(52)+1;
  else iTirada = Random(51)+2;

  switch(iTirada)
  {
      // Pergas nivel 2
      case 1:  sResref = "x2_it_sparscr205";break; // Arma flamigera

      case 2:  sResref = "x1_it_spdvscr204";break;
      case 3:  sResref = "x1_it_sparscr201";break;
      case 4:  sResref = "x2_it_spdvscr202";break;
      case 5:  sResref = "nw_it_sparscr211";break;
      case 6:  sResref = "x1_it_spdvscr202";break;
      case 7:  sResref = "nw_it_sparscr212";break;
      case 8:  sResref = "nw_it_sparscr213";break;
      case 9:  sResref = "x2_it_sparscr207";break;
      case 10: sResref = "nw_it_spdvscr202";break;
      case 11: sResref = "nw_it_sparscr217";break;
      case 12: sResref = "x2_it_sparscr206";break;
      case 13: sResref = "x2_it_sparscr201";break;
      case 14: sResref = "x2_it_spdvscr203";break;
      case 15: sResref = "nw_it_sparscr206";break;
      case 16: sResref = "x2_it_sparscr202";break;
      case 17: sResref = "nw_it_sparscr219";break;
      case 18: sResref = "nw_it_sparscr215";break;
      case 19: sResref = "nw_it_sparscr101";break;
      case 20: sResref = "x2_it_sparscr305";break;
      case 21: sResref = "x1_it_spdvscr205";break;
      case 22: sResref = "x2_it_spdvscr201";break;
      case 23: sResref = "nw_it_sparscr220";break;
      case 24: sResref = "x2_it_sparscr203";break;
      case 25: sResref = "nw_it_sparscr208";break;
      case 26: sResref = "nw_it_sparscr209";break;
      case 27: sResref = "x2_it_spdvscr204";break;
      case 28: sResref = "nw_it_sparscr308";break;
      case 29: sResref = "x1_it_spdvscr201";break;
      case 30: sResref = "nw_it_sparscr207";break;
      case 31: sResref = "nw_it_sparscr216";break;
      case 32: sResref = "nw_it_spdvscr201";break;
      case 33: sResref = "nw_it_sparscr202";break;
      case 34: sResref = "x1_it_spdvscr203";break;
      case 35: sResref = "nw_it_sparscr221";break;
      case 36: sResref = "nw_it_sparscr303";break;
      case 37: sResref = "x2_it_spdvscr205";break;
      case 38: sResref = "nw_it_sparscr201";break;
      case 39: sResref = "nw_it_sparscr205";break;
      case 40: sResref = "nw_it_spdvscr203";break;
      case 41: sResref = "nw_it_spdvscr204";break;
      case 42: sResref = "x2_it_sparscr204";break;
      case 43: sResref = "nw_it_sparscr203";break;
      case 44: sResref = "x1_it_sparscr202";break;
      case 45: sResref = "nw_it_sparscr214";break;
      case 46: sResref = "nw_it_sparscr204";break;
      case 47: sResref = "perga_baletrans3";break;
      case 48: sResref = "perga_agnazscor3";break;
      case 49: sResref = "perga_heroism3";break;
      case 50: sResref = "perga_aliind3";break;
      case 51: sResref = "perga_treparacn3";break;
      case 52: sResref = "perga_falsavida3";break;
  }

  return sResref;
}

string ObtenerResrefPergaminoNivelTresAleatorio(int iTienda = FALSE)  // 5
{
  string sResref;
  int iTirada;

  if(iTienda == FALSE) iTirada = Random(52)+1;
  else iTirada = Random(48)+5;

  switch(iTirada)
  {
      // Pergas nivel 3
      case 1:  sResref = "x2_it_sparscr303";break; // Afiladura
      case 2:  sResref = "x2_it_sparscr304";break; // Arma magica mayor
      case 3:  sResref = "x2_it_spdvscr305";break; // Fuego oscuro
      case 4:  sResref = "x2_it_spdvscr303";break; // Hoja sedienta

      case 5:  sResref = "nw_it_sparscr405";break;
      case 6:  sResref = "nw_it_sparscr307";break;
      case 7:  sResref = "nw_it_sparscr406";break;
      case 8:  sResref = "nw_it_sparscr411";break;
      case 9:  sResref = "x1_it_spdvscr301";break;
      case 10: sResref = "nw_it_sparscr509";break;
      case 11: sResref = "nw_it_sparscr301";break;
      case 12: sResref = "x1_it_sparscr301";break;
      case 13: sResref = "x2_it_spdvscr309";break;
      case 14: sResref = "nw_it_sparscr413";break;
      case 15: sResref = "nw_it_sparscr309";break;
      case 16: sResref = "nw_it_sparscr304";break;
      case 17: sResref = "x2_it_spdvscr306";break;
      case 18: sResref = "x1_it_spdvscr303";break;
      case 19: sResref = "nw_it_sparscr414";break;
      case 20: sResref = "x1_it_sparscr303";break;
      case 21: sResref = "nw_it_sparscr312";break;
      case 22: sResref = "x2_it_spdvscr302";break;
      case 23: sResref = "x2_it_spdvscr301";break;
      case 24: sResref = "x1_it_spdvscr302";break;
      case 25: sResref = "x2_it_spdvscr310";break;
      case 26: sResref = "nw_it_sparscr314";break;
      case 27: sResref = "x2_it_spdvscr307";break;
      case 28: sResref = "nw_it_sparscr310";break;
      case 29: sResref = "nw_it_sparscr302";break;
      case 30: sResref = "x2_it_sparscrmc";break;
      case 31: sResref = "x2_it_spdvscr304";break;
      case 32: sResref = "x2_it_sparscr301";break;
      case 33: sResref = "nw_it_sparscr315";break;
      case 34: sResref = "x2_it_spdvscr311";break;
      case 35: sResref = "nw_it_spdvscr402";break;
      case 36: sResref = "x2_it_spdvscr407";break;
      case 37: sResref = "x2_it_spdvscr312";break;
      case 38: sResref = "x1_it_spdvscr305";break;
      case 39: sResref = "nw_it_spdvscr301";break;
      case 40: sResref = "nw_it_sparscr402";break;
      case 41: sResref = "nw_it_spdvscr302";break;
      case 42: sResref = "x2_it_sparscr302";break;
      case 43: sResref = "x2_it_spdvscr313";break;
      case 44: sResref = "nw_it_sparscr313";break;
      case 45: sResref = "x1_it_spdvscr304";break;
      case 46: sResref = "nw_it_sparscr305";break;
      case 47: sResref = "nw_it_sparscr306";break;
      case 48: sResref = "nw_it_sparscr311";break;
      case 49: sResref = "x1_it_sparscr302";break;
      case 50: sResref = "perga_volar5";break;
      case 51: sResref = "perga_suenyopro5";break;
      case 52: sResref = "perga_crecomagu5";break;
  }

  return sResref;
}

string ObtenerResrefPergaminoNivelCuatroAleatorio(int iTienda = FALSE)  // 7
{
  string sResref;
  int iTirada;

  if(iTienda == FALSE) iTirada = Random(37)+1;
  else iTirada = Random(34)+4;

  switch(iTirada)
  {
      // Pergas nivel 4
      case 1:  sResref = "perga_zancada7";break;   // Zancada arborea
      case 2:  sResref = "perga_puertadim7";break; // Puerta dimensional
      case 3:  sResref = "x2_it_spdvscr401";break; // Espada sagrada

      case 4:  sResref = "nw_it_sparscr501";break;
      case 5:  sResref = "x2_it_spdvscr404";break;
      case 6:  sResref = "nw_it_sparscr503";break;
      case 7:  sResref = "nw_it_sparscr416";break;
      case 8:  sResref = "nw_it_sparscr412";break;
      case 9:  sResref = "nw_it_sparscr418";break;
      case 10: sResref = "x1_it_spdvscr403";break;
      case 11: sResref = "x2_it_spdvscr405";break;
      case 12: sResref = "x2_it_spdvscr406";break;
      case 13: sResref = "nw_it_sparscr505";break;
      case 14: sResref = "x2_it_spdvscr402";break;
      case 15: sResref = "x2_it_sparscr401";break;
      case 16: sResref = "nw_it_sparscr408";break;
      case 17: sResref = "x1_it_spdvscr401";break;
      case 18: sResref = "x1_it_sparscr401";break;
      case 19: sResref = "nw_it_sparscr417";break;
      case 20: sResref = "x1_it_spdvscr402";break;
      case 21: sResref = "nw_it_sparscr401";break;
      case 22: sResref = "nw_it_sparscr409";break;
      case 23: sResref = "nw_it_sparscr415";break;
      case 24: sResref = "nw_it_spdvscr401";break;
      case 25: sResref = "nw_it_sparscr410";break;
      case 26: sResref = "nw_it_sparscr403";break;
      case 27: sResref = "nw_it_sparscr404";break;
      case 28: sResref = "nw_it_sparscr407";break;
      case 29: sResref = "perga_ancdim7";break;
      case 30: sResref = "x2_it_spdvscr308";break;
      case 31: sResref = "perga_acidorb7";break;
      case 32: sResref = "perga_coldorb7";break;
      case 33: sResref = "perga_elecorb7";break;
      case 34: sResref = "perga_fireorb7";break;
      case 35: sResref = "perga_sonicorb7";break;
      case 36: sResref = "perga_multra7";break;
      case 37: sResref = "x2_it_spdvscr403";break;
  }

  return sResref;
}

string ObtenerResrefPergaminoNivelCincoAleatorio(int iTienda = FALSE) // 9
{
  string sResref;
  int iTirada;

  if(iTienda == FALSE) iTirada = Random(31)+1;
  else iTirada = Random(28)+4;

  switch(iTirada)
  {
      // Pergas nivel 5
      case 1:  sResref = "perga_teleport9";break;  // Teleportar
      case 2:  sResref = "nw_it_spdvscr501";break; // Revivir a los muertos
      case 3:  sResref = "nw_it_sparscr606";break; // VisiÛn verdadera

      case 4:  sResref = "x2_it_spdvscr504";break;
      case 5:  sResref = "nw_it_sparscr502";break;
      case 6:  sResref = "nw_it_sparscr507";break;
      case 7:  sResref = "x2_it_sparscr503";break;
      case 8:  sResref = "nw_it_sparscr608";break;
      case 9:  sResref = "x2_it_spdvscr509";break;
      case 10: sResref = "nw_it_sparscr504";break;
      case 11: sResref = "x1_it_sparscr501";break;
      case 12: sResref = "nw_it_sparscr508";break;
      case 13: sResref = "x2_it_spdvscr505";break;
      case 14: sResref = "x1_it_spdvscr501";break;
      case 15: sResref = "nw_it_sparscr511";break;
      case 16: sResref = "nw_it_sparscr512";break;
      case 17: sResref = "nw_it_sparscr513";break;
      case 18: sResref = "x2_it_sparscr502";break;
      case 19: sResref = "nw_it_sparscr506";break;
      case 20: sResref = "x2_it_spdvscr502";break;
      case 21: sResref = "x1_it_spdvscr502";break;
      case 22: sResref = "x2_it_sparscr501";break;
      case 23: sResref = "x2_it_spdvscr506";break;
      case 24: sResref = "x2_it_spdvscr507";break;
      case 25: sResref = "nw_it_sparscr510";break;
      case 26: sResref = "x2_it_spdvscr501";break;
      case 27: sResref = "x2_it_spdvscr503";break;
      case 28: sResref = "x1_it_sparscr502";break;
      case 29: sResref = "perga_mcurelit9";break;
      case 30: sResref = "perga_inflgtwm9";break;
      case 31: sResref = "perga_gheroism9";break;
  }

  return sResref;
}

int ObtenerTipoDanyoAleatorio()
{
  int iTipoDanyo;

  switch(Random(15)+1)
  {
      case 1:  iTipoDanyo = IP_CONST_DAMAGETYPE_ACID;        break;
      case 2:  iTipoDanyo = IP_CONST_DAMAGETYPE_BLUDGEONING; break;
      case 3:  iTipoDanyo = IP_CONST_DAMAGETYPE_COLD;        break;
      case 4:  iTipoDanyo = IP_CONST_DAMAGETYPE_DIVINE;      break;
      case 5:  iTipoDanyo = IP_CONST_DAMAGETYPE_ELECTRICAL;  break;
      case 6:  iTipoDanyo = IP_CONST_DAMAGETYPE_FIRE;        break;
      case 7:  iTipoDanyo = IP_CONST_DAMAGETYPE_MAGICAL;     break;
      case 8:  iTipoDanyo = IP_CONST_DAMAGETYPE_NEGATIVE;    break;
      case 9:  iTipoDanyo = IP_CONST_DAMAGETYPE_PIERCING;    break;
      case 10: iTipoDanyo = IP_CONST_DAMAGETYPE_POSITIVE;    break;
      case 11: iTipoDanyo = IP_CONST_DAMAGETYPE_SLASHING;    break;
      case 12: iTipoDanyo = IP_CONST_DAMAGETYPE_SONIC;       break;
      case 13: iTipoDanyo = IP_CONST_DAMAGETYPE_FUERZA;      break;
      case 14: iTipoDanyo = IP_CONST_DAMAGETYPE_PSIQUICO;    break;
      case 15: iTipoDanyo = IP_CONST_DAMAGETYPE_VENENO;      break;
  }

  return iTipoDanyo;
}

int ObtenerRazaAleatoria()
{
  int iRaza;

  switch(Random(24)+1)
  {
      case 1:  iRaza = IP_CONST_RACIALTYPE_ABERRATION;         break;
      case 2:  iRaza = IP_CONST_RACIALTYPE_ANIMAL;             break;
      case 3:  iRaza = IP_CONST_RACIALTYPE_BEAST;              break;
      case 4:  iRaza = IP_CONST_RACIALTYPE_CONSTRUCT;          break;
      case 5:  iRaza = IP_CONST_RACIALTYPE_DRAGON;             break;
      case 6:  iRaza = IP_CONST_RACIALTYPE_DWARF;              break;
      case 7:  iRaza = IP_CONST_RACIALTYPE_ELEMENTAL;          break;
      case 8:  iRaza = IP_CONST_RACIALTYPE_ELF;                break;
      case 9:  iRaza = IP_CONST_RACIALTYPE_FEY;                break;
      case 10: iRaza = IP_CONST_RACIALTYPE_GIANT;              break;
      case 11: iRaza = IP_CONST_RACIALTYPE_GNOME;              break;
      case 12: iRaza = IP_CONST_RACIALTYPE_HALFELF;            break;
      case 13: iRaza = IP_CONST_RACIALTYPE_HALFLING;           break;
      case 14: iRaza = IP_CONST_RACIALTYPE_HALFORC;            break;
      case 15: iRaza = IP_CONST_RACIALTYPE_HUMAN;              break;
      case 16: iRaza = IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID; break;
      case 17: iRaza = IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS; break;
      case 18: iRaza = IP_CONST_RACIALTYPE_HUMANOID_ORC;       break;
      case 19: iRaza = IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN; break;
      case 20: iRaza = IP_CONST_RACIALTYPE_MAGICAL_BEAST;      break;
      case 21: iRaza = IP_CONST_RACIALTYPE_OUTSIDER;           break;
      case 22: iRaza = IP_CONST_RACIALTYPE_SHAPECHANGER;       break;
      case 23: iRaza = IP_CONST_RACIALTYPE_UNDEAD;             break;
      case 24: iRaza = IP_CONST_RACIALTYPE_VERMIN;             break;
  }

  return iRaza;
}

int ObtenerDanyoPorRangoAleatorio(int iRango)
{
  int iTirada, iDanyo;

  switch(iRango)
  {
      case 1:
      {
          iTirada = d3();

               if(iTirada == 1) iDanyo = IP_CONST_DAMAGEBONUS_1;
          else if(iTirada == 2) iDanyo = IP_CONST_DAMAGEBONUS_2;
          else if(iTirada == 3) iDanyo = IP_CONST_DAMAGEBONUS_1d4;
      }break;

      case 2:
      {
          iTirada = Random(5)+1;

          if(iTirada == 1)      iDanyo = IP_CONST_DAMAGEBONUS_1;
          else if(iTirada == 2) iDanyo = IP_CONST_DAMAGEBONUS_2;
          else if(iTirada == 3) iDanyo = IP_CONST_DAMAGEBONUS_1d4;
          else if(iTirada == 4) iDanyo = IP_CONST_DAMAGEBONUS_3;
          else if(iTirada == 5) iDanyo = IP_CONST_DAMAGEBONUS_1d6;
      }break;

      case 3:
      {
          iTirada = d6();

          if(iTirada == 1)      iDanyo = IP_CONST_DAMAGEBONUS_2;
          else if(iTirada == 2) iDanyo = IP_CONST_DAMAGEBONUS_1d4;
          else if(iTirada == 3) iDanyo = IP_CONST_DAMAGEBONUS_3;
          else if(iTirada == 4) iDanyo = IP_CONST_DAMAGEBONUS_1d6;
          else if(iTirada == 5) iDanyo = IP_CONST_DAMAGEBONUS_4;
          else if(iTirada == 6) iDanyo = IP_CONST_DAMAGEBONUS_1d8;
      }break;

      case 4:
      {
          iTirada = Random(9)+1;

          if(iTirada == 1)       iDanyo = IP_CONST_DAMAGEBONUS_2;
          else if(iTirada == 2)  iDanyo = IP_CONST_DAMAGEBONUS_1d4;
          else if(iTirada == 3)  iDanyo = IP_CONST_DAMAGEBONUS_3;
          else if(iTirada == 4)  iDanyo = IP_CONST_DAMAGEBONUS_1d6;
          else if(iTirada == 5)  iDanyo = IP_CONST_DAMAGEBONUS_4;
          else if(iTirada == 6)  iDanyo = IP_CONST_DAMAGEBONUS_1d8;
          else if(iTirada == 7)  iDanyo = IP_CONST_DAMAGEBONUS_2d4;
          else if(iTirada == 8)  iDanyo = IP_CONST_DAMAGEBONUS_5;
          else if(iTirada == 9)  iDanyo = IP_CONST_DAMAGEBONUS_1d10;
      }break;

      case 5:
      {
          iTirada = Random(6)+1;

          if(iTirada == 1)       iDanyo = IP_CONST_DAMAGEBONUS_1d6;
          else if(iTirada == 2)  iDanyo = IP_CONST_DAMAGEBONUS_4;
          else if(iTirada == 3)  iDanyo = IP_CONST_DAMAGEBONUS_1d8;
          else if(iTirada == 4)  iDanyo = IP_CONST_DAMAGEBONUS_2d4;
          else if(iTirada == 5)  iDanyo = IP_CONST_DAMAGEBONUS_5;
          else if(iTirada == 6)  iDanyo = IP_CONST_DAMAGEBONUS_1d10;
      }break;
  }

  return iDanyo;
}

void CrearPergamino(object oObjetivo, int iRango, int iTienda = FALSE)
{
  string sResref;
  int iTirada = d3();

  if(iRango == 1) // Pergas de niveles 0 1 2
  {
           if(iTirada == 1) sResref = ObtenerResrefPergaminoNivelCeroAleatorio();
      else if(iTirada == 2) sResref = ObtenerResrefPergaminoNivelUnoAleatorio(iTienda);
      else                  sResref = ObtenerResrefPergaminoNivelDosAleatorio(iTienda);
  }

  else if(iRango == 2) // Pergas de niveles 1 2 3
  {
           if(iTirada == 1) sResref = ObtenerResrefPergaminoNivelUnoAleatorio(iTienda);
      else if(iTirada == 2) sResref = ObtenerResrefPergaminoNivelDosAleatorio(iTienda);
      else                  sResref = ObtenerResrefPergaminoNivelTresAleatorio(iTienda);
  }

  else if(iRango == 3) // Pergas niveles 2 3 4
  {
          if(iTirada == 1)  sResref = ObtenerResrefPergaminoNivelDosAleatorio(iTienda);
      else if(iTirada == 2) sResref = ObtenerResrefPergaminoNivelTresAleatorio(iTienda);
      else                  sResref = ObtenerResrefPergaminoNivelCuatroAleatorio(iTienda);
  }

  else if(iRango == 4) // Pergas niveles 3 4 5
  {
           if(iTirada == 1) sResref = ObtenerResrefPergaminoNivelTresAleatorio(iTienda);
      else if(iTirada == 2) sResref = ObtenerResrefPergaminoNivelCuatroAleatorio(iTienda);
      else                  sResref = ObtenerResrefPergaminoNivelCincoAleatorio(iTienda);
  }

  else if(iRango == 5) // Pergas niveles 4 5
  {
      if(d2() == 1) sResref = ObtenerResrefPergaminoNivelCuatroAleatorio(iTienda);
      else          sResref = ObtenerResrefPergaminoNivelCincoAleatorio(iTienda);
  }

  object oPergamino = CreateItemOnObject(sResref, oObjetivo);
  SetDroppableFlag(oPergamino, TRUE);
  SetPlotFlag(oPergamino, FALSE);
  SetIdentified(oPergamino, iTienda);
  SetLocalInt(oPergamino, "PCItem", 1);
  // Debug: ver si el objeto se ha creado correctamente...
  if(oPergamino == OBJECT_INVALID) WriteTimestampedLogEntry("[SISTEMA DE TESOROS] Error de creaciÛn de objeto (pergamino). La resref "+sResref+" no se ha creado exitosamente.");
}

void CrearGemas(object oObjetivo, int iRango, int iTienda = FALSE)
{
  string sResref;

  switch(Random(42)+1)
  {
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
      case 9:  sResref = "nw_it_gem00" + IntToString(Random(9)+1);  break;
      case 10:
      case 11:
      case 12:
      case 13:
      case 14:
      case 15: sResref = "nw_it_gem0" + IntToString(Random(6)+10);  break;
      case 16: sResref = "aguamarina"; break;
      case 17: sResref = "ambar"; break;
      case 18: sResref = "crisoberilo"; break;
      case 19: sResref = "diopsidoestrella"; break;
      case 20: sResref = "jacinto"; break;
      case 21: sResref = "lapislazuli"; break;
      case 22: sResref = "perla"; break;
      case 23: sResref = "piedralunar"; break;
      case 24: sResref = "piedrasangrienta"; break;
      case 25: sResref = "shandon"; break;
      case 26: sResref = "turquesa"; break;
      case 27: sResref = "zafiroestrellado"; break;
      case 28: sResref = "azurita"; break;
      case 29: sResref = "rodocrosita"; break;
      case 30: sResref = "cornalina"; break;
      case 31: sResref = "espinelaroja"; break;
      case 32: sResref = "perlanegra"; break;
      case 33: sResref = "corindonviolado"; break;
      case 34: sResref = "diamanteazulado"; break;
      case 35: sResref = "iolita"; break;
      case 36: sResref = "ojodetigre"; break;
      case 37: sResref = "crisoprasa"; break;
      case 38: sResref = "circon"; break;
      case 39: sResref = "calcedonia"; break;
      case 40: sResref = "jaspe"; break;
      case 41: sResref = "jade"; break;
      case 42: sResref = "turmalina"; break;
  }

  object oGema = CreateItemOnObject(sResref, oObjetivo);
  SetDroppableFlag(oGema, TRUE);
  SetPlotFlag(oGema, FALSE);
  SetLocalInt(oGema, "PCItem", 1);

  if(GetGoldPieceValue(oGema) > 200 && iTienda == FALSE) SetIdentified(oGema, FALSE);
  if (iTienda==TRUE) {SetIdentified(oGema, TRUE);}
  // Debug: ver si el objeto se ha creado correctamente...
  if(oGema == OBJECT_INVALID) WriteTimestampedLogEntry("[SISTEMA DE TESOROS] Error de creaciÛn de objeto (gema). La resref "+sResref+" no se ha creado exitosamente.");
}

void CrearBasura(object oObjetivo, int iRango, int iTienda = FALSE)
{
  string sResref;

  switch(Random(210)+1)
  {
      case 1: sResref = "nw_it_thnmisc00" + IntToString(Random(4)+1); break; // botellas vacÌas (4 tipos)
      case 2: sResref = "nw_it_mmidmisc05"; break;   // carne
      case 3: sResref = "nw_it_msmlmisc0" + IntToString(Random(4)+6); break; // diente de bodak, etc.
      case 4: sResref = "nw_it_msmlmisc1" + IntToString(Random(2)); break;   // lengua de slaad, etc.
      case 5: sResref = "nw_it_msmlmisc1" + IntToString(Random(2)+3); break; // nudillo esqueleto, calavera de g·rgola
      case 6: sResref = "nw_it_msmlmisc" + IntToString(Random(9)+17); break; // Sangre dragon, madera fÈrrea, Polvos de hada, pez, harapos, Tope, belladona, ajo, Icor
      case 7: sResref = "x3_it_wyvernbld"; break;    // sandre draco
      case 8: sResref = "nw_it_creitem201"; break;   // pluma gaviota
      case 9: sResref = "x3_it_moonstick"; break;    // luna empalada
      case 10: sResref = "nw_it_picks00" + IntToString(Random(4)+1); break;  // herr.ladron+1+3+6+10
      case 11: sResref = "nw_it_contain001"; break;  // caja grande
      case 12: sResref = "nw_it_torch001"; break;    // antorcha
      case 13: sResref = "zep_flagstandard"; break;  // bandera
      case 14: sResref = "zep_holysymbol"; break;    // simbolo sagrado
      case 15: sResref = "zep_book"; break;          // libro
      case 16: sResref = "zep_guitar"; break;        // guitarra
      case 17: sResref = "zep_harp"; break;          // harpa
      case 18: sResref = "zep_lute"; break;          // laud
      case 19: sResref = "zep_pipes"; break;         // flauta
      case 20: sResref = "zep_tambourine"; break;    // pandereta
      case 21: sResref = "zep_violinf"; break;       // violin
      case 22: sResref = "zep_violinm"; break;       // violin
      case 23: sResref = "zep_violinbow"; break;     // violin
      case 24: sResref = "zep_babyholdable"; break;  // bebe
      case 25: sResref = "zep_rose_blue"; break;     // flor
      case 26: sResref = "zep_figure1"; break;       // figura
      case 27: sResref = "flowers"; break;           // flores
      case 28: sResref = "zep_gempouch"; break;      // bolsa gemas
      case 29: sResref = "zep_lantern"; break;       // linterna
      case 30: sResref = "zep_lily"; break;          // flor
      case 31: sResref = "zep_rose_red"; break;      // flor
      case 32: sResref = "zep_zebrahide"; break;     // piel de zebra
      case 33: sResref = "zep_crystalball"; break;   // bola de cristal
      case 34: sResref = "zep_fan"; break;           // abanico
      case 35: sResref = "zep_mug_0" + IntToString(Random(4)+1); break;      // taza
      case 36: sResref = "zep_papoose"; break;       // bebe
      case 37: sResref = "zep_umbrella"; break;      // paraguas
      case 38: sResref = "x1_wmgrenade00" + IntToString(Random(7)+1); break; // armas arrojadizas
      case 39:
        //material de curandero nuevo.
        switch(d4()) {
            case 1:
                sResref = "vendas_pb_01";
                break;
            case 2:
                sResref = "vendas_pb_03";
                break;
            case 3:
                sResref = "vendas_pb_06";
                break;
            case 4:
                sResref = "vendas_pb_10";
                break;
        }
        break;
      case 40: sResref = "nw_it_trap00" + IntToString(Random(9)+1); break;   // trampas
      case 41: sResref = "nw_it_trap0" + IntToString(Random(34)+10); break;  // trampas
      case 42: sResref = "nw_it_book00" + IntToString(Random(9)+1); break;   // libros
      case 43: sResref = "nw_it_book0" + IntToString(Random(21)+10); break;  // libros
      case 44: sResref = "nw_it_mring009"; break;    // anillo
      case 45: sResref = "nw_it_mring0" + IntToString(Random(2)+10); break;  // anillos
      case 46: sResref = "nw_it_mring0" + IntToString(Random(3)+21); break;  // anillos
      case 47: sResref = "jarracervezaenan"; break;
      case 48: sResref = "nw_it_mneck0" + IntToString(Random(4)+20); break;  // collares
      case 49: sResref = "x2_it_poison00" + IntToString(Random(3)+7); break; // venenos
      case 50: sResref = "x2_it_poison0" + IntToString(Random(3)+25); break; // venenos
      case 51: sResref = "x2_it_poison0" + IntToString(Random(3)+13); break; // venenos
      case 52: sResref = "x2_it_poison0" + IntToString(Random(3)+37); break; // venenos
      case 53: sResref = "x2_it_poison0" + IntToString(Random(3)+31); break; // venenos
      case 54: sResref = "x2_it_poison0" + IntToString(Random(3)+19); break; // venenos
      case 55: sResref = "bastndemadera"; break;
      case 56: sResref = "amuletoadiamanta"; break;
      case 57: sResref = "collaragnimani"; break;
      case 58: sResref = "collarcaparazon"; break;
      case 59: sResref = "collarobsidiana"; break;
      case 60: sResref = "it_mneck041"; break;
      case 61: sResref = "collardelbendi"; break;
      case 62: sResref = "anillodanzafuego"; break;
      case 63: sResref = "anillohematites"; break;
      case 64: sResref = "anillojade"; break;
      case 65: sResref = "anillodemaderaco"; break;
      case 66: sResref = "anilloolivino"; break;
      case 67: sResref = "anilloonix"; break;
      case 68: sResref = "anilloopalofuego"; break;
      case 69: sResref = "anillopielangel"; break;
      case 70: sResref = "anillorubi"; break;
      case 71: sResref = "it_mring03" + IntToString(Random(2)+6); break;
      case 72: sResref = "_ajuardedifunto"; break;
      case 73: sResref = "amulaleatorio0" + IntToString(Random(4)+1); break;
      case 74: sResref = "anillodeinvmairj"; break;
      case 75: sResref = "barajadetalis"; break;
      case 76: sResref = "bola_ladron"; break;
      case 77: sResref = "botasdebuenaymal"; break;
      case 78: sResref = "botasprisapormor"; break;
      case 79: sResref = "brazaleteoro"; break;
      case 80: sResref = "calizdelaton"; break;
      case 81: sResref = "calizdeplata"; break;
      case 82: sResref = "campanilla"; break;
      case 83: sResref = "capadeinvisibili"; break;
      case 84: sResref = "foodration002"; break;
      case 85: sResref = "cartasdenavegaci"; break;
      case 86: sResref = "cetrojuguete"; break;
      case 87: sResref = "_conchaextra"; break;
      case 88: sResref = "vgz_concharoja"; break;
      case 89: sResref = "basura_copamader"; break;
      case 90: sResref = "copadeoro"; break;
      case 91: sResref = "gz_it_rope"; break;
      case 92: sResref = "dientetiburon"; break;
      case 93: sResref = "_doblon"; break;
      case 94: sResref = "item"; break;
      case 95: sResref = "basura_eslabon"; break;
      case 96: sResref = "espadamalditadel"; break;
      case 97: sResref = "espadarotapedazs"; break;
      case 98: sResref = "espejodemano"; break;
      case 99: sResref = "espejodeplata"; break;
      case 100: sResref = "basura_aranaest"; break;
      case 101: sResref = "estatuilladedrag"; break;
      case 102: sResref = "estatuillaoro"; break;
      case 103: sResref = "estatuillaplata"; break;
      case 104: sResref = "estatuasirena"; break;
      case 105: sResref = "bullionbond10"; break;
      case 106: sResref = "harpademaestro"; break;
      case 107: sResref = "_huevotortuga"; break;
      case 108: sResref = "incensarioshares"; break;
      case 109: sResref = "basura_martillo"; break;
      case 110: sResref = "mechondepelos" + IntToString(Random(2)+1); break;
      case 111: sResref = "basura_ramitas"; break;
      case 112: sResref = "_muelaoro"; break;
      case 113: sResref = "vgz_cs_palacavar"; break;
      case 114: sResref = "_gemamarina" + IntToString(Random(3)+1); break;
      case 115: sResref = "pinturadegrancal"; break;
      case 116: sResref = "veladormir"; break;
      case 117: sResref = "pinturadegran" + IntToString(Random(2)+2); break;
      case 118: sResref = "basura_platillo"; break;
      case 119: sResref = "polvoantiluz"; break;
      case 120: sResref = "basura_restos"; break;
      case 121: sResref = "finassedas"; break;
      case 122: sResref = "setaparamos"; break;
      case 123: sResref = "simboloantimagma"; break;
      case 124: sResref = "tapiceriadelana"; break;
      case 125: sResref = "basura_tazon"; break;
      case 126: sResref = "tienda_camp"; break;
      case 127: sResref = "vgz_cristalbrill"; break;
      case 128: sResref = "vainadeespada"; break;
      case 129: sResref = "vainadeespada" + IntToString(Random(2)+2); break;
      case 130: sResref = "varitagastada" + IntToString(Random(3)+1); break;
      case 131: sResref = "hc_tinderbox"; break;
      case 132: sResref = "focodivino" + IntToString(Random(4)+1); break;
      case 133: sResref = "basura_urna"; break;
      case 134: sResref = "reloj_ins"; break;
      case 135: sResref = "polvoardiente"; break;
      case 136: sResref = "polvoelectrizant"; break;
      case 137: sResref = "polvohelado"; break;
      case 138: sResref = "_polvo"; break;
      case 139: sResref = "mortero"; break;
      case 140: sResref = "vgz_baul"; break;
      case 141: sResref = "guantearcano"; break;
      case 142: sResref = "tabaco"; break;
      case 143: sResref = "sute_her_dm1"; break;
      case 144: sResref = "hozrecolector"; break;
      case 145: sResref = "martillo_herr001"; break;
      case 146: sResref = "sute_her_vendas"; break;
      case 147: sResref = "sute_her_dh1"; break;
      case 148: sResref = "virutasresplande"; break;
      case 149: sResref = "gema_rub"; break;
      case 150: sResref = "truequeenlosmuel"; break;
      case 151: sResref = "florluminosa"; break;
      case 152: sResref = "picadarocosa"; break;
      case 153: sResref = "x2_it_cfm_bscrl"; break;
      case 154: sResref = "x2_it_cfm_wand"; break;
      case 155: sResref = "x2_it_cfm_pbottl"; break;
      case 156: sResref = "libroespecial0" + IntToString(Random(3)+2); break;
      case 157: sResref = "libroespecial0" + IntToString(Random(2)+8); break;
      case 158: sResref = "item012"; break;
      case 159: sResref = "formula008"; break;
      case 160: sResref = "formula12"; break;
      case 161: sResref = "formula19"; break;
      case 162: sResref = "formula02" + IntToString(Random(2)+2); break;
      case 163: sResref = "formula026"; break;
      case 164: sResref = "formula039"; break;
      case 165: sResref = "librodeconvocaci"; break;
      case 166: sResref = "nota23"; break;
      case 167: sResref = "notasmarr"; break;
      case 168: sResref = "receta006"; break;
      case 169: sResref = "receta012"; break;
      case 170: sResref = "receta022"; break;
      case 171: sResref = "receta024"; break;
      case 172: sResref = "receta02" + IntToString(Random(4)+6); break;
      case 173: sResref = "receta035"; break;
      case 174: sResref = "receta049"; break;
      case 175: sResref = "receta05" + IntToString(Random(2)+1); break;
      case 176: sResref = "receta075"; break;
      case 177: sResref = "receta08" + IntToString(Random(3)+1); break;
      case 178: sResref = "receta098"; break;
      case 179: sResref = "raizdenara"; break;
      case 180: sResref = "pb_ofi_artdiag" + IntToString(Random(2)+1); break;   // Diagramas de artesanÌa urdimbrica (son 25)
      case 181: sResref = "pb_ofi_artdiag" + IntToString(Random(2)+3); break;
      case 182: sResref = "pb_ofi_artdiag" + IntToString(Random(2)+5); break;
      case 183: sResref = "pb_ofi_artdiag" + IntToString(Random(2)+7); break;
      case 184: sResref = "pb_ofi_artdiag" + IntToString(Random(2)+9); break;
      case 185: sResref = "pb_ofi_artdiag" + IntToString(Random(2)+11); break;
      case 186: sResref = "pb_ofi_artdiag" + IntToString(Random(2)+13); break;
      case 187: sResref = "pb_ofi_artdiag" + IntToString(Random(2)+15); break;
      case 188: sResref = "pb_ofi_artdiag" + IntToString(Random(2)+17); break;
      case 189: sResref = "pb_ofi_artdiag" + IntToString(Random(2)+19); break;
      case 190: sResref = "pb_ofi_artdiag" + IntToString(Random(2)+21); break;
      case 191: sResref = "pb_ofi_artdiag" + IntToString(Random(3)+23); break;
      case 192: sResref = "pb_artesa_polvo" + IntToString(Random(4)+1); break;  // Polvos de escuelas magicas (son 8)
      case 193: sResref = "pb_artesa_polvo" + IntToString(Random(4)+5); break;
      case 194: sResref = "pb_artesa_car" + IntToString(Random(3)); break;      // Esencias de caracteristicas (son 6)
      case 195: sResref = "pb_artesa_car" + IntToString(Random(3)+3); break;
      case 196: sResref = "libro_veneno"; break;
      case 197: sResref = "libro_veneno_001"; break;
      case 198: sResref = "libro_veneno_002"; break;
      case 199: sResref = "libro_veneno_003"; break;
      case 200: sResref = "libro_veneno_006"; break;
      case 201: sResref = "libro_veneno_007"; break;
      case 202: sResref = "libro_veneno_008"; break;
      case 203: sResref = "libro_veneno_009"; break;
      case 204: sResref = "libro_veneno_011"; break;
      case 205: sResref = "libro_veneno_019"; break;
      case 206: sResref = "libro_veneno_020"; break;
      case 207: sResref = "libro_veneno_025"; break;
      case 208: sResref = "rec_fundidor_" + IntToString(Random(6)+1); break; // Recetas de fundiciÛn
      case 209: sResref = "rec_curtidor_" + IntToString(Random(3)+1); break; // Recetas de curtidurÌa
      case 210: sResref = "rec_marroquineri"; break; // Receta de marroquinerÌaa

  }

  object oBasura = CreateItemOnObject(sResref, oObjetivo);
  SetDroppableFlag(oBasura, TRUE);
  SetPlotFlag(oBasura, FALSE);
  SetLocalInt(oBasura, "PCItem", 1);
  if(GetGoldPieceValue(oBasura) > 200 && iTienda == FALSE) SetIdentified(oBasura, FALSE);
  if (iTienda==TRUE) {SetIdentified(oBasura, TRUE);}
  // Debug: ver si el objeto se ha creado correctamente...
  if(oBasura == OBJECT_INVALID) WriteTimestampedLogEntry("[SISTEMA DE TESOROS] Error de creaciÛn de objeto (basura). La resref "+sResref+" no se ha creado exitosamente.");
}

void CrearPocion(object oObjetivo, int iRango, int iTienda = FALSE)
{
  string sResref;

  switch(Random(77))
  {
      case 0: sResref = "poti_negativa";  break;
      case 1: sResref = "nw_it_mpotion001";  break;
      case 2: sResref = "nw_it_mpotion002";  break;
      case 3: sResref = "nw_it_mpotion003";  break;
      case 4: sResref = "nw_it_mpotion004";  break;
      case 5: sResref = "nw_it_mpotion005";  break;
      case 6: sResref = "nw_it_mpotion006";  break;
      case 7: sResref = "nw_it_mpotion007";  break;
      case 8: sResref = "nw_it_mpotion008";  break;
      case 9: sResref = "nw_it_mpotion009";  break;
      case 10: sResref = "nw_it_mpotion010";  break;
      case 11: sResref = "nw_it_mpotion011";  break;
      case 12: sResref = "x2_it_mpotion002"; break;
      case 13: sResref = "nw_it_mpotion013";  break;
      case 14: sResref = "nw_it_mpotion014";  break;
      case 15: sResref = "nw_it_mpotion015";  break;
      case 16: sResref = "nw_it_mpotion016";  break;
      case 17: sResref = "nw_it_mpotion017";  break;
      case 18: sResref = "nw_it_mpotion018";  break;
      case 19: sResref = "nw_it_mpotion019";  break;
      case 20: sResref = "nw_it_mpotion020";  break;
      case 21: sResref = "nw_it_mpotion021";  break;
      case 22: sResref = "nw_it_mpotion022";  break;
      case 23: sResref = "nw_it_mpotion023";  break;
      case 24: sResref = "poti_negativa"; break;
      case 25: sResref = "sidrademanzana";  break;
      case 26: sResref = "sidradepera";  break;
      case 27: sResref = "vinopurskulcosex";  break;
      case 28: sResref = "vinopurskul";  break;
      case 29: sResref = "vinopurskulocura";  break;
      case 30: sResref = "pocindeaguant";  break;
      case 31: sResref = "pocindearmadu";  break;
      case 32: sResref = "pocindeastuci";  break;
      case 33: sResref = "it_potfoxs";  break;
      case 34: sResref = "pocindeclaria";  break;
      case 35: sResref = "pocindecustod";  break;
      case 36: sResref = "pocindeescudo";  break;
      case 37: sResref = "pocindeesplen";  break;
      case 38: sResref = "pocindefuerza";  break;
      case 39: sResref = "pocindegracia";  break;
      case 40: sResref = "pocindelibert";  break;
      case 41: sResref = "pocindemente";  break;
      case 42: sResref = "pocindepielp";  break;
      case 43: sResref = "pocindepielpma";  break;
      case 44: sResref = "pocindepoder";  break;
      case 45: sResref = "pocindepolimo";  break;
      case 46: sResref = "pocindeprotec";  break;
      case 47: sResref = "pocindeprote2";  break;
      case 48: sResref = "pocindequitarce";  break;
      case 49: sResref = "pocindequitarmi";  break;
      case 50: sResref = "pocindequitaren";  break;
      case 51: sResref = "pocindequitarma";  break;
      case 52: sResref = "pocinderesist2";  break;
      case 53: sResref = "pocinderesistcon";  break;
      case 54: sResref = "pocinderesist";  break;
      case 55: sResref = "pocinderestab";  break;
      case 56: sResref = "pocindesabidu";  break;
      case 57: sResref = "pocindesembla";  break;
      case 58: sResref = "it_potehtrl";  break;
      case 59: sResref = "pocindesoport";  break;
      case 60: sResref = "pocindetransf";  break;
      case 61: sResref = "pocindeultrav";  break;
      case 62: sResref = "pocindeverlo";  break;
      case 63: sResref = "pocindevisin";  break;
      case 64: sResref = "sangrepura";  break;
      case 65: sResref = "sangrevirgen";  break;
      case 66: sResref = "bloodvialempty";  break;
      case 67: sResref = "cervezanorteair";  break;
      case 68: sResref = "uki_bebidarisa";  break;
      case 69: sResref = "uki_bebidasueno";  break;
      case 70: sResref = "uki_bebidaadelg";  break;
      case 71: sResref = "uki_bebidaengor";  break;
      case 72: sResref = "uki_bebidaarbol";  break;
      case 73: sResref = "uki_bebidalucha";  break;
      case 74: sResref = "cervezaalientodr";  break;
      case 75: sResref = "cervezanorteair";  break;
      case 76: sResref = "siempremiel";  break;
      case 77: sResref = "poti_negativa2";  break;
  }

  object oPocion = CreateItemOnObject(sResref, oObjetivo);
  SetDroppableFlag(oPocion, TRUE);
  SetPlotFlag(oPocion, FALSE);
  SetLocalInt(oPocion, "PCItem", 1);
  if(GetGoldPieceValue(oPocion) > 200 && iTienda == FALSE) SetIdentified(oPocion, FALSE);
  if (iTienda==TRUE) {SetIdentified(oPocion, TRUE);}
  // Debug: ver si el objeto se ha creado correctamente...
  if(oPocion == OBJECT_INVALID) WriteTimestampedLogEntry("[SISTEMA DE TESOROS] Error de creaciÛn de objeto (pocion). La resref "+sResref+" no se ha creado exitosamente.");
}

void CrearMiscelanea(object oObjetivo, int iRango, int iTienda = FALSE)
{
  if(iRango < 5) CrearBasura(oObjetivo, iRango);
  else
  {
      string sResref;

      switch(Random(20)+1)
      {
          case 1: sResref = "it_mmedmisc002";  break;
          case 2: sResref = "x2_is_blue";  break;
          case 3: sResref = "x2_is_paleblue";  break;
          case 4: sResref = "x2_is_sandblue";  break;
          case 5: sResref = "x2_is_deepred";  break;
          case 6: sResref = "x2_is_pink";  break;
          case 7: sResref = "x2_is_drose";  break;
          case 8: sResref = "x2_is_pandgreen";  break;
          //case 9: sResref = "nw_it_mmidmisc0" + IntToString(Random(4)+1);  break;
          //case 10: sResref = "nw_it_msmlmisc05";  break;
          //case 11: sResref = "nw_it_contain00" + IntToString(Random(2)+2);  break;
          //case 12: sResref = "nw_it_novel002";  break;
          //case 13: sResref = "x0_deck_avatar";  break;
          //case 14: sResref = "x0_it_mmedmisc0" + IntToString(Random(6)+1);  break;
          //case 15: sResref = "x0_it_mthnmisc0" + IntToString(Random(3)+4);  break;
          //case 16: sResref = "x0_it_mthnmisc0" + IntToString(Random(2)+8);  break;
          //case 17: sResref = "x0_it_mthnmisc1" + IntToString(Random(2));  break;
          //case 18: sResref = "x0_it_mthnmisc" + IntToString(Random(9)+13);  break;
          //case 19: sResref = "x0_it_msmlmisc0" + IntToString(Random(6)+1);  break;
          //case 20: sResref = "x0_misc_prayer";  break;
          //case 21: sResref = "x0_misc_charge";  break;
          //case 22: sResref = "x0_misc_lyrics";  break;
          //case 23: sResref = "x0_misc_fists";  break;
          //case 24: sResref = "x0_misc_twig";  break;
          //case 25: sResref = "x0_misc_twand";  break;
          //case 26: sResref = "x1_it_mbook001";  break;
          case 9:  sResref = "libroespecial01" + IntToString(Random(4));  break;
          case 10: sResref = "pergaminodenethe";  break;
          case 11: sResref = "libroespecial01";  break;
          case 12: sResref = "vgz_simbolo" + IntToString(Random(3)+1);  break;
          case 13: sResref = "bola_ladron";  break;
          case 14: sResref = "bullionbond25";  break;
          case 15: sResref = "cs_hadabotella";  break;
          case 16: sResref = "linternadeoghma";  break;
          case 17: sResref = "zarzcillodebasha";  break;
          case 18: sResref = "pipadelcazador";  break;
          case 19: sResref = "plantamedicinal";  break;
          case 20: sResref = "_reliquiakelemvo";  break;
          //case 21: sResref = "x2_it_trap00" + IntToString(Random(4)+1); break;    // Trampas epicas
      }

      object oMiscelanea = CreateItemOnObject(sResref, oObjetivo);
      SetDroppableFlag(oMiscelanea, TRUE);
      SetPlotFlag(oMiscelanea, FALSE);
      SetLocalInt(oMiscelanea, "PCItem", 1);
      if(GetGoldPieceValue(oMiscelanea) > 200 && iTienda == FALSE) SetIdentified(oMiscelanea, FALSE);
      if (iTienda==TRUE) {SetIdentified(oMiscelanea, TRUE);}
      // Debug: ver si el objeto se ha creado correctamente...
      if(oMiscelanea == OBJECT_INVALID) WriteTimestampedLogEntry("[SISTEMA DE TESOROS] Error de creaciÛn de objeto (miscelanea). La resref "+sResref+" no se ha creado exitosamente.");
  }
}

void EncantamientoPropiedadLanzarConjuro(object oObjeto, int iRango)
{
  int iTirada, iConjuro, iUsos, iBardo, iClerigo, iDruida, iPaladin, iExplorador, iMagoHechi; // Bard (1) Cleric (2) Druid (3) Paladin (4) Ranger (5) Wiz_Sorc (6)

  switch(iRango)
  {
      case 1:
      case 2:
      {
          iTirada = Random(33)+1;

               if(iTirada == 1)  { iConjuro = IP_CONST_CASTSPELL_ACID_SPLASH_1; iMagoHechi = TRUE; }
          else if(iTirada == 2)  { iConjuro = IP_CONST_CASTSPELL_BURNING_HANDS_2; iMagoHechi = TRUE; }
          else if(iTirada == 3)  { iConjuro = IP_CONST_CASTSPELL_CHARM_PERSON_2; iBardo = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 4)  { iConjuro = IP_CONST_CASTSPELL_COLOR_SPRAY_2; iMagoHechi = TRUE; }
          else if(iTirada == 5)  { iConjuro = IP_CONST_CASTSPELL_DAZE_1; iBardo = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 6)  { iConjuro = IP_CONST_CASTSPELL_ELECTRIC_JOLT_1; iMagoHechi = TRUE; }
          else if(iTirada == 7)  { iConjuro = IP_CONST_CASTSPELL_MAGE_ARMOR_2; iBardo = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 8)  { iConjuro = IP_CONST_CASTSPELL_RAY_OF_FROST_1; iMagoHechi = TRUE; }
          else if(iTirada == 9)  { iConjuro = IP_CONST_CASTSPELL_RAY_OF_ENFEEBLEMENT_2; iMagoHechi = TRUE; }
          else if(iTirada == 10) { iConjuro = IP_CONST_CASTSPELL_BLESS_2; iClerigo = TRUE; iPaladin = TRUE; }
          else if(iTirada == 11) { iConjuro = IP_CONST_CASTSPELL_SLEEP_2; iBardo = TRUE; iDruida = TRUE; iExplorador = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 12) { iConjuro = IP_CONST_CASTSPELL_SUMMON_CREATURE_I_2; iBardo = TRUE; iClerigo = TRUE; iDruida = TRUE; iExplorador = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 13) { iConjuro = IP_CONST_CASTSPELL_DOOM_2; iClerigo = TRUE; }
          else if(iTirada == 14) { iConjuro = IP_CONST_CASTSPELL_ENDURE_ELEMENTS_2; iClerigo = TRUE; iDruida = TRUE; iPaladin = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 15) { iConjuro = IP_CONST_CASTSPELL_ENTANGLE_2; iDruida = TRUE; iExplorador = TRUE; }
          else if(iTirada == 16) { iConjuro = IP_CONST_CASTSPELL_FLARE_1; iBardo = TRUE; iDruida = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 17) { iConjuro = IP_CONST_CASTSPELL_GREASE_2; iBardo = TRUE; iDruida = TRUE; iExplorador = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 18) { iConjuro = IP_CONST_CASTSPELL_INFLICT_MINOR_WOUNDS_1; iClerigo = TRUE; }
          else if(iTirada == 19) { iConjuro = IP_CONST_CASTSPELL_LIGHT_1; iBardo = TRUE; iClerigo = TRUE; iDruida = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 20) { iConjuro = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_1; iClerigo = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 21) { iConjuro = IP_CONST_CASTSPELL_PROTECTION_FROM_ALIGNMENT_2; iBardo = TRUE; iClerigo = TRUE; iPaladin = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 22) { iConjuro = IP_CONST_CASTSPELL_REMOVE_FEAR_2; iClerigo = TRUE; }
          else if(iTirada == 23) { iConjuro = IP_CONST_CASTSPELL_RESISTANCE_2; iBardo = TRUE; iClerigo = TRUE; iDruida = TRUE; iPaladin = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 24) { iConjuro = IP_CONST_CASTSPELL_SANCTUARY_2; iClerigo = TRUE; }
          else if(iTirada == 25) { iConjuro = IP_CONST_CASTSPELL_SCARE_2; iBardo = TRUE; iClerigo = TRUE; iMagoHechi = TRUE; }
          else if(iTirada <= 29) { iConjuro = IP_CONST_CASTSPELL_CURE_LIGHT_WOUNDS_2; iBardo = TRUE; iClerigo = TRUE; iDruida = TRUE; iPaladin = TRUE; iExplorador = TRUE; }
          else if(iTirada <= 33) { iConjuro = IP_CONST_CASTSPELL_CURE_MINOR_WOUNDS_1; iBardo = TRUE; iClerigo = TRUE; iDruida = TRUE; }

          iTirada = d100();

          if(iTirada <= 40) iUsos = IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE;
          else              iUsos = IP_CONST_CASTSPELL_NUMUSES_2_CHARGES_PER_USE;
      }break;

      case 3:
      {
          iTirada = Random(28)+1;

               if(iTirada == 1)  { iConjuro = IP_CONST_CASTSPELL_BURNING_HANDS_2; iMagoHechi = TRUE; }
          else if(iTirada == 2)  { iConjuro = IP_CONST_CASTSPELL_MAGE_ARMOR_2; iBardo = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 3)  { iConjuro = IP_CONST_CASTSPELL_MAGIC_MISSILE_5; iMagoHechi = TRUE; }
          else if(iTirada == 4)  { iConjuro = IP_CONST_CASTSPELL_COLOR_SPRAY_2; iMagoHechi = TRUE; }
          else if(iTirada == 5)  { iConjuro = IP_CONST_CASTSPELL_GHOSTLY_VISAGE_3; iBardo = TRUE; iMagoHechi = TRUE;  }
          else if(iTirada == 6)  { iConjuro = IP_CONST_CASTSPELL_WEB_3; iMagoHechi = TRUE; }
          else if(iTirada == 7)  { iConjuro = IP_CONST_CASTSPELL_MELFS_ACID_ARROW_3; iMagoHechi = TRUE; }
          else if(iTirada == 8)  { iConjuro = IP_CONST_CASTSPELL_LIGHTNING_BOLT_5; iMagoHechi = TRUE; }
          else if(iTirada == 9)  { iConjuro = IP_CONST_CASTSPELL_AMPLIFY_5; iBardo = TRUE; }
          else if(iTirada == 10) { iConjuro = IP_CONST_CASTSPELL_BARKSKIN_3; iDruida = TRUE; iExplorador = TRUE; }
          else if(iTirada == 11) { iConjuro = IP_CONST_CASTSPELL_DOOM_5; iClerigo = TRUE; }
          else if(iTirada == 12) { iConjuro = IP_CONST_CASTSPELL_ENTANGLE_5; iDruida = TRUE; iExplorador = TRUE; }
          else if(iTirada == 13) { iConjuro = IP_CONST_CASTSPELL_BLESS_2; iClerigo = TRUE; iPaladin = TRUE; }
          else if(iTirada == 14) { iConjuro = IP_CONST_CASTSPELL_BANE_5; iClerigo = TRUE; }
          else if(iTirada == 15) { iConjuro = IP_CONST_CASTSPELL_SUMMON_CREATURE_II_3; iBardo = TRUE; iClerigo = TRUE; iDruida = TRUE; iExplorador = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 16) { iConjuro = IP_CONST_CASTSPELL_SUMMON_CREATURE_III_5; iBardo = TRUE; iClerigo = TRUE; iDruida = TRUE; iExplorador = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 17) { iConjuro = IP_CONST_CASTSPELL_SLEEP_5; iBardo = TRUE; iDruida = TRUE; iExplorador = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 18) { iConjuro = IP_CONST_CASTSPELL_PRAYER_5; iClerigo = TRUE; iPaladin = TRUE; }
          else if(iTirada == 19) { iConjuro = IP_CONST_CASTSPELL_OWLS_WISDOM_3; iClerigo = TRUE; iDruida = TRUE; iExplorador = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 20) { iConjuro = IP_CONST_CASTSPELL_ANIMATE_DEAD_5; iClerigo = TRUE; iMagoHechi = TRUE; }
          else if(iTirada <= 24) { iConjuro = IP_CONST_CASTSPELL_CURE_LIGHT_WOUNDS_5; iBardo = TRUE; iClerigo = TRUE; iDruida = TRUE; iPaladin = TRUE; iExplorador = TRUE; }
          else if(iTirada <= 28) { iConjuro = IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_3; iBardo = TRUE; iClerigo = TRUE; iDruida = TRUE; iPaladin = TRUE; iExplorador = TRUE; }

          iTirada = d100();

          if(iTirada <= 40) iUsos = IP_CONST_CASTSPELL_NUMUSES_2_CHARGES_PER_USE;
          else iUsos = IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE;
      }break;

      case 4:
      case 5:
      {
          iTirada = Random(25)+1;

          if(iTirada == 1)  { iConjuro = IP_CONST_CASTSPELL_DISPLACEMENT_9; iBardo = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 2)  { iConjuro = IP_CONST_CASTSPELL_FIREBALL_10; iMagoHechi = TRUE; }
          else if(iTirada == 3)  { iConjuro = IP_CONST_CASTSPELL_CONE_OF_COLD_9; iMagoHechi = TRUE; }
          else if(iTirada == 4)  { iConjuro = IP_CONST_CASTSPELL_DOMINATE_PERSON_7; iBardo = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 5)  { iConjuro = IP_CONST_CASTSPELL_DISPLACEMENT_9; iBardo = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 6)  { iConjuro = IP_CONST_CASTSPELL_WAR_CRY_7; iBardo = TRUE; }
          else if(iTirada == 7)  { iConjuro = IP_CONST_CASTSPELL_TASHAS_HIDEOUS_LAUGHTER_7; iBardo = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 8)  { iConjuro = IP_CONST_CASTSPELL_ENERVATION_7; iMagoHechi = TRUE; }
          else if(iTirada == 9) { iConjuro = IP_CONST_CASTSPELL_SLAY_LIVING_9; iClerigo = TRUE; iDruida = TRUE; }
          else if(iTirada == 10) { iConjuro = IP_CONST_CASTSPELL_STONESKIN_7; iDruida = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 11) { iConjuro = IP_CONST_CASTSPELL_ICE_STORM_9; iBardo = TRUE; iDruida = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 12) { iConjuro = IP_CONST_CASTSPELL_CALL_LIGHTNING_10; iDruida = TRUE; }
          else if(iTirada == 13) { iConjuro = IP_CONST_CASTSPELL_DARKVISION_6; iBardo = TRUE; iClerigo = TRUE; iDruida = TRUE; iExplorador = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 14) { iConjuro = IP_CONST_CASTSPELL_DEATH_WARD_7; iClerigo = TRUE; iDruida = TRUE; iPaladin = TRUE; }
          else if(iTirada == 15) { iConjuro = IP_CONST_CASTSPELL_DIVINE_POWER_7; iClerigo = TRUE; }
          else if(iTirada == 16) { iConjuro = IP_CONST_CASTSPELL_SUMMON_CREATURE_IV_7; iBardo = TRUE; iClerigo = TRUE; iDruida = TRUE; iExplorador = TRUE; iMagoHechi = TRUE; }
          else if(iTirada == 17) { iConjuro = IP_CONST_CASTSPELL_WALL_OF_FIRE_9; iDruida = TRUE; iMagoHechi = TRUE; }
          else if(iTirada <= 21) { iConjuro = IP_CONST_CASTSPELL_CURE_SERIOUS_WOUNDS_10; iBardo = TRUE; iClerigo = TRUE; iDruida = TRUE; iPaladin = TRUE; iExplorador = TRUE; }
          else if(iTirada <= 25) { iConjuro = IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_6; iBardo = TRUE; iClerigo = TRUE; iDruida = TRUE; iPaladin = TRUE; iExplorador = TRUE; }

          iTirada = d100();

          if(iTirada <= 40)  iUsos = IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE;
          else iUsos = IP_CONST_CASTSPELL_NUMUSES_4_CHARGES_PER_USE;
      }break;
  }

  itemproperty iPropiedadLanzarConjuro = ItemPropertyCastSpell(iConjuro, iUsos);
  IPSafeAddItemProperty(oObjeto, iPropiedadLanzarConjuro);
  DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_CAST_SPELL);

  iTirada = d3(4) * iRango + 5;
  if(iTirada > 40) iTirada = 40;
  SetItemCharges(oObjeto, iTirada);

  if(iBardo == TRUE)      IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(IP_CONST_CLASS_BARD));
  if(iClerigo == TRUE)    IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(IP_CONST_CLASS_CLERIC));
  if(iDruida == TRUE)     IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(IP_CONST_CLASS_DRUID));
  if(iPaladin == TRUE)    IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(IP_CONST_CLASS_PALADIN));
  if(iExplorador == TRUE) IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(IP_CONST_CLASS_RANGER));
  if(iMagoHechi == TRUE)
  {
      IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(IP_CONST_CLASS_WIZARD));
      IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(IP_CONST_CLASS_SORCERER));
      IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(CLASS_TYPE_INGENIERO));
  }
}

void EncantamientoPropiedadEspacioDeConjuro(object oObjeto, int iRango, int iCantidad)
{
  itemproperty ipEspacioDeConjuro;
  int iClase, iNivel, iClaseEspecial;
  int iContador = 0;
  int iTirada;
  do
  {
      iTirada = Random(11)+1;
      switch(iTirada)
      {
          case 1: {iClase = IP_CONST_CLASS_BARD;        iClaseEspecial = 1;}    break;
          case 2:  iClase = IP_CONST_CLASS_DRUID;                               break;
          case 3:  iClase = IP_CONST_CLASS_SORCERER;                            break;
          case 4:  iClase = IP_CONST_CLASS_WIZARD;                              break;
          case 5: {iClase = IP_CONST_CLASS_PALADIN;     iClaseEspecial = 2;}    break;
          case 6: {iClase = IP_CONST_CLASS_RANGER;      iClaseEspecial = 2;}    break;
          case 7:  iClase = IP_CONST_CLASS_CLERIC;                              break;
          case 8:  {iClase = CLASS_TYPE_INGENIERO;      iClaseEspecial = 1;}    break;
          case 9: {iClase = CLASS_TYPE_PAL_ANTIGUO;     iClaseEspecial = 2;}    break;
          case 10: {iClase = CLASS_TYPE_PAL_OSCURO;     iClaseEspecial = 2;}    break;
          case 11: {iClase = CLASS_TYPE_PAL_VENGADOR;   iClaseEspecial = 2;}    break;

      }
  }while((GetBaseItemType(oObjeto)==BASE_ITEM_MAGICSTAFF) && ((iClase==IP_CONST_CLASS_RANGER)||(iClase==IP_CONST_CLASS_PALADIN)||(iClase==IP_CONST_CLASS_BARD)));
  while(iContador < iCantidad)
  {
      if(iClaseEspecial == 1)
      {
          switch(iRango)  // Bardos y ArtÌfices maximo nivel 6
          {
              case 1: iNivel = 1;      break;  // 1
              case 2: iNivel = d2();   break;  // 1-2
              case 3: iNivel = d4();   break;  // 1-4
              case 4: iNivel = d4()+1; break;  // 2-5
              case 5: iNivel = d4()+2; break;  // 3-6
          }
      }

      else if(iClaseEspecial == 2)
      {
          switch(iRango)  // Paladines y exploradores maximo nivel 4
          {
              case 1: iNivel = 1;      break;  // 1
              case 2: iNivel = d2();   break;  // 1-2
              case 3: iNivel = d3();   break;  // 1-3
              case 4: iNivel = d3()+1; break;  // 2-4
              case 5: iNivel = d2()+2; break;  // 3-4
          }
      }
      else
      {
          switch(iRango)  // El resto maximo nivel 9
          {
              case 1: iNivel = d2();   break;  // 1-2
              case 2: iNivel = d3();   break;  // 1-3
              case 3: iNivel = d4()+1; break;  // 2-5
              case 4: iNivel = d6()+1; break;  // 2-7
              case 5: iNivel = d6()+3; break;  // 4-9
          }
      }

      ipEspacioDeConjuro = ItemPropertyBonusLevelSpell(iClase, iNivel);
      AddItemProperty(DURATION_TYPE_PERMANENT, ipEspacioDeConjuro, oObjeto);
      DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N);

      iContador = iContador + 1;
  }

  int iPropiedadesAEliminar = iCantidad - 1;
  itemproperty ip = GetFirstItemProperty(oObjeto);
  while(iPropiedadesAEliminar > 0)
  {
      if(GetIsItemPropertyValid(ip))
      {
          RemoveItemProperty(oObjeto, ip);
          iPropiedadesAEliminar = iPropiedadesAEliminar - 1;

          ip = GetNextItemProperty(oObjeto);
      }
         else iPropiedadesAEliminar = 0;
  }

  itemproperty ipLimitacionClase = ItemPropertyLimitUseByClass(iClase);
  IPSafeAddItemProperty(oObjeto, ipLimitacionClase);
  DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_USE_LIMITATION_CLASS);
}

void EncantamientoPropiedadReforzado(object oObjeto, int iRango)
{
    int iCalidad;

     switch(iRango)
     {
         case 1: iCalidad = d2();           break;  // 1-2
         case 2: iCalidad = Random(2)+2;    break;  // 2-3
         case 3: iCalidad = Random(2)+3;    break;  // 3-4
         case 4: iCalidad = Random(2)+4;    break;  // 4-5
         case 5: iCalidad = 5;              break; // 5
     }

     itemproperty iPropiedadReforzado = ItemPropertyMaxRangeStrengthMod(iCalidad);
     IPSafeAddItemProperty(oObjeto, iPropiedadReforzado);
     DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_MIGHTY);
}

void EncantamientoPropiedadBonoAtaque(object oObjeto, int iRango)
{
    int iCalidad;

     switch(iRango)
     {
         case 1: iCalidad = d2();            break;  // 1-2
         case 2: iCalidad = Random(2)+2;     break;  // 2-3
         case 3: iCalidad = Random(2)+3;     break;  // 3-4
         case 4: iCalidad = Random(2)+4;     break;  // 4-5
         case 5: iCalidad = 5;               break;  // 5
     }

     itemproperty iPropiedadBonificadorAtaque = ItemPropertyEnhancementBonus(iCalidad);
     IPSafeAddItemProperty(oObjeto, iPropiedadBonificadorAtaque);
     DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_ENHANCEMENT_BONUS);
}

void EncantamientoPropiedadMunicionIlimitada(object oObjeto, int iRango)
{
  int iTipo, iTirada;

  switch (iRango)
  {
      case 1:
      case 2:
      case 3:
      case 4: iTipo = IP_CONST_UNLIMITEDAMMO_BASIC; break;

      case 5:
      {
          iTirada = d10();

               if(iTirada <= 2) iTipo = IP_CONST_UNLIMITEDAMMO_BASIC;
               if(iTirada <= 4) iTipo = IP_CONST_UNLIMITEDAMMO_PLUS1;
          else if(iTirada <= 6) iTipo = IP_CONST_UNLIMITEDAMMO_PLUS2;
          else if(iTirada == 7) iTipo = IP_CONST_UNLIMITEDAMMO_PLUS3;
          else if(iTirada == 8) iTipo = IP_CONST_UNLIMITEDAMMO_1D6COLD;
          else if(iTirada == 9) iTipo = IP_CONST_UNLIMITEDAMMO_1D6FIRE;
          else                  iTipo = IP_CONST_UNLIMITEDAMMO_1D6LIGHT;
      }break;
  }

  itemproperty ipMunicionIlimitada = ItemPropertyUnlimitedAmmo(iTipo);
  IPSafeAddItemProperty(oObjeto, ipMunicionIlimitada);
  DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_UNLIMITED_AMMUNITION);
}

void EncantamientoPropiedadBonificadorMejoraAtaque(object oObjeto, int iRango)
{
  itemproperty ipBonificadorMejora, ipBonificadorAtaque;
  int iValor;
  int iTirada = d100();

  switch(iRango)
  {
      case 1: iValor = d2();            break;  // 1-2
      case 2: iValor = Random(2)+2;     break;  // 2-3
      case 3: iValor = Random(2)+3;     break;  // 3-4
      case 4: iValor = Random(2)+4;     break;  // 4-5
      case 5: iValor = 5;               break;  // 5

  }

        if(iTirada <= 70)  ipBonificadorAtaque = ItemPropertyEnhancementBonus(iValor);
    else if(iTirada <= 85)  ipBonificadorAtaque = ItemPropertyEnhancementBonusVsAlign(Random(5)+1, iValor);
    else if(iTirada <= 100) ipBonificadorAtaque = ItemPropertyEnhancementBonusVsRace(ObtenerRazaAleatoria(), iValor);

    IPSafeAddItemProperty(oObjeto, ipBonificadorAtaque);

        if(iTirada <= 70)  DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_ENHANCEMENT_BONUS);
    else if(iTirada <= 85)  DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP);
    else if(iTirada <= 100) DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP);
}

void EncantamientoPropiedadExtraDanyoDistancia(object oObjeto)
{
  itemproperty ipTipoDanyoDistancia = ItemPropertyExtraRangeDamageType(Random(3));
  IPSafeAddItemProperty(oObjeto, ipTipoDanyoDistancia);
  DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE);
}

void EncantamientoPropiedadExtraDanyoCuerpoACuerpo(object oObjeto)
{
  int iTipoObjeto = GetBaseItemType(oObjeto);
  if(iTipoObjeto == BASE_ITEM_DART || iTipoObjeto == BASE_ITEM_THROWINGAXE || iTipoObjeto == BASE_ITEM_SHURIKEN)
  {
      IPSafeAddItemProperty(oObjeto, ItemPropertyExtraRangeDamageType(Random(3)));
      DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE);
  }
  else
  {
      IPSafeAddItemProperty(oObjeto, ItemPropertyExtraMeleeDamageType(Random(3)));
      DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE);
  }
}

void EncantamientoPropiedadCriticosMasivos(object oObjeto, int iRango)
{
  int iDanyo = ObtenerDanyoPorRangoAleatorio(iRango);
  int iTipoArma = GetBaseItemType(oObjeto);

  if(iTipoArma == BASE_ITEM_RAPIER  || iTipoArma == BASE_ITEM_KUKRI ||
     iTipoArma == BASE_ITEM_SCIMITAR || iTipoArma == 1172)
  {
      if(iDanyo != IP_CONST_DAMAGEBONUS_1 && iDanyo != IP_CONST_DAMAGEBONUS_2 && iDanyo != IP_CONST_DAMAGEBONUS_3 &&
         iDanyo != IP_CONST_DAMAGEBONUS_1d4 && iDanyo != IP_CONST_DAMAGEBONUS_1d6) iDanyo = IP_CONST_DAMAGEBONUS_1d6;
  }

  IPSafeAddItemProperty(oObjeto, ItemPropertyMassiveCritical(iDanyo));
  DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_MASSIVE_CRITICALS);
}

void EncantamientoPropiedadBonificadorDanyo(object oObjeto, int iRango)
{
  int iTirada = d100();
  itemproperty ipBonificadorDanyo;
  int iDanyo     = ObtenerDanyoPorRangoAleatorio(iRango);
  int iTipoDanyo = ObtenerTipoDanyoAleatorio();
  int iRaza      = ObtenerRazaAleatoria();

  if(iTipoDanyo == IP_CONST_DAMAGETYPE_MAGICAL  || iTipoDanyo == IP_CONST_DAMAGETYPE_DIVINE ||
     iTipoDanyo == IP_CONST_DAMAGETYPE_NEGATIVE || iTipoDanyo == IP_CONST_DAMAGETYPE_POSITIVE)
  {
      if(iDanyo != IP_CONST_DAMAGEBONUS_1 && iDanyo != IP_CONST_DAMAGEBONUS_2 && iDanyo != IP_CONST_DAMAGEBONUS_1d4) iDanyo = IP_CONST_DAMAGEBONUS_1d4;
  }

  if(iTipoDanyo == IP_CONST_DAMAGETYPE_FUERZA  || iTipoDanyo == IP_CONST_DAMAGETYPE_PSIQUICO || iTipoDanyo == IP_CONST_DAMAGETYPE_VENENO)
  {
      if(iDanyo != IP_CONST_DAMAGEBONUS_1 && iDanyo != IP_CONST_DAMAGEBONUS_2 && iDanyo != IP_CONST_DAMAGEBONUS_1d4 && iDanyo != IP_CONST_DAMAGEBONUS_3
      && iDanyo != IP_CONST_DAMAGEBONUS_1d6 && iDanyo != IP_CONST_DAMAGEBONUS_4 && iDanyo != IP_CONST_DAMAGEBONUS_1d8) iDanyo = IP_CONST_DAMAGEBONUS_1d8;
  }

       if(iTirada <= 80)  ipBonificadorDanyo = ItemPropertyDamageBonus(iTipoDanyo, iDanyo);
  else if(iTirada <= 90)  ipBonificadorDanyo = ItemPropertyDamageBonusVsAlign(Random(5)+1, iTipoDanyo, iDanyo);
  else if(iTirada <= 100) ipBonificadorDanyo = ItemPropertyDamageBonusVsRace(iRaza, iTipoDanyo, iDanyo);

  IPSafeAddItemProperty(oObjeto, ipBonificadorDanyo, 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);

       if(iTirada <= 80)  DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_DAMAGE_BONUS);
  else if(iTirada <= 90)  DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP);
  else if(iTirada <= 100) DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP);
}

void EncantamientoPropiedadBonificadorHabilidad(object oObjeto, int iRango)
{
  int iValor;
  int iHabilidad = Random(39);
  if(iHabilidad == 20 || iHabilidad == 22) iHabilidad = Random(34); // Parche para que estas habilidades tengan menos porcentage de aparicion (Tasacion y Artesania)
  else if(iHabilidad == 34) iHabilidad = Random(34);                // Parche para que hablar un idioma no se escoja


  switch(iRango)
  {
      case 1: iValor = d4() + 3; break;
      case 2: iValor = d4() + 3; break;
      case 3: iValor = d4() + 4; break;
      case 4: iValor = d4() + 5; break;
  }

  if(iValor >7) iValor = 7;

  itemproperty ipBonificadorHabilidad = ItemPropertySkillBonus(iHabilidad, iValor);
  IPSafeAddItemProperty(oObjeto, ipBonificadorHabilidad);
  DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_SKILL_BONUS);
}

void EncantamientoPropiedadBonificadorCA(object oObjeto, int iRango)
{
  itemproperty ipBonificadorCA;
  int iValor, iTipoCA;
  int iTirada = d100();

  switch(iRango)
  {
      case 1: iValor = d2();            break;  // 1-2
      case 2: iValor = Random(2)+2;     break;  // 2-3
      case 3: iValor = Random(2)+3;     break; // 3-4
      case 4: iValor = Random(2)+4;     break; // 4-5
      case 5: iValor = 5;               break;  // 5
  }

       if(iTirada <= 55)  ipBonificadorCA = ItemPropertyACBonus(iValor);
  else if(iTirada <= 70)  ipBonificadorCA = ItemPropertyACBonusVsAlign(Random(5)+1, iValor);
  else if(iTirada <= 85)  ipBonificadorCA = ItemPropertyACBonusVsDmgType(Random(3), iValor);
  else if(iTirada <= 100) ipBonificadorCA = ItemPropertyACBonusVsRace(ObtenerRazaAleatoria(), iValor);

  IPSafeAddItemProperty(oObjeto, ipBonificadorCA);

       if(iTirada <= 55)  DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_AC_BONUS);
  else if(iTirada <= 70)  DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP);
  else if(iTirada <= 85)  DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE);
  else if(iTirada <= 100) DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP);
}

void EncantamientoPropiedadResistenciaReduccionDanyo(object oObjeto, int iRango)
{
  int iResistencia, iMejoraReducida, iCantidadReducida;

  if(d100() <= 70) // 70 % de resistencia de danyo
  {
      switch(iRango)
      {
          case 1:
          case 2: iResistencia = IP_CONST_DAMAGEIMMUNITY_10_PERCENT; break;
          case 3: iResistencia = IP_CONST_DAMAGEIMMUNITY_10_PERCENT; break;
          case 4:
          {
              if(d2() == 1) iResistencia = IP_CONST_DAMAGEIMMUNITY_10_PERCENT;
              else          iResistencia = 9;
          }break;
          case 5: iResistencia = 9; break;
      }

      int iTipoDanyo = ObtenerTipoDanyoAleatorio();

      int iTirada = d3();
       if(iTirada == 1)  iTipoDanyo = IP_CONST_DAMAGETYPE_BLUDGEONING;
  else if(iTirada == 2)  iTipoDanyo = IP_CONST_DAMAGETYPE_SLASHING;
  else if(iTirada == 3)  iTipoDanyo = IP_CONST_DAMAGETYPE_PIERCING;

      IPSafeAddItemProperty(oObjeto,ItemPropertyDamageImmunity(iTipoDanyo, iResistencia));
      DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE);
  }

  else // 30 % de reduccion de danyo
  {
      switch(iRango)
      {
          case 1:
          case 2:
          {
              iMejoraReducida = IP_CONST_DAMAGEREDUCTION_1;  // +1
              iCantidadReducida = IP_CONST_DAMAGESOAK_5_HP;  // 5 hp
          }break;

          case 3:
          {
              iMejoraReducida = Random(2);      // +1 o +2
              iCantidadReducida = Random(2)+1;  // 5 o 10 hp
          }break;

          case 4:
          {
              iMejoraReducida = Random(3);      // +1 o +2 o +3
              iCantidadReducida = Random(2)+1;  // 5 o 10 hp
          }break;

          case 5:
          {
              iMejoraReducida = Random(3)+2;                 // +3 o +4 o +5
              iCantidadReducida = IP_CONST_DAMAGESOAK_5_HP;  // 5hp
          }break;
      }

      itemproperty ipReduccionDanyo = ItemPropertyDamageReduction(iMejoraReducida, iCantidadReducida);
      IPSafeAddItemProperty(oObjeto, ipReduccionDanyo);
      DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_DAMAGE_REDUCTION);
  }
}

void EncantamientoPropiedadBonificadorCaracteristica(object oObjeto, int iRango)
{
  int iValor;

  switch(iRango)
  {
      case 1: iValor = d2();            break;  // 1-2
      case 2: iValor = Random(2)+3;     break; // 3-4
      case 3: iValor = Random(2)+5;     break; // 5-6
      case 4: iValor = 6;               break;  // 6
      case 5: iValor = 6;               break;  // 6
  }

  itemproperty ipBonificadorCaracteristica = ItemPropertyAbilityBonus(Random(6), iValor);
  IPSafeAddItemProperty(oObjeto, ipBonificadorCaracteristica);
  DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_ABILITY_BONUS);
}

void EncantamientoPropiedadMiscelanea(object oObjeto, int iRango)
{
  itemproperty ipPropiedadMiscelanea;
  int iTirada, iDebugPropiedad;

  switch(iRango)
  {
      case 1:
      {
          iTirada = d10();

          if(iTirada <= 7)      {ipPropiedadMiscelanea = ItemPropertyBonusSpellResistance(0); iDebugPropiedad = ITEM_PROPERTY_SPELL_RESISTANCE;} // +10
          else if(iTirada == 8) {ipPropiedadMiscelanea = ItemPropertyWeightReduction(1);      iDebugPropiedad = ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION;} // 80%
          else if(iTirada == 9) {ipPropiedadMiscelanea = ItemPropertyBonusFeat(0);            iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote alerta
          else                  {ipPropiedadMiscelanea = ItemPropertyDarkvision();            iDebugPropiedad = ITEM_PROPERTY_DARKVISION;} // Vision en la oscuridad
      }break;

      case 2:
      {
          iTirada = d20();

          if(iTirada <= 4)       {ipPropiedadMiscelanea = ItemPropertyBonusSpellResistance(Random(2)); iDebugPropiedad = ITEM_PROPERTY_SPELL_RESISTANCE;} // +10 o +12
          else if(iTirada <= 8)  {ipPropiedadMiscelanea = ItemPropertyBonusFeat(Random(2)+1);          iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote Ambidextrismo o Hendedura
          else if(iTirada <= 12) {ipPropiedadMiscelanea = ItemPropertyBonusFeat(Random(4)+237);        iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote Voluntad de hierro, Gran Fortaleza, Reflejos r·pidos, Pericia en Combate
          //else if(iTirada <= 15) {ipPropiedadMiscelanea = ItemPropertyBonusFeat(Random(3)+114);        iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote Finta mejorada, Romper Arma mejorado, Presa mejorada
          //else if(iTirada == 16) {ipPropiedadMiscelanea = ItemPropertyBonusFeat(Random(2)+111);        iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote Arrollar mejorado, Presa mejorado
          //else if(iTirada == 17) {ipPropiedadMiscelanea = ItemPropertyBonusFeat(107);                  iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote Embestida mejorada
          else if(iTirada <= 18) {ipPropiedadMiscelanea = ItemPropertyWeightReduction(Random(2)+1);    iDebugPropiedad = ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION;} // 80% o 60%
          else if(iTirada == 19) {ipPropiedadMiscelanea = ItemPropertyBonusFeat(0);                    iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote alerta
          else                   {ipPropiedadMiscelanea = ItemPropertyDarkvision();                    iDebugPropiedad = ITEM_PROPERTY_DARKVISION;} // Vision en la oscuridad
      }break;

      case 3:
      {
          iTirada = d20();

          if(iTirada <= 3)       {ipPropiedadMiscelanea = ItemPropertyBonusSpellResistance(Random(3));  iDebugPropiedad = ITEM_PROPERTY_SPELL_RESISTANCE;} // +10 o +12 o +14
          else if(iTirada <= 5)  {ipPropiedadMiscelanea = ItemPropertyBonusFeat(Random(5)+1);           iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote Ambidextrismo o Hendedura o Conjurar en Combate o Esquiva o Expulsares aumentados
          else if(iTirada <= 8)  {ipPropiedadMiscelanea = ItemPropertyBonusFeat(Random(7)+8);           iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Una de las 7 dotes de soltura con escuela de magia
          else if(iTirada <= 11) {ipPropiedadMiscelanea = ItemPropertyRegeneration(1);                  iDebugPropiedad = ITEM_PROPERTY_REGENERATION;} // Regeneracion 1
          else if(iTirada <= 14) {ipPropiedadMiscelanea = ItemPropertyBonusFeat(Random(4)+237);         iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote Voluntad de hierro, Gran Fortaleza, Reflejos r·pidos, Pericia en Combate
          //else if(iTirada <= 16) {ipPropiedadMiscelanea = ItemPropertyBonusFeat(Random(3)+114);         iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote Finta mejorada, Romper Arma mejorado, Presa mejorada
          //else if(iTirada == 17) {ipPropiedadMiscelanea = ItemPropertyBonusFeat(Random(2)+111);         iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote Arrollar mejorado, Presa mejorado
          //else if(iTirada == 18) {ipPropiedadMiscelanea = ItemPropertyBonusFeat(107);                   iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote Embestida mejorada
          else if(iTirada <= 19) {ipPropiedadMiscelanea = ItemPropertyImmunityToSpellLevel(1);          iDebugPropiedad = ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL;} // Immunidad a conjuros de nivel 1
          else                   {ipPropiedadMiscelanea = ItemPropertyWeightReduction(Random(3)+1);     iDebugPropiedad = ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION;} // 80% o 60% o 40%
      }break;

      case 4:
      {
          iTirada = d20();

          if(iTirada <= 3)       {ipPropiedadMiscelanea = ItemPropertyBonusSpellResistance(Random(3)+1);  iDebugPropiedad = ITEM_PROPERTY_SPELL_RESISTANCE;} // +12 o +14 o +16
          else if(iTirada <= 5)  {ipPropiedadMiscelanea = ItemPropertyBonusFeat(Random(5)+1);             iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote Ambidextrismo o Hendedura o Conjurar en Combate o Esquiva o Expulsares aumentados
          else if(iTirada <= 7)  {ipPropiedadMiscelanea = ItemPropertyBonusFeat(Random(6)+15);            iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote Conjuros penetrantes o Ataque poderoso o Combate con dos armas o Especializacion impacto sin arma o Sutileza o Crtico mejorado sin arma
          else if(iTirada <= 9)  {ipPropiedadMiscelanea = ItemPropertyBonusFeat(Random(7)+8);             iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Una de las 7 dotes de soltura con escuela de magia
          else if(iTirada <= 11) {ipPropiedadMiscelanea = ItemPropertyRegeneration(1);                    iDebugPropiedad = ITEM_PROPERTY_REGENERATION;} // Regeneracion 1
          else if(iTirada <= 14) {ipPropiedadMiscelanea = ItemPropertyBonusFeat(Random(4)+237);           iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote Voluntad de hierro, Gran Fortaleza, Reflejos r·pidos, Pericia en Combate
          //else if(iTirada <= 16) {ipPropiedadMiscelanea = ItemPropertyBonusFeat(Random(3)+114);           iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote Finta mejorada, Romper Arma mejorado, Presa mejorada
          //else if(iTirada == 17) {ipPropiedadMiscelanea = ItemPropertyBonusFeat(Random(2)+111);           iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote Arrollar mejorado, Presa mejorado
          //else if(iTirada == 18) {ipPropiedadMiscelanea = ItemPropertyBonusFeat(107);                     iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote Embestida mejorada
          else if(iTirada <= 19) {ipPropiedadMiscelanea = ItemPropertyImmunityToSpellLevel(d2());         iDebugPropiedad = ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL;} // Immunidad a conjuros de nivel 1 o 2
          else                   {ipPropiedadMiscelanea = ItemPropertyWeightReduction(Random(3)+2);       iDebugPropiedad = ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION;} // 60% o 40% o 20%
      }break;

      case 5:
      {
          iTirada = d20();

          if(iTirada <= 2)       {ipPropiedadMiscelanea = ItemPropertyBonusSpellResistance(Random(3)+2);  iDebugPropiedad = ITEM_PROPERTY_SPELL_RESISTANCE;} // +14 o +16 o +18
          else if(iTirada <= 4)  {ipPropiedadMiscelanea = ItemPropertyBonusFeat(Random(5)+1);             iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote Ambidextrismo o Hendedura o Conjurar en Combate o Esquiva o Expulsares aumentados
          else if(iTirada <= 6)  {ipPropiedadMiscelanea = ItemPropertyBonusFeat(Random(6)+15);            iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote Conjuros penetrantes o Ataque poderoso o Combate con dos armas o Especializacion impacto sin arma o Sutileza o Crtico mejorado sin arma
          //else if(iTirada <= 8)  {ipPropiedadMiscelanea = ItemPropertyBonusFeat(Random(4)+27);            iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Movilidad, Desarme mejorado, Ataque torbellino, Disparo rapido
          else if(iTirada <= 10) {ipPropiedadMiscelanea = ItemPropertyBonusFeat(Random(7)+8);             iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Una de las 7 dotes de soltura con escuela de magia
          else if(iTirada <= 12) {ipPropiedadMiscelanea = ItemPropertyRegeneration(1);                    iDebugPropiedad = ITEM_PROPERTY_REGENERATION;} // Regeneracion 1
          else if(iTirada <= 14) {ipPropiedadMiscelanea = ItemPropertyBonusFeat(Random(4)+237);           iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote Voluntad de hierro, Gran Fortaleza, Reflejos r·pidos, Pericia en Combate
          //else if(iTirada <= 16) {ipPropiedadMiscelanea = ItemPropertyBonusFeat(Random(3)+114);           iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote Finta mejorada, Romper Arma mejorado, Presa mejorada
          //else if(iTirada == 17) {ipPropiedadMiscelanea = ItemPropertyBonusFeat(Random(2)+111);           iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote Arrollar mejorado, Presa mejorado
          //else if(iTirada == 18) {ipPropiedadMiscelanea = ItemPropertyBonusFeat(107);                     iDebugPropiedad = ITEM_PROPERTY_BONUS_FEAT;} // Dote Embestida mejorada
          else if(iTirada <= 19) {ipPropiedadMiscelanea = ItemPropertyImmunityToSpellLevel(d2());         iDebugPropiedad = ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL;} // Immunidad a conjuros de nivel 1 o 2
          else                   {ipPropiedadMiscelanea = ItemPropertyWeightReduction(Random(3)+3);       iDebugPropiedad = ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION;} // 40% o 20% 0 10%
      }break;
  }

  IPSafeAddItemProperty(oObjeto, ipPropiedadMiscelanea);
  DebugComprobarCorrectaAplicacionPropiedad(oObjeto, iDebugPropiedad);
}

void EncantamientoPropiedadBonificadorSalvacion(object oObjeto, int iRango)
{
  itemproperty ipBonificadorSalvacion;
  int iValor, iTipo, iTirada;
  int iProbabilidadSalvacion = d100();

  switch(iRango)
  {
      case 1: iValor = 1;      break;  // 1
      case 2:
      case 3: iValor = d2();   break;  // 1-2
      case 4: iValor = d3();   break;  // 1-3
      case 5: iValor = d2()+1; break;  // 2-3
  }

  if(iProbabilidadSalvacion <= 15)
  {
      iTirada = Random(13)+1;
      switch(iTirada)
      {
          case 1:  iTipo = IP_CONST_SAVEVS_ACID;          break;
          case 2:  iTipo = IP_CONST_SAVEVS_COLD;          break;
          case 3:  iTipo = IP_CONST_SAVEVS_DEATH;         break;
          case 4:  iTipo = IP_CONST_SAVEVS_DISEASE;       break;
          case 5:  iTipo = IP_CONST_SAVEVS_DIVINE;        break;
          case 6:  iTipo = IP_CONST_SAVEVS_ELECTRICAL;    break;
          case 7:  iTipo = IP_CONST_SAVEVS_FEAR;          break;
          case 8:  iTipo = IP_CONST_SAVEVS_FIRE;          break;
          case 9:  iTipo = IP_CONST_SAVEVS_MINDAFFECTING; break;
          case 10: iTipo = IP_CONST_SAVEVS_NEGATIVE;      break;
          case 11: iTipo = IP_CONST_SAVEVS_POISON;        break;
          case 12: iTipo = IP_CONST_SAVEVS_POSITIVE;      break;
          case 13: iTipo = IP_CONST_SAVEVS_SONIC;         break;
      }

      ipBonificadorSalvacion = ItemPropertyBonusSavingThrowVsX(iTipo, iValor);
  }

  else if(iProbabilidadSalvacion <= 35)  ipBonificadorSalvacion = ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, iValor);
  else if(iProbabilidadSalvacion <= 100) ipBonificadorSalvacion = ItemPropertyBonusSavingThrow(Random(3)+1, iValor);

  IPSafeAddItemProperty(oObjeto, ipBonificadorSalvacion);

       if(iProbabilidadSalvacion <= 35)  DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_SAVING_THROW_BONUS);
  else if(iProbabilidadSalvacion <= 100) DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC);
}

void EncantamientoPropiedadRegeneracionVampirica(object oObjeto, int iRango)
{
  int iRegeneracion;

  switch(iRango)
  {
      case 1: iRegeneracion = 1;      break;  // 1
      case 2: iRegeneracion = d2();   break;  // 1-2
      case 3: iRegeneracion = d3();   break;  // 1-3
      case 4: iRegeneracion = d3()+1; break;  // 2-4
      case 5: iRegeneracion = d4()+1; break;  // 2-5
  }

  itemproperty ipRegeneracionVampirica = ItemPropertyVampiricRegeneration(iRegeneracion);
  IPSafeAddItemProperty(oObjeto, ipRegeneracionVampirica);
  DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_REGENERATION_VAMPIRIC);
}

void EncantamientoPropiedadEfectoAlGolpear(object oObjeto, int iRango)
{
  int iTipoEfecto, iCD;
  int iEspecial = 1;
  int iTirada = Random(15) + 1;

  switch(iTirada)
  {
      case 1:  iTipoEfecto = IP_CONST_ONHIT_ABILITYDRAIN; iEspecial = Random(6);   break;
      case 2:  iTipoEfecto = IP_CONST_ONHIT_BLINDNESS;    iEspecial = Random(3)+2;   break;
      case 3:  iTipoEfecto = IP_CONST_ONHIT_CONFUSION;    iEspecial = Random(3)+2;   break;
      case 4:  iTipoEfecto = IP_CONST_ONHIT_DAZE;         iEspecial = Random(3)+2;   break;
      case 5:  iTipoEfecto = IP_CONST_ONHIT_DEAFNESS;     iEspecial = Random(3)+2;   break;
      case 6:  iTipoEfecto = IP_CONST_ONHIT_DISEASE;      iEspecial = Random(17);  break;
      case 7:  iTipoEfecto = IP_CONST_ONHIT_DOOM;         iEspecial = Random(3)+2;   break;
      case 8:  iTipoEfecto = IP_CONST_ONHIT_FEAR;         iEspecial = Random(3)+2;   break;
      case 9:  iTipoEfecto = IP_CONST_ONHIT_HOLD;         iEspecial = Random(3)+2;   break;
      case 10: iTipoEfecto = IP_CONST_ONHIT_ITEMPOISON;   iEspecial = Random(6);   break;
      case 11: iTipoEfecto = IP_CONST_ONHIT_SILENCE;      iEspecial = Random(3)+2;   break;
      case 12: iTipoEfecto = IP_CONST_ONHIT_SLEEP;        iEspecial = Random(3)+2;   break;
      case 13: iTipoEfecto = IP_CONST_ONHIT_SLOW;         iEspecial = Random(3)+2;   break;
      case 14: iTipoEfecto = IP_CONST_ONHIT_STUN;         iEspecial = Random(3)+2;   break;
      //case 15: iTipoEfecto = IP_CONST_ONHIT_WOUNDING;     iEspecial = Random(4)+1; break; Sube mucho el nivel (valor del objeto) y es poco util
      //case 16: iTipoEfecto = IP_CONST_ONHIT_KNOCK;                                 break; Apertura no funciona con ubicados que no se pueden destruir
      case 15: iTipoEfecto = IP_CONST_ONHIT_LESSERDISPEL;                          break;
  }

  switch(iRango)
  {
      case 1:
      case 2:  iCD = 0;           break;  // CD 14
      case 3:  iCD = Random(2);   break;  // CD 14-16
      case 4:  iCD = Random(2);   break;  // CD 14-16
      case 5:  iCD = Random(2)+1; break;  // CD 16-18
  }

  itemproperty ipEfectoAlGolpear = ItemPropertyOnHitProps(iTipoEfecto, iCD, iEspecial);
  IPSafeAddItemProperty(oObjeto, ipEfectoAlGolpear);
  DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_ON_HIT_PROPERTIES, iTipoEfecto, iCD, iEspecial);
}

void EncantamientoPropiedadAfilada(object oObjeto)
{
  IPSafeAddItemProperty(oObjeto, ItemPropertyKeen());
  DebugComprobarCorrectaAplicacionPropiedad(oObjeto, ITEM_PROPERTY_KEEN);
}

void FinalizarObjetoCreado(object oObjeto, object oObjetivo, int iCalidad, int iRango, int iTienda = FALSE)
{
  if(iCalidad > 0)
  {
      int ipCalidad;
      string sNombre = GetName(oObjeto);

      switch(iRango)
      {
          case 1: sNombre = ColorString(sNombre+" superior", 159, 182, 205);  ipCalidad = IP_CONST_QUALITY_ABOVE_AVERAGE; break;
          case 2: sNombre = ColorString(sNombre+" encantado/a", 0, 243, 243); ipCalidad = IP_CONST_QUALITY_VERY_GOOD;     break;
          case 3: sNombre = ColorString(sNombre+" poderoso/a", 65, 105, 225);   ipCalidad = IP_CONST_QUALITY_EXCELLENT;     break;
          case 4: sNombre = ColorString(sNombre+" legendario/a", 218, 165, 32); ipCalidad = IP_CONST_QUALITY_MASTERWORK;    break;
          case 5: sNombre = ColorString(sNombre+" tit·nico/a", 255, 0, 255);    ipCalidad = IP_CONST_QUALITY_GOD_LIKE;      break;
      }

      SetName(oObjeto, sNombre);
      SetPlotFlag(oObjeto, FALSE);
      SetLocalInt(oObjeto, "CALIDAD_GUARDADA", ipCalidad);
      SetLocalInt(oObjeto, "PCItem", 1);

      if(GetObjectType(oObjetivo) == OBJECT_TYPE_CREATURE) SetDescription(oObjeto, "Puedes notar cÛmo este objeto contiene encantamientos, pero no lleva el sello de ning˙n fabricante. Su historia y leyenda son aparentemente desconocidas, sÛlo conoces que lo rescataste de las garras de "+GetName(OBJECT_SELF)+". A partir de ahora t˙ ser·s su nuevo propietario, el amo y seÒor de los relatos venideros de este objeto m·gico.");
      else if(iTienda == TRUE) SetDescription(oObjeto, "Puedes notar cÛmo este objeto contiene encantamientos, pero no lleva el sello de ning˙n fabricante. Su historia y leyenda son aparentemente desconocidas, sÛlo conoces que un comerciante te lo vendiÛ. A partir de ahora t˙ ser·s su nuevo propietario, el amo y seÒor de los relatos venideros de este objeto m·gico.");
      else SetDescription(oObjeto, "Puedes notar cÛmo este objeto contiene encantamientos, pero no lleva el sello de ning˙n fabricante. Su historia y leyenda son aparentemente desconocidas, sÛlo conoces que lo rescataste del interior de un cofre de tesoro. A partir de ahora t˙ ser·s su nuevo propietario, el amo y seÒor de los relatos venideros de este objeto m·gico.");

      SetIdentified(oObjeto, TRUE);
      if(GetGoldPieceValue(oObjeto) > 200 && iTienda == FALSE) SetIdentified(oObjeto, FALSE);

      if(iCalidad > 4) SetLocalInt(oObjeto, "masNivel15", TRUE);
      DelayCommand(0.2, IPSafeAddItemProperty(oObjeto, ItemPropertyQuality(ipCalidad)));
      if (iTienda==TRUE) {SetIdentified(oObjeto, TRUE);}
  }

  else
  {
      SetLocalInt(oObjeto, "CALIDAD_GUARDADA", IP_CONST_QUALITY_AVERAGE);
      SetDescription(oObjeto, "Este objeto no tiene ning˙n encantamiento, ni siquiera mundano, y tampoco lleva el sello de ning˙n fabricante.");
      SetIdentified(oObjeto, TRUE);
      SetPlotFlag(oObjeto, FALSE);
      SetLocalInt(oObjeto, "PCItem", 1);
      if (iTienda==TRUE) {SetIdentified(oObjeto, TRUE);}
      DelayCommand(0.2, IPSafeAddItemProperty(oObjeto, ItemPropertyQuality(IP_CONST_QUALITY_AVERAGE)));
  }

}

object IniciarObjetoCreado(object oObjetivo, int iTipoObjeto, int iTienda = FALSE)
{
  int iTirada, iTipoDeterioro, iArmaRota, iArmaDoble, iArrojadiza, iMunicion;
  int iStack = 1;
  string sResref, sNombre;

  int iDebugMess = 0;

  if(iDebugMess == 1) SendMessageToAllDMs("Creando objeto basico, tipo de objeto: "+IntToString(iTipoObjeto));

  switch(iTipoObjeto)
  {
      case 1: // Espadas largas
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = Random(19) + 1;
          switch(iTirada)
          {
              case 1:  sResref = "nw_it_crewls00" + IntToString(Random(2)+5); break;
              case 2:  sResref = "nw_it_novel007"; break;
              case 3:  sResref = "nw_wswls001"; break;
              case 4:  sResref = "nw_wswmls002"; break;
              case 5:  sResref = "nw_wswmls00" + IntToString(Random(4)+4); break;
              case 6:  sResref = "nw_wswmls009"; break;
              case 7:  sResref = "nw_wswmls01" + IntToString(Random(4)); break;
              case 8:  sResref = "x0_wswmls001"; break;
              case 9:  sResref = "x"+IntToString(Random(2))+"_wswmls002"; break;
              case 10: sResref = "x2_it_frzdrowbld"; break;
              case 11: sResref = "x2_wdrowls00" + IntToString(Random(4)+1); break;
              case 12: sResref = "x2_wswmls00" + IntToString(Random(5)+3); break;
              case 13: sResref = "x3_it_coldironb"; break;
              case 14: sResref = "zep_unholysw"; break;
              case 15: sResref = "zep_jian"; break;
              case 16: sResref = "zep_planetarls"; break;
              case 17: sResref = "zep_unholysw"; break;
              case 18: sResref = "zep_brokenlongs"; iArmaRota = 1; break;
              case 19: sResref = "zep_xswml_001"; break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1: sNombre = "Espada larga"; break;
              case 2: sNombre = "Espada de caballero"; break;
              case 3: sNombre = "Exc·libur"; break;
              case 4: sNombre = "Hoja de gladiador"; break;
              case 5: sNombre = "Espada de hierro"; break;
              case 6: sNombre = "Espada sagrada"; break;
          }
      }break;

      case 2: // Espadas de dos hojas
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = d2();
          if(iTirada == 1)
          {
              iTirada = Random(7)+1;
              switch(iTirada)
              {
                  case 1: sResref = "zep_xdbsc_00" + IntToString(Random(4)+1); break;
                  case 2: sResref = "zep_wetbs_001"; break;
                  case 3: sResref = "nw_wdbmsw002"; break;
                  case 4: sResref = "nw_wdbmsw00" + IntToString(Random(5)+4); break;
                  case 5: sResref = "nw_wdbmsw01" + IntToString(Random(2)); break;
                  case 6: sResref = "x0_wdbmsw00" + IntToString(Random(2)+1); break;
                  case 7: sResref = "x2_wdbmsw00" + IntToString(Random(2)+3); break;
              }
          }
          else if(iTirada == 2) sResref = "item_maugcep";

          iTirada = d6();
          switch(iTirada)
          {
              case 1: sNombre = "Espada de dos hojas"; break;
              case 2: sNombre = "Cimitarra doble"; break;
              case 3: sNombre = "Espada ceremonial b·rbara"; break;
              case 4: sNombre = "Hojas doble de gladiador"; break;
              case 5: sNombre = "Doble muerte"; break;
              case 6: sNombre = "Doble sagrado destino"; break;
          }
      }break;

      case 3: // Dagas
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = d10();
          if(iTirada <= 5)
          {
              iTirada = d6();
              switch(iTirada)
              {
                  case 1:  sResref = "x0_wswmdg00" + IntToString(Random(2)+1); break;
                  case 2:  sResref = "x2_wswmdg00" + IntToString(Random(2)+3); break;
                  case 3:  sResref = "nw_wswmdg00" + IntToString(Random(2)+8); break;
                  case 4:  sResref = "nw_wswmdg002"; break;
                  case 5:  sResref = "nw_wswdg001"; break;
                  case 6:  sResref = "zep_brokendagg"; iArmaRota = 1; break;
              }
         }
         else if(iTirada > 5 && iTirada <8) sResref = "ZEP_ASSASSINDAGG";
         else if(iTirada >= 8) sResref = "item_dagahechi";

          iTirada = Random(5)+1;
          switch(iTirada)
          {
              case 1: sNombre = "Daga de asesino"; break;
              case 2: sNombre = "Cuchillo"; break;
              case 3: sNombre = "Daga"; break;
              case 4: sNombre = "Lanza de fata"; break;
              case 5: sNombre = "PuÒal"; break;
          }
      }break;

      case 4: // Espadones
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = Random(17)+1;
          switch(iTirada)
          {
              case 1:  sResref = "nw_wswmgs01" + IntToString(Random(2)+1); break;
              case 2:  sResref = "x0_wswmgs00" + IntToString(Random(2)+1); break;
              case 3:  sResref = "x2_wswmgs00" + IntToString(Random(2)+3); break;
              case 4:  sResref = "nw_wswmgs002"; break;
              case 5:  sResref = "nw_wswmgs005"; break;
              case 6:  sResref = "nw_wswmgs009"; break;
              case 7:  sResref = "nw_wswgs001"; break;
              case 8:  sResref = "zep_xswgs_001"; break;
              case 9:  sResref = "zep_brokengreats"; iArmaRota = 1; break;
              case 10: sResref = "zep_wpngsw_001"; break;
              case 11: sResref = "zep_nodachi"; break;
              case 12: sResref = "item_espadonen"; break;
              case 13: sResref = "item_giantgsword"; break;
              case 14: sResref = "item_giantgsw002"; break;
              case 15: sResref = "item_giantgsw003"; break;
              case 16: sResref = "item_giantgsw004"; break;
              case 17: sResref = "item_giantgsw005"; break;
          }

          iTirada = d8();
          switch(iTirada)
          {
              case 1: sNombre = "EspadÛn"; break;
              case 2: sNombre = "Mandoble"; break;
              case 3: sNombre = "Claymore"; break;
              case 4: sNombre = "Hoja r˙nica"; break;
              case 5: sNombre = "La Torre"; break;
              case 6: sNombre = "Espada de reyes"; break;
              case 7: sNombre = "Espada de cristal"; break;
              case 8: sNombre = "Nodachi"; break;
          }
      }break;

      case 5: // Espadas cortas
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = Random(13)+1;
          switch(iTirada)
          {
              case 1:  sResref = "zep_wpnssw_00" + IntToString(Random(2)+1); break;
              case 2:  sResref = "x0_wswmss00" + IntToString(Random(2)+1); break;
              case 3:  sResref = "x2_wswmss00" + IntToString(Random(2)+3); break;
              case 4:  sResref = "nw_wswmss011"; break;
              case 5:  sResref = "x2_wswmss006"; break;
              case 6:  sResref = "nw_wswmss009"; break;
              case 7:  sResref = "nw_wswmss002"; break;
              case 8:  sResref = "nw_wswss001"; break;
              case 9:  sResref = "zep_wakizashi"; break;
              case 10: sResref = "zep_ninjato"; break;
              case 11: sResref = "zep_brokenshorts"; iArmaRota = 1; break;
              case 12: sResref = "zep_browniesword"; break;
              case 13: sResref = "zep_baatjamdo"; break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Garra de ladrÛn"; break;
              case 2:  sNombre = "ApuÒaladora"; break;
              case 3:  sNombre = "Espada de corta"; break;
              case 4:  sNombre = "Cuchillo jamonero"; break;
              case 5:  sNombre = "Triple filo"; break;
              case 6:  sNombre = "Defensora"; break;
          }
      }break;

      case 6: // Espadas bastardas
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = d8();
          switch(iTirada)
          {
              case 1: sResref = "x0_wswmbs00" + IntToString(Random(2)+1); break;
              case 2: sResref = "x2_wswmbs00" + IntToString(Random(4)+3); break;
              case 3: sResref = "nw_wswmbs00" + IntToString(Random(3)+3); break;
              case 4: sResref = "nw_wswmbs010"; break;
              case 5: sResref = "nw_wswmbs002"; break;
              case 6: sResref = "nw_wswbs001"; break;
              case 7: sResref = "zep_wpnbsw_001"; break;
              case 8: sResref = "zep_bastardsw"; break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Valkiria"; break;
              case 2:  sNombre = "Castigadora"; break;
              case 3:  sNombre = "Sol naciente"; break;
              case 4:  sNombre = "Espada bastarda"; break;
              case 5:  sNombre = "Espada de cristal"; break;
              case 6:  sNombre = "Guardia real"; break;
          }
      }break;

      case 7: // Cimitarras
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = Random(5)+1;
          switch(iTirada)
          {
              case 1: sResref = "nw_wswmsc01" + IntToString(Random(2)); break;
              case 2: sResref = "x0_wswmsc00" + IntToString(Random(2)+1); break;
              case 3: sResref = "x2_wswmsc00" + IntToString(Random(2)+3); break;
              case 4: sResref = "nw_wswmsc00" + IntToString(Random(5)+4); break;
              case 5: sResref = "nw_wswsc001"; break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Sable"; break;
              case 2:  sNombre = "Sable pirata"; break;
              case 3:  sNombre = "Cimitarra"; break;
              case 4:  sNombre = "Ojos de Zehir"; break;
              case 5:  sNombre = "Hoja curvada"; break;
              case 6:  sNombre = "Quitapenas"; break;
          }
      }break;

      case 8: // Alfanjes
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = d3();
          switch(iTirada)
          {
              case 1: sResref = "zep_xswfa_00" + IntToString(Random(5)+1); break;
              case 2: sResref = "zep_falchion"; break;
              case 3: sResref = "zep_planetarfal"; break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Alfanje"; break;
              case 2:  sNombre = "Alfanje pirata"; break;
              case 3:  sNombre = "Sable enorme"; break;
              case 4:  sNombre = "Sable serpentino"; break;
              case 5:  sNombre = "Alfanje de doble filo"; break;
              case 6:  sNombre = "Cimitarra ancha"; break;
          }
      }break;

      case 9: // Katanas
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = Random(7)+1;
          switch(iTirada)
          {
              case 1: sResref = "nw_wswmka01" + IntToString(Random(2)); break;
              case 2: sResref = "x0_wswmka00" + IntToString(Random(2)+1); break;
              case 3: sResref = "x2_wswmka00" + IntToString(Random(2)+3); break;
              case 4: sResref = "nw_wswmka00" + IntToString(Random(2)+6); break;
              case 5: sResref = "nw_wswka001"; break;
              case 6: sResref = "nw_wswmka004"; break;
              case 7: sResref = "x2_wswmka006"; break;
          }

          iTirada = Random(7)+1;
          switch(iTirada)
          {
              case 1:  sNombre = "Masamune"; break;
              case 2:  sNombre = "Uchigatana"; break;
              case 3:  sNombre = "Katana"; break;
              case 4:  sNombre = "Espada ninja"; break;
              case 5:  sNombre = "Apocalipsis"; break;
              case 6:  sNombre = "Kazekiri"; break;
              case 7:  sNombre = "Murasame"; break;
          }
      }break;

      case 10: // Estoques
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = d8();
          switch(iTirada)
          {
              case 1: sResref = "nw_wswmrp01" + IntToString(Random(2)); break;
              case 2: sResref = "x0_wswmrp00" + IntToString(Random(2)+1); break;
              case 3: sResref = "x2_wswmrp00" + IntToString(Random(2)+3); break;
              case 4: sResref = "nw_wswmrp00" + IntToString(Random(2)+7); break;
              case 5: sResref = "zep_armandspoint"; break;
              case 6: sResref = "zep_keenrapier"; break;
              case 7: sResref = "nw_wswrp001"; break;
              case 8: sResref = "nw_wswmrp004"; break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Estoque"; break;
              case 2:  sNombre = "Florete"; break;
              case 3:  sNombre = "Brazo del duelista"; break;
              case 4:  sNombre = "Espada ropera"; break;
              case 5:  sNombre = "Demoledora"; break;
              case 6:  sNombre = "Gladius"; break;
          }
      }break;

      case 11: // Picos
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = d4();
          switch(iTirada)
          {
              case 1: sResref = "zep_heavypick001"; break;
              case 2: sResref = "zep_heavypick"; break;
              case 3: sResref = "zep_lightpick"; break;
              case 4: sResref = "zep_lightpick001"; break;
          }

          iTirada = d4();
          switch(iTirada)
          {
              case 1:  sNombre = "Pico de minero"; break;
              case 2:  sNombre = "Pico"; break;
              case 3:  sNombre = "Picapiedra"; break;
              case 4:  sNombre = "Voluntad del svirfneblin"; break;
          }
      }break;

      case 12: // Tridentes
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = Random(4)+1;
          switch(iTirada)
          {
              case 1: sResref = "nw_wpltr00" + IntToString(Random(9)+1); break;
              case 2: sResref = "nw_wpltr010"; break;
              case 3: sResref = "item_tridentecep"; break;
              case 4: sResref = "item_tridentecep"; break;
          }

          iTirada = d4();
          switch(iTirada)
          {
              case 1:  sNombre = "Tridente del Trueno"; break;
              case 2:  sNombre = "Tridente"; break;
              case 3:  sNombre = "Ira de Umberli"; break;
              case 4:  sNombre = "Surcamares"; break;
          }
      }break;

      case 13: // Cachiporras
      {
          iTipoDeterioro = Random(2)+2;
          sResref = "ZEP_SAP";
          sNombre = "Cachiporra";
      }break;
      case 14: // NUNCHAKU
      {
          iTipoDeterioro = Random(2)+2;
          sResref = "ZEP_NUNCHAKU";
          sNombre = "Nunchaku";
      }break;
      case 15: // SAI
      {
          iTipoDeterioro = Random(2)+2;
          sResref = "ZEP_XDBSC_001";
          sNombre = "Sai";
      }break;
      case 16: //Rueda
      {
          iTipoDeterioro = Random(2)+2;
          sResref = "ZEP_WINDFIRE";
          sNombre = "Rueda del fuego y el viento";
      }break;
      case 17: // Doble-hacha
      case 18: // Hachas arrojadizas / Chakrams
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = d20();
          switch(iTirada)
          {
              case 1:  sNombre = "Hacha de mithril"; break;
              case 2:  sNombre = "Hacha de gigante"; break;
              case 3:  sNombre = "Rompetierra"; break;
              case 4:  sNombre = "Asaltante"; break;
              case 5:  sNombre = "Hacha del SeÒor Enano"; break;
              case 6:  sNombre = "Rompecr·neos"; break;
              case 7:  sNombre = "Hacha Ìgnea"; break;
              case 8:  sNombre = "Hacha vorpalina"; break;
              case 9:  sNombre = "Hacha de leÒador"; break;
              case 10: sNombre = "Furia destructora"; break;
              case 11: sNombre = "Hacha brutal"; break;
              case 12: sNombre = "Mano de Gruumsh"; break;
              case 13: sNombre = "Hacha gÈlida"; break;
              case 14: sNombre = "Centinela"; break;
              case 15: sNombre = "Hacha de Clangeddin"; break;
              case 16: sNombre = "Hacha fulminante"; break;
              case 17: sNombre = "Hacha de Velo Mortal"; break;
              case 18: sNombre = "Hacha del Tigre Rojo"; break;
              case 19: sNombre = "Demoledora"; break;
              case 20: sNombre = "Matagigantes"; break;
          }

          iTirada = Random(40)+1;
          switch(iTirada)
          {
              // Hachas ligeras
              case 1:  sResref = "nw_waxmhn00" + IntToString(Random(2)+2); break;
              case 2:  sResref = "nw_waxmhn00" + IntToString(Random(2)+5); break;
              case 3:  sResref = "nw_waxmhn00" + IntToString(Random(2)+8); break;
              case 4:  sResref = "nw_waxmhn01" + IntToString(Random(2)); break;
              case 5:  sResref = "x0_waxmhn00" + IntToString(Random(2)+1); break;
              case 6:  sResref = "x2_waxmhn00" + IntToString(Random(2)+3); break;

              // Hachas de batalla
              case 7:  sResref = "nw_waxbt001"; break;
              case 8:  sResref = "nw_waxmbt00" + IntToString(Random(4)+3); break;
              case 9:  sResref = "nw_waxmbt008"; break;
              case 10: sResref = "nw_waxmbt01" + IntToString(Random(2)); break;
              case 11: sResref = "x0_waxmbt00" + IntToString(Random(2)+1); break;

              // Hachas de guerra enana
              case 12: sResref = "x2_wdwraxe001"; break;
              case 13: sResref = "x2_wmdwraxe00" + IntToString(Random(4)+2); break;
              case 14: sResref = "x2_wmdwraxe00" + IntToString(Random(4)+6); break;
              case 15: sResref = "x2_wmdwraxe01" + IntToString(Random(2)); break;

              // Grandes hachas
              case 16: sResref = "nw_waxgr001"; break;
              case 17: sResref = "nw_waxmgr00" + IntToString(Random(5)+2); break;
              case 18: sResref = "nw_waxmgr00" + IntToString(Random(2)+8); break;
              case 19: sResref = "nw_waxmgr011"; break;
              case 20: sResref = "x0_waxmgr00" + IntToString(Random(2)+1); break;
              case 21: sResref = "x2_waxmgr00" + IntToString(Random(2)+3); break;
              case 22: sResref = "nw_waxmgr011"; break;

              // Hachas dobles
              case 23: sResref = "nw_wdbax001";  iArmaDoble = TRUE; break;
              case 24: sResref = "nw_wdbmax002"; iArmaDoble = TRUE; break;
              case 25: sResref = "nw_wdbmax00" + IntToString(Random(6)+4); iArmaDoble = TRUE; break;
              case 26: sResref = "nw_wdbmax01" + IntToString(Random(2));   iArmaDoble = TRUE; break;
              case 27: sResref = "x0_wdbmax00" + IntToString(Random(2)+1); iArmaDoble = TRUE; break;
              case 28: sResref = "x2_wdbmax00" + IntToString(Random(2)+3); iArmaDoble = TRUE; break;

              // Hachas arrojadizas / Chakram
              case 29: sResref = "zep_chakram"; sNombre = "Chakram"; iArrojadiza = TRUE; break;
              case 30: sResref = "nw_wthax001"; iArrojadiza = TRUE; break;
              case 31: sResref = "nw_wthmax00" + IntToString(Random(8)+2); iArrojadiza = TRUE; break;
              case 32: sResref = "x0_wthmax00" + IntToString(Random(2)+1); iArrojadiza = TRUE; break;
              case 33: sResref = "x2_wthmax00" + IntToString(Random(2)+3); iArrojadiza = TRUE; break;

              //Gran hacha enorme
              case 34: sResref = "item_ghachaen"; break;
              case 35: sResref = "item_giantgaxe02"; break;
              case 36: sResref = "item_giantgaxe03"; break;
              case 37: sResref = "item_giantgaxe04"; break;
              case 38: sResref = "item_giantgaxe05"; break;
              case 39: sResref = "item_giantgaxe06"; break;
              case 40: sResref = "item_ghachaen"; break;
          }
      }break;

      case 19: // Alabardas
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = Random(11)+1;
          switch(iTirada)
          {
              case 1:  sResref = "zep_wpnhlb_001"; break;
              case 2:  sResref = "zep_kwandao"; break;
              case 3:  sResref = "zep_naginata"; break;
              case 4:  sResref = "zep_pudao"; break;
              case 5:  sResref = "nw_wplhb001"; break;
              case 6:  sResref = "nw_wplmhb00" + IntToString(Random(3)+2); break;
              case 7:  sResref = "nw_wplmhb00" + IntToString(Random(4)+6); break;
              case 8:  sResref = "nw_wplmhb01" + IntToString(Random(2)); break;
              case 9:  sResref = "x0_wplmhb00" + IntToString(Random(2)+1); break;
              case 10: sResref = "x2_wplmhb00" + IntToString(Random(2)+3); break;
              case 11: sResref = "x2_it_venomhb"; break;
          }

          iTirada = d8();
          switch(iTirada)
          {
              case 1:  sNombre = "Alabarda"; break;
              case 2:  sNombre = "Aliento de DragÛn"; break;
              case 3:  sNombre = "Asoladora"; break;
              case 4:  sNombre = "Alabarda de ponzoÒa"; break;
              case 5:  sNombre = "Voluntad de Atar"; break;
              case 6:  sNombre = "Partearco"; break;
              case 7:  sNombre = "Orilla del Agua"; break;
              case 8:  sNombre = "Naginata"; break;
          }
      }break;

      case 20: // Lanzas
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = Random(18)+1;
          switch(iTirada)
          {
              case 1:  sResref = "nw_wplmss002"; break;
              case 2:  sResref = "nw_wplmss004"; break;
              case 3:  sResref = "nw_wplmss00" + IntToString(Random(3)+6); break;
              case 4:  sResref = "nw_wplmss01" + IntToString(Random(2)); break;
              case 5:  sResref = "x0_wplmss00" + IntToString(Random(2)+1); break;
              case 6:  sResref = "x2_wplmss00" + IntToString(Random(2)+3); break;
              case 7: sResref = "item_lanzaen"; break;
              case 8: sResref = "item_lanzaen"; break;
              case 9: sResref = "item_lanzaen"; break;
              case 10: sResref = "item_lanzaen"; break;
              case 11: sResref = "item_lanzaen"; break;
              case 12: sResref = "item_lanzaen"; break;
              case 13: sResref = "item_lanzacorta"; break;
              case 14: sResref = "item_lanzacorta"; break;
              case 15: sResref = "item_lanzacorta"; break;
              case 16: sResref = "item_lanzacorta"; break;
              case 17: sResref = "item_lanzacorta"; break;
              case 18: sResref = "item_lanzacorta"; break;
          }

          iTirada = Random(7)+1;
          switch(iTirada)
          {
              case 1:  sNombre = "Lanza"; break;
              case 2:  sNombre = "Lanza eÛlica"; break;
              case 3:  sNombre = "Lanza de cristal"; break;
              case 4:  sNombre = "Lanza de aerodragÛn"; break;
              case 5:  sNombre = "Lanza sagrada"; break;
              case 6:  sNombre = "Gae Bolg"; break;
              case 7:  sNombre = "Gungnir"; break;
          }
      }break;

      case 21: // Guadanyas
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = d8();
          switch(iTirada)
          {
              case 1: sResref = "crpi_reapr_scyth"; break;
              case 2: sResref = "zep_nagamaki"; break;
              case 3: sResref = "nw_wplsc001"; break;
              case 4: sResref = "nw_wplmsc00" + IntToString(Random(5)+2); break;
              case 5: sResref = "nw_wplmsc00" + IntToString(Random(2)+8); break;
              case 6: sResref = "nw_wplmsc01" + IntToString(Random(2)); break;
              case 7: sResref = "x0_wplmsc00" + IntToString(Random(2)+1); break;
              case 8: sResref = "x2_wplmsc00" + IntToString(Random(2)+3); break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "GuadaÒa brutal"; break;
              case 2:  sNombre = "Locura del campesino"; break;
              case 3:  sNombre = "La Muerte"; break;
              case 4:  sNombre = "Furia de Khauntea"; break;
              case 5:  sNombre = "Masacre"; break;
              case 6:  sNombre = "⁄ltimo filo"; break;
          }
      }break;

      case 22: // Dardos
      {
          iArrojadiza = TRUE;
          iTipoDeterioro = Random(2)+2;
          iTirada = d3();
          switch(iTirada)
          {
              case 1: sResref = "nw_wthmdt00" + IntToString(Random(8)+2); break;
              case 2: sResref = "x0_wthmdt00" + IntToString(Random(2)+1); break;
              case 3: sResref = "x2_wthmdt00" + IntToString(Random(2)+3); break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Dardo"; break;
              case 2:  sNombre = "Cornadas"; break;
              case 3:  sNombre = "Golpetazo de draco"; break;
              case 4:  sNombre = "Astillas de hierro"; break;
              case 5:  sNombre = "P˙as de mantÌcora"; break;
              case 6:  sNombre = "El ˙ltimo suspiro"; break;
          }
      }break;

      case 23: // Shuriken
      {
          iArrojadiza = TRUE;
          iTipoDeterioro = Random(2)+2;
          iTirada = d3();
          switch(iTirada)
          {
              case 1: sResref = "nw_wthmsh00" + IntToString(Random(8)+2); break;
              case 2: sResref = "x0_wthmsh00" + IntToString(Random(2)+1); break;
              case 3: sResref = "x2_wthmsh00" + IntToString(Random(2)+3); break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Shuriken"; break;
              case 2:  sNombre = "Estrella ninja"; break;
              case 3:  sNombre = "Amenaza oriental"; break;
              case 4:  sNombre = "Estrellas"; break;
              case 5:  sNombre = "Cortacuellos"; break;
              case 6:  sNombre = "Trituradoras"; break;
          }
      }break;

      case 24: // Clavas
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sResref = "x2_it_iwoodclub"; break;
              case 2:  sResref = "nw_wblmcl00" + IntToString(Random(5)+2); break;
              case 3:  sResref = "nw_wblmcl00" + IntToString(Random(2)+8); break;
              case 4:  sResref = "nw_wblmcl01" + IntToString(Random(2)); break;
              case 5:  sResref = "x0_wblmcl00" + IntToString(Random(2)+1); break;
              case 6: sResref = "x2_wblmcl00" + IntToString(Random(2)+3); break;

          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "RaspÛn"; break;
              case 2:  sNombre = "Cachiporra"; break;
              case 3:  sNombre = "Tronco de leÒoscuro"; break;
              case 4:  sNombre = "Astilla de ·rbol nodal"; break;
              case 5:  sNombre = "Sueltamamporros"; break;
              case 6:  sNombre = "RompemandÌbulas"; break;
          }
      }break;

      case 25: // Manguales ligeros
      case 26: // Manguales pesados
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = d10();
          switch(iTirada)
          {
              case 1:  sResref = "nw_wblmfl002"; break;
              case 2:  sResref = "nw_wblmfl00" + IntToString(Random(6)+4); break;
              case 3:  sResref = "nw_wblmfl01" + IntToString(Random(2)); break;
              case 4:  sResref = "x0_wblmfl00" + IntToString(Random(2)+1); break;
              case 5:  sResref = "x2_wblmfl00" + IntToString(Random(3)+3); break;
              case 6:  sResref = "nw_wblmfh00" + IntToString(Random(5)+2); break;
              case 7:  sResref = "nw_wblmfh00" + IntToString(Random(2)+8); break;
              case 8:  sResref = "nw_wblmfh01" + IntToString(Random(2)); break;
              case 9:  sResref = "x0_wblmfh00" + IntToString(Random(2)+1); break;
              case 10: sResref = "x2_wblmfh00" + IntToString(Random(3)+3); break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Mangual de aceroscuro"; break;
              case 2:  sNombre = "La Horda"; break;
              case 3:  sNombre = "Furia demoledora"; break;
              case 4:  sNombre = "AplastaejÈrcitos"; break;
              case 5:  sNombre = "Descanso seguro"; break;
              case 6:  sNombre = "Pulverizador"; break;
          }
      }break;

      case 27: // MAZOS
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = Random(2)+1;
          switch(iTirada)
          {
              case 1:  sResref = "ZEP_XBLMA_001"; break;
              case 2:  sResref = "item_mazoen"; break;
          }

          iTirada = d8();
          switch(iTirada)
          {
              case 1:  sNombre = "Rompecr·neos"; break;
              case 2:  sNombre = "Avalancha"; break;
              case 3:  sNombre = "Mazo infernal"; break;
              case 4:  sNombre = "Quebrahuesos"; break;
              case 5:  sNombre = "Gravilla"; break;
              case 6:  sNombre = "Machacamuros"; break;
              case 7:  sNombre = "Martillo de hierro"; break;
              case 8:  sNombre = "Lluvia brutal"; break;
          }
      }break;
      case 28: // Martillos de guerra
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = Random(13)+1;
          switch(iTirada)
          {
              case 1:  sResref = "nw_wblmhw009"; break;
              case 2:  sResref = "zep_azerhammer"; break;
              case 3:  sResref = "nw_wblmhl00" + IntToString(Random(5)+2); break;
              case 4:  sResref = "nw_wblmhl00" + IntToString(Random(2)+8); break;
              case 5:  sResref = "nw_wblmhl01" + IntToString(Random(2)); break;
              case 6:  sResref = "x0_wblmhl00" + IntToString(Random(2)+1); break;
              case 7:  sResref = "x2_wblmhl00" + IntToString(Random(4)+3); break;
              case 8:  sResref = "nw_wblmhw00" + IntToString(Random(5)+2); break;
              case 9:  sResref = "nw_wblmhw01" + IntToString(Random(3)); break;
              case 10: sResref = "x0_wblmhw00" + IntToString(Random(2)+1); break;
              case 11: sResref = "x2_wblmhw00" + IntToString(Random(3)+3); break;
              case 12: sResref = "zep_xblma_00" + IntToString(Random(4)+1); break;
          }

          iTirada = d8();
          switch(iTirada)
          {
              case 1:  sNombre = "Rompecr·neos"; break;
              case 2:  sNombre = "Avalancha"; break;
              case 3:  sNombre = "Mazo infernal"; break;
              case 4:  sNombre = "Quebrahuesos"; break;
              case 5:  sNombre = "Gravilla"; break;
              case 6:  sNombre = "Machacamuros"; break;
              case 7:  sNombre = "Martillo de hierro"; break;
              case 8:  sNombre = "Lluvia brutal"; break;
          }
      }break;

      case 29: // Mazas ligeras y pesadas
      case 30: // Mazas terribles
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = Random(11)+1;
          switch(iTirada)
          {
              case 1:  sResref = "x1_wblmml001"; break;
              case 2:  sResref = "nw_wblmml00" + IntToString(Random(6)+4); break;
              case 3:  sResref = "nw_wblmml01" + IntToString(Random(3)); break;
              case 4:  sResref = "x0_wblmml00" + IntToString(Random(2)+1); break;
              case 5:  sResref = "x2_wblmml00" + IntToString(Random(3)+3); break;
              case 6:  sResref = "zep_xblmh_00" + IntToString(Random(5)+1); break;
              case 7:  sResref = "nw_wdbmma00" + IntToString(Random(5)+2); iArmaDoble = TRUE; break;
              case 8:  sResref = "nw_wdbmma00" + IntToString(Random(2)+8); iArmaDoble = TRUE; break;
              case 9:  sResref = "nw_wdbmma01" + IntToString(Random(2));   iArmaDoble = TRUE; break;
              case 10: sResref = "x0_wdbmma00" + IntToString(Random(2)+1); iArmaDoble = TRUE; break;
              case 11: sResref = "x2_wdbmma00" + IntToString(Random(3)+3); iArmaDoble = TRUE; break;
              case 12:  sResref = "ZEP_XBLMH_001"; break;
              case 13:  sResref = "ZEP_XBLMH_001"; break;
              case 14:  sResref = "ZEP_XBLMH_001"; break;
              case 15:  sResref = "ZEP_XBLMH_001"; break;
          }

          iTirada = d10();
          switch(iTirada)
          {
              case 1:  sNombre = "⁄nico golpe"; break;
              case 2:  sNombre = "Maza de hierro frÌo"; break;
              case 3:  sNombre = "Castigo de Tyr"; break;
              case 4:  sNombre = "Embestida"; break;
              case 5:  sNombre = "Mazazo tremendo"; break;
              case 6:  sNombre = "Dolor de Ilmater"; break;
              case 7:  sNombre = "Barricada"; break;
              case 8:  sNombre = "Torbellino"; break;
              case 9:  sNombre = "La torre"; break;
              case 10: sNombre = "Defensora"; break;
          }
      }break;

      case 31: // Mazas de armas
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = Random(5)+1;
          switch(iTirada)
          {
              case 1:  sResref = "nw_wblmms00" + IntToString(Random(3)+2); break;
              case 2:  sResref = "nw_wblmms00" + IntToString(Random(4)+6); break;
              case 3:  sResref = "nw_wblmms01" + IntToString(Random(2)); break;
              case 4:  sResref = "x0_wblmms00" + IntToString(Random(2)+1); break;
              case 5:  sResref = "x2_wblmms00" + IntToString(Random(3)+3); break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Bola de pinchos"; break;
              case 2:  sNombre = "Maza de armas"; break;
              case 3:  sNombre = "Agrietacimientos"; break;
              case 4:  sNombre = "Destructor de escudos"; break;
              case 5:  sNombre = "Esfera de metal"; break;
              case 6:  sNombre = "Defensa rotatoria"; break;
          }
      }break;

      case 32: // Bastones
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sResref = "x2_it_iwoodstaff"; break;
              case 2:  sResref = "nw_wdbmqs00" + IntToString(Random(8)+2); break;
              case 3:  sResref = "x0_wdbmqs00" + IntToString(Random(2)+1); break;
              case 4:  sResref = "x2_wdbmqs00" + IntToString(Random(5)+3); break;
              case 5:  sResref = "x2_it_iwoodstaff"; break;
              case 6:  sResref = "x2_it_iwoodstaff"; break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Vara mortal"; break;
              case 2:  sNombre = "Corteza forestal"; break;
              case 3:  sNombre = "BastÛn equilibrado"; break;
              case 4:  sNombre = "B·culo de huesos"; break;
              case 5:  sNombre = "Rompeespaldas"; break;
              case 6:  sNombre = "Cayado de anciano"; break;
          }
      }break;

      case 33: // Hoces
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sResref = "nw_wspmsc00" + IntToString(Random(5)+2); break;
              case 2:  sResref = "nw_wspmsc00" + IntToString(Random(5)+2); break;
              case 3:  sResref = "nw_wspmsc00" + IntToString(Random(2)+8); break;
              case 4:  sResref = "nw_wspmsc01" + IntToString(Random(2)); break;
              case 5:  sResref = "x0_wspmsc00" + IntToString(Random(2)+1); break;
              case 6:  sResref = "x2_wspmsc00" + IntToString(Random(3)+3); break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Espiga dorada"; break;
              case 2:  sNombre = "Segador vital"; break;
              case 3:  sNombre = "Hoz de leÒoscuro"; break;
              case 4:  sNombre = "Hocico de Oso"; break;
              case 5:  sNombre = "Malas hierbas"; break;
              case 6:  sNombre = "Garra de lince"; break;
          }
      }break;

      case 34: // Kamas
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = d3();
          switch(iTirada)
          {
              case 1:  sResref = "nw_wspmka00" + IntToString(Random(8)+2); break;
              case 2:  sResref = "x0_wspmka00" + IntToString(Random(2)+1); break;
              case 3:  sResref = "x2_wspmka00" + IntToString(Random(3)+3); break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Kama"; break;
              case 2:  sNombre = "Segadora"; break;
              case 3:  sNombre = "Descarga Ki"; break;
              case 4:  sNombre = "Filo oriental"; break;
              case 5:  sNombre = "R·faga de golpes"; break;
              case 6:  sNombre = "KamÛn"; break;
          }
      }break;

      case 35: // Kukirs y Katares
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = Random(8)+1;
          switch(iTirada)
          {
              case 1:  sResref = "nw_wspmku003"; break;
              case 2:  sResref = "x2_wspmku005"; break;
              case 3:  sResref = "nw_wspmku00" + IntToString(Random(3)+5); break;
              case 4:  sResref = "x2_kuk_storm"; break;
              case 5:  sResref = "nw_wspmku003"; break;
              case 6:  sResref = "zep_katar"; break;
              case 7:  sResref = "zep_katar"; break;
              case 8:  sResref = "zep_katar"; break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "PuÒal"; break;
              case 2:  sNombre = "Filo curvado"; break;
              case 3:  sNombre = "PequeÒa amenaza"; break;
              case 4:  sNombre = "Sable pirata pequeÒo"; break;
              case 5:  sNombre = "PezuÒa de felino"; break;
              case 6:  sNombre = "Velocidad"; break;
          }
      }break;

      case 36: // Latigos
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = d4();
          switch(iTirada)
          {
              case 1:  sResref = "zep_kusari"; break;
              case 2:  sResref = "x2_whip_black"; break;
              case 3:  sResref = "zep_manriki"; break;
              case 4:  sResref = "x2_whip_black"; break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "L·tigo"; break;
              case 2:  sNombre = "L·tigo devastador"; break;
              case 3:  sNombre = "Azote de infieles"; break;
              case 4:  sNombre = "Flagelo de Loviatar"; break;
              case 5:  sNombre = "Cuerda demoniaca"; break;
              case 6:  sNombre = "Las Siete Colas"; break;
          }
      }break;

      case 37: // Ballestas
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = d6();
          switch(iTirada)
          {
              case 1: sResref = "nw_wbwmxl00" + IntToString(Random(8)+2); break;
              case 2: sResref = "x0_wbwmxl00" + IntToString(Random(2)+1); break;
              case 3: sResref = "x2_wbwmxl00" + IntToString(Random(3)+3); break;
              case 4: sResref = "nw_wbwmxh00" + IntToString(Random(8)+2); break;
              case 5: sResref = "x0_wbwmxh00" + IntToString(Random(2)+1); break;
              case 6: sResref = "x2_wbwmxh00" + IntToString(Random(3)+3);break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Cuerdas de acero"; break;
              case 2:  sNombre = "Ballesta de batalla"; break;
              case 3:  sNombre = "Lanza-proyectiles"; break;
              case 4:  sNombre = "Ballesta de la guardia de Amn"; break;
              case 5:  sNombre = "Honor del Imperio"; break;
              case 6:  sNombre = "Tiradora de la Espesura"; break;
          }
      }break;

      case 38: // Arcos
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = Random(11)+1;
          switch(iTirada)
          {
              case 1: sResref = "zep_wolbw_001"; break;
              case 2: sResref = "zep_daikyu"; break;
              case 3: sResref = "x2_wbwmln010"; break;
              case 4: sResref = "nw_wbwmln00" + IntToString(Random(8)+2); break;
              case 5: sResref = "nw_wbwmln01" + IntToString(Random(3)); break;
              case 6: sResref = "x0_wbwmln00" + IntToString(Random(4)+1); break;
              case 7: sResref = "x2_wbwmln00" + IntToString(Random(5)+5); break;
              case 8: sResref = "nw_wbwmsh00" + IntToString(Random(8)+2); break;
              case 9: sResref = "nw_wbwmsh01" + IntToString(Random(3)); break;
              case 10: sResref = "x0_wbwmsh00" + IntToString(Random(4)+1); break;
              case 11: sResref = "x2_wbwmsh00" + IntToString(Random(5)+5); break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Arco de asedio"; break;
              case 2:  sNombre = "Arco Èlfico de batalla"; break;
              case 3:  sNombre = "UniÛn de la naturaleza"; break;
              case 4:  sNombre = "Cuerda sangrienta"; break;
              case 5:  sNombre = "Arco de guerra de mediano"; break;
              case 6:  sNombre = "Ojo avizor"; break;
          }
      }break;

      case 39: // Hondas
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = d4();
          switch(iTirada)
          {
              case 1: sResref = "nw_wbwmsl010"; break;
              case 2: sResref = "nw_wbwmsl00" + IntToString(Random(6)+3); break;
              case 3: sResref = "x0_wbwmsl00" + IntToString(Random(2)+1); break;
              case 4: sResref = "x2_wbwmsl00" + IntToString(Random(3)+3); break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Honda buscadora"; break;
              case 2:  sNombre = "Lanzapiedras"; break;
              case 3:  sNombre = "Ira del mediano"; break;
              case 4:  sNombre = "CorazÛn de ArvorÌn"; break;
              case 5:  sNombre = "Cuero tensado"; break;
              case 6:  sNombre = "PersecuciÛn nÛmada"; break;
          }
      }break;

      case 40: // Virotes
      {
          iTipoDeterioro = 10;
          iMunicion = TRUE;
          iTirada = d4();
          switch(iTirada)
          {
              case 1: sResref = "nw_wammbo010"; break;
              case 2: sResref = "x2_wammbo001"; break;
              case 3: sResref = "nw_wammbo00" + IntToString(Random(9)+1); break;
              case 4: sResref = "x2_wammbo01" + IntToString(Random(2)+1); break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Virotes"; break;
              case 2:  sNombre = "Lanzas aÈreas"; break;
              case 3:  sNombre = "Alfileres mortales"; break;
              case 4:  sNombre = "Aguijones"; break;
              case 5:  sNombre = "Asesinas aÈreas"; break;
              case 6:  sNombre = "GorriÛn sangriento"; break;
          }
      }break;

      case 41: // Flechas
      {
          iTipoDeterioro = 10;
          iMunicion = TRUE;
          iTirada = d4();
          switch(iTirada)
          {
              case 1: sResref = "x2_wammar001"; break;
              case 2: sResref = "nw_wammar00" + IntToString(Random(9)+1); break;
              case 3: sResref = "nw_wammar01" + IntToString(Random(2)); break;
              case 4: sResref = "x2_wammar01" + IntToString(Random(2)+2); break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Flechas"; break;
              case 2:  sNombre = "Flechas de hierro"; break;
              case 3:  sNombre = "Cortadoras del viento"; break;
              case 4:  sNombre = "Ojos Èlficos"; break;
              case 5:  sNombre = "Cuernos de pegaso"; break;
              case 6:  sNombre = "Buscadoras sangrientas"; break;
          }
      }break;

      case 42: // Balas
      {
          iTipoDeterioro = 10;
          iMunicion = TRUE;
          iTirada = d4();
          switch(iTirada)
          {
              case 1: sResref = "nw_wammbu010"; break;
              case 2: sResref = "x2_wammbu009"; break;
              case 3: sResref = "x2_wammbu010"; break;
              case 4: sResref = "nw_wammbu00" + IntToString(Random(9)+1); break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Balas"; break;
              case 2:  sNombre = "Balas pesadas"; break;
              case 3:  sNombre = "Rocas afiladas"; break;
              case 4:  sNombre = "Piedras gruesas"; break;
              case 5:  sNombre = "Manos medianas"; break;
              case 6:  sNombre = "Ofensiva de Gond"; break;
          }
      }break;

      case 43: // Bastones magicos
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = Random(14)+1;
          switch(iTirada)
          {
              case 1: sResref = "nw_wmgst00" + IntToString(Random(5)+2); break;
              case 2: sResref = "nw_it_novel008"; break;
              case 3: sResref = "x2_wmgst001"; break;
              case 4: sResref = "x0_cheatstick"; break;
              case 5: sResref = "zep_dragonclawf"; break;
              case 6: sResref = "zep_dragonclawm"; break;
              case 7: sResref = "zep_druidstf"; break;
              case 8: sResref = "zep_druidstm"; break;
              case 9: sResref = "zep_gnarledstaff"; break;
              case 10: sResref = "quarterstaff1"; break;
              case 11: sResref = "bastondelordmimo"; break;
              case 12: sResref = "item_dagahechi"; break;
              case 13: sResref = "item_dagahechi"; break;
              case 14: sResref = "item_dagahechi"; break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "BastÛn de control"; break;
              case 2:  sNombre = "Canalizador de energÌa"; break;
              case 3:  sNombre = "Ira de la naturaleza"; break;
              case 4:  sNombre = "Castigo divino"; break;
              case 5:  sNombre = "La mano divina del Dios"; break;
              case 6:  sNombre = "Cayado de huesos podridos"; break;
          }
      }break;

      case 44: // Varitas
      {
          iTipoDeterioro = 5;
          iTirada = Random(9)+1;
          switch(iTirada)
          {
              case 1: sResref = "nw_wmgwn00" + IntToString(Random(8)+2); break;
              case 2: sResref = "nw_wmgwn01" + IntToString(Random(4)); break;
              case 3: sResref = "varitaderociada"; break;
              case 4: sResref = "varitadeproye3_1"; break;
              case 5: sResref = "drow_proy_m"; break;
              case 6: sResref = "varitacurativa" + IntToString(Random(4)+1); break;
              case 7: sResref = "varitadecontag"; break;
              case 8: sResref = "varitadeidenti"; break;
              case 9: sResref = "varitamanosard"; break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Varita conjuradora"; break;
              case 2:  sNombre = "Varita aplastante"; break;
              case 3:  sNombre = "Varita astral"; break;
              case 4:  sNombre = "Varita tenaz"; break;
              case 5:  sNombre = "Varita psÌquica"; break;
              case 6:  sNombre = "Varita tronante"; break;
          }
      }break;

      case 45: // Cetros
      {
          iTipoDeterioro = 5;
          iTirada = Random(7)+1;
          switch(iTirada)
          {
              case 1: sResref = "nw_wmgrd002"; break;
              case 2: sResref = "x2_it_wmgrd001"; break;
              case 3: sResref = "x0_wmgmrd007"; break;
              case 4: sResref = "nw_wmgmrd00" + IntToString(Random(5)+2); break;
              case 5: sResref = "cetroaracnido"; break;
              case 6: sResref = "cs_cetronudill"; break;
              case 7: sResref = "dondelloth"; break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Cetro de control mental"; break;
              case 2:  sNombre = "BastÛn de mando"; break;
              case 3:  sNombre = "Canalizador de conjuros"; break;
              case 4:  sNombre = "Cetro demonÌaco"; break;
              case 5:  sNombre = "Vara de hueso"; break;
              case 6:  sNombre = "Cetro de supremacÌa"; break;
          }
      }break;

      case 46: // Escudos pequenyos
      {
          iTipoDeterioro = 6;
          iTirada = Random(14)+1;
          switch(iTirada)
          {
              case 1: sResref = "zep_buckler"; break;
              case 2: sResref = "zep_sshldem_001"; break;
              case 3: sResref = "zep_sshldsn_001"; break;
              case 4: sResref = "x2_smchaosshield"; break;
              case 5: sResref = "x2_it_ironwshlds"; break;
              case 6: sResref = "nw_ashmsw00" + IntToString(Random(8)+2); break;
              case 7: sResref = "nw_ashmsw01" + IntToString(Random(2)); break;
              case 8: sResref = "x0_ashmsw00" + IntToString(Random(2)+1); break;
              case 9: sResref = "x2_ashmsw00" + IntToString(Random(2)+3); break;
              case 10: sResref = "e009"; break;
              case 11: sResref = "escudopequeod"; break;
              case 12: sResref = "hen_esc_grant"; break;
              case 13: sResref = "vgz_escudotrasgo"; break;
              case 14: sResref = "e014"; break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Broquel"; break;
              case 2:  sNombre = "Escudete"; break;
              case 3:  sNombre = "Adarga"; break;
              case 4:  sNombre = "Rodela"; break;
              case 5:  sNombre = "Defensa del asesino"; break;
              case 6:  sNombre = "Guardacabeza"; break;
          }
      }break;

      case 47: // Escudos grandes
      {
          iTipoDeterioro = 6;
          iTirada = Random(19)+1;
          switch(iTirada)
          {
              case 1: sResref = "zep_azershield"; break;
              case 2: sResref = "zep_lshldek_001"; break;
              case 3: sResref = "x2_it_iwoodshldl"; break;
              case 4: sResref = "nw_ashmlw00" + IntToString(Random(8)+2); break;
              case 5: sResref = "x0_ashmlw00" + IntToString(Random(3)+1); break;
              case 6: sResref = "x2_ashmlw00" + IntToString(Random(4)+3); break;
              case 7: sResref = "x2_adrowshl00" + IntToString(Random(3)+1); break;
              case 8: sResref = "centinela4"; break;
              case 9: sResref = "escudodearmon"; break;
              case 10: sResref = "esm_escudo_mazm"; break;
              case 11: sResref = "escudodemithir"; break;
              case 12: sResref = "uri_soldadoamn"; break;
              case 13: sResref = "escudodeunbrion"; break;
              case 14: sResref = "escudodelperdi"; break;
              case 15: sResref = "escudograndede"; break;
              case 16: sResref = "escudohojanegra"; break;
              case 17: sResref = "escudozhentarim"; break;
              case 18: sResref = "graciaancestral"; break;
              case 19: sResref = "conv_escesq"; break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Escudo de madera"; break;
              case 2:  sNombre = "Protector"; break;
              case 3:  sNombre = "Escudo reforzado"; break;
              case 4:  sNombre = "Escudo de hierro"; break;
              case 5:  sNombre = "Escudo de recluta"; break;
              case 6:  sNombre = "Gloria de Amn"; break;
          }
      }break;

      case 48: // Escudos paveses
      {
          iTipoDeterioro = 6;
          iTirada = Random(16)+1;
          switch(iTirada)
          {
              case 1: sResref = "zep_dirganswall"; break;
              case 2: sResref = "zep_tshldwl_001"; break;
              case 3: sResref = "x2_it_ironwshldt"; break;
              case 4: sResref = "nw_ashmto00" + IntToString(Random(8)+2); break;
              case 5: sResref = "nw_ashmto01" + IntToString(Random(2)); break;
              case 6: sResref = "x0_ashmto00" + IntToString(Random(2)+1); break;
              case 7: sResref = "x2_ashmto00" + IntToString(Random(3)+3); break;
              case 8: sResref = "x3_it_pdshield"; break;
              case 9: sResref = "escudodrow"; break;
              case 10: sResref = "escudopavsdemit"; break;
              case 11: sResref = "siervoperdidaesc"; break;
              case 12: sResref = "escudopavsde"; break;
              case 13: sResref = "escudodelator"; break;
              case 14: sResref = "escudodeescama"; break;
              case 15: sResref = "item008"; break;
              case 16: sResref = "escudofortaleza"; break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "CenturiÛn"; break;
              case 2:  sNombre = "Defensor"; break;
              case 3:  sNombre = "Deflector"; break;
              case 4:  sNombre = "Muralla impenetrable"; break;
              case 5:  sNombre = "Escudo sagrado"; break;
              case 6:  sNombre = "⁄ltima defensa"; break;
          }
      }break;

      case 49: // Amuletos
      {
          iTipoDeterioro = 7;
          iTirada = Random(15)+1;
          switch(iTirada)
          {
              case 1:  sResref = "nw_it_mneck00" + IntToString(Random(2)+1); break;
              case 2:  sResref = "nw_it_mneck004"; break;
              case 3:  sResref = "nw_it_mneck00" + IntToString(Random(2)+6); break;
              case 4:  sResref = "nw_it_mneck024"; break;
              case 5:  sResref = "nw_it_mneck030"; break;
              case 6:  sResref = "nw_it_mneck035"; break;
              case 7:  sResref = "x0_it_mneck004"; break;
              case 8:  sResref = "x2_it_mneck001"; break;
              case 9:  sResref = "asy_amuletodrago"; break;
              case 10: sResref = "amuletodebolas1"; break;
              case 11: sResref = "vgz_amutemplo"; break;
              case 12: sResref = "amuletomgicodkal"; break;
              case 13: sResref = "amuletodeinflume"; break;
              case 14: sResref = "collarobsidiana"; break;
              case 15: sResref = "brochedelacapabr"; break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Amuleto"; break;
              case 2:  sNombre = "Cadena enjoyada"; break;
              case 3:  sNombre = "Talism·n"; break;
              case 4:  sNombre = "Collar mÌstico"; break;
              case 5:  sNombre = "Fetiche cham·nico"; break;
              case 6:  sNombre = "Cordel de huesos"; break;
          }
      }break;

      case 50: // Anillos
      {
          iTipoDeterioro = 8;
          iTirada = Random(19)+1;
          switch(iTirada)
          {
              case 1:  sResref = "nw_it_mring006"; break;
              case 2:  sResref = "nw_it_mring024"; break;
              case 3:  sResref = "nw_it_mring001"; break;
              case 4:  sResref = "nw_it_mring031"; break;
              case 5:  sResref = "nw_it_mring023"; break;
              case 6:  sResref = "x0_it_mring001"; break;
              case 7:  sResref = "nw_it_mring005"; break;
              case 8:  sResref = "x2_nash_ring"; break;
              case 9:  sResref = "x2_it_mring009"; break;
              case 10: sResref = "nw_it_novel001"; break;
              case 11: sResref = "anillodecusto002"; break;
              case 12: sResref = "anillodivinoma"; break;
              case 13: sResref = "smbolosagradotal"; break;
              case 14: sResref = "smbolosagradohel"; break;
              case 15: sResref = "anillodelasesipi"; break;
              case 16: sResref = "anillodecristal"; break;
              case 17: sResref = "anillodeacuida"; break;
              case 18: sResref = "anilloantivene"; break;
              case 19: sResref = "dedosagiles"; break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Anillo"; break;
              case 2:  sNombre = "Aro perfecto"; break;
              case 3:  sNombre = "Arete pequeÒo"; break;
              case 4:  sNombre = "Sortija divina"; break;
              case 5:  sNombre = "Argolla de hueso"; break;
              case 6:  sNombre = "CÌrculo cham·nico"; break;
          }
      }break;

      case 51: // Botas
      {
          iTipoDeterioro = 9;
          iTirada = d10();
          switch(iTirada)
          {
              case 1:  sResref = "nw_it_mboots015"; break;
              case 2:  sResref = "nw_it_mboots010"; break;
              case 3:  sResref = "nw_it_mboots018"; break;
              case 4:  sResref = "x0_it_mboots001"; break;
              case 5:  sResref = "x1_it_mboots001"; break;
              case 6:  sResref = "nw_it_mboots00" + IntToString(Random(3)+1); break;
              case 7:  sResref = "saltarinas"; break;
              case 8:  sResref = "vgz_botaskossut"; break;
              case 9:  sResref = "_botasdelabuele2"; break;
              case 10: sResref = "pasofranco"; break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Botas"; break;
              case 2:  sNombre = "Gracia felina"; break;
              case 3:  sNombre = "Puntillas"; break;
              case 4:  sNombre = "Paso ligero"; break;
              case 5:  sNombre = "Sin rastro"; break;
              case 6:  sNombre = "Zapatos de cuero"; break;
          }
      }break;

      case 52: // Brazales
      {
          iTipoDeterioro = 4;
          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sResref = "x0_it_mbracer001"; break;
              case 2:  sResref = "nw_it_mbracer00" + IntToString(Random(2)+1); break;
              case 3:  sResref = "bracersofk"; break;
              case 4:  sResref = "brazalesmalditos"; break;
              case 5:  sResref = "dreadbond"; break;
              case 6:  sResref = "magusguard"; break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Pulseras de la suerte"; break;
              case 2:  sNombre = "Brazaletes"; break;
              case 3:  sNombre = "Banda de M·scara"; break;
              case 4:  sNombre = "Bracil de la fe"; break;
              case 5:  sNombre = "Cinta oscura"; break;
              case 6:  sNombre = "Escudo de mano"; break;
          }
      }break;

      case 53: // Capas
      {
          iTipoDeterioro = 4;
          iTirada = d8();
          switch(iTirada)
          {
              case 1:  sResref = "zep_cloak"; break;
              case 2:  sResref = "zep_cloak001"; break;
              case 3:  sResref = "zep_cloak00" + IntToString(Random(7)+3); break;
              case 4:  sResref = "nw_maarcl0" + IntToString(Random(4)+88); break;
              case 5:  sResref = "nw_maarcl09" + IntToString(Random(4)+2); break;
              case 6:  sResref = "x0_maarcl02" + IntToString(Random(5)+5); break;
              case 7:  sResref = "nw_maarcl10" + IntToString(Random(3)+4); break;
              case 8:  sResref = "nw_maarcl09" + IntToString(Random(4)+6); break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Capa de tela"; break;
              case 2:  sNombre = "Manto de cuero"; break;
              case 3:  sNombre = "Capa reforzada"; break;
              case 4:  sNombre = "Toga de protecciÛn"; break;
              case 5:  sNombre = "Vestimentas de paladÌn"; break;
              case 6:  sNombre = "Manto del bufÛn"; break;
          }
      }break;

      case 54: // Cinturones
      {
          iTipoDeterioro = 8;
          iTirada = Random(40)+1;

          if(iTirada <= 30) sResref = "loot_cintoesc" + IntToString(Random(4)+1);
          else if(iTirada == 31) sResref = "nw_it_mbelt010";
          else if(iTirada == 32) sResref = "nw_it_mbelt018";
          else if(iTirada == 33) sResref = "x0_it_mbelt002";
          else if(iTirada == 34) sResref = "x2_it_mbelt002";
          else if(iTirada == 35) sResref = "nw_it_mbelt00" + IntToString(Random(4)+3);
          else if(iTirada == 36) sResref = "cintodeurnst";
          else if(iTirada == 37) sResref = "cinturndefuertma";
          else if(iTirada == 38) sResref = "cinturndehechice";
          else if(iTirada == 39) sResref = "destructordelasc";
          else                   sResref = "fajnbendito";

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "CinturÛn"; break;
              case 2:  sNombre = "CinturÛn grueso"; break;
              case 3:  sNombre = "Cinto b·rbaro"; break;
              case 4:  sNombre = "TahalÌ protector"; break;
              case 5:  sNombre = "FajÌn deflector"; break;
              case 6:  sNombre = "Abrazadera de cuero"; break;
          }
      }break;

      case 55: // Armadura (Ropas)
      {
          iTipoDeterioro = 4;
          iTirada = d10();
          switch(iTirada)
          {
              case 1:  sResref = "x2_cus_robe1"; break;
              case 2:  sResref = "nw_mcloth017"; break;
              case 3:  sResref = "nw_mcloth015"; break;
              case 4:  sResref = "x2_it_pmrobe"; break;
              case 5:  sResref = "x3_it_robeeyes"; break;
              case 6:  sResref = "x2_cus_lastwords"; break;
              case 7:  sResref = "kimonodecombat"; break;
              case 8:  sResref = "nw_mcloth009"; break;
              case 9:  sResref = "nw_mcloth006"; break;
              case 10: sResref = "nw_cloth020"; break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Ropas"; break;
              case 2:  sNombre = "T˙nica cÛmoda"; break;
              case 3:  sNombre = "Atuendos"; break;
              case 4:  sNombre = "Vestimentas arcanas"; break;
              case 5:  sNombre = "Ajuar felino"; break;
              case 6:  sNombre = "Ropaje maldito"; break;
          }
      }break;

      case 56: // Armadura (Ligera)
      {
          iTipoDeterioro = 1;
          iTirada = Random(17)+1;
          switch(iTirada)
          {
              case 1:  sResref = "nw_maarcl00" + IntToString(Random(2)+1); break;
              case 2:  sResref = "nw_maarcl007"; break;
              case 3:  sResref = "nw_maarcl04" + IntToString(Random(4)+3); break;
              case 4:  sResref = "nw_maarcl067"; break;
              case 5:  sResref = "nw_maarcl07" + IntToString(Random(2)+1); break;
              case 6:  sResref = "nw_maarcl075"; break;
              case 7:  sResref = "nw_maarcl079"; break;
              case 8:  sResref = "nw_maarcl08" + IntToString(Random(2)+3); break;
              case 9:  sResref = "nw_maarcl087"; break;
              case 10: sResref = "x0_maarcl00" + IntToString(Random(6)+1); break;
              case 11: sResref = "x0_maarcl009"; break;
              case 12: sResref = "x2_maarcl02" + IntToString(Random(5)+5); break;
              case 13: sResref = "x2_maarcl03" + IntToString(Random(2)+3); break;
              case 14: sResref = "x2_cus_bindingso"; break;
              case 15: sResref = "x2_cus_fletchers"; break;
              case 16: sResref = "zep_barbarianfur"; break;
              case 17: sResref = "zep_studdedleath"; break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Armadura de las sombras"; break;
              case 2:  sNombre = "Armadura Èlfica"; break;
              case 3:  sNombre = "Cueros de ladrÛn"; break;
              case 4:  sNombre = "Piel de oso"; break;
              case 5:  sNombre = "Vestimenta de b·rbaro"; break;
              case 6:  sNombre = "Equilibrio de la naturaleza"; break;
          }
      }break;

      case 57: // Armadura (Intermedia)
      {
          iTipoDeterioro = 1;
          iTirada = Random(23)+1;
          switch(iTirada)
          {
              case 1:  sResref = "nw_maarcl035"; break;
              case 2:  sResref = "nw_maarcl04" + IntToString(Random(3)+7); break;
              case 3:  sResref = "nw_maarcl06" + IntToString(Random(2)+5); break;
              case 4:  sResref = "nw_maarcl070"; break;
              case 5:  sResref = "nw_maarcl073"; break;
              case 6:  sResref = "nw_maarcl07" + IntToString(Random(2)+7); break;
              case 7:  sResref = "nw_maarcl082"; break;
              case 8:  sResref = "nw_maarcl085"; break;
              case 9:  sResref = "x0_maarcl00" + IntToString(Random(2)+7); break;
              case 10: sResref = "x0_maarcl01" + IntToString(Random(4)+3); break;
              case 11: sResref = "x2_maarcl03" + IntToString(Random(2)+1); break;
              case 12: sResref = "x2_maarcl03" + IntToString(Random(4)+5); break;
              case 13: sResref = "x2_maarcl050"; break;
              case 14: sResref = "x2_mdrowar020"; break;
              case 15: sResref = "x2_mduerar006"; break;
              case 16: sResref = "x2_it_adachain"; break;
              case 17: sResref = "x2_armor_001"; break;
              case 18: sResref = "zep_chainbikini"; break;
              case 19: sResref = "zep_aecm_001"; break;
              case 20: sResref = "zep_chain"; break;
              case 21: sResref = "zep_druidarmor"; break;
              case 22: sResref = "zep_lamellar"; break;
              case 23: sResref = "zep_tieflingchn"; break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Coraza Èlfica"; break;
              case 2:  sNombre = "Cota de escamas sangrienta"; break;
              case 3:  sNombre = "Cota de mallas de mithril"; break;
              case 4:  sNombre = "Armadura de dragÛn"; break;
              case 5:  sNombre = "Voluntad divina"; break;
              case 6:  sNombre = "Cota fÈrrea"; break;
          }
      }break;

      case 58: // Armadura (Pesada)
      {
          iTipoDeterioro = 1;
          iTirada = Random(26)+1;
          switch(iTirada)
          {
              case 1:  sResref = "nw_maarcl022"; break;
              case 2:  sResref = "nw_maarcl025"; break;
              case 3:  sResref = "nw_maarcl02" + IntToString(Random(2)+7); break;
              case 4:  sResref = "nw_maarcl05" + IntToString(Random(4)); break;
              case 5:  sResref = "nw_maarcl062"; break;
              case 6:  sResref = "nw_maarcl064"; break;
              case 7:  sResref = "nw_maarcl06" + IntToString(Random(2)+8); break;
              case 8:  sResref = "nw_maarcl074"; break;
              case 9:  sResref = "nw_maarcl076"; break;
              case 10: sResref = "nw_maarcl08" + IntToString(Random(2)); break;
              case 11: sResref = "nw_maarcl086"; break;
              case 12: sResref = "x0_maarcl01" + IntToString(Random(2)+7); break;
              case 13: sResref = "x0_maarcl02" + IntToString(Random(4)+1); break;
              case 14: sResref = "x2_mdrowar031"; break;
              case 15: sResref = "x2_mdrowar040"; break;
              case 16: sResref = "x2_mduerar002"; break;
              case 17: sResref = "x2_maarcl04" + IntToString(Random(8)+1); break;
              case 18: sResref = "x2_c3_maarcl037"; break;
              case 19: sResref = "x2_cus_casielsso"; break;
              case 20: sResref = "x2_cus_armoroffa"; break;
              case 21: sResref = "zep_aribeth"; break;
              case 22: sResref = "crpi_reaper_armr"; break;
              case 23: sResref = "aarcl007"; break;
              case 24: sResref = "zep_knightarmor"; break;
              case 25: sResref = "zep_goblin"; break;
              case 26: sResref = "zep_knightarm" + IntToString(Random(5)+2); break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Baluarte"; break;
              case 2:  sNombre = "El defensor dorado"; break;
              case 3:  sNombre = "Alma de Tempus"; break;
              case 4:  sNombre = "Armadura completa"; break;
              case 5:  sNombre = "Armadura laminada de hierro"; break;
              case 6:  sNombre = "Cota de bandas Èlfica"; break;
          }
      }break;

      case 59: // Yelmos
      {
          iTipoDeterioro = 8;
          iTirada = d12();
          switch(iTirada)
          {
              case 1:  sResref = "zep_hlmcorm_001"; break;
              case 2:  sResref = "zep_chitinhelm"; break;
              case 3:  sResref = "nw_arhe005"; break;
              case 4:  sResref = "zep_shadowhood"; break;
              case 5:  sResref = "zep_thayvian"; break;
              case 6:  sResref = "zep_wingedhelm"; break;
              case 7:  sResref = "x2_arduerhe001"; break;
              case 8:  sResref = "x2_it_adahelm"; break;
              case 9:  sResref = "nw_arhe002"; break;
              case 10: sResref = "x3_it_pdhelmet"; break;
              case 11: sResref = "x2_helm_00" + IntToString(Random(2)+1); break;
              case 12: sResref = "x2_it_arhelm01"; break;
          }

          iTirada = d6();
          switch(iTirada)
          {
              case 1:  sNombre = "Yelmo"; break;
              case 2:  sNombre = "Vanguardia"; break;
              case 3:  sNombre = "Casquete de ballestero"; break;
              case 4:  sNombre = "Casco agrietado"; break;
              case 5:  sNombre = "MorriÛn emplumado"; break;
              case 6:  sNombre = "Defensa aÈrea"; break;
          }
      }break;

      case 60: // Guanteletes
      {
          iTipoDeterioro = Random(2)+2;
          iTirada = Random(13)+1;
          switch(iTirada)
          {
              case 1: sResref = "nw_it_mglove021"; break;
              case 2: sResref = "nw_it_mglove026"; break;
              case 3: sResref = "nw_it_mglove016"; break;
              case 4: sResref = "x1_it_mglove001"; break;
              case 5: sResref = "x2_glove_bal"; break;
              case 6: sResref = "x2_it_mglove022"; break;
              case 7: sResref = "guanteletesapla"; break;
              case 8: sResref = "guanteletescurat"; break;
              case 9: sResref = "guanteletesmayor"; break;
              case 10: sResref = "guantescosidosel"; break;
              case 11: sResref = "guantesdecurande"; break;
              case 12: sResref = "guantesdelarte1"; break;
              case 13: sResref = "guantesdecuero"; break;
          }

          iTirada = Random(14)+1;
          switch(iTirada)
          {
              case 1:  sNombre = "Machacapiedras"; break;
              case 2:  sNombre = "PuÒos de acero"; break;
              case 3:  sNombre = "Guantes de batalla"; break;
              case 4:  sNombre = "Rompenarices"; break;
              case 5:  sNombre = "Guanteletes de monje"; break;
              case 6:  sNombre = "Manos fÈrreas"; break;
              case 7:  sNombre = "Garras de tigre"; break;
              case 8:  sNombre = "Perforacorazones"; break;
              case 9:  sNombre = "Guantes de ninja"; break;
              case 10: sNombre = "Brazaletes de Ki"; break;
              case 11: sNombre = "Pulverizadores"; break;
              case 12: sNombre = "PezuÒas de dragÛn"; break;
              case 13: sNombre = "Cornadas sangrientas"; break;
              case 14: sNombre = "Guantes de batalla"; break;
          }
      }break;
  }

  if(iArrojadiza == TRUE) iStack = 10 + d20(2);
  else if(iMunicion == TRUE) iStack = 20 + d20(4);
  object oObjetoCreado = CreateItemOnObject(sResref, oObjetivo, iStack);

  if(iDebugMess == 1) SendMessageToAllDMs("Creado objeto, resref de objeto: "+sResref+" stack: "+IntToString(iStack));

  SetDroppableFlag(oObjetoCreado, TRUE);
  SetItemCursedFlag(oObjetoCreado, FALSE);

  // Debug: ver si el objeto se ha creado correctamente...
  if(oObjetoCreado == OBJECT_INVALID) WriteTimestampedLogEntry("[SISTEMA DE TESOROS] Error de creaciÛn de objeto. La resref "+sResref+" y el nombre "+sNombre+" no se ha creado exitosamente.");

  if(iArmaDoble == TRUE) sNombre = sNombre + " doble";
  SetName(oObjetoCreado, sNombre);

  if(iDebugMess == 1) SendMessageToAllDMs("Creado objeto, nombre de objeto: "+sNombre);

  itemproperty ip = GetFirstItemProperty(oObjetoCreado);
  while(GetIsItemPropertyValid(ip))
  {
      RemoveItemProperty(oObjetoCreado, ip);
      ip = GetNextItemProperty(oObjetoCreado);
  }

  if(iDebugMess == 1) SendMessageToAllDMs("Propiedades magicas del objeto de base borradas."+sNombre);

  if((d100() <= 10 || iArmaRota == 1) && iTienda == FALSE)
  {
      itemproperty ipPenalizador;
      string sNombre = ColorString(GetName(oObjetoCreado) + " destrozada", 255, 0, 0);

           if(iTipoDeterioro == 1)  ipPenalizador = ItemPropertyDecreaseAC(IP_CONST_ACMODIFIERTYPE_ARMOR, d4()+1);      // Deterioro en armaduras y brazales
      else if(iTipoDeterioro == 2)  ipPenalizador = ItemPropertyEnhancementPenalty(d4()+1);                             // Deterioro en armas y guanteletes
      else if(iTipoDeterioro == 3)  ipPenalizador = ItemPropertyAttackPenalty(d4()+1);                                  // Deterioro en armas y guanteletes
      else if(iTipoDeterioro == 4)  ipPenalizador = ItemPropertyDecreaseAbility(Random(6), d4()+1);                     // Deterioro en ropas y capas
      else if(iTipoDeterioro == 5)  ipPenalizador = ItemPropertyWeightIncrease(d3());                                   // Deterioro en varitas y cetros
      else if(iTipoDeterioro == 6)  ipPenalizador = ItemPropertyDecreaseAC(IP_CONST_ACMODIFIERTYPE_SHIELD, d4()+1);     // Deterioro en escudos
      else if(iTipoDeterioro == 7)  ipPenalizador = ItemPropertyDecreaseAC(IP_CONST_ACMODIFIERTYPE_NATURAL, d4()+1);    // Deterioro en amuletos
      else if(iTipoDeterioro == 8)  ipPenalizador = ItemPropertyDecreaseAC(IP_CONST_ACMODIFIERTYPE_DEFLECTION, d4()+1); // Deterioro en anillos, yelmos, capa, cinto
      else if(iTipoDeterioro == 9)  ipPenalizador = ItemPropertyDecreaseAC(IP_CONST_ACMODIFIERTYPE_DODGE, d4()+1);      // Deterioro en botas
      else if(iTipoDeterioro == 10) ipPenalizador = ItemPropertyDamagePenalty(d4()+1);                                  // Deterioro en municion

      DelayCommand(0.2, IPSafeAddItemProperty(oObjetoCreado, ipPenalizador));
      DelayCommand(0.2, IPSafeAddItemProperty(oObjetoCreado, ItemPropertyQuality(IP_CONST_QUALITY_DESTROYED)));

      SetName(oObjetoCreado, sNombre);
      SetDescription(oObjetoCreado, "Este objeto est· destrozado, y si te lo equipas o lo usas sufrir·s importantes penalizadores. Parece que no resistiÛ el auge de la batalla.");
      SetIdentified(oObjetoCreado, TRUE);
      SetLocalInt(oObjetoCreado, "DESTROZADO", TRUE);
      SetLocalInt(oObjetoCreado, "PCItem", 1);
      if(iDebugMess == 1) SendMessageToAllDMs("El objeto creado esta roto."+sNombre);
  }
  if (iTienda=TRUE){SetIdentified(oObjetoCreado, TRUE);} else {SetIdentified(oObjetoCreado, FALSE);}
    SetLocalInt(oObjetoCreado, "PCItem", 1);
  return oObjetoCreado;
}

void CrearArmadura(object oObjetivo, int iRango, int iTienda = FALSE)
{
  int iTirada;
  int iBonoMejora = 0;
  int iCalidad = 0;
  int nProp = 0;
    if(iRango == 1) {
            nProp = d2();         //1 Û 2
        } else if(iRango == 2) {
           nProp = 2;            //2
        } else if(iRango == 3) {
            nProp = d2()+1;         // 2 Û 3
        } else if(iRango == 4) {
            nProp = 3;           // 3
        } else {
            nProp = d2()+2;  //3 Û 4
    }
  object oObjetoCreado = IniciarObjetoCreado(oObjetivo, Random(14)+46, iTienda);

  if(GetLocalInt(oObjetoCreado, "DESTROZADO") == TRUE) return;

  // 1. Bonificador de CA
  iTirada = d100();
  if(iTirada <= 35)
  {
      DelayCommand(0.2, EncantamientoPropiedadBonificadorCA(oObjetoCreado, iRango));
      iBonoMejora = 1;
      iCalidad++;
  }

  // 2. Bonificador de resistencia/reduccion
  iTirada = d100();
  if(iTirada <= 30 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadResistenciaReduccionDanyo(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 3. Bonificador de salvacion
  iTirada = d100();
  if(iTirada <= 25 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadBonificadorSalvacion(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 4. Bonificador de habilidad
  iTirada = d100();
  if(iTirada <= 20 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadBonificadorHabilidad(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 5. Bonificador de caracteristica
  iTirada = d100();
  if(iTirada <= 20 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadBonificadorCaracteristica(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 6. Bonificador miscelanea
  iTirada = d100();
  if(iTirada <= 12 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadMiscelanea(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 7. Espacios de conjuro
  iTirada = d100();
  if(iTirada <= 10 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadEspacioDeConjuro(oObjetoCreado, iRango, d3()));
      iCalidad++;
  }

  // 8. Lanzar conjuro
  iTirada = d100();
  if(iTirada <= 3 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadLanzarConjuro(oObjetoCreado, iRango));
      iCalidad++;
  }

  //Incluir el bono de mejora si tiene mas propiedades magicas
  if(iBonoMejora == 0 && iCalidad >= 1)
    {
    DelayCommand(0.2, EncantamientoPropiedadBonificadorCA(oObjetoCreado, iRango));
    iCalidad++;
    }

  int iDebugMess = 0;
  if(iDebugMess == 1) SendMessageToAllDMs("Creadas propiedades magicas de rango:"+IntToString(iRango));
  if(iDebugMess == 1) SendMessageToAllDMs("Creadas propiedades magicas de calidad/num prop:"+IntToString(iCalidad));

  if (iCalidad > 4) SetLocalInt(oObjetoCreado, "masNivel15", 1);
  FinalizarObjetoCreado(oObjetoCreado, oObjetivo, iCalidad, iRango, iTienda);
}

void CrearArmaCuerpo(object oObjetivo, int iRango, int iTienda = FALSE)
{
  int iTirada;
  int iCalidad = 0;
  int iBonoMejora = 0;
  int nProp = 0;
  if(iRango == 1) {
            nProp = d2();         //1 Û 2
        } else if(iRango == 2) {
           nProp = 2;            //2
        } else if(iRango == 3) {
            nProp = d2()+1;         // 2 Û 3
        } else if(iRango == 4) {
            nProp = 3;           // 3
        } else {
            nProp = d2()+2;  //3 Û 4
    }


  object oObjetoCreado = IniciarObjetoCreado(oObjetivo, Random(36)+1, iTienda);

  if(GetLocalInt(oObjetoCreado, "DESTROZADO") == TRUE) return;

  // 1. Bonificador de ataque o mejora
  iTirada = d100();
  if(iTirada <= 35)
  {
      DelayCommand(0.2, EncantamientoPropiedadBonificadorMejoraAtaque(oObjetoCreado, iRango));
      iBonoMejora = 1;
      iCalidad++;
  }

  // 2. Bonificador de danyo
  iTirada = d100();
  if(iTirada <= 30 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadBonificadorDanyo(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 3. Afilada
  iTirada = d100();
  if(iTirada <= 20 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadAfilada(oObjetoCreado));
      iCalidad++;
  }

  // 4. Criticos masivos
  iTirada = d100();
  if(iTirada <= 20 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadCriticosMasivos(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 5. Efecto al golpear
  iTirada = d100();
  if(iTirada <= 20 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadEfectoAlGolpear(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 6. Regeneracion vampirica
  iTirada = d100();
  if(iTirada <= 15 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadRegeneracionVampirica(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 7. Bonificador de danyo (segundo danyo)
  iTirada = d100();
  if(iTirada <= 12 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadBonificadorDanyo(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 8. Extra danyo cuerpo a cuerpo
  iTirada = d100();
  if(iTirada <= 8 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadExtraDanyoCuerpoACuerpo(oObjetoCreado));
      iCalidad++;
  }

  //Incluir el bono de mejora si tiene mas propiedades magicas
  if(iBonoMejora == 0 && iCalidad >= 1)
    {
    DelayCommand(0.2, EncantamientoPropiedadBonificadorMejoraAtaque(oObjetoCreado, iRango));
    iCalidad++;
    }

  int iDebugMess = 0;
  if(iDebugMess == 1) SendMessageToAllDMs("Creadas propiedades magicas de rango:"+IntToString(iRango));
  if(iDebugMess == 1) SendMessageToAllDMs("Creadas propiedades magicas de calidad/num prop:"+IntToString(iCalidad));

  if (iCalidad > 4) SetLocalInt(oObjetoCreado, "masNivel15", 1);
  FinalizarObjetoCreado(oObjetoCreado, oObjetivo, iCalidad, iRango, iTienda);
}

void CrearArmaDistancia(object oObjetivo, int iRango, int iTienda = FALSE)
{
  int iTirada;
  int iCalidad = 0;
  int iBonoMejora = 0;
  object oObjetoCreado = IniciarObjetoCreado(oObjetivo, Random(3)+37, iTienda);
  int nProp = 0;
    if(iRango == 1) {
            nProp = d2();         //1 Û 2
        } else if(iRango == 2) {
           nProp = 2;            //2
        } else if(iRango == 3) {
            nProp = d2()+1;         // 2 Û 3
        } else if(iRango == 4) {
            nProp = 3;           // 3
        } else {
            nProp = d2()+2;  //3 Û 4
    }

  if(GetLocalInt(oObjetoCreado, "DESTROZADO") == TRUE) return;

  // 1. Bonificador de ataque a distancia
  iTirada = d100();
  if(iTirada <= 35)
  {
      DelayCommand(0.2, EncantamientoPropiedadBonoAtaque(oObjetoCreado, iRango));
      iBonoMejora = 1;
      iCalidad++;
  }

  // 2. Reforzado
  iTirada = d100();
  if(iTirada <= 32 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadReforzado(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 3. Criticos masivos
  iTirada = d100();
  if(iTirada <= 25 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadCriticosMasivos(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 4 Bonificador de danyo
  iTirada = d100();
  if(iTirada <= 15 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadBonificadorDanyo(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 5. Bonificador de habilidad
  iTirada = d100();
  if(iTirada <= 12 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadBonificadorHabilidad(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 6. Extra danyo a distancia
  iTirada = d100();
  if(iTirada <= 8 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadExtraDanyoDistancia(oObjetoCreado));
      iCalidad++;
  }

  // 7. Municion ilimitada
  iTirada = d100();
  if(iTirada <= 3 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadMunicionIlimitada(oObjetoCreado, iRango));
      iCalidad++;
  }

  //Incluir el bono de mejora si tiene mas propiedades magicas
  if(iBonoMejora == 0 && iCalidad >= 1)
    {
    DelayCommand(0.2, EncantamientoPropiedadBonoAtaque(oObjetoCreado, iRango));
    iCalidad++;
    }

  int iDebugMess = 0;
  if(iDebugMess == 1) SendMessageToAllDMs("Creadas propiedades magicas de rango:"+IntToString(iRango));
  if(iDebugMess == 1) SendMessageToAllDMs("Creadas propiedades magicas de calidad/num prop:"+IntToString(iCalidad));

  if (iCalidad > 4) SetLocalInt(oObjetoCreado, "masNivel15", 1);
  FinalizarObjetoCreado(oObjetoCreado, oObjetivo, iCalidad, iRango, iTienda);
}

void CrearMunicion(object oObjetivo, int iRango, int iTienda = FALSE)
{
  int iTirada;
  int iCalidad = 0;
  object oObjetoCreado = IniciarObjetoCreado(oObjetivo, Random(3)+40, iTienda);
  int nProp = 0;
    if(iRango == 1) {
            nProp = d2();         //1 Û 2
        } else if(iRango == 2) {
           nProp = 2;            //2
        } else if(iRango == 3) {
            nProp = d2()+1;         // 2 Û 3
        } else if(iRango == 4) {
            nProp = 3;           // 3
        } else {
            nProp = d2()+2;  //3 Û 4
    }

  if(GetLocalInt(oObjetoCreado, "DESTROZADO") == TRUE) return;

  // 1. Bonificador de danyo
  iTirada = d100();
  if(iTirada <= 60)
  {
      DelayCommand(0.2, EncantamientoPropiedadBonificadorDanyo(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 2. Efecto al golpear
  iTirada = d100();
  if(iTirada <= 35 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadEfectoAlGolpear(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 3. Regeneracion vampirica
  iTirada = d100();
  if(iTirada <= 20 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadRegeneracionVampirica(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 4. Bonificador de danyo
  iTirada = d100();
  if(iTirada <= 15 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadBonificadorDanyo(oObjetoCreado, iRango));
      iCalidad++;
  }

  int iDebugMess = 0;
  if(iDebugMess == 1) SendMessageToAllDMs("Creadas propiedades magicas de rango:"+IntToString(iRango));
  if(iDebugMess == 1) SendMessageToAllDMs("Creadas propiedades magicas de calidad/num prop:"+IntToString(iCalidad));

  if (iCalidad > 4) SetLocalInt(oObjetoCreado, "masNivel15", 1);
  FinalizarObjetoCreado(oObjetoCreado, oObjetivo, iCalidad, iRango, iTienda);
}

void CrearBastonesMagicos(object oObjetivo, int iRango, int iTienda = FALSE)
{
  int iTirada;
  int iCalidad = 0;
  int nProp = 0;

    if(iRango == 1) {
            nProp = d2();         //1 Û 2
        } else if(iRango == 2) {
           nProp = 2;            //2
        } else if(iRango == 3) {
            nProp = d2()+1;         // 2 Û 3
        } else if(iRango == 4) {
            nProp = 3;           // 3
        } else {
            nProp = d2()+2;  //3 Û 4
    }


  object oObjetoCreado = IniciarObjetoCreado(oObjetivo, 43, iTienda);

  if(GetLocalInt(oObjetoCreado, "DESTROZADO") == TRUE) return;

  // 1. Lanzar conjuro
  DelayCommand(0.2, EncantamientoPropiedadLanzarConjuro(oObjetoCreado, iRango));
  iCalidad++;

  // 2. Lanzar conjuro
  iTirada = d100();
  if(iTirada <= 25 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadLanzarConjuro(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 3. Lanzar conjuro
  iTirada = d100();
  if(iTirada <= 25 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadLanzarConjuro(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 4. Espacios de conjuro
  iTirada = d100();
  if(iTirada <= 15 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadEspacioDeConjuro(oObjetoCreado, iRango, d3()));
      iCalidad++;
  }

  // 5. Bonificador de habilidad
  iTirada = d100();
  if(iTirada <= 10 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadBonificadorHabilidad(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 6. Bonificador de caracteristica
  iTirada = d100();
  if(iTirada <= 5 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadBonificadorCaracteristica(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 7. Bonificador de resistencia/reduccion
  iTirada = d100();
  if(iTirada <= 5 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadResistenciaReduccionDanyo(oObjetoCreado, iRango));
      iCalidad++;
  }

  int iDebugMess = 0;
  if(iDebugMess == 1) SendMessageToAllDMs("Creadas propiedades magicas de rango:"+IntToString(iRango));
  if(iDebugMess == 1) SendMessageToAllDMs("Creadas propiedades magicas de calidad/num prop:"+IntToString(iCalidad));

  if (iCalidad > 4) SetLocalInt(oObjetoCreado, "masNivel15", 1);
  FinalizarObjetoCreado(oObjetoCreado, oObjetivo, iCalidad, iRango, iTienda);
}

void CrearVaritasCetros(object oObjetivo, int iRango, int iTienda = FALSE)
{
  object oObjetoCreado = IniciarObjetoCreado(oObjetivo, Random(2)+44, iTienda);

  if(GetLocalInt(oObjetoCreado, "DESTROZADO") == TRUE) return;

  // 1. Lanzar conjuro
  DelayCommand(0.2, EncantamientoPropiedadLanzarConjuro(oObjetoCreado, iRango));

  int iDebugMess = 0;
  if(iDebugMess == 1) SendMessageToAllDMs("Creadas propiedades magicas de rango:"+IntToString(iRango));

  FinalizarObjetoCreado(oObjetoCreado, oObjetivo, 1, iRango, iTienda);
}

void CrearGuanteletesMonje(object oObjetivo, int iRango, int iTienda = FALSE)
{
  int iTirada;
  int iCalidad = 0;
  int iBonoMejora = 0;
  int nProp = iRango;
   if(iRango == 1) {
            nProp = d2();         //1 Û 2
        } else if(iRango == 2) {
           nProp = 2;            //2
        } else if(iRango == 3) {
            nProp = d2()+1;         // 2 Û 3
        } else if(iRango == 4) {
            nProp = 3;           // 3
        } else {
            nProp = d2()+2;  //3 Û 4
    }

  object oObjetoCreado = IniciarObjetoCreado(oObjetivo, 60, iTienda);

  if(GetLocalInt(oObjetoCreado, "DESTROZADO") == TRUE) return;

  // 1. Bonificador de ataque
  iTirada = d100();
  if(iTirada <= 35)
  {
      DelayCommand(0.2, EncantamientoPropiedadBonoAtaque(oObjetoCreado, iRango));
      iBonoMejora = 1;
      iCalidad++;
  }

  // 2. Bonificador de danyo
  iTirada = d100();
  if(iTirada <= 30 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadBonificadorDanyo(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 3. Bonificador de habilidad
  iTirada = d100();
  if(iTirada <= 25 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadBonificadorHabilidad(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 4. Bonificador de caracteristica
  iTirada = d100();
  if(iTirada <= 20 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadBonificadorCaracteristica(oObjetoCreado, iRango));
      iCalidad++;
  }

  // 5. Bonificador de danyo
  iTirada = d100();
  if(iTirada <= 15 && nProp != iCalidad)
  {
      DelayCommand(0.2, EncantamientoPropiedadBonificadorDanyo(oObjetoCreado, iRango));
      iCalidad++;
  }

  //Incluir el bono de mejora si tiene mas propiedades magicas
  if(iBonoMejora == 0 && iCalidad >= 1)
    {
    DelayCommand(0.2, EncantamientoPropiedadBonoAtaque(oObjetoCreado, iRango));
    iCalidad++;
    }

  int iDebugMess = 0;
  if(iDebugMess == 1) SendMessageToAllDMs("Creadas propiedades magicas de rango:"+IntToString(iRango));
  if(iDebugMess == 1) SendMessageToAllDMs("Creadas propiedades magicas de calidad/num prop:"+IntToString(iCalidad));

  if (iCalidad > 4) SetLocalInt(oObjetoCreado, "masNivel15", 1);
  FinalizarObjetoCreado(oObjetoCreado, oObjetivo, iCalidad, iRango, iTienda);
}

void Crear1ObjetoAleatorio(object oDestino, int iRango, int iMejoraTesoro=1)
{
  int iDebugMess = 0;
  int iTirada = d100();

  if(iDebugMess == 1) SendMessageToAllDMs("Mirando tipo de objeto con mejora en probabilidad tipo: "+IntToString(iMejoraTesoro));

  if(iMejoraTesoro == 1)  // 25% de objetos encantados
  {
           if(iTirada <= 4)   CrearArmadura(oDestino, iRango);
      else if(iTirada <= 8)   CrearArmaCuerpo(oDestino, iRango);
      else if(iTirada <= 12)  CrearArmaDistancia(oDestino, iRango);
      else if(iTirada <= 15)  CrearMunicion(oDestino, iRango);
      else if(iTirada <= 18)  CrearBastonesMagicos(oDestino, iRango);
      else if(iTirada <= 22)  CrearVaritasCetros(oDestino, iRango);
      else if(iTirada <= 25)  CrearGuanteletesMonje(oDestino, iRango);
      else if(iTirada <= 37)  CrearPergamino(oDestino, iRango);
      else if(iTirada <= 57)  CrearGemas(oDestino, iRango);
      else if(iTirada <= 87)  CrearBasura(oDestino, iRango);
      else if(iTirada <= 90)  CrearMiscelanea(oDestino, iRango);
      else if(iTirada <= 100) CrearPocion(oDestino, iRango);
  }
  else if(iMejoraTesoro == 2)  // 50% de objetos encantados
  {
           if(iTirada <= 6)   CrearArmadura(oDestino, iRango);
      else if(iTirada <= 16)  CrearArmaCuerpo(oDestino, iRango);
      else if(iTirada <= 24)  CrearArmaDistancia(oDestino, iRango);
      else if(iTirada <= 30)  CrearMunicion(oDestino, iRango);
      else if(iTirada <= 36)  CrearBastonesMagicos(oDestino, iRango);
      else if(iTirada <= 44)  CrearVaritasCetros(oDestino, iRango);
      else if(iTirada <= 50)  CrearGuanteletesMonje(oDestino, iRango);
      else if(iTirada <= 60)  CrearPergamino(oDestino, iRango);
      else if(iTirada <= 72)  CrearGemas(oDestino, iRango);
      else if(iTirada <= 87)  CrearBasura(oDestino, iRango);
      else if(iTirada <= 93)  CrearMiscelanea(oDestino, iRango);
      else if(iTirada <= 100) CrearPocion(oDestino, iRango);
  }
}

void GenerarTesoroEnCriaturas()
{
  int iDebugMess = 0;
  int iRango, iTirada;

  // Calcaulo del rango
  int fValorDesafio = GetHitDice(OBJECT_SELF);



  if(fValorDesafio <= 9) iRango = 1;       // RANGO 1: Niveles 1-9
  else if(fValorDesafio <= 14) iRango = 1; // RANGO 1: Niveles 10-14
  else if(fValorDesafio <= 19) iRango = 1; //  2 RANGO 2: Niveles 15-19
  else if(fValorDesafio <= 29) iRango = 1; //  3 RANGO 3: Niveles 20-29
  else if(fValorDesafio <= 39) iRango = 1; //  4 RANGO 4: Niveles 30-39
  else iRango = 1;                         //  5 RANGO 5: Niveles >= 40

  if(iDebugMess == 1)
    {
    SendMessageToAllDMs("===INICIO GENEREACION TESORO===");
    SendMessageToAllDMs("Rango de la criatura: "+IntToString(iRango));
    }

  // Correccion del bug de Bioware que imposibilitaba saquear objetos
  // indesprendibles equipados en torso, cabeza y manos.
  object oCabeza = GetItemInSlot(INVENTORY_SLOT_HEAD);
  object oTorso = GetItemInSlot(INVENTORY_SLOT_CHEST);
  object oManoIzq = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
  object oManoDer = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
  if(GetIsObjectValid(oCabeza) && GetDroppableFlag(oCabeza))
  {
      object oCopiaCabeza = CopyItem(oCabeza, OBJECT_SELF, TRUE);
      SetLocalObject(oCopiaCabeza, "COPIASAQUEO", oCabeza);
      SetDroppableFlag(oCabeza, FALSE);
  }
  if(GetIsObjectValid(oTorso) && GetDroppableFlag(oTorso))
  {
      object oCopiaTorso = CopyItem(oTorso, OBJECT_SELF, TRUE);
      SetLocalObject(oCopiaTorso, "COPIASAQUEO", oTorso);
      SetDroppableFlag(oTorso, FALSE);
  }
  if(GetIsObjectValid(oManoIzq) && GetDroppableFlag(oManoIzq))
  {
      object oCopiaManoIzq = CopyItem(oManoIzq, OBJECT_SELF, TRUE);
      SetLocalObject(oCopiaManoIzq, "COPIASAQUEO", oManoIzq);
      SetDroppableFlag(oManoIzq, FALSE);
  }
  if(GetIsObjectValid(oManoDer) && GetDroppableFlag(oManoDer))
  {
      object oCopiaManoDer = CopyItem(oManoDer, OBJECT_SELF, TRUE);
      SetLocalObject(oCopiaManoDer, "COPIASAQUEO", oManoDer);
      SetDroppableFlag(oManoDer, FALSE);
  }

  // Generacion de objetos en jefazos
  int iVariableJefazo = GetLocalInt(OBJECT_SELF, "JEFAZO");
  if(iVariableJefazo > 0)
  {


            if(fValorDesafio <= 9) iRango = 1;       // RANGO 1: Niveles 1-9
       else if(fValorDesafio <= 14) iRango = 1; // RANGO 1: Niveles 10-14
       else if(fValorDesafio <= 19) iRango = 2; //  2 RANGO 2: Niveles 15-19
       else if(fValorDesafio <= 29) iRango = 3; //  3 RANGO 3: Niveles 20-29
       else if(fValorDesafio <= 39) iRango = 4; //  4 RANGO 4: Niveles 30-30
       else iRango = 5;                         //  5 RANGO 5: Niveles >= 40

      if(iDebugMess == 1) SendMessageToAllDMs("Criatura boss.");

      if(iVariableJefazo == 2 || iRango <= 2)
      {
          DelayCommand(2.0, CrearOro(OBJECT_SELF, Random(4) + 3));
          DelayCommand(2.0, CrearPergamino(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearGemas(OBJECT_SELF, iRango));
          DelayCommand(2.0, Crear1ObjetoAleatorio(OBJECT_SELF, iRango, 2));
          DelayCommand(2.0, Crear1ObjetoAleatorio(OBJECT_SELF, iRango, 2));
          if(d100() <= 60) DelayCommand(2.0, Crear1ObjetoAleatorio(OBJECT_SELF, iRango, 2));
          if(d100() <= 30) DelayCommand(2.0, Crear1ObjetoAleatorio(OBJECT_SELF, iRango, 2));
      }
      else if(iVariableJefazo == 3 || iRango == 3)
      {
          DelayCommand(2.0, CrearOro(OBJECT_SELF, Random(3)+6));
          DelayCommand(2.0, CrearArmaCuerpo(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearArmadura(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearPergamino(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearPergamino(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearGemas(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearGemas(OBJECT_SELF, iRango));
          DelayCommand(2.0, Crear1ObjetoAleatorio(OBJECT_SELF, iRango, 2));
          DelayCommand(2.0, Crear1ObjetoAleatorio(OBJECT_SELF, iRango, 2));
          if(d100() <= 60) DelayCommand(2.0, Crear1ObjetoAleatorio(OBJECT_SELF, iRango, 2));
          if(d100() <= 30) DelayCommand(2.0, Crear1ObjetoAleatorio(OBJECT_SELF, iRango, 2));
      }
      else if(iVariableJefazo == 4 || iRango == 4)
      {
          DelayCommand(2.0, CrearOro(OBJECT_SELF, Random(3)+8));
          DelayCommand(2.0, CrearArmaCuerpo(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearArmaCuerpo(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearArmadura(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearPergamino(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearPergamino(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearPergamino(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearGemas(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearGemas(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearGemas(OBJECT_SELF, iRango));
          DelayCommand(2.0, Crear1ObjetoAleatorio(OBJECT_SELF, iRango, 2));
          DelayCommand(2.0, Crear1ObjetoAleatorio(OBJECT_SELF, iRango, 2));
          DelayCommand(2.0, Crear1ObjetoAleatorio(OBJECT_SELF, iRango, 2));
          if(d100() <= 35) DelayCommand(2.0, CrearVaritasCetros(OBJECT_SELF, iRango));
          if(d100() <= 60) DelayCommand(2.0, Crear1ObjetoAleatorio(OBJECT_SELF, iRango, 2));
          if(d100() <= 30) DelayCommand(2.0, Crear1ObjetoAleatorio(OBJECT_SELF, iRango, 2));
      }
      else // Epicos
      {
          DelayCommand(2.0, CrearOro(OBJECT_SELF, Random(4)+7));
          DelayCommand(2.0, CrearPergamino(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearPergamino(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearPergamino(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearPergamino(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearPergamino(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearPergamino(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearPergamino(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearPergamino(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearGemas(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearGemas(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearGemas(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearGemas(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearGemas(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearGemas(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearGemas(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearGemas(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearArmaCuerpo(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearArmaCuerpo(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearArmadura(OBJECT_SELF, iRango));
          DelayCommand(2.0, CrearArmadura(OBJECT_SELF, iRango));
          DelayCommand(2.0, Crear1ObjetoAleatorio(OBJECT_SELF, iRango, d2()));
          DelayCommand(2.0, Crear1ObjetoAleatorio(OBJECT_SELF, iRango, d2()));
          DelayCommand(2.0, Crear1ObjetoAleatorio(OBJECT_SELF, iRango, d2()));
          if(d100() <= 15) DelayCommand(2.0, CrearBastonesMagicos(OBJECT_SELF, iRango));
          if(d100() <= 35) DelayCommand(2.0, CrearArmaDistancia(OBJECT_SELF, iRango));
          if(d100() <= 35) DelayCommand(2.0, CrearGuanteletesMonje(OBJECT_SELF, iRango));
          if(d100() <= 15) DelayCommand(2.0, CrearMiscelanea(OBJECT_SELF, iRango));
      }
      return;
  }

  // Sin tesoro:
  // - Las criaturas diminutas
  // - Las razas animales o bestias
  // - Los que tengan determinada variable
  // - Creacion de pieles en animales
  if(GetCreatureSize(OBJECT_SELF) == CREATURE_SIZE_TINY  ||
     GetRacialType(OBJECT_SELF)== RACIAL_TYPE_ANIMAL     ||
     GetRacialType(OBJECT_SELF)== RACIAL_TYPE_BEAST      ||
     GetLocalInt(OBJECT_SELF, "NOTESORO") == TRUE)
  {
      //CreateItemOnObject("sd_skin", oSack, 1);
      return;
  }

  if(iDebugMess == 1) SendMessageToAllDMs("Criatura normal.");

  // Oportunidad de aumentar el rango (2%)
  // No se puede subir al rango 6
  /*iTirada = d100();
  if(iTirada <= 2)
  {
      iRango++;
      if(iRango == 6) iRango = 5;
      if(iDebugMess == 1) SendMessageToAllDMs("Incrementado rango tesoro, 2%, rango: "+IntToString(iRango));
  } */

  // Generacion de oro
  if(d100() <= 70) DelayCommand(2.0, CrearOro(OBJECT_SELF, iRango));

  // Generacion de objetos
  if(d100() <= 15) DelayCommand(2.0, Crear1ObjetoAleatorio(OBJECT_SELF, iRango, 1));
  if(d100() <= 7)  DelayCommand(2.0, Crear1ObjetoAleatorio(OBJECT_SELF, iRango, 1));
  if(d100() <= 3)  DelayCommand(2.0, Crear1ObjetoAleatorio(OBJECT_SELF, iRango, 1));
}

void GenerarTesoroEnUbicados(object oPC, int iCalidad=1)
{
  // Anti spam
  if(GetLocalInt(OBJECT_SELF, "TESOROGENERADO") == TRUE) return;

  SetLocalInt(OBJECT_SELF, "TESOROGENERADO", TRUE);
  DelayCommand(3000.0, DeleteLocalInt(OBJECT_SELF, "TESOROGENERADO"));

  // Eliminar anteriores objetos del ubicado
  object oRemoveItem = GetFirstItemInInventory(OBJECT_SELF);
  while(GetIsObjectValid(oRemoveItem))
  {
      DestroyObject(oRemoveItem);

      oRemoveItem = GetNextItemInInventory(OBJECT_SELF);
  }

  // Disipacion de los conjuros de invisivilidad
  if(GetSkillRank(SKILL_MOVE_SILENTLY, oPC) < 20)
  {
      effect eBad = GetFirstEffect(oPC);
      while(GetIsEffectValid(eBad))
      {
          if(GetEffectType(eBad) == EFFECT_TYPE_ETHEREAL ||
             GetEffectType(eBad) == EFFECT_TYPE_IMPROVEDINVISIBILITY ||
             GetEffectType(eBad) == EFFECT_TYPE_INVISIBILITY ||
             GetEffectType(eBad) == EFFECT_TYPE_SANCTUARY)
          {
              RemoveEffect(oPC, eBad);
          }
          eBad = GetNextEffect(oPC);
      }
  }

  // Generacion de oro
  if(d100() <= 90) DelayCommand(0.2, CrearOro(OBJECT_SELF, iCalidad, TRUE));

  // Generacion de objetos
  if(d100() <= 80) DelayCommand(0.2, Crear1ObjetoAleatorio(OBJECT_SELF, iCalidad, 2));
  if(d100() <= 20) DelayCommand(0.2, Crear1ObjetoAleatorio(OBJECT_SELF, iCalidad, 2));
  if(d100() <= 5) DelayCommand(0.2, Crear1ObjetoAleatorio(OBJECT_SELF, iCalidad, 2));
}

void GenerarTesoroEnUbicadosBoss(object oPC, int iCalidad)
{
  // Anti spam
  if(GetLocalInt(OBJECT_SELF, "TESOROGENERADO") == TRUE) return;

  SetLocalInt(OBJECT_SELF, "TESOROGENERADO", TRUE);
  DelayCommand(3000.0, DeleteLocalInt(OBJECT_SELF, "TESOROGENERADO"));

  //Borramos si es tesoro de boss
  if(GetLocalInt(OBJECT_SELF, "TESOROBOSS") > 0) DelayCommand(300.0, DestroyObject(OBJECT_SELF, 0.5));

  // Eliminar anteriores objetos del ubicado
  object oRemoveItem = GetFirstItemInInventory(OBJECT_SELF);
  while(GetIsObjectValid(oRemoveItem))
  {
      DestroyObject(oRemoveItem);

      oRemoveItem = GetNextItemInInventory(OBJECT_SELF);
  }

  // Disipacion de los conjuros de invisivilidad
  if(GetSkillRank(SKILL_MOVE_SILENTLY, oPC) < 20)
  {
      effect eBad = GetFirstEffect(oPC);
      while(GetIsEffectValid(eBad))
      {
          if(GetEffectType(eBad) == EFFECT_TYPE_ETHEREAL ||
             GetEffectType(eBad) == EFFECT_TYPE_IMPROVEDINVISIBILITY ||
             GetEffectType(eBad) == EFFECT_TYPE_INVISIBILITY ||
             GetEffectType(eBad) == EFFECT_TYPE_SANCTUARY)
          {
              RemoveEffect(oPC, eBad);
          }
          eBad = GetNextEffect(oPC);
      }
  }

  // Generacion de objetos
          DelayCommand(0.2, CrearOro(OBJECT_SELF, Random(3)+6));
          DelayCommand(0.2, CrearArmaCuerpo(OBJECT_SELF, iCalidad));
          DelayCommand(0.2, CrearArmadura(OBJECT_SELF, iCalidad));
          DelayCommand(0.2, CrearPergamino(OBJECT_SELF, iCalidad));
          DelayCommand(0.2, CrearPergamino(OBJECT_SELF, iCalidad));
          DelayCommand(0.2, CrearGemas(OBJECT_SELF, iCalidad));
          DelayCommand(0.2, CrearGemas(OBJECT_SELF, iCalidad));
          DelayCommand(0.2, Crear1ObjetoAleatorio(OBJECT_SELF, iCalidad, 2));
          DelayCommand(0.2, Crear1ObjetoAleatorio(OBJECT_SELF, iCalidad, 2));
          if(d100() <= 50) DelayCommand(0.2, CrearOro(OBJECT_SELF, iCalidad, TRUE));
          if(d100() <= 30) DelayCommand(0.2, Crear1ObjetoAleatorio(OBJECT_SELF, iCalidad, d2()));
          if(d100() <= 20) DelayCommand(0.2, Crear1ObjetoAleatorio(OBJECT_SELF, iCalidad, d2()));
          if(d100() <= 5)  DelayCommand(0.2, Crear1ObjetoAleatorio(OBJECT_SELF, iCalidad, d2()));
}

//void main(){}
