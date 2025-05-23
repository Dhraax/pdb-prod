#include "mti_libreria"
void main()
{
  object oMod = GetModule();
  if(GetLocalInt(oMod, "CRESTAFERMOS") == 1) return;

  SetLocalInt(oMod, "CRESTAFERMOS", 1);
  DelayCommand(6.0, DeleteLocalInt(oMod, "CRESTAFERMOS"));

  object oGuardia1 = GetNearestObjectByTag("cr_pegapalos1");
  object oGuardia2 = GetNearestObjectByTag("cr_pegapalos2");

 //if(GetIsInCombat(oGuardia1) == TRUE) return;
// if(GetIsInCombat(oGuardia2) == TRUE) return;

  object oEstafermo1 = GetNearestObjectByTag("cr_estafermo1");
  object oEstafermo2 = GetNearestObjectByTag("cr_estafermo2");

  AssignCommand(oGuardia1, ActionAttack(oEstafermo1));
  AssignCommand(oGuardia2, ActionAttack(oEstafermo2));
}
