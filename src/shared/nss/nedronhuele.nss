void main()
{
  object oPC = GetEnteringObject();
  object oMod = GetModule();
  location lPR = GetLocation(GetWaypointByTag("Nedron"));

  if(GetIsPC(oPC) == FALSE) return;

  if(GetLocalInt(oMod, "DESAPARECERCUERPO") == FALSE)
  {
      CreateObject(OBJECT_TYPE_PLACEABLE, "corpsenedron", lPR);
      SetLocalInt(oMod, "DESAPARECERCUERPO", TRUE);
      FloatingTextStringOnCreature("¡El olor a podrido es más fuerte aquí!", oPC);
  }
}
