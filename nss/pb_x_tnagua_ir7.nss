void main()
{
object oPC = GetPCSpeaker();
object oMod = GetModule();
object oTarget = GetWaypointByTag("mago_amn_sala_7");
effect eVis_1 = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2);
effect eVis_2 = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);

ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis_1, oPC);
DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis_2, oPC));

DelayCommand(0.4, AssignCommand(oPC, ClearAllActions()));
DelayCommand(0.5, AssignCommand(oPC, ActionJumpToObject(oTarget)));

DeleteLocalInt(oMod, "TORREOCUPADA");
DeleteLocalInt(oPC, "NIVELTORRE");
SetCampaignInt("QUESTAMNAGUATORRE", "AVANCE", 1, oPC);
}
