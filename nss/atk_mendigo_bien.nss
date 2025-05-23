void main()
{
  object oPC = GetPCSpeaker();

  if(GetGold(oPC) > 0)
  {
      AssignCommand(oPC, TakeGoldFromCreature(1, oPC, TRUE));
      SetLocalInt(OBJECT_SELF, "ATKMENDIGO", 1);
      DelayCommand(1000.0, DeleteLocalInt(OBJECT_SELF, "ATKMENDIGO"));
  }

  else
  {
      FloatingTextStringOnCreature("¡No tienes una moneda de oro!", oPC);
  }
}
