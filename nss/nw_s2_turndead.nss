//::///////////////////////////////////////////////
//:: Turn Undead
//:: NW_S2_TurnDead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks domain powers and class to determine
    the proper turning abilities of the casting
    character.
*/
//:://////////////////////////////////////////////
//:: Created By: Nov 2, 2001
//:: Created On: Preston Watamaniuk
//:://////////////////////////////////////////////
//:: MODIFIED MARCH 5 2003 for Blackguards
//:: Modified November 29, 2003 for Evil Cleric Rebuke/Command

#include "lib_race"

// Checks to see if an evil cleric has control 'slots' to command
// the specified undead
// if TRUE, the cleric has enough levels of control to control the undead
// if FALSE, the cleric will rebuke the undead instead
int CanCommand(int nClassLevel, int nTargetHD) {
    int nSlots = GetLocalInt(OBJECT_SELF, "wb_clr_comm_slots");
    int nNew = nSlots + nTargetHD;
    if(nClassLevel >= nNew) {
        return TRUE;
    }
    return FALSE;
}

void AddCommand(int nTargetHD) {
    int nSlots = GetLocalInt(OBJECT_SELF, "wb_clr_comm_slots");
    SetLocalInt(OBJECT_SELF, "wb_clr_comm_slots", nSlots + nTargetHD);
}

void SubCommand(int nTargetHD) {
    int nSlots = GetLocalInt(OBJECT_SELF, "wb_clr_comm_slots");
    SetLocalInt(OBJECT_SELF, "wb_clr_comm_slots", nSlots - nTargetHD);
}

void RebukeUndead(int nTurnLevel, int nTurnHD, int nVermin, int nElemental, int nConstructs, int nOutsider, int nClassLevel, int nTurnPower) {
    //Gets all creatures in a 20m radius around the caster and rebukes them or not.  If the creatures
    //HD are 1/2 or less of the nClassLevel then the creature is commanded (dominated).
    int nCnt = 1;
    int nHD, nRacial, nHDCount, bValid, nDamage;
    nHDCount = 0;
    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
    effect eVisTurn = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
    effect eDamage;
    effect eTurned = EffectCutsceneParalyze();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eVisTurn, eTurned);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eDeath = SupernaturalEffect(EffectCutsceneDominated());
    effect eDomin = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDeathLink = EffectLinkEffects(eDeath, eDomin);

    effect eImpactVis = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, GetLocation(OBJECT_SELF));

    //Get nearest enemy within 20m (60ft)
    //Why are you using GetNearest instead of GetFirstObjectInShape
    object oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE , OBJECT_SELF, nCnt,CREATURE_TYPE_PERCEPTION , PERCEPTION_SEEN);
    while(GetIsObjectValid(oTarget) && nHDCount < nTurnHD && GetDistanceToObject(oTarget) <= 20.0)
    {
        //Obtenemos los DG del objetivo sumando su resistencia a la expulsion.
        nHD = GetHitDice(oTarget) + GetTurnResistanceHD(oTarget);
        nRacial = GetRacialType(oTarget);

        if(nHD <= nTurnLevel && nHD <= (nTurnHD - nHDCount))
        {
            //Check the various domain turning types
            if(PB_Race_GetIsUndead(oTarget))
            {
                bValid = TRUE;
            }
            else if (nRacial == RACIAL_TYPE_VERMIN && nVermin > 0)
            {
                bValid = TRUE;
            }
            else if (nRacial == RACIAL_TYPE_ELEMENTAL && nElemental > 0)
            {
                bValid = TRUE;
            }
            else if (nRacial == RACIAL_TYPE_CONSTRUCT && nConstructs > 0)
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_TURN_UNDEAD));
                nDamage = d3(nTurnLevel);
                eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                nHDCount += nHD;
            }
            else if (nRacial == RACIAL_TYPE_OUTSIDER && nOutsider > 0)
            {
                bValid = TRUE;
            }

            //Raza inmune a la reprension.
            if (GetSubRace(oTarget) == "DeathKnight"){
                SendMessageToPC(oTarget, "Eres inmune a la reprensión");
                SendMessageToPC(OBJECT_SELF, GetName(oTarget)+" es inmune a la reprensión");
                bValid = FALSE;
            }

            //Se localizo un blanco valido.
            if( bValid == TRUE)
            {
                //Si el blanco no es un aliado.
                if(!GetIsFriend(oTarget)){
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

                    if((nClassLevel/2) >= nHD && CanCommand(nClassLevel, nHD))
                    {
                        //Fire cast spell at event for the specified target
                        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_TURN_UNDEAD));
                        //Destroy the target
                        DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeathLink, oTarget, RoundsToSeconds(10)));
                        AddCommand(nHD);
                        DelayCommand(RoundsToSeconds(10), SubCommand(nHD));
                    }
                    else
                    {
                        //Turn the target
                        //Fire cast spell at event for the specified target
                        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_TURN_UNDEAD));
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10));
                    }
                } else {
                    //Si el blanco es un alidado:
                    if(GetLocalInt(oTarget, "nTurnPower") != 0){
                        //Si los aliados estan siendo expulsados intetamos disipar el efecto.
                        if(nTurnPower >= GetLocalInt(oTarget, "nTurnPower")){
                            //Si la tirada de expulsion es mejor que la del bueno se elimita la expulsion.
                            effect eDelete = GetFirstEffect(oTarget);
                            while(GetIsEffectValid(eDelete)){
                                if(GetEffectType(eDelete) == FEAT_TURN_UNDEAD){
                                    effect eVisDips = EffectVisualEffect(VFX_FNF_DISPEL);
                                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisDips, oTarget);
                                    RemoveEffect(oTarget, eDelete);
                                    DeleteLocalInt(oTarget, "nTurnPower");
                                }
                                eDelete = GetNextEffect(oTarget);
                            }
                        }
                    } else {
                        //Si los aliados no estan siendo expulsados los reforzamos.
                        if(nTurnLevel > nHD){
                            //Si el muerto ya esta reforzado no vuelve a intentarlo.
                            if(!GetLocalInt(oTarget,"nTurnReinforced")){
                                SendMessageToPC(OBJECT_SELF, GetName(oTarget)+" ha sido reforzado contra la expulsión como si tuviese "+IntToString(nTurnLevel-nHD)+" DG");
                                SendMessageToPC(oTarget, GetName(OBJECT_SELF)+" ha reforzado tu resistencia a la expulsión.");
                                effect eReinforce = EffectTurnResistanceIncrease(nTurnLevel-nHD);
                                effect eVisReinf = EffectVisualEffect(VFX_IMP_HARM);
                                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisReinf, oTarget);
                                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eReinforce, oTarget, RoundsToSeconds(10));
                                SetLocalInt(oTarget, "nTurnReinforced",1);
                                DelayCommand(RoundsToSeconds(10), DeleteLocalInt(oTarget, "nTurnReinforced"));
                            }
                        }
                    }
                }
                nHDCount = nHDCount + nHD;
            }
        }
        bValid = FALSE;
        nCnt++;
        oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE , OBJECT_SELF, nCnt,CREATURE_TYPE_PERCEPTION , PERCEPTION_SEEN);
    }
}

void TurnUndead(int nTurnLevel, int nTurnHD, int nVermin, int nElemental, int nConstructs, int nOutsider, int nClassLevel, int nTurnPower) {
    //Gets all creatures in a 20m radius around the caster and turns them or not.  If the creatures
    //HD are 1/2 or less of the nClassLevel then the creature is destroyed.
    int nCnt = 1;
    int nHD, nRacial, nHDCount, bValid, nDamage;
    nHDCount = 0;
    effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    effect eVisTurn = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eDamage;
    effect eTurned = EffectTurned();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eVisTurn, eTurned);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eDeath = SupernaturalEffect(EffectDeath(TRUE));

    effect eImpactVis = EffectVisualEffect(481); // ANTES VFX_FNF_LOS_HOLY_30
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, GetLocation(OBJECT_SELF));

    //Get nearest enemy within 20m (60ft)
    //Why are you using GetNearest instead of GetFirstObjectInShape
    object oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE , OBJECT_SELF, nCnt,CREATURE_TYPE_PERCEPTION , PERCEPTION_SEEN);
    while(GetIsObjectValid(oTarget) && nHDCount < nTurnHD && GetDistanceToObject(oTarget) <= 20.0)
    {
        if(!GetIsFriend(oTarget))
        {
            nHD = GetHitDice(oTarget) + GetTurnResistanceHD(oTarget);
            nRacial = GetRacialType(oTarget);
            if(nHD <= nTurnLevel && nHD <= (nTurnHD - nHDCount))
            {
                //Check the various domain turning types
                if(PB_Race_GetIsUndead(oTarget))
                {
                    bValid = TRUE;
                }
                else if (nRacial == RACIAL_TYPE_VERMIN && nVermin > 0)
                {
                    bValid = TRUE;
                }
                else if (nRacial == RACIAL_TYPE_ELEMENTAL && nElemental > 0)
                {
                    bValid = TRUE;
                }
                else if (nRacial == RACIAL_TYPE_CONSTRUCT && nConstructs > 0)
                {
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_TURN_UNDEAD));
                    nDamage = d3(nTurnLevel);
                    eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                    nHDCount += nHD;
                }
                else if (nRacial == RACIAL_TYPE_OUTSIDER && nOutsider > 0)
                {
                    bValid = TRUE;
                }

                //Subraza inmune a la expulsion.
                if (GetSubRace(oTarget) == "DeathKnight"){
                    SendMessageToPC(oTarget, "Eres inmune a la expulsión");
                    SendMessageToPC(OBJECT_SELF, GetName(oTarget)+" es inmune a la expulsión");
                    bValid = FALSE;
                }

                //Apply results of the turn
                if( bValid == TRUE)
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

                    if((nClassLevel/2) >= nHD)
                    {
                        //Fire cast spell at event for the specified target
                        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_TURN_UNDEAD));
                        //Destroy the target
                        DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                    }
                    else
                    {
                        //Fire cast spell at event for the specified target
                        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_TURN_UNDEAD));
                        //Asignamos el efecto a los objetivos afectados.
                        AssignCommand(oTarget, ActionMoveAwayFromObject(OBJECT_SELF, TRUE));
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10));
                        //Asignamos el poder de expulsion del clerigo.
                        SetLocalInt(oTarget, "nTurnPower", nTurnPower);
                        //Eliminamos la variable que marca el poder de expulsion pasados los 10 asaltos.
                        DelayCommand(RoundsToSeconds(10), DeleteLocalInt(oTarget, "nTurnPower"));
                    }
                    nHDCount = nHDCount + nHD;
                }
            }
            bValid = FALSE;
        }
        nCnt++;
        oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE , OBJECT_SELF, nCnt,CREATURE_TYPE_PERCEPTION , PERCEPTION_SEEN);
    }
}

void main()
{
    if(GetLocalInt(OBJECT_SELF, "ACELERAR_EXPULSION_SPAM") == TRUE)
    {
        SendMessageToPC(OBJECT_SELF,"<cþ<<>Sólo puedes realizar una expulsión por asalto.</c>");
        return;
    }

    SetLocalInt(OBJECT_SELF, "ACELERAR_EXPULSION_SPAM", TRUE);
    DelayCommand(6.0, DeleteLocalInt(OBJECT_SELF, "ACELERAR_EXPULSION_SPAM"));

    int nClericLevel = GetLevelByClass(CLASS_TYPE_CLERIC);              //Clérigo
    int nPaladinLevel = GetLevelByClass(CLASS_TYPE_PALADIN);            //Paladin
    int nBlackguardlevel = GetLevelByClass(CLASS_TYPE_PAL_OSCURO);      //Paladín Oscuro.
    int nSoldadoLevel = GetLevelByClass(CLASS_TYPE_PAL_ANTIGUO);        //Caballero de Luz.
    int nVengadorLevel = GetLevelByClass(CLASS_TYPE_PAL_VENGADOR);       //Vengador.
    int nSiervoLevel = GetLevelByClass(47);
    int nTotalLevel =  GetHitDice(OBJECT_SELF);

    int nTurnLevel = nClericLevel;
    int nClassLevel = nClericLevel;


    if((nPaladinLevel - 2) > nTurnLevel)
    {
        nTurnLevel = nPaladinLevel - 2;
        nClassLevel = nPaladinLevel -2;
    }
    if((nBlackguardlevel - 2) > nTurnLevel)
    {
        nTurnLevel = nBlackguardlevel - 2;
        nClassLevel = nBlackguardlevel -2;
    }
    if((nSoldadoLevel - 2) > nTurnLevel)
    {
        nTurnLevel = nSoldadoLevel - 2;
        nClassLevel = nSoldadoLevel -2;
    }
    if((nVengadorLevel - 2) > nTurnLevel)
    {
        nTurnLevel = nVengadorLevel - 2;
        nClassLevel = nVengadorLevel -2;
    }

    //Siervo de la muerte.
    if ( (nSiervoLevel > 0) && ( nSiervoLevel - 2 > nClassLevel) )
    {
        nClassLevel = nSiervoLevel - 2;
        nTurnLevel = nSiervoLevel - 2;
    }

    //Flags for bonus turning types
    int nElemental = GetHasFeat(FEAT_AIR_DOMAIN_POWER) + GetHasFeat(FEAT_EARTH_DOMAIN_POWER) + GetHasFeat(FEAT_FIRE_DOMAIN_POWER) + GetHasFeat(FEAT_WATER_DOMAIN_POWER);
    int nVermin = GetHasFeat(FEAT_PLANT_DOMAIN_POWER) + GetHasFeat(FEAT_ANIMAL_COMPANION);
    int nConstructs = GetHasFeat(FEAT_DESTRUCTION_DOMAIN_POWER);
    int nOutsider = GetHasFeat(FEAT_GOOD_DOMAIN_POWER) + GetHasFeat(FEAT_EVIL_DOMAIN_POWER) + GetHasFeat(1287) + GetHasFeat(1288);

    //Flag for improved turning ability
    int nSun = GetHasFeat(FEAT_SUN_DOMAIN_POWER);
    int iPotenciarExpulsion = GetLocalInt(OBJECT_SELF, "POTENCIAR_EXPULSION");
    int iAcelerarExpulsion = GetLocalInt(OBJECT_SELF, "ACELERAR_EXPULSION");
    //int iIntensificarExpulsion = GetLocalInt(OBJECT_SELF, "INTENSIFICAR_EXPULSION"); No implementada por ahora

    //Make a turning check roll, modify if have the Sun Domain
    int nChrMod = GetAbilityModifier(ABILITY_CHARISMA);
    int nTurnCheck = d20() + nChrMod;              //The roll to apply to the max HD of undead that can be turned --> nTurnLevel
    int nTurnHD = d6(2) + nChrMod + nClassLevel;   //The number of HD of undead that can be turned.

    if(nSun == TRUE)
    {
        nTurnCheck += d4();
        nTurnHD += d6();
        SendMessageToPC(OBJECT_SELF, "<cÍþ>Tu expulsión es mejorada gracias al Dominio del Sol.</c>");
    }

    if(iPotenciarExpulsion == TRUE)
    {
        nTurnCheck -= 2;
        nTurnHD += d6(2);
        DeleteLocalInt(OBJECT_SELF, "POTENCIAR_EXPULSION");
        SendMessageToPC(OBJECT_SELF, "<cÍþ>Tu expulsión es potenciada gracias a la dote Potenciar Expulsión.</c>");
    }
    else if(iAcelerarExpulsion == TRUE)
    {
        nTurnCheck -= 4;
        nTurnHD -= 4;
        DeleteLocalInt(OBJECT_SELF, "ACELERAR_EXPULSION");
        SendMessageToPC(OBJECT_SELF, "<cÍþ>Tu expulsión es acelerada gracias a la dote Acelerar Expulsión.</c>");
    }
    //else if(iAcelerarExpulsion > 0)
    //{
    //    nTurnCheck += iAcelerarExpulsion;
    //    nTurnHD -= iAcelerarExpulsion;
    //    DeleteLocalInt(OBJECT_SELF, "INTENSIFICAR_EXPULSION");
    //    SendMessageToPC(OBJECT_SELF, "<cÍþ>Tu expulsión es intensificada gracias a la dote Intensificar Expulsión.</c>");
    //}

    //Determine the maximum HD of the undead that can be turned.
    if(nTurnCheck <= 0)
    {
        nTurnLevel -= 4;
    }
    else if(nTurnCheck >= 1 && nTurnCheck <= 3)
    {
        nTurnLevel -= 3;
    }
    else if(nTurnCheck >= 4 && nTurnCheck <= 6)
    {
        nTurnLevel -= 2;
    }
    else if(nTurnCheck >= 7 && nTurnCheck <= 9)
    {
        nTurnLevel -= 1;
    }
    else if(nTurnCheck >= 10 && nTurnCheck <= 12)
    {
        //Stays the same
    }
    else if(nTurnCheck >= 13 && nTurnCheck <= 15)
    {
        nTurnLevel += 1;
    }
    else if(nTurnCheck >= 16 && nTurnCheck <= 18)
    {
        nTurnLevel += 2;
    }
    else if(nTurnCheck >= 19 && nTurnCheck <= 21)
    {
        nTurnLevel += 3;
    }
    else if(nTurnCheck >= 22)
    {
        nTurnLevel += 4;
    }

    string sTC = IntToString(nTurnCheck);
    string sHD = IntToString(nTurnHD);
    SendMessageToPC(OBJECT_SELF,"<cþþþ>Poder de la expulsión: " + sTC + "</c>");
    SendMessageToPC(OBJECT_SELF,"<cþþþ>Dados de golpe afectados: " + sHD + "</c>");

    if(GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL){
        RebukeUndead(nTurnLevel, nTurnHD, nVermin, nElemental, nConstructs, nOutsider, nClassLevel, nTurnCheck);
    } else {
        TurnUndead(nTurnLevel, nTurnHD, nVermin, nElemental, nConstructs, nOutsider, nClassLevel, nTurnCheck);
    }
}
