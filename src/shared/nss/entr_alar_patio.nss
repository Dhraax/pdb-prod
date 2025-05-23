void main()
{
object oTarget = GetWaypointByTag("entrada_alarico_patio");
location lTarget = GetLocation(oTarget);
object oPC = GetClickingObject();

if(!GetIsPC(oPC)) return;

if(GetItemPossessedBy(oPC, "pasedelacofradia")!= OBJECT_INVALID)
   {
     SendMessageToPC(oPC, "Bienvenido a la cofradía, contrabandista");

    if(GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionJumpToLocation(lTarget));
   }
else
   {
    FloatingTextStringOnCreature("No estoy autorizado a entrar en este lugar", oPC);
   }
}
