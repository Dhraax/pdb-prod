 void main()
{
  object oPC = GetLastUsedBy();
  object oContenedor = GetObjectByTag("spawn_encuentros");
  int oActivo = GetLocalInt(oContenedor, "oActivo");
  object oCreatura8 = GetObjectByTag("giant001");
  effect eDamage= EffectDamage(10000, DAMAGE_TYPE_MAGICAL);
  object oCreatura12 = GetObjectByTag("orconv12");
  object oCreatura16 = GetObjectByTag("Reptilnivel16");
  object oCreatura20 = GetObjectByTag("Dragonnivel20");
  object oCreatura25 = GetObjectByTag("X2_DRACOLICH001");
  object oCopia = GetObjectByTag("oPC1");
  location lSpawn = GetLocation(GetWaypointByTag("spawn_creatura"));
  object oSpawn = GetNearestObjectToLocation(1,lSpawn);
  object oArea = GetArea(oPC);
  object oObject = GetFirstObjectInArea(oArea);
  // Eliminar personalizados.

  object oPerso = GetObjectByTag(GetLocalString(oContenedor,"Raza"));
  //if (oActivo==1){
//  SpeakString("Encuentro eliminado");
  SetLocalInt(oContenedor, "oActivo",0);
  /* ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oCreatura8);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oCreatura12);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oCreatura16);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oCreatura20);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oCreatura25);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPerso);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oCopia);*/
   if (GetLocalInt(OBJECT_SELF,"nToggle") == 0)
   {
   PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE,1.0,1.0);
   SetLocalInt(OBJECT_SELF,"nToggle",1);//set "ON"
   }
    else
   {
   PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE,1.0,1.0);
   SetLocalInt(OBJECT_SELF,"nToggle",0);//set "OFF"
   }

    while(GetIsObjectValid(oObject))
    {
         // Destroy any objects tagged "DESTROY"
         //if(GetTag(oObject) == "giant001" || GetTag(oObject) == "orconv12" || GetTag(oObject) == "Reptilnivel16" || GetTag(oObject) == "Dragonnivel20" || GetTag(oObject) == "X2_DRACOLICH001" || GetTag(oObject) == "oPC1" || GetTag(oObject) == GetLocalString(oContenedor,"Raza"))
         //{
           if(GetIsPC(oObject) == FALSE && GetObjectType(oObject) == 1)
           {
           ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oObject);
           }
         //}
         oObject = GetNextObjectInArea(oArea);
    }


 /* } else {
  ActionStartConversation( oPC, "spawn_bichos", TRUE );
  } */
  //}
}
