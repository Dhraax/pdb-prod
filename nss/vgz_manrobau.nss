void VariableRobar(object oPC, int iMinimoHostigar, int iMinimoIntimidar,
                   int iMinimoEsconderse, int iMinimoMoverse, int iTirada)
{
  if(GetIsNight() &&
     GetItemPossessedBy(oPC, "pasedelacofradia") == OBJECT_INVALID &&
     GetItemPossessedBy(oPC, "permisodelacofradia") == OBJECT_INVALID &&
     GetLocalInt(oPC,"Manrobau") == 0 &&
     GetStealthMode(oPC) == STEALTH_MODE_DISABLED &&
     GetSkillRank(SKILL_TAUNT, oPC) < iMinimoHostigar &&
     GetSkillRank(SKILL_INTIMIDATE, oPC) < iMinimoIntimidar &&
     GetSkillRank(SKILL_HIDE, oPC) < iMinimoEsconderse &&
     GetSkillRank(SKILL_MOVE_SILENTLY, oPC) < iMinimoMoverse &&
     d100() < iTirada)
  {
      SetLocalInt(oPC, "Manrobau",1);
      DelayCommand(1000.0, DeleteLocalInt(oPC,"Manrobau"));
  }
}

void main()
{
  object oPC = GetEnteringObject();
  VariableRobar(oPC, 15, 15, 15, 15, 75);
  //Scripts para eliminar los pnj del área.
  ExecuteScript ("z0_area_onexit", oPC);
}
