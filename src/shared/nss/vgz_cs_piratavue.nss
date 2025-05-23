void main()
{
object oPC = GetLastUsedBy();
location lPC = GetLocation(oPC);
effect eEfecto = EffectVisualEffect(35);

object oTarget = GetWaypointByTag("hogarpiratavuelta");
location lTarget = GetLocation(oTarget);

ApplyEffectToObject(DURATION_TYPE_INSTANT,eEfecto,oPC);
ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eEfecto,lPC);

AssignCommand(oPC, ClearAllActions());
AssignCommand(oPC, ActionJumpToLocation(lTarget));
}
