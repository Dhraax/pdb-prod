void main()
{
  object oMod = GetModule();
  if(GetLocalInt(oMod, "USTESTAFERMOS") == 1) return;

  SetLocalInt(oMod, "USTESTAFERMOS", 1);
  DelayCommand(6.0, DeleteLocalInt(oMod, "USTESTAFERMOS"));

  object oGuardia1 = GetNearestObjectByTag("ust_pegapalos1");
  object oGuardia2 = GetNearestObjectByTag("ust_pegapalos2");

  if(GetIsInCombat(oGuardia1) == TRUE) return;
  if(GetIsInCombat(oGuardia2) == TRUE) return;

  object oEstafermo1 = GetNearestObjectByTag("ust_estafermomele1");
  object oEstafermo2 = GetNearestObjectByTag("ust_estafermomele2");

  AssignCommand(oGuardia1, ActionAttack(oEstafermo1));
  AssignCommand(oGuardia2, ActionAttack(oEstafermo2));
}
