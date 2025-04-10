void main()
{
  object oPC = GetLastUsedBy();

  // No se satura
  if(GetLocalInt(OBJECT_SELF, "NOSATURAR") == TRUE)
  {
      FloatingTextStringOnCreature("<cþ>* La esfera mágica del pedestal tarda 1 hora en recargarse *</c>", oPC);
      return;
  }

  int iNivelPJ = GetHitDice(oPC);
  int iConjuroElegido;

  if(iNivelPJ < 3) iConjuroElegido = SPELL_SUMMON_CREATURE_I;
  else if(iNivelPJ < 5) iConjuroElegido = SPELL_SUMMON_CREATURE_II;
  else if(iNivelPJ < 7) iConjuroElegido = SPELL_SUMMON_CREATURE_III;
  else if(iNivelPJ < 9) iConjuroElegido = SPELL_SUMMON_CREATURE_IV;
  else if(iNivelPJ < 11) iConjuroElegido = SPELL_SUMMON_CREATURE_V;
  else if(iNivelPJ < 13) iConjuroElegido = SPELL_SUMMON_CREATURE_VI;
  else if(iNivelPJ < 15) iConjuroElegido = SPELL_SUMMON_CREATURE_VII;
  else if(iNivelPJ < 17) iConjuroElegido = SPELL_SUMMON_CREATURE_VIII;
  else iConjuroElegido = SPELL_SUMMON_CREATURE_IX;

  SetLocalInt(OBJECT_SELF, "NOSATURAR", TRUE);
  DelayCommand(180.0, DeleteLocalInt(OBJECT_SELF, "NOSATURAR"));
  FloatingTextStringOnCreature("<c´þd>* Convocas una criatura fiel que te seguirá *</c>", oPC);
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWSTUN), GetLocation(OBJECT_SELF));
  AssignCommand(oPC, ActionCastSpellAtObject(iConjuroElegido, oPC, METAMAGIC_ANY, TRUE, 10, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
}
