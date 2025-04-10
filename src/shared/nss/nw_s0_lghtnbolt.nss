//::///////////////////////////////////////////////
//:: Lightning Bolt
//:: NW_S0_LightnBolt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does 1d6 per level in a 5ft tube for 30m
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On:  March 8, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: May 2, 2001

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "vgz_libreria"
#include "pb_nivellanzador"
#include "colors_inc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
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

//Int de Vgzchapuza y pentaculo:
object oItm = GetSpellCastItem();
    if(oItm == OBJECT_INVALID && GetItemPossessedBy(OBJECT_SELF, "polvo_per")!= OBJECT_INVALID)
    {
     pentaculo(GetLocation(OBJECT_SELF),VFX_BEAM_LIGHTNING,1.0);
     SendMessageToPC(OBJECT_SELF,ColorToken(33,33,180) + "!El conjuro parece haberse potenciado con la arenilla de amatista!</c>");
    }
//

    //Declare major variables
    int nCasterLevel = GetTotalCasterLevel(OBJECT_SELF);
    //Limit caster level
    if (nCasterLevel > 10)
    {
        nCasterLevel = 10;
    }
    int nDamage;
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    //Set the lightning stream to start at the caster's hands
    effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF, BODY_NODE_HAND);
    effect eVis  = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
    effect eDamage;
    object oTarget = GetSpellTargetObject();
    location lTarget = GetLocation(oTarget);
    object oNextTarget, oTarget2;
    float fDelay;
    int nCnt = 1;

    oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    while(GetIsObjectValid(oTarget2) && GetDistanceToObject(oTarget2) <= 30.0)
    {
        //Get first target in the lightning area by passing in the location of first target and the casters vector (position)
        oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
        while (GetIsObjectValid(oTarget))
        {
           //Exclude the caster from the damage effects
           if (oTarget != OBJECT_SELF && oTarget2 == oTarget)
           {
                if ((GetHasFeat(FEAT_MASTERY_SHAPES, OBJECT_SELF)) && (GetLocalInt(OBJECT_SELF, "archmage_mastery_shaping") == 1) && (!GetIsReactionTypeHostile(oTarget, OBJECT_SELF) || oTarget == OBJECT_SELF || GetMaster(oTarget) == OBJECT_SELF))
         {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE), oTarget);
        }
	else if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
                {
                   //Fire cast spell at event for the specified target
                   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LIGHTNING_BOLT));
                   //Make an SR check
                   if (!MyResistSpell(OBJECT_SELF, oTarget))
                   {
                        //Roll damage

                        //Vgzchapu
                    int iExtra = 0;
                    int iDano = 0;
                    if(oItm == OBJECT_INVALID && GetItemPossessedBy(OBJECT_SELF, "polvo_per")!= OBJECT_INVALID)
                    {
                    iDano = d6(2);
                    iExtra = 12;

                    object oIngrediente = GetItemPossessedBy(OBJECT_SELF,"polvo_per");
                    DestroyObject(oIngrediente);
                    effect eUki = EffectVisualEffect(77);//electrico
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eUki, oTarget);
                    }
                    //

                        nDamage =  d6(nCasterLevel)  + iDano;;
                        //Enter Metamagic conditions
                        if (nMetaMagic == METAMAGIC_MAXIMIZE)
                        {
                             nDamage = (6 * nCasterLevel) + iExtra;//Damage is at max
                        }
                        if (nMetaMagic == METAMAGIC_EMPOWER)
                        {
                             nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                        }
                        //Adjust damage based on Reflex Save, Evasion and Improved Evasion
                        nDamage = GetReflexAdjustedDamage(nDamage, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)),SAVING_THROW_TYPE_ELECTRICITY);
                        //Set damage effect
                        eDamage = EffectDamage(nDamage, ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_ELECTRICAL));
                        if(nDamage > 0)
                        {
                            fDelay = GetSpellEffectDelay(GetLocation(oTarget), oTarget);
                            //Apply VFX impcat, damage effect and lightning effect
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
                        }
                    }
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,1.0);
                    //Set the currect target as the holder of the lightning effect
                    oNextTarget = oTarget;
                    eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oNextTarget, BODY_NODE_CHEST);
                }
           }
           //Get the next object in the lightning cylinder
           oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
        }
        nCnt++;
        oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
       
    }
 DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
