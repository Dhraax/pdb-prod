//::///////////////////////////////////////////////
//:: Undead Graft
//:: X2_S2_UndGraft1
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Pale Master may use their undead arm to paralyze
    foes for 1d6+2 rounds on a successful melee touch attack

    Save is 14 + pale master level/2


    Elves immune to this effect
    TaB pg 66;
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 05, 2003
//:: Updated On: 2003-07-24, Georg Zoeller (added elf immunity, touch attack check, fixed duration)
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "pb_nivellanzador"

void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    //object oCaster = GetCurrentHitPoints(OBJECT_SELF);
    int nCasterLvl = GetTotalCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    int nRounds = d6(1);

    //Declare effects
    effect ePara = EffectNegativeLevel(1);
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    eDur = EffectLinkEffects(eVis,eDur);

    if (TouchAttackMelee(oTarget,TRUE)>0)
    {

     //Signal spell cast at event
     SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

      //Apply effects to target and caster
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eDur, oTarget);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePara, oTarget, HoursToSeconds(24));

    } else
    {
         // * GZ: According to TaB missed attacks are not wasted.
         int nId = GetSpellId();

         if (nId == 1379)
         {
             IncrementRemainingFeatUses(OBJECT_SELF,1557);
         }
         else if (nId == 1380)
         {
             IncrementRemainingFeatUses(OBJECT_SELF,1558);
         }
         else if (nId == 1381)
         {
             IncrementRemainingFeatUses(OBJECT_SELF,1559);
         }
         else if (nId == 1382)
         {
             IncrementRemainingFeatUses(OBJECT_SELF,1560);
         }
    }
}
