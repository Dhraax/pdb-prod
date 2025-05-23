 #include "f_vampire_spls_h"
int StartingConditional()
{
object oPC = GetPCSpeaker();
string sSubraza = GetStringLowerCase(GetSubRace(oPC));

if (GetIsVampire(oPC)|| sSubraza == "ghul" || sSubraza == "deathknight" || sSubraza == "necropolita" || sSubraza == "liche") return FALSE;
return TRUE;
}
