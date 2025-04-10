#include "mti_libreria"
#include "nw_i0_spells"
#include "nwnx_creature"
#include "inc_spells"

const int VARIABLE_XP_EQUITACION  = 4;
const int VARIABLE_XP_MONTURA     = 8;

int CalculoSiguienteNivelXPEquitacion(int iNivelEquitacion)
{
  return iNivelEquitacion * (iNivelEquitacion + 1) * VARIABLE_XP_EQUITACION;
}

int CalculoSiguienteNivelXPMontura(int iNivelMontura)
{
  return iNivelMontura * (iNivelMontura + 1) * VARIABLE_XP_MONTURA;
}

string ObtenerRangoJineteString(object oPC)
{
  int iNivelEquitacion = ObtenerIntPersistente(oPC, "NIVELEQUITACION");
  string sRango;
  if(iNivelEquitacion >= 100) sRango = "Gran maestro jinete";
  else if(iNivelEquitacion >= 90) sRango = "Maestro jinete";
  else if(iNivelEquitacion >= 70) sRango = "Jinete notable";
  else if(iNivelEquitacion >= 50) sRango = "Jinete especialista";
  else if(iNivelEquitacion >= 25) sRango = "Aprendiz de jinete aventajado";
  else if(iNivelEquitacion >= 10) sRango = "Aprendiz de jinete";
  else if(iNivelEquitacion >= 1) sRango = "Novicio jinete";

  return sRango;
}

int VerSiEsMontura(object oMontura = OBJECT_SELF)
{
  if(GetTag(oMontura) == "cab_montura") return TRUE;

  return FALSE;
}

int VerSiEsMonturaConvocada(object oMontura = OBJECT_SELF)
{
  if(GetTag(oMontura) == "cab_monturaconv") return TRUE;

  return FALSE;
}

int VerSiEsMonturaAntigua(object oMontura = OBJECT_SELF)
{
  string sResRefMontura = GetResRef(oMontura);
  if(sResRefMontura == "cab_marroncep"  ||
     sResRefMontura == "cab_blancocep"  ||
     sResRefMontura == "cab_negrocep"   ||
     sResRefMontura == "cab_palponi"    ||
     sResRefMontura == "cab_ponimarcep" ||
     sResRefMontura == "cab_poniblacep" ||
     sResRefMontura == "cab_ponimotcep" ||
     sResRefMontura == "cab_aurenthilcep") return TRUE;

  return FALSE;
}

int VerSiDebeTenerSonidoCaballo(object oMontura = OBJECT_SELF)
{
  string sResRefMontura = GetResRef(oMontura);
  if(sResRefMontura == "cab_jabalired"     ||
     sResRefMontura == "cab_jabalired2"    ||
     sResRefMontura == "cab_jabaligrey"    ||
     sResRefMontura == "cab_jabaligrey2"   ||
     sResRefMontura == "cab_jabalinegro"   ||
     sResRefMontura == "cab_jabalinegro2"  ||
     sResRefMontura == "cab_leon"          ||
     sResRefMontura == "cab_leona"         ||
     sResRefMontura == "cab_perro"         ||
     sResRefMontura == "cab_leopardo"      ||
     sResRefMontura == "cab_lagartoverde"  ||
     sResRefMontura == "cab_lagartonaran"  ||
     sResRefMontura == "cab_loboterr"      ||
     sResRefMontura == "cab_huargo"        ||
     sResRefMontura == "cab_muertoviv"     ||
     sResRefMontura == "cab_hipogrifo"     ||
     sResRefMontura == "cab_grifo"         ||
     sResRefMontura == "cab_grifo2"        ||
     sResRefMontura == "cab_jarilith"      ||
     sResRefMontura == "cab_cabranegra"    ||
     sResRefMontura == "cab_cabramarron"   ||
     sResRefMontura == "cab_cabramoteada"  ||
     sResRefMontura == "cab_cabrablanca"   ||
     sResRefMontura == "cab_ciervo"        ||
     sResRefMontura == "cab_oso"           ||
     sResRefMontura == "cab_osopolar"      ||
     sResRefMontura == "cab_osomarron"     ||
     sResRefMontura == "cab_osonegro") return FALSE;
  return TRUE;
}

int VerSiEsMonturaVoladora(object oMontura = OBJECT_SELF)
{
  string sResRefMontura = GetResRef(oMontura);
  if(sResRefMontura == "cab_hipogrifo"    ||
     sResRefMontura == "cab_grifo"        ||
     sResRefMontura == "cab_grifo2"        ||
     sResRefMontura == "cab_pegasoblanco" ||
     sResRefMontura == "cab_pegasonegro"  ||
     sResRefMontura == "cab_pegasomarron") return TRUE;

  return FALSE;
}

int VerSiEsAnimalDeCarga(object oAnimalDeCarga = OBJECT_SELF)
{
  if(GetTag(oAnimalDeCarga) == "cab_animalcarga") return TRUE;

  return FALSE;
}

int VerSiEsMascota(object oMascota = OBJECT_SELF)
{
  if(GetTag(oMascota) == "cab_mascota") return TRUE;

  return FALSE;
}

void ComprarAnimalDeCarga(object oPC, string sResref, int iOro)
{
  // Si estamos montados, no podemos comprar animales de carga
  if(ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0)
  {
      AssignCommand(OBJECT_SELF, ActionSpeakString("¡Desmóntate de esa montura y hablamos mejor!"));
      return;
  }

  // No se pueden tener mas de 3 de ayudantes
  if(GetHenchman(oPC, 1) != OBJECT_INVALID &&
     GetHenchman(oPC, 2) != OBJECT_INVALID &&
     GetHenchman(oPC, 3) != OBJECT_INVALID)
  {
      AssignCommand(OBJECT_SELF, ActionSpeakString("¡No puedes tener más de 3 ayudantes a la vez!"));
      return;
  }

  // Intentamos sacar una montura pero no tenemos dinero para pagar
  if(GetGold(oPC) < iOro)
  {
      AssignCommand(OBJECT_SELF, ActionSpeakString("¡Necesitas pagar "+IntToString(iOro)+" monedas de oro para alquilar este animal de carga!"));
      return;
  }

  // Obtenemos la carga, nombre de variable del stock y el nombre del animal
  int iCarga;
  string sVariable;
  string sNombre;
  if(sResref == "cab_cargapin") {iCarga = 50; sVariable = "STOCKPIN"; sNombre = "pingüino de carga";}
  else if(sResref == "cab_cargatej") {iCarga = 50; sVariable = "STOCKTEJ"; sNombre = "tejón de carga";}
  else if(sResref == "cab_cargajab") {iCarga = 40; sVariable = "STOCKJAB"; sNombre = "jabalí de carga";}
  else if(sResref == "cab_cargaesc") {iCarga = 30; sVariable = "STOCKESC"; sNombre = "escarabajo de carga";}
  else if(sResref == "cab_cargapon") {iCarga = 30; sVariable = "STOCKPON"; sNombre = "poni de carga";}
  else if(sResref == "cab_cargabue" || sResref == "cab_cargabue2") {iCarga = 20; sVariable = "STOCKBUE"; sNombre = "poni de carga";}
  else if(sResref == "cab_cargacab" || sResref == "cab_cargacab2") {iCarga = 20; sVariable = "STOCKCAB"; sNombre = "caballo de carga";}
  else if(sResref == "cab_cargacam") {iCarga = 10; sVariable = "STOCKCAM"; sNombre = "camello de carga";}
  else if(sResref == "cab_cargaoso") {iCarga = 0; sVariable = "STOCKOSO"; sNombre = "oso de carga";}

  // Si no hay stock, nanay
  if(GetLocalInt(OBJECT_SELF, sVariable) <= 0)
  {
      AssignCommand(OBJECT_SELF, ActionSpeakString("¡Lo lamento, no dispongo de más ejemplares de "+sNombre+"!"));
      return;
  }

  // Aparece el animal de carga y te sigue
  location lLugarEstablo = GetLocation(GetWaypointByTag(GetTag(GetArea(oPC)) + "establo"));
  float fDistanciaEstablo = GetDistanceBetweenLocations(GetLocation(oPC), lLugarEstablo);
  location lLugarelegido;
  if(fDistanciaEstablo == -1.0 || fDistanciaEstablo > 15.0) lLugarelegido = GetLocation(oPC);
  else lLugarelegido = GetLocation(GetWaypointByTag(GetTag(GetArea(oPC)) + "establo"));
  object oAnimalCarga = CreateObject(OBJECT_TYPE_CREATURE, sResref, lLugarelegido);
  AddHenchman(oPC, oAnimalCarga);
  DelayCommand(1.9, AssignCommand(oAnimalCarga, ClearAllActions(TRUE)));
  DelayCommand(2.0, AssignCommand(oAnimalCarga, ActionMoveToObject(oPC, TRUE)));
  SetLocalString(oAnimalCarga, "AMO", GetName(oPC, TRUE));
  SetLocalInt(oAnimalCarga,"Ayudante_NoBorrar",1);

  // Creamos la carga al animal de carga
  int iContador = 0;
  while(iContador < iCarga)
  {
      CreateItemOnObject("cab_carga", oAnimalCarga);
      iContador = iContador + 1;
  }

  // Nombre del propietario del animal
  SetDescription(oAnimalCarga, GetDescription(oAnimalCarga) + "\n\n<c ~ >Propietario: </c>" + ObtenerStringPersistente(oPC,"Disfrazado_nombre"));

  // Restamos el stock
  SetLocalString(oAnimalCarga, "CABSTOCK", sVariable);
  int iValorStock = GetLocalInt(OBJECT_SELF, sVariable);
  SetLocalInt(OBJECT_SELF, sVariable, iValorStock - 1);

  // Pagamos
  AssignCommand(oPC, TakeGoldFromCreature(iOro, oPC, TRUE));
  AssignCommand(OBJECT_SELF, ActionSpeakString("¡Jojojo! Aquí tienes tu "+sNombre+", ¡que sano se le ve!"));
  SendMessageToPC(oPC, "<ceî´>Pagas "+IntToString(iOro)+" monedas de oro por el alquiler del animal de carga.</c>");

  // Variables anmales sin devolver
  int iAnimalesSinDevolver = ObtenerIntPersistente(oPC, "ANIMALES_SIN_DEVOLVER");
  GuardarIntPersistente(oPC, "ANIMALES_SIN_DEVOLVER", iAnimalesSinDevolver + 1);
}

int ObtenerDevolucionOroDeAnimalDeCarga(object oAnimalCarga)
{
  string sResref = GetResRef(oAnimalCarga);
  if(sResref == "cab_cargapin") return 75;
  else if(sResref == "cab_cargatej") return 75;
  else if(sResref == "cab_cargajab") return 188;
  else if(sResref == "cab_cargaesc") return 375;
  else if(sResref == "cab_cargapon") return 375;
  else if(sResref == "cab_cargabue" || sResref == "cab_cargabue2") return 750;
  else if(sResref == "cab_cargacab" || sResref == "cab_cargacab2") return 750;
  else if(sResref == "cab_cargacam") return 1500;
  else if(sResref == "cab_cargaoso") return 3000;
  else return 0;
}

void MascotaInvocacion(location lLugar)
{
  effect eInvocacionMascota = EffectSummonCreature("cab_mascota", 92, 0.0, TRUE);
  ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eInvocacionMascota, lLugar);
}

void MascotaAjustes(object oPC, object oObjetoMascota)
{
  // Obtenemos los datos de la mascota
  string sNombreMascota, sRetratoMascota;
  int iConjuntoSonidos, iApariencia;
  string sIdentidadMascota = GetStringRight(GetResRef(oObjetoMascota), 2);
  if(sIdentidadMascota == "01")      {sNombreMascota = "Perro";            sRetratoMascota = "po_dog_";        iConjuntoSonidos = 27;  iApariencia = 176;}
  else if(sIdentidadMascota == "02") {sNombreMascota = "Doberman";         sRetratoMascota = "po_dobie_";      iConjuntoSonidos = 27;  iApariencia = 2394;} //1393
  else if(sIdentidadMascota == "03") {sNombreMascota = "Husky";            sRetratoMascota = "po_husky_";      iConjuntoSonidos = 27;  iApariencia = 2395;} //1394
  else if(sIdentidadMascota == "04") {sNombreMascota = "Dálmata";          sRetratoMascota = "po_dalm_";       iConjuntoSonidos = 27;  iApariencia = 2400;} //1399
  else if(sIdentidadMascota == "05") {sNombreMascota = "Lobo";             sRetratoMascota = "po_wolf_";       iConjuntoSonidos = 103; iApariencia = 181;}
  else if(sIdentidadMascota == "06") {sNombreMascota = "Gaviota";          sRetratoMascota = "po_seagull_";    iConjuntoSonidos = 451; iApariencia = 291;}
  else if(sIdentidadMascota == "07") {sNombreMascota = "Búho";             sRetratoMascota = "po_a_bird_rap_"; iConjuntoSonidos = 451; iApariencia = 2948;} //1947
  else if(sIdentidadMascota == "08") {sNombreMascota = "Loro";             sRetratoMascota = "po_poly_";       iConjuntoSonidos = 452; iApariencia = 7;}
  else if(sIdentidadMascota == "09") {sNombreMascota = "Cuervo";           sRetratoMascota = "po_a_bird_rap_"; iConjuntoSonidos = 77;  iApariencia = 1068;} //145
  else if(sIdentidadMascota == "10") {sNombreMascota = "Tucán";            sRetratoMascota = "po_poly_";       iConjuntoSonidos = 77;  iApariencia = 2964;} //1963
  else if(sIdentidadMascota == "11") {sNombreMascota = "Cobra";            sRetratoMascota = "po_cobra_";      iConjuntoSonidos = 260; iApariencia = 194;}
  else if(sIdentidadMascota == "12") {sNombreMascota = "Gato blanco";      sRetratoMascota = "po_kitten2_";    iConjuntoSonidos = 854; iApariencia = 2410;} //1409
  else if(sIdentidadMascota == "13") {sNombreMascota = "Gato negro";       sRetratoMascota = "po_darkcat_";    iConjuntoSonidos = 854; iApariencia = 7520;} //1406
  else if(sIdentidadMascota == "14") {sNombreMascota = "Gato marrón";      sRetratoMascota = "po_orngecat_";   iConjuntoSonidos = 854; iApariencia = 7519;} //1408
  else if(sIdentidadMascota == "15") {sNombreMascota = "Mofeta";           sRetratoMascota = "po_skunk_";      iConjuntoSonidos = 4;   iApariencia = 2339;} //1338
  else if(sIdentidadMascota == "16") {sNombreMascota = "Cangrejo";         sRetratoMascota = "po_crab_";       iConjuntoSonidos = 89;  iApariencia = 2985;} //1984
  else if(sIdentidadMascota == "17") {sNombreMascota = "Tejón";            sRetratoMascota = "po_badger_";     iConjuntoSonidos = 4;   iApariencia = 8;}
  else if(sIdentidadMascota == "18") {sNombreMascota = "Gallina";          sRetratoMascota = "po_chicken_";    iConjuntoSonidos = 21;  iApariencia = 31;}
  else if(sIdentidadMascota == "19") {sNombreMascota = "Ratoncito";        sRetratoMascota = "po_rat_";        iConjuntoSonidos = 4;   iApariencia = 2309;} //1308
  else if(sIdentidadMascota == "20") {sNombreMascota = "Rata blanca";      sRetratoMascota = "po_rat_";        iConjuntoSonidos = 249; iApariencia = 2984;} //1983
  else if(sIdentidadMascota == "21") {sNombreMascota = "Mono";             sRetratoMascota = "po_monkey_";     iConjuntoSonidos = 250; iApariencia = 2750;} //1749
  else if(sIdentidadMascota == "22") {sNombreMascota = "Cerdito";          sRetratoMascota = "po_boar_";       iConjuntoSonidos = 10;  iApariencia = 2970;} //1969
  else if(sIdentidadMascota == "23") {sNombreMascota = "Lémur";            sRetratoMascota = "po_raccoon_";    iConjuntoSonidos = 4;   iApariencia = 2331;} //1330
  else if(sIdentidadMascota == "24") {sNombreMascota = "Mapache";          sRetratoMascota = "po_raccoon_";    iConjuntoSonidos = 4;   iApariencia = 2942;} //1941
  else if(sIdentidadMascota == "25") {sNombreMascota = "Panda rojo";       sRetratoMascota = "po_redpanda_";   iConjuntoSonidos = 4;   iApariencia = 2330;} //1329
  else if(sIdentidadMascota == "26") {sNombreMascota = "Hurón";            sRetratoMascota = "po_ferret_";     iConjuntoSonidos = 4;   iApariencia = 2342;} //1341
  else if(sIdentidadMascota == "27") {sNombreMascota = "Visón";            sRetratoMascota = "po_rat_";        iConjuntoSonidos = 4;   iApariencia = 2340;} //1339
  else if(sIdentidadMascota == "28") {sNombreMascota = "Ciervo pequeñito"; sRetratoMascota = "po_zfawn_";      iConjuntoSonidos = 24;  iApariencia = 2804;} //1803
  else if(sIdentidadMascota == "29") {sNombreMascota = "Comadreja";        sRetratoMascota = "po_rat_";        iConjuntoSonidos = 249; iApariencia = 2337;} //1336
  else if(sIdentidadMascota == "30") {sNombreMascota = "Nutria";           sRetratoMascota = "po_direrat_";    iConjuntoSonidos = 4;   iApariencia = 2341;} //1340

  // Aplicamos los ajustes
  object oMascota = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);
  string sNombrePJ = GetName(oPC, TRUE);
  string sNombreMascotaPersonalizado = GetLocalString(oObjetoMascota, "MASCOTA_NOMBREPERS");
  SetDescription(oMascota, "Esta es la mascota ("+sNombreMascota+") de "+sNombrePJ+".");
  if(sNombreMascotaPersonalizado == "") sNombreMascota = sNombreMascota+" de "+sNombrePJ;
  else sNombreMascota = sNombreMascotaPersonalizado;
  SetName(oMascota, sNombreMascota);
  SetPortraitResRef(oMascota, sRetratoMascota);
  SetSoundset(oMascota, iConjuntoSonidos);
  SetCreatureAppearanceType(oMascota, iApariencia);
  AssignCommand(oMascota, ActionSpeakString("*Tu mascota está feliz de verte y acude a ti corriendo*"));
  AssignCommand(oMascota, ActionMoveToLocation(GetLocation(oPC), TRUE));
  SetLocalObject(oPC, "MASCOTA_OBJGUARDADO", oObjetoMascota);
}

void DescripcionMascota(object oObjetoMascota)
{
  string sNombre = GetLocalString(oObjetoMascota, "MASCOTA_NOMBREPERS");
  if(sNombre == "") sNombre = "Ninguno en especial";

  string sDescripcion = "Este objeto demuestra que eres poseedor de una mascota. Te bastará con usarlo para llamar al animal, el cual acudirá a ti corriendo.\n\n" +
  "Tu mascota huirá de cualquier enemigo, y cuando la dañen se refugiará en algún lugar seguro, por lo que tendrás que llamarla de nuevo para que aparezca. Podrás llamarla hasta 3 veces al día.\n\n" +
  "<c ~ >Nombre:</c> "+ sNombre +". (Es posible que tengas que cambiar de área para que se visualice correctamente)";

  SetDescription(oObjetoMascota, sDescripcion);
}

void DescripcionMontura(object oObjetoMontura, string sEstado = "Viva, en perfecto estado")
{
  string sNombre = GetLocalString(oObjetoMontura, "CABNOMBRE");
  int iNivel = GetLocalInt(oObjetoMontura, "NIVELMONTURA");
  int iXP = GetLocalInt(oObjetoMontura, "NIVELMONTURAXP");
  int iXPSigNiv = CalculoSiguienteNivelXPMontura(iNivel);

  if(sNombre == "") sNombre = "Ninguno en especial";

  string sDescripcion = "Este objeto demuestra que eres poseedor de una montura en cualquier establo de Amn. Podrás usarlo de distintas formas:\n" +
  "- Si estás desmontado y cerca de un establo, podrás sacar o guardar tu montura, dependiendo si tenías ya alguna siguiéndote o no.\n" +
  "- Si estás montado, te desmontarás.\n\n" +
  "<c ~ >Nombre:</c> "+ sNombre +". (Es posible que tengas que cambiar de área para que se visualice correctamente)\n" +
  "<c ~ >Nivel:</c> "+ IntToString(iNivel) +".\n" +
  "<c ~ >Experiencia:</c> "+ IntToString(iXP) + "/" + IntToString(iXPSigNiv) + ".\n" +
  "<c ~ >Estado:</c> "+ sEstado +".";

  SetDescription(oObjetoMontura, sDescripcion);
}

void AplicarRetratoMontura(int iTipoRetrato = 2, object oMontura = OBJECT_SELF)
{
  string sRetratoMontura = GetPortraitResRef(oMontura);
  if(sRetratoMontura == "po_horse1_" || sRetratoMontura == "po_horse1a_" || sRetratoMontura == "po_horse1c_")
  {
      if(iTipoRetrato == 1) SetPortraitResRef(oMontura, "po_horse1a_");
      else SetPortraitResRef(oMontura, "po_horse1c_");
  }
  else if(sRetratoMontura == "po_horse2_" || sRetratoMontura == "po_horse2a_" || sRetratoMontura == "po_horse2c_")
  {
      if(iTipoRetrato == 1) SetPortraitResRef(oMontura, "po_horse2a_");
      else SetPortraitResRef(oMontura, "po_horse2c_");
  }
  else if(sRetratoMontura == "po_horse3_" || sRetratoMontura == "po_horse3a_" || sRetratoMontura == "po_horse3c_")
  {
      if(iTipoRetrato == 1) SetPortraitResRef(oMontura, "po_horse3a_");
      else SetPortraitResRef(oMontura, "po_horse3c_");
  }
  else if(sRetratoMontura == "po_horse4_" || sRetratoMontura == "po_horse4a_" || sRetratoMontura == "po_horse4c_")
  {
      if(iTipoRetrato == 1) SetPortraitResRef(oMontura, "po_horse4a_");
      else SetPortraitResRef(oMontura, "po_horse4c_");
  }
}

int ObtenerArmaduraMontura(int iApariencia)
{
  // SIN ARMADURAS
  if((iApariencia >= 496 && iApariencia <= 498) ||
     (iApariencia >= 509 && iApariencia <= 511) ||
     (iApariencia >= 522 && iApariencia <= 524) ||
     (iApariencia >= 535 && iApariencia <= 537) ||
     (iApariencia >= 549 && iApariencia <= 561) ||
     (iApariencia >= 2856 && iApariencia <= 2861) || //1855-1862
     (iApariencia >= 3517 && iApariencia <= 3521) || //2518-2520
     (iApariencia >= 3560 && iApariencia <= 3562) || //2559-2561
     (iApariencia >= 3575 && iApariencia <= 3579) || //2574-2578
     (iApariencia >= 3590 && iApariencia <= 3592) || //2589-2591
     (iApariencia >= 4906 && iApariencia <= 4913) || //3905-3912
     (iApariencia == 4915 || iApariencia == 4916) ||  //3914-1915
     (iApariencia >= 4921 && iApariencia <= 4932) || //3920-3931
      iApariencia == 4902 || iApariencia == 204) return 1;      //3901

  // ARMADURA DE MALLAS
  else if(iApariencia == 501  || iApariencia == 506  ||
          iApariencia == 514  || iApariencia == 519  ||
          iApariencia == 527  || iApariencia == 532  ||
          iApariencia == 540  || iApariencia == 545  ||
          iApariencia == 3524 || iApariencia == 3529 || //2523-2528
          iApariencia == 3582 || iApariencia == 3587 || //2581-2586
          iApariencia == 3595 || iApariencia == 4903 || //2594-3902
          iApariencia == 4904) return 3;     //3903

  // ARMADURA DE ESCAMAS
  else if(iApariencia == 500  || iApariencia == 505   ||
          iApariencia == 513  || iApariencia == 518   ||
          iApariencia == 526  || iApariencia == 531   ||
          iApariencia == 539  || iApariencia == 544   ||
          iApariencia == 3581 || iApariencia == 3586  || //2580-2585
          iApariencia == 3523 || iApariencia == 3528  || //2522-2527
          iApariencia == 3594 || iApariencia == 4914  || //2593-3913
         (iApariencia >= 4917 && iApariencia <= 4920)) return 4; //3916-3919

  // ARMADURA DE CUERO
  return 2;
}

void AplicarArmaduraMontura(object oPC, int iApariencia)
{
  // SIN ARMADURAS
  if(ObtenerArmaduraMontura(iApariencia) == 1)
  {
      FloatingTextStringOnCreature("<c´þd>Montura sin armadura equipada</c>", oPC, FALSE);
      AplicarRetratoMontura(1);
  }

  // ARMADURA DE CUERO
  else if(ObtenerArmaduraMontura(iApariencia) == 2)
  {
      FloatingTextStringOnCreature("<c´þd>Montura con armadura de cuero equipada</c>", oPC, FALSE);
      AplicarRetratoMontura();
  }

  // ARMADURA DE MALLAS
  else if(ObtenerArmaduraMontura(iApariencia) == 3)
  {
      FloatingTextStringOnCreature("<c´þd>Montura con armadura de mallas equipada</c>", oPC, FALSE);
      AplicarRetratoMontura();
  }

  // ARMADURA DE ESCAMAS
  else if(ObtenerArmaduraMontura(iApariencia) == 4)
  {
      FloatingTextStringOnCreature("<c´þd>Montura con armadura de escamas equipada</c>", oPC, FALSE);
      AplicarRetratoMontura();
  }
}

void MonturasMontarse(object oPC, int iAnimacionesJustas = FALSE)
{
  if(VerSiDebeTenerSonidoCaballo()) AssignCommand(oPC, PlaySound("c_horse_dead"));
  else AssignCommand(oPC, PlaySound("c_maggris_atk1"));

  // No nos podemos montar cuando tenemos alguna forma rara
  int iAparienciaAntigua = GetAppearanceType(oPC);
  int iFenotipoAntiguo = GetPhenoType(oPC);
  if(iAparienciaAntigua > 6)
  {

        SendMessageToPC(oPC, "<cüGB>No puedes montarte con esa apariencia.</c>");
        return;

  }

  if(iFenotipoAntiguo > 2 && iFenotipoAntiguo != 4)
  {

        SendMessageToPC(oPC, "<cüGB>No puedes montarte con este fenotipo.</c>");
        return;

  }

  if(ObtenerIntPersistente(oPC,"APA_CAMBIADA") > 0)
  {

        SendMessageToPC(oPC, "<cüGB>No puedes montarte transformado.</c>");
        return;

  }

  // Adios invisivilidad
  effect eInvi = GetFirstEffect(oPC);
  while(GetIsEffectValid(eInvi))
  {
      if(GetEffectType(eInvi) == EFFECT_TYPE_IMPROVEDINVISIBILITY ||
         GetEffectType(eInvi) == EFFECT_TYPE_INVISIBILITY)
      {
          RemoveEffect(oPC, eInvi);
      }
      eInvi = GetNextEffect(oPC);
  }

  gsSPRemoveEffect(oPC, SPELL_IMPROVED_INVISIBILITY);
  gsSPRemoveEffect(oPC, SPELL_INVISIBILITY);
  gsSPRemoveEffect(oPC, SPELL_INVISIBILITY_SPHERE);

  // Desactivacion del modo carrera
  if(GetHasSpellEffect(984, oPC))
  {
      FloatingTextStringOnCreature("<cþ<<>* Modo Carrera desactivado *</c>", oPC, FALSE);
      RemoveEffectsFromSpell(oPC, 984);
  }

  string sResRefCaballo = GetResRef(OBJECT_SELF);
  int iAparienciaCaballo = GetAppearanceType(OBJECT_SELF);
  int iSonidosPasos = 17;
  int iFenotipoEscogido;
  int iMontado;

  // Guardamos persistentemente las apariencias (Parte I)
  int iSonidosPasosAntiguos = GetFootstepType(oPC);
  GuardarIntPersistente(oPC, "CABFENTIPO", iFenotipoAntiguo);
  GuardarIntPersistente(oPC, "CABSONIDOSPASOS", iSonidosPasosAntiguos);
  GuardarStringPersistente(oPC, "CABRESREF1", GetResRef(OBJECT_SELF));
  GuardarIntPersistente(oPC, "CABRESREF2", GetAppearanceType(OBJECT_SELF));

  // CINCO PASOS BASICOS PARA MONTARSE (apariencia, cola, fenotipo, sonidos de pasos y efectos)
  if(VerSiEsMonturaAntigua() == FALSE)
  {
      // Guardamos persistentemente las apariencias (Parte II)
      int iColaAntigua = GetCreatureTailType(oPC);
      GuardarIntPersistente(oPC, "CABAPARIENCIA", iAparienciaAntigua);
      GuardarIntPersistente(oPC, "CABCOLA", iColaAntigua);

      // Ajuste monturas voladoras
      if(VerSiEsMonturaVoladora())
      {
          object oHabilidadMonturaVuelo = CreateItemOnObject("cab_volar", oPC);
          int iAlasEscogidas = 0;
          if(sResRefCaballo == "cab_pegasoblanco") iAlasEscogidas=2;//SetLocalInt(oHabilidadMonturaVuelo, "CABPEGASOBLANCO", TRUE); // El caballo blanco tiene una apariencia unica que no necesita alas, solo el objeto
          else if(sResRefCaballo == "cab_pegasomarron") iAlasEscogidas = 2008; //1960
          else if(sResRefCaballo == "cab_pegasonegro") iAlasEscogidas = 1961; //1965
          else if(sResRefCaballo == "cab_grifo2") iAlasEscogidas = 0;
          GuardarIntPersistente(oPC, "CABALAS", GetCreatureWingType(oPC));
          DelayCommand(1.5, SetCreatureWingType(iAlasEscogidas, oPC));

      }

      //Caballos de paladín tienen otra variable.
      if(sResRefCaballo == "cab_palcaba") iMontado = 3;
      else if(sResRefCaballo == "cab_cabraconvo") iMontado = 3;
      else if(sResRefCaballo == "cab_ciervoconvo") iMontado = 3;
      else if(sResRefCaballo == "cab_huargoconvo") iMontado = 3;
      else if(sResRefCaballo == "cab_cabnegrconvo") iMontado = 3;
      //Caballos normales.
      else iMontado = 1;

      // 1. Elegimos apariencia de jinete  (caballos/ponis del cep no usan esto)
      int iAparienciaEscogida;
      if(GetGender(oPC) == GENDER_FEMALE)
      {
          if(iAparienciaAntigua == APPEARANCE_TYPE_DWARF) iAparienciaEscogida = 482;
          else if(iAparienciaAntigua == APPEARANCE_TYPE_ELF) iAparienciaEscogida = 484;
          else if(iAparienciaAntigua == APPEARANCE_TYPE_GNOME) iAparienciaEscogida = 486;
          else if(iAparienciaAntigua == APPEARANCE_TYPE_HALFLING) iAparienciaEscogida = 488;
          else if(iAparienciaAntigua == APPEARANCE_TYPE_HALF_ELF) iAparienciaEscogida = 490;
          else if(iAparienciaAntigua == APPEARANCE_TYPE_HALF_ORC) iAparienciaEscogida = 492;
          else if(iAparienciaAntigua == APPEARANCE_TYPE_HUMAN) iAparienciaEscogida = 494;
      }
      else
      {
          if(iAparienciaAntigua == APPEARANCE_TYPE_DWARF) iAparienciaEscogida = 483;
          else if(iAparienciaAntigua == APPEARANCE_TYPE_ELF) iAparienciaEscogida = 485;
          else if(iAparienciaAntigua == APPEARANCE_TYPE_GNOME) iAparienciaEscogida = 487;
          else if(iAparienciaAntigua == APPEARANCE_TYPE_HALFLING) iAparienciaEscogida = 489;
          else if(iAparienciaAntigua == APPEARANCE_TYPE_HALF_ELF) iAparienciaEscogida = 491;
          else if(iAparienciaAntigua == APPEARANCE_TYPE_HALF_ORC) iAparienciaEscogida = 493;
          else if(iAparienciaAntigua == APPEARANCE_TYPE_HUMAN) iAparienciaEscogida = 495;
      }

      DelayCommand(1.5, SetCreatureAppearanceType(oPC, iAparienciaEscogida));


      // 2. Elegimos la apariencia de cola (caballos/ponis del cep no usan esto)
      int iDiferencia;
      int iColaEscogida;

      if(sResRefCaballo == "cab_uninegrocep")
      {
          iDiferencia = iAparienciaCaballo - 3519; //2518
          iColaEscogida = 504 + iDiferencia;
      }
      else if(sResRefCaballo == "cab_uniblancocep")
      {
          iDiferencia = iAparienciaCaballo - 3577; //2576
          iColaEscogida = 491 + iDiferencia;
      }

      else if(sResRefCaballo == "cab_uniblancocl1") iColaEscogida = 2957;
      else if(sResRefCaballo == "cab_uniblancocl2") iColaEscogida = 2956;
      else if(sResRefCaballo == "cab_jabalired") {iColaEscogida = 9997; iSonidosPasos = 1;}
      else if(sResRefCaballo == "cab_jabalired2") {iColaEscogida = 10501; iSonidosPasos = 1;}
      else if(sResRefCaballo == "cab_jabaligrey") {iColaEscogida = 9998; iSonidosPasos = 1;}
      else if(sResRefCaballo == "cab_jabaligrey2") {iColaEscogida = 10500; iSonidosPasos = 1;}
      else if(sResRefCaballo == "cab_jabalinegro") {iColaEscogida = 9999; iSonidosPasos = 1;}
      else if(sResRefCaballo == "cab_jabalinegro2") {iColaEscogida = 10524; iSonidosPasos = 1;}
      else if(sResRefCaballo == "cab_leon") {iColaEscogida = 9995; iSonidosPasos = 1;}
      else if(sResRefCaballo == "cab_leona") {iColaEscogida = 9990; iSonidosPasos = 1;}
      else if(sResRefCaballo == "cab_perro") {iColaEscogida = 9992; iSonidosPasos = 1;}
      else if(sResRefCaballo == "cab_leopardo") {iColaEscogida = 9996;iSonidosPasos = 1;}
      else if(sResRefCaballo == "cab_lagartoverde") {iColaEscogida = 9981; iSonidosPasos = 1;}
      else if(sResRefCaballo == "cab_lagartonaran") {iColaEscogida = 9980; iSonidosPasos = 1;}
      else if(sResRefCaballo == "cab_loboterr") {iColaEscogida = 9983; iSonidosPasos = 1;}
      else if(sResRefCaballo == "cab_huargo") {iColaEscogida = 9993; iSonidosPasos = 1;}
      else if(sResRefCaballo == "cab_jarilith") {iColaEscogida = 9984; iSonidosPasos = 1;}
      else if(sResRefCaballo == "cab_pegasoblanco") {iColaEscogida = 9971;}  //2953
      else if(sResRefCaballo == "cab_pegasonegro") {iColaEscogida = 2939;}
      else if(sResRefCaballo == "cab_pegasomarron") {iColaEscogida = 2940;}
      else if(sResRefCaballo == "cab_cabranegra") {iColaEscogida = 10006;}
      else if(sResRefCaballo == "cab_cabramarron") {iColaEscogida = 10007;}
      else if(sResRefCaballo == "cab_cabramoteada") {iColaEscogida = 10008;}
      else if(sResRefCaballo == "cab_cabrablanca") {iColaEscogida = 10004;}
      else if(sResRefCaballo == "cab_osopolar") {iColaEscogida = 10002;}
      else if(sResRefCaballo == "cab_osomarron") {iColaEscogida = 10030;}
      else if(sResRefCaballo == "cab_osonegro") {iColaEscogida = 10031;}
      else if(sResRefCaballo == "cab_oso") {iColaEscogida = 9975; iSonidosPasos = 1;}
      else if(sResRefCaballo == "cab_ciervo") {iColaEscogida = 9976; iSonidosPasos = 1;}
      else if(sResRefCaballo == "cab_huargoconvo") {iColaEscogida = 9993; iSonidosPasos = 1;}
      else if(sResRefCaballo == "cab_cabnegrconvo") {iColaEscogida = 78; iSonidosPasos = 1;}
      else if(sResRefCaballo == "cab_cabraconvo") {iColaEscogida = 10007;}
      else if(sResRefCaballo == "cab_ciervoconvo") {iColaEscogida = 9976; iSonidosPasos = 1;}

      else if(sResRefCaballo == "cab_blanco169")
      {
          if(iAparienciaCaballo == 3590) iColaEscogida = 9971; //2589
          else if(iAparienciaCaballo == 3591) iColaEscogida = 2962; //2590
          else if(iAparienciaCaballo == 3592) iColaEscogida = 2961; //2591
          else if(iAparienciaCaballo == 3593) iColaEscogida = 2959; //2592
          else if(iAparienciaCaballo == 3594) iColaEscogida = 2963; //2593
          else if(iAparienciaCaballo == 3595) iColaEscogida = 2958; //2594
          else if(iAparienciaCaballo == 3596) iColaEscogida = 2960; //2595
      }

      else if(sResRefCaballo == "cab_muertoviv")
      {
          iSonidosPasos = 8;
          if(iAparienciaCaballo == 1057)  iColaEscogida = 9987;   //3901 4902
          else if(iAparienciaCaballo == 1058) iColaEscogida = 9988;  //3902  4903
          else if(iAparienciaCaballo == 1059) iColaEscogida = 9989;  //3903 4904
      }

      else if(sResRefCaballo == "cab_hipogrifo")
      {
          iSonidosPasos = 1;
          if(iAparienciaCaballo == 4915) iColaEscogida = 5006; //3914
          else if(iAparienciaCaballo == 4916) iColaEscogida = 5004;  //3915
          else if(iAparienciaCaballo == 4917) iColaEscogida = 5005;  //3916
      }

      else if(sResRefCaballo == "cab_grifo")
      {
          iSonidosPasos = 1;
          if(iAparienciaCaballo == 4912) iColaEscogida = 5007;      //3911
          else if(iAparienciaCaballo == 4913) iColaEscogida = 5001; //3912
          else if(iAparienciaCaballo == 4915) iColaEscogida = 5002; //3913
      }
      else if(sResRefCaballo == "cab_grifo2")
      {
          iSonidosPasos = 1;
          if(iAparienciaCaballo == 1163) iColaEscogida = 10003;
          else if(iAparienciaCaballo == 1161) iColaEscogida = 10001;

      }

      else
      {
          iDiferencia = iAparienciaCaballo - 496;
          iColaEscogida = 15 + iDiferencia;
      }

      DelayCommand(1.5, SetCreatureTailType(iColaEscogida, oPC));


      // 3. Elegimos el fenotipo (0=Normal, 1= Bajo, 2=Gordo, 4= Alto, 73=Viejo)
      if(iAnimacionesJustas == TRUE)
      {
          if(iFenotipoAntiguo < 1 || iFenotipoAntiguo == 4 || iFenotipoAntiguo == 73) iFenotipoEscogido = 6;
          else iFenotipoEscogido = 8;
      }
      else
      {
          if(iFenotipoAntiguo < 1 || iFenotipoAntiguo == 4 || iFenotipoAntiguo == 73) iFenotipoEscogido = 3;
          else iFenotipoEscogido = 5;
      }
  }
  else
  {
      // Guardamos persistentemente las apariencias (Parte III)
      if(sResRefCaballo == "cab_palponi") iMontado = 4;
      else iMontado = 2;

      if(iFenotipoAntiguo < 1 || iFenotipoAntiguo == 4 || iFenotipoAntiguo == 73)
      {
          if(sResRefCaballo == "cab_marroncep") iFenotipoEscogido = 17;
          else if(sResRefCaballo == "cab_blancocep") iFenotipoEscogido = 10;
          else if(sResRefCaballo == "cab_negrocep") iFenotipoEscogido = 11;
          else if(sResRefCaballo == "cab_ponimarcep" || sResRefCaballo == "cab_palponi") iFenotipoEscogido = 14;
          else if(sResRefCaballo == "cab_poniblacep") iFenotipoEscogido = 15;
          else if(sResRefCaballo == "cab_ponimotcep") iFenotipoEscogido = 18;
          else if(sResRefCaballo == "cab_aurenthilcep") iFenotipoEscogido = 13;
      }
      else
      {
          if(sResRefCaballo == "cab_marroncep") iFenotipoEscogido = 27;
          else if(sResRefCaballo == "cab_blancocep") iFenotipoEscogido = 30;
          else if(sResRefCaballo == "cab_negrocep") iFenotipoEscogido = 31;
          else if(sResRefCaballo == "cab_ponimarcep") iFenotipoEscogido = 34;
          else if(sResRefCaballo == "cab_poniblacep") iFenotipoEscogido = 35;
          else if(sResRefCaballo == "cab_ponimotcep") iFenotipoEscogido = 28;
          else if(sResRefCaballo == "cab_aurenthilcep") iFenotipoEscogido = 33;
      }
  }

  DelayCommand(1.5, SetPhenoType(iFenotipoEscogido, oPC));

  // 4. Elegimos el sonido de los pasos
  DelayCommand(1.5, SetFootstepType(iSonidosPasos, oPC));

  // Fijamos que estamos montados y puntos golpes temporales
  GuardarIntPersistente(oPC, "CAB_MONTADO", iMontado);

  // 5. Efectos monturas
  int iBonoCon = GetHitDice(OBJECT_SELF)/5 + 2;
  if(iBonoCon <= 0) iBonoCon = 1;
  SetLocalInt(oPC, "CAB_CON_MONTURA", iBonoCon);

  ReaplicarEfectosPB(oPC,TRUE);

  // Animaciones de montarse
  effect eFantasma = EffectCutsceneGhost();
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFantasma, OBJECT_SELF);
  AssignCommand(OBJECT_SELF, ActionJumpToObject(oPC));
  AssignCommand(oPC, ActionPlayAnimation(41, 0.4, 2.0));
  float fOrientacionPJ = GetFacing(oPC);
  DelayCommand(0.5, AssignCommand(OBJECT_SELF, SetFacing(fOrientacionPJ)));
  DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), OBJECT_SELF));
  DelayCommand(2.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDisappear(), OBJECT_SELF));

  // Guardamos la vida del caballo y el retrato
  GuardarIntPersistente(oPC, "CABVIDA", GetCurrentHitPoints(OBJECT_SELF));
  GuardarStringPersistente(oPC, "CABRETRATO", GetPortraitResRef(OBJECT_SELF));

  // Guardamos el PJ
  DelayCommand(3.0, ExportSingleCharacter(oPC));
}

void MonturasDesmontarse(object oPC, object oObjetoMontura)
{
  // Aplicamos apariencia, cola, alas, fenotipo y sonidos de pasos guardados
  int iMontado = ObtenerIntPersistente(oPC, "CAB_MONTADO");
  if(iMontado == 1 || iMontado == 3)
  {
      int iAparienciaguardada = ObtenerIntPersistente(oPC, "CABAPARIENCIA");
      int iColaGuardada = ObtenerIntPersistente(oPC, "CABCOLA");
      SetCreatureAppearanceType(oPC, iAparienciaguardada);
      SetCreatureTailType(iColaGuardada, oPC);

      object oHabilidadMonturaVuelo = GetItemPossessedBy(oPC, "cab_volar");
      if(GetIsObjectValid(oHabilidadMonturaVuelo))
      {
          if(GetLocalInt(oHabilidadMonturaVuelo, "CABPEGASOBLANCO") == FALSE)
          {
              int iAlasGuardadas = ObtenerIntPersistente(oPC, "CABALAS");
              SetCreatureWingType(iAlasGuardadas, oPC);
          }

          DestroyObject(oHabilidadMonturaVuelo);
      }
  }

  int iFenotipoGuardado = ObtenerIntPersistente(oPC, "CABFENTIPO");
  int iSonidosPasosGuardados = ObtenerIntPersistente(oPC, "CABSONIDOSPASOS");
  SetPhenoType(iFenotipoGuardado, oPC);
  SetFootstepType(iSonidosPasosGuardados, oPC);

  // Eliminamos el estado de montado
  GuardarIntPersistente(oPC, "CAB_MONTADO", 0);

  // Aparece la montura y te sigue
  string sResrefMontura = ObtenerStringPersistente(oPC, "CABRESREF1");
  int iAparienciaMontura = ObtenerIntPersistente(oPC, "CABRESREF2");
  object oMontura = CreateObject(OBJECT_TYPE_CREATURE, sResrefMontura, GetLocation(oPC));
  SetCreatureAppearanceType(oMontura, iAparienciaMontura);
  AddHenchman(oPC, oMontura);

  // Amo y nombre de la montura
  SetLocalString(oMontura, "AMO", GetName(oPC, TRUE));
  string sNombre = GetLocalString(oObjetoMontura, "CABNOMBRE");
  if(sNombre != "") SetName(oMontura, sNombre);

  // Subimos de nivel a la montura
  int iNivelMontura = GetLocalInt(oObjetoMontura, "NIVELMONTURA");
  int iClaseNivel = GetClassByPosition(1, oMontura);
  while(iNivelMontura != 1)
  {
      LevelUpHenchman(oMontura, iClaseNivel);
      iNivelMontura = iNivelMontura - 1;
  }

  // Nombre del propietario del animal
  SetDescription(oMontura, GetDescription(oMontura) + "\n\n<c ~ >Propietario: </c>" + ObtenerStringPersistente(oPC,"Disfrazado_nombre"));

  // Sonidos de pasos montura
  if(VerSiDebeTenerSonidoCaballo(oMontura)) DelayCommand(1.5, SetFootstepType(17, oMontura));
  else DelayCommand(1.5, SetFootstepType(1, oMontura));

  // Guardamos la montura (por si tiene que desaparecer al establecerla como muerte)
  SetLocalObject(oPC, "CAB_MONTURAGUARDADA", oMontura);

  // Aplicamos la vida del caballo
  effect eDanyo = EffectDamage(GetMaxHitPoints(oMontura) - ObtenerIntPersistente(oPC, "CABVIDA"));
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eDanyo, oMontura);
  GuardarIntPersistente(oPC, "CABVIDA", 0);

  // Aplicamos el retrato al caballo
  string sRetratoMontura = ObtenerStringPersistente(oPC, "CABRETRATO");
  if(sRetratoMontura != "") SetPortraitResRef(oMontura, sRetratoMontura);
  GuardarStringPersistente(oPC, "CABRETRATO", "");

  // Eliminar efectos monturas
  ReaplicarEfectosPB(oPC,TRUE);
}

void MonturasGuardar(object oPC, object oCaballoUsado)
{
  // Desactivamos el caballo
  SetItemCursedFlag(oCaballoUsado, FALSE);

  // Animaciones
  object oMontura = GetHenchman(oPC);
  if(GetTag(GetHenchman(oPC, 2)) == "cab_montura") oMontura = GetHenchman(oPC, 2);
  else if(GetTag(GetHenchman(oPC, 3)) == "cab_montura") oMontura = GetHenchman(oPC, 3);

  RemoveHenchman(oPC, oMontura);
  AssignCommand(oPC, SpeakString("* Guardas tu montura en el establo *"));
  location lLugarEstablo = GetLocation(GetWaypointByTag(GetTag(GetArea(oPC)) + "establo"));
  DelayCommand(1.9, AssignCommand(oMontura, ClearAllActions(TRUE)));
  DelayCommand(2.0, AssignCommand(oMontura, ActionMoveToLocation(lLugarEstablo, TRUE)));
  DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDisappear(), oMontura));

  // Eliminar amo
  DeleteLocalString(oMontura, "AMO");

  // Guardamos el PJ
  DelayCommand(3.0, ExportSingleCharacter(oPC));
}

void MorirEncimaDeMontura(object oPC)
{
  // Aplicamos apariencia, cola, fenotipo y sonidos de pasos guardados
  int iMontado = ObtenerIntPersistente(oPC, "CAB_MONTADO");

  if(iMontado == 0) return;

  if(iMontado == 1 || iMontado == 3)
  {
      int iAparienciaguardada = ObtenerIntPersistente(oPC, "CABAPARIENCIA");
      int iColaGuardada = ObtenerIntPersistente(oPC, "CABCOLA");
      SetCreatureAppearanceType(oPC, iAparienciaguardada);
      SetCreatureTailType(iColaGuardada, oPC);

      object oHabilidadMonturaVuelo = GetItemPossessedBy(oPC, "cab_volar");
      if(GetIsObjectValid(oHabilidadMonturaVuelo))
      {
          if(GetLocalInt(oHabilidadMonturaVuelo, "CABPEGASOBLANCO") == FALSE)
          {
              int iAlasGuardadas = ObtenerIntPersistente(oPC, "CABALAS");
              SetCreatureWingType(iAlasGuardadas, oPC);
          }

          DestroyObject(oHabilidadMonturaVuelo);
      }
  }

  int iFenotipoGuardado = ObtenerIntPersistente(oPC, "CABFENTIPO");
  int iSonidosPasosGuardados = ObtenerIntPersistente(oPC, "CABSONIDOSPASOS");
  SetPhenoType(iFenotipoGuardado, oPC);
  SetFootstepType(iSonidosPasosGuardados, oPC);

  // Eliminamos el estado de montado
  GuardarIntPersistente(oPC, "CAB_MONTADO", 0);
}
