#include "NW_I0_GENERIC"
#include "X0_INC_HENAI"
#include "x2_inc_switches"
//#include "nwnx_creature"

void main()
{
    string sResref = GetResRef(OBJECT_SELF);

    // ESCUCHA
    SetAssociateListenPatterns();
    bkSetListeningPatterns();

    //DMFI CODE ADDITIONS BEGIN HERE
    SetListening(OBJECT_SELF, TRUE);
    SetListenPattern(OBJECT_SELF, "**", 20600); //listen to all text
    SetLocalInt(OBJECT_SELF, "hls_Listening", 1); //listen to all text
    //DMFI CODE ADDITIONS END HERE

    // IA
    SetAssociateState(NW_ASC_POWER_CASTING);
    SetAssociateState(NW_ASC_HEAL_AT_50);
    SetAssociateState(NW_ASC_RETRY_OPEN_LOCKS);
    SetAssociateState(NW_ASC_DISARM_TRAPS);
    SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, FALSE);
    SetAssociateState(NW_ASC_DISTANCE_4_METERS);

    if(sResref == "conv_nixi" || sResref == "conv_pixi" || sResref == "conv_satiro") SetAssociateState(NW_ASC_USE_RANGED_WEAPON, TRUE);
    else SetAssociateState(NW_ASC_USE_RANGED_WEAPON, FALSE);

    // CONVOCACIONES
    if(sResref == "conv_perroint") SetSpawnInCondition(NW_FLAG_END_COMBAT_ROUND_EVENT);
    else if(sResref == "conv_osoncel") DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(422), OBJECT_SELF));
    else if(sResref == "conv_avispainf") DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(411), OBJECT_SELF));
    else if(sResref == "conv_bebilith") DelayCommand(1.5, SetFootstepType(FOOTSTEP_TYPE_SPIDER, OBJECT_SELF));
    else if(sResref == "con_asecon") DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(530), OBJECT_SELF));
    else if(sResref == "asy_solarconv" || sResref == "asy_solarconv_bu") DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(558), OBJECT_SELF));
    else if(sResref == "conv_unicornioce") DelayCommand(1.5, AssignCommand(OBJECT_SELF, ActionCastSpellAtObject(SPELL_MAGIC_CIRCLE_AGAINST_EVIL, OBJECT_SELF, METAMAGIC_ANY, TRUE, 15, PROJECTILE_PATH_TYPE_DEFAULT, TRUE)));

    // Set starting location
    SetAssociateStartLocation();
}
