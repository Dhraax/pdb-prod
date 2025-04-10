//::///////////////////////////////////////////////
//:: USAR OBJETO MAGICO (Pergaminos)
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
  Regula cuando se requieren tiradas de UOM y cuando no al lanzar conjuros
  a traves de pergaminos.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 23/04/2013
//:://////////////////////////////////////////////

#include "x2_inc_switches"
#include "pb_nivellanzador"
#include "dominios_inc"
#include "inc_timelock"

const int DEBUG = FALSE; // Activa mensajes de ayuda de testeo
object oPC = OBJECT_SELF;

void FracasoEspectacular(object oPC)
{
  switch(d8())
  {
      case 1: ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(3)), oPC); break;
      case 2: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oPC, 10.0); break;
      case 3: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectConfused(), oPC, 10.0); break;
      case 4: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph(POLYMORPH_TYPE_COW, TRUE), oPC, 12.0); break;
      case 5: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oPC, 10.0); break;
      case 6: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNegativeLevel(1), oPC, 60.0); break;
      case 7: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPetrify(), oPC, 10.0); break;
      case 8: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCurse(2,2,2,2,2,2), oPC, 60.0); break;
  }

  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_S), oPC);
}

int ObtenerNivelMinimoPerga(int iClase, int iEsfera)
{
    int iNivelNecesario = 0;

    // clerigo, druida, mago
    if (iClase == CLASS_TYPE_CLERIC || iClase == CLASS_TYPE_DRUID || iClase == CLASS_TYPE_WIZARD)
    {
        switch (iEsfera)
        {
            case 1: iNivelNecesario = 1; break;
            case 2: iNivelNecesario = 3; break;
            case 3: iNivelNecesario = 5; break;
            case 4: iNivelNecesario = 7; break;
            case 5: iNivelNecesario = 9; break;
            case 6: iNivelNecesario = 11; break;
            case 7: iNivelNecesario = 13; break;
            case 8: iNivelNecesario = 15; break;
            case 9: iNivelNecesario = 17; break;
        }
    }

    // Hechicero y Alma Predilecta
    else if (iClase == CLASS_TYPE_SORCERER || iClase == CLASS_TYPE_FAVORED_SOUL)
    {
        switch(iEsfera)
        {
            case 1: iNivelNecesario = 1; break;
            case 2: iNivelNecesario = 4; break;
            case 3: iNivelNecesario = 6; break;
            case 4: iNivelNecesario = 8; break;
            case 5: iNivelNecesario = 10; break;
            case 6: iNivelNecesario = 12; break;
            case 7: iNivelNecesario = 14; break;
            case 8: iNivelNecesario = 16; break;
            case 9: iNivelNecesario = 18; break;
        }
    }

    // Bardo
    else if(iClase == CLASS_TYPE_BARD)
    {
        switch(iEsfera)
        {
            case 1: iNivelNecesario = 2; break;
            case 2: iNivelNecesario = 4; break;
            case 3: iNivelNecesario = 7; break;
            case 4: iNivelNecesario = 10; break;
            case 5: iNivelNecesario = 13; break;
            case 6: iNivelNecesario = 16; break;
        }
    }

    // Paladin / Explorador
    else if(iClase == CLASS_TYPE_PALADIN || iClase == CLASS_TYPE_RANGER || iClase == CLASS_TYPE_PAL_ANTIGUO || iClase == CLASS_TYPE_PAL_OSCURO || iClase == CLASS_TYPE_PAL_VENGADOR)
    {
        switch(iEsfera)
        {
            case 1: iNivelNecesario = 4; break;
            case 2: iNivelNecesario = 8; break;
            case 3: iNivelNecesario = 11; break;
            case 4: iNivelNecesario = 14; break;
        }
    }

    // Agente Arpista
    else if(iClase == CLASS_TYPE_HARPER)
    {
        switch(iEsfera)
        {
            case 1: iNivelNecesario = 1; break;
            case 2: iNivelNecesario = 3; break;
            case 3: iNivelNecesario = 5; break;
        }
    }

    // Asesino / Guardia negro
    else if(iClase == CLASS_TYPE_ASSASSIN || iClase == CLASS_TYPE_BLACKGUARD)
    {
        switch(iEsfera)
        {
            case 1: iNivelNecesario = 1; break;
            case 2: iNivelNecesario = 3; break;
            case 3: iNivelNecesario = 5; break;
            case 4: iNivelNecesario = 7; break;
        }
    }

    // Artífice
    if (iClase == CLASS_TYPE_INGENIERO)
    {
        switch (iEsfera)
        {
            case 1: iNivelNecesario = 2; break;
            case 2: iNivelNecesario = 6; break;
            case 3: iNivelNecesario = 9; break;
            case 4: iNivelNecesario = 12; break;
            case 5: iNivelNecesario = 15; break;
            case 6: iNivelNecesario = 18; break;
            case 7: iNivelNecesario = 23; break;
            case 8: iNivelNecesario = 26; break;
            case 9: iNivelNecesario = 29; break;
        }
    }

  return iNivelNecesario;
}

int UsarObjetoMagicoPergas()
{
    object oObjetoEjecutado = GetSpellCastItem();

    // Si no hay objeto por medio...
    // O no es un pergamino o varita o cetro o baston magico...
    if(!GetIsObjectValid(oObjetoEjecutado) ||
        (GetBaseItemType(oObjetoEjecutado) != BASE_ITEM_BLANK_SCROLL && GetBaseItemType(oObjetoEjecutado) != BASE_ITEM_ENCHANTED_SCROLL &&
        GetBaseItemType(oObjetoEjecutado) != BASE_ITEM_SCROLL       && GetBaseItemType(oObjetoEjecutado) != BASE_ITEM_SPELLSCROLL      &&
        GetBaseItemType(oObjetoEjecutado) != BASE_ITEM_BLANK_WAND   && GetBaseItemType(oObjetoEjecutado) != BASE_ITEM_ENCHANTED_WAND   &&
        GetBaseItemType(oObjetoEjecutado) != BASE_ITEM_MAGICWAND    && GetBaseItemType(oObjetoEjecutado) != BASE_ITEM_MAGICROD         &&
        GetBaseItemType(oObjetoEjecutado) != BASE_ITEM_MAGICSTAFF))
    {
        return TRUE; // No hay tirada de UOM
    }


    // Fix para corregir los subconjuros que dependen de un conjuro maestro
    int iIDConjuro = GetSpellId();
    string sConjuroMaestro = Get2DAString("spells", "Master", iIDConjuro);
    if(sConjuroMaestro != "") iIDConjuro = StringToInt(sConjuroMaestro);

    // Declaramos variables del conjuro del pergamino
    int iEsferaConjuro          = StringToInt(Get2DAString("spells", "Innate", iIDConjuro));
    string sBardo               = Get2DAString("spells", "Bard",     iIDConjuro);
    string sClerigo             = Get2DAString("spells", "Cleric",   iIDConjuro);
    string sDruida              = Get2DAString("spells", "Druid",    iIDConjuro);
    string sPaladin             = Get2DAString("spells", "Paladin",  iIDConjuro);
    string sExplorador          = Get2DAString("spells", "Ranger",   iIDConjuro);
    string sMagoHechi           = Get2DAString("spells", "Wiz_Sorc", iIDConjuro);
    string sPaladinAntiguo      = Get2DAString("spells", "PaladinAntiguos",  iIDConjuro);
    string sPaladinOscuro       = Get2DAString("spells", "PaladinOscuro",  iIDConjuro);
    string sPaladinVengador     = Get2DAString("spells", "PaladinVengador",  iIDConjuro);
    int iBardo              = StringToInt(sBardo);     // <-- Nos indica que el perga ES de esta clase (aunque un perga puede tener varias clases)
    int iClerigo            = StringToInt(sClerigo);   //     Ademas nos indica la esfera del conjuro para esa clase
    int iDruida             = StringToInt(sDruida);
    int iPaladin            = StringToInt(sPaladin);
    int iExplorador         = StringToInt(sExplorador);
    int iMagoHechi          = StringToInt(sMagoHechi);
    int iPaladinAntiguo     = StringToInt(sPaladinAntiguo);
    int iPaladinOscuro      = StringToInt(sPaladinOscuro);
    int iPaladinVengador    = StringToInt(sPaladinVengador);

    // Debug:
    if(DEBUG)
    {
        SendMessageToPC(oPC, "Bardo " + sBardo);
        SendMessageToPC(oPC, "Clerigo " + sClerigo);
        SendMessageToPC(oPC, "Druida " + sDruida);
        SendMessageToPC(oPC, "Paladin " + sPaladin);
        SendMessageToPC(oPC, "Explorador " + sExplorador);
        SendMessageToPC(oPC, "Hechi/Mago " + sMagoHechi);
    }

    // Declaramos variables de tiradas posibles
    int iEmularClase     = TRUE;  // <-- 1. Si no somos de alguna clase del perga
    int iEmularNLanzador = TRUE;  // <-- 2. Si somos de alguna clase del perga pero no llegamos al nivel de lanzador
    int iEmularCaracteri = TRUE;  // <-- 3. Si no tenemos la caracteristica lanzadora suficiente
    int iObjetoArcano = TRUE;     // <-- Si es un perga arcano, tendra fallo de conjuro arcano
    int iNLanzadorFaltante = 100; // <- Ponemos de base que fallamos por 100 niveles de lanzador, asi el valor real siempre sera menor. Simple calculo para obtener la clase a tener en cuenta para emular nivel de lanzador
    int iDiferenciaNLanzador, iNivelLanzadorElegido, iClaseElegida;
    int iVaritas = FALSE;
    int iVeterano = 0;
    int iDG = GetHitDice(oPC);


    // Ajustes de varitas, cetros y bastones mágicos
    if(GetBaseItemType(oObjetoEjecutado) == BASE_ITEM_BLANK_WAND || GetBaseItemType(oObjetoEjecutado) == BASE_ITEM_ENCHANTED_WAND ||
        GetBaseItemType(oObjetoEjecutado) == BASE_ITEM_MAGICWAND  || GetBaseItemType(oObjetoEjecutado) == BASE_ITEM_MAGICROD       ||
        GetBaseItemType(oObjetoEjecutado) == BASE_ITEM_MAGICSTAFF)
    {
        iObjetoArcano = FALSE;
        iEmularNLanzador = FALSE;
        iEmularCaracteri = FALSE;
        iVaritas = TRUE;
    }

    // COMPROBACIONES GENERALES generales de clases, caracteristicas y nivel de lanzador
    // Conjuros de asesinos
    int iNivelAsesino = GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC);
    if(iNivelAsesino > 0)
    {
        if(iIDConjuro == 165 || iIDConjuro == 415 || iIDConjuro == 1138 || iIDConjuro == 1139 || iIDConjuro == 1127) // Nivel 1
        {
            iEmularClase = FALSE;

            if(iVaritas == FALSE)
            {
                iEmularNLanzador = FALSE;
                if(iEmularCaracteri == TRUE && GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) >= 11) iEmularCaracteri = FALSE;
            }
        }
        else if(iIDConjuro == 356 || iIDConjuro == 90 || iIDConjuro == 13 || iIDConjuro == 36 || iIDConjuro == 1100) // Nivel 2
        {
            iEmularClase = FALSE;

            if(iVaritas == FALSE)
            {
                if(iEmularCaracteri == TRUE && GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) >= 12) iEmularCaracteri = FALSE;
                if(iEmularNLanzador == TRUE)
                {
                    iDiferenciaNLanzador = 3 - iNivelAsesino;
                    if(GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC) >= 3) iEmularNLanzador = FALSE;
                    else if(iDiferenciaNLanzador < iNLanzadorFaltante) {iNLanzadorFaltante = iDiferenciaNLanzador; iClaseElegida = CLASS_TYPE_ASSASSIN; iNivelLanzadorElegido = iNivelAsesino;}
                }
            }
        }
        else if(iIDConjuro == 105 || iIDConjuro == 1136 || iIDConjuro == 1137 || iIDConjuro == 15 || iIDConjuro == 998) // Nivel 3
        {
            iEmularClase = FALSE;

            if(iVaritas == FALSE)
            {
                if(iEmularCaracteri == TRUE && GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) >= 13) iEmularCaracteri = FALSE;
                if(iEmularNLanzador == TRUE)
                {
                    iDiferenciaNLanzador = 5 - iNivelAsesino;
                    if(GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC) >= 5) iEmularNLanzador = FALSE;
                    else if(iDiferenciaNLanzador < iNLanzadorFaltante) {iNLanzadorFaltante = iDiferenciaNLanzador; iClaseElegida = CLASS_TYPE_ASSASSIN; iNivelLanzadorElegido = iNivelAsesino;}
                }
            }
        }
        else if(iIDConjuro == 20 || iIDConjuro == 88 || iIDConjuro == 62 || iIDConjuro == 129 || iIDConjuro == 1129) // Nivel 4
        {
            iEmularClase = FALSE;

            if(iVaritas == FALSE)
            {
                if(iEmularCaracteri == TRUE && GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) >= 14) iEmularCaracteri = FALSE;
                if(iEmularNLanzador == TRUE)
                {
                    iDiferenciaNLanzador = 7 - iNivelAsesino;
                    if(GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC) >= 7) iEmularNLanzador = FALSE;
                    else if(iDiferenciaNLanzador < iNLanzadorFaltante) {iNLanzadorFaltante = iDiferenciaNLanzador; iClaseElegida = CLASS_TYPE_ASSASSIN; iNivelLanzadorElegido = iNivelAsesino;}
                }
            }
        }
    }
    // Conjuros de Soldado de la luz
    int iNivelSoldado = GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT, oPC);
    if(iNivelSoldado > 0)
    {
        if(iIDConjuro == 1163 || iIDConjuro == 1164 || iIDConjuro == 1165 || iIDConjuro == 1166 ) // Nivel 1
        {
            iEmularClase = FALSE;

            if(iVaritas == FALSE)
            {
                iEmularNLanzador = FALSE;
                if(iEmularCaracteri == TRUE && GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) >= 11) iEmularCaracteri = FALSE;
            }
        }
        else if(iIDConjuro == 1168 || iIDConjuro == 1169 || iIDConjuro == 1170 || iIDConjuro == 1 ) // Nivel 2
        {
            iEmularClase = FALSE;

            if(iVaritas == FALSE)
            {
                if(iEmularCaracteri == TRUE && GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) >= 12) iEmularCaracteri = FALSE;
                if(iEmularNLanzador == TRUE)
                {
                    iDiferenciaNLanzador = 3 - iNivelSoldado;
                    if(GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT, oPC) >= 3) iEmularNLanzador = FALSE;
                    else if(iDiferenciaNLanzador < iNLanzadorFaltante) {iNLanzadorFaltante = iDiferenciaNLanzador; iClaseElegida = CLASS_TYPE_SOLDIER_OF_LIGHT; iNivelLanzadorElegido = iNivelSoldado;}
                }
            }
        }
        else if(iIDConjuro == 1172 || iIDConjuro == 1173 || iIDConjuro == 1174 || iIDConjuro == 1175 ) // Nivel 3
        {
            iEmularClase = FALSE;

            if(iVaritas == FALSE)
            {
                if(iEmularCaracteri == TRUE && GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) >= 13) iEmularCaracteri = FALSE;
                if(iEmularNLanzador == TRUE)
                {
                    iDiferenciaNLanzador = 5 - iNivelSoldado;
                    if(GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT, oPC) >= 5) iEmularNLanzador = FALSE;
                    else if(iDiferenciaNLanzador < iNLanzadorFaltante) {iNLanzadorFaltante = iDiferenciaNLanzador; iClaseElegida = CLASS_TYPE_SOLDIER_OF_LIGHT; iNivelLanzadorElegido = iNivelSoldado;}
                }
            }
        }
        else if(iIDConjuro == 1177 || iIDConjuro == 1178 || iIDConjuro == 1179 || iIDConjuro == 1180 ) // Nivel 4
        {
            iEmularClase = FALSE;

            if(iVaritas == FALSE)
            {
                if(iEmularCaracteri == TRUE && GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) >= 14) iEmularCaracteri = FALSE;
                if(iEmularNLanzador == TRUE)
                {
                    iDiferenciaNLanzador = 7 - iNivelSoldado;
                    if(GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT, oPC) >= 7) iEmularNLanzador = FALSE;
                    else if(iDiferenciaNLanzador < iNLanzadorFaltante) {iNLanzadorFaltante = iDiferenciaNLanzador; iClaseElegida = CLASS_TYPE_SOLDIER_OF_LIGHT; iNivelLanzadorElegido = iNivelSoldado;}
                }
            }
        }
    }
    // Conjuros de guardias negros
    int iNivelGuardiaNegro = GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC);
    if(iNivelGuardiaNegro > 0)
    {
        iObjetoArcano = FALSE;

        if(iIDConjuro == 54 || iIDConjuro == 32 || iIDConjuro == 432 || iIDConjuro == 174 || iIDConjuro == 999) // Nivel 1
        {
            iEmularClase = FALSE;

            if(iVaritas == FALSE)
            {
                iEmularNLanzador = FALSE;
                if(iEmularCaracteri == TRUE && GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) >= 11) iEmularCaracteri = FALSE;
            }
        }
        else if(iIDConjuro == 36 || iIDConjuro == 34 || iIDConjuro == 433 || iIDConjuro == 175 || iIDConjuro == 9) // Nivel 2
        {
            iEmularClase = FALSE;

            if(iVaritas == FALSE)
            {
                if(iEmularCaracteri == TRUE && GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) >= 12) iEmularCaracteri = FALSE;
                if(iEmularNLanzador == TRUE)
                {
                    iDiferenciaNLanzador = 3 - iNivelGuardiaNegro;
                    if(GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC) >= 3) iEmularNLanzador = FALSE;
                    else if(iDiferenciaNLanzador < iNLanzadorFaltante) {iNLanzadorFaltante = iDiferenciaNLanzador; iClaseElegida = CLASS_TYPE_BLACKGUARD; iNivelLanzadorElegido = iNivelGuardiaNegro;}
                }
            }
        }
        else if(iIDConjuro == 35 || iIDConjuro == 434 || iIDConjuro == 176 || iIDConjuro == 137 || iIDConjuro == 27) // Nivel 3
        {
            iEmularClase = FALSE;

            if(iVaritas == FALSE)
            {
                if(iEmularCaracteri == TRUE && GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) >= 13) iEmularCaracteri = FALSE;
                if(iEmularNLanzador == TRUE)
                {
                    iDiferenciaNLanzador = 5 - iNivelGuardiaNegro;
                    if(GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC) >= 5) iEmularNLanzador = FALSE;
                    else if(iDiferenciaNLanzador < iNLanzadorFaltante) {iNLanzadorFaltante = iDiferenciaNLanzador; iClaseElegida = CLASS_TYPE_BLACKGUARD; iNivelLanzadorElegido = iNivelGuardiaNegro;}
                }
            }
        }
        else if(iIDConjuro == 31 || iIDConjuro == 435 || iIDConjuro == 177 || iIDConjuro == 62  || iIDConjuro == 129) // Nivel 4
        {
            iEmularClase = FALSE;

            if(iVaritas == FALSE)
            {
                if(iEmularCaracteri == TRUE && GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) >= 14) iEmularCaracteri = FALSE;
                if(iEmularNLanzador == TRUE)
                {
                    iDiferenciaNLanzador = 7 - iNivelGuardiaNegro;
                    if(GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC) >= 7) iEmularNLanzador = FALSE;
                    else if(iDiferenciaNLanzador < iNLanzadorFaltante) {iNLanzadorFaltante = iDiferenciaNLanzador; iClaseElegida = CLASS_TYPE_BLACKGUARD; iNivelLanzadorElegido = iNivelGuardiaNegro;}
                }
            }
        }
    }
    // Conjuros de bardos
    if (sBardo != "")
    {
        int iNivelBardo = GetLevelByClass(CLASS_TYPE_BARD, oPC);
        if (iNivelBardo > 0)
        {
            if(GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC) > 0) iNivelBardo += GetSpecialCasterLevel(CLASS_TYPE_PALEMASTER, oPC);
            if(GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO, oPC) > 0) iNivelBardo += GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO, oPC);
            if(GetLevelByClass(CLASS_TYPE_CABALLERO_ARCANO, oPC) > 0) iNivelBardo += GetSpecialCasterLevel(CLASS_TYPE_CABALLERO_ARCANO, oPC);
            iEmularClase = FALSE;
        }

        if (iVaritas == FALSE)
        {
            if (iEmularCaracteri == TRUE && GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE) >= 10 + iBardo) iEmularCaracteri = FALSE;
            if (iEmularNLanzador == TRUE)
            {
                iDiferenciaNLanzador = ObtenerNivelMinimoPerga(CLASS_TYPE_BARD, iEsferaConjuro) - iNivelBardo;
                if (iDiferenciaNLanzador <= 0) iEmularNLanzador = FALSE;
                else if (iDiferenciaNLanzador < iNLanzadorFaltante) {iNLanzadorFaltante = iDiferenciaNLanzador; iClaseElegida = CLASS_TYPE_BARD; iNivelLanzadorElegido = iNivelBardo;}
            }
        }
    }
    int iNivelClerigo = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
    int iNivelAlmaPredilecta = GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oPC);
    int iNivelDivino = iNivelClerigo + iNivelAlmaPredilecta;
    if (sClerigo != "")
    {
        // Conjuros de clérigo & alma predilecta
        int nChosenDivineClass = iNivelClerigo ? CLASS_TYPE_CLERIC : CLASS_TYPE_FAVORED_SOUL;

        if (iNivelClerigo || iNivelAlmaPredilecta)
        {
            if (GetLevelByClass(CLASS_TYPE_TEURGO_MIST, oPC) > 0) iNivelDivino += GetSpecialCasterLevel(CLASS_TYPE_TEURGO_MIST, oPC);
            if (GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT_DIVINE, oPC) > 0) iNivelDivino += GetSpecialCasterLevel(CLASS_TYPE_SHADOW_ADEPT_DIVINE, oPC);
            if (GetLevelByClass(CLASS_TYPE_HARPER_DIVINE, oPC) > 0) iNivelDivino += GetSpecialCasterLevel(CLASS_TYPE_HARPER_DIVINE, oPC);
            iEmularClase = FALSE;
            iObjetoArcano = FALSE;
        }

        if (iVaritas == FALSE)
        {
            if ((iEmularCaracteri == TRUE && GetAbilityScore(oPC, iNivelClerigo ? ABILITY_WISDOM : ABILITY_CHARISMA, TRUE) >= 10 + iClerigo)) iEmularCaracteri = FALSE;
            if (iEmularNLanzador == TRUE)
            {
                iDiferenciaNLanzador = ObtenerNivelMinimoPerga(nChosenDivineClass, iEsferaConjuro) - iNivelDivino;
                if (iDiferenciaNLanzador <= 0) iEmularNLanzador = FALSE;
                else if (iDiferenciaNLanzador < iNLanzadorFaltante) { iNLanzadorFaltante = iDiferenciaNLanzador; iClaseElegida = nChosenDivineClass; iNivelLanzadorElegido = iNivelDivino; }
            }
        }
    }
    // Conjuros de druidas
    if (sDruida != "")
    {
        int iNivelDruida = GetLevelByClass(CLASS_TYPE_DRUID, oPC) + GetLevelByClass(51, oPC);
        if (iNivelDruida > 0) {
            iEmularClase = FALSE;
            iObjetoArcano = FALSE;
        }

        if (iVaritas == FALSE)
        {
            if (iEmularCaracteri == TRUE && GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) >= 10 + iDruida) iEmularCaracteri = FALSE;
            if (iEmularNLanzador == TRUE)
            {
                iDiferenciaNLanzador = ObtenerNivelMinimoPerga(CLASS_TYPE_DRUID, iEsferaConjuro) - iNivelDruida;
                if (iDiferenciaNLanzador <= 0) iEmularNLanzador = FALSE;
                else if (iDiferenciaNLanzador < iNLanzadorFaltante) {iNLanzadorFaltante = iDiferenciaNLanzador; iClaseElegida = CLASS_TYPE_DRUID; iNivelLanzadorElegido = iNivelDruida;}
            }
        }
    }
    // Conjuros de paladines
    if (sPaladin != "")
    {
        int iNivelPaladin = GetLevelByClass(CLASS_TYPE_PALADIN, oPC);
        if (iNivelPaladin > 0) {
            iEmularClase = FALSE;
            iObjetoArcano = FALSE;
        }

        if (iVaritas == FALSE)
        {
            if (iEmularCaracteri == TRUE && GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) >= 10 + iPaladin) iEmularCaracteri = FALSE;
            if (iEmularNLanzador == TRUE)
            {
                iDiferenciaNLanzador = ObtenerNivelMinimoPerga(CLASS_TYPE_PALADIN, iEsferaConjuro) - iNivelPaladin;
                if (iDiferenciaNLanzador <= 0) iEmularNLanzador = FALSE;
                else if (iDiferenciaNLanzador < iNLanzadorFaltante) {iNLanzadorFaltante = iDiferenciaNLanzador; iClaseElegida = CLASS_TYPE_PALADIN; iNivelLanzadorElegido = iNivelPaladin;}
            }
        }
    }
    // Conjuros de paladines antiguos
    if (sPaladinAntiguo != "")
    {
        int iNivelPaladin = GetLevelByClass(CLASS_TYPE_PAL_ANTIGUO, oPC);
        if (iNivelPaladin > 0) {
            iEmularClase = FALSE;
            iObjetoArcano = FALSE;
        }

        if (iVaritas == FALSE)
        {
            if (iEmularCaracteri == TRUE && GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) >= 10 + iPaladin) iEmularCaracteri = FALSE;
            if (iEmularNLanzador == TRUE)
            {
                iDiferenciaNLanzador = ObtenerNivelMinimoPerga(CLASS_TYPE_PAL_ANTIGUO, iEsferaConjuro) - iNivelPaladin;
                if (iDiferenciaNLanzador <= 0) iEmularNLanzador = FALSE;
                else if (iDiferenciaNLanzador < iNLanzadorFaltante) {iNLanzadorFaltante = iDiferenciaNLanzador; iClaseElegida = CLASS_TYPE_PAL_ANTIGUO; iNivelLanzadorElegido = iNivelPaladin;}
            }
        }
    }
    // Conjuros de paladines oscuros
    if (sPaladinOscuro != "")
    {
        int iNivelPaladin = GetLevelByClass(CLASS_TYPE_PAL_OSCURO, oPC);
        if (iNivelPaladin > 0) {
            iEmularClase = FALSE;
            iObjetoArcano = FALSE;
        }

        if (iVaritas == FALSE)
        {
            if (iEmularCaracteri == TRUE && GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) >= 10 + iPaladin) iEmularCaracteri = FALSE;
            if (iEmularNLanzador == TRUE)
            {
                iDiferenciaNLanzador = ObtenerNivelMinimoPerga(CLASS_TYPE_PALADIN, iEsferaConjuro) - iNivelPaladin;
                if (iDiferenciaNLanzador <= 0) iEmularNLanzador = FALSE;
                else if (iDiferenciaNLanzador < iNLanzadorFaltante) {iNLanzadorFaltante = iDiferenciaNLanzador; iClaseElegida = CLASS_TYPE_PAL_OSCURO; iNivelLanzadorElegido = iNivelPaladin;}
            }
        }
    }
    // Conjuros de paladines vengadores
    if (sPaladinVengador != "")
    {
        int iNivelPaladin = GetLevelByClass(CLASS_TYPE_PAL_VENGADOR, oPC);
        if (iNivelPaladin > 0) {
            iEmularClase = FALSE;
            iObjetoArcano = FALSE;
        }

        if (iVaritas == FALSE)
        {
            if (iEmularCaracteri == TRUE && GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) >= 10 + iPaladin) iEmularCaracteri = FALSE;
            if (iEmularNLanzador == TRUE)
            {
                iDiferenciaNLanzador = ObtenerNivelMinimoPerga(CLASS_TYPE_PAL_VENGADOR, iEsferaConjuro) - iNivelPaladin;
                if (iDiferenciaNLanzador <= 0) iEmularNLanzador = FALSE;
                else if (iDiferenciaNLanzador < iNLanzadorFaltante) {iNLanzadorFaltante = iDiferenciaNLanzador; iClaseElegida = CLASS_TYPE_PAL_VENGADOR; iNivelLanzadorElegido = iNivelPaladin;}
            }
        }
    }
    // Conjuros de exploradores
    if (sExplorador != "")
    {
        int iNivelExplorador = GetLevelByClass(CLASS_TYPE_RANGER, oPC);
        if (iNivelExplorador > 0) {
            iEmularClase = FALSE;
            iObjetoArcano = FALSE;
        }

        if (iVaritas == FALSE)
        {
            if (iEmularCaracteri == TRUE && GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) >= 10 + iExplorador) iEmularCaracteri = FALSE;
            if (iEmularNLanzador == TRUE)
            {
                iDiferenciaNLanzador = ObtenerNivelMinimoPerga(CLASS_TYPE_RANGER, iEsferaConjuro) - iNivelExplorador;
                if (iDiferenciaNLanzador <= 0) iEmularNLanzador = FALSE;
                else if (iDiferenciaNLanzador < iNLanzadorFaltante) {iNLanzadorFaltante = iDiferenciaNLanzador; iClaseElegida = CLASS_TYPE_RANGER; iNivelLanzadorElegido = iNivelExplorador;}
            }
        }
    }
    // Conjuros de magos y hechiceros
    if (sMagoHechi != "")
    {
        int iNivelMago = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
        //Si tiene la dote Lanzador de conjuros veterano
        if (GetHasFeat(1369, oPC))
        {
            iNivelMago +=4;

            if(iNivelMago > iDG)
            {
                iNivelMago = iDG;
            }
        }
        if(iNivelMago > 0)
        {
            if(GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC) > 0) iNivelMago += GetSpecialCasterLevel(CLASS_TYPE_PALEMASTER, oPC);
            if(GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO, oPC) > 0) iNivelMago += GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO, oPC);
            if(GetLevelByClass(CLASS_TYPE_CABALLERO_ARCANO, oPC) > 0) iNivelMago += GetSpecialCasterLevel(CLASS_TYPE_CABALLERO_ARCANO, oPC);
            if(GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oPC) > 0) iNivelMago += GetSpecialCasterLevel(CLASS_TYPE_SHADOW_ADEPT, oPC);
            if(GetLevelByClass(CLASS_TYPE_ARCHMAGE, oPC) > 0) iNivelMago += GetSpecialCasterLevel(CLASS_TYPE_ARCHMAGE, oPC);
            if(GetLevelByClass(CLASS_TYPE_HARPER, oPC) > 0) iNivelMago += GetSpecialCasterLevel(CLASS_TYPE_HARPER, oPC);
            iEmularClase = FALSE;
        }
        int iNivelHechicero = GetLevelByClass(CLASS_TYPE_SORCERER, oPC);
        if(iNivelHechicero > 0)
        {
            if(GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC) > 0) iNivelHechicero += GetSpecialCasterLevel(CLASS_TYPE_PALEMASTER, oPC);
            if(GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO, oPC) > 0) iNivelHechicero += GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO, oPC);
            if(GetLevelByClass(CLASS_TYPE_CABALLERO_ARCANO, oPC) > 0) iNivelHechicero += GetSpecialCasterLevel(CLASS_TYPE_CABALLERO_ARCANO, oPC);
            if(GetLevelByClass(CLASS_TYPE_ARCHMAGE, oPC) > 0) iNivelMago += GetSpecialCasterLevel(CLASS_TYPE_ARCHMAGE, oPC);
            if(GetLevelByClass(CLASS_TYPE_HARPER, oPC) > 0) iNivelMago += GetSpecialCasterLevel(CLASS_TYPE_HARPER, oPC);
            iEmularClase = FALSE;
        }
        int iNivelArtifice = GetLevelByClass(CLASS_TYPE_INGENIERO, oPC);
        if(iNivelArtifice > 0)
        {
            if(GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC) > 0) iNivelArtifice += GetSpecialCasterLevel(CLASS_TYPE_PALEMASTER, oPC);
            if(GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO, oPC) > 0) iNivelArtifice += GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO, oPC);
            if(GetLevelByClass(CLASS_TYPE_CABALLERO_ARCANO, oPC) > 0) iNivelArtifice += GetSpecialCasterLevel(CLASS_TYPE_CABALLERO_ARCANO, oPC);
            if(GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oPC) > 0) iNivelArtifice += GetSpecialCasterLevel(CLASS_TYPE_SHADOW_ADEPT, oPC);
            if(GetLevelByClass(CLASS_TYPE_ARCHMAGE, oPC) > 0) iNivelArtifice += GetSpecialCasterLevel(CLASS_TYPE_ARCHMAGE, oPC);
            if(GetLevelByClass(CLASS_TYPE_HARPER, oPC) > 0) iNivelArtifice += GetSpecialCasterLevel(CLASS_TYPE_HARPER, oPC);
            iEmularClase = FALSE;
        }

        if(iVaritas == FALSE)
        {
            int iInteligencia = GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE);
            int iCarisma = GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE);
            int iPuntCaracArcanaElegida = iInteligencia;
            int iNivelArcanoElegido = iNivelMago;
            int iClaseArcanaElegida = CLASS_TYPE_WIZARD;
            if(iCarisma > iInteligencia) iPuntCaracArcanaElegida = iCarisma;
            if(iNivelHechicero > ( iNivelMago && iNivelArtifice)) { iNivelArcanoElegido = iNivelHechicero; iClaseArcanaElegida = CLASS_TYPE_SORCERER; }
            if(iNivelArtifice > ( iNivelMago && iNivelHechicero)) { iNivelArcanoElegido = iNivelArtifice; iClaseArcanaElegida = CLASS_TYPE_INGENIERO; }

            if(iEmularCaracteri == TRUE && iPuntCaracArcanaElegida >= 10 + iMagoHechi) iEmularCaracteri = FALSE;
            if(iEmularNLanzador == TRUE)
            {
                iDiferenciaNLanzador = ObtenerNivelMinimoPerga(iClaseArcanaElegida, iEsferaConjuro) - iNivelArcanoElegido;
                if(iDiferenciaNLanzador <= 0) iEmularNLanzador = FALSE;
                else if(iDiferenciaNLanzador < iNLanzadorFaltante) {iNLanzadorFaltante = iDiferenciaNLanzador; iClaseElegida = iClaseArcanaElegida; iNivelLanzadorElegido = iNivelArcanoElegido;}
            }
        }
    }
    // Apaño para los conjuros de dominio de clerigo
    if (iNivelClerigo)
    {
        if (VerSiEsConjuroDeDominio(oPC, iIDConjuro))
        {
            iEmularClase = FALSE;
            iObjetoArcano = FALSE;

            if(iEmularNLanzador)
            {
                iNivelLanzadorElegido = GetTotalCasterLevel(oPC,CLASS_TYPE_CLERIC);
                iDiferenciaNLanzador = ObtenerNivelMinimoPerga(CLASS_TYPE_CLERIC, iEsferaConjuro - 1) - iNivelLanzadorElegido;
                if(iDiferenciaNLanzador <= 0) iEmularNLanzador = FALSE;
                else if(iDiferenciaNLanzador < iNLanzadorFaltante) {iNLanzadorFaltante = iDiferenciaNLanzador; iClaseElegida = CLASS_TYPE_CLERIC; }
            }

            if(iEmularCaracteri && GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) >= 10 + iEsferaConjuro) iEmularCaracteri = FALSE;
            else if(GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) < 10 + iEsferaConjuro) iEmularCaracteri = TRUE;
        }
    }
    // Pergas con fallo de conjuro arcano, descartamos los arcanos y los que solo tienen componente verbal
    if(iVaritas == FALSE && (iObjetoArcano == TRUE || iEmularClase == TRUE) && Get2DAString("spells", "VS", iIDConjuro) != "v")
    {
        if(d100() <= GetArcaneSpellFailure(oPC))
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(77), oPC);
            SendMessageToPC(oPC, "<cÂ>¡Fallo de conjuro!</c>");
            return FALSE;
        }
    }

    // Debug:
    if(DEBUG == TRUE)
    {
        SendMessageToPC(oPC, "Emular clase " + IntToString(iEmularClase));
        SendMessageToPC(oPC, "Emular lanzador " + IntToString(iEmularNLanzador));
        SendMessageToPC(oPC, "Emular caracteristica " + IntToString(iEmularCaracteri));

    }

    // No hay tirada de UOM porque el ejecutor cumple todos los requisitos
    if(iEmularClase == FALSE && iEmularNLanzador == FALSE && iEmularCaracteri == FALSE) return TRUE;

    // TIRADAS
    int iUsarObjetoMagicoRangos = GetSkillRank(SKILL_USE_MAGIC_DEVICE, oPC, TRUE);
    int iUsarObjetoMagico = GetSkillRank(SKILL_USE_MAGIC_DEVICE, oPC);
    int iSinergiaCCon = 0;
    int iSinergiaDEsc = 0;
    if(GetSkillRank(16, oPC, TRUE) / 5 >= 1) iSinergiaCCon = 2;
    if(GetSkillRank(29, oPC, TRUE) / 5 >= 1) iSinergiaDEsc = 2;
    int iBonoExitoUom = GetLocalInt(oPC, "BONO_EXITO_UOM");
    int iTirada, iCD, iResultadoTirada,iCDLanzador,iBonoUOM,iBonoNivelLanzador;

    //Pequeño calculo por si es mas facil pasar la tirada con UOM que emulando nivel de lanzador.
    if(iEmularClase == FALSE)
    {
        if (iVaritas == TRUE) iCD = 20;
        else iCD = 20 + ObtenerNivelMinimoPerga(CLASS_TYPE_WIZARD, iEsferaConjuro);

        iCDLanzador = ObtenerNivelMinimoPerga(iClaseElegida, iEsferaConjuro) + 1;
        iBonoUOM = iUsarObjetoMagico + iSinergiaCCon + iSinergiaDEsc + iBonoExitoUom;
        iBonoNivelLanzador = iNivelLanzadorElegido;

        int iDifUOM = iCD - iBonoUOM;
        int iDifLanzador = iCDLanzador - iBonoNivelLanzador;
        if(iDifUOM < iDifLanzador) iEmularClase = TRUE;

    }
    // 1. Tirada: Emular la clase (o la 1 o la 2, pero nunca las dos)
    if (iEmularClase)
    {
        if (iUsarObjetoMagicoRangos == 0)
        {
            SendMessageToPC(oPC, "<c›þþ>" + GetName(oPC) + "</c> <cþ–2>realiza una prueba de 'Usar objeto mágico' para emular clase: *fracaso automático*: habilidad no entrenada.</c>");
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE), oPC);
            return FALSE;
        }

        iTirada = d20() + iUsarObjetoMagico + iSinergiaCCon + iSinergiaDEsc + iBonoExitoUom;
        if (iVaritas == TRUE) iCD = 20;
        else iCD = 20 + ObtenerNivelMinimoPerga(CLASS_TYPE_WIZARD, iEsferaConjuro);
        iResultadoTirada = iTirada - iCD;

        if (iResultadoTirada >= 0)
        {
            SendMessageToPC(oPC, "<c›þþ>" + GetName(oPC) + "</c> <cþ–2>realiza una prueba de 'Usar objeto mágico' para emular clase: *éxito*: "+IntToString(iTirada)+" contra CD "+IntToString(iCD)+"</c>");
            if (GetLocalInt(oPC, "BONO_EXITO_UOM") == 0) SetLocalInt(oPC, "BONO_EXITO_UOM", 2);
        }
        else
        {
            SendMessageToPC(oPC, "<c›þþ>" + GetName(oPC) + "</c> <cþ–2>realiza una prueba de 'Usar objeto mágico' para emular clase: *fracaso*: "+IntToString(iTirada)+" contra CD "+IntToString(iCD)+"</c>");
            DeleteLocalInt(oPC, "BONO_EXITO_UOM");
            if (iResultadoTirada <= -10) FracasoEspectacular(oPC);
            else ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE), oPC);
            return FALSE;
        }
    }
    else
    {
        // 2. Tirada: Emular nivel de lanzador
        if (iEmularNLanzador)
        {
            iTirada = d20() + iNivelLanzadorElegido;
            iCD = ObtenerNivelMinimoPerga(iClaseElegida, iEsferaConjuro) + 1;
            iResultadoTirada = iTirada - iCD;

            if (iResultadoTirada >= 0)
            {
                SendMessageToPC(oPC, "<c›þþ>" + GetName(oPC) + "</c> <cþ–2>realiza una prueba para emular nivel de lanzador: *éxito*: "+IntToString(iTirada)+" contra CD "+IntToString(iCD)+"</c>");
            }
            else
            {
                SendMessageToPC(oPC, "<c›þþ>" + GetName(oPC) + "</c> <cþ–2>realiza una prueba para emular nivel de lanzador: *fracaso*: "+IntToString(iTirada)+" contra CD "+IntToString(iCD)+"</c>");
                iTirada = d20() + GetAbilityScore(oPC, ABILITY_WISDOM);
                iCD = 5;
                iResultadoTirada = iTirada - iCD;
                if (iResultadoTirada < 0)
                {
                    SendMessageToPC(oPC, "<c›þþ>" + GetName(oPC) + "</c> <cþ–2>realiza una tirada de Sabiduría: *fracaso*: "+IntToString(iTirada)+" contra CD 5</c>");
                    FracasoEspectacular(oPC);
                }
                else
                {
                    SendMessageToPC(oPC, "<c›þþ>" + GetName(oPC) + "</c> <cþ–2>realiza una tirada de Sabiduría: *éxito*: "+IntToString(iTirada)+" contra CD 5</c>");
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE), oPC);
                }
                return FALSE;
            }
        }
    }

    // 3. Tirada: Emular caracteristica
    if (iEmularCaracteri)
    {
        if (iUsarObjetoMagicoRangos == 0)
        {
            SendMessageToPC(oPC, "<c›þþ>" + GetName(oPC) + "</c> <cþ–2>realiza una prueba de 'Usar objeto mágico' para emular caractersística: *fracaso automático*: habilidad no entrenada.</c>");
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE), oPC);
            return FALSE;
        }

        iTirada = d20() + iUsarObjetoMagico + iSinergiaCCon + iSinergiaDEsc + iBonoExitoUom;
        iCD = 25 + iEsferaConjuro;
        iResultadoTirada = iTirada - iCD;

        if (iResultadoTirada >= 0)
        {
            SendMessageToPC(oPC, "<c›þþ>" + GetName(oPC) + "</c> <cþ–2>realiza una prueba de 'Usar objeto mágico' para emular caractersística: *éxito*: "+IntToString(iTirada)+" contra CD "+IntToString(iCD)+"</c>");
            if(GetLocalInt(oPC, "BONO_EXITO_UOM") == 0) SetLocalInt(oPC, "BONO_EXITO_UOM", 2);
        }
        else
        {
            SendMessageToPC(oPC, "<c›þþ>" + GetName(oPC) + "</c> <cþ–2>realiza una prueba de 'Usar objeto mágico' para emular caractersística: *fracaso*: "+IntToString(iTirada)+" contra CD "+IntToString(iCD)+"</c>");
            DeleteLocalInt(oPC, "BONO_EXITO_UOM");
            if(iResultadoTirada <= -10) FracasoEspectacular(oPC);
            else ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE), oPC);
            return FALSE;
        }
    }
    // Hemos pasado las tiradas y todo ha salido bien
    return TRUE;
}

void main()
{
    SetExecutedScriptReturnValue(UsarObjetoMagicoPergas());
}
