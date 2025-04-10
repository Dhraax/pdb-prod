#include "pb_nivellanzador"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  string sAmo = GetLocalString(OBJECT_SELF, "AMO");
  int nCasterLevel = GetTotalCasterLevel(oPC);
  int nControlDG = nCasterLevel *2;
  int nNiveles = GetHitDice(OBJECT_SELF);
  int nDG = GetLocalInt(oPC, "UNDEADDG");


  if(sAmo == GetName(oPC))
  {
      //Recuperamos al nomuerto si tenemos sitio
	    if(nDG < nControlDG){
        AddHenchman(oPC);
		      SetLocalInt(oPC, "UNDEADDG", nDG + nNiveles);
        		}
     return TRUE;
  }

  return FALSE;
}
