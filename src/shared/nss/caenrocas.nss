//Put this OnEnter
void main()
{

object oPC = GetEnteringObject();

if (!GetIsPC(oPC)) return;

object oTarget;
oTarget = GetObjectByTag("pw_caenrocas");

//Visual effects can't be applied to waypoints, so if it is a WP
//apply to the WP's location instead

int nInt;
nInt = GetObjectType(oTarget);
if (nInt != OBJECT_TYPE_WAYPOINT) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(354), oTarget);
else ApplyEffectAtLocation(DURATION_TYPE_INSTANT,EffectVisualEffect(353) , GetLocation(oTarget));
PlaySound("as_na_rockfallg1");
PlaySound("as_na_rockcavsm1");
}

