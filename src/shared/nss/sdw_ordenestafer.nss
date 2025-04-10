#include "mti_libreria"
void main()
{
  object oMod = GetModule();

  if(GetLocalInt(oMod, "SDW_ORDENESTAFERMOS") == 1) return;
  SetLocalInt(oMod, "SDW_ORDENESTAFERMOS", 1);
  DelayCommand(6.0, DeleteLocalInt(oMod, "SDW_ORDENESTAFERMOS"));

  object oGuardia1 = GetNearestObjectByTag("sdw_postulantepegapalos1");
  object oGuardia2 = GetNearestObjectByTag("sdw_postulantepegapalos2");

  if(GetIsInCombat(oGuardia1) == TRUE) return;
  if(GetIsInCombat(oGuardia2) == TRUE) return;

  object oEstafermo1 = GetNearestObjectByTag("sdw_estafermo1");
  object oEstafermo2 = GetNearestObjectByTag("sdw_estafermo2");

  AssignCommand(oGuardia1, ActionAttack(oEstafermo1));
  AssignCommand(oGuardia2, ActionAttack(oEstafermo2));
}
