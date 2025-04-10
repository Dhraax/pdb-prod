//::///////////////////////////////////////////////
//:: Magic Convalescence functions
//:: NW_S0_MgcConvlF.nss
//:: Created By: Mimiqp (mimiqp100@gmail.com)
//:: Created On: Jun 03, 2024
//:://////////////////////////////////////////////
/*
    Libary of functions for the
    Magic Convalescence spell
*/
//:://////////////////////////////////////////////


#include "inc_spells"

const int SPELL_MAGIC_CONVAL_ID = 1397;
const float SPELL_MAGIC_CONVAL_DUR_MULT = 6.0; //1 round per caster level = 6 seconds per caster level
const float SPELL_MAGIC_CONVAL_RADIUS = 6.7;
const int VFX_IMP_MAGIC_CONVALESCENCE1 = 7204;
const int VFX_IMP_MAGIC_CONVALESCENCE2 = 7205;
const int VFX_IMP_MAGIC_CONVALESCENCE3 = 7206;
const int VFX_MAGIC_CONVALESCENCE_AURA = 7210;
const int VFX_MAGIC_CONVALESCENCE_ICON = 130;
const int VFX_MAGIC_CONVALESCENCE_PROJ = 7211;



//MagicConvalescenceTrigger: function called when a spellcaster is inside the
//aura of the magic convalescence spell and casts a spell, and therefore they
//have to heal the owner of the aura.
//------------------------------------------------------------------------------
void MagicConvalescenceTrigger(object oSource, object oTarget, int nSpellLvlCast);

//This will run the code for the spell Magic Convalescence if the Pre function
//returned TRUE.
void X2PostSpellCastCode_MagicConvalescence();



//------------------------------------------------------------------------------
//MagicConvalescenceTrigger: function called when a spellcaster is inside the
//aura of the magic convalescence spell and casts a spell, and therefore they
//have to heal the owner of the aura.
//oSource: the creature that cast a spell inside the aura
//oTarget: The creature on which the healing by the magic convalescence spell will be applied on
//int nSpellLvlCast: the level of the spell that was cast
//------------------------------------------------------------------------------
void MagicConvalescenceTrigger(object oSource, object oTarget, int nSpellLvlCast)
{
    //-------------------------------------------------------------------------
    //DECLARE MAJOR VARIABLES

    //Special effect for the impact of the healing
//    int nEffect = 679;
    int nRoll=d10();

    int nEffect;
    switch (nRoll)
    {
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
    case 6:
        nEffect = VFX_IMP_MAGIC_CONVALESCENCE1;
        break;
    case 7:
    case 8:
        nEffect = VFX_IMP_MAGIC_CONVALESCENCE2;
        break;
    case 9:
    case 10:
        nEffect = VFX_IMP_MAGIC_CONVALESCENCE3;
        break;
    default:
        nEffect = VFX_IMP_MAGIC_CONVALESCENCE1;
        break;
    }

    string sSource = GetName(oSource);

    //Amount of total healing
    int nHealing = 0;

    //Amount of extra healing due to empower metamagic feat
    //This is not currently implemented but the architecture for this is left
    //in place for future implementation
    int nHealingEmpower = 0;
    int nEmpowered = 0;

    //Amount of extra healing due to the healing domain
    int nHealingDomain = 0;

    //Amount of extra healing due the feat augmented healing
    int nHealingAugmented = 0;

    //Augmented healing constant
    int nAugmentedHealing = 1121;


    //--------------------------------------------------------------------------
    //CALCULATE THE HEALING
    //Check the extra healing in case of having the empower feat
    if (nEmpowered)
    {
        nHealingEmpower = IntDivisionRounding(nSpellLvlCast, 2);
    }

    //Check the extra healing in case of having the healing domain
    if (GetHasFeat(FEAT_HEALING_DOMAIN_POWER, oTarget))
    {
        nHealingDomain = IntDivisionRounding(nSpellLvlCast, 2);
    }

    //Check the extra healing in case of having the augmented healing feat
    if (GetHasFeat(nAugmentedHealing, oTarget))
    {
        //2 points of Augmented Healing x spell level Magic Convalescence = 2 x 5 = 10
        nHealingAugmented = 2*5;
    }

    //Calculate total healing
    nHealing = nSpellLvlCast + nHealingEmpower + nHealingDomain + nHealingAugmented;

    //Set the heal effect
    effect eHeal = EffectHeal(nHealing);
    //Set the VFX impact effect
    effect eVis = EffectVisualEffect(nEffect);


    //--------------------------------------------------------------------------
    //CREATE AND COMPUTE THE HEALING PROJECTILE
    float fDist = GetDistanceBetween(oSource, oTarget);
    float fDelay = fDist / (3.0 * log(fDist) + 2.0) + 0.1;

    effect eMissile = EffectVisualEffect(VFX_MAGIC_CONVALESCENCE_PROJ);

    //--------------------------------------------------------------------------
    //APPLY THE EFFECTS

    //Create the healing projectile effect
    AssignCommand(oSource, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));

    //Apply healing
    DelayCommand(fDelay, AssignCommand(oTarget, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget)));

    //Apply VFX impact
    DelayCommand(fDelay, AssignCommand(oTarget, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget)));



    //--------------------------------------------------------------------------
    // INFORM THE RECEIVER OF THE HEALING IF THEY ARE PC
    if(GetIsPC(oTarget))
    {
        //Prepare string message to inform the player about the amount of healing
        string sInfo = "Convalecencia Mágica (\"" + sSource + "\"). Nivel de conjuro: " + IntToString(nSpellLvlCast)+".";


        if(nHealingEmpower > 0)
        {
            //Add this information into the informative string
            sInfo = sInfo + " Potenciar Conjuro: +" + IntToString(nHealingEmpower)+".";
        }

        if(nHealingDomain > 0)
        {
            //Add this information into the informative string
            sInfo = sInfo + " Dominio de Curación: +" + IntToString(nHealingDomain)+".";
        }

        if(nHealingAugmented > 0)
        {
            sInfo = sInfo + " Curación Aumentada: +" + IntToString(nHealingAugmented)+".";
        }

        sInfo = sInfo + " Total=" + IntToString(nHealing) + ".";

        //sInfo = GetStringColoredRGB(sInfo, 255, 255, 255);
        SendMessageToPC(oTarget, sInfo);
    }
}



//--------------------------------------------------------------------------
// Spell hook - Magic Convalescence
// If OBJECT_SELF is in the aura of a magic convalescence spell, then
// the owner of that aura should receive healing.
//--------------------------------------------------------------------------
void X2PostSpellCastCode_MagicConvalescence()
{
    string sSpellName = "NW_S0_MgcConvlTr";
    int nSpellEffect = 0;
    object oCreator;
    int nSpellLvl=0;

    //Get the first effect on the caster
    effect eEffect = GetFirstEffect(OBJECT_SELF);

    //This will be used as a safeguard, since sometimes the GetNextEffect function when it finds no more effects it still returns the previous effect
    //Therefore, we will compare the previous effect with the current effect
    //If both are the same, then it means that we have reached the last event in the previous iteration
    effect ePreviousEffect;

    //This function does not work because it only works if the effect was created from within the spell's script
    //if (GetHasSpellEffect(nSpellIDMagicConvalescence, OBJECT_SELF))

    //Check if it is a valid effect and begin looping
    //Since sometimes the GetNextEffect function returns the previous effect when it finds no more effects
    //We will compare the previous effect with the current effect
    //If both are the same, then it means that we have already reached the last event in the previous iteration
    while(GetIsEffectValid(eEffect) && !(ePreviousEffect == eEffect))
    {
        //Get the spell ID of the effect
        nSpellEffect = GetEffectSpellId(eEffect);

        //Get the OBJECT representing the creator of the effect
        oCreator = GetEffectCreator(eEffect);

        //If the spell ID is the same as the magic convalescence, then run the effects of the magic convalescence on the creator
        if(nSpellEffect == SPELL_MAGIC_CONVAL_ID && (GetEffectType(eEffect)==EFFECT_TYPE_MOVEMENT_SPEED_INCREASE || oCreator==OBJECT_SELF))
        {
            //Call the Magic Convalescence function
            MagicConvalescenceTrigger(OBJECT_SELF, oCreator, GetLastSpellLevel());
        }

        //Save the previous effect
        ePreviousEffect = eEffect;

        //Pass to the next effect and continue looping
        eEffect = GetNextEffect(OBJECT_SELF);
    }
}
