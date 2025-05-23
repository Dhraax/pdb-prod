void main()
{
 location iSpawn = GetLocation(GetWaypointByTag("spawn_creatura"));
 object oContenedor = GetObjectByTag("spawn_encuentros");
 object oPC = GetPCSpeaker();
 CopyObject(oPC,iSpawn,OBJECT_INVALID,"oPC1");
 DelayCommand(1.0,ChangeToStandardFaction(GetObjectByTag("oPC1"),0));
 DelayCommand(2.0,AssignCommand (GetObjectByTag("oPC1"), ActionAttack(oPC)));
 SetLocalInt(oContenedor, "oActivo", 1);
}
