//::///////////////////////////////////////////////
//:: TRANSPOSICION FUNESTA
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    El lanzador y 1 critura hostil cambian sus posiciones, con tirada de voluntad.
    Si se lanza sobre una criatura de tu grupo, no hay tirada (igual que tranposicion benigna)
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 30 de Mayo de 2010
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "nw_i0_spells"

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

  if(GetLocalInt(GetArea(oCaster), "DISABLE_TRANSPOSITION"))
  {
      SendMessageToPC(oCaster, "<cþ<<>Este conjuro no se puede usar aquí, algo te lo impide.</c>");
      return;
  }

  if(GetLocalInt(oTarget, "DISABLE_TRANSPOSITION"))
  {
      SendMessageToPC(oCaster, "<cþ<<>El objetivo es immune a la tranposición funesta.</c>");
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GLOBE_USE), oTarget);
      return;
  }

  if(!GetIsDead(oTarget) && GetIsObjectValid(oTarget))
  {
      int nHarmful = TRUE;
      if(GetFactionLeader(oCaster) == GetFactionLeader(oTarget))
      {
          nHarmful = FALSE;
      }

      SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), nHarmful));

      if(nHarmful)
      {
          if(ResistSpell(oCaster, oTarget))
          {
              ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE), oTarget);
              return;
          }

          if(MySavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF))))
          {
              ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE), oTarget);
              return;
          }
      }

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
      DelayCommand(1.1, AssignCommand(oCaster, ClearAllActions(TRUE)));
      DelayCommand(1.1, AssignCommand(oTarget, ClearAllActions(TRUE)));
      DelayCommand(1.2, AssignCommand(oCaster, JumpToLocation(lTarget)));
      DelayCommand(1.2, AssignCommand(oTarget, JumpToLocation(lCaster)));
      DelayCommand(1.3, AssignCommand(oCaster, ClearAllActions(TRUE)));
      DelayCommand(1.3, AssignCommand(oTarget, ClearAllActions(TRUE)));
      DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
  }
}
