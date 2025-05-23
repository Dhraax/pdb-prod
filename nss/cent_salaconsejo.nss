void main()
{
  object oPC = GetClickingObject();
  if(!GetIsPC(oPC)) return;

  if(GetItemPossessedBy(oPC, "cuerno_centinelas")!= OBJECT_INVALID)

  {


      object oTarget = GetWaypointByTag("_salidaconsejodruidi");
      location lTarget = GetLocation(oTarget);

      if(GetAreaFromLocation(lTarget) == OBJECT_INVALID) return;

      AssignCommand(oPC, ClearAllActions());
      AssignCommand(oPC, ActionJumpToLocation(lTarget));
  }

  else
  {
      FloatingTextStringOnCreature("*No puedes pasar sin el cuerno de los centinelas.*", oPC);
  }
}
