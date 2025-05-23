//::///////////////////////////////////////////////
//:: Darkness: On Exit
//:: NW_S0_DarknessB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 28, 2002
//:://////////////////////////////////////////////
#include "x2_inc_spellhook"
#include "nw_i0_spells"
#include "inc_spells"

void main()
{
    gsSPRemoveEffect(
        GetExitingObject(),
        GetSpellId(),
        GetAreaOfEffectCreator());
}
