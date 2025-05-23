#include "cab_inc"

int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(VerSiEsMontura() == TRUE)
  {
      if(VerSiDebeTenerSonidoCaballo()) AssignCommand(oPC, PlaySound("c_horse_slct"));
      else AssignCommand(oPC, PlaySound("c_maggris_slct"));
      return TRUE;
  }

  return FALSE;
}
