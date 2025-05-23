void main()
{
  object oPC = GetEnteringObject();
  object oMod = GetModule();
  string sNombrePC = GetName(oPC);

  if(GetIsPC(oPC) == FALSE) return;

  // Antisaturamiento
  if(GetLocalInt(oMod, "PAR_NOSATURAR" + sNombrePC)) return;
  SetLocalInt(oMod, "PAR_NOSATURAR" + sNombrePC, TRUE);
  DelayCommand(300.0, DeleteLocalInt(oMod, "PAR_NOSATURAR" + sNombrePC));

  // Te maldices
  if(GetItemPossessedBy(oPC, "llave_paramos3") == OBJECT_INVALID &&
     GetItemPossessedBy(oPC, "llave_paramos4") == OBJECT_INVALID)
  {
      SendMessageToPC(oPC, "<cþ<<>¡Las raíces te han maldecido! El árbol no te reconoce como un hermano.</c>");
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCurse(2,2,2,2,2,2), oPC, 300.0);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD), oPC);
      return;
  }

  // Te curas
  SendMessageToPC(oPC, "<c´þd>¡Las raíces te han bendecido! El árbol te ha reconocido como un hermano.</c>");
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectRegenerate(1, 6.0), oPC, 300.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowIncrease(SAVING_THROW_ALL, 1), oPC, 300.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_ALL_SKILLS, 1), oPC, 300.0);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(1082), oPC);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(1086), oPC);
}
