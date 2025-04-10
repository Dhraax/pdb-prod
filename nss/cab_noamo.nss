#include "cab_inc"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  string sAmo = GetLocalString(OBJECT_SELF, "AMO");

  if(VerSiEsMascota() == TRUE) return FALSE;

  if(sAmo != GetName(oPC, TRUE))
  {
      if(VerSiDebeTenerSonidoCaballo()) AssignCommand(oPC, PlaySound("c_horse_hit2"));
      else AssignCommand(oPC, PlaySound("c_maggris_hit1"));
      return TRUE;
  }

  return FALSE;
}
