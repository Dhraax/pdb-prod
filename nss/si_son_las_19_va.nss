#include "f_vampire_spls_h"
int StartingConditional()
{
object oPC = GetPCSpeaker();
if ((GetIsVampire(oPC))&&(GetTimeHour() == 19)||(GetIsVampire(oPC))&&(GetTimeHour() == 20))return TRUE;
return FALSE;
}
