//::///////////////////////////////////////////////
//:: Cone of Cold
//:: NW_S0_ConeCold
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Cone of cold creates an area of extreme cold,
// originating at your hand and extending outward
// in a cone. It drains heat, causing 1d6 points of
// cold damage per caster level (maximum 15d6).
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: 10/18/02000
//:://////////////////////////////////////////////
//:: Last Updated By: Aidan Scanlan On: April 11, 2001
//:: Update Pass By: Preston W, On: July 25, 2001

float SpellDelay (object oTarget, int nShape);

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
      if(oItm == OBJECT_INVALID && GetItemPossessedBy(OBJECT_SELF, "polvo_zaf")!= OBJECT_INVALID)
      {
      pentagramahaciasi(GetLocation(OBJECT_SELF),VFX_BEAM_COLD,1.0);
      SendMessageToPC(OBJECT_SELF, ColorToken(33,33,180) + "!El conjuro parece haberse potenciado con la arenilla de zafiro!</c>");
      }
//

    //Declare major variables
    int nCasterLevel = GetTotalCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    int nDamage;
    float fDelay;
    location lTargetLocation = GetSpellTargetLocation();
    object oTarget;
    //Limit Caster level for the purposes of damage.
    if (nCasterLevel > 15)
    {
        nCasterLevel = 15;
    }
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
         if ((GetHasFeat(FEAT_MASTERY_SHAPES, OBJECT_SELF)) && (GetLocalInt(OBJECT_SELF, "archmage_mastery_shaping") == 1) && (!GetIsReactionTypeHostile(oTarget, OBJECT_SELF) || oTarget == OBJECT_SELF || GetMaster(oTarget) == OBJECT_SELF))
         {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE), oTarget);
        }
	else if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
     // March 2003. Removed this as part of the reputation pass
     //            if((GetSpellId() == 340 && !GetIsFriend(oTarget)) || GetSpellId() == 25)
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONE_OF_COLD));
                //Get the distance between the target and caster to delay the application of effects
                fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20.0;
                //Make SR check, and appropriate saving throw(s).
                if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay) && (oTarget != OBJECT_SELF))
                {
                    //Detemine damage
                    //Vgzchapu
                    int iExtra = 0;
                    int iDano = 0;
                    if(oItm == OBJECT_INVALID && GetItemPossessedBy(OBJECT_SELF, "polvo_zaf")!= OBJECT_INVALID)
                    {
                    iDano = d6(2);
                    iExtra = 12;
                    object oIngrediente = GetItemPossessedBy(OBJECT_SELF,"polvo_zaf");
                    DestroyObject(oIngrediente);

                    effect eUki = EffectVisualEffect(19);//hielo
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eUki, oTarget);
                    }
                    //
                    nDamage = d6(nCasterLevel) + iDano;
                    //Enter Metamagic conditions
                    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                    {
                         nDamage = (6 * nCasterLevel) + iExtra;//Damage is at max (Extra vgzchapu)
                    }
                    else if (nMetaMagic == METAMAGIC_EMPOWER)
                    {
                         nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                    }
                    //Adjust damage according to Reflex Save, Evasion or Improved Evasion
                    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)), SAVING_THROW_TYPE_COLD);

                    // Apply effects to the currently selected target.
                    effect eCold = EffectDamage(nDamage, ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_COLD));
                    effect eVis = EffectVisualEffect(VFX_IMP_FROST_L);
                    if(nDamage > 0)
                    {
                        //Apply delayed effects
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCold, oTarget));
                    }
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
       
    }
 DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
