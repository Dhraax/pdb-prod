void main()
{
object oPC= GetEnteringObject();
location lEfecto = GetLocation(GetWaypointByTag("fuego_mausoleo_gamb"));
effect eVis = EffectVisualEffect(VFX_FNF_FIREBALL);
SetLocalInt(oPC, "fuego_cripta_gambiton", 1);
PlaySound("c_slaadpow_dead");
ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lEfecto);
CreateObject(OBJECT_TYPE_PLACEABLE, "llama_mausol", lEfecto);
}

