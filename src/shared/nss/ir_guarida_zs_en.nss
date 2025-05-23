void main()
{
  object oPC = GetPCSpeaker();
  object oTarget = GetWaypointByTag("entrada_maga_zs");
  object oArmario = GetObjectByTag("armario_entrada_zs");
  effect eSummon = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2);
  effect eFantasma = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE);
  effect eArmarioEfecto = EffectVisualEffect(VFX_FNF_PWSTUN);
  object oItemToTake = GetItemPossessedBy(oPC, "Tesis_sonr_aprendrz_zs");

  // Para la persistencia en multijugador
  SetLocalInt(oPC, "ESTOYENZAPSUNE", 1);

  SetLocalInt(OBJECT_SELF, "GUARDIA_SUNE_MAGA", 1);
  if(GetIsObjectValid(oItemToTake) != 0) DestroyObject(oItemToTake);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eArmarioEfecto, oArmario);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFantasma, oArmario);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eSummon, oPC);
  AssignCommand(oPC, SpeakString("*¡El libro desaparece por arte de magia!*"));
  AssignCommand(oPC, JumpToObject(oTarget));
}
