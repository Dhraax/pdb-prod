void main()
{
  if(GetCommandable(OBJECT_SELF))
  {
      BeginConversation();
      ClearAllActions();
      AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 0.0,999999999999999.9));
  }
}
