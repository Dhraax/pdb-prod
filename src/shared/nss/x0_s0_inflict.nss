//::///////////////////////////////////////////////
//:: [Inflict Wounds]
//:: [X0_S0_Inflict.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
//:: This script is used by all the inflict spells
//::
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 2002
//:://////////////////////////////////////////////
//:: Monti (10/03/12): Anyadida compatibilidad con conjuros de guardia negro

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
*/
    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
// End of Spell Cast Hook

    int nSpellID = GetSpellId();
    switch (nSpellID)
    {
/*Minor*/     case 431: case 1190: spellsInflictTouchAttack(1, 0, 1, 246, VFX_IMP_HEALING_G, nSpellID); break;
/*Light*/     case 432: case 1074: case 1198: spellsInflictTouchAttack(d8(), 5, 8, 246, VFX_IMP_HEALING_G, nSpellID); break;
/*Moderate*/  case 433: case 1080: case 1208: spellsInflictTouchAttack(d8(2), 10, 16, 246, VFX_IMP_HEALING_G, nSpellID); break;
/*Serious*/   case 434: case 611: case 1085: case 1217: spellsInflictTouchAttack(d8(3), 15, 24, 246, VFX_IMP_HEALING_G, nSpellID); break;
/*Critical*/  case 435: case 612: case 1091: case 1227: spellsInflictTouchAttack(d8(4), 20, 32, 246, VFX_IMP_HEALING_G, nSpellID); break;
   DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    }
}
