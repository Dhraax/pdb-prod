void main()
{
  object oChair;
        oChair = GetNearestObjectByTag("Couch01", OBJECT_SELF);
        if (GetIsObjectValid(oChair) && !GetIsObjectValid (GetSittingCreature (oChair)))
   AssignCommand(OBJECT_SELF, SetFacing(DIRECTION_NORTH));
   ActionSit(oChair);
}
