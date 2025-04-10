void main()
{
  object oPC = GetPCSpeaker();

  //Espada de plata
  string sEmpu = "emp_espada_plata";
  string sFilo = "filodeespadadepl";

  object oEmpu = GetItemPossessedBy(oPC, sEmpu);
  object oFilo = GetItemPossessedBy(oPC, sFilo);
  object oCromwell = OBJECT_SELF;

  if(GetGold(oPC) >= 200000 &&
     oEmpu != OBJECT_INVALID &&
     oFilo != OBJECT_INVALID)
  {
      DestroyObject(oEmpu);
      DestroyObject(oFilo);

      SetCampaignInt("CROMWELL", "ESPADADEPLATA", 1, oPC);
      DelayCommand(0.1, AssignCommand(oCromwell, SpeakString("¡Listo, aquí tienes tu mandoble!")));
      AssignCommand(oPC, TakeGoldFromCreature(200000, oPC, TRUE));
      CreateItemOnObject("mandobledeplata", oPC);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), oPC);
      DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oPC));
  }

  else
  {
      FloatingTextStringOnCreature("¡No tienes los materiales necesarios!", oPC);
  }
}
