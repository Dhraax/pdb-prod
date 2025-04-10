void main()
{
  object oPC = GetEnteringObject();
  int iManrobau = GetLocalInt(oPC,"Manrobau");

  if(GetLocalInt(oPC,"Manrobau") == 1 && GetGold(oPC) > 0)
  {
      int iOroLadrones = GetCampaignInt("ingresos","dinerocofr");
      int iOroARobar = d20() + 20;
      SetCampaignInt("ingresos", "dinerocofr", iOroLadrones + iOroARobar);
      SetLocalInt(oPC, "Manrobau", 0);
      TakeGoldFromCreature(iOroARobar, oPC);
      FloatingTextStringOnCreature("*Cuando miras en tus bolsillos notas que te falta algo de oro*", oPC);
  }
}
