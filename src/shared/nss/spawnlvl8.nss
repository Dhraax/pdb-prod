void CreateObjectVoid(int nObjectType, string sTemplate, location lLoc, int bUseAppearAnimation = FALSE)
{
    CreateObject(nObjectType, sTemplate, lLoc, bUseAppearAnimation);
}

void main()
{
    effect eAOE = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
    string sResCreature = "giant001";
    object oContenedor = GetObjectByTag("spawn_encuentros");
    location lSpawn = GetLocation(GetWaypointByTag("spawn_creatura"));
    CreateObjectVoid(OBJECT_TYPE_CREATURE, sResCreature, lSpawn, TRUE);
    SetLocalInt(oContenedor, "oActivo", 1);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eAOE, lSpawn);


}
