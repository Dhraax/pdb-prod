#include "mti_libreria"
#include "pb_constantes"
#include "nwnx_creature"
#include "lib_race"
void main()
{
    object oPC = GetPCSpeaker();
    int nRacialType = GetRacialType(oPC);
    string sSubRace = GetStringLowerCase(GetSubRace(oPC));
    int iModo = StringToInt(GetScriptParam("Tipo"));
    //Quitamos del jugador el modo cutsecene
    SetCutsceneMode(oPC, FALSE);

    switch(nRacialType)
    {
        case RACIAL_TYPE_CELADRIN:
            CreateItemOnObject("crr_gfuego002", oPC);
            break;
        case RACIAL_TYPE_AASIMAR:
            CreateItemOnObject("crr_subrace_5", oPC);
            break;
        case RACIAL_TYPE_DROW:
            CreateItemOnObject("crr_subrace_2", oPC);
            CreateItemOnObject("ms_fuegofee", oPC);
            break;
        case RACIAL_TYPE_DUERGAR:
            CreateItemOnObject("crr_subrace_3", oPC);
            break;
        case RACIAL_TYPE_DWARF_ARTICO:
            NWNX_Creature_SetSize(oPC, CREATURE_SIZE_SMALL);
            break;
        case RACIAL_TYPE_GAGUA:
            CreateItemOnObject("charcoracial", oPC);
            break;
        case RACIAL_TYPE_GAIRE:
            CreateItemOnObject("levitar", oPC);
            break;
        case RACIAL_TYPE_GFUEGO:
            CreateItemOnObject("crr_gfuego1", oPC);
            break;
        case RACIAL_TYPE_GTIERRA:
            CreateItemOnObject("crr_tierra1", oPC);
            break;
        case RACIAL_TYPE_GITHZERAI:
            CreateItemOnObject("crr_gaton", oPC);
            CreateItemOnObject("crr_gexplo", oPC);
            CreateItemOnObject("levitar", oPC);
            break;
        case RACIAL_TYPE_SEMIOGRO:
            NWNX_Creature_SetSize(oPC, CREATURE_SIZE_LARGE);
            break;
        case RACIAL_TYPE_TIEFLING:
            break;
        case RACIAL_TYPE_OGROHECHICERO:
            NWNX_Creature_SetSize(oPC, CREATURE_SIZE_LARGE);
            CreateItemOnObject("crr_ogro_dormir", oPC);
            CreateItemOnObject("crr_ogro_cono", oPC);
            CreateItemOnObject("crr_ogro_hecper", oPC);
            CreateItemOnObject("crr_ogro_polimor", oPC);
            CreateItemOnObject("crr_ogro_invi", oPC);
            CreateItemOnObject("crr_ogro_oscurid", oPC);
            CreateItemOnObject("crr_vuelo2", oPC);
            break;
        case RACIAL_TYPE_OGRO:
            NWNX_Creature_SetSize(oPC, CREATURE_SIZE_LARGE);
            break;
        case RACIAL_TYPE_MINOTAURO:
            NWNX_Creature_SetSize(oPC, CREATURE_SIZE_LARGE);
            break;
        case RACIAL_TYPE_GOLIAT:
            NWNX_Creature_SetSize(oPC, CREATURE_SIZE_LARGE);
            break;
        case RACIAL_TYPE_SHADARKAI:
            CreateItemOnObject("ITEMAPONER", oPC);
            break;
        case RACIAL_TYPE_TANARUKK:
            break;
        case RACIAL_TYPE_AVARIEL:
            // Alas
            int iProb = d6();
            int iAlas;
            if(iProb == 1) iAlas = 32;      // Alas de pajaro, oscuras
            else if(iProb == 2) iAlas = 6;  // Alas de pajaro
            else if(iProb == 3) iAlas = 30; // Alas de demonio, erinyes
            else if(iProb == 4) iAlas = 31; // Alas de pajaro rojo
            else iAlas = 2;                 // Alas de angel (33%)
            SetCreatureWingType(iAlas, oPC);
            CreateItemOnObject("crr_vuelo2", oPC);
            break;
    }
    if (sSubRace == "Licantropo" || sSubRace == "licantropo")
    {
        //Es un hombre lobo.
        if(iModo == 1)
        {
            //Ajustes comunes de Licántropos.
            //Todos tienen modificación de raza.
            NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_SHAPECHANGER);
            //Ajuste de caracteristicas
            NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, 2);
            NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, 2);
            // Ajuste de dotes
            NWNX_Creature_AddFeat(oPC, FEAT_LOWLIGHTVISION); // Vision en la penumbra
            NWNX_Creature_AddFeat(oPC, FEAT_IRON_WILL); // Voluntad de hierro
            GuardarStringPersistente(oPC, "TIPOLICANTROPO", "lobo");
            // Habilidades de hombre-lobo
            CreateItemOnObject("ms_hlis", oPC);
            CreateItemOnObject("ms_hldd001", oPC);
            CreateItemOnObject("ms_hldd010", oPC);
            CreateItemOnObject("ms_hldd003", oPC);
            SendMessageToPC(oPC, "<cþ–2>Tenemos más apariencias de forma híbrida para hombre-lobo. Puedes contactar con los DMs para cambiarla.</c>");
        }
        //Es un hombre jabalí.
        if(iModo == 2)
        {
            //Ajustes comunes de Licántropos.
            //Todos tienen modificación de raza.
            NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_SHAPECHANGER);
            //Ajuste de caracteristicas
            NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, 2);
            NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, 2);
            // Ajuste de dotes
            NWNX_Creature_AddFeat(oPC, FEAT_LOWLIGHTVISION); // Vision en la penumbra
            NWNX_Creature_AddFeat(oPC, FEAT_IRON_WILL); // Voluntad de hierro
            GuardarStringPersistente(oPC, "TIPOLICANTROPO", "jabali");
            // Habilidades de hombre-jabali
            CreateItemOnObject("ms_hlis", oPC);
            CreateItemOnObject("ms_hldd017", oPC);
            CreateItemOnObject("ms_hldd016", oPC);
        }
        //Es un hombre gato.
        if(iModo == 3)
        {
            //Ajustes comunes de Licántropos.
            //Todos tienen modificación de raza.
            NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_SHAPECHANGER);
            //Ajuste de caracteristicas
            NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, 2);
            NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, 2);
            // Ajuste de dotes
            NWNX_Creature_AddFeat(oPC, FEAT_LOWLIGHTVISION); // Vision en la penumbra
            NWNX_Creature_AddFeat(oPC, FEAT_IRON_WILL); // Voluntad de hierro
            GuardarStringPersistente(oPC, "TIPOLICANTROPO", "gato");
            CreateItemOnObject("ms_hlis", oPC);
            CreateItemOnObject("ms_hldd023", oPC);
            CreateItemOnObject("ms_hldd022", oPC);
            SendMessageToPC(oPC, "<cþ–2>Tenemos más apariencias de forma híbrida y animal para hombre-gato. Puedes contactar con los DMs para cambiarla.</c>");
        }
        //Es un hombre rata.
        if(iModo == 4)
        {
            //Ajustes comunes de Licántropos.
            //Todos tienen modificación de raza.
            NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_SHAPECHANGER);
            //Ajuste de caracteristicas
            NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, 2);
            NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, 2);
            // Ajuste de dotes
            NWNX_Creature_AddFeat(oPC, FEAT_LOWLIGHTVISION); // Vision en la penumbra
            NWNX_Creature_AddFeat(oPC, FEAT_IRON_WILL); // Voluntad de hierro
            GuardarStringPersistente(oPC, "TIPOLICANTROPO", "rata");
            // Habilidades de hombre-rata
            CreateItemOnObject("ms_hlis", oPC);
            CreateItemOnObject("ms_hldd026", oPC);
            CreateItemOnObject("ms_hldd025", oPC);
        }
    }
    if (sSubRace == "Engendro" || sSubRace == "engendro")
    {
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_STRENGTH, 2);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, 2);

        NWNX_Creature_AddFeat(oPC, FEAT_TEMPLATE_VAMPIRE_SPAWN);
        NWNX_Creature_AddFeat(oPC, FEAT_DARKVISION);

        NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_UNDEAD);
    }
    if (sSubRace == "Liche" || sSubRace == "liche")
    {
        // Ajusta de caracteristicas y raza
        NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_UNDEAD);
        // Aplica apariencia de Esqueleto Dinamico
        SetCreatureAppearanceType(oPC, 2770);//1769
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, 2);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, 2);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, 2);
        //Dotes
        NWNX_Creature_AddFeat(oPC, 897);
    }
    if (sSubRace == "Lythari" || sSubRace == "lythari")
    {
        // Ajuste de raza y apariencia
        NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_SHAPECHANGER);
        SetDeity(oPC, "Selûne");
        // Ajuste de caracteristicas
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, 2);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, 2);
        // Ajuste de dotes
        NWNX_Creature_AddFeat(oPC, FEAT_IRON_WILL); // Voluntad de hierro
        NWNX_Creature_AddFeat(oPC, FEAT_LOWLIGHTVISION); // Visión penumbra
        // Habilidades de lythari
        CreateItemOnObject("ms_hldd030", oPC);
    }
    if (sSubRace == "Tiflin" || sSubRace == "tiflin")
    {
        // Ajusta de raza y caracteristicas
        NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_OUTSIDER);
        SetCreatureAppearanceType(oPC, 6);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, 2);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, 2);
        // Habilidades de tiflin
        CreateItemOnObject("crr_subrace_2", oPC);
        NWNX_Creature_AddFeat(oPC, FEAT_LOWLIGHTVISION); // Visión penumbra
    }
    if (sSubRace == "Umbra" || sSubRace == "umbra")
    {
        // Ajuste de raza, caracteristicas
        NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_OUTSIDER);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, 2);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, 2);
        // Habilidades de las Umbras
        CreateItemOnObject("crr_ogro_oscurid", oPC);
        CreateItemOnObject("crr_ogro_invi", oPC);
        CreateItemOnObject("crr_gtele", oPC);
    }
    if (sSubRace == "Semifata" || sSubRace == "semifata")
    {
        // Ajusta de caracteristicas y raza
        NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_FEY);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, 2);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, - 2);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, 2);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, 4 );
        // Aplica apariencia de Semifata
        SetCreatureWingType(25, oPC);
        //Dotes
        NWNX_Creature_AddFeat(oPC, FEAT_LOWLIGHTVISION); // Visión penumbra
        // Habilidades de Semifata
        CreateItemOnObject("ms_fuegofee", oPC);
        CreateItemOnObject("crr_ogro_hecper", oPC);
        CreateItemOnObject("crr_ogro_dormir", oPC);
        CreateItemOnObject("crr_fata1", oPC);
        CreateItemOnObject("crr_fata2", oPC);
        CreateItemOnObject("crr_fata002", oPC);
        CreateItemOnObject("crr_fata4", oPC);
        CreateItemOnObject("crr_fata5", oPC);
        CreateItemOnObject("crr_fata6", oPC);
        CreateItemOnObject("levitar", oPC);
        CreateItemOnObject("crr_vuelo2", oPC);
    }
    if (sSubRace == "Vampiro" || sSubRace == "vampiro")
    {
        // Ajuste de caracteristicas y raza
        NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_UNDEAD);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_STRENGTH, 6);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, 4);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, 2);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, 2);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, 4);
        // Ajuste de dotes: Alerta, Esquiva, Inciativa mejorada, Reflejos rápidos y Competencia con arma criatura.
        NWNX_Creature_AddFeat(oPC, FEAT_ALERTNESS);
        NWNX_Creature_AddFeat(oPC, FEAT_DODGE);
        NWNX_Creature_AddFeat(oPC, FEAT_IMPROVED_INITIATIVE);
        NWNX_Creature_AddFeat(oPC, FEAT_LIGHTNING_REFLEXES);
        NWNX_Creature_AddFeat(oPC, FEAT_WEAPON_PROFICIENCY_CREATURE);
    }

    //Ponemos a todas las razas el tamaño mínimo.
    float fAltura = PB_Race_TamanoMinimo(oPC);
    GuardarIntPersistente(oPC, "CAB_ALTURA", TRUE);
    GuardarFloatPersistente(oPC, "IND_ALTURA", fAltura);
    SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, fAltura);

    // El leto ha sido aplicado
    GuardarIntPersistente(oPC, "LETO_APLICADO", TRUE);
    SetCutsceneMode(oPC,FALSE);
}
