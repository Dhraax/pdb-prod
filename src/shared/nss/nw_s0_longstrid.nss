//::///////////////////////////////////////////////
//:: Longstrider
//:: NW_S0_Longstrid
//:: Copyright (c) 2024 Puerta de Baldur
//:://////////////////////////////////////////////
/*
    This spell increases your base land speed by 10 feet.
    (This adjustment counts as an enhancement bonus.) It has no effect on other
    modes of movement, such as burrow, climb, fly, or swim.
*/
//:://////////////////////////////////////////////
//:: Created By: Puerta de Baldur
//:: Modified By: Mimiqp (mimiqp100@gmail.com)
//:: Modified On: May 20, 2024
//:: Modifications: MVP conversion from
//:: being a function called on object usage to
//:: a spell memorised from the spellbook and used
//:: as any other spell from the game.
//:://////////////////////////////////////////////



#include "x2_inc_spellhook"
#include "x2_inc_switches"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if(!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oPC= OBJECT_SELF;
    int iDuracion= GetLevelByClass(CLASS_TYPE_DRUID, oPC);

    if (GetLevelByClass(CLASS_TYPE_RANGER, oPC)>iDuracion)
    {
      iDuracion= GetLevelByClass(CLASS_TYPE_RANGER, oPC);
    }

    effect eVis = EffectVisualEffect(VFX_IMP_HASTE);

    effect eVelocidad = EffectMovementSpeedIncrease(5 + GetHitDice(oPC));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVelocidad, oPC, HoursToSeconds(iDuracion));

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

