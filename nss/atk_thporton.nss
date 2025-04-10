void main()
{
  if(GetLocalInt(OBJECT_SELF, "PUERTAYAABIERTA") == 1) return;
  SetLocalInt(OBJECT_SELF, "PUERTAYAABIERTA", 1);
  DelayCommand(1.1, DeleteLocalInt(OBJECT_SELF, "PUERTAYAABIERTA"));

  PlayAnimation(ANIMATION_PLACEABLE_OPEN, 0.1);
  DelayCommand(1.0, PlayAnimation(ANIMATION_PLACEABLE_CLOSE, 0.1));

  object oPC = GetLastUsedBy();
  object oTemploDeHelmo = GetWaypointByTag("atk_templohelmoin2");
  DelayCommand(0.4, AssignCommand(oPC, ClearAllActions()));
  DelayCommand(0.5, AssignCommand(oPC, JumpToObject(oTemploDeHelmo)));
}
