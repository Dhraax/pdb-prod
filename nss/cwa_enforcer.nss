//:://////////////////////////////////////////////
/*
   Pre-Conjuros
*/
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "mti_libreria"
#include "aa_i_main"
#include "pb_nivellanzador"
#include "glt_blig_spellch"
#include "inc_spells"
#include "inc_timelock"

void main()
{
    object oPC = OBJECT_SELF;
    //GetSpellTargetLocation(); // returns the targeted location of the spell, if valid
    //GetSpellSaveDC(); // gets the DC required to save against the effects of the spell
    //Fix para evitar el error de demasiado nivel en conjuros lanzados vía feats.
    int nSpellFeatId = GetSpellFeatId();
    if(GetIsPC(oPC) && !GetIsDM(oPC) && !GetIsDMPossessed(oPC))
    {
        if(!CheckBlighterSpellcast())
        {
            SetModuleOverrideSpellScriptFinished();
            return;
        }
        //Si el lanzador no puede lanzar el conjuro y además, no es un conjuro de una dote.
        if(!GetCasterCanCast() && nSpellFeatId == -1)
        {
            SetModuleOverrideSpellScriptFinished();
            FloatingTextStringOnCreature("Este conjuro es de nivel demasiado alto para ti.", OBJECT_SELF, FALSE);
            return;
        }
    }


    object oObjetivo = GetSpellTargetObject();
    object oObjetoConjuro = GetSpellCastItem();
    int iConjuro = GetSpellId();
    int iNivel = GetTotalCasterLevel(OBJECT_SELF);
    //int ClaseConjuro = GetLastSpellCastClass();
    string NombreMapa = GetName(GetArea(oPC), TRUE);

    // Pociones envenenadas
    string sTag = GetTag(GetSpellCastItem());
    sTag = GetStringRight(sTag, 10);

    if (sTag == "envenenada")
    {
        //Obtiene nuevamente el tag de la pocion
        sTag = GetTag(GetSpellCastItem());
        //Y obtiene el id de la pocion cargado en el tag
        sTag = GetStringRight(sTag, 13);
        sTag = GetStringLeft(sTag, 2);
        //Aplica la pocion al efecto
        effect eVenon = EffectPoison(StringToInt(sTag));
        object oTarget = GetSpellTargetObject();
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVenon, oTarget);
        SendMessageToPC(oTarget, "¡La poción está envenenada!");
        //Evita que se desencadene el conjuro
        SetModuleOverrideSpellScriptFinished();
    }

    // Cuerpo ferreo, pociones no
    if(oPC == oObjetivo && GetHasSpellEffect(996, oPC) && GetIsObjectValid(oObjetoConjuro) &&
    (GetBaseItemType(oObjetoConjuro) == 49 || GetBaseItemType(oObjetoConjuro) == 101 || GetBaseItemType(oObjetoConjuro) == 104))
    {
        SetModuleOverrideSpellScriptFinished();
        SendMessageToPC(oPC, "<cÂ>La poción no hace efecto debido al conjuro 'Cuerpo férreo' que tienes activo.</c>");
        return;
    }

    // Guardias negros, agentes arpistas y asesinos (No tener caracteristica lanzadora)
    if(GetIsObjectValid(oObjetoConjuro) == FALSE)
    {
        int iFalloCaracPrimara = FALSE;

        if(GetLevelByClass(CLASS_TYPE_HARPER, oPC) > 0)
        {
            if(iConjuro >= 1110 && iConjuro <= 1114 && GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE) < 11) iFalloCaracPrimara = TRUE;
            if(iConjuro >= 1116 && iConjuro <= 1120 && GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE) < 12) iFalloCaracPrimara = TRUE;
            if(iConjuro >= 1122 && iConjuro <= 1126 && GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE) < 13) iFalloCaracPrimara = TRUE;
        }

        if(GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC) > 0)
        {
            if(iConjuro >= 1002 && iConjuro <= 1006 && GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) < 11) iFalloCaracPrimara = TRUE;
            if(iConjuro >= 1008 && iConjuro <= 1012 && GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) < 12) iFalloCaracPrimara = TRUE;
            if(iConjuro >= 1014 && iConjuro <= 1018 && GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) < 13) iFalloCaracPrimara = TRUE;
            if(iConjuro >= 1020 && iConjuro <= 1024 && GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) < 14) iFalloCaracPrimara = TRUE;
        }

        if(GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC) > 0)
        {
            if(iConjuro >= 1072 && iConjuro <= 1076 && GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) < 11) iFalloCaracPrimara = TRUE;
            if(iConjuro >= 1078 && iConjuro <= 1082 && GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) < 12) iFalloCaracPrimara = TRUE;
            if(iConjuro >= 1084 && iConjuro <= 1088 && GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) < 13) iFalloCaracPrimara = TRUE;
            if(iConjuro >= 1090 && iConjuro <= 1094 && GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) < 14) iFalloCaracPrimara = TRUE;
        }

        if(iFalloCaracPrimara == TRUE)
        {
            SetModuleOverrideSpellScriptFinished();
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(62), oPC);
            SendMessageToPC(oPC, "<cÂ>¡No puedes lanzar el conjuro! Tu característica primaria lanzadora de conjuros no es lo suficiente alta.</c>");
            return;
        }
    }

    // Zona magia muerta
    if(GetLocalInt(GetArea(oPC), "MAGIA_MUERTA") == TRUE)
    {
        if(NombreMapa == "Mar de las Espadas"|| NombreMapa == "Mar Impenetrable") //Añadido de Nompho
        {
            if(iConjuro == SPELL_FIREBALL               || iConjuro == SPELL_CALL_LIGHTNING||
                iConjuro == SPELL_CHAIN_LIGHTNING        || iConjuro == SPELL_CONE_OF_COLD||
                iConjuro == SPELL_DELAYED_BLAST_FIREBALL || iConjuro == SPELL_EPIC_HELLBALL||
                iConjuro == SPELL_EPIC_RUIN              || iConjuro == SPELL_FIRE_STORM||
                iConjuro == SPELL_ICE_STORM              || iConjuro == SPELL_IMPLOSION||
                iConjuro == SPELL_LIGHTNING_BOLT         || iConjuro == SPELL_METEOR_SWARM||
                iConjuro == SPELL_STORM_OF_VENGEANCE     || iConjuro == SPELL_WAIL_OF_THE_BANSHEE||
                iConjuro == SPELL_PROTECTION_FROM_EVIL   || iConjuro == SPELL_PROTECTION_FROM_GOOD||
                iConjuro == SPELL_INCENDIARY_CLOUD       || iConjuro == SPELL_INFERNO)
            {
                return;
            }
            else
            {
                SetModuleOverrideSpellScriptFinished();
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(62), oPC);
                SendMessageToPC(oPC, "<cÂ>¡Desde el barco no puedes lanzar conjuros a otras regiones alejadas del mar!</c>");
                return;
            }
        }

        SetModuleOverrideSpellScriptFinished();
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(62), oPC);
        SendMessageToPC(oPC, "<cÂ>¡Esta zona es de magia muerta! El conjuro no funcionó.</c>");
        return;
    }

    // Zona magia salvaje. Añadido de Nompho
    if(GetLocalInt(GetArea(oPC), "MAGIA_SALVAJE") == TRUE)
    {
        int conjuroaleatorio = Random(635);

        SetModuleOverrideSpellScriptFinished();
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(62), oPC);
        SendMessageToPC(oPC, "<cÂ>¡Esta zona es de magia salvaje! El conjuro se descontrola.</c>");
        ActionCastSpellAtObject(conjuroaleatorio,oObjetivo,METAMAGIC_ANY,TRUE,15,PROJECTILE_PATH_TYPE_DEFAULT,FALSE);
        return;
    }

    // Grilletes arcanos, con fallo de conjuro
    object oGrilletes = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
    string sGrilletes = GetStringLeft(GetTag(oGrilletes), 15);
    if(sGrilletes == "grillete_arcano")
    {
        string sTipoGrillete = GetStringRight(GetTag(oGrilletes), 1);
        int iPorcentage;
        if(sTipoGrillete == "1") iPorcentage = 25;
        else if(sTipoGrillete == "2") iPorcentage = 50;
        else if(sTipoGrillete == "3") iPorcentage = 75;
        else if(sTipoGrillete == "4") iPorcentage = 100;

        if(d100() <= iPorcentage)
        {
            SetModuleOverrideSpellScriptFinished();
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(77), oPC);
            SendMessageToPC(oPC, "<cÂ>¡El grillete arcano te impide usar magia!</c>");
            return;
        }
    }

    // Imbuir flecha de arquero arcano
    if(GetHasFeat(FEAT_PRESTIGE_IMBUE_ARROW))
    {
        int iResult = AAImbueArrow(oObjetivo, iConjuro, iNivel);

        if(iResult == 1)
        {
            FloatingTextStringOnCreature("* Has imbuido la flecha con éxito *", OBJECT_SELF);
            SetModuleOverrideSpellScriptFinished();
        }

        else if(iResult == 0)
        {
            FloatingTextStringOnCreature("* Fracasas al imbuir la flecha *", OBJECT_SELF);
            SetModuleOverrideSpellScriptFinished();
        }
    }

    // Has usado magia ilegalmente
    if(GetLocalInt(GetArea(oPC), "CWA_AREA") == TRUE)
    {
        // Si el conjuro es lanzado por el jugador... (varitas, cetros, etc. se permiten)
        // Comprobacion de licencia magica
        // A los DMs no les salta
        // Evitar que salgan los magos muy repetidamente
        if(oObjetoConjuro != OBJECT_INVALID) return;
        if(GetItemPossessedBy(oPC, "licenciamagica") != OBJECT_INVALID) return;
        if(GetIsDM(oPC) || GetIsDMPossessed(oPC)) return;
        if(GetLocalString(GetModule(), "AVISOMAGO" + GetName(oPC)) == GetName(oPC)) return;

        // Conjuros que ignoran esto (curaciones y eso)
        if(iConjuro == SPELL_CURE_CRITICAL_WOUNDS || iConjuro == SPELL_CURE_LIGHT_WOUNDS ||
            iConjuro == SPELL_CURE_MINOR_WOUNDS || iConjuro == SPELL_CURE_MODERATE_WOUNDS ||
            iConjuro == SPELL_CURE_SERIOUS_WOUNDS || iConjuro == SPELL_MONSTROUS_REGENERATION ||
            iConjuro == SPELL_REGENERATE || iConjuro == VFX_IMP_RESTORATION ||
            iConjuro == VFX_IMP_RESTORATION_GREATER || iConjuro == VFX_IMP_RESTORATION_LESSER ||
            iConjuro == SPELL_HEAL || iConjuro == SPELL_HEALING_CIRCLE || iConjuro == SPELL_HEALING_STING ||
            iConjuro == SPELL_REMOVE_BLINDNESS_AND_DEAFNESS || iConjuro == SPELL_REMOVE_CURSE ||
            iConjuro == SPELL_REMOVE_DISEASE || iConjuro == SPELL_REMOVE_FEAR || iConjuro == SPELL_REMOVE_PARALYSIS ||
            iConjuro == 1050 || iConjuro == 1051 || iConjuro == 1052 || iConjuro == 1053 ||
            (iConjuro >= 1061 && iConjuro <= 1070)) return;

        SendMessageToPC(oPC, "<cÂ>¡Has usado magia ilegalmente</c>");
        object oMago = CreateObject(OBJECT_TYPE_CREATURE, "magoencapuchado", GetLocation(oPC));
        DelayCommand(2.9, AssignCommand(oPC, ClearAllActions(TRUE)));
        DelayCommand(3.0, AssignCommand(oMago, ActionStartConversation(oPC, "cwa_enforcer")));
        string sNombre = GetName(oPC, TRUE);
        string sCuenta = GetPCPlayerName(oPC);
        string sAvisos = IntToString(ObtenerIntPersistente(oPC, "AVISOSMAGOS")+1);
        SendMessageToAllDMs("[Informe de los magos encapuchados] El desviado: "+sNombre+" ("+sCuenta+") ha usado conjuros potencialmente dañinos en Athkatla. Veces acollejeado: "+sAvisos+".");
    }

    // Compartir conjuro familiar y companyero animal
    int iCompartirConjuro = 0;
    string sHostil = Get2DAString("spells", "HostileSetting", iConjuro);
    if(GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC)) == TRUE) iCompartirConjuro = ASSOCIATE_TYPE_FAMILIAR;
    if(GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC)) == TRUE) iCompartirConjuro = ASSOCIATE_TYPE_ANIMALCOMPANION;

    if(oObjetivo == oPC && iCompartirConjuro > 0 && sHostil == "0" && /* oObjetoConjuro == OBJECT_INVALID && */
        iConjuro != SPELL_SANCTUARY       && iConjuro != SPELL_AURA_OF_VITALITY && iConjuro != SPELL_ELEMENTAL_SWARM &&
        iConjuro != SPELL_AURAOFGLORY     && iConjuro != SPELL_NATURES_BALANCE  && iConjuro != SPELL_ETHEREALNESS &&
        iConjuro != SPELL_FIREBRAND       && iConjuro != SPELL_FLAME_WEAPON     && iConjuro != SPELL_GREATER_MAGIC_WEAPON &&
        iConjuro != 1050 && iConjuro != 1051 && iConjuro != 1052 && iConjuro != 1053 && iConjuro != SPELL_ETHEREAL_VISAGE &&
        iConjuro != 1043 && iConjuro != 1044 && iConjuro != 1045 && iConjuro != 1046 && iConjuro != 1047 && iConjuro != 1048 &&
        iConjuro != 387  && iConjuro != 388  && iConjuro != 389  && iConjuro != 390  && iConjuro != 391  && iConjuro != 392 &&
        iConjuro != 393  && iConjuro != 394  && iConjuro != 395  && iConjuro != 396  && iConjuro != 397  && iConjuro != 398 &&
        iConjuro != 399  && iConjuro != 400  && iConjuro != 401  && iConjuro != 402  && iConjuro != 403  && iConjuro != 404 &&
        iConjuro != 405  && iConjuro != 546)
    {
        object oAliado = GetAssociate(iCompartirConjuro, oPC);

        DelayCommand(0.5, AssignCommand(oAliado, ClearAllActions(TRUE)));
        DelayCommand(1.0, AssignCommand(oAliado, ActionCastSpellAtObject(iConjuro, oAliado, GetMetaMagicFeat(), TRUE, 15, PROJECTILE_PATH_TYPE_DEFAULT, TRUE)));
        DelayCommand(1.5, AssignCommand(oAliado, ClearAllActions(TRUE)));
    }

    //Imbuir item de Artífice y Aptitud Sortílega Archimago.
    //Se lanza un conjuro contra el item.
    if(GetTag(oObjetivo) == "cls_ing_item5" || GetTag(oObjetivo) == "ArchmagesFocusofPower")
    {
        if(GetTag(oObjetivo) == "ArchmagesFocusofPower" && GetLocalInt(oObjetivo,"APTITUD_SETEADA") != 0)
        {
            SetModuleOverrideSpellScriptFinished();
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(62), oPC);
            if(GetTag(oObjetivo) == "ArchmagesFocusofPower"){SendMessageToPC(oPC, "<c´$$>¡Solo se puede guardar una única vez el conjuro en tu Aptitud Sortílega!</c>");}
            return;
        }
        if(GetIsObjectValid(oObjetoConjuro))
        {
            SetModuleOverrideSpellScriptFinished();
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(62), oPC);
            if(GetTag(oObjetivo) == "cls_ing_item5"){SendMessageToPC(oPC, "<c´$$>¡No puedes imbuir tu Objeto Guardaconjuros, con un conjuro proveniente de un objeto!</c>");}
            if(GetTag(oObjetivo) == "ArchmagesFocusofPower"){SendMessageToPC(oPC, "<c´$$>¡No puedes guardar este conjuro en tu Aptitud Sortílega, con un conjuro proveniente de un objeto!</c>");}
            return;
        }
        if(GetSpellFeatId() != -1)
        {
            SetModuleOverrideSpellScriptFinished();
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(62), oPC);
            if(GetTag(oObjetivo) == "cls_ing_item5"){SendMessageToPC(oPC, "<c´$$>¡No puedes imbuir tu Objeto Guardaconjuros, con un conjuro proveniente de una dote!</c>");}
            if(GetTag(oObjetivo) == "ArchmagesFocusofPower"){SendMessageToPC(oPC, "<c´$$>¡No puedes guardar este conjuro en tu Aptitud Sortílega, con un conjuro proveniente de una dote!</c>");}
            return;
        }
        SetLocalInt(oObjetivo,"SPELL_ID",iConjuro);
        if(GetTag(oObjetivo) == "cls_ing_item5"){SendMessageToPC(oPC,ColorTexto("Conjuro guardado correctamente en el Objeto Guardaconjuros.",TXT_COLOR_VERDE));}
        if(GetTag(oObjetivo) == "ArchmagesFocusofPower")
        {
            SendMessageToPC(oPC,ColorTexto("Conjuro guardado correctamente la Aptitud Sortílega.",TXT_COLOR_VERDE));
            SetLocalInt(oObjetivo,"APTITUD_SETEADA",1);
        }
    }

    //TRUCOS INFINITOS: MAGO, HECHICERO, BARDO, DRUIDA, CLERIGO
    if(GetLastSpellCastClass() == CLASS_TYPE_WIZARD || GetLastSpellCastClass() == CLASS_TYPE_SORCERER || GetLastSpellCastClass() == CLASS_TYPE_BARD || GetLastSpellCastClass() == CLASS_TYPE_DRUID || GetLastSpellCastClass() == CLASS_TYPE_CLERIC || GetLastSpellCastClass() == CLASS_TYPE_INGENIERO   || GetLastSpellCastClass() == CLASS_TYPE_FAVORED_SOUL)
    {
        //Leemos la esfera del conjuro usado.
        int iEsfera = StringToInt(Get2DAString("spells", "Innate", iConjuro));
        //Si es un truco, volvemos a darle el uso que ha gastado.
        if(iEsfera == 0)
        {
            if(GetLastSpellCastClass() == CLASS_TYPE_WIZARD || GetLastSpellCastClass() == CLASS_TYPE_CLERIC || GetLastSpellCastClass() == CLASS_TYPE_DRUID || GetLastSpellCastClass() == CLASS_TYPE_INGENIERO)
            {
                //Los conjuros de luz + color, regeneran el conjuro "padre" luz.
                if(iConjuro >= 1061 && iConjuro <= 1065){iConjuro =100;}
                ReadySingleMemorizedSpell(oPC, GetLastSpellCastClass(), iConjuro, GetMetaMagicFeat());
            }
            if(GetLastSpellCastClass() == CLASS_TYPE_BARD || GetLastSpellCastClass() == CLASS_TYPE_SORCERER  || GetLastSpellCastClass() == CLASS_TYPE_FAVORED_SOUL)
            {
                ReadySpellLevel(oPC, iEsfera, GetLastSpellCastClass());
            }
        }
    }

    //Varitas del brujo solo puede usarlas el creador de la varita.
    string sWarCreator = GetLocalString(oObjetoConjuro, "WAR_CREADOR");

    if(sWarCreator != "" && sWarCreator != GetName(oPC,TRUE))
    {
        SetModuleOverrideSpellScriptFinished();
        SendMessageToPC(oPC,ColorTexto("¡Las varitas creadas por un brujo arcano, solo las puede usar su creador!",TXT_COLOR_ROJO));
        return;
    }

    //COOLDOWN POCIONES
    if(GetTag(oObjetoConjuro) == "NW_IT_MPOTION020")
    {
        // Cooldown check.
        if(GetIsTimelocked(oPC, "Pocion de Curar Heridas Moderadas"))
        {
            TimelockErrorMessage(oPC, "Pocion de Curar Heridas Moderadas");
            CreateItemOnObject(GetTag(oObjetoConjuro), oPC, 1);
            SetModuleOverrideSpellScriptFinished();
            return;
        }
        if(GetLocalInt(oPC, "dm_nocurar") == 1)
        {
            SetModuleOverrideSpellScriptFinished();
            CreateItemOnObject(GetTag(oObjetoConjuro), oPC, 1);
            return;
        }
        SetTimelock(oPC, 10, "Pocion de Curar Heridas Moderadas", 0, 0);
    }
    if(GetTag(oObjetoConjuro) == "NW_IT_MPOTION001")
    {
        // Cooldown check.
        if(GetIsTimelocked(oPC, "Pocion de Curar Heridas Leves"))
        {
            TimelockErrorMessage(oPC, "Pocion de Curar Heridas Leves");
            CreateItemOnObject(GetTag(oObjetoConjuro), oPC, 1);
            SetModuleOverrideSpellScriptFinished();
            return;
        }
        if(GetLocalInt(oPC, "dm_nocurar") == 1)
        {
            SetModuleOverrideSpellScriptFinished();
            CreateItemOnObject(GetTag(oObjetoConjuro), oPC, 1);
            return;
        }
        SetTimelock(oPC, 10, "Pocion de Curar Heridas Leves", 0, 0);
    }
    if(GetTag(oObjetoConjuro) == "NW_IT_MPOTION002")
    {
        // Cooldown check.
        if(GetIsTimelocked(oPC, "Pocion de Curar Heridas Graves"))
        {
            TimelockErrorMessage(oPC, "Pocion de Curar Heridas Graves");
            CreateItemOnObject(GetTag(oObjetoConjuro), oPC, 1);
            SetModuleOverrideSpellScriptFinished();
            return;
        }
        if(GetLocalInt(oPC, "dm_nocurar") == 1)
        {
            SetModuleOverrideSpellScriptFinished();
            CreateItemOnObject(GetTag(oObjetoConjuro), oPC, 1);
            return;
        }
        SetTimelock(oPC, 10, "Pocion de Curar Heridas Graves", 0, 0);
    }
    if(GetTag(oObjetoConjuro) == "NW_IT_MPOTION003")
    {
        // Cooldown check.
        if(GetIsTimelocked(oPC, "Pocion de Curar Heridas Criticas"))
        {
            TimelockErrorMessage(oPC, "Pocion de Curar Heridas Criticas");
            CreateItemOnObject(GetTag(oObjetoConjuro), oPC, 1);
            SetModuleOverrideSpellScriptFinished();
            return;
        }
        if(GetLocalInt(oPC, "dm_nocurar") == 1)
        {
            SetModuleOverrideSpellScriptFinished();
            CreateItemOnObject(GetTag(oObjetoConjuro), oPC, 1);
            return;
        }
        SetTimelock(oPC, 10, "Pocion de Curar Heridas Criticas", 0, 0);
    }
    if(GetTag(oObjetoConjuro) == "NW_IT_MPOTION011")
    {
        // Cooldown check.
        if(GetIsTimelocked(oPC, "Pocion de Restablecimiento Menor"))
        {
            TimelockErrorMessage(oPC, "Pocion de Restablecimiento Menor");
            CreateItemOnObject(GetTag(oObjetoConjuro), oPC, 1);
            SetModuleOverrideSpellScriptFinished();
            return;
        }
        if(GetLocalInt(oPC, "dm_nocurar") == 1)
        {
            SetModuleOverrideSpellScriptFinished();
            CreateItemOnObject(GetTag(oObjetoConjuro), oPC, 1);
            return;
        }
        SetTimelock(oPC, 10, "Pocion de Curar Restablecimiento Menor", 0, 0);
    }
    if(GetTag(oObjetoConjuro) == "NW_IT_MPOTION006")
    {
        // Cooldown check.
        if(GetIsTimelocked(oPC, "Pocion de Antidoto"))
        {
            TimelockErrorMessage(oPC, "Pocion de Antidoto");
            CreateItemOnObject(GetTag(oObjetoConjuro), oPC, 1);
            SetModuleOverrideSpellScriptFinished();
            return;
        }
        if(GetLocalInt(oPC, "dm_nocurar") == 1)
        {
            SetModuleOverrideSpellScriptFinished();
            CreateItemOnObject(GetTag(oObjetoConjuro), oPC, 1);
            return;
        }
        SetTimelock(oPC, 10, "Pocion de Antidoto", 0, 0);
    }

    //SendMessageToPC(oPC,ColorTexto(GetName(oObjetoConjuro)+" "+GetTag(oObjetoConjuro),TXT_COLOR_ROJO));

    ExecuteScript("cerr_setsplev", OBJECT_SELF);
}
