void main()
{
  object oMod = GetModule();

  if(GetLocalInt(oMod, "AMNAESTAFERMOS") == 1) return;
  SetLocalInt(oMod, "AMNAESTAFERMOS", 1);
  DelayCommand(6.0, DeleteLocalInt(oMod, "AMNAESTAFERMOS"));

  object oGuardia1 = GetNearestObjectByTag("amna_pegapalos1");
  if(GetIsInCombat(oGuardia1) == TRUE) return;

  object oEstafermo1 = GetNearestObjectByTag("amna_estafermo1");
  AssignCommand(oGuardia1, ActionAttack(oEstafermo1));
}
