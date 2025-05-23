void main()
{
  object oPJ = GetLastUsedBy();
  string sSubraza = GetStringLowerCase(GetSubRace(oPJ));
  object oTrampilla = OBJECT_SELF;
  object oLlave = GetItemPossessedBy(oPJ, "llav_crip_vv");
  location lLugar = GetLocation(GetWaypointByTag("ir_cript_vv"));

  if(GetLocalInt(OBJECT_SELF, "TRAMP_V_V") == 1)
  {
      AssignCommand(oPJ, ActionJumpToLocation(lLugar));
      return;
  }

  if(sSubraza == "vampiro" || sSubraza == "ghul" || sSubraza == "deathknight" || sSubraza == "necropolita" || sSubraza == "liche")
  {
      DelayCommand(0.5, PlayAnimation(ANIMATION_PLACEABLE_OPEN));
      DelayCommand(0.5, SetLocalInt(OBJECT_SELF, "TRAMP_V_V", 1));
      DelayCommand(1.4, AssignCommand(oPJ, ClearAllActions()));
      DelayCommand(1.5, AssignCommand(oPJ, ActionJumpToLocation(lLugar)));
      DelayCommand(5.0, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
      DelayCommand(5.0, DeleteLocalInt(OBJECT_SELF, "TRAMP_V_V"));
      return;
  }

  if(oLlave != OBJECT_INVALID)
  {
      DestroyObject(oLlave);
      DelayCommand(0.5, AssignCommand(OBJECT_SELF, PlayAnimation(ANIMATION_PLACEABLE_OPEN)));
      DelayCommand(0.5, SetLocalInt(OBJECT_SELF, "TRAMP_V_V", 1));
      DelayCommand(1.4, AssignCommand(oPJ, ClearAllActions()));
      DelayCommand(1.5, AssignCommand(oPJ, ActionJumpToLocation(lLugar)));
      DelayCommand(5.0, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
      DelayCommand(5.0, DeleteLocalInt(OBJECT_SELF, "TRAMP_V_V"));
  }
  else
  {
      PlaySound("as_dr_woodlgcl1");
      FloatingTextStringOnCreature("*Cerrada*", oPJ);
  }
}
