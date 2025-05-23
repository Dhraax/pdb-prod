#include "f_vampire_spls_h"
void main()
{
    object oPC = GetLastUsedBy();
    string sSubraza = GetStringLowerCase(GetSubRace(oPC));
    int baliado = FALSE;
    if (GetItemPossessedBy(oPC, "asy_emblemavamp") != OBJECT_INVALID) baliado== TRUE;
    if ((GetIsVampire(oPC)==TRUE) || (sSubraza == "ghul") || (sSubraza == "deathknight") || (sSubraza == "necropolita") ||(sSubraza == "liche") || (baliado==TRUE))
    {
        ActionStartConversation(oPC);
    }

}
