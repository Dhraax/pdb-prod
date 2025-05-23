void main()
{
  object oPC = GetPCSpeaker();
  int iDineros = GetGold(oPC);

  if(iDineros >= 100)
  {
      int ioro = GetCampaignInt("donativos","hospicio");
      SetCampaignInt("donativos","hospicio",ioro + 100);
      TakeGoldFromCreature(100,oPC,TRUE);
      AssignCommand(OBJECT_SELF,SpeakString("Gracias por tu dinero. Nos ayudará algo."));
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_ALL_SKILLS, 2), oPC, 300.0);
      FloatingTextStringOnCreature("* Recibes una bendición por la donación *", oPC);
  }
  else AssignCommand(OBJECT_SELF,SpeakString("No tienes suficiente oro..."));
}
