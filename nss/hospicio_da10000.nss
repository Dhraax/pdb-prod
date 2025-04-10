void main()
{
  object oPC = GetPCSpeaker();
  int iDineros = GetGold(oPC);

  if(iDineros >= 10000)
  {
      int ioro = GetCampaignInt("donativos","hospicio");
      SetCampaignInt("donativos","hospicio",ioro + 10000);
      TakeGoldFromCreature(10000,oPC,TRUE);
      AssignCommand(OBJECT_SELF,SpeakString("¡Oh Gracias! Haremos mucho con eso."));
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_ALL_SKILLS, 2), oPC, 500.0);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACIncrease(2), oPC, 500.0);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageIncrease(DAMAGE_BONUS_1d4, DAMAGE_TYPE_DIVINE), oPC, 500.0);
      FloatingTextStringOnCreature("* Recibes una bendición por la donación *", oPC);
  }
  else AssignCommand(OBJECT_SELF,SpeakString("No tienes suficiente oro..."));
}
