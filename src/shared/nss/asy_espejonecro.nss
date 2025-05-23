//::///////////////////////////////////////////////
//:: FileName asy_espejonecro
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 06/04/2018 1:58:17
//:://////////////////////////////////////////////
#include "f_vampire_spls_h"
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    string sSubraza = GetStringLowerCase(GetSubRace(oPC));
    int iRestriccion1 = GetLocalInt (OBJECT_SELF, "SIGHUL");
    if ((GetIsVampire(oPC)==TRUE)||((GetItemPossessedBy(oPC, "asy_emblemavamp") != OBJECT_INVALID))||((sSubraza == "necropolita")||(sSubraza == "deathknight")||(sSubraza == "ghul") ||(sSubraza == "liche") && (iRestriccion1 != 0)))
      {
        return TRUE;
      }

    return FALSE;

}
