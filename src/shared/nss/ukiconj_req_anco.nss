int StartingConditional()
{
  object oPC = GetPCSpeaker();

  // Restricción basada en la habilidad de personaje
  if(GetSkillRank(SKILL_SPELLCRAFT, oPC, TRUE) < 12 ||
     GetSkillRank(SKILL_CONCENTRATION, oPC, TRUE) < 12) return FALSE;

  // Restricción basada en la clase de personaje
  if(GetLevelByClass(CLASS_TYPE_WIZARD, oPC) < 11 &&
     GetLevelByClass(CLASS_TYPE_SORCERER, oPC) < 11) return FALSE;

    return TRUE;
}
