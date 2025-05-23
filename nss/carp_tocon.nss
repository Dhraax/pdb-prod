void main()
{
  object oPC = GetLastSpellCaster();
  int iConjuro = GetLastSpell();

  if(GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0 &&
    (iConjuro == SPELL_CURE_CRITICAL_WOUNDS ||
     iConjuro == SPELL_CURE_LIGHT_WOUNDS ||
     iConjuro == SPELL_CURE_MINOR_WOUNDS ||
     iConjuro == SPELL_CURE_MODERATE_WOUNDS ||
     iConjuro == SPELL_CURE_SERIOUS_WOUNDS ||
     iConjuro == SPELL_REGENERATE ||
     iConjuro == SPELL_MASS_HEAL ||
     iConjuro == SPELL_HEAL))
  {
      SetXP(oPC, GetXP(oPC) + 25);
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(29), GetLocation(OBJECT_SELF));
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(549), OBJECT_SELF);
      FloatingTextStringOnCreature("*Has regenerado el árbol, sus ramas volverán a crecer en poco tiempo*", oPC);
      SetUseableFlag(OBJECT_SELF, FALSE);
  }

  else
  {
      SendMessageToPC(oPC, "*Solamente los druidas lanzando conjuros de curación sobre el tocón podrán revivir el árbol*");
  }
}
