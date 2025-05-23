//::///////////////////////////////////////////////
//:: DETECTAR MUERTOS VIVIENTES
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Detectar muertos vivientes.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 19 de Junio de 2013
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "conj_det_inc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_DIVINATION);
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

  Detectar(OBJECT_SELF, GetSpellId());
  DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
