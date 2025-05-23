void main()
{
object oSacerdote = GetObjectByTag("SacerdoreSupremodeKhauntea");
object oPuntoRuta = GetWaypointByTag("POST_SacerdoreSupremodeKhauntea");
location lLugar = GetLocation(oPuntoRuta);
effect eEfecto1 = EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD);
effect eEfecto2 = EffectVisualEffect(VFX_FNF_SUMMON_GATE);

ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eEfecto1, lLugar,3.0f);
DestroyObject(oSacerdote);
ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eEfecto2, lLugar,3.0f);
CreateObject(OBJECT_TYPE_CREATURE, "sacerdote_transform", lLugar, TRUE);
}
