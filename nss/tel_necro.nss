#include "mti_libreria"
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    string sSubraza = GetStringLowerCase(GetSubRace(oPC));
    if(sSubraza == "vampiro" ||
       sSubraza == "ghul" ||
       sSubraza == "deathknight" ||
       sSubraza  == "necropolita" ||
       sSubraza  == "liche"
       ){ return TRUE;  }

    return FALSE;
}
