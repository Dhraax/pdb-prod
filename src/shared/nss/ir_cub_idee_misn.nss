void main()
{
object oPC = GetPCSpeaker();
location lPuntoDeRuta = GetLocation(GetWaypointByTag("Puerto_Minsorran"));

if(GetGold(oPC) >= 100)
    {
      AssignCommand(oPC, TakeGoldFromCreature(100, oPC, TRUE));
      AssignCommand(oPC, ClearAllActions());
      AssignCommand(oPC, ActionJumpToLocation(lPuntoDeRuta));
    }
else
    {
      FloatingTextStringOnCreature("¡No tienes 100 monedas de oro!", oPC);
    }
}
