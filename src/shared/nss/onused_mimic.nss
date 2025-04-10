//::///////////////////////////////////////////////
// Ubicados se transforman en criaturas MIMIC
// By Darth
//::///////////////////////////////////////////////

void CrearUbicado(location lLocation, string sResRef, string sCreature, float fRespawn)
{
     object Restore;
     Restore = RetrieveCampaignObject("UBICADOS", sResRef, lLocation);
     SetLocalString(Restore, "CRIATURA", sCreature);
     SetLocalFloat(Restore, "RESPAWN", fRespawn);
     DelayCommand(1.0, DeleteCampaignVariable("UBICADOS", sResRef));

}

void Esconder(object oUbicado)
{
 SetObjectVisualTransform(oUbicado, OBJECT_VISUAL_TRANSFORM_SCALE, -100.0);
 SetUseableFlag(OBJECT_SELF, FALSE);
 SetPlotFlag(OBJECT_SELF, FALSE);
}

void main()
{
  //Declaramos variables
   string sCreature = GetLocalString(OBJECT_SELF, "CRIATURA");
   float fRespawn = GetLocalFloat(OBJECT_SELF, "RESPAWN");
   object oPC = GetLastUsedBy();
   object oCopy = OBJECT_SELF;
   location lLocation = GetLocation(oCopy);
   effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);

   //Si no aplicamos tiempo de respawn por defecto son 5 minutos
   if(fRespawn < 1.0) fRespawn = 600.0;

   //Si pasamos cerca, activamos el temariooo
   if (GetLocalInt(OBJECT_SELF, "NOSPAM") < 1)
   {
     //Creamos el bicho
           object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sCreature, GetLocation(OBJECT_SELF));
           ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(OBJECT_SELF));

        //Guardamos los datos para generar luego el ubicado de nuevo
           string sResRef = GetResRef(oCopy);
           object oWaypoint = CreateObject(OBJECT_TYPE_WAYPOINT, "WP_SpawnDead001", lLocation, FALSE, sResRef);
           StoreCampaignObject("UBICADOS", sResRef, oCopy);
           SetLocalFloat(oWaypoint, "RESPAWN", fRespawn);
           SetLocalString(oWaypoint, "CRIATURA", sCreature);

       //Lo destruimos
           SetLocalInt(OBJECT_SELF, "NOSPAM", 1);
           DelayCommand(0.5, Esconder(OBJECT_SELF)); //Como no podemos destruir, camuflamos
           DestroyObject(OBJECT_SELF, fRespawn+0.5);


       //Lo restauramos pasado el tiempo definido
           string iResRef =  GetTag(oWaypoint);
           string sCreature = GetLocalString(oWaypoint, "CRIATURA");
           float fRespawn = GetLocalFloat(oWaypoint, "RESPAWN");
           location lTarget = GetLocation(oWaypoint);
           DelayCommand(fRespawn, CrearUbicado(lTarget, iResRef, sCreature, fRespawn));
           DestroyObject(oWaypoint, fRespawn+0.5);

   }

}

