void main()
{
   object oContenedor = GetObjectByTag("spawn_encuentros");
   object oTarget = GetObjectByTag(GetLocalString(oContenedor, "Raza"));
   location lSpawn = GetLocation(GetWaypointByTag("spawn_creatura"));
   int iCantidad = GetLocalInt(oContenedor, "AICantidad");
   int iCount;
   object oPC = GetPCSpeaker();

   RemoveHenchman(oPC, oTarget);
   while(iCount != iCantidad)
   {
   iCount++;
   CopyObject(oTarget,lSpawn,OBJECT_INVALID,"iPCx",TRUE);
   }

}
