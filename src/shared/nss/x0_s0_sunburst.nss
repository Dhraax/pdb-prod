//::///////////////////////////////////////////////
//:: Sunburst
//:: X0_S0_Sunburst
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Brilliant globe of heat
// All creatures in the globe are blinded and
// take 6d6 damage
// Undead creatures take 1d6 damage (max 25d6)
// The blindness is permanent unless cast to remove it
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 23 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 14, 2003
//:: Notes: Changed damage to non-undead to 6d6
//:: 2003-10-09: GZ Added Subrace check for vampire special case, bugfix

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

float nSize =  RADIUS_SIZE_COLOSSAL;



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


    //Declare major variables
    string sAOETag;
    object oCaster = OBJECT_SELF;
    int nCasterLvl = GetTotalCasterLevel(oCaster);
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    int nDamage = 0;
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    effect eHitVis = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_FIRE);
    effect eLOS = EffectVisualEffect(2067); //(VFX_FNF_LOS_HOLY_30);
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();

    //Si tiene la dote Urdimbre Sombria el conjuro falla.
      if( GetHasFeat(1354, oCaster))
      {
      SetModuleOverrideSpellScriptFinished();
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(62), oCaster);
      SendMessageToPC(oCaster, "<c�>�Este conjuro no funciona con Urdimbre Sombria.</c>");
      return;
      }
    //Limit Caster level for the purposes of damage
    if (nCasterLvl > 25)
    {
        nCasterLvl = 25;
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eLOS, GetSpellTargetLocation());
    int bDoNotDoDamage = FALSE;


    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        //buscamos entre los efectos de area si alguno coincide con el AoE de Oscuridad
        if (GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
        {
            sAOETag = GetTag(oTarget);
            //erradicamos oscuridad
            if (sAOETag == "VFX_PER_DARKNESS")
            {
                spellsDispelAoE(oTarget, OBJECT_SELF, 50);
            }
        }
        else
        if ((GetHasFeat(FEAT_MASTERY_SHAPES, OBJECT_SELF)) && (GetLocalInt(OBJECT_SELF, "archmage_mastery_shaping") == 1) && (!GetIsReactionTypeHostile(oTarget, OBJECT_SELF) || oTarget == OBJECT_SELF || GetMaster(oTarget) == OBJECT_SELF))
         {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE), oTarget);
        }
    else if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SUNBURST));
            //This visual effect is applied to the target object not the location as above.  This visual effect
            //represents the flame that erupts on the target not on the ground.
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHitVis, oTarget);

            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                if (PB_Race_GetIsUndead(oTarget) || GetRacialType(oTarget) == RACIAL_TYPE_OOZE )
                {
                    //Roll damage for each target
                    nDamage = MaximizeOrEmpower(6, nCasterLvl, nMetaMagic);
                }
                else
                {
                    nDamage = MaximizeOrEmpower(6, 6, nMetaMagic);
               }

                // * if a vampire then destroy it
                if (GetAppearanceType(oTarget) == APPEARANCE_TYPE_VAMPIRE_MALE || GetAppearanceType(oTarget) == APPEARANCE_TYPE_VAMPIRE_FEMALE || GetStringLowerCase(GetSubRace(oTarget)) == "vampire" || GetStringLowerCase(GetSubRace(oTarget)) == "vampiro" )
                {
                    // SpeakString("I vampire");
                    // * if reflex saving throw fails no blindness
                    if (!ReflexSave(oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)), SAVING_THROW_TYPE_SPELL))
                    {
                        effect eDeath = EffectDeath();
                        //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M), oTarget);

                        // Need to make this supernatural, so that it ignores death immunity.
                        eDeath = SupernaturalEffect( eDeath );
                        //Apply epicenter explosion on caster
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplode, oTarget);
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                        bDoNotDoDamage = TRUE;
                    }
                }
                if (bDoNotDoDamage == FALSE)
                    //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)), SAVING_THROW_TYPE_SPELL);

                // * Do damage
                if ((nDamage > 0) && (bDoNotDoDamage == FALSE))
                {
                    //Set the damage effect
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);

                    // Apply effects to the currently selected target.
                    DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));

                     // * if reflex saving throw fails apply blindness
                    if (!ReflexSave(oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)), SAVING_THROW_TYPE_SPELL))
                    {
                        effect eBlindness = EffectBlindness();
                        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBlindness, oTarget);
                    }
                } // nDamage > 0
             }

             //-----------------------------------------------------------------
             // GZ: Bugfix, reenable damage for next object
             //-----------------------------------------------------------------
             bDoNotDoDamage = FALSE;
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE, OBJECT_TYPE_CREATURE);

    }
      DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}


