void main()
{
  AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 0.0,999999999999999.9));

  //Added for corpse_script
  SetLootable(OBJECT_SELF, TRUE);
}
