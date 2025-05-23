void main()
{
  object oPC = GetEnteringObject();
  object oMod = GetModule();

  // Solo PJs
  if(GetIsPC(oPC) == FALSE) return;

  // Antisaturamiento
  if(GetLocalInt(oMod, "PAREXPLO") == 1) return;
  SetLocalInt(oMod, "PAREXPLO", 1);
  DelayCommand(6.0, DeleteLocalInt(oMod, "PAREXPLO"));

  object oGuardia1 = GetNearestObjectByTag("par_anirin");
  object oEstafermo1 = GetNearestObjectByTag("par_palo");

  if(GetIsDay() == FALSE)
  {
      if(GetIsInCombat(oGuardia1) == TRUE) AssignCommand(oGuardia1, ClearAllActions(TRUE));
  }

  else
  {
      if(d2() == 1)
      {
          if(GetIsInCombat(oGuardia1) == FALSE)
          {
              AssignCommand(oGuardia1, ActionAttack(oEstafermo1));
              DelayCommand(60.0, AssignCommand(oGuardia1, ClearAllActions(TRUE)));
          }
      }
  }
}
