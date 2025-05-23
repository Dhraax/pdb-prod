/////////////////////////////////////////////////////////////////
//
// Script de Asignar apariencia según encuentro
//
/////////////////////////////////////////////////////////////////

#include "nwnx_creature"
#include "enc_equipo"


void AsignarApariencia(int nClass, object oCreature, object oArea)
{
 int eApariencia;
 int sTipoApariencia = GetLocalInt(oArea, "AparienciaEncuentro");
 int sEncuentro = GetLocalInt(oArea, "NIVEL_ENCUENTRO");
 int nClass = GetLocalInt(oCreature, "ENC_CLASS");

 //Efectos Extra sin AsignarPoderes
 effect eRD = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_SLASHING, 10));
 effect eOcultacion = SupernaturalEffect(EffectConcealment(25));
 effect eImmune = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
 effect eCritico = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
 effect eRC = SupernaturalEffect(EffectSpellResistanceIncrease(10 + GetHitDice(oCreature)));
 effect eReduccion = SupernaturalEffect(EffectDamageReduction(10, DAMAGE_POWER_PLUS_FIVE, 100));

 //Buscamos el tipo de apariencia definido
    switch(sTipoApariencia)
        {
        // SubTipo 1: Humanos Hombres-Rata
         case 1:
                if(nClass == CLASS_TYPE_WIZARD)         eApariencia = 238;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 874;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 873;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 873;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 238;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 874;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMAN);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 2: Humanos Bandidos
         case 2:if(nClass == CLASS_TYPE_WIZARD)         eApariencia = 975;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 1074;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 974;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 974;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 975;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 976;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMAN);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 3: Humanos Gitanos
         case 3:if(nClass == CLASS_TYPE_WIZARD)         eApariencia = 263;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 258;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 275;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 275;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 263;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 188;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMAN);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 4: Humanos Uthgar
         case 4:if(nClass == CLASS_TYPE_WIZARD)         eApariencia = 214;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 1251;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 213;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 213;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 214;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 296;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMAN);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 5: Humanos Sectarios
         case 5:if(nClass == CLASS_TYPE_WIZARD)         eApariencia = 1012;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 1011;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 1013;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 1013;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 1011;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 1014;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMAN);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 6: Humanos Mercenarios
         case 6:if(nClass == CLASS_TYPE_WIZARD)         eApariencia = 1074;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 1072;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 1073;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 1073;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 1074;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 1196;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMAN);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 7: Humanos Cofradia
         case 7:if(nClass == CLASS_TYPE_WIZARD)         eApariencia = 325;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 324;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 326;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 326;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 325;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 323;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMAN);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 8: Humanos Hombre-Lobo
         case 8:if(nClass == CLASS_TYPE_WIZARD)         eApariencia = 988;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 983;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 984;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 983;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 987;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 986;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_SHAPECHANGER);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 9: Razas Antiguas Trasgos
         case 9:if(nClass == CLASS_TYPE_WIZARD)         eApariencia = 85;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 86;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 83;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 83;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 84;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 919;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMANOID_GOBLINOID);
                NWNX_Creature_SetSize(oCreature, CREATURE_SIZE_SMALL);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 10: Razas Antiguas Grandes Trasgos
         case 10:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 391;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 919;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 390;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 390;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 391;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 390;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMANOID_GOBLINOID);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 11: Razas Antiguas Kobolds
         case 11:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 305;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 302;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 300;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 304;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 301;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 300;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMANOID_REPTILIAN);
                NWNX_Creature_SetSize(oCreature, CREATURE_SIZE_SMALL);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 12: Razas Antiguas Gnolls
         case 12:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 2551;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 2550;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 2553;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 388;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 389;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 388;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMANOID_MONSTROUS);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 13: Razas Antiguas Orcos
         case 13:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 138;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 141;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 137;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 140;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 139;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 136;
                AjustarEquipo(oCreature);
                break;

        // SubTipo 14: Razas Antiguas Osgos
         case 14:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 27;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 29;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 25;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 30;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 28;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 26;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMANOID_MONSTROUS);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 15: Razas Antiguas Ogros y Ogros Hechiceros
         case 15:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 1096;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 1106;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 922;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 1107;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 1099;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 909;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_GIANT);
                NWNX_Creature_SetSize(oCreature, CREATURE_SIZE_LARGE);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 16: Razas Antiguas Minotauros
         case 16:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 122;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 120;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 1266;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 120;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 122;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 121;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMANOID_MONSTROUS);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 17: Razas Antiguas Trolls y Ettins
         case 17:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 165;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 164;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 72;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 72;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 1056;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 990;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_GIANT);
                NWNX_Creature_SetSize(oCreature, CREATURE_SIZE_LARGE);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 18: Razas Antiguas Gigante de Piedra, Colinas, Montañas
         case 18:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 4407;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 78;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 2710;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 79;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 4404;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 2718;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_GIANT);
                NWNX_Creature_SetSize(oCreature, CREATURE_SIZE_LARGE);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 19: Razas Antiguas Gigantes de Fuego
         case 19:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 2753;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 2740;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 2741;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 2742;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 2747;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 2744;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_GIANT);
                NWNX_Creature_SetSize(oCreature, CREATURE_SIZE_LARGE);
                SetLocalInt(oCreature, "Gigante_Fuego", 1);
                AjustarEquipo(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 20: Razas Antiguas Gigantes de Hielo
         case 20:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 2735;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 2721;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 2722;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 2720;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 2729;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 2726;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_GIANT);
                NWNX_Creature_SetSize(oCreature, CREATURE_SIZE_LARGE);
                SetLocalInt(oCreature, "Gigante_Frio", 1);
                AjustarEquipo(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 21: No-Muerto Zombies
         case 21:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 1360;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 195;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 196;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 197;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 1359;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 7483;
                SetLocalInt(oCreature, "Zombie", 1);
                AjustarEquipoGarras(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 22: No-Muerto Esqueletos
         case 22:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 1416;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 1230;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 1413;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 1252;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 1419;
                if(GetLocalInt(oCreature, "JEFAZO") == 1)  eApariencia = 4294;
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRD, oCreature);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 23: No-Muerto Fantasmas
         case 23:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 4103;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 4112;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 187;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 186;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 187;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 1092;
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eOcultacion, oCreature);
                AjustarEquipoGarras(oCreature);
                break;

        // SubTipo 24: No-Muerto Necrofagos
         case 24:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 1000;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 76;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 74;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 993;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 995;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 77;
                SetLocalInt(oCreature, "Ghoul", 1);
                AjustarEquipoGarras(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 25: No-Muerto Sombras
         case 25:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 2091;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 146;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 147;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 147;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 2092;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 4893;
                SetLocalInt(oCreature, "Sombra", 1);
                AjustarEquipoGarras(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 26: No-Muerto Momias
         case 26:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 7482;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 125;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 59;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 124;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 7482;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 7484;
                SetLocalInt(oCreature, "Momia", 1);
                AjustarEquipoGarras(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 27: No-Muerto Horrores Acorazados
         case 27:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 3976;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 3976;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 24;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 193;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 23;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 40;
                AjustarEquipo(oCreature);
                break;

        // SubTipo 28: No-Muerto Vampiros
         case 28:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 1194;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 980;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 980;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 981;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 980;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 1193;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_UNDEAD);
                SetLocalInt(oCreature, "Vampiro", 1);
                AjustarEquipo(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 29: No-Muerto Espectros
         case 29:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 1092;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 1081;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 1080;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 1082;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 1092;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 1093;
                SetLocalInt(oCreature, "Espectro", 1);
                AjustarEquipoGarras(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 30: No-Muerto Alhun, Azotamentes
         case 30:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 415;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 36;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 36;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 36;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 415;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 415;
                SetLocalInt(oCreature, "Psionico", 1);
                AjustarEquipoGarras(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 31: No-Muerto Caballeros Condenados, Liches
         case 31:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 1274;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 1269;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 1071;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 466;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 1270;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 465;
                SetLocalInt(oCreature, "Liche", 1);
                AjustarEquipo(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 32: Reptiles Kuo-Toa
         case 32:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 903;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 901;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 905;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 904;
                else if(nClass == CLASS_TYPE_DRUID)     eApariencia = 904;
                else if(nClass == CLASS_TYPE_RANGER)    eApariencia = 905;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 904;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 2520;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMANOID_REPTILIAN);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 33: Reptiles Asabis
         case 33:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 354;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 917;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 355;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 355;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 354;
                else if(nClass == CLASS_TYPE_DRUID)     eApariencia = 917;
                else if(nClass == CLASS_TYPE_RANGER)    eApariencia = 917;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 353;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMANOID_REPTILIAN);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 34: Reptiles Sajuaguin
         case 34:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 65;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 65;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 65;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 65;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 67;
                else if(nClass == CLASS_TYPE_DRUID)     eApariencia = 67;
                else if(nClass == CLASS_TYPE_RANGER)    eApariencia = 67;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 66;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMANOID_REPTILIAN);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 35: Reptiles Saurion
         case 35:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 451;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 451;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 451;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 452;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 452;
                else if(nClass == CLASS_TYPE_DRUID)     eApariencia = 452;
                else if(nClass == CLASS_TYPE_RANGER)    eApariencia = 451;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 453;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMANOID_REPTILIAN);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 36: Reptiles Dragones Cromaticos
         case 36:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 2042;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 380;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 2041;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 2041;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 380;
                else if(nClass == CLASS_TYPE_DRUID)     eApariencia = 2042;
                else if(nClass == CLASS_TYPE_RANGER)    eApariencia = 2042;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 50;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_DRAGON);
                SetLocalInt(oCreature, "Cromatico", 1);
                AjustarEquipoGarras(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 37: Reptiles Hombres-Lagarto
         case 37:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 4250;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 4251;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 4250;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 4254;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 4252;
                else if(nClass == CLASS_TYPE_DRUID)     eApariencia = 4250;
                else if(nClass == CLASS_TYPE_RANGER)    eApariencia = 4252;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 191;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMANOID_REPTILIAN);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 38: Yuan-Ti
         case 38:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 287;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 286;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 286;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 286;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 285;
                else if(nClass == CLASS_TYPE_DRUID)     eApariencia = 287;
                else if(nClass == CLASS_TYPE_RANGER)    eApariencia = 286;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 370;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMANOID_REPTILIAN);
                SetLocalInt(oCreature, "PulsoVeneno", 1);
                AjustarEquipo(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 39: Reptiles Aboleths
         case 39:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 1199;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 3970;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 1200;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 1200;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 1199;
                else if(nClass == CLASS_TYPE_DRUID)     eApariencia = 1199;
                else if(nClass == CLASS_TYPE_RANGER)    eApariencia = 1200;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 3969;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMANOID_REPTILIAN);
                SetLocalInt(oCreature, "Aboleth", 1);
                AjustarEquipoGarras(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 40: Siervos Dragones Venerables
         case 40:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 2319;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 457;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 2319;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 2319;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 2319;
                else if(nClass == CLASS_TYPE_DRUID)     eApariencia = 2319;
                else if(nClass == CLASS_TYPE_RANGER)    eApariencia = 457;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 4624;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_DRAGON);
                SetLocalInt(oCreature, "Cromatico", 1);
                AjustarEquipoGarras(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 41: Magico Elementales Pequeños
         case 41:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 56;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 56;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 56;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 56;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 56;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 57;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_OUTSIDER);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCritico, oCreature);
                AjustarEquipoGarras(oCreature);
                break;

        // SubTipo 42: Magico Krenshar (Gato del Infierno)
         case 42:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 96;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 96;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 96;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 96;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 96;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 7489;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_OUTSIDER);
                SetLocalInt(oCreature, "Hellcat", 1);
                AjustarEquipoGarras(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 43: Magico Manticoras
         case 43:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 1030;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 1030;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 1030;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 1030;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 1030;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 1030;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_MAGICAL_BEAST);
                SetLocalInt(oCreature, "Manticora", 1);
                AjustarEquipoGarras(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 44: Magico Formicidas
         case 44:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 363;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 360;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 361;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 361;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 362;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 363;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_OUTSIDER);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 45: Gargolas
         case 45:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 1389;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 1389;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 1389;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 1389;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 1389;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 1389;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_OUTSIDER);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eReduccion, oCreature);
                AjustarEquipoGarras(oCreature);
                break;

        // SubTipo 46: Magico Salamandras
         case 46:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 2107;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 2108;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 2108;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 2108;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 2109;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 7425;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_OUTSIDER);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 47: Magico Nagas
         case 47:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 4449;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 4451;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 4450;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 4448;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 454;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 459;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_OUTSIDER);
                SetLocalInt(oCreature, "Naga", 1);
                AjustarEquipo(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 48: Magico Arpias
         case 48:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 419;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 419;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 419;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 419;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 419;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 419;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_OUTSIDER);
                SetLocalInt(oCreature, "Arpia", 1);
                AjustarEquipoGarras(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 49: Magico Slaads colores
         case 49:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 154;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 155;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 155;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 151;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 151;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 427;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_OUTSIDER);
                SetLocalInt(oCreature, "Slaad", 1);
                AjustarEquipoGarras(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 50: Magico Slaads de la muerte
         case 50:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 152;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 153;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 153;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 153;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 152;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 426;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_OUTSIDER);
                SetLocalInt(oCreature, "Slaad", 1);
                AjustarEquipoGarras(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 51: Magico Elementales Ancianos
         case 51:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 60;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 60;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 60;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 60;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 60;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 61;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_OUTSIDER);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCritico, oCreature);
                AjustarEquipoGarras(oCreature);
                break;

         // SubTipo 52: Magico Demonios Poderosos
         case 52:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 163;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 4872;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 1048;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 101;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 38;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 461;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_OUTSIDER);
                SetLocalInt(oCreature, "Demonio", 1);
                AjustarEquipo(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 53: Constructos Objetos Animados
         case 53:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 2438;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 2425;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 2425;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 2425;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 2437;
                else if(nClass == CLASS_TYPE_CONSTRUCT) eApariencia = 2425;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 2427;
                AjustarEquipoGarras(oCreature);
                break;

        // SubTipo 54: Robotitos
         case 54:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 2277;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 1040;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 1040;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 1040;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 2277;
                else if(nClass == CLASS_TYPE_CONSTRUCT) eApariencia = 1040;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 2277;
                AjustarEquipoGarras(oCreature);
                break;

        // SubTipo 55: Constructos Arañas Mecanicas, Objetos Mecanicos
         case 55:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 2422;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 2218;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 2219;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 2217;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 2422;
                else if(nClass == CLASS_TYPE_CONSTRUCT) eApariencia = 2219;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 937;
                AjustarEquipoGarras(oCreature);
                break;

        // SubTipo 56: Constructos Golem Arcilla o Mineral (Zafiro, Calcita)
         case 56:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 7367;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 91;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 91;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 91;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 7367;
                else if(nClass == CLASS_TYPE_CONSTRUCT) eApariencia = 91;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 91;
                AjustarEquipoGarras(oCreature);
                break;

        // SubTipo 57: Constructos Guardian Escudos
         case 57:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 898;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 898;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 897;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 898;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 898;
                else if(nClass == CLASS_TYPE_CONSTRUCT) eApariencia = 898;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 89;
                AjustarEquipo(oCreature);
                break;

        // SubTipo 58:  Constructos Golems de Gema (Rubi, Diamante, Esmeralda)
         case 58:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 169;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 931;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 926;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 173;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 169;
                else if(nClass == CLASS_TYPE_CONSTRUCT) eApariencia = 173;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 149;
                AjustarEquipoGarras(oCreature);
                break;

        // SubTipo 59: Constructos Maruts
         case 59:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 1035;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 1032;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 1032;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 1033;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 1034;
                else if(nClass == CLASS_TYPE_CONSTRUCT) eApariencia = 1032;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 420;
                SetLocalInt(oCreature, "Golem", 1);
                AjustarEquipo(oCreature);
                AsignarPoderes(oCreature);
                break;

       // SubTipo 60: Constructos Golem de Hierro
         case 60:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 973;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 973;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 973;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 973;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 973;
                else if(nClass == CLASS_TYPE_CONSTRUCT) eApariencia = 973;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 421;
                SetLocalInt(oCreature, "Golem", 1);
                AjustarEquipoGarras(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 61: Infraoscuridad Desgarrador
         case 61:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 205;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 205;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 205;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 205;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 205;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 7307;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_VERMIN);
                AjustarEquipoGarras(oCreature);
                break;

        // SubTipo 62: Infraoscuridad kobold
         case 62:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 305;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 302;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 300;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 300;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 301;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 300;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMANOID_REPTILIAN);
                NWNX_Creature_SetSize(oCreature, CREATURE_SIZE_SMALL);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 63: Infraoscuridad Miconidos
         case 63:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 944;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 944;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 942;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 942;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 944;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 7411;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMANOID_REPTILIAN);
                SetLocalInt(oCreature, "Miconido", 1);
                AjustarEquipoGarras(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 64: Infraoscuridad Tracnido
         case 64:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 166;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 102;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 102;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 166;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 166;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 166;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_VERMIN);
                SetLocalInt(oCreature, "Tracnido", 1);
                AjustarEquipoGarras(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 65: Infraoscuridad Gigantes de Infra
         case 65:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 1136;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 1136;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 1136;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 1136;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 1136;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 1136;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_ABERRATION);
                NWNX_Creature_SetSize(oCreature, CREATURE_SIZE_LARGE);
                AjustarEquipo(oCreature);
                break;


        // SubTipo 66: Infraoscuridad Aguijoneador
         case 66:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 359;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 357;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 357;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 357;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 359;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 358;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_ABERRATION);
                SetLocalInt(oCreature, "PulsoVeneno", 1);
                AjustarEquipo(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 67: Infraoscuridad Duergar
         case 67:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 1156;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 1150;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 1152;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 1155;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 1154;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 1151;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_DWARF);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmune, oCreature);
                AjustarEquipo(oCreature);
                break;


        // SubTipo 68: Infraoscuridad Drow
         case 68:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 409;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 1138;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 1140;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 1138;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 1143;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 1148;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_ELF);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRC, oCreature);
                AjustarEquipo(oCreature);
                break;


        // SubTipo 69: Infraoscuridad Drañas
         case 69:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 406;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 407;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 1145;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 407;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 1145;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 1144;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_ABERRATION);
                SetLocalInt(oCreature, "PulsoVeneno", 1);
                SetLocalInt(oCreature, "Tracnido", 1);
                AjustarEquipo(oCreature);
                AsignarPoderes(oCreature);
                break;


        // SubTipo 70: Infraoscuridad Aboleth
         case 70:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 1199;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 3970;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 1200;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 1200;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 1199;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 3969;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_ABERRATION);
                SetLocalInt(oCreature, "Aboleth", 1);
                AjustarEquipoGarras(oCreature);
                AsignarPoderes(oCreature);
                break;


        // SubTipo 71: Infraoscuridad Contempladores
         case 71:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 402;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 7454;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 2509;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 2509;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 401;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 299;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_ABERRATION);
                SetLocalInt(oCreature, "Beholder", 1);
                AjustarEquipoGarras(oCreature);
                AsignarPoderes(oCreature);
                break;


        // SubTipo 72: Infraoscuridad Azotamentes
         case 72:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 1022;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 168;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 168;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 168;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 1026;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 414;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_ABERRATION);
                SetLocalInt(oCreature, "Psionico", 1);
                AjustarEquipoGarras(oCreature);
                AsignarPoderes(oCreature);
                break;

        // SubTipo 73: Humanos Sectarios Chungos
         case 73:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 319;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 324;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 312;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 311;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 189;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 320;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMAN);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 74: Humanos Hombres-Tiburon
         case 74:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 7481;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 7481;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 7481;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 7481;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 7481;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 7481;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_SHAPECHANGER);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 75: Reptiles Salamandras
         case 75:if(nClass == CLASS_TYPE_WIZARD)        eApariencia = 2107;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 2108;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 2108;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 2108;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 2109;
                else if(nClass == CLASS_TYPE_DRUID)     eApariencia = 2107;
                else if(nClass == CLASS_TYPE_RANGER)    eApariencia = 2107;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 7425;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMANOID_REPTILIAN);
                AjustarEquipo(oCreature);
                break;
         // SubTipo 76: Humanos y Enanos
         case 76:
                if(nClass == CLASS_TYPE_WIZARD)         eApariencia = 284;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 250;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 251;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 251;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 248;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 243;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMAN);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 77: Enanos a caballo
         case 77:if(nClass == CLASS_TYPE_WIZARD)         eApariencia = 243;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 269;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 252;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 253;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 257;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 254;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMAN);
                AjustarEquipo(oCreature);
                break;

        // SubTipo 78: Gnomos
         case 78:if(nClass == CLASS_TYPE_WIZARD)         eApariencia = 243;
                else if(nClass == CLASS_TYPE_ROGUE)     eApariencia = 258;
                else if(nClass == CLASS_TYPE_BARBARIAN) eApariencia = 278;
                else if(nClass == CLASS_TYPE_FIGHTER)   eApariencia = 260;
                else if(nClass == CLASS_TYPE_CLERIC)    eApariencia = 277;
                if(GetLocalInt(oCreature, "JEFAZO") == 1) eApariencia = 244;
                NWNX_Creature_SetRacialType(oCreature, RACIAL_TYPE_HUMAN);
                AjustarEquipo(oCreature);
                break;
        }

    //Asignamos la apariencia
    DelayCommand(0.5, SetCreatureAppearanceType(oCreature, eApariencia));

    //Si es Jefe tiene poderes.
   if(GetLocalInt(oCreature, "JEFAZO") == 1)
        {
        SetObjectVisualTransform(oCreature, OBJECT_VISUAL_TRANSFORM_SCALE, 1.15);
        if(GetLocalInt(oCreature, "PODER_ESPECIAL") == FALSE && sEncuentro >= 2)
            {
            switch(d8(1))
                {
                case 1: SetLocalInt(oCreature, "PODER_ESPECIAL", 2); break;
                case 2: SetLocalInt(oCreature, "PODER_ESPECIAL", 3); break;
                case 3: SetLocalInt(oCreature, "PODER_ESPECIAL", 4); break;
                case 4: SetLocalInt(oCreature, "PODER_ESPECIAL", 5); break;
                case 5: SetLocalInt(oCreature, "PODER_ESPECIAL", 6); break;
                case 6: SetLocalInt(oCreature, "PODER_ESPECIAL", 7); break;
                case 7: SetLocalInt(oCreature, "PODER_ESPECIAL", 8); break;
                case 8: SetLocalInt(oCreature, "PODER_ESPECIAL", 10); break;
                }
            }
        }

}

