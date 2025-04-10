//::///////////////////////////////////////////////
//:: FABRICAR OBJETO DE ARPISTA (LIBRERIA)
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Libreria de fabricacion de objetos de arpista.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 1 de Mayo de 2011
//:://////////////////////////////////////////////

#include "x2_inc_itemprop"

void EncantamientoPropiedadLanzarConjuro(object oObjeto, int iRango);
int CalculoDelRangoArpista(object oPC);
int Costes(object oPC, int iOroRequerido, int iBonoXP);
void EncantamientoPociones(object oObjeto, int iTipo);
void EncantamientoPropiedadBonificadorHabilidad(object oObjeto, int iRango, int iHabilidad=0);
void EncantamientoPropiedadBonificadorCaracteristica(object oObjeto, int iRango);

void EncantamientoPropiedadLanzarConjuro(object oObjeto, int iRango)
{
  int iTirada, iConjuro, iUsos;

  switch(iRango)
  {
      case 1:
      case 2:
      {
          iTirada = Random(29)+1;

               if(iTirada == 1)  iConjuro = IP_CONST_CASTSPELL_ACID_SPLASH_1;
          else if(iTirada == 2)  iConjuro = IP_CONST_CASTSPELL_BLESS_2;
          else if(iTirada == 3)  iConjuro = IP_CONST_CASTSPELL_BURNING_HANDS_2;
          else if(iTirada == 4)  iConjuro = IP_CONST_CASTSPELL_CHARM_PERSON_2;
          else if(iTirada == 5)  iConjuro = IP_CONST_CASTSPELL_COLOR_SPRAY_2;
          else if(iTirada == 6)  iConjuro = IP_CONST_CASTSPELL_SLEEP_2;
          else if(iTirada == 7)  iConjuro = IP_CONST_CASTSPELL_SUMMON_CREATURE_I_2;
          else if(iTirada == 8)  iConjuro = IP_CONST_CASTSPELL_DAZE_1;
          else if(iTirada == 9)  iConjuro = IP_CONST_CASTSPELL_DOOM_2;
          else if(iTirada == 10) iConjuro = IP_CONST_CASTSPELL_ELECTRIC_JOLT_1;
          else if(iTirada == 11) iConjuro = IP_CONST_CASTSPELL_ENDURE_ELEMENTS_2;
          else if(iTirada == 12) iConjuro = IP_CONST_CASTSPELL_ENTANGLE_2;
          else if(iTirada == 13) iConjuro = IP_CONST_CASTSPELL_FLARE_1;
          else if(iTirada == 14) iConjuro = IP_CONST_CASTSPELL_GREASE_2;
          else if(iTirada == 15) iConjuro = IP_CONST_CASTSPELL_INFLICT_MINOR_WOUNDS_1;
          else if(iTirada == 16) iConjuro = IP_CONST_CASTSPELL_LIGHT_1;
          else if(iTirada == 17) iConjuro = IP_CONST_CASTSPELL_MAGE_ARMOR_2;
          else if(iTirada == 18) iConjuro = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_1;
          else if(iTirada == 19) iConjuro = IP_CONST_CASTSPELL_PROTECTION_FROM_ALIGNMENT_2;
          else if(iTirada == 20) iConjuro = IP_CONST_CASTSPELL_RAY_OF_FROST_1;
          else if(iTirada == 21) iConjuro = IP_CONST_CASTSPELL_RAY_OF_ENFEEBLEMENT_2;
          else if(iTirada == 22) iConjuro = IP_CONST_CASTSPELL_REMOVE_FEAR_2;
          else if(iTirada == 23) iConjuro = IP_CONST_CASTSPELL_RESISTANCE_2;
          else if(iTirada == 24) iConjuro = IP_CONST_CASTSPELL_SANCTUARY_2;
          else if(iTirada == 25) iConjuro = IP_CONST_CASTSPELL_SCARE_2;
          else if(iTirada <= 27) iConjuro = IP_CONST_CASTSPELL_CURE_LIGHT_WOUNDS_2;
          else if(iTirada <= 29) iConjuro = IP_CONST_CASTSPELL_CURE_MINOR_WOUNDS_1;

          iTirada = d100();

               if(iTirada <= 40)   iUsos = IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE;
          else if(iTirada <= 100)  iUsos = IP_CONST_CASTSPELL_NUMUSES_2_CHARGES_PER_USE;
      }break;

      case 3:
      {
          iTirada = Random(24)+1;

               if(iTirada == 1)  iConjuro = IP_CONST_CASTSPELL_BURNING_HANDS_2;
          else if(iTirada == 2)  iConjuro = IP_CONST_CASTSPELL_BARKSKIN_3;
          else if(iTirada == 3)  iConjuro = IP_CONST_CASTSPELL_MAGE_ARMOR_2;
          else if(iTirada == 4)  iConjuro = IP_CONST_CASTSPELL_MAGIC_MISSILE_5;
          else if(iTirada == 5)  iConjuro = IP_CONST_CASTSPELL_COLOR_SPRAY_2;
          else if(iTirada == 6)  iConjuro = IP_CONST_CASTSPELL_DOOM_5;
          else if(iTirada == 7)  iConjuro = IP_CONST_CASTSPELL_ENTANGLE_5;
          else if(iTirada == 8)  iConjuro = IP_CONST_CASTSPELL_GHOSTLY_VISAGE_3;
          else if(iTirada == 9)  iConjuro = IP_CONST_CASTSPELL_SUMMON_CREATURE_III_5;
          else if(iTirada == 10) iConjuro = IP_CONST_CASTSPELL_BLESS_2;
          else if(iTirada == 11) iConjuro = IP_CONST_CASTSPELL_BANE_5;
          else if(iTirada == 12) iConjuro = IP_CONST_CASTSPELL_WEB_3;
          else if(iTirada == 13) iConjuro = IP_CONST_CASTSPELL_SUMMON_CREATURE_II_3;
          else if(iTirada == 14) iConjuro = IP_CONST_CASTSPELL_SLEEP_5;
          else if(iTirada == 15) iConjuro = IP_CONST_CASTSPELL_PRAYER_5;
          else if(iTirada == 16) iConjuro = IP_CONST_CASTSPELL_OWLS_WISDOM_3;
          else if(iTirada == 17) iConjuro = IP_CONST_CASTSPELL_MELFS_ACID_ARROW_3;
          else if(iTirada == 18) iConjuro = IP_CONST_CASTSPELL_LIGHTNING_BOLT_5;
          else if(iTirada == 19) iConjuro = IP_CONST_CASTSPELL_ANIMATE_DEAD_5;
          else if(iTirada == 20) iConjuro = IP_CONST_CASTSPELL_AMPLIFY_5;
          else if(iTirada <= 22) iConjuro = IP_CONST_CASTSPELL_CURE_LIGHT_WOUNDS_5;
          else if(iTirada <= 24) iConjuro = IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_3;

          iTirada = d100();

               if(iTirada <= 40)  iUsos = IP_CONST_CASTSPELL_NUMUSES_2_CHARGES_PER_USE;
          else if(iTirada <= 100)  iUsos = IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE;
      }break;

      case 4:
      case 5:
      {
          iTirada = Random(24)+1;

               if(iTirada == 1)  iConjuro = IP_CONST_CASTSPELL_DISPLACEMENT_9;
          else if(iTirada == 2)  iConjuro = IP_CONST_CASTSPELL_FIREBALL_10;
          else if(iTirada == 3)  iConjuro = IP_CONST_CASTSPELL_SLAY_LIVING_9;
          else if(iTirada == 4)  iConjuro = IP_CONST_CASTSPELL_STONESKIN_7;
          else if(iTirada == 5)  iConjuro = IP_CONST_CASTSPELL_ICE_STORM_9;
          else if(iTirada == 6)  iConjuro = IP_CONST_CASTSPELL_CALL_LIGHTNING_10;
          else if(iTirada == 7)  iConjuro = IP_CONST_CASTSPELL_CONE_OF_COLD_9;
          else if(iTirada == 8)  iConjuro = IP_CONST_CASTSPELL_DARKVISION_6;
          else if(iTirada == 9)  iConjuro = IP_CONST_CASTSPELL_DEATH_WARD_7;
          else if(iTirada == 10) iConjuro = IP_CONST_CASTSPELL_DOMINATE_PERSON_7;
          else if(iTirada == 11) iConjuro = IP_CONST_CASTSPELL_DIVINE_POWER_7;
          else if(iTirada == 12) iConjuro = IP_CONST_CASTSPELL_DISPLACEMENT_9;
          else if(iTirada == 13) iConjuro = IP_CONST_CASTSPELL_SUMMON_CREATURE_IV_7;
          else if(iTirada == 14) iConjuro = IP_CONST_CASTSPELL_SUMMON_CREATURE_V_9;
          else if(iTirada == 15) iConjuro = IP_CONST_CASTSPELL_TRUE_SEEING_9;
          else if(iTirada == 16) iConjuro = IP_CONST_CASTSPELL_TRUE_STRIKE_5;
          else if(iTirada == 17) iConjuro = IP_CONST_CASTSPELL_WALL_OF_FIRE_9;
          else if(iTirada == 18) iConjuro = IP_CONST_CASTSPELL_WAR_CRY_7;
          else if(iTirada == 19) iConjuro = IP_CONST_CASTSPELL_TASHAS_HIDEOUS_LAUGHTER_7;
          else if(iTirada == 20) iConjuro = IP_CONST_CASTSPELL_ENERVATION_7;
          else if(iTirada <= 22) iConjuro = IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_6;
          else if(iTirada <= 24) iConjuro = IP_CONST_CASTSPELL_CURE_SERIOUS_WOUNDS_10;

          iTirada = d100();

               if(iTirada <= 40)  iUsos = IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE;
          else if(iTirada <= 100)  iUsos = IP_CONST_CASTSPELL_NUMUSES_4_CHARGES_PER_USE;
      }break;
  }

  itemproperty iPropiedadLanzarConjuro = ItemPropertyCastSpell(iConjuro, iUsos);
  IPSafeAddItemProperty(oObjeto, iPropiedadLanzarConjuro);

  iTirada = d12() * iRango + 5;
  if(iTirada > 25) iTirada = 25;
  SetItemCharges(oObjeto, iTirada);
}

int CalculoDelRangoArpista(object oPC)
{
  int iNivelJugador = GetHitDice(oPC);
  int iRango;

  if(iNivelJugador <= 5) iRango = 1;
  else if(iNivelJugador <= 10) iRango = d2();
  else if(iNivelJugador <= 15) iRango = d3();
  else if(iNivelJugador <= 20) iRango = d3()+1;
  else iRango = d3()+2;

  return iRango;
}

int Costes(object oPC, int iOroRequerido, int iBonoXP)
{
  if(GetGold(oPC) < iOroRequerido)
  {
      SendMessageToPC(oPC, "No tienes suficiente oro.");
      return FALSE;
  }

  AssignCommand(oPC, TakeGoldFromCreature(iOroRequerido, oPC, TRUE));
  SetXP(oPC, GetXP(oPC) + iBonoXP);
  return TRUE;
}

void EncantamientoPociones(object oObjeto, int iTipo)
{
  int iConjuro;

  switch(iTipo)
  {
      case 1: iConjuro = IP_CONST_CASTSPELL_BULLS_STRENGTH_15;  break;
      case 2: iConjuro = IP_CONST_CASTSPELL_CATS_GRACE_15;  break;
      case 3: iConjuro = IP_CONST_CASTSPELL_ENDURANCE_15;  break;
      case 4: iConjuro = IP_CONST_CASTSPELL_FOXS_CUNNING_15;  break;
      case 5: iConjuro = IP_CONST_CASTSPELL_OWLS_WISDOM_15;  break;
      case 6: iConjuro = IP_CONST_CASTSPELL_EAGLE_SPLEDOR_15;  break;
  }

  itemproperty ipPocion = ItemPropertyCastSpell(iConjuro, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE);
  IPSafeAddItemProperty(oObjeto, ipPocion);
}

void EncantamientoPropiedadBonificadorHabilidad(object oObjeto, int iRango, int iHabilidad=0)
{
  int iValor;

  if(iHabilidad == 0) iHabilidad = Random(39);

  switch(iRango)
  {
      case 1: iValor = d2();        break;  // 1-2
      case 2: iValor = d4();        break;  // 1-4
      case 3: iValor = Random(5)+2; break;  // 2-6
      case 4: iValor = d6()+2;      break;  // 3-8
      case 5: iValor = Random(7)+4; break;  // 4-10
  }

  itemproperty ipBonificadorHabilidad = ItemPropertySkillBonus(iHabilidad, iValor);
  IPSafeAddItemProperty(oObjeto, ipBonificadorHabilidad);
}

void EncantamientoPropiedadBonificadorCaracteristica(object oObjeto, int iRango)
{
  int iValor;

  switch(iRango)
  {
      case 1:
      case 2: iValor = 1;      break;  // 1
      case 3: iValor = d3();   break;  // 1-3
      case 4: iValor = d4()+1; break;  // 2-5
      case 5: iValor = d4()+2; break;  // 3-6
  }

  itemproperty ipBonificadorCaracteristica = ItemPropertyAbilityBonus(Random(6), iValor);
  IPSafeAddItemProperty(oObjeto, ipBonificadorCaracteristica);
}
