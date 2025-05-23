//::///////////////////////////////////////////////
//:: LUZ
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Luz (con distintos colores).
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 4 de Junio de 2010
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"
#include "colors_inc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
  /*
    Spellcast Hook Code
    Added 2003-07-07 by Georg Zoeller
    If you want to make changes to all spells,
    check x2_inc_spellhook.nss to find out more
  */

  if (!X2PreSpellCastCode())
  {
      // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
      return;
  }

  // End of Spell Cast Hook

  object oCaster = OBJECT_SELF;
  object oTarget = GetSpellTargetObject();
  int nType = GetObjectType(oTarget);
  float fDuration = HoursToSeconds(GetTotalCasterLevel(oCaster));

  //Si tiene la dote Urdimbre Sombria el conjuro falla.
      if( GetHasFeat(1354, oCaster))
      {
      SetModuleOverrideSpellScriptFinished();
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(62), oCaster);
      SendMessageToPC(oCaster, ColorToken(254,60,60) + "Este conjuro no funciona con Urdimbre Sombria.</c>");
      return;
      }

  if((GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE) == METAMAGIC_EXTEND)
  {
      fDuration = fDuration * 2;
  }

  int nLightVFX;
  int nLightIP;
  int nSpellId = GetSpellId();
  switch(nSpellId)
  {
      case 1061: nLightVFX = VFX_DUR_LIGHT_BLUE_20;   nLightIP = IP_CONST_LIGHTCOLOR_BLUE;   break;
      case 1062: nLightVFX = VFX_DUR_LIGHT_ORANGE_20; nLightIP = IP_CONST_LIGHTCOLOR_ORANGE; break;
      case 1063: nLightVFX = VFX_DUR_LIGHT_PURPLE_20; nLightIP = IP_CONST_LIGHTCOLOR_PURPLE; break;
      case 1064: nLightVFX = VFX_DUR_LIGHT_RED_20;    nLightIP = IP_CONST_LIGHTCOLOR_RED;    break;
      case 1065: nLightVFX = VFX_DUR_LIGHT_YELLOW_20; nLightIP = IP_CONST_LIGHTCOLOR_YELLOW; break;
  }

  if(nType == OBJECT_TYPE_CREATURE || nType == OBJECT_TYPE_PLACEABLE)
  {
      RemoveSpellEffects(1061, oCaster, oTarget);//Light_Blue
      RemoveSpellEffects(1062, oCaster, oTarget);//Light_Orange
      RemoveSpellEffects(1063, oCaster, oTarget);//Light_Purple
      RemoveSpellEffects(1064, oCaster, oTarget);//Light_Red
      RemoveSpellEffects(1065, oCaster, oTarget);//Light_Yellow
      RemoveSpellEffects(1066, oCaster, oTarget);//Continual_Blue
      RemoveSpellEffects(1067, oCaster, oTarget);//Continual_Orange
      RemoveSpellEffects(1068, oCaster, oTarget);//Continual_Purple
      RemoveSpellEffects(1069, oCaster, oTarget);//Continual_Red
      RemoveSpellEffects(1070, oCaster, oTarget);//Continual_Yellow
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), EffectVisualEffect(nLightVFX)), oTarget, fDuration);
      SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellId, FALSE));
  }

  else if(nType == OBJECT_TYPE_ITEM)
  {
      if(!IPGetIsItemEquipable(oTarget))
      {
          FloatingTextStrRefOnCreature(83326, oCaster);
          return;
      }

      if(GetItemHasItemProperty(oTarget, ITEM_PROPERTY_LIGHT))
      {
          IPRemoveMatchingItemProperties(oTarget, ITEM_PROPERTY_LIGHT, DURATION_TYPE_TEMPORARY);
      }

      AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_BRIGHT, nLightIP), oTarget, fDuration);
      DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
  }
}
