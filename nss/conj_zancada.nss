//::///////////////////////////////////////////////
//:: ZANCADA ARBOREA
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Zancada arborea.
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

  // End of Spell Cast Hook
  object oTarget = GetSpellTargetObject();

  if(GetStringLeft(GetTag(oTarget), 15) != "zancadruid_tree")
  {
      FloatingTextStringOnCreature("<cþ<<>¡El objetivo no es un árbol válido para Zancada arbórea!</c>", OBJECT_SELF, FALSE);
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
      return;
  }

  if(GetHasSpellEffect(990))
  {
      FloatingTextStringOnCreature("<cþ<<>El ancla dimensional te impide usar Zancada arbórea.</c>", OBJECT_SELF);
      return;
  }

  AssignCommand(OBJECT_SELF, ClearAllActions(TRUE));
  AssignCommand(OBJECT_SELF, ActionStartConversation(OBJECT_SELF, "conj_zancada", TRUE, FALSE));
  DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
