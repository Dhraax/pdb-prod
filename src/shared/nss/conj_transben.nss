//::///////////////////////////////////////////////
//:: TRANSPOSICION BENIGNA
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    El lanzador y 1 criatura de tu grupo cambian sus posiciones, sin tirada.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 30 de Mayo de 2010
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
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

  if(GetLocalInt(GetArea(oCaster), "DISABLE_TRANSPOSITION") ||
     GetLocalInt(oTarget, "DISABLE_TRANSPOSITION"))
  {
      SendMessageToPC(oCaster, "<cþ<<>Este conjuro no se puede usar aquí, algo te lo impide.</c>");
      return;
  }

  if(!GetIsDead(oTarget) && GetIsObjectValid(oTarget) && GetFactionLeader(oCaster) == GetFactionLeader(oTarget))
  {
      SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
      location lCaster = GetLocation(oCaster);
      location lTarget = GetLocation(oTarget);
      effect eVisual1 = EffectVisualEffect(VFX_IMP_CHARM);
      effect eVisual2 = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual1, oCaster);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual1, oTarget);
      DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual1, oCaster));
      DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual1, oTarget));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual2, oCaster);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual2, oTarget);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oCaster, 1.5);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oTarget, 1.5);
      AssignCommand(oCaster, ClearAllActions(TRUE));
      AssignCommand(oTarget, ClearAllActions(TRUE));
      DelayCommand(1.0, AssignCommand(oCaster, ClearAllActions(TRUE)));
      DelayCommand(1.0, AssignCommand(oTarget, ClearAllActions(TRUE)));
      DelayCommand(1.1, AssignCommand(oCaster, JumpToLocation(lTarget)));
      DelayCommand(1.1, AssignCommand(oTarget, JumpToLocation(lCaster)));
      DelayCommand(1.2, AssignCommand(oCaster, ClearAllActions(TRUE)));
      DelayCommand(1.2, AssignCommand(oTarget, ClearAllActions(TRUE)));
      DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
  }
  else
  {
      SendMessageToPC(oCaster, "<cþþþ>El objetivo del conjuro debe ser un PJ de tu grupo.</c>");
      return;
  }
}
