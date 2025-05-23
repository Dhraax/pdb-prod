//::///////////////////////////////////////////////
//:: CEP Creature Wizard
//:: Community Expansion Pack
//:://////////////////////////////////////////////
/*
    Level the creature up in the specified class
*/
//:://////////////////////////////////////////////
//:: Created By:   420
//:: Created On:   April 20, 2009
//:://////////////////////////////////////////////
#include "zep_cw_inc"
#include "nwnx_creature"

void main()
{
object oTarget = GetLocalObject(OBJECT_SELF, "CW_Target");
int nClass = GetLocalInt(OBJECT_SELF, "CW_Class");
int nLevel = StringToInt(GetSpokenString());
int iPackage = StringToInt(Get2DAString("classes", "Package", nClass));
NWNX_Creature_LevelUp(oTarget, nClass, nLevel, iPackage);
TokenList();
}
