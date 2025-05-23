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




    //=======================================================================
    //                  Habilidades de 5e y progresion
    //=======================================================================

    //////////////////////////////
    ///       Competencias     ///
    //////////////////////////////

    // Competencia con Acrobacias
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1900;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_TUMBLE;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Competencia con Atletismo
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1901;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 26; //Saltar/Atletismo
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Competencia con Conocimiento Arcano
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1902;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_CONCENTRATION;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);
    skillFeat.iSkill = SKILL_LORE; //Saber Arcano
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Competencia con Engaño
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1903;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_BLUFF;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Competencia con Historia
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1904;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_DISCIPLINE; //Saber Local
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Competencia con Interpretacion
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1905;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_PERFORM;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Competencia con Intimidacion
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1906;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_INTIMIDATE;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Competencia con Investigacion
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1907;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_SEARCH;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Competencia con Juego de Manos
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1908;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_PICK_POCKET;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Competencia con Medicina
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1909;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_HEAL;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Competencia con Naturaleza
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1910;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_TUMBLE;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Competencia con Percepcion
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1911;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_SPOT;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);
    skillFeat.iSkill = SKILL_LISTEN;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Competencia con Perspicacia
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1912;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 28;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Competencia con Persuasion
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1913;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_APPRAISE;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Competencia con Religion
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1914;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_PARRY; //sab religion
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Competencia con Sigilo
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1915;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_HIDE;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);
    skillFeat.iSkill = SKILL_MOVE_SILENTLY;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Competencia con Supervivencia
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1916;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 36;  //superivencia
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Competencia con Trato con Animales
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1917;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_ANIMAL_EMPATHY;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);


    // Competencia con Herramientas de Aquimista
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1918;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 25; //Nadar -> Herramientas de alquimia
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Competencia con Herramientas de Herrero
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1919;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_CRAFT_TRAP; //Herramientas de herrero
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Competencia con Herramientas de Carpintero
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1920;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 34; //Herramienta Carpt
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Competencia con Herramientas de Sastre
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1921  ;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_TUMBLE;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Competencia con Herramientas de Artista
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1922;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 31; //her artista
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Competencia con Herramientas de Joyero
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1923;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 32; //Herramienta joyeria
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Competencia con Herramientas de Cartografo
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1924;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 29;  //Herramientas Cart.
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);


    // Competencia con Herramientas de Ladron
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1925;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_OPEN_LOCK; //Her. ladron
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);
    skillFeat.iSkill = SKILL_DISABLE_TRAP; //Inutilizar mecanismo
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);


    // Competencia con Herramientas de Trampero
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1926;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_SET_TRAP;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);


    // Competencia con Herramientas de Navegante
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1927;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_TUMBLE;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);


    // Competencia con Instrumento Musical de Viento
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1928;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 35; //Instrumento Viento
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);


    // Competencia con Instrumento Musical de Cuerda
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1929;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 37; //Instrumento Cuerda
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);


    // Competencia con Instrumento Musical de Percusion
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1930;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 38; //Instrumento Percusion
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);


    // Competencia con Utiles de Disfraz
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1931;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 30; //Disfrazarse
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);


    // Competencia con Utiles de Falsificador
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1932;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 33; //Utiles Falsificador
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    //////////////////////////////
    ///        Pericias        ///
    //////////////////////////////

    // Pericia con Acrobacias
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1934;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_TUMBLE;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Pericia con Atletismo
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1935;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 26; //Saltar/Atletismo
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Pericia con Conocimiento Arcano
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1936;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_CONCENTRATION;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);
    skillFeat.iSkill = SKILL_LORE; //Saber Arcano
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Pericia con Engaño
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1937;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_BLUFF;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Pericia con Historia
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1938;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_DISCIPLINE; //Saber Local
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Pericia con Interpretacion
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1939;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_PERFORM;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Pericia con Intimidacion
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1940;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_INTIMIDATE;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Pericia con Investigacion
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1941;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_SEARCH;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Pericia con Juego de Manos
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1942;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_PICK_POCKET;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Pericia con Medicina
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1943;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_HEAL;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Pericia con Naturaleza
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1944;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_TUMBLE;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Pericia con Percepcion
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1945;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_SPOT;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);
    skillFeat.iSkill = SKILL_LISTEN;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Pericia con Perspicacia
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1946;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 28;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Pericia con Persuasion
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1947;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_APPRAISE;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Pericia con Religion
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1948;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_PARRY; //sab religion
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Pericia con Sigilo
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1949;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_HIDE;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);
    skillFeat.iSkill = SKILL_MOVE_SILENTLY;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Pericia con Supervivencia
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1950;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 36;  //superivencia
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Pericia con Trato con Animales
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1951;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_ANIMAL_EMPATHY;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);


    // Pericia con Herramientas de Aquimista
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1952;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 25; //Nadar -> Herramientas de alquimia
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Pericia con Herramientas de Herrero
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1953;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_CRAFT_TRAP; //Herramientas de herrero
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Pericia con Herramientas de Carpintero
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1954;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 34; //Herramienta Carpt
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Pericia con Herramientas de Sastre
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1955 ;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_TUMBLE;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Pericia con Herramientas de Artista
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1956;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 31; //her artista
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Pericia con Herramientas de Joyero
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1957;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 32; //Herramienta joyeria
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

    // Pericia con Herramientas de Cartografo
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1958;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 29;  //Herramientas Cart.
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);


    // Pericia con Herramientas de Ladron
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1959;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_OPEN_LOCK; //Her. ladron
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);
    skillFeat.iSkill = SKILL_DISABLE_TRAP; //Inutilizar mecanismo
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);


    // Pericia con Herramientas de Trampero
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1960;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_SET_TRAP;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);


    // Pericia con Herramientas de Navegante
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1961;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = SKILL_TUMBLE;
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);


    // Pericia con Instrumento Musical de Viento
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1962;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 35; //Instrumento Viento
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);


    // Pericia con Instrumento Musical de Cuerda
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1963;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 37; //Instrumento Cuerda
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);


    // Pericia con Instrumento Musical de Percusion
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1964;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 38; //Instrumento Percusion
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);


    // Pericia con Utiles de Disfraz
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1965;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 30; //Disfrazarse
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);


    // Pericia con Utiles de Falsificador
    skillFeat = emptyStruct;
    skillFeat.iFeat = 1966;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 0.25f;

    skillFeat.iSkill = 33; //Utiles Falsificador
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);



    //===========================================================================================
    // Adaptación de la concentración de 5e, +1 por nivel de clase lanzadora de conjuros.
    //===========================================================================================

    skillFeat = emptyStruct;
    skillFeat.iFeat = 1900;
    skillFeat.iModifier = 2;
    skillFeat.fClassLevelMod = 1.00f;

    skillFeat.iSkill = SKILL_CONCENTRATION;
    skillFeat = NWNX_SkillRanks_AddSkillFeatClass(skillFeat, CLASS_TYPE_WIZARD);
    skillFeat = NWNX_SkillRanks_AddSkillFeatClass(skillFeat, CLASS_TYPE_DRUID);
    skillFeat = NWNX_SkillRanks_AddSkillFeatClass(skillFeat, CLASS_TYPE_CLERIC);
    skillFeat = NWNX_SkillRanks_AddSkillFeatClass(skillFeat, CLASS_TYPE_RANGER);
    skillFeat = NWNX_SkillRanks_AddSkillFeatClass(skillFeat, CLASS_TYPE_WARLOCK);
    skillFeat = NWNX_SkillRanks_AddSkillFeatClass(skillFeat, CLASS_TYPE_BARD);
    skillFeat = NWNX_SkillRanks_AddSkillFeatClass(skillFeat, CLASS_TYPE_PALADIN);
    skillFeat = NWNX_SkillRanks_AddSkillFeatClass(skillFeat, CLASS_TYPE_SORCERER);
    skillFeat = NWNX_SkillRanks_AddSkillFeatClass(skillFeat, CLASS_TYPE_ARCHMAGE);
    skillFeat = NWNX_SkillRanks_AddSkillFeatClass(skillFeat, CLASS_TYPE_PALE_MASTER);
    skillFeat = NWNX_SkillRanks_AddSkillFeatClass(skillFeat, CLASS_TYPE_HARPER);
    NWNX_SkillRanks_SetSkillFeat(skillFeat, TRUE);

}

//void main(){}
