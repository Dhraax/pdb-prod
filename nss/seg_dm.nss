#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetIsDM(oPC) || GetIsDMPossessed(oPC) && GetLocalInt(oPC, "SEG_DM")) return TRUE;
  else return FALSE;
}
