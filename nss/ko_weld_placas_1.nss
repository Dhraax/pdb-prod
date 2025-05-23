#include "nw_i0_tool"

int StartingConditional()  //Miramos si tiene entrenada descifrar escritura
{
object oPC = GetPCSpeaker();
int iRangoBase = GetSkillRank (29, oPC, TRUE);
string sIdioma = GetLocalString (OBJECT_SELF, "IDIOMA");

if ((iRangoBase > 0)&& !HasItem(oPC, sIdioma))
    {
    return TRUE;
    }
else
    {
    return FALSE;
    }
}
