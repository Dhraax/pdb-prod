//::///////////////////////////////////////////////
//:: Orc Warlord
//:://////////////////////////////////////////////
/*
    Final Rage - All allies within 10 feet enter a rage.
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

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
    // Declare major variables
    object oTarget;
    location oLoc = GetSpellTargetLocation();
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    float fDelay;

     ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
    //Determine friends in the radius around the character
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, oLoc);
    while (GetIsObjectValid(oTarget))
    {
        if(GetIsFriend(oTarget))
        {
            // Casts rage on target
            AssignCommand(oTarget, ClearAllActions());
            AssignCommand(oTarget, ActionCastSpellAtObject(307, oTarget, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE) );
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, oLoc);
    }
}
