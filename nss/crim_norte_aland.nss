void main()
{
object oPC = GetPCSpeaker();
location lPuntoDeRuta = GetLocation(GetWaypointByTag("crim_norte_alandor"));

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
