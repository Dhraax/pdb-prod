//::///////////////////////////////////////////////
//:: PALABRA DE REGRESO
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Palabra de regreso.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 8 de Noviembre de 2011
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

  if(GetHasSpellEffect(990))
  {
      FloatingTextStringOnCreature("<cþ<<>El ancla dimensional te impide usar Palabra de regreso.</c>", OBJECT_SELF, TRUE);
      return;
  }

  if(GetLocalInt(GetArea(OBJECT_SELF), "NOTELEPORT") == 1)
  {
      FloatingTextStringOnCreature("<cþ<<>Este conjuro no se puede usar aquí, algo te lo impide.</c>", OBJECT_SELF, TRUE);
      return;
  }

  // End of Spell Cast Hook
  object oTarget = GetSpellTargetObject();
  AssignCommand(oTarget, ClearAllActions(TRUE));
  AssignCommand(oTarget, ActionStartConversation(oTarget, "conj_regreso", TRUE, FALSE));
  SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
  DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
