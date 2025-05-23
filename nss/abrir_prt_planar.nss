void main()
{
object oPuerta = GetObjectByTag("odisea_prt");

SetLocked(oPuerta, FALSE);
AssignCommand(oPuerta, ActionOpenDoor(oPuerta));

FloatingTextStringOnCreature("*Has abierto la puerta*", GetLastUsedBy());
}
