void main()
{
  object oPC = GetEnteringObject();

  // No se satura
  if(GetLocalInt(OBJECT_SELF, "NOSATURARBF") == TRUE) return;

  // No se lanzan bolas a los PNJs
  if(GetIsPC(oPC) == FALSE) return;

  // 66% de probabilidad de explosion
  if(d3() == 3) return;

  SetLocalInt(OBJECT_SELF, "NOSATURARBF", TRUE);
  DelayCommand(12.0, DeleteLocalInt(OBJECT_SELF, "NOSATURARBF"));

  object oBalistaMasCercana = GetNearestObjectByTag("pa_balista", oPC);
  FloatingTextStringOnCreature("¡Una bola de fuego del castillo se dirige hacia ti!", oPC);
  AssignCommand(oBalistaMasCercana, ActionCastSpellAtObject(SPELL_FIREBALL, oPC, METAMAGIC_ANY, TRUE, 10, PROJECTILE_PATH_TYPE_BALLISTIC, TRUE));
}
