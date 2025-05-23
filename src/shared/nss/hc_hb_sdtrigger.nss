//::///////////////////////////////////////////////
//:: Secret Door invis object
//:: V 1.6
//:: Copyright (c) 2001 Bioware Corp. //:://////////////////////////////////////////////
/*
    This Invisable object will do a check and see
    if any elf comes within a radius of this object.

    It will create a trap door that will have its
    Destination set to a waypoint that has
    a tag of DST_<tag of this object>

    The radius is determined by the reflex saving
    throw of the invisible object

    The DC of the search stored by the willpower
    saving throw.

*/
//:://////////////////////////////////////////////
//:: Created By  : Robert Babiak
//:: Created On  : June 25, 2002
//::---------------------------------------------
//:: Modifyed By : Robert Babiak
//:: Modifyed On : July 24, 2002
//:: Modification: Changed the name of the blueprint
//:: used to create a wall door instead, and also
//:: incorporated a optimization to reduce CPU usage.
//::---------------------------------------------
//:: Modifyed By : Robert Babiak
//:: Modifyed On : July 25, 2002
//:: fixed problem with the aborting of the search
//:: for PC that where in the search radius.
//:: it was aborting when it got found a PC that
//:: outside the search distance, but this also
//:: canceled the search check.
//::
//:: This will teach me to trust code mailed in
//:: from users...
//::---------------------------------------------
//:: Modified By: Tromador
//:: Modified On: August 4, 2002
//:: The hakpak causes save/load issues.
//:: Modified to use a standard "portal" type
//:: placeable, instead of the custom hakpak models.
//::----------------------------------------------
//:: Modified By: Whyteshadow
//:: Modified On: August 4, 2002
//:: Only elves can search passively.
//:: Also, every elf in range will search,
//:: not just the one with the best skill.
//:: Also, the elf must be able to SEE the
//:: location of the door.
//::----------------------------------------------
//:: Modified By: yibble <yibble@yibble.org>
//:: Modified On: September 25, 2002
//:: Using GetDetectMode function to avoid using the
//:: SearchTool.
//::----------------------------------------------
//:://////////////////////////////////////////////

#include "hc_text_doors"
#include "lib_race"

void main()
{
    // set to time in seconds that you want to rehide the secret door.
    float fRehideTime = 60.0;

    if (GetLocalInt(OBJECT_SELF, "bFound") == TRUE)
        return;

    if (GetLocalInt(OBJECT_SELF, "bReset") == TRUE)
    {
        object oDoor = GetLocalObject(OBJECT_SELF, "Door");
        SetPlotFlag(oDoor, FALSE);
        if (oDoor != OBJECT_INVALID)
            DestroyObject(oDoor);
        DeleteLocalObject(OBJECT_SELF, "Door");
        DeleteLocalInt(OBJECT_SELF, "bReset");
    }

    object oUser;
    location lDoor = GetLocation(OBJECT_SELF);
    int nDetectMode;
    float fSearchDist = 25.0;
    oUser = GetFirstObjectInShape(SHAPE_SPHERE, fSearchDist, lDoor, TRUE, OBJECT_TYPE_CREATURE);

    while(GetIsObjectValid(oUser))
    {
        if((nDetectMode = GetDetectMode(oUser)))
        {
            int nRogueLevel = GetLevelByClass(CLASS_TYPE_ROGUE, oUser);
            location locPlayer = GetLocation(oUser);
            float fDis = FeetToMeters(5.0);
            int nFT = FALSE;


            if(nDetectMode == DETECT_MODE_ACTIVE)
            {
                fDis = FeetToMeters(IntToFloat(GetReflexSavingThrow(OBJECT_SELF)));
                nFT = TRUE;
            }

            // Hidden door detection
            if (((GetLocalInt(OBJECT_SELF, "bFound") != TRUE) && (GetDistanceToObject(oUser) <= fDis) && (nFT)) || ((GetLocalInt(OBJECT_SELF, "bFound") != TRUE) && (GetDistanceToObject(oUser) <= fDis) && (nDetectMode != DETECT_MODE_ACTIVE) && (PB_Race_GetIsElf(oUser))))
            {
                string strTag = GetTag(OBJECT_SELF);
                location locDoor = GetLocation(OBJECT_SELF);
                int nDC = GetWillSavingThrow(OBJECT_SELF) - 100;
                int nSearch = GetSkillRank(SKILL_SEARCH, oUser);
                int nRoll = d20();

                //SendMessageToPC(oUser, "DEBUG: DETECT_MODE was " + IntToString(nDetectMode) + ". fDis was " + FloatToString(fDis) + ". nFT was " + IntToString(nFT) + ". nDC was " + IntToString(nDC) + ". nRoll was " + IntToString(nRoll) + ". nSearch was " + IntToString(nSearch) + ".");

                // Search is not a trained skill, so a search of 0 is valid
                if ((nRoll + nSearch) >= nDC)
                {
                    // yes we found it, now create a door for us to use. it.
                    object oidDoor;
                    //Let's create the correct type of object for the trigger we are
                    if(GetResRef(OBJECT_SELF) == "hc_pl_hiddendr04")
                        {
                        oidDoor = CreateObject(OBJECT_TYPE_PLACEABLE, "nw_pl_hiddendr03", locDoor, TRUE);
                        FloatingTextStringOnCreature(TRAPDOORFOUND, oUser, FALSE);
                        }
                    else if(GetResRef(OBJECT_SELF) == "hc_pl_hiddendr02")
                        {
                        oidDoor = CreateObject(OBJECT_TYPE_PLACEABLE, "nw_pl_hiddendr01", locDoor, TRUE);
                        FloatingTextStringOnCreature(DOORFOUND, oUser, FALSE);
                        }
                    SetLocalString( oidDoor, "Destination" , "dst_" + strTag );
                    SetPlotFlag(oidDoor,1);
                    SetLocalInt(OBJECT_SELF, "bFound", TRUE);
                    SetLocalObject(OBJECT_SELF, "Door", oidDoor);
                    DelayCommand(fRehideTime, SetLocalInt(OBJECT_SELF, "bFound", FALSE));
                    DelayCommand(fRehideTime, SetLocalInt(OBJECT_SELF, "bReset", TRUE));
                }
            }
        }
        oUser = GetNextObjectInShape(SHAPE_SPHERE, fSearchDist, lDoor, TRUE, OBJECT_TYPE_CREATURE);
    }
}
