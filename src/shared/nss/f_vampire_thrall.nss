void main()
{
  AssignCommand(OBJECT_SELF, ClearAllActions(TRUE));
  AssignCommand(OBJECT_SELF, ActionCastSpellAtObject(SPELL_NEGATIVE_ENERGY_BURST, OBJECT_SELF, METAMAGIC_ANY, TRUE, 10, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
  DelayCommand(0.2, SetCommandable(FALSE, OBJECT_SELF));
  DelayCommand(2.0, SetCommandable(TRUE, OBJECT_SELF));
}
