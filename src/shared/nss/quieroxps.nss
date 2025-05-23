void main()
{
  if(GetLocalInt(OBJECT_SELF, "NOSATURAR") == TRUE) return;
  SetLocalInt(OBJECT_SELF, "NOSATURAR", TRUE);
  DelayCommand(6.0, DeleteLocalInt(OBJECT_SELF, "NOSATURAR"));

  object oPC = GetLastAttacker();

  if(GetXP(oPC) < 15000)
  {
      DelayCommand(4.0, GiveXPToCreature(oPC, 10 + d6()));
      DelayCommand(4.1, AssignCommand(oPC, ClearAllActions(TRUE)));
      DelayCommand(4.2, FloatingTextStringOnCreature("<c´þd>* El entrenamiento aumenta tu experiencia *</c>", oPC));
  }

  else
  {
      SendMessageToPC(oPC, "<cþ>Eres lo suficiente experimentado en la batalla como para ganar más experiencia golpeando estos simples estafermos o dianas. No recibirás más experiencia.</c>");
  }
}
