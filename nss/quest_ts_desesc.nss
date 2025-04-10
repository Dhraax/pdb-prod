void LimpiarCofre(object oCofre)
{
    object oObjetoEliminar = GetFirstItemInInventory(oCofre);
    while(GetIsObjectValid(oObjetoEliminar))
    {
        DestroyObject(oObjetoEliminar);

        oObjetoEliminar = GetNextItemInInventory(oCofre);
    }
}

int StartingConditional()
{
  object oPC = GetPCSpeaker();

  // CD 30 de Descifrar escritura
  if (GetSkillRank(29, oPC) + d20() >= 30)
  {
      object oCofre = GetNearestObjectByTag("mti_quest_sombras_cofre3frag");

      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_KNOCK), oCofre);
      SetLocalInt(OBJECT_SELF, "QUEST_SOMBRAS_COFRE_ABIERTO", TRUE);
      SetLocked(oCofre, FALSE);
      CreateItemOnObject("quest_ts_simb3", oCofre);

      DelayCommand(1000.0, LimpiarCofre(oCofre));
      DelayCommand(1001.0, SetLocked(oCofre, TRUE));
      DelayCommand(1002.0, DeleteLocalInt(OBJECT_SELF, "QUEST_SOMBRAS_COFRE_ABIERTO"));

      SetXP(oPC, GetXP(oPC) + 50);

      return TRUE;
  }
  else
  {
      SetLocalInt(oPC, "SPAM_DESC_ESCRITURA", TRUE);
      DelayCommand(300.0, DeleteLocalInt(oPC, "SPAM_DESC_ESCRITURA"));
      return FALSE;
  }
}
