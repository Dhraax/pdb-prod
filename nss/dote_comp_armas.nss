//::///////////////////////////////////////////////
//:: COMPETENCIAS CON ARMAS
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
    Regula las competencias con armas

    45: CompetenciaArmaSencilla_Danzarin: ballesta ligera, ballesta pesada, daga, dardo, maza ligera, maza pesada, maza de armas, bast√≥n y clava.
    48: CompetenciaArmaSencilla_Druida: bast√≥n, clava, daga, dardo, honda, hoz, lanza corta, lanza larga.
    49: CompetenciaArmaSencilla_Monje: ballesta ligera, ballesta pesada, bast√≥n, clava, daga y honda.
    50: CompetenciaArmaSencilla_Asesino: ballesta ligera, ballesta pesada, daga y dardo.
    51: CompetenciaArmaSencilla_Mago: ballesta ligera, ballesta pesada, bast√≥n, clava y daga.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 14 de Mayo de 2011
//:://////////////////////////////////////////////

#include "x2_inc_itemprop"
#include "NW_I0_GENERIC"

void AplicarCompetenciaArmas(object oPC, object oObjeto, int iObjetoBase)
{
  int iDoteCompetencia = FALSE;
  int iArmaSencillaDanzarin = FALSE;
  int iArmaSencillaDruida = FALSE;
  int iArmaSencillaMonje = FALSE;
  int iArmaSencillaAsesino = FALSE;
  int iArmaSencillaMago = FALSE;

  switch(iObjetoBase)
  {
      case 0: iDoteCompetencia = 1169; break;   // Espada corta
      case 1: iDoteCompetencia = 1175; break;   // Espada larga
      case 2: iDoteCompetencia = 1177; break;   // Hacha de batalla
      case 3: iDoteCompetencia = 1160; break;   // Espada bastarda
      case 4: iDoteCompetencia = 1178; break;   // Mangual ligero
      case 5: iDoteCompetencia = 1179; break;   // Martillo de guerra
      case 6:                                   // Ballesta pesada
      {
          iDoteCompetencia = 46;
          iArmaSencillaDanzarin = TRUE;
          iArmaSencillaMonje = TRUE;
          iArmaSencillaAsesino = TRUE;
          iArmaSencillaMago = TRUE;
      }break;
      case 7:                                   // Ballesta ligera
      {
          iDoteCompetencia = 46;
          iArmaSencillaDanzarin = TRUE;
          iArmaSencillaMonje = TRUE;
          iArmaSencillaAsesino = TRUE;
          iArmaSencillaMago = TRUE;
      }break;
      case 8: iDoteCompetencia = 1186; break;   // Arco largo
      case 9:                                   // Maza ligera
      {
          iDoteCompetencia = 46;
          iArmaSencillaDanzarin = TRUE;
      }break;
      case 10: iDoteCompetencia = 1180; break;  // Alabarda
      case 11: iDoteCompetencia = 1185; break;  // Arco corto
      case 12: iDoteCompetencia = 1161; break;  // Espada de dos hojas
      case 13: iDoteCompetencia = 1181; break;  // Espadon
      case 18: iDoteCompetencia = 1182; break;  // Gran hacha
      case 22:                                  // Daga
      {
          iDoteCompetencia = 46;
          iArmaSencillaDanzarin = TRUE;
          iArmaSencillaDruida = TRUE;
          iArmaSencillaMonje = TRUE;
          iArmaSencillaAsesino = TRUE;
          iArmaSencillaMago = TRUE;
      }break;
      case 28:                                  // Clava
      {
          iDoteCompetencia = 46;
          iArmaSencillaDanzarin = TRUE;
          iArmaSencillaDruida = TRUE;
          iArmaSencillaMonje = TRUE;
          iArmaSencillaMago = TRUE;
      }break;
      case 31:                                  // Dardo
      {
          iDoteCompetencia = 46;
          iArmaSencillaDanzarin = TRUE;
          iArmaSencillaDruida = TRUE;
          iArmaSencillaAsesino = TRUE;
      }break;
      case 32: iDoteCompetencia = 1162; break;  // Maza terrible
      case 33: iDoteCompetencia = 1163; break;  // Hacha doble
      case 35: iDoteCompetencia = 1184; break;  // Mangual pesado
      case 37: iDoteCompetencia = 1173; break;  // Martillo ligero
      case 38: iDoteCompetencia = 1171; break;  // Hacha de mano
      case 40: iDoteCompetencia = 1164; break;  // Kama
      case 41: iDoteCompetencia = 1165; break;  // Katana
      case 42: iDoteCompetencia = 1172; break;  // Kukri
      case 47:                                  // Maza de armas
      {
          iDoteCompetencia = 46;
          iArmaSencillaDanzarin = TRUE;
      }break;
      case 50:                                  // Baston
      {
          iDoteCompetencia = 46;
          iArmaSencillaDanzarin = TRUE;
          iArmaSencillaDruida = TRUE;
          iArmaSencillaMonje = TRUE;
          iArmaSencillaMago = TRUE;
      }break;
      case 51: iDoteCompetencia = 1176; break;  // Estoque
      case 53: iDoteCompetencia = 1174; break;  // Cimitarra
      case 55: iDoteCompetencia = 1183; break;  // Guadanya
      case 58: iDoteCompetencia = 1564; break;  // Lanza de Guerra
      case 59: iDoteCompetencia = 1166; break;  // Shuriken
      case 60:                                  // Hoz
      {
          iDoteCompetencia = 46;
          iArmaSencillaDruida = TRUE;
      }break;
      case 61:                                  // Honda
      {
          iDoteCompetencia = 46;
          iArmaSencillaDruida = TRUE;
          iArmaSencillaMonje = TRUE;
      }break;
      case 63: iDoteCompetencia = 1170; break;  // Hacha arrojadiza
      case 92: iDoteCompetencia = 1208; break;  // Lanza de caballeria
      case 95: iDoteCompetencia = 1187; break;  // Tridente
      case 108: iDoteCompetencia = 1167; break; // Hacha de guerra enana
      case 111: iDoteCompetencia = 1168; break; // Latigo
      case 210:                                 // Lanza Corta
      {
          iDoteCompetencia = 46;
          iArmaSencillaDruida = TRUE;
      }break;
      case 300: iDoteCompetencia = 1187; break; // Tridente a una mano
      case 301: iDoteCompetencia = 1189; break; // Pico pesado
      case 302: iDoteCompetencia = 1188; break; // Pico ligero
      case 303: iDoteCompetencia = 1190; break; // Sai
      case 304: iDoteCompetencia = 1191; break; // Nunchaku
      case 305: iDoteCompetencia = 1192; break; // Alfanje
      case 308: iDoteCompetencia = 1193; break; // Cachiporra
      case 309:                                 // Daga de asesino
      {
          iDoteCompetencia = 46;
          iArmaSencillaDanzarin = TRUE;
          iArmaSencillaDruida = TRUE;
          iArmaSencillaMonje = TRUE;
          iArmaSencillaAsesino = TRUE;
          iArmaSencillaMago = TRUE;
      }break;
      case 310: iDoteCompetencia = 46; break;   // Katar
      case 312:                                 // Maza ligera 2
      {
          iDoteCompetencia = 46;
          iArmaSencillaDanzarin = TRUE;
      }break;
      case 313: iDoteCompetencia = 1172; break; // Kukri 2
      case 316: iDoteCompetencia = 1192; break; // Alfanje 2
      case 317:                                 // Maza pesada
      {
          iDoteCompetencia = 46;
          iArmaSencillaDanzarin = TRUE;
      }break;
      case 318: iDoteCompetencia = 1194; break; // Mazo
      case 319: iDoteCompetencia = 1195; break; // Espada larga mercurial
      case 320: iDoteCompetencia = 1196; break; // Espadon mercurial
      case 321: iDoteCompetencia = 1197; break; // Cimitarra doble
      case 322: iDoteCompetencia = 1198; break; // Aguijada
      case 323: iDoteCompetencia = 1199; break; // Rueda de viento y fuego
      case 324: iDoteCompetencia = 1161; break; // Espada de dos hojas Maug
      case 330: iDoteCompetencia = 1175; break; // Espada larga 2
      case 513:                                 // Lanza Larga
      {
          iDoteCompetencia = 46;
          iArmaSencillaDruida = TRUE;
      }break;
      case 511: iDoteCompetencia = 1565; break; // Espad√≥n Enorme
      case 510: iDoteCompetencia = 1566; break; // Mazo Enorme
      case 512: iDoteCompetencia = 1567; break; // Hacha Enorme
      case 514:                                  // Daga HechicerÌa
      {
          iDoteCompetencia = 46;
          iArmaSencillaDanzarin = TRUE;
          iArmaSencillaDruida = TRUE;
          iArmaSencillaMonje = TRUE;
          iArmaSencillaAsesino = TRUE;
          iArmaSencillaMago = TRUE;
      }break;
      default:  iDoteCompetencia = FALSE; break;
  }

  // Si nos equipamos un objeto que no requiere competencia, no pasa nada
  if(iDoteCompetencia == FALSE) return;

  if(GetHasFeat(iDoteCompetencia, oPC) == FALSE)
  {
      if(GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC)) return;

      if(GetHasFeat(45, oPC) == TRUE && iArmaSencillaDanzarin == TRUE) return; // Armas sencillas del danzarin
      if(GetHasFeat(48, oPC) == TRUE && iArmaSencillaDruida == TRUE) return; // Armas sencillas del druida
      if(GetHasFeat(49, oPC) == TRUE && iArmaSencillaMonje == TRUE) return; // Armas sencillas del monje
      if(GetHasFeat(50, oPC) == TRUE && iArmaSencillaAsesino == TRUE) return; // Armas sencillas del asesino
      if(GetHasFeat(51, oPC) == TRUE && iArmaSencillaMago == TRUE) return; // Armas sencillas del mago

      SetLocalInt(oObjeto, "COMPETENCIA_PENALIZADOR", TRUE);
      IPSafeAddItemProperty(oObjeto,ItemPropertyAttackPenalty(4),9999999999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
      FloatingTextStringOnCreature("<c¥$$>* No eres competente con "+GetName(oObjeto)+" *</c>", oPC, FALSE);
      DelayCommand(0.2, SendMessageToPC(oPC, "<c¥$$>"+GetName(oObjeto)+" te aplica un penalizador de <c¥$$>-4</c> al Ataque.</c>"));
  }
}

void EliminarCompetenciaArmas(object oObjeto)
{
  if(GetLocalInt(oObjeto, "COMPETENCIA_PENALIZADOR"))
  {
      IPRemoveMatchingItemProperties(oObjeto, ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER);
      DeleteLocalInt(oObjeto,"COMPETENCIA_PENALIZADOR");
  }
}

void EliminarPropiedadesTemporales(object oObjeto)
{
  itemproperty ip = GetFirstItemProperty(oObjeto);
  while(GetIsItemPropertyValid(ip))
  {
      if(GetItemPropertyDurationType(ip) == DURATION_TYPE_TEMPORARY &&       // Solo propiedades temporales
         GetItemPropertyType(ip) != ITEM_PROPERTY_ARCANE_SPELL_FAILURE &&    // Fix para bardos
         GetItemPropertyType(ip) != ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER) // Fix para competencias con armas
      {
          RemoveItemProperty(oObjeto, ip);
      }

      ip = GetNextItemProperty(oObjeto);
  }
}