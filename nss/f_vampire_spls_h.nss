int GetIsVampire(object oPC = OBJECT_SELF)
{
  return (GetLocalInt(oPC, "FALLEN_SUBRACE") == 1);
}
