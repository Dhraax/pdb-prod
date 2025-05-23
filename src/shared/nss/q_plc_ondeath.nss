//::///////////////////////////////////////////////
//:: Placeable OnPhysicalAttacked Script
//:: q_plc_ondeath.nss
//:://////////////////////////////////////////////
/*
    On death of a door or placeable it spawns in an appropriate
    item component.

    To use this system the following variable must be placed upon your
    placeable objects:

    Q_MATERIAL_ID (int) - identifies the material the object is made from,
                          possible values are:

                          0 Invalid
                          1 Wood
                          2 Metal
                          3 Stone
*/
//:://////////////////////////////////////////////
//:: Created By: Pstemarie
//:: Created On: July 14, 2011
//:://////////////////////////////////////////////

const int MIN_SKILL_LEVEL = 5;

void main()
{
    //declare major variables
    object oSlayer = GetLastKiller();
    string sResRef;

    // * only drop components if the player has some decent skill level
    // * the reason is to prevent clutter for players who have no interest
    // * in the crafting system
    if (GetSkillRank(SKILL_CRAFT_ARMOR, oSlayer) > MIN_SKILL_LEVEL || GetSkillRank(SKILL_CRAFT_WEAPON, oSlayer) > MIN_SKILL_LEVEL)
    {
        int nMat = GetLocalInt(OBJECT_SELF, "Q_MATERIAL_ID");

        switch(nMat)
        {
            case 0: break; //material invalid - no craftable component to drop
            case 1: sResRef = "x2_it_cmat_oakw"; break; //wood
            case 2: sResRef = "x2_it_cmat_iron"; break; //metal
            case 3: break; //stone - no craftable component to not drop
        }
        if (sResRef != "")
        {
            location lLoc = GetLocation(OBJECT_SELF);
            CreateObject(OBJECT_TYPE_ITEM, sResRef, lLoc);
        }
    }
}
