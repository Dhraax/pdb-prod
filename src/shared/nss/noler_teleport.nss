 #include "x0_i0_transport"

void main()
{
object oPC = GetLastUsedBy();
if(!GetIsPC(oPC)) return;

object oDestination = GetObjectByTag(GetLocalString(OBJECT_SELF, "DESTINATION"));
if( !GetIsObjectValid(oDestination)) return;

TransportToWaypoint(oPC, oDestination);
}
