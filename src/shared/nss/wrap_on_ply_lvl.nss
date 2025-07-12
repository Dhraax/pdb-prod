//::////////////////////////////////////////////////////////////////////////////
//:: Nombre del guión:  wrap_on_ply_lvl                                   //:://
//::////////////////////////////////////////////////////////////////////////////
//:: GUION ON_PLAYER_LEVEL_UP PARA EL SERVIDOR PUERTA DE BALDUR           //:://
//:: Creado por Monti                                                     //:://
//::////////////////////////////////////////////////////////////////////////////

#include "f_vampire_lvlup"
//#include "idiomas_inc"
#include "nwnx_creature"
#include "dominios_inc"
#include "nw_i0_plot"
#include "pb_constantes"
#include "pb_inc_mmf"

//Baja el nivel dejando al PJ a 1 punto de subir de nuevo.
void BajarNivelQuedandoseA1XP(object oPC);
void BajarNivelQuedandoseA1XP(object oPC)
{
  int iPrevXP = GetXP(oPC);
  int iXP;
  switch(GetHitDice(oPC))
  {
      case 2: iXP = 999; break;
      case 3: iXP = 2999; break;
      case 4: iXP = 5999; break;
      case 5: iXP = 9999; break;
      case 6: iXP = 14999; break;
      case 7: iXP = 20999; break;
      case 8: iXP = 27999; break;
      case 9: iXP = 359999; break;
      case 10: iXP = 44999; break;
      case 11: iXP = 54999; break;
      case 12: iXP = 65999; break;
      case 13: iXP = 77999; break;
      case 14: iXP = 90999; break;
      case 15: iXP = 104999; break;
      case 16: iXP = 119999; break;
      case 17: iXP = 135999; break;
      case 18: iXP = 152999; break;
      case 19: iXP = 170999; break;
      case 20: iXP = 189999; break;
      case 21: iXP = 209999; break;
      case 22: iXP = 230999; break;
      case 23: iXP = 252999; break;
      case 24: iXP = 275999; break;
      case 25: iXP = 299999; break;
      case 26: iXP = 324999; break;
      case 27: iXP = 350999; break;
      case 28: iXP = 377999; break;
      case 29: iXP = 405999; break;
      case 30: iXP = 434999; break;
      case 31: iXP = 464999; break;
      case 32: iXP = 495999; break;
      case 33: iXP = 527999; break;
      case 34: iXP = 560999; break;
      case 35: iXP = 594999; break;
      case 36: iXP = 629999; break;
      case 37: iXP = 665999; break;
      case 38: iXP = 702999; break;
      case 39: iXP = 740999; break;
      case 40: iXP = 779999; break;
      default: iXP = GetXP(oPC); break;
  }
  //Bajamos el nivel.
  SetXP(oPC, iXP);
  //Le metemos la PX que tenía antes de bajarle el nivel.
  SetXP(oPC, iPrevXP);
}

void main()
{
  object oPC  = GetPCLevellingUp();
  int iNivel = GetHitDice(oPC);
  int iExperiencia = GetXP(oPC);

  //MAESTRO MULTIPLES FORMAS
    MMFLevelUpManagement(oPC);

  // 0. LOG, aviso de subida de nivel
  WriteTimestampedLogEntry("Informe: El PJ: " + GetName(oPC) + " de la cuenta: "
  + GetPCPlayerName(oPC) + " ha subido al nivel: " + IntToString(GetHitDice(oPC)) + ".");

  // 1. RESTRICCIONES
  // 1.1 No se pueden guardar mas de 4 puntos de habilidad
  if(NWNX_Creature_GetSkillPointsRemaining(oPC) > 4)
  {
      BajarNivelQuedandoseA1XP(oPC);
      SendMessageToPC(oPC, "<cþ<<>¡No puedes guardar más de 4 puntos de habilidad al subir de nivel!</c>");
      return;
  }

  // 1.2 Requisitos de Estilos de combate activados una vez por PJ
  int iNivelExplorador = GetLevelByClass(CLASS_TYPE_RANGER, oPC);
  if(iNivelExplorador >= 3)
  {
      if(iNivelExplorador == 3 && GetHasFeat(1314, oPC) == TRUE)
      {
          BajarNivelQuedandoseA1XP(oPC);
          SendMessageToPC(oPC, "<cþ<<>¡Debes escoger un estilo de combate antes de subir al nivel 3º de explorador! Usa la dote 'Estilo de combate' de tu menú radial.</c>");
          return;
      }
      else if(iNivelExplorador == 7 && GetHasFeat(1317, oPC) == TRUE)
      {
          BajarNivelQuedandoseA1XP(oPC);
          SendMessageToPC(oPC, "<cþ<<>¡Debes activar una vez el estilo de combate mejorado antes de subir al nivel 7º de explorador! Usa la dote 'Estilo de combate mejorado' de tu menú radial.</c>");
          return;
      }
      else if(iNivelExplorador == 12 && GetHasFeat(1321, oPC) == TRUE)
      {
          BajarNivelQuedandoseA1XP(oPC);
          SendMessageToPC(oPC, "<cþ<<>¡Debes activar una vez la maestría con el estilo de combate antes de subir al nivel 12º de explorador! Usa la dote 'Maestría con el estilo de combate' de tu menú radial.</c>");
          return;
      }
  }

  // 1.3 Correccion del Bug del DD en niveles epicos
  // Aunque poco probable que suceda, un PJ discipulo de dragon de nivel 14 en adelante
  // podria pillar una segunda dote de 'tipo de dragon escogido'. Se crea este
  // pequenyo parche para evitarlo
  if(GetLevelByClass(37, oPC) > 13)
  {
      int iTiposDragonEncontrados = 0;
      int iDoteTipoDragon = 1330;
      while(iDoteTipoDragon <= 1353)
      {
          if(GetHasFeat(iDoteTipoDragon, oPC)) iTiposDragonEncontrados++;
          if(iDoteTipoDragon == 1339) iDoteTipoDragon = 1343;
          else iDoteTipoDragon++;
      }

      if(iTiposDragonEncontrados > 1)
      {
          BajarNivelQuedandoseA1XP(oPC);
          SendMessageToPC(oPC, "<cþ<<>No puedes elegir una nueva dote de 'Tipo de dragón'. Se te ha bajado un nivel.</c>");
          return;
      }
  }

  // 1.4 Bloqueos de nivel
  // Se mantiene un 25% de la XP del siguiente nivel como mucho
  /*if(iNivel == 6) // Nivel 6
  {
      if(GetCampaignInt("DESBLOQUEO", "NIVEL6", oPC) == 0)
      {
          SetXP(oPC, 14999);
          SendMessageToPC(oPC, ColorTexto("No puedes subir de nivel debido al bloqueo de nivel 6. Por favor, contacta con un DM o lee tu diario o manual del servidor para obtener el permiso", TXT_COLOR_ROJO));
          return;
      }
      else if(iExperiencia > 16500) SetXP(oPC, 16500); 1500
  }

  else if(iNivel == 11) // Nivel 11
  {
      if(GetCampaignInt("DESBLOQUEO", "NIVEL11", oPC) == 0)
      {
          SetXP(oPC, 54999);
          SendMessageToPC(oPC, ColorTexto("No puedes subir de nivel debido al bloqueo de nivel 11. Por favor, contacta con un DM o lee tu diario o manual del servidor para obtener el permiso", TXT_COLOR_ROJO));
          return;
      }
      else if(iExperiencia > 57750) SetXP(oPC, 57750); 2750
  }

  else if(iNivel == 16) // Nivel 16
  {
      if(GetCampaignInt("DESBLOQUEO", "NIVEL16", oPC) == 0)
      {
          SetXP(oPC, 119999);
          SendMessageToPC(oPC, ColorTexto("No puedes subir de nivel debido al bloqueo de nivel 16. Por favor, contacta con un DM o lee tu diario o manual del servidor para obtener el permiso", TXT_COLOR_ROJO));
          return;
      }
      else if(iExperiencia > 124000) SetXP(oPC, 124000);4000
  }

  else if(iNivel == 21) // Nivel 21
  {
      if(GetCampaignInt("DESBLOQUEO", "NIVEL21", oPC) == 0)
      {
          SetXP(oPC, 209999);
          SendMessageToPC(oPC, ColorTexto("No puedes subir de nivel debido al bloqueo de nivel 21. Por favor, contacta con un DM o lee tu diario o manual del servidor para obtener el permiso", TXT_COLOR_ROJO));
          return;
      }
      else if(iExperiencia > 215250) SetXP(oPC, 215250);
  }

  else if(iNivel == 26) // Nivel 26
  {
      if(GetCampaignInt("DESBLOQUEO", "NIVEL26", oPC) == 0)
      {
          SetXP(oPC, 324999);
          SendMessageToPC(oPC, ColorTexto("No puedes subir de nivel debido al bloqueo de nivel 26. Por favor, contacta con un DM o lee tu diario o manual del servidor para obtener el permiso", TXT_COLOR_ROJO));
          return;
      }
      else if(iExperiencia > 357500) SetXP(oPC, 357500);
  }

  // Nivel 30
  else if(iNivel == 30)
  {
      if(GetCampaignInt("DESBLOQUEO", "NIVEL30", oPC) == 0)
      {
          SetXP(oPC, 434999);
          SendMessageToPC(oPC, ColorTexto("No puedes subir de nivel debido al bloqueo de nivel 30. Por favor, contacta con un DM o lee tu diario o manual del servidor para obtener el permiso", TXT_COLOR_ROJO));
          return;
      }
      else if(iExperiencia > 478500) SetXP(oPC, 478500);
  }

  // Nivel 35
  else if(GetHitDice(oPC) == 35 && GetCampaignInt("DESBLOQUEO", "NIVEL35", oPC) == 0)
  {
      SetXP(oPC, 594999);
      SendMessageToPC(oPC, ColorTexto("No puedes subir de nivel debido al bloqueo de nivel 35. Por favor, contacta con un DM o lee tu diario o manual del servidor para obtener el permiso", TXT_COLOR_ROJO));
      return;
  }  */

  if(iNivel == 9) // Nivel 9
  {
      if(GetCampaignInt("DESBLOQUEO", "NIVEL9", oPC) == 0)
      {
          SetXP(oPC, 35999);
          SendMessageToPC(oPC, ColorTexto("No puedes subir de nivel debido al bloqueo de nivel 9. Por favor, contacta con un DM o lee tu diario o manual del servidor para obtener el permiso", TXT_COLOR_ROJO));
          return;
      }
      else if(iExperiencia > 36900) SetXP(oPC, 36900);
  }

  else if(iNivel == 13) // Nivel 13
  {
      if(GetCampaignInt("DESBLOQUEO", "NIVEL13", oPC) == 0)
      {
          SetXP(oPC, 77999);
          SendMessageToPC(oPC, ColorTexto("No puedes subir de nivel debido al bloqueo de nivel 13. Por favor, contacta con un DM o lee tu diario o manual del servidor para obtener el permiso", TXT_COLOR_ROJO));
          return;
      }
      else if(iExperiencia > 79950) SetXP(oPC, 79950);
  }

  else if(iNivel == 17) // Nivel 17
  {
      if(GetCampaignInt("DESBLOQUEO", "NIVEL17", oPC) == 0)
      {
          SetXP(oPC, 135999);
          SendMessageToPC(oPC, ColorTexto("No puedes subir de nivel debido al bloqueo de nivel 17. Por favor, contacta con un DM o lee tu diario o manual del servidor para obtener el permiso", TXT_COLOR_ROJO));
          return;
      }
      else if(iExperiencia > 139400) SetXP(oPC, 139400);
  }

  else if(iNivel == 21) // Nivel 21
  {
      if(GetCampaignInt("DESBLOQUEO", "NIVEL21", oPC) == 0)
      {
          SetXP(oPC, 209999);
          SendMessageToPC(oPC, ColorTexto("No puedes subir de nivel debido al bloqueo de nivel 21. Por favor, contacta con un DM o lee tu diario o manual del servidor para obtener el permiso", TXT_COLOR_ROJO));
          return;
      }
      else if(iExperiencia > 215250) SetXP(oPC, 215250);
  }
  else if(iNivel == 22) // Nivel 22
  {
      if(GetCampaignInt("DESBLOQUEO", "NIVEL22", oPC) == 0)
      {
          SetXP(oPC, 230999);
          SendMessageToPC(oPC, ColorTexto("No puedes subir de nivel debido al bloqueo de nivel 22. Por favor, contacta con un DM o lee tu diario o manual del servidor para obtener el permiso", TXT_COLOR_ROJO));
          return;
      }
      else if(iExperiencia > 236775) SetXP(oPC, 236775);
  }
  else if(iNivel == 24) // Nivel 24
  {
      if(GetCampaignInt("DESBLOQUEO", "NIVEL24", oPC) == 0)
      {
          SetXP(oPC, 275999);
          SendMessageToPC(oPC, ColorTexto("No puedes subir de nivel debido al bloqueo de nivel 24. Por favor, contacta con un DM o lee tu diario o manual del servidor para obtener el permiso", TXT_COLOR_ROJO));
          return;
      }
      else if(iExperiencia > 282900) SetXP(oPC, 282900);
  }
  else if(iNivel == 26) // Nivel 26
  {
      if(GetCampaignInt("DESBLOQUEO", "NIVEL26", oPC) == 0)
      {
          SetXP(oPC, 324999);
          SendMessageToPC(oPC, ColorTexto("No puedes subir de nivel debido al bloqueo de nivel 26. Por favor, contacta con un DM o lee tu diario o manual del servidor para obtener el permiso", TXT_COLOR_ROJO));
          return;
      }
      else if(iExperiencia > 331500) SetXP(oPC, 331500);
  }

  // Nivel 30
  else if(iNivel == 30)
  {
      if(GetCampaignInt("DESBLOQUEO", "NIVEL30", oPC) == 0)
      {
          SetXP(oPC, 434999);
          SendMessageToPC(oPC, ColorTexto("No puedes subir de nivel debido al bloqueo de nivel 30. Por favor, contacta con un DM o lee tu diario o manual del servidor para obtener el permiso", TXT_COLOR_ROJO));
          return;
      }
      else if(iExperiencia > 478500) SetXP(oPC, 478500);
  }

  // Nivel 35
  else if(GetHitDice(oPC) == 35 && GetCampaignInt("DESBLOQUEO", "NIVEL35", oPC) == 0)
  {
      SetXP(oPC, 594999);
      SendMessageToPC(oPC, ColorTexto("No puedes subir de nivel debido al bloqueo de nivel 35. Por favor, contacta con un DM o lee tu diario o manual del servidor para obtener el permiso", TXT_COLOR_ROJO));
      return;
  }


  // 2. HABILIDADES
  // 2.1 Dar hablidad de foco divino
  object oHabilidad = GetItemPossessedBy(oPC, "mti_elegfoco");
  if(GetIsObjectValid(oHabilidad) != TRUE &&
    (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0 ||
     GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oPC) > 0 ||
     GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0  ||
     GetLevelByClass(CLASS_TYPE_PALADIN, oPC) > 0 ||
     GetLevelByClass(CLASS_TYPE_PAL_ANTIGUO, oPC) > 0  ||
     GetLevelByClass(CLASS_TYPE_PAL_OSCURO, oPC) > 0  ||
     GetLevelByClass(CLASS_TYPE_PAL_VENGADOR, oPC) > 0)) CreateItemOnObject("mti_elegfoco", oPC);

  // 2.2 Dar el levitar de los drows
  if((GetRacialType(oPC) == RACIAL_TYPE_DROW) && GetHitDice(oPC) >= 11 &&
     GetIsObjectValid(GetItemPossessedBy(oPC, "levitar")) == FALSE)
     CreateItemOnObject("levitar", oPC);

  if(GetRacialType(oPC) == RACIAL_TYPE_DROW_BASICO && GetHitDice(oPC) >= 13 &&
     GetIsObjectValid(GetItemPossessedBy(oPC, "levitar")) == FALSE)
     CreateItemOnObject("levitar", oPC);

  // 2.3 Dar libro de convocaciones
  object oConvocaciones = GetItemPossessedBy(oPC, "librodeconvocaci");
  if(GetIsObjectValid(oConvocaciones) != TRUE &&
    (GetLevelByClass(CLASS_TYPE_SORCERER, oPC) > 0 ||
     GetLevelByClass(CLASS_TYPE_WIZARD, oPC) > 0   ||
     GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0   ||
     GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0    ||
     GetLevelByClass(CLASS_TYPE_BARD, oPC) > 0     ||
     GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) > 0)) CreateItemOnObject("librodeconvocaci", oPC);

  // 2.4 Dominios de clerigo, dar o quitar objetos y dotes según sea el caso
  ConjurosDominios(oPC);

    // 2.5 Idiomas cláseos, dar o quitar objetos y dotes según sea el caso
    //IdiomasAutomaticosClaseos(oPC);
    // DRUIDAS
    if(GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0 && !GetIsObjectValid(GetItemPossessedBy(oPC, "hlslang_79")))
    {
        // Dar idioma druida
        CreateItemOnObject("hlslang_79", oPC);
    }
    if(GetLevelByClass(CLASS_TYPE_ROGUE, oPC) > 0 && !GetIsObjectValid(GetItemPossessedBy(oPC, "hlslang_9")))
    {
        // Dar idioma argot de los ladrones
        CreateItemOnObject("hlslang_9", oPC);
    }

  if(GetHasFeat(1298, oPC)) // Dominio enano, gran fortaleza
  {
      if(!GetHasFeat(FEAT_GREAT_FORTITUDE, oPC)) NWNX_Creature_AddFeatByLevel(oPC, FEAT_GREAT_FORTITUDE, iNivel);
  }
  if(GetHasFeat(1299, oPC)) // Dominio elfico, disparo a bocajarro
  {
      if(!GetHasFeat(FEAT_POINT_BLANK_SHOT, oPC)) NWNX_Creature_AddFeatByLevel(oPC, FEAT_POINT_BLANK_SHOT, iNivel);
  }

  //Si se mete ambidiextro o combate  con dos armas, se te regala la faltante.
  if(GetHasFeat(1, oPC) && !GetHasFeat(41, oPC))
  {
        NWNX_Creature_AddFeatByLevel(oPC, 41, iNivel);
        SendMessageToPC(oPC, "<c´þd>¡Has adquirido la dote Combate con dos armas gratuitamente!</c>");
  }
  if(!GetHasFeat(1, oPC) && GetHasFeat(41, oPC))
  {
        NWNX_Creature_AddFeatByLevel(oPC, 1, iNivel);
        SendMessageToPC(oPC, "<c´þd>¡Has adquirido la dote Ambidiestro gratuitamente!</c>");
  }

  // 2.6 Garras y mordiscos de Discipulo de Dragon
  object oDDGarras1  = GetItemPossessedBy(oPC, "dradis_garras1");
  if(GetHasFeat(1341, oPC))
  {
      if(!GetIsObjectValid(oDDGarras1))  // Si se tiene la dote y NO se tienen las garras, se crean y se equipan
      {
          object oDDGarras1  = CreateItemOnObject("nw_it_crewpsp005", oPC, 1, "dradis_garras1");
          object oDDGarras2  = CreateItemOnObject("nw_it_crewpsp005", oPC, 1, "dradis_garras2");
          object oDDMordisco = CreateItemOnObject("nw_it_crewps002", oPC, 1, "dradis_mordisco");
          SetIdentified(oDDGarras1, TRUE);
          SetIdentified(oDDGarras2, TRUE);
          SetIdentified(oDDMordisco, TRUE);
          SetPlotFlag(oDDGarras1, TRUE);
          SetPlotFlag(oDDGarras2, TRUE);
          SetPlotFlag(oDDMordisco, TRUE);
          SetItemCursedFlag(oDDGarras1, TRUE);
          SetItemCursedFlag(oDDGarras2, TRUE);
          SetItemCursedFlag(oDDMordisco, TRUE);
          SetName(oDDGarras1, "<cÈª`>Garras dracónicas</c>");
          SetName(oDDGarras2, "<cÈª`>Garras dracónicas</c>");
          SetName(oDDMordisco, "<cÈª`>Mordisco dracónico</c>");
          SetDescription(oDDGarras1, "<cÈª`>Este objeto son tus 'garras' de discípulo de dragón, si se te desequipara por error puedes equipártelo fácilmente moviéndolo a un acceso directo y haciendo Click izquierdo sobre él.</c>");
          SetDescription(oDDGarras2, "<cÈª`>Este objeto son tus 'garras' de discípulo de dragón, si se te desequipara por error puedes equipártelo fácilmente moviéndolo a un acceso directo y haciendo Click izquierdo sobre él.</c>");
          SetDescription(oDDMordisco, "<cÈª`>Este objeto es tu 'mordisco' de discípulo de dragón, si se te desequipara por error puedes equipártelo fácilmente moviéndolo a un acceso directo y haciendo Click izquierdo sobre él.</c>");
          AssignCommand(oPC, ClearAllActions());
          AssignCommand(oPC, ActionEquipItem(oDDGarras1, INVENTORY_SLOT_CWEAPON_L));
          AssignCommand(oPC, ActionEquipItem(oDDGarras2, INVENTORY_SLOT_CWEAPON_R));
          AssignCommand(oPC, ActionEquipItem(oDDMordisco, INVENTORY_SLOT_CWEAPON_B));
      }
      else
      {
          object oEquipGarras =  GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
          if(!GetIsObjectValid(oEquipGarras)) // Si se tiene la dote y tienen las garras sin equipar, se equipan
          {
              object oDDGarras1  = GetItemPossessedBy(oPC, "dradis_garras1");
              object oDDGarras2  = GetItemPossessedBy(oPC, "dradis_garras2");
              object oDDMordisco = GetItemPossessedBy(oPC, "dradis_mordisco");
              AssignCommand(oPC, ClearAllActions());
              AssignCommand(oPC, ActionEquipItem(oDDGarras1, INVENTORY_SLOT_CWEAPON_L));
              AssignCommand(oPC, ActionEquipItem(oDDGarras2, INVENTORY_SLOT_CWEAPON_R));
              AssignCommand(oPC, ActionEquipItem(oDDMordisco, INVENTORY_SLOT_CWEAPON_B));
          }
      }

  }
  else // Si no se tiene la dote y SI se tiene las garras, se eliminan (p.e. bajar de nivel y subir en otra cosa)
  {

      if(GetIsObjectValid(oDDGarras1))
      {
          object oDDGarras2  = GetItemPossessedBy(oPC, "dradis_garras2");
          object oDDMordisco = GetItemPossessedBy(oPC, "dradis_mordisco");
          DestroyObject(oDDGarras1, 0.1);
          DestroyObject(oDDGarras2, 0.1);
          DestroyObject(oDDMordisco, 0.1);
      }
  }

  // 2.7 Alas de Discipulo de Dragon
  if(GetLevelByClass(37, oPC) == 9)
  {
      int iTipoAlas;
      if(GetHasFeat(1330, oPC) || GetHasFeat(1345, oPC) || GetHasFeat(1348, oPC) || GetHasFeat(1349, oPC)) iTipoAlas = 67;
      else if(GetHasFeat(1331, oPC) || GetHasFeat(1353, oPC)) iTipoAlas = 64;
      else if(GetHasFeat(1332, oPC)) iTipoAlas = 65;
      else if(GetHasFeat(1334, oPC) || GetHasFeat(1344, oPC)) iTipoAlas = 66;
      else if(GetHasFeat(1335, oPC)) iTipoAlas = 62;
      else if(GetHasFeat(1336, oPC)) iTipoAlas = 60;
      else if(GetHasFeat(1337, oPC) || GetHasFeat(1343, oPC)) iTipoAlas = 61;
      else if(GetHasFeat(1338, oPC) || GetHasFeat(1351, oPC)) iTipoAlas = 63;
      else if(GetHasFeat(1339, oPC)) iTipoAlas = 59;
      else if(GetHasFeat(1346, oPC)) iTipoAlas = 17;
      else if(GetHasFeat(1347, oPC) || GetHasFeat(1352, oPC)) iTipoAlas = 18;
      else /*if(GetHasFeat(1333, oPC) || GetHasFeat(1350, oPC))*/ iTipoAlas = 68;

      SetCreatureWingType(iTipoAlas, oPC);
      SendMessageToPC(oPC, "<c´þd>¡Te han salido alas dracónicas!</c>");
      if(!GetIsObjectValid(GetItemPossessedBy(oPC, "crr_vuelo2"))) CreateItemOnObject("crr_vuelo2", oPC);
 }

  // 2.8 Inmunidad de Discipulo de Dragon
  if(GetLevelByClass(37, oPC) == 10)
  {
      int iDote;
      int iDote2 = FALSE;
      string sInmunidad;
      if(GetHasFeat(1330, oPC) || GetHasFeat(1336, oPC) || GetHasFeat(1345, oPC) || GetHasFeat(1349, oPC)) { iDote = 572; sInmunidad = "daño de electricidad"; }
      else if(GetHasFeat(1331, oPC) || GetHasFeat(1335, oPC) || GetHasFeat(1348, oPC) || GetHasFeat(1353, oPC)) { iDote = 542; sInmunidad = "daño de frío"; }
      else if(GetHasFeat(1332, oPC) || GetHasFeat(1334, oPC) || GetHasFeat(1337, oPC) || GetHasFeat(1346, oPC)) { iDote = 552; sInmunidad = "daño de ácido"; }
      else if(GetHasFeat(1343, oPC) || GetHasFeat(1344, oPC) || GetHasFeat(1347, oPC)) { iDote = 582; sInmunidad = "daño sónico"; }
      else if(GetHasFeat(1350, oPC)) { iDote = 557; iDote = 577; sInmunidad = "50% daño de fuego y 50% daño sónico."; }
      else if(GetHasFeat(1351, oPC)) { iDote = 209; iDote = 219; sInmunidad = "veneno y enfermedades"; }
      else if(GetHasFeat(1352, oPC)) { iDote = 219; sInmunidad = "enfermedades"; }
      else /*if(GetHasFeat(1333, oPC) || GetHasFeat(1338, oPC) || GetHasFeat(1339, oPC))*/ { iDote = 964; sInmunidad = "daño de fuego"; }

      if(iDote2 == FALSE) NWNX_Creature_AddFeatByLevel(oPC, iDote, iNivel);
      else { NWNX_Creature_AddFeatByLevel(oPC, iDote, iNivel); NWNX_Creature_AddFeatByLevel(oPC, iDote2, iNivel); }
      SendMessageToPC(oPC, "<c´þd>Plantilla de semidragón aplicada, se te ha otorgado la inmunidad correspondiente: '" + sInmunidad + "'.</c>");
  }


  //2.9 Items de Brujo para multiclases
    object oInvocaciones = GetItemPossessedBy(oPC, "invocaciones");
    object oBrujoVarita = GetItemPossessedBy(oPC, "var_borrar");
    //Si ya no eres Brujo, adios items.
    if(GetIsObjectValid(oInvocaciones) && (!GetLevelByClass(57, oPC)))
    DestroyObject(oInvocaciones, 0.1);
    if(GetIsObjectValid(oBrujoVarita) && (!GetHasFeat(1498, oPC)))
    DestroyObject(oBrujoVarita, 0.1);
    //Añadimos si no lo tenemos y cumplimos el nivel de brujo
    if(GetIsObjectValid(oInvocaciones) != TRUE && (GetLevelByClass(57, oPC) == 1 )) CreateItemOnObject("invocaciones", oPC);
    if(GetIsObjectValid(oBrujoVarita)  != TRUE && (NWNX_Creature_GetKnowsFeat(oPC, 1498))) CreateItemOnObject("var_borrar", oPC);

  // 3.0 Reaplicar efectos subrazas
  ReaplicarEfectosPB(oPC,TRUE, FALSE, TRUE);
  VampireLevelUp(oPC, TRUE);

 //3.1 Alas Alma Predilecta
  if(GetLevelByClass(59, oPC) == 17)
  {
      int iTipoAlas;
      int iAlineamiento = GetAlignmentGoodEvil(oPC);
      switch (iAlineamiento)
      {
       case ALIGNMENT_GOOD: iTipoAlas = CREATURE_WING_TYPE_ANGEL;break;
       case ALIGNMENT_NEUTRAL:  iTipoAlas = CREATURE_WING_TYPE_ANGEL; break;
       case ALIGNMENT_EVIL:  iTipoAlas = CREATURE_WING_TYPE_DEMON;break;
      }

      SetCreatureWingType(iTipoAlas, oPC);
      SendMessageToPC(oPC, "<c´þd>¡Te han salido alas!</c>");
      if(!GetIsObjectValid(GetItemPossessedBy(oPC, "crr_vuelo2"))) CreateItemOnObject("crr_vuelo2", oPC);
 }

    //3.2 Equipamiento del Artífice.
    if(GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) >= 3)
    {
        //Si no tiene los objetos por lo que sea, se los damos.
        //Artillero.
        if(ObtenerIntPersistente(oPC,"CLS_ING_TIPO") == 1 && !GetIsObjectValid(GetItemPossessedBy(oPC, "cls_ing_item1")))
        {
            CreateItemOnObject("cls_ing_item1", oPC);
        }
        //Armero.
        else if(ObtenerIntPersistente(oPC,"CLS_ING_TIPO") == 2 && !GetIsObjectValid(GetItemPossessedBy(oPC, "cls_ing_item2")))
        {
            CreateItemOnObject("cls_ing_item2", oPC);
        }
        //Alquimista.
        else if(ObtenerIntPersistente(oPC,"CLS_ING_TIPO") == 4 && !GetIsObjectValid(GetItemPossessedBy(oPC, "cls_ing_item4")))
        {
            CreateItemOnObject("cls_ing_item4", oPC);
            object oCinto = GetItemInSlot(INVENTORY_SLOT_BELT, oPC);
        }
        //Guardaconjuros.
        if(GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) >= 16)
        {
            if(!GetIsObjectValid(GetItemPossessedBy(oPC, "cls_ing_item5")))
            {
                CreateItemOnObject("cls_ing_item5", oPC);
            }
        }
    }
    //Si se es menos de nivel 8 de Artífice y se tiene alguno de los items, los borramos.
    else if(GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) < 3)
    {
        //Artillero.
        if(GetIsObjectValid(GetItemPossessedBy(oPC, "cls_ing_item1")) || GetIsObjectValid(GetItemPossessedBy(oPC, "cls_ing_item2")) || GetIsObjectValid(GetItemPossessedBy(oPC, "cls_ing_item4")))
        {
            DestroyObject(GetItemPossessedBy(oPC, "cls_ing_item1"));
            DestroyObject(GetItemPossessedBy(oPC, "cls_ing_item2"));
            DestroyObject(GetItemPossessedBy(oPC, "cls_ing_item4"));
        }
        //Si se sube cualquier nivel, sin tener el tipo de Artífice seteado, te obliga a setearlo.
        if(ObtenerIntPersistente(oPC,"CLS_ING_TIPO") == 0 && GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) > 1)
        {
          BajarNivelQuedandoseA1XP(oPC);
          SendMessageToPC(oPC, "<cþ<<>Debes elegir un tipo de Artífice.</c>");
          return;
        }
    }
    //Si se mete la dote de Lantan pero no es gnomo, bajamos nivel.
    if(GetHasFeat(1771, oPC) && GetRacialType(oPC) != RACIAL_TYPE_GNOME)
    {
          BajarNivelQuedandoseA1XP(oPC);
          SendMessageToPC(oPC, "<cþ<<>La dote Nacido en Lantan, solo es accesible para gnomos.</c>");
          return;
    }

    //Dote Urdimbre Sombria
    if(GetHasFeat(1354, oPC))
    {
        if(ObtenerIntPersistente(oPC, "DOTE_SOMBRIA") == FALSE ) ExecuteScript("ms_leto_sombria", oPC);
    }

    //Archimago: Aptitud Sortílega.
    if(GetLevelByClass(CLASS_TYPE_ARCHMAGE, oPC) >= 1 && GetHasFeat(1432, oPC))
    {
        if(!GetIsObjectValid(GetItemPossessedBy(oPC, "ArchmagesFocusofPower")))
        {
            CreateItemOnObject("ArchmagesFocusofPower", oPC);
        }
    }
}
