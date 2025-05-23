//::///////////////////////////////////////////////
//:: DOTE RASTREAR / RASTREAR MEJORADO
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
    Highly modified version of HCR Tracking script integrated with Wilderness
    Lore System, featuring several levels of details about tracked creatures,
    wilderness lore bonus when tracking favored enemies, wilderness lore synergy
    bonus, DC adjustments based on area, weather, time, creature size and more.
    Also, there is a half-hour delay for consecutive tracking attempts at the
    same spot or no delay at all if the distance between attempts is above 30m.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 3 de Mayo de 2012
//:://////////////////////////////////////////////

#include "x2_inc_switches"
#include "lib_race"

int ObtenerCDBaseRastreoArea(object oArea, int iCD)
{
  if(GetLocalInt(oArea, "RASTREO_CD") > 0) return GetLocalInt(oArea, "RASTREO_CD");
  else
  {
      // Set the Area DC needed for tracking as well
      SetLocalInt(oArea, "RASTREO_CD", iCD);

      return iCD;
  }
}

int ObtenerAjustesCDRastreoArea(object oRastreador)
{
  int iCD;

  // Set a higher DC for bad weather conditions
  if(GetWeather(GetArea(oRastreador)) == WEATHER_SNOW) iCD = 6;
  else
  {
      if(GetWeather(GetArea(oRastreador)) == WEATHER_RAIN) iCD = 3;
      else iCD = 0;
  }

  // Raise the DC for poor visibility conditions
  if(!GetIsDay())
  {
      if(GetIsNight()) iCD += 3;
      else iCD += 2; // Dawn or Dusk
  }

  return iCD;
}

int ObtenerCriaturaAjusteCD(object oCriatura)
{
  int iAjusteCD = 0;

  // Ajuste de tamanyo
  switch(GetCreatureSize(oCriatura))
  {
      case 21:  iAjusteCD = 4;  break;
      case 20:  iAjusteCD = 3;  break;
      case CREATURE_SIZE_TINY:  iAjusteCD = 2;  break;
      case CREATURE_SIZE_SMALL: iAjusteCD = 1;  break;
      case CREATURE_SIZE_LARGE: iAjusteCD = -1; break;
      case CREATURE_SIZE_HUGE:  iAjusteCD = -2; break;
      case 22:  iAjusteCD = -3; break;
      case 23:  iAjusteCD = -4; break;
  }

  // Por cada 100 de peso de inventario, un -1 a la CD
  iAjusteCD -= GetWeight(oCriatura) / 1000;
  // Por cada 3 niveles, un +1 a la CD
  iAjusteCD += GetHitDice(oCriatura) / 3;
  // Si esta el estado de sigilo activado, un +5 a la CD
  if(GetStealthMode(oCriatura) == STEALTH_MODE_ACTIVATED) iAjusteCD += 5;

  return iAjusteCD;
}

void ObtenerInformacionRastros(float fDireccionRastreador, object oRastreador, object oCriatura, int iResultadoRestaTiradaCD, float fDistancia)
{
  string sRaza;
  string sDistancia;
  string sDireccion;

  // Informacion de la criatura
  if(iResultadoRestaTiradaCD <= 6)
  {
      switch(GetCreatureSize(oCriatura))
      {
          case 21:  sRaza = "Una criatura minúscula";  break;
          case 20:  sRaza = "Una criatura diminuta";  break;
          case CREATURE_SIZE_TINY: sRaza = "Una criatura menuda"; break;
          case CREATURE_SIZE_SMALL: sRaza = "Una criatura pequeña"; break;
          case CREATURE_SIZE_MEDIUM: sRaza = "Una criatura de tamaño medio"; break;
          case CREATURE_SIZE_LARGE: sRaza = "Una criatura grande"; break;
          case CREATURE_SIZE_HUGE: sRaza = "Una criatura enorme"; break;
          case 22:  sRaza = "Una criatura gargantuesca"; break;
          case 23:  sRaza = "Una criatura colosal"; break;
          default: sRaza = "Una criatura extraña"; break;
      }
  }
  else
  {
      if(iResultadoRestaTiradaCD >= 25) sRaza = GetName(oCriatura);
      else
      {
          int iRacialType = GetRacialType(oCriatura);
          switch(iRacialType)
          {
              case RACIAL_TYPE_ABERRATION: sRaza = "Una aberración"; break;
              case RACIAL_TYPE_ANIMAL: sRaza = "Un animal"; break;
              case RACIAL_TYPE_BEAST: sRaza = "Una bestia"; break;
              case RACIAL_TYPE_CONSTRUCT: sRaza = "Un constructo"; break;
              case RACIAL_TYPE_DRAGON: sRaza = "Un dragón"; break;
              case RACIAL_TYPE_DWARF: sRaza = "Un enano"; break;
              case RACIAL_TYPE_ELEMENTAL: sRaza = "Un elemental"; break;
              case RACIAL_TYPE_ELF: sRaza = "Un elfo"; break;
              case RACIAL_TYPE_FEY: sRaza = "Una fata"; break;
              case RACIAL_TYPE_GIANT: sRaza = "Un gigante"; break;
              case RACIAL_TYPE_GNOME: sRaza = "Un gnomo"; break;
              case RACIAL_TYPE_HALFELF: sRaza = "Un semielfo"; break;
              case RACIAL_TYPE_HALFLING: sRaza = "Un mediano"; break;
              case RACIAL_TYPE_HALFORC: sRaza = "Un semiorco"; break;
              case RACIAL_TYPE_HUMAN: sRaza = "Un humano"; break;
              case RACIAL_TYPE_HUMANOID_GOBLINOID: sRaza = "Un humanoide trasgoide"; break;
              case RACIAL_TYPE_HUMANOID_MONSTROUS: sRaza = "Un humanoide monstruoso"; break;
              case RACIAL_TYPE_HUMANOID_ORC: sRaza = "Un humanoide orco"; break;
              case RACIAL_TYPE_HUMANOID_REPTILIAN: sRaza = "Un humanoide reptiliano"; break;
              case RACIAL_TYPE_INVALID: sRaza = "Una criatura extraña"; break;
              case RACIAL_TYPE_MAGICAL_BEAST: sRaza = "Una bestia mágica"; break;
              case RACIAL_TYPE_OOZE: sRaza = "Un cieno"; break;
              case RACIAL_TYPE_OUTSIDER: sRaza = "Un ajeno"; break;
              case RACIAL_TYPE_SHAPECHANGER: sRaza = "Un posible cambiaformas"; break;
              case RACIAL_TYPE_VERMIN: sRaza = "Una sabandija"; break;
              default: sRaza = "Una criatura desconocida"; break;
          }

          if (PB_Race_GetIsUndead(oCriatura)) sRaza = "Un muerto viviente";
      }
  }

  // Informacion de la distancia
  if(iResultadoRestaTiradaCD < 10) sDistancia = " está ";
  else
  {
      if(iResultadoRestaTiradaCD > 20) sDistancia = " parece estar a unos " + IntToString(FloatToInt(fDistancia))+ " metros ";
      else
      {
          if (fDistancia > 120.0) sDistancia = " parece estar muy lejos ";
          else if (fDistancia > 80.0) sDistancia = " parece estar algo lejos ";
          else if (fDistancia > 40.0) sDistancia = " parece estar no muy lejos ";
          else if (fDistancia > 10.0) sDistancia = " parece estar cerca ";
          else sDistancia = " parece estar muy cerca ";
      }
  }

  // Informacion de la direccion
  if(iResultadoRestaTiradaCD <= 3) sDireccion = "en algún lugar de esta área";
  else
  {
      if(fDireccionRastreador >= 360.0) fDireccionRastreador = 720.0 - fDireccionRastreador;
      if(fDireccionRastreador < 0.0) fDireccionRastreador += 360.0;
      int iDireccionRastreador = FloatToInt(fDireccionRastreador);

      if(iDireccionRastreador >= 338 || iDireccionRastreador <=  22) sDireccion = "al este";
      else if(iDireccionRastreador >=  23 && iDireccionRastreador <=  67) sDireccion = "al noreste";
      else if(iDireccionRastreador >=  68 && iDireccionRastreador <= 112) sDireccion = "al norte";
      else if(iDireccionRastreador >= 113 && iDireccionRastreador <= 157) sDireccion = "al noroeste";
      else if(iDireccionRastreador >= 158 && iDireccionRastreador <= 202) sDireccion = "al oeste";
      else if(iDireccionRastreador >= 203 && iDireccionRastreador <= 247) sDireccion = "al suroeste";
      else if(iDireccionRastreador >= 248 && iDireccionRastreador <= 292) sDireccion = "al sur";
      else if(iDireccionRastreador >= 293 && iDireccionRastreador <= 337) sDireccion = "al sureste";
  }

  DelayCommand(6.0, SendMessageToPC(oRastreador, "<c»ðª>" + sRaza + sDistancia + sDireccion + ".</c>"));
}

int ObtenerBonusEnemigoRedilecto(object oRanger, object oCritter)
{
  int bBonus = FALSE;
  int nRacialType = GetRacialType(oCritter);
  switch(nRacialType)
  {
    case RACIAL_TYPE_ABERRATION:
         if (GetHasFeat(FEAT_FAVORED_ENEMY_ABERRATION, oRanger))
           bBonus = TRUE;
         break;
    case RACIAL_TYPE_ANIMAL:
         if (GetHasFeat(FEAT_FAVORED_ENEMY_ANIMAL, oRanger))
           bBonus = TRUE;
         break;
    case RACIAL_TYPE_BEAST:
         if (GetHasFeat(FEAT_FAVORED_ENEMY_BEAST, oRanger))
           bBonus = TRUE;
         break;
    case RACIAL_TYPE_CONSTRUCT:
         if (GetHasFeat(FEAT_FAVORED_ENEMY_CONSTRUCT, oRanger))
           bBonus = TRUE;
         break;
    case RACIAL_TYPE_DRAGON:
         if (GetHasFeat(FEAT_FAVORED_ENEMY_DRAGON, oRanger))
           bBonus = TRUE;
         break;
    case RACIAL_TYPE_DWARF:
         if (GetHasFeat(FEAT_FAVORED_ENEMY_DWARF, oRanger))
           bBonus = TRUE;
         break;
    case RACIAL_TYPE_ELEMENTAL:
         if (GetHasFeat(FEAT_FAVORED_ENEMY_ELEMENTAL, oRanger))
           bBonus = TRUE;
         break;
    case RACIAL_TYPE_ELF:
         if (GetHasFeat(FEAT_FAVORED_ENEMY_ELF, oRanger))
           bBonus = TRUE;
         break;
    case RACIAL_TYPE_FEY:
         if (GetHasFeat(FEAT_FAVORED_ENEMY_FEY, oRanger))
           bBonus = TRUE;
         break;
    case RACIAL_TYPE_GIANT:
         if (GetHasFeat(FEAT_FAVORED_ENEMY_GIANT, oRanger))
           bBonus = TRUE;
         break;
    case RACIAL_TYPE_GNOME:
         if (GetHasFeat(FEAT_FAVORED_ENEMY_GNOME, oRanger))
           bBonus = TRUE;
         break;
    case RACIAL_TYPE_HALFELF:
         if (GetHasFeat(FEAT_FAVORED_ENEMY_HALFELF, oRanger))
           bBonus = TRUE;
         break;
    case RACIAL_TYPE_HALFLING:
         if (GetHasFeat(FEAT_FAVORED_ENEMY_HALFLING, oRanger))
           bBonus = TRUE;
         break;
    case RACIAL_TYPE_HALFORC:
         if (GetHasFeat(FEAT_FAVORED_ENEMY_HALFORC, oRanger))
           bBonus = TRUE;
         break;
    case RACIAL_TYPE_HUMAN:
         if (GetHasFeat(FEAT_FAVORED_ENEMY_HUMAN, oRanger))
           bBonus = TRUE;
         break;
    case RACIAL_TYPE_HUMANOID_GOBLINOID:
         if (GetHasFeat(FEAT_FAVORED_ENEMY_GOBLINOID, oRanger))
           bBonus = TRUE;
         break;
    case RACIAL_TYPE_HUMANOID_MONSTROUS:
         if (GetHasFeat(FEAT_FAVORED_ENEMY_MONSTROUS, oRanger))
           bBonus = TRUE;
         break;
    case RACIAL_TYPE_HUMANOID_ORC:
         if (GetHasFeat(FEAT_FAVORED_ENEMY_ORC, oRanger))
           bBonus = TRUE;
         break;
    case RACIAL_TYPE_HUMANOID_REPTILIAN:
         if (GetHasFeat(FEAT_FAVORED_ENEMY_REPTILIAN, oRanger))
           bBonus = TRUE;
         break;
    case RACIAL_TYPE_MAGICAL_BEAST:
         if (GetHasFeat(FEAT_FAVORED_ENEMY_MAGICAL_BEAST, oRanger))
           bBonus = TRUE;
         break;
    case RACIAL_TYPE_OOZE: break;
    case RACIAL_TYPE_OUTSIDER:
         if (GetHasFeat(FEAT_FAVORED_ENEMY_OUTSIDER, oRanger))
           bBonus = TRUE;
         break;
    case RACIAL_TYPE_SHAPECHANGER:
         if (GetHasFeat(FEAT_FAVORED_ENEMY_SHAPECHANGER, oRanger))
           bBonus = TRUE;
         break;
    case RACIAL_TYPE_VERMIN:
         if (GetHasFeat(FEAT_FAVORED_ENEMY_VERMIN, oRanger))
           bBonus = TRUE;
         break;
  }

  if (PB_Race_GetIsUndead(oCritter) && GetHasFeat(FEAT_FAVORED_ENEMY_UNDEAD, oRanger)) bBonus = TRUE;

  if(bBonus == TRUE) return (GetLevelByClass(CLASS_TYPE_RANGER, oRanger) / 5) + 1;
  else return 0;
}

void main()
{
  object oRastreador = OBJECT_SELF;
  object oArea = GetArea(oRastreador);

  // Con efectos dayninos no puedes usarla
  int iFalloDote = FALSE;
  if(GetIsResting(oRastreador) || GetLocalInt(oRastreador, "DERRIBADO") || GetLocalInt(oRastreador, "SLIDING")) iFalloDote = TRUE;

  effect eEfecto = GetFirstEffect(oRastreador);
  while(GetIsEffectValid(eEfecto))
  {
      if(GetEffectType(eEfecto) == EFFECT_TYPE_CHARMED ||           GetEffectType(eEfecto) == EFFECT_TYPE_CONFUSED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_CUTSCENE_PARALYZE || GetEffectType(eEfecto) == EFFECT_TYPE_CUTSCENEIMMOBILIZE ||
         GetEffectType(eEfecto) == EFFECT_TYPE_DAZED ||             GetEffectType(eEfecto) == EFFECT_TYPE_DOMINATED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_ENTANGLE ||          GetEffectType(eEfecto) == EFFECT_TYPE_FRIGHTENED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_PARALYZE ||          GetEffectType(eEfecto) == EFFECT_TYPE_PETRIFY ||
         GetEffectType(eEfecto) == EFFECT_TYPE_SLEEP ||             GetEffectType(eEfecto) == EFFECT_TYPE_STUNNED) iFalloDote = TRUE;

      eEfecto = GetNextEffect(oRastreador);
  }

  if(iFalloDote == TRUE)
  {
      FloatingTextStringOnCreature("<cþ•w>* En tu estado no puedes rastrear *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // No puedes concentrarte para buscar rastros en combate
  if(GetIsInCombat(oRastreador))
  {
      SendMessageToPC(oRastreador, "<cþ•w>No puedes rastrear en combate.</c>");
      return;
  }

  // Anti-saturamiento de rastreo, no se puede rastrear continuamente
  object oMod = GetModule();
  string sNombreRastreador = GetName(oRastreador);
  location lLugarRastreador = GetLocation(oRastreador);
  float fDistanciaSaturamiento = GetDistanceBetweenLocations(lLugarRastreador, GetLocalLocation(oRastreador, "RASTREO_LUGARJUGADOR"));
  if(GetLocalInt(oMod, "RASTREO_NOSATURAR" + sNombreRastreador) == TRUE &&
     fDistanciaSaturamiento <= 30.0 && fDistanciaSaturamiento != -1.0)
  {
      SendMessageToPC(oRastreador, "<cþ•w>Ya has intentado buscar rastros por aquí no hace mucho tiempo.</c>");
      return;
  }

  // Ajuste de variables anti-saturamiento
  float fDemoraNuevoIntento;
  if(GetIsAreaInterior(oArea) == TRUE) fDemoraNuevoIntento = 30.0;
  else fDemoraNuevoIntento = 180.0;

  SetLocalInt(oMod, "RASTREO_NOSATURAR" + sNombreRastreador, TRUE);
  DelayCommand(fDemoraNuevoIntento, DeleteLocalInt(oMod, "RASTREO_NOSATURAR" + sNombreRastreador));
  SetLocalLocation(oRastreador, "RASTREO_LUGARJUGADOR", lLugarRastreador);

  // EMPIEZA EL RASTREO!!
  // Animacion y mensaje inicial
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oRastreador, 8.0);
  DelayCommand(0.2, FloatingTextStringOnCreature("<cþþþ>* Buscando rastros en la zona *</c>", oRastreador));
  DelayCommand(0.3, AssignCommand(oRastreador, ClearAllActions()));
  DelayCommand(0.4, AssignCommand(oRastreador, PlayAnimation(ANIMATION_LOOPING_CUSTOM17, 1.0, 7.5)));

  // Declaracion de variables
  int iAjusteCDDistancia, iTirada, iCD, iCriaturasRastreadas, iBonoRastrearMejorado, iRastreoValido;
  float fDistancia;
  vector vCreature;

  int iBonoDoteSupervivencia = 0;
  if(GetHasFeat(1247, oRastreador)) iBonoDoteSupervivencia = 10;      // Soltura epica
  else if(GetHasFeat(1235, oRastreador)) iBonoDoteSupervivencia = 3;  // Soltura normal

  int iPosicionCriaturaCercana = 1;
  int iAreaCD = ObtenerCDBaseRastreoArea(oArea, 10) + ObtenerAjustesCDRastreoArea(oRastreador);
  int iSupervivencia = GetSkillRank(36, oRastreador) + iBonoDoteSupervivencia;
  object oCriatura = GetNearestObject(OBJECT_TYPE_CREATURE, oRastreador, iPosicionCriaturaCercana);

  // Ajustes dote "Rastrear mejorado"
  if(GetHasFeat(1312)) iBonoRastrearMejorado = 5;

  // Comprueba los rastros de todas las criaturas del area
  while(GetIsObjectValid(oCriatura))
  {
      // No se rastrea cuando...
      if(iCriaturasRastreadas >= 5 && GetHasFeat(1312) == FALSE)                     break;                // Rastrear mejorado se salta el limite de 3 criaturas rastreadas
      else if(GetFactionEqual(oRastreador, oCriatura) == TRUE)                       iRastreoValido = FALSE; // Si son del mismo grupo que el rastreador, no se les puede rastrear
      else if(GetLocalInt(oCriatura, "RASTREO_IMMUNIDAD") == TRUE)                   iRastreoValido = FALSE; // Si la criatura tiene la variable "RASTRO_IMMUNIDAD" en TRUE, no se le puede rastrear
      else if(GetIsAreaNatural(oArea) == TRUE && GetHasFeat(201, oCriatura) == TRUE) iRastreoValido = FALSE; // Dote "Pisada sin rastro" en areas naturales imposibilita el rastreo
      else if(GetHasSpellEffect(1108, oCriatura) == TRUE)                            iRastreoValido = FALSE; // Conjuro "Pasar sin dejar rastro" imposibilita el rastreo
      else iRastreoValido = TRUE;

      // Rastreo valido o no, y tiradas
      if(iRastreoValido == TRUE)
      {
          fDistancia = GetDistanceBetween(oCriatura, oRastreador);
          iAjusteCDDistancia = FloatToInt(fDistancia / 10.0);
          iTirada = d20() + iSupervivencia + ObtenerBonusEnemigoRedilecto(oRastreador, oCriatura) + iBonoRastrearMejorado;
          iCD = iAreaCD + iAjusteCDDistancia + ObtenerCriaturaAjusteCD(oCriatura);

          if(iTirada >= iCD)
          {
              iCriaturasRastreadas++;
              vCreature = GetPosition(oCriatura);
              AssignCommand(oRastreador, SetFacingPoint(vCreature));
              AssignCommand(oRastreador, ObtenerInformacionRastros(GetFacing(oRastreador), oRastreador, oCriatura, iTirada - iCD, fDistancia));
          }
      }

      iPosicionCriaturaCercana++;
      oCriatura = GetNearestObject(OBJECT_TYPE_CREATURE, oRastreador, iPosicionCriaturaCercana);
  }

  // Mensaje de que no hay rastros
  if(iCriaturasRastreadas == 0) DelayCommand(6.0, SendMessageToPC(oRastreador, "<cþ•w>No encuentras ningún tipo de rastro aquí.</c>"));
}
