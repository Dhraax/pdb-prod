//::///////////////////////////////////////////////
//:: TELEPORTAR Y TELEPORTAR MAYOR
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Teleportar y Teleportar mayor.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 8 de Noviembre de 2011
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "pb_nivellanzador"
#include "war_utilities"

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

  if (!CheckWarlockSpellCharisma()) return;

  // End of Spell Cast Hook

  object oTarget = OBJECT_SELF;
  int iIdConjuro = GetSpellId();

  if(GetHasSpellEffect(990))
  {
      FloatingTextStringOnCreature("<cþ<<>El ancla dimensional te impide usar Teleportar.</c>", oTarget);
      return;
  }

  if(GetLocalInt(GetArea(oTarget), "NOTELEPORT") == 1)
  {
      FloatingTextStringOnCreature("<cþ<<>Este conjuro no se puede usar aquí, algo te lo impide.</c>", oTarget);
      return;
  }

  SetLocalInt(oTarget, "TELEPORTAR", 2);

  SetLocalInt(oTarget, "NIVEL_LANZADOR_TELEPORTAR", GetTotalCasterLevel(oTarget));

  AssignCommand(oTarget, ClearAllActions(TRUE));
  SetLocalInt(oTarget, "RUTASOMBRAS", TRUE);
  ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_DARKNESS), GetLocation(oTarget), RoundsToSeconds(2));
  AssignCommand(oTarget, ActionStartConversation(oTarget, "conj_teleport", TRUE, FALSE));
  SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
}
