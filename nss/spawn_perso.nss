/* void CreateObjectVoid(int nObjectType, string sTemplate, location lLoc, int bUseAppearAnimation = FALSE)
{
    CreateObject(nObjectType, sTemplate, lLoc, bUseAppearAnimation);
}    */

int StartingConditional()
{
    object oContenedor = GetObjectByTag("spawn_encuentros");
    string sResCreature = GetLocalString(oContenedor, "Raza");
    object oTarget = GetObjectByTag(sResCreature);
    location lSpawn = GetLocation(GetWaypointByTag("spawn_creatura"));
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
    effect ePetrify = EffectPetrify();
    CreateObject(OBJECT_TYPE_CREATURE, sResCreature, lSpawn, FALSE);
    SetLocalInt(oContenedor, "oActivo", 1);
    effect eAOE = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eAOE, lSpawn);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePetrify, oTarget);
    DelayCommand(3.0,ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    SpeakString("Spawn:"+sResCreature);
    return TRUE;
}
