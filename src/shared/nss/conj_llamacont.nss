//::///////////////////////////////////////////////
//:: LLAMA CONTINUA
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Llama continua (con distintos colores).
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 4 de Junio de 2010
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "nw_i0_spells"

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
  int nLightVFX;
  int nLightIP;
  int nSpellId = GetSpellId();

  //Si tiene la dote Urdimbre Sombria el conjuro falla.
      if( GetHasFeat(1354, oCaster))
      {
      SetModuleOverrideSpellScriptFinished();
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(62), oCaster);
      SendMessageToPC(oCaster, "<cÂ>¡Este conjuro no funciona con Urdimbre Sombria.</c>");
      return;
      }

  switch(nSpellId)
  {
      case 1066: nLightVFX = VFX_DUR_LIGHT_BLUE_20;   nLightIP = IP_CONST_LIGHTCOLOR_BLUE;   break;
      case 1067: nLightVFX = VFX_DUR_LIGHT_ORANGE_20; nLightIP = IP_CONST_LIGHTCOLOR_ORANGE; break;
      case 1068: nLightVFX = VFX_DUR_LIGHT_PURPLE_20; nLightIP = IP_CONST_LIGHTCOLOR_PURPLE; break;
      case 1069: nLightVFX = VFX_DUR_LIGHT_RED_20;    nLightIP = IP_CONST_LIGHTCOLOR_RED;    break;
      case 1070: nLightVFX = VFX_DUR_LIGHT_YELLOW_20; nLightIP = IP_CONST_LIGHTCOLOR_YELLOW; break;
  }

  int nType = GetObjectType(oTarget);
  if(nType == OBJECT_TYPE_ITEM)
  {
      if(!IPGetIsItemEquipable(oTarget))
      {
          FloatingTextStrRefOnCreature(83326, oCaster);
          return;
      }

      itemproperty ip = ItemPropertyLight (IP_CONST_LIGHTBRIGHTNESS_BRIGHT, nLightIP);
      IPSafeAddItemProperty(oTarget, ip, 99999.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,TRUE,TRUE);
  }

  else
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
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectLinkEffects(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), EffectVisualEffect(nLightVFX)), oTarget);
      SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellId, FALSE));
      DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
  }
}

