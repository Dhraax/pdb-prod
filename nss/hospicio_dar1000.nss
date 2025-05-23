void main()
{
  object oPC = GetPCSpeaker();
  int iDineros = GetGold(oPC);

  if(iDineros >= 1000)
  {
      int ioro = GetCampaignInt("donativos","hospicio");
      SetCampaignInt("donativos","hospicio",ioro + 1000);
      TakeGoldFromCreature(1000,oPC,TRUE);
      AssignCommand(OBJECT_SELF,SpeakString("Gracias por tu dinero. Nos ayudará muchísimo."));
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_ALL_SKILLS, 2), oPC, 400.0);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACIncrease(2), oPC, 400.0);
      FloatingTextStringOnCreature("* Recibes una bendición por la donación *", oPC);
  }
  else AssignCommand(OBJECT_SELF,SpeakString("No tienes suficiente oro..."));
}
