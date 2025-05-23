void NoDrops(object oCreature)
{
  object oItem = GetFirstItemInInventory(oCreature);

  while(GetIsObjectValid(oItem))
  {
      if(GetDroppableFlag(oItem)) SetDroppableFlag(oItem, FALSE);

      oItem = GetNextItemInInventory(oCreature);
  }

  int iLoop = 0;
  while (iLoop < 18)
  {
      oItem = GetItemInSlot(iLoop, oCreature);
      if(GetIsObjectValid(oItem) && GetDroppableFlag(oItem)) SetDroppableFlag(oItem, FALSE);

      iLoop++;
  }
}


void main()
{
  AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
  DelayCommand(1.0f, AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE)));

  int iLoop = 1;
  object oCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, OBJECT_SELF, iLoop);
  while(GetIsObjectValid(oCreature))
  {
      if(!GetIsPC(oCreature)) NoDrops(oCreature);

      iLoop++;
      oCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, OBJECT_SELF, iLoop);
  }

  FloatingTextStringOnCreature("<c´þd>* Objetos no soltables: Hecho *</c>", GetLastUsedBy());
}
