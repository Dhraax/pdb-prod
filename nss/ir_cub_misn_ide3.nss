void main()
{
object oPC = GetPCSpeaker();
location lPuntoDeRuta = GetLocation(GetWaypointByTag("Puerto_Edive"));

if(GetGold(oPC) >= 150)
    {
      AssignCommand(oPC, TakeGoldFromCreature(150, oPC, TRUE));
      AssignCommand(oPC, ClearAllActions());
      AssignCommand(oPC, ActionJumpToLocation(lPuntoDeRuta));
    }
else
    {
      FloatingTextStringOnCreature("¡No tienes 150 monedas de oro!", oPC);
    }
}
