#include "nwnx_race"
#include "pb_constantes"

// Función utilizada para comprobar si el personaje es considerado elfo
int PB_Race_GetIsElf(object oPC);

// Función utilizada para comprobar si el personaje es considerado enano
int PB_Race_GetIsDwarf(object oPC);

// Función utilizada para comprobar si el personaje es considerado mediano
int PB_Race_GetIsHalfling(object oPC);

// Función utilizada para comprobar si el tipo racial es considerado humanoide
int PB_Race_GetIsHumanoid(int nRacial);

// Función utilizada para comprobar si el personaje es considerado no muerto
int PB_Race_GetIsUndead(object oPC);

// Función utilizada para saber el tamaño máximo de un PJ por raza.
float PB_Race_TamanoMaximo (object oPC);

// Función utilizada para saber el tamaño mínimo de un PJ por raza.
float PB_Race_TamanoMinimo (object oPC);

void PB_Race_SetupRaces() {
    // RAZA - CELADRIN
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_CELADRIN, NWNX_RACE_MODIFIER_DMGRESIST, DAMAGE_TYPE_FIRE, 10);
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_CELADRIN, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_ELF);            //Raza padre, elfo.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_CELADRIN, NWNX_RACE_MODIFIER_FEAT, 228, 1);                     //Visión en la oscuridad, nivel 1.

    // RAZA - FEY'RI
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_FEYRI, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_ELF);   //Raza padre, elfo.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_FEYRI, NWNX_RACE_MODIFIER_FEAT, FEAT_LOWLIGHTVISION, 1);     //Visión en la penumbra, nivel 1.

    // RAZA - ORCO TANARUKK
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_TANARUKK, NWNX_RACE_MODIFIER_DMGRESIST, DAMAGE_TYPE_FIRE, 10);
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_TANARUKK, NWNX_RACE_MODIFIER_AC, 4, AC_NATURAL_BONUS);
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_TANARUKK, NWNX_RACE_MODIFIER_SRCHARGEN, 14);
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_TANARUKK, NWNX_RACE_MODIFIER_SRINCLEVEL, 1, 1, 1);
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_TANARUKK, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_OUTSIDER);   //Raza padre, ajeno.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_TANARUKK, NWNX_RACE_MODIFIER_FEAT, 228, 1);                 //Visión en la oscuridad, nivel 1.

    // RAZA - AZERBLOOD
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_AZERBLOOD, NWNX_RACE_MODIFIER_DMGRESIST, DAMAGE_TYPE_FIRE, 10);
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_AZERBLOOD, NWNX_RACE_MODIFIER_ABVSRACE, RACIAL_TYPE_OUTSIDER, 1);
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_AZERBLOOD, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_OUTSIDER);          //Raza padre, ajeno.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_AZERBLOOD, NWNX_RACE_MODIFIER_FEAT, 228, 1);                        //Visión en la oscuridad, nivel 1.

    // RAZA - TUMULARIO
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_WIGHT, NWNX_RACE_MODIFIER_IMMUNITY, IMMUNITY_TYPE_MIND_SPELLS);
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_WIGHT, NWNX_RACE_MODIFIER_IMMUNITY, IMMUNITY_TYPE_POISON);
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_WIGHT, NWNX_RACE_MODIFIER_IMMUNITY, IMMUNITY_TYPE_PARALYSIS);
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_WIGHT, NWNX_RACE_MODIFIER_IMMUNITY, IMMUNITY_TYPE_STUN);
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_WIGHT, NWNX_RACE_MODIFIER_IMMUNITY, IMMUNITY_TYPE_DEATH);
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_WIGHT, NWNX_RACE_MODIFIER_IMMUNITY, IMMUNITY_TYPE_DISEASE);
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_WIGHT, NWNX_RACE_MODIFIER_IMMUNITY, IMMUNITY_TYPE_CRITICAL_HIT);
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_WIGHT, NWNX_RACE_MODIFIER_IMMUNITY, IMMUNITY_TYPE_NEGATIVE_LEVEL);
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_WIGHT, NWNX_RACE_MODIFIER_IMMUNITY, IMMUNITY_TYPE_ABILITY_DECREASE);
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_WIGHT, NWNX_RACE_MODIFIER_IMMUNITY, IMMUNITY_TYPE_SNEAK_ATTACK);
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_WIGHT, NWNX_RACE_MODIFIER_SKILL, SKILL_MOVE_SILENTLY, 8);
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_WIGHT, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_UNDEAD);
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_WIGHT, NWNX_RACE_MODIFIER_FEAT, 228, 1);                                //Visión en la oscuridad, nivel 1.

    // RAZA - TIEFLING
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_TIEFLING, NWNX_RACE_MODIFIER_FEAT, FEAT_LOWLIGHTVISION, 1);     //Visión en la penumbra, nivel 1.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_TIEFLING, NWNX_RACE_MODIFIER_DMGRESIST, DAMAGE_TYPE_FIRE, 5);   //Resistencia al daño fuego, 5.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_TIEFLING, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_HUMAN);          //Raza padre, humano.

    // RAZA - ELFO SOLA
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_SOLAR_ELF, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_ELF);           //Raza padre, elfo.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_SOLAR_ELF, NWNX_RACE_MODIFIER_FEAT, FEAT_LOWLIGHTVISION, 1);  //Visión en la penumbra, nivel 1.

    // RAZA - ELFO SALVAJE
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_SALVAJE_ELF, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_ELF);         //Raza padre, elfo.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_SALVAJE_ELF, NWNX_RACE_MODIFIER_FEAT, FEAT_LOWLIGHTVISION, 1);  //Visión en la penumbra, nivel 1.

    // RAZA - ELFO SILVANO
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_WOOD_ELF, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_ELF);            //Raza padre, elfo.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_WOOD_ELF, NWNX_RACE_MODIFIER_FEAT, FEAT_LOWLIGHTVISION, 1);  //Visión en la penumbra, nivel 1.

    // RAZA - ELFO DE LAS ESTRELLAS
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_ESTRELLAS_ELF, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_ELF);       //Raza padre, elfo.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_ESTRELLAS_ELF, NWNX_RACE_MODIFIER_FEAT, FEAT_LOWLIGHTVISION, 1);  //Visión en la penumbra, nivel 1.

    // RAZA - ENANO DORADO
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DWARF_DORADO, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_DWARF);      //Raza padre, enano.

    // RAZA - GNOLL
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GNOLL, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_HUMANOID_MONSTROUS);    //Raza padre, humanoide monstruoso.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GNOLL, NWNX_RACE_MODIFIER_FEAT, 1185, 1);                           //Competencia con arma marcial (arco corto)
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GNOLL, NWNX_RACE_MODIFIER_FEAT, 1177, 1);                           //Competencia con arma marcial (hacha de batalla)
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GNOLL, NWNX_RACE_MODIFIER_AC, 1, AC_NATURAL_BONUS);                 //CA 1 natural.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GNOLL, NWNX_RACE_MODIFIER_FEAT, 228, 1);                            //Visión en la oscuridad, nivel 1.

    //RAZA - GRAN TRASGO
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GRAN_TRASGO, NWNX_RACE_MODIFIER_SKILL, SKILL_MOVE_SILENTLY, 2);         //Bono de moverse sigiloso 2.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GRAN_TRASGO, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_HUMANOID_GOBLINOID);  //Raza padre, humanoide monstruoso trasgoide.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GRAN_TRASGO, NWNX_RACE_MODIFIER_FEAT, 228, 1);                          //Visión en la oscuridad, nivel 1.

    //RAZA - KOBOLD
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_KOBOLD, NWNX_RACE_MODIFIER_SKILL, SKILL_HIDE, 4);                   //Bono de esconderse 4.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_KOBOLD, NWNX_RACE_MODIFIER_SKILL, SKILL_SEARCH, 2);                 //Bono de buscar 2.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_KOBOLD, NWNX_RACE_MODIFIER_SKILL, SKILL_CRAFT_TRAP, 2);             //Bono de artesanía 2.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_KOBOLD, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_HUMANOID_REPTILIAN);   //Raza padre, humanoide monstruoso reptiliano.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_KOBOLD, NWNX_RACE_MODIFIER_FEAT, 228, 1);                           //Visión en la oscuridad, nivel 1.

    //RAZA - ORCO DE LA MONTANA
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_ORCO_MONTANA, NWNX_RACE_MODIFIER_SKILL, SKILL_CRAFT_TRAP, 2);       //Bono de artesanía 2.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_ORCO_MONTANA, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_HUMANOID_ORC);   //Raza padre, humanoide monstruoso orco.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_ORCO_MONTANA, NWNX_RACE_MODIFIER_FEAT, 228, 1);                     //Visión en la oscuridad, nivel 1.

    //RAZA - SEMIOGRO
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_SEMIOGRO, NWNX_RACE_MODIFIER_MOVEMENTSPEED, 25);                //Velocidad aumentada 25%.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_SEMIOGRO, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_GIANT);          //Raza padre, gigante.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_SEMIOGRO, NWNX_RACE_MODIFIER_FEAT, 228, 1);                     //Visión en la oscuridad, nivel 1.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_SEMIOGRO, NWNX_RACE_MODIFIER_AC, 4, AC_NATURAL_BONUS);          //CA 4 natural.

    //RAZA - TRASGO
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_TRASGO, NWNX_RACE_MODIFIER_SKILL, SKILL_MOVE_SILENTLY, 2);          //Bono de moverse sigiloso 2.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_TRASGO, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_HUMANOID_GOBLINOID);   //Raza padre, humanoide monstruoso trasgoide.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_TRASGO, NWNX_RACE_MODIFIER_FEAT, 228, 1);                           //Visión en la oscuridad, nivel 1.

    // RAZA - DUERGAR
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DUERGAR, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_DWARF);                   //Raza padre, enano.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DUERGAR, NWNX_RACE_MODIFIER_IMMUNITY, IMMUNITY_TYPE_POISON);            //Inmunidad a venenos.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DUERGAR, NWNX_RACE_MODIFIER_IMMUNITY, IMMUNITY_TYPE_PARALYSIS);         //Inmunidad a parálisis.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DUERGAR, NWNX_RACE_MODIFIER_SPELLIMMUNITY, SPELL_PHANTASMAL_KILLER);    //Inmunidad a asesino fantasmal.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DUERGAR, NWNX_RACE_MODIFIER_SPELLIMMUNITY, SPELL_WEIRD);                //Inmunidad a némesis.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DUERGAR, NWNX_RACE_MODIFIER_SKILL, SKILL_MOVE_SILENTLY, 4);             //Bonificador mov. sigiloso 4.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DUERGAR, NWNX_RACE_MODIFIER_SKILL, SKILL_SPOT, 4);                      //Bonificador avistar 1.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DUERGAR, NWNX_RACE_MODIFIER_SKILL, SKILL_LISTEN, 4);                    //Bonificador escuchar 1.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DUERGAR, NWNX_RACE_MODIFIER_FEAT, 1806, 1);                             //Sensibilidad solar, nivel 1.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DUERGAR, NWNX_RACE_MODIFIER_FEAT, 228, 1);                              //Visión en la oscuridad, nivel 1.

    // RAZA - AASIMAR
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_AASIMAR, NWNX_RACE_MODIFIER_DMGRESIST, DAMAGE_TYPE_ACID, 5);        //Resistencia al ácido 5.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_AASIMAR, NWNX_RACE_MODIFIER_DMGRESIST, DAMAGE_TYPE_ELECTRICAL, 5);  //Resistencia al eléctrico 5.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_AASIMAR, NWNX_RACE_MODIFIER_DMGRESIST, DAMAGE_TYPE_COLD, 5);        //Resistencia al frío 5.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_AASIMAR, NWNX_RACE_MODIFIER_SKILL, SKILL_SPOT, 2);                  //Bonificador avistar 2.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_AASIMAR, NWNX_RACE_MODIFIER_SKILL, SKILL_LISTEN, 2);                //Bonificador escuchar 2.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_AASIMAR, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_OUTSIDER);            //Raza padre, ajeno.

    // RAZA - ENANO ÁRTICO
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DWARF_ARTICO, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_DWARF);              //Raza padre, enano.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DWARF_ARTICO, NWNX_RACE_MODIFIER_DMGIMMUNITY, DAMAGE_TYPE_COLD, 100);   //Inmunidad al frío.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DWARF_ARTICO, NWNX_RACE_MODIFIER_FEAT, 228, 1);                         //Visión en la oscuridad, nivel 1.

    // RAZA - GENASÍ DE AGUA
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GAGUA, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_OUTSIDER);      //Raza padre, ajeno.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GAGUA, NWNX_RACE_MODIFIER_DMGRESIST, DAMAGE_TYPE_COLD, 10); //Resistencia al frío 10.

    // RAZA - GENASÍ DE AIRE
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GAIRE, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_OUTSIDER);              //Raza padre, ajeno.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GAIRE, NWNX_RACE_MODIFIER_DMGRESIST, DAMAGE_TYPE_ELECTRICAL, 10);   //Resistencia al eléctrico 10.

    // RAZA - GENASÍ DE FUEGO
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GFUEGO, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_OUTSIDER);         //Raza padre, ajeno.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GFUEGO, NWNX_RACE_MODIFIER_DMGRESIST, DAMAGE_TYPE_FIRE, 10);    //Resistencia al fuego 10.

    // RAZA - GENASÍ DE TIERRA
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GTIERRA, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_OUTSIDER);            //Raza padre, ajeno.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GTIERRA, NWNX_RACE_MODIFIER_DMGRESIST, DAMAGE_TYPE_ACID, 10);   //Resistencia al ácido 10.

    // RAZA - AVARIEL
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_AVARIEL, NWNX_RACE_MODIFIER_SKILL, SKILL_SPOT, 2);          //Bonificador avistar 2.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_AVARIEL, NWNX_RACE_MODIFIER_SKILL, SKILL_TUMBLE, 4);        //Bonificador piruetas 4.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_AVARIEL, NWNX_RACE_MODIFIER_SKILL, 26, 4);                  //Bonificador saltar 4.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_AVARIEL, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_ELF);         //Raza padre, elfo.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_AVARIEL, NWNX_RACE_MODIFIER_FEAT, FEAT_LOWLIGHTVISION, 1);  //Visión en la penumbra, nivel 1.

    // RAZA - OSGO
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_OSGO, NWNX_RACE_MODIFIER_SKILL, SKILL_MOVE_SILENTLY, 4);        //Bonificador mov. sigiloso 4.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_OSGO, NWNX_RACE_MODIFIER_FEAT, 228, 1);                         //Visión en la oscuridad, nivel 1.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_OSGO, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_HUMANOID_GOBLINOID); //Raza padre, humanoide trasgoide.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_OSGO, NWNX_RACE_MODIFIER_AC, 3, AC_NATURAL_BONUS);              //CA 3 natural.

    // RAZA - GITHZERAI
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GITHZERAI, NWNX_RACE_MODIFIER_AC, 4, AC_NATURAL_BONUS);                                         //CA 4 natural.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GITHZERAI, NWNX_RACE_MODIFIER_SRCHARGEN, 5);                                                    //Resistencia magica inicial, 5.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GITHZERAI, NWNX_RACE_MODIFIER_SRINCLEVEL, 1, 1, 1);                                             //Resistencia escalable, 1 por nivel.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GITHZERAI, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_OUTSIDER);                                      //Raza padre, ajeno.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GITHZERAI, NWNX_RACE_MODIFIER_SAVEVSTYPE, SAVING_THROW_WILL, SAVING_THROW_TYPE_MIND_SPELLS, 2); //Voluntad contra conjuros enajenadores 2

    // RAZA - DROW
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DROW, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_ELF);                                            //Raza padre, elfo.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DROW, NWNX_RACE_MODIFIER_SAVEVSTYPE, SAVING_THROW_WILL, SAVING_THROW_TYPE_MIND_SPELLS, 2);  //Voluntad contra conjuros enajenadores 2
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DROW, NWNX_RACE_MODIFIER_SAVEVSTYPE, SAVING_THROW_WILL, SAVING_THROW_TYPE_SPELL, 2);        //Voluntad contra conjuros 2
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DROW, NWNX_RACE_MODIFIER_SRCHARGEN, 11);                                                    //Resistencia magica inicial, 11.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DROW, NWNX_RACE_MODIFIER_SRINCLEVEL, 1, 1, 1);                                              //Resistencia escalable, 1 por nivel.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DROW, NWNX_RACE_MODIFIER_FEAT, 228, 1);                                                     //Visión en la oscuridad, nivel 1.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DROW, NWNX_RACE_MODIFIER_FEAT, 1806, 1);                                                    //Sensibilidad solar, nivel 1.

    //RAZA - OGRO
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_OGRO, NWNX_RACE_MODIFIER_MOVEMENTSPEED, 25);                //Velocidad aumentada 25%.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_OGRO, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_GIANT);          //Raza padre, gigante.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_OGRO, NWNX_RACE_MODIFIER_FEAT, 228, 1);                     //Visión en la oscuridad, nivel 1.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_OGRO, NWNX_RACE_MODIFIER_AC, 5, AC_NATURAL_BONUS);          //CA 5 natural.

    //RAZA - MINOTAURO
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_MINOTAURO, NWNX_RACE_MODIFIER_MOVEMENTSPEED, 25);                       //Velocidad aumentada 25%.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_MINOTAURO, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_HUMANOID_MONSTROUS);    //Raza padre, humanoide monstruoso.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_MINOTAURO, NWNX_RACE_MODIFIER_FEAT, 228, 1);                            //Visión en la oscuridad, nivel 1.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_MINOTAURO, NWNX_RACE_MODIFIER_AC, 5, AC_NATURAL_BONUS);                 //CA 5 natural.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_MINOTAURO, NWNX_RACE_MODIFIER_SKILL, SKILL_SPOT, 4);                    //Bonificador avistar 4.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_MINOTAURO, NWNX_RACE_MODIFIER_SKILL, SKILL_LISTEN, 4);                  //Bonificador escuchar 4.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_MINOTAURO, NWNX_RACE_MODIFIER_SKILL, SKILL_SEARCH, 4);                  //Bonificador buscar 4.

    //RAZA - OGRO HECHICERO
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_OGROHECHICERO, NWNX_RACE_MODIFIER_MOVEMENTSPEED, 25);               //Velocidad aumentada 25%.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_OGROHECHICERO, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_GIANT);         //Raza padre, gigante.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_OGROHECHICERO, NWNX_RACE_MODIFIER_FEAT, 228, 1);                    //Visión en la oscuridad, nivel 1.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_OGROHECHICERO, NWNX_RACE_MODIFIER_AC, 5, AC_NATURAL_BONUS);         //CA 5 natural.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_OGROHECHICERO, NWNX_RACE_MODIFIER_SRCHARGEN, 19);                   //Resistencia magica inicial, 11.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_OGROHECHICERO, NWNX_RACE_MODIFIER_REGENERATION, 5, 6);              //Regeneración 5, por cada 6 segundos
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_OGROHECHICERO, NWNX_RACE_MODIFIER_FEAT, 1535, 1);                   //Poliformar.

    //RAZA - GOLIAT
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GOLIAT, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_GIANT);    //Raza padre, gigante.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GOLIAT, NWNX_RACE_MODIFIER_SKILL, 31, 4);               //Bonificador equilibrio 4.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GOLIAT, NWNX_RACE_MODIFIER_SKILL, 37, 4);               //Bonificador escalar 4.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_GOLIAT, NWNX_RACE_MODIFIER_SKILL, 28, 2);               //Bonificador av.int 2.

    //RAZA - SHADAR KAI
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_SHADARKAI, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_ELF);               //Raza padre, elfo.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_SHADARKAI, NWNX_RACE_MODIFIER_DMGRESIST, DAMAGE_TYPE_NEGATIVE, 5);  //Resistencia negativa 5.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_SHADARKAI, NWNX_RACE_MODIFIER_FEAT, 228, 1);                        //Visión en la oscuridad, nivel 1.

    //RAZA - YUAN TI
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_YUANTI, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_HUMANOID_MONSTROUS);                       //Raza padre, humanoide monstruoso.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_YUANTI, NWNX_RACE_MODIFIER_SRCHARGEN, 10);                                              //Resistencia magica inicial, 11.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_YUANTI, NWNX_RACE_MODIFIER_SRINCLEVEL, 1, 1, 1);                                        //Resistencia escalable, 1 por nivel.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_YUANTI, NWNX_RACE_MODIFIER_SAVEVSTYPE, SAVING_THROW_FORT, SAVING_THROW_TYPE_POISON, 4); //Resistencia contra venenos +4
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_YUANTI, NWNX_RACE_MODIFIER_SKILL, 30, 5);                                               //Bonificador disfrazar +5
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_YUANTI, NWNX_RACE_MODIFIER_FEAT, 228, 1);                                               //Visión en la oscuridad, nivel 1.

    // RAZA - DROW BASICO
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DROW_BASICO, NWNX_RACE_MODIFIER_RACE, RACIAL_TYPE_ELF);                                             //Raza padre, elfo.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DROW_BASICO, NWNX_RACE_MODIFIER_SAVEVSTYPE, SAVING_THROW_WILL, SAVING_THROW_TYPE_MIND_SPELLS, 2);   //Voluntad contra conjuros enajenadores 2
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DROW_BASICO, NWNX_RACE_MODIFIER_SAVEVSTYPE, SAVING_THROW_WILL, SAVING_THROW_TYPE_SPELL, 2);         //Voluntad contra conjuros 2
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DROW_BASICO, NWNX_RACE_MODIFIER_FEAT, 228, 1);                                                      //Visión en la oscuridad, nivel 1.
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_DROW_BASICO, NWNX_RACE_MODIFIER_FEAT, 1806, 1);                                                     //Sensibilidad solar, nivel 1.


    //RAZA - KENKU
    NWNX_Race_SetRacialModifier(RACIAL_TYPE_KENKU, NWNX_RACE_MODIFIER_FEAT, 228, 1);    //Visión en la oscuridad, nivel 1.
}

int PB_Race_GetIsElf(object oPC) {
    int nRacialType = GetRacialType(oPC);

    switch(nRacialType) {
        case RACIAL_TYPE_ELF: case RACIAL_TYPE_WOOD_ELF: case RACIAL_TYPE_ESTRELLAS_ELF: case RACIAL_TYPE_SALVAJE_ELF: case RACIAL_TYPE_SOLAR_ELF: case RACIAL_TYPE_CELADRIN: case RACIAL_TYPE_AVARIEL:
            return TRUE;
    }

    return FALSE;
}

int PB_Race_GetIsDwarf(object oPC) {
    int nRacialType = GetRacialType(oPC);

    switch(nRacialType) {
        case RACIAL_TYPE_DWARF: case RACIAL_TYPE_AZERBLOOD: case RACIAL_TYPE_DWARF_ARTICO: case RACIAL_TYPE_DWARF_DORADO:
            return TRUE;
    }

    return FALSE;
}

int PB_Race_GetIsHalfling(object oPC) {
    int nRacialType = GetRacialType(oPC);

    switch(nRacialType) {
        case RACIAL_TYPE_HALFLING: case RACIAL_TYPE_FORTECOR:
            return TRUE;
    }

    return FALSE;
}

int PB_Race_GetIsHumanoid(int nRacial)
{
    switch(nRacial) {
        case RACIAL_TYPE_HUMAN:
        case RACIAL_TYPE_DWARF: case RACIAL_TYPE_AZERBLOOD: case RACIAL_TYPE_DWARF_ARTICO: case RACIAL_TYPE_DWARF_DORADO:
        case RACIAL_TYPE_ELF: case RACIAL_TYPE_WOOD_ELF: case RACIAL_TYPE_ESTRELLAS_ELF: case RACIAL_TYPE_SALVAJE_ELF: case RACIAL_TYPE_SOLAR_ELF: case RACIAL_TYPE_CELADRIN: case RACIAL_TYPE_AVARIEL:
        case RACIAL_TYPE_FEYRI:
        case RACIAL_TYPE_HALFELF: case RACIAL_TYPE_SEMIELFO2:
        case RACIAL_TYPE_GNOME:
        case RACIAL_TYPE_HALFLING: case RACIAL_TYPE_FORTECOR:
        case RACIAL_TYPE_KENKU:
        case RACIAL_TYPE_HALFORC:
        case RACIAL_TYPE_TANARUKK:
        case RACIAL_TYPE_HUMANOID_GOBLINOID:
        case RACIAL_TYPE_HUMANOID_MONSTROUS:
        case RACIAL_TYPE_HUMANOID_ORC:
        case RACIAL_TYPE_HUMANOID_REPTILIAN:
        case RACIAL_TYPE_AASIMAR:
        case RACIAL_TYPE_DRACONIDO:
        case RACIAL_TYPE_DROW: case RACIAL_TYPE_DROW_BASICO:
        case RACIAL_TYPE_DUERGAR:
        case RACIAL_TYPE_GAGUA:
        case RACIAL_TYPE_GAIRE:
        case RACIAL_TYPE_GFUEGO:
        case RACIAL_TYPE_GITHZERAI:
        case RACIAL_TYPE_GNOLL:
        case RACIAL_TYPE_GOLIAT:
        case RACIAL_TYPE_GRAN_TRASGO:
        case RACIAL_TYPE_GTIERRA:
        case RACIAL_TYPE_KOBOLD:
        case RACIAL_TYPE_MINOTAURO:
        case RACIAL_TYPE_OGRO:
        case RACIAL_TYPE_OGROHECHICERO:
        case RACIAL_TYPE_ORCO_MONTANA:
        case RACIAL_TYPE_OSGO:
        case RACIAL_TYPE_SEMIOGRO:
        case RACIAL_TYPE_SHADARKAI:
        case RACIAL_TYPE_TIEFLING:
        case RACIAL_TYPE_TRASGO:
        case RACIAL_TYPE_YUANTI:
            return TRUE;
    }

    return FALSE;
}

int PB_Race_GetIsUndead(object oPC) {
    int nRacialType = GetRacialType(oPC);

    switch(nRacialType) {
        case RACIAL_TYPE_UNDEAD:
        case RACIAL_TYPE_WIGHT:
            return TRUE;
    }

    return FALSE;
}

float PB_Race_TamanoMaximo (object oPC)
{
    string sSubRaza = GetStringLowerCase(GetSubRace(oPC));
    int iRaza = GetRacialType(oPC);
    float fValor;

    if(iRaza == RACIAL_TYPE_HUMAN || iRaza == RACIAL_TYPE_AASIMAR || RACIAL_TYPE_GAGUA || RACIAL_TYPE_GAIRE
        || RACIAL_TYPE_GFUEGO || RACIAL_TYPE_GTIERRA || RACIAL_TYPE_TIEFLING
        || sSubRaza == "Tiflin" || sSubRaza == "tiflin" || iRaza == RACIAL_TYPE_GRAN_TRASGO
        || iRaza == RACIAL_TYPE_GITHZERAI || RACIAL_TYPE_YUANTI) fValor = 1.07;
    if(iRaza == RACIAL_TYPE_ELF || iRaza == RACIAL_TYPE_ESTRELLAS_ELF || iRaza == RACIAL_TYPE_SALVAJE_ELF
        || iRaza == RACIAL_TYPE_SOLAR_ELF || iRaza == RACIAL_TYPE_WOOD_ELF || iRaza == RACIAL_TYPE_CELADRIN
        || iRaza == RACIAL_TYPE_SHADARKAI || iRaza == RACIAL_TYPE_AVARIEL || sSubRaza == "Lythari" || sSubRaza == "lythari"
        || sSubRaza == "Semifata" || sSubRaza == "semifata") fValor = 1.13;
    if(iRaza == RACIAL_TYPE_DROW || iRaza == RACIAL_TYPE_DROW_BASICO)
    {
        fValor = 0.97;
        if(GetGender(oPC) == GENDER_MALE) fValor = 0.90;
    }
    if(iRaza == RACIAL_TYPE_DWARF || iRaza == RACIAL_TYPE_AZERBLOOD) fValor = 1.04;
    if(iRaza == RACIAL_TYPE_DWARF_DORADO) fValor = 0.98;
    if(iRaza == RACIAL_TYPE_DWARF_ARTICO) fValor = 0.95;
    if(iRaza == RACIAL_TYPE_HALFORC || iRaza == RACIAL_TYPE_ORCO_MONTANA) fValor = 1.02;
    if(iRaza == RACIAL_TYPE_HALFLING || iRaza == RACIAL_TYPE_FORTECOR) fValor = 1.03;
    if(iRaza == RACIAL_TYPE_GNOME) fValor = 1.03;
    if(iRaza == RACIAL_TYPE_TRASGO) fValor = 0.93;
    if(iRaza == RACIAL_TYPE_KOBOLD) fValor = 0.90;
    if(iRaza == RACIAL_TYPE_OSGO) fValor = 1.06;
    if(iRaza == RACIAL_TYPE_GOLIAT) fValor = 1.30;
    if(iRaza == RACIAL_TYPE_SEMIOGRO) fValor = 1.30;
    if(iRaza == RACIAL_TYPE_KENKU) fValor = 1.40;
    if(iRaza == RACIAL_TYPE_TANARUKK) fValor = 1.05;
    if(iRaza == RACIAL_TYPE_MINOTAURO) fValor = 1.10;
    if(iRaza == RACIAL_TYPE_OGRO || iRaza == RACIAL_TYPE_OGROHECHICERO) fValor = 1.40;
    return fValor;
}

float PB_Race_TamanoMinimo (object oPC)
{
    string sSubRaza = GetStringLowerCase(GetSubRace(oPC));
    int iRaza = GetRacialType(oPC);
    float fValor;

    if(iRaza == RACIAL_TYPE_HUMAN || iRaza == RACIAL_TYPE_AASIMAR || RACIAL_TYPE_GAGUA || RACIAL_TYPE_GAIRE
        || RACIAL_TYPE_GFUEGO || RACIAL_TYPE_GTIERRA || RACIAL_TYPE_TIEFLING
        || sSubRaza == "Tiflin" || sSubRaza == "tiflin" || iRaza == RACIAL_TYPE_GRAN_TRASGO
        || iRaza == RACIAL_TYPE_GITHZERAI || RACIAL_TYPE_YUANTI) fValor = 0.93;
    if(iRaza == RACIAL_TYPE_ELF || iRaza == RACIAL_TYPE_ESTRELLAS_ELF || iRaza == RACIAL_TYPE_SALVAJE_ELF
        || iRaza == RACIAL_TYPE_SOLAR_ELF || iRaza == RACIAL_TYPE_WOOD_ELF || iRaza == RACIAL_TYPE_CELADRIN
        || iRaza == RACIAL_TYPE_SHADARKAI || iRaza == RACIAL_TYPE_AVARIEL || sSubRaza == "Lythari" || sSubRaza == "lythari"
        || sSubRaza == "Semifata" || sSubRaza == "semifata") fValor = 0.97;
    if(iRaza == RACIAL_TYPE_DROW || iRaza == RACIAL_TYPE_DROW_BASICO)
    {
        fValor = 0.90;
        if(GetGender(oPC) == GENDER_MALE) fValor = 0.80;
    }
    if(iRaza == RACIAL_TYPE_DWARF || iRaza == RACIAL_TYPE_AZERBLOOD) fValor = 0.98;
    if(iRaza == RACIAL_TYPE_DWARF_DORADO) fValor = 0.94;
    if(iRaza == RACIAL_TYPE_DWARF_ARTICO) fValor = 0.90;
    if(iRaza == RACIAL_TYPE_HALFORC || iRaza == RACIAL_TYPE_ORCO_MONTANA) fValor = 0.93;
    if(iRaza == RACIAL_TYPE_HALFLING || iRaza == RACIAL_TYPE_FORTECOR) fValor = 0.97;
    if(iRaza == RACIAL_TYPE_GNOME) fValor = 0.97;
    if(iRaza == RACIAL_TYPE_TRASGO) fValor = 0.83;
    if(iRaza == RACIAL_TYPE_KOBOLD) fValor = 0.70;
    if(iRaza == RACIAL_TYPE_OSGO) fValor = 1.0;
    if(iRaza == RACIAL_TYPE_GOLIAT) fValor = 1.15;
    if(iRaza == RACIAL_TYPE_SEMIOGRO) fValor = 1.20;
    if(iRaza == RACIAL_TYPE_KENKU) fValor = 1.20;
    if(iRaza == RACIAL_TYPE_TANARUKK) fValor = 1.02;
    if(iRaza == RACIAL_TYPE_MINOTAURO) fValor = 1.02;
    if(iRaza == RACIAL_TYPE_OGRO || iRaza == RACIAL_TYPE_OGROHECHICERO) fValor = 1.30;

    return fValor;
}

//void main(){}
