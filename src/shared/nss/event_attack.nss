#include "nwnx_damage"
#include "mti_libreria"
#include "x0_i0_spells"
#include "pb_constantes"

int GetCriticalMultiplier(object oWeapon, int iAttackType);

void main()
{
    struct NWNX_Damage_AttackEventData data;

    // Get all the data of the damage event
    data = NWNX_Damage_GetAttackEventData();

    object oDamager = OBJECT_SELF; // The damager
    object oTarget = data.oTarget;
    int iAttackResult = data.iAttackResult;
    int iHandUse = data.iWeaponAttackType;

    //Chequeamos el arma equipada para calcular el modificador de critico.
    object oArmaEquipada = GetItemInSlot(data.iAttackType == 2 ? INVENTORY_SLOT_LEFTHAND : INVENTORY_SLOT_RIGHTHAND, oDamager);
    int iCriticoMod = GetCriticalMultiplier(oArmaEquipada, data.iWeaponAttackType);
    if(GetHasFeat(FEAT_INCREASE_MULTIPLIER, oDamager)) iCriticoMod + 1;

    //Actualización 28/09/2024: Leemos modificador de características para las dotes.
    int iInteligencia = GetAbilityModifier(ABILITY_INTELLIGENCE, oDamager);
    int eDex = GetAbilityModifier(ABILITY_DEXTERITY, oDamager);

    //Actualización 28/09/2024: Miramos si el arma de la mano usada es sutil.
    //Miramos cual es la última arma usada
    object oArma;
    //Comprobamos el arma, según la mano que se use para atacar.
    if(iHandUse == 1) oArma = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oDamager);
    else if(iHandUse == 2) oArma = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oDamager);
    //Miramos el tipo de arma.
    int iTipoArmaEquipada = GetBaseItemType(oArma);
    int iTamanyoArmaEquipada = StringToInt(Get2DAString("baseitems", "WeaponSize", iTipoArmaEquipada));
    int iEstoque = StringToInt(Get2DAString("baseitems", "Name", iTipoArmaEquipada));

    /*// Let send the damage amounts and types to the Damager
    SendMessageToPC(oDamager, "iBludgeoning: " + IntToString(data.iBludgeoning));
    SendMessageToPC(oDamager, "iPierce: " + IntToString(data.iPierce));
    SendMessageToPC(oDamager, "iSlash: " + IntToString(data.iSlash));
    SendMessageToPC(oDamager, "iMagical: " + IntToString(data.iMagical));
    SendMessageToPC(oDamager, "iAcid: " + IntToString(data.iAcid));
    SendMessageToPC(oDamager, "iCold: " + IntToString(data.iCold));
    SendMessageToPC(oDamager, "iDivine: " + IntToString(data.iDivine));
    SendMessageToPC(oDamager, "iElectrical: " + IntToString(data.iElectrical));
    SendMessageToPC(oDamager, "iFire: " + IntToString(data.iFire));
    SendMessageToPC(oDamager, "iNegative: " + IntToString(data.iNegative));
    SendMessageToPC(oDamager, "iPositive: " + IntToString(data.iPositive));
    SendMessageToPC(oDamager, "iSonic: " + IntToString(data.iSonic));
    SendMessageToPC(oDamager, "iBase: " + IntToString(data.iBase));
    SendMessageToPC(oDamager, "iAttackResult: " + IntToString(data.iAttackResult));
    SendMessageToPC(oDamager, "iWeaponAttackType: " + IntToString(data.iWeaponAttackType));
    SendMessageToPC(oDamager, "iCriticoMod: " + IntToString(iCriticoMod));
    */

    //Dote Puños de Hierro
    if(GetHasFeat(1520, oDamager) && data.iWeaponAttackType == 7)
    {
        object oEmptySlot = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oDamager);
        object oEmptySlot2 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oDamager);

        if(oEmptySlot == OBJECT_INVALID && oEmptySlot2 == OBJECT_INVALID)
        {
            int dado = d6(1);
            if(iAttackResult == 3) dado = dado*iCriticoMod;

            data.iBase = data.iBase + dado;
        }
    }

    // //Improved Crossbow Sniper //Dote Crossbow Sniper // ANULADO POR KRONOS, PREGUNTAR!
    // if(GetHasFeat(1522, oDamager ) && GetLocalInt(oDamager, "DOTE_FRANCOTIRADOR") == 2)
    // {
    //     int eDex = GetAbilityModifier(ABILITY_DEXTERITY, oDamager);
    //     if(iAttackResult == 3) eDex = eDex*iCriticoMod;

    //     data.iBase = data.iBase + eDex;
    // }

    //Dote Crossbow Sniper
    // else
    if(GetHasFeat(1521, oDamager) && GetLocalInt(oDamager, "DOTE_FRANCOTIRADOR") == 1)
    {
        int eDex = GetAbilityModifier(ABILITY_DEXTERITY, oDamager);
        if(iAttackResult == 3) eDex = eDex*iCriticoMod;

        data.iBase = data.iBase + eDex/2;
    }

    //Bonificador Daño Espadachin **Impacto Aguzado
    //Actualización 28/09/2024: El impacto a partir del 12, añade la mitad del bono de destreza, además se hace un fix que cuando tienes duales y te desequipas una de las armas, se pierda el bono. Además el daño por las dotes de los críticos se aplican aquí directamente.
    if(GetLevelByClass(58, oDamager) >= 3)
    {
        //Bonificador Daño Espadachin **Impacto Aguzado
        object oArmadura = GetItemInSlot(INVENTORY_SLOT_CHEST, oDamager);
        int iTipoArmadura = GetArmorType(oDamager);

        //El arma que portamos existe y no llevamos armaduras no ligeras.
        if(oArmaEquipada != OBJECT_INVALID  && iTipoArmadura <= 3 )
        {
            //Si el arma es pequeña, no es de distancia o es un estoque, aplicamos.
            if(iTamanyoArmaEquipada <= 2 && !GetWeaponRanged(oArmaEquipada) || (iEstoque == 1545 || iEstoque == 1535 || iEstoque == 1544 || iEstoque == 16807275 || iEstoque == 172 || iEstoque == 16827327 || iEstoque ==1547)) //Solo si tiene arma ligera o estoque/katana/bastón/cimitarradoble/espadadoble/lanzalarga y no es a distancia
            {
                //Daño normal, solo el daño de la int.
                int iDano = iInteligencia;
                int iDanoExtra;
                //Daño a partir del 12, daño de la int + (dex/2)
                if(GetLevelByClass(58, oDamager) >= 12) iDano = iInteligencia + (eDex/2);
                //Daño de las dotes del espadachín.
                if(GetHasFeat(1513, oDamager)) iDanoExtra = d12(2);
                if(GetHasFeat(1512, oDamager)) iDanoExtra = d6(2);
                //Si es crítico, multiplicamos el daño normal por su multiplicador y añadimos el daño extra de las dotes.
                if(iAttackResult == 3) iDano = (iDano*iCriticoMod) + iDanoExtra;
                data.iBase = data.iBase + iDano;
            }
        }
    }

    //ATAQUE PODEROSO
    if(GetHasSpellEffect(898, oDamager))
    {
        int iDanyo = GetLocalInt(oDamager, "DANYO_AP");
        if(iAttackResult == 3) iDanyo = iDanyo*iCriticoMod;
        if(iDanyo > 0) data.iBase = data.iBase + iDanyo;
    }

    //Especializacion Alma Predilecta
    if(GetHasFeat(FEAT_FAVORED_SOUL_SPECIALIZATION, oDamager))
    {
        int iDanyo = 2;
        if(iAttackResult == 3) iDanyo = iDanyo*iCriticoMod;
        data.iBase = data.iBase + iDanyo;
    }

    //Bonificador Daño Dote del Pícaro: Golpe preciso.
    //Actualización 28/09/2024: Dote del Pícaro Golpe preciso: Añade el modificador de destreza a su daño, si porta armas sutiles.
    if(GetHasFeat(1505, oDamager))
    {
        //El arma que portamos existe y no llevamos armaduras no ligeras.
        if(oArmaEquipada != OBJECT_INVALID)
        {
            //Si el arma es pequeña, no es de distancia o es un estoque, aplicamos.
            if(iTamanyoArmaEquipada <= 2 && !GetWeaponRanged(oArmaEquipada) || (iEstoque == 1545 || iEstoque == 1535 || iEstoque == 1544 || iEstoque == 16807275 || iEstoque == 172 || iEstoque == 16827327 || iEstoque ==1547)) //Solo si tiene arma ligera o estoque/katana/bastón/cimitarradoble/espadadoble/lanzalarga y no es a distancia
            {
                //Daño normal, solo el daño de la int.
                int iDano = eDex;
                //Si es crítico, multiplicamos el daño normal por su multiplicador y añadimos el daño extra de las dotes.
                if(iAttackResult == 3) iDano = iDano*iCriticoMod;
                data.iBase = data.iBase + iDano;
            }
        }
    }

    //Castigar al mal
    if(GetLocalInt(oDamager,"FEAT301"))
    {
        if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
        {
            int iDano;
            if(GetLevelByClass(CLASS_TYPE_PAL_ANTIGUO, oDamager) > 0) iDano = GetLevelByClass(CLASS_TYPE_PAL_ANTIGUO, oDamager);
            if(GetLevelByClass(CLASS_TYPE_PAL_VENGADOR, oDamager) > 0) iDano = GetLevelByClass(CLASS_TYPE_PAL_VENGADOR, oDamager);
            //Fix, cuando no existe un daño, te devuelve -1, tenemos que setear a 0, para que meta los puntos con el valor real.
            if(data.iDivine > 0) data.iDivine = data.iDivine + iDano;
            else data.iDivine = data.iDivine + iDano + 1;
        }
        DeleteLocalInt(oDamager,"FEAT301");
    }
    //Castigar al bien
    if(GetLocalInt(oDamager,"FEAT472"))
    {
        if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD)
        {
            int iDano;
            if(GetLevelByClass(CLASS_TYPE_PAL_OSCURO, oDamager) > 0) iDano = GetLevelByClass(CLASS_TYPE_PAL_OSCURO, oDamager);
            //Fix, cuando no existe un daño, te devuelve -1, tenemos que setear a 0, para que meta los puntos con el valor real.
            if(data.iDivine > 0) data.iDivine = data.iDivine + iDano;
            else data.iDivine = data.iDivine + iDano + 1;
        }
        DeleteLocalInt(oDamager,"FEAT472");
    }


    // Send the modfied damages to nwnx
    NWNX_Damage_SetAttackEventData(data);
}

int GetCriticalMultiplier(object oWeapon, int iWeaponAttackType) {
    if (iWeaponAttackType == 7) return 2;

    int iWeaponType = GetBaseItemType(oWeapon);
    int iCriticalMod = StringToInt(Get2DAString("baseitems", "CritHitMult", iWeaponType));

    return iCriticalMod;
}
