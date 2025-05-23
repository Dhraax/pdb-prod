void main()
{
   object oContenedor = GetObjectByTag("spawn_encuentros");
   SetLocalString(oContenedor, "Res","demon001");
   SetLocalString(oContenedor, "Raza","NW_CREATURE_009");
   location lSpawn = GetLocation(GetWaypointByTag("spawn_creatura"));
//   effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
//   effect ePetrify = EffectParalyze();
   CreateObject(OBJECT_TYPE_CREATURE, "demon001", lSpawn, FALSE);
   object oTarget = GetObjectByTag("NW_CREATURE_009");
   SetLocalInt(oContenedor, "oActivo", 1);
   effect eAOE = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eAOE, lSpawn);
//   DelayCommand(2.0,ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePetrify, oTarget));
//   DelayCommand(2.0,ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
   object oPC=GetPCSpeaker();
   object oHech = GetHenchman(oPC,1);
   DelayCommand(0.5,AddHenchman(oPC,oTarget));
   DelayCommand(1.0,OpenInventory(oTarget, oPC));
   SetLocalInt(oTarget,"IsAI",1);
}
