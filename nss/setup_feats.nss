#include "nwnx_skillranks"
#include "nwnx_feat"
#include "pb_constantes"

void SetupFeats() {
    NWNX_Feat_SetFeatModifier(FEAT_APTDEM_TS_LIGHTNING, NWNX_FEAT_MODIFIER_SAVEVSTYPE, SAVING_THROW_TYPE_ALL, SAVING_THROW_TYPE_ELECTRICITY, 2);
    NWNX_Feat_SetFeatModifier(FEAT_APTDEM_TS_POISON, NWNX_FEAT_MODIFIER_SAVEVSTYPE, SAVING_THROW_TYPE_ALL, SAVING_THROW_TYPE_POISON, 2);
    NWNX_Feat_SetFeatModifier(FEAT_APTDEM_FIRE_RESISTANCE, NWNX_FEAT_MODIFIER_DMGRESIST, DAMAGE_TYPE_FIRE, 10);
    NWNX_Feat_SetFeatModifier(FEAT_APTDEM_DAMAGE_RESISTANCE, NWNX_FEAT_MODIFIER_DMGREDUCTION, 10, 1);
    NWNX_Feat_SetFeatModifier(FEAT_FAVORED_SOUL_DAMAGE_RESISTANCE, NWNX_FEAT_MODIFIER_DMGRESIST, 5, 10);
    NWNX_Feat_SetFeatModifier(FEAT_FAVORED_SOUL_COLD_RESISTANCE, NWNX_FEAT_MODIFIER_DMGRESIST, DAMAGE_TYPE_COLD, 10);
    NWNX_Feat_SetFeatModifier(FEAT_FAVORED_SOUL_ACID_RESISTANCE, NWNX_FEAT_MODIFIER_DMGRESIST, DAMAGE_TYPE_ACID, 10);
    NWNX_Feat_SetFeatModifier(FEAT_FAVORED_SOUL_FIRE_RESISTANCE, NWNX_FEAT_MODIFIER_DMGRESIST, DAMAGE_TYPE_FIRE, 10);
    NWNX_Feat_SetFeatModifier(FEAT_FAVORED_SOUL_ELECTRICAL_RESISTANCE, NWNX_FEAT_MODIFIER_DMGRESIST, DAMAGE_TYPE_ELECTRICAL, 10);
    NWNX_Feat_SetFeatModifier(FEAT_FAVORED_SOUL_SONIC_RESISTANCE, NWNX_FEAT_MODIFIER_DMGRESIST, DAMAGE_TYPE_SONIC, 10);
    NWNX_Feat_SetFeatModifier(FEAT_MDL_VIGOR, NWNX_FEAT_MODIFIER_SAVE, SAVING_THROW_FORT, 4);
    NWNX_Feat_SetFeatModifier(FEAT_MDL_HUESOS, NWNX_FEAT_MODIFIER_IMMUNITY, IMMUNITY_TYPE_STUN);
    NWNX_Feat_SetFeatModifier(FEAT_MDL_HUESOS, NWNX_FEAT_MODIFIER_IMMUNITY, IMMUNITY_TYPE_DISEASE);
    NWNX_Feat_SetFeatModifier(FEAT_MDL_MAESTRIA, NWNX_FEAT_MODIFIER_IMMUNITY, IMMUNITY_TYPE_ABILITY_DECREASE);
    NWNX_Feat_SetFeatModifier(FEAT_MDL_MAESTRIA, NWNX_FEAT_MODIFIER_IMMUNITY, IMMUNITY_TYPE_CRITICAL_HIT);
    NWNX_Feat_SetFeatModifier(FEAT_MDL_MAESTRIA, NWNX_FEAT_MODIFIER_IMMUNITY, IMMUNITY_TYPE_SLEEP);
    NWNX_Feat_SetFeatModifier(FEAT_MDL_MAESTRIA, NWNX_FEAT_MODIFIER_IMMUNITY, IMMUNITY_TYPE_PARALYSIS);
    NWNX_Feat_SetFeatModifier(FEAT_MDL_MAESTRIA, NWNX_FEAT_MODIFIER_IMMUNITY, IMMUNITY_TYPE_POISON);
    NWNX_Feat_SetFeatModifier(FEAT_MDL_MAESTRIA, NWNX_FEAT_MODIFIER_IMMUNITY, IMMUNITY_TYPE_DEATH);
    NWNX_Feat_SetFeatModifier(FEAT_MDL_MAESTRIA, NWNX_FEAT_MODIFIER_IMMUNITY, IMMUNITY_TYPE_NEGATIVE_LEVEL);
    NWNX_Feat_SetFeatModifier(FEAT_MDL_AFINIDAD10, NWNX_FEAT_MODIFIER_ARCANESPELLFAILURE, -10);
    NWNX_Feat_SetFeatModifier(FEAT_MDL_AFINIDAD20, NWNX_FEAT_MODIFIER_ARCANESPELLFAILURE, -10);

    // Modificadores raciales de la plantilla Engendro Vampírico
    NWNX_Feat_SetFeatModifier(FEAT_TEMPLATE_VAMPIRE_SPAWN, NWNX_FEAT_MODIFIER_REGENERATION, 2, 6);
    NWNX_Feat_SetFeatModifier(FEAT_TEMPLATE_VAMPIRE_SPAWN, NWNX_FEAT_MODIFIER_IMMUNITY, IMMUNITY_TYPE_STUN);
    NWNX_Feat_SetFeatModifier(FEAT_TEMPLATE_VAMPIRE_SPAWN, NWNX_FEAT_MODIFIER_IMMUNITY, IMMUNITY_TYPE_DISEASE);
    NWNX_Feat_SetFeatModifier(FEAT_TEMPLATE_VAMPIRE_SPAWN, NWNX_FEAT_MODIFIER_IMMUNITY, IMMUNITY_TYPE_ABILITY_DECREASE);
    NWNX_Feat_SetFeatModifier(FEAT_TEMPLATE_VAMPIRE_SPAWN, NWNX_FEAT_MODIFIER_IMMUNITY, IMMUNITY_TYPE_CRITICAL_HIT);
    NWNX_Feat_SetFeatModifier(FEAT_TEMPLATE_VAMPIRE_SPAWN, NWNX_FEAT_MODIFIER_IMMUNITY, IMMUNITY_TYPE_PARALYSIS);
    NWNX_Feat_SetFeatModifier(FEAT_TEMPLATE_VAMPIRE_SPAWN, NWNX_FEAT_MODIFIER_IMMUNITY, IMMUNITY_TYPE_POISON);
    NWNX_Feat_SetFeatModifier(FEAT_TEMPLATE_VAMPIRE_SPAWN, NWNX_FEAT_MODIFIER_IMMUNITY, IMMUNITY_TYPE_DEATH);
    NWNX_Feat_SetFeatModifier(FEAT_TEMPLATE_VAMPIRE_SPAWN, NWNX_FEAT_MODIFIER_IMMUNITY, IMMUNITY_TYPE_NEGATIVE_LEVEL);
    NWNX_Feat_SetFeatModifier(FEAT_TEMPLATE_VAMPIRE_SPAWN, NWNX_FEAT_MODIFIER_IMMUNITY, IMMUNITY_TYPE_MIND_SPELLS);

    //Inmunidades del paladín de diferentes tipo.
    NWNX_Feat_SetFeatModifier(300, NWNX_FEAT_MODIFIER_IMMUNITY, IMMUNITY_TYPE_FEAR);
    NWNX_Feat_SetFeatModifier(1730, NWNX_FEAT_MODIFIER_IMMUNITY, IMMUNITY_TYPE_FEAR);
}

void SetupSkillFeats() {
    struct NWNX_SkillRanks_SkillFeat skillFeat;
    struct NWNX_SkillRanks_SkillFeat emptyStruct;

    // Afinidad con Engañar
    skillFeat = emptyStruct;
    skillFeat.iSkill = SKILL_BLUFF;
    skillFeat.iFeat = FEAT_SKILL_AFFINITY_BLUFF;
    skillFeat.iModifier = 2;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Afinidad con Esconderse
    skillFeat = emptyStruct;
    skillFeat.iSkill = SKILL_HIDE;
    skillFeat.iFeat = FEAT_SKILL_AFFINITY_HIDE;
    skillFeat.iModifier = 2;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Afinidad con Interpretar
    skillFeat = emptyStruct;
    skillFeat.iSkill = SKILL_PERFORM;
    skillFeat.iFeat = FEAT_SKILL_AFFINITY_PERFORM;
    skillFeat.iModifier = 2;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Voz Melodiosa
    skillFeat = emptyStruct;
    skillFeat.iSkill = SKILL_PERSUADE;
    skillFeat.iFeat = FEAT_MELODIOUS_VOICE;
    skillFeat.iModifier = 1;
    skillFeat.fClassLevelMod = 0.2;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Afinidad con Tasación
    skillFeat = emptyStruct;
    skillFeat.iSkill = SKILL_APPRAISE;
    skillFeat.iFeat = FEAT_SKILL_AFFINITY_APPRAISE;
    skillFeat.iModifier = 2;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Afinidad con Artesanía
    skillFeat = emptyStruct;
    skillFeat.iSkill = SKILL_CRAFT_TRAP;
    skillFeat.iFeat = FEAT_SKILL_AFFINITY_CRAFTING;
    skillFeat.iModifier = 2;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Afinidad con Reunir Información
    skillFeat = emptyStruct;
    skillFeat.iSkill = SKILL_GATHER_INFORMATION;
    skillFeat.iFeat = FEAT_SKILL_AFFINITY_GATHER_INFORMATION;
    skillFeat.iModifier = 2;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Afinidad con Diplomacia
    skillFeat = emptyStruct;
    skillFeat.iSkill = SKILL_PERSUADE;
    skillFeat.iFeat = FEAT_SKILL_AFFINITY_PERSUADE;
    skillFeat.iModifier = 2;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Plantilla: Engendro Vampírico
    skillFeat = emptyStruct;
    skillFeat.iFeat = FEAT_TEMPLATE_VAMPIRE_SPAWN;
    skillFeat.iModifier = 2;
    skillFeat.iSkill = SKILL_BLUFF;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);
    skillFeat.iSkill = SKILL_HIDE;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);
    skillFeat.iSkill = SKILL_MOVE_SILENTLY;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);
    skillFeat.iSkill = SKILL_SPOT;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);
    skillFeat.iSkill = SKILL_LISTEN;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);
    skillFeat.iSkill = SKILL_SEARCH;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);
    skillFeat.iSkill = SKILL_SENSE_MOTIVE;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);


    //Dote de Sensibilidad Solar: -4 a Avistar en exteriores durante el día.
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1806;                     //Dote.
    skillFeat.iModifier = -4;                   //Malus.
    skillFeat.iAreaFlagsForbidden = 0x1 | 0x2;  //No se aplica en interiores o subterráneos.
    skillFeat.iDayOrNight = 1;                  //Solo por el día.
    skillFeat.iSkill = SKILL_SPOT;              //Aplicamos el penalizador en avistar.
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);
}

//void main(){}
