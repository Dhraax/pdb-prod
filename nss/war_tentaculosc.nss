//::///////////////////////////////////////////////
//:: Evards Black Tentacles: Heartbeat
//:: NW_S0_EvardsB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon remaining within the mass of rubbery tentacles the
    target is struck by 1d4 + 1/lvl tentacles.  Each
    makes a grapple check. If it succeeds then
    it does 1d6+4 damage and the target must make
    a Fortitude Save versus paralysis or be paralyzed
    for 1 round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 23, 2001
//:://////////////////////////////////////////////
//:: GZ: Removed SR, its not there by the book


#include "X0_I0_SPELLS"

void main()
{
    //Declare major variables
  object oTarget = GetExitingObject();
  object oPC = GetAreaOfEffectCreator();

     //Eliminamos los efectos al salir
     RemoveSpellEffects(1349, oPC, oTarget);
     DeleteLocalInt(oTarget, "TENTACULOS");
     ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE), oTarget);

}
