#include "mti_libreria"
#include "nwnx_creature"

void TiradaDeDadosHab(object oPC, string sTirada, int iHab, int EsHab = FALSE, int EsSalvacion = FALSE, int EsCaracteristica = FALSE)
{
    if(EsHab == TRUE && !GetHasSkill(iHab, oPC))
    {
        SendMessageToPC(oPC,ColorTexto("No tienes esta habilidad.",TXT_COLOR_ROJO));
        return;

    }
    int iDado = Random(20)+1;
    int iRangos;
    if(EsHab == TRUE) iRangos = GetSkillRank(iHab, oPC);
    if(EsSalvacion == TRUE)
    {
        if(iHab == 1) iRangos = GetWillSavingThrow(oPC);
        if(iHab == 2) iRangos = GetReflexSavingThrow(oPC);
        if(iHab == 3) iRangos = GetFortitudeSavingThrow(oPC);
    }
    if(EsCaracteristica == TRUE) iRangos = GetAbilityModifier(iHab, oPC);
    string sFraseCompilada = "";
    string sRangos = "";

    sFraseCompilada = "Tirada de <cþ~ >"+ sTirada +"</c>, resultado ";

    if (iDado==1)
    {
        sFraseCompilada = sFraseCompilada
                        + "= <cþ  >1 Fallo</c>. Tirada de Fallo crítico ";
        iDado = Random (20)+1;
    }
    else if (iDado==20)
    {
        sFraseCompilada = sFraseCompilada
                        + "= <c þ >20 Éxito</c>. Tirada de Éxito crítico ";
        iDado = Random (20)+1;
    }

    if (iRangos<0) sRangos = IntToString(iRangos);
    else sRangos = "+"+IntToString(iRangos);
    sFraseCompilada = sFraseCompilada
                        + "<c þþ>"
                        + IntToString(iDado)+sRangos
                        +"="+IntToString(iDado+iRangos)
                        +"</c>.";
    if(GetLocalInt(GetPCSpeaker(), "iDadosDms") == 1) SendMessageToAllDMs(GetName(oPC)+": "+sFraseCompilada);
    else
        AssignCommand(oPC, ActionSpeakString(sFraseCompilada));

    return;
}


void TiradaDeDados(object oPC, string sTirada, int iOpcion)
{
    int iDado;
    if(iOpcion == 1) iDado = d2();
    if(iOpcion == 2) iDado = d4();
    if(iOpcion == 3) iDado = d6();
    if(iOpcion == 4) iDado = d8();
    if(iOpcion == 5) iDado = d10();
    if(iOpcion == 6) iDado = d12();
    if(iOpcion == 7) iDado = d20();
    if(iOpcion == 8) iDado = d100();
    if(iOpcion == 9)
    {
        iDado = d20() + NWNX_Creature_GetAttackBonus(oPC);
        SendMessageToPC(oPC,ColorTexto("Recuerda: Esta tirada no tiene en cuenta el bono de ataque que pueda otorgar los guantes al ir desarmado, si el ataque es desarmado y se tiene guantes con bono de mejora, sumadlo.",TXT_COLOR_ROJO));
    }
    if(iOpcion == 10)
    {
        iDado = d20() + GetAbilityModifier(ABILITY_DEXTERITY, oPC);
        if(GetHasFeat(337, oPC)) iDado = d20() + GetAbilityModifier(ABILITY_DEXTERITY, oPC) + 4;
    }

    string sResultado = "<c þþ>"+IntToString(iDado)+"</c>";

    if(GetLocalInt(oPC, "iDadosDms") == 1)
        SendMessageToAllDMs(GetName(oPC)+": "+"Tirada de <cþ~ >"+ sTirada +"</c>, resultado = "+ sResultado +".");
    else
        AssignCommand(oPC, ActionSpeakString("Tirada de <cþ~ >"+ sTirada +"</c>, resultado = "+ sResultado +"."));
}



void main()
{
    object oPC = GetPCChatSpeaker();
    string sTexto = GetPCChatMessage();
    string sTirada;
    int iHab;

    //////////////////////////////
    //TIRADA DE DADOS ALEATORIOS//
    //////////////////////////////
    if(GetStringLeft(sTexto, 5) == "!d100")
    {
        sTirada = "d100";
        TiradaDeDados(oPC, sTirada, 8);
        return;
    }

    if(GetStringLeft(sTexto, 4) == "!d20")
    {
        sTirada = "d20";
        TiradaDeDados(oPC, sTirada, 7);
        return;
    }

    if(GetStringLeft(sTexto, 4) == "!d12")
    {
        sTirada = "d12";
        TiradaDeDados(oPC, sTirada, 6);
        return;
    }

    if(GetStringLeft(sTexto, 4) == "!d10")
    {
        sTirada = "d10";
        TiradaDeDados(oPC, sTirada, 5);
        return;
    }

    if(GetStringLeft(sTexto, 3) == "!d8")
    {
        sTirada = "d8";
        TiradaDeDados(oPC, sTirada, 4);
        return;
    }

    if(GetStringLeft(sTexto, 3) == "!d6")
    {
        sTirada = "d6";
        TiradaDeDados(oPC, sTirada, 3);
        return;
    }

    if(GetStringLeft(sTexto, 3) == "!d4")
    {
        sTirada = "d4";
        TiradaDeDados(oPC, sTirada, 2);
        return;
    }

    if(GetStringLeft(sTexto, 3) == "!d2")
    {
        sTirada = "d2";
        TiradaDeDados(oPC, sTirada, 1);
        return;
    }

    ///////////////////////
    //TIRADAS MISCELANEAS//
    ///////////////////////
    if(GetStringLeft(sTexto, 8) == "!dAtaque")
    {
        sTirada = "ataque";
        TiradaDeDados(oPC, sTirada, 9);
        return;
    }

    if(GetStringLeft(sTexto, 12) == "!dIniciativa")
    {
        sTirada = "ataque";
        TiradaDeDados(oPC, sTirada, 10);
        return;
    }

    ////////////////////////
    //TIRADAS DE HABILIDAD//
    ////////////////////////

    if(GetStringLeft(sTexto, 7) == "!dAbrir")
    {
        sTirada = "abrir cerraduras";
        iHab = 9;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 6) == "!dArte")
    {
        sTirada = "artesanía";
        iHab = 22;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 11) == "!dAveriguar")
    {
        sTirada = "averiguar intenciones";
        iHab = 28;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 9) == "!dAvistar")
    {
        sTirada = "avistar";
        iHab = 17;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 8) == "!dBuscar")
    {
        sTirada = "buscar";
        iHab = 14;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 15) == "!dConcentracion")
    {
        sTirada = "concentración";
        iHab = 1;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 10) == "!dConjuros")
    {
        sTirada = "conocimiento de conjuros";
        iHab = 16;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 11) == "!dDescifrar")
    {
        sTirada = "descifrar escritura";
        iHab = 29;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 12) == "!dDiplomacia")
    {
        sTirada = "diplomacia";
        iHab = 12;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 9) == "!dDisfraz")
    {
        sTirada = "disfrazarse";
        iHab = 30;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 9) == "!dEngañar")
    {
        sTirada = "engañar";
        iHab = 23;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 12) == "!dEquilibrio")
    {
        sTirada = "equilibrio";
        iHab = 31;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 11) == "!dEscapismo")
    {
        sTirada = "escapismo";
        iHab = 32;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 12) == "!dEsconderse")
    {
        sTirada = "esconderse";
        iHab = 5;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 10) == "!dEscuchar")
    {
        sTirada = "escuchar";
        iHab = 6;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 12) == "!dFalsificar")
    {
        sTirada = "falsificar";
        iHab = 33;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 8) == "!dHablar")
    {
        sTirada = "hablar idiomas";
        iHab = 34;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 7) == "!dManos")
    {
        sTirada = "juego de manos";
        iHab = 13;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 13) == "!dInterpretar")
    {
        sTirada = "interpretar";
        iHab = 11;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 11) == "!dIntimidar")
    {
        sTirada = "intimidar";
        iHab = 24;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 12) == "!dInutilizar")
    {
        sTirada = "inutilizar mecanismo";
        iHab = 2;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 8) == "!dMontar")
    {
        sTirada = "montar";
        iHab = 27;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 8) == "!dSigilo")
    {
        sTirada = "moverse sigiloso";
        iHab = 8;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 7) == "!dNadar")
    {
        sTirada = "nadar";
        iHab = 25;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 10) == "!dPiruetas")
    {
        sTirada = "piruetas";
        iHab = 21;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 9) == "!dTrampas")
    {
        sTirada = "poner trampas";
        iHab = 15;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 8) == "!dReunir")
    {
        sTirada = "reunir información";
        iHab = 35;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 8) == "!dArcano")
    {
        sTirada = "saber arcano";
        iHab = 7;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 7) == "!dLocal")
    {
        sTirada = "saber local";
        iHab = 3;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 7) == "!dOtros")
    {
        sTirada = "saber otros";
        iHab = 18;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 10) == "!dReligion")
    {
        sTirada = "religión";
        iHab = 10;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 7) == "!dSanar")
    {
        sTirada = "sanar";
        iHab = 4;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 8) == "!dSaltar")
    {
        sTirada = "saltar";
        iHab = 26;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }
    if(GetStringLeft(sTexto, 15) == "!dSupervivencia")
    {
        sTirada = "supervivencia";
        iHab = 36;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }
    if(GetStringLeft(sTexto, 10) == "!dTasacion")
    {
        sTirada = "tasación";
        iHab = 20;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }
    if(GetStringLeft(sTexto, 10) == "!dAnimales")
    {
        sTirada = "trato con animales";
        iHab = 0;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 8) == "!dTrepar")
    {
        sTirada = "trepar";
        iHab = 37;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 5) == "!dUOM")
    {
        sTirada = "usar objeto mágico";
        iHab = 19;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 9) == "!dCuerdas")
    {
        sTirada = "uso de cuerdas";
        iHab = 38;
        TiradaDeDadosHab(oPC, sTirada, iHab, TRUE);
        return;
    }

    ////////////////////////
    //TIRADAS DE SALVACION//
    ////////////////////////
    if(GetStringLeft(sTexto, 10) == "!dVoluntad")
    {
        sTirada = "voluntad";
        TiradaDeDadosHab(oPC, sTirada, 1, FALSE, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 10) == "!dReflejos")
    {
        sTirada = "reflejos";
        TiradaDeDadosHab(oPC, sTirada, 2, FALSE, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 11) == "!dFortaleza")
    {
        sTirada = "fortaleza";
        TiradaDeDadosHab(oPC, sTirada, 3, FALSE, TRUE);
        return;
    }

    //////////////////////////////
    //TIRADAS DE CARACTERISTICAS//
    //////////////////////////////
    if(GetStringLeft(sTexto, 5) == "!dFue")
    {
        sTirada = "fuerza";
        TiradaDeDadosHab(oPC, sTirada, ABILITY_STRENGTH, FALSE, FALSE, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 5) == "!dSab")
    {
        sTirada = "sabiduría";
        TiradaDeDadosHab(oPC, sTirada, ABILITY_WISDOM, FALSE, FALSE, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 5) == "!dCar")
    {
        sTirada = "carisma";
        TiradaDeDadosHab(oPC, sTirada, ABILITY_CHARISMA, FALSE, FALSE, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 5) == "!dCon")
    {
        sTirada = "constitución";
        TiradaDeDadosHab(oPC, sTirada, ABILITY_CONSTITUTION, FALSE, FALSE, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 5) == "!dDex")
    {
        sTirada = "destreza";
        TiradaDeDadosHab(oPC, sTirada, ABILITY_DEXTERITY, FALSE, FALSE, TRUE);
        return;
    }

    if(GetStringLeft(sTexto, 5) == "!dInt")
    {
        sTirada = "inteligencia";
        TiradaDeDadosHab(oPC, sTirada, ABILITY_INTELLIGENCE, FALSE, FALSE, TRUE);
        return;
    }

    //CHAT AYUDA
    if(GetStringLeft(sTexto, 7) == "!dAyuda")
    {
        SendMessageToPC(oPC,ColorTexto("Dados de Habilidades: !dAbrir, !dArte, !dAveriguar, !dAvistar, !dBuscar, !dConcentracion, !dConjuros, !dDescifrar, !dDiplomacia, !dDisfraz, !dEngañar, !dEquilibrio, !dEscapismo, !dEsconderse, !dEscuchar, !dFalsificar, !dHablar, !dManos, !dInterpretar, !dIntimidar, !dInutilizar, !dMontar, !dSigilo, !dNadar, !dPiruetas, !dTrampas, !dReunir, !dArcano, !dLocal, !dOtros, !dReligion, !dSanar, !dSaltar, !dSupervivencia, !dTasacion, !dAnimales, !dTrepar, !dUOM, !dCuerdas.",TXT_COLOR_VERDE));
        SendMessageToPC(oPC,ColorTexto("Dados miceláneos: !d100, !d20, !d12, !d10, !d8, !d6, !d4, !d2, !dAtaque, !dIniciativa.",TXT_COLOR_VERDE));
        SendMessageToPC(oPC,ColorTexto("Dados salvación: !dVoluntad, !dReflejos, !dFortaleza.",TXT_COLOR_VERDE));
        SendMessageToPC(oPC,ColorTexto("Dados características: !dCar, !dCon, !dDex, !dInt, !dFue, !dSab.",TXT_COLOR_VERDE));
        return;
    }
}
