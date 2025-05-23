//::///////////////////////////////////////////////
//:: Vampire Aura of the Unnatural On Enter
//:: FV_S1_AuraUnata.nss
//:://////////////////////////////////////////////
/*
    Upon entering the aura, undead will be paralyzed
    if they fail a will save and are lower than
    your level. If they are 5 levels or more lower
    they will save or be dominated. All other
    creatures have a will save
    (DC=10+[Hit Dice/3]) to paralyze or fear depending
    on race/class/gender.
*/
//:://////////////////////////////////////////////
//:: Created By: Fallen
//:://////////////////////////////////////////////
#include "f_vampire_spls_h"
#include "f_vampirebite_h"
#include "lib_race"

void main()
{
    //Declare major variables

    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eCharm = EffectCutsceneParalyze();
    eCharm = EffectLinkEffects(eVis, eCharm);
    effect ePara = EffectParalyze();
    ePara = EffectLinkEffects(eVis, ePara);
    eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
    effect eDom = EffectCutsceneDominated();
    eDom = EffectLinkEffects(eVis, eDom);

    object oTarget = GetEnteringObject();
    int iRace = GetRacialType(oTarget);
    object oOwner = GetAreaOfEffectCreator();
    if(!GetIsObjectValid(oOwner))
        {
        DestroyObject(OBJECT_SELF);
        return;
        }
    int myHD = Determine_Vampire_Level(oOwner);
    int iHDDiff = (GetHitDice(oTarget) > FloatToInt(GetChallengeRating(oTarget))) ? GetHitDice(oTarget) : FloatToInt(GetChallengeRating(oTarget));
    int iDC = 10 + (myHD/2) + GetAbilityModifier(ABILITY_CHARISMA, oOwner);

    iHDDiff = myHD - iHDDiff;

    if(GetIsEnemy(oTarget, oOwner))
        {
        //Racial checks
        if(iRace == RACIAL_TYPE_MAGICAL_BEAST || iRace == RACIAL_TYPE_OUTSIDER ||
           (iRace == RACIAL_TYPE_DRAGON && GetCreatureSize(oTarget) >= CREATURE_SIZE_LARGE)) return;
        else if(PB_Race_GetIsUndead(oTarget) || GetIsVampire(oTarget))
            {
            if(iHDDiff >= 5)
                { //5 level difference, save for dominate, not using
                  //a mind based save since most undead are immune =p
                if (WillSave(oTarget, iDC, SAVING_THROW_TYPE_NONE, oOwner) == 0)
                    {
                    //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDom, oTarget, RoundsToSeconds(myHD/2));
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDom, oTarget, RoundsToSeconds(myHD));
                    }
                }
            else if(iHDDiff > 0)
                { //minor level difference, save for charm, not using
                  //a mind based save since most undead are immune =p
                if (WillSave(oTarget, iDC, SAVING_THROW_TYPE_NONE, oOwner) == 0)
                    {
                    //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharm, oTarget, RoundsToSeconds(myHD/2));
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharm, oTarget, RoundsToSeconds(myHD));
                    }
                } //they are higher level...good luck!
            }
        else if(iHDDiff > 0)
            {
            if(GetIsPlayableRacialType(oTarget) && Random(iDC) > 7)
                {
                if (WillSave(oTarget, iDC, SAVING_THROW_TYPE_MIND_SPELLS, oOwner) == 0)
                    {
                    //Apply the VFX impact and effects
                    //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePara, oTarget, RoundsToSeconds(myHD/3));
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePara, oTarget, RoundsToSeconds(myHD/2));
                    }
                }
            else //not a playable race, or same gender and 'unlucky'
                {
                //Make a fear saving throw check
                if (WillSave(oTarget, iDC, SAVING_THROW_TYPE_FEAR, oOwner) == 0)
                    {
                    //Apply the VFX impact and effects
                    //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFear, oTarget, RoundsToSeconds(myHD/3));
                        if (GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR) == FALSE)
                        {
                            if ((iRace == RACIAL_TYPE_ANIMAL) ||
                                (iRace == RACIAL_TYPE_BEAST) ||
                                (iRace == RACIAL_TYPE_VERMIN) ||
                                (iRace == RACIAL_TYPE_HUMANOID_GOBLINOID) ||
                                (iRace == RACIAL_TYPE_HUMANOID_MONSTROUS) ||
                                (iRace == RACIAL_TYPE_HUMANOID_ORC) ||
                                (iRace == RACIAL_TYPE_HUMANOID_REPTILIAN) ||
                                (iRace == RACIAL_TYPE_DWARF) ||
                                (iRace == RACIAL_TYPE_HALFELF) ||
                                (iRace == RACIAL_TYPE_HALFORC) ||
                                (PB_Race_GetIsElf(oTarget)) ||
                                (iRace == RACIAL_TYPE_GNOME) ||
                                (PB_Race_GetIsHalfling(oTarget)) ||
                                (iRace == RACIAL_TYPE_HUMAN))

                            {
                                eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
                                effect eFear = EffectFrightened();
                                eFear = EffectLinkEffects(eVis, eFear);
                                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFear, oTarget, RoundsToSeconds(myHD/2));
                            }
                        }

                    }
                }
            }
        }
}
