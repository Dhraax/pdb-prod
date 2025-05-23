void main()
{
  object oPC = OBJECT_SELF;

  object oTarget;
  location lTarget;
  oTarget = GetWaypointByTag("volvernecro");

lTarget = GetLocation(oTarget);


if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

AssignCommand(oPC, ClearAllActions());

DelayCommand(3.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));

oTarget = oPC;



int nInt;
nInt = GetObjectType(oTarget);

if (nInt != OBJECT_TYPE_WAYPOINT) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD), oTarget);
else ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD), GetLocation(oTarget));

}
