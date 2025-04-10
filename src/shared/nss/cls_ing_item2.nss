#include "mti_libreria"
#include "X0_I0_SPELLS"
#include "inc_spells"
#include "cls_ing_lib"
#include "pb_nivellanzador"
#include "war_utilities"
#include "nostack_inc"
#include "x2_inc_spellhook"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    location lLocation = GetSpellTargetLocation();
    int iInfusionTipo = ObtenerIntPersistente(oPC,"CLS_ING_DOTE");
    int iCasterLevel = GetTotalCasterLevel(oPC, CLASS_TYPE_INGENIERO);
    string sNombre = GetName(oPC, TRUE);

    //Calculo de CD.
    int iCD = iCDING (oPC);

    //Calculo de daño.
    int iDano = iDANOING (oPC);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedIncrease(-50), oPC, 2.5);
    FloatingTextStringOnCreature("*Recargar de energía tu armadura te hace ir más lento.*",oPC,FALSE,FALSE);

    //////////////////////
    //PODER ÚNICO BÁSICO//
    //////////////////////
    if(GetSpellId() == 1429)
    {
        //Borramos los efectos de CIBORG, ANTIMAGIA.
        gsSPRemoveEffect(oPC,1410,oPC);
        gsSPRemoveEffect(oPC,1415,oPC);

        //El lanzamiento de este "Poder Único", se considera hostil para quien lo recibe.
        SignalEvent (oTarget, EventSpellCastAt(oPC, GetSpellId()));

        //Este ataque, de base, realiza ataque de toque a distancia.
        int nTouch = TouchAttackMelee(oTarget);

        //Si acierta el ataque de toque, pues le mete daño, añadimos también un efectito del "tiro".
        if(nTouch == 1)
        {
            //Calculamos las distancias, para hacer un Delay a la hora de aplicar efectos.
            float fDelay = GetDistanceBetween(oPC, oTarget)/20.0;
            //Aplicamos los efectos.
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDano, DAMAGE_TYPE_MAGICAL), oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGBLUE), oTarget));
        }
        //Si es crítico x2 al daño, efecto visual incrementado.
        if(nTouch == 2)
        {
            iDano = iDano * 2;
            //Calculamos las distancias, para hacer un Delay a la hora de aplicar efectos.
            float fDelay = GetDistanceBetween(oPC, oTarget)/20.0;
            //Aplicamos los efectos.
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDano, DAMAGE_TYPE_MAGICAL), oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGBLUE,FALSE,1.2), oTarget));
        }
    }

    //////////////////////////
    //GUANTELETES DEL TRUENO//
    //////////////////////////
    if(GetSpellId() == 1409)
    {
        //Borramos los efectos de CIBORG, ANTIMAGIA.
        gsSPRemoveEffect(oPC,1410,oPC);
        gsSPRemoveEffect(oPC,1415,oPC);

        //El lanzamiento de este "Poder Único", se considera hostil para quien lo recibe.
        SignalEvent (oTarget, EventSpellCastAt(oPC, GetSpellId()));

        //Este ataque, de base, realiza ataque de toque a distancia.
        int nTouch = TouchAttackRanged(oTarget);

        //Extra de daño por la infusión.
        iDano = iDano + d6(2);
        //Si acierta el ataque de toque, pues le mete daño, añadimos también un efectito del "tiro".
        if(nTouch == 1)
        {
            //Calculamos las distancias, para hacer un Delay a la hora de aplicar efectos.
            float fDelay = GetDistanceBetween(oPC, oTarget)/20.0;
            //Aplicamos los efectos.
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDano, DAMAGE_TYPE_ELECTRICAL), oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_S), oTarget));
        }
        //Si es crítico x2 al daño, efecto visual incrementado.
        if(nTouch == 2)
        {
            iDano = iDano * 2;
            //Calculamos las distancias, para hacer un Delay a la hora de aplicar efectos.
            float fDelay = GetDistanceBetween(oPC, oTarget)/20.0;
            //Aplicamos los efectos.
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDano, DAMAGE_TYPE_ELECTRICAL), oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), oTarget));
        }
    }

    //////////
    //CIBORG//
    //////////
    if(GetSpellId() == 1410)
    {
        if(GetLocalInt(oPC, "CLS_ING_CIBORG") == 1)
        {
            SendMessageToPC(oPC, "<c´$$>¡No puedes usar esta infusión hasta que no se pase su tiempo de duración (esté o no disipada)!</c>"); return;
        }

        //Borramos los efectos de CIBORG, ANTIMAGIA.
        gsSPRemoveEffect(oPC,1410,oPC);
        gsSPRemoveEffect(oPC,1415,oPC);

        //Fire cast spell at event for the specified target
        SignalEvent (oTarget, EventSpellCastAt(oPC, GetSpellId(), FALSE));

        effect eMov = EffectMovementSpeedIncrease(50);
        effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);


        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        DoNoStackSkillBonus(oPC,oTarget,5,37,RoundsToSeconds(iCasterLevel),GetSpellId());
        DoNoStackSkillBonus(oPC,oTarget,5,25,RoundsToSeconds(iCasterLevel),GetSpellId());
        DoNoStackSkillBonus(oPC,oTarget,5,26,RoundsToSeconds(iCasterLevel),GetSpellId());
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMov, oTarget, RoundsToSeconds(iCasterLevel));

        //Aplicamos la variable antiuso y la borramos cuando pase el tiempo.
        SetLocalInt(oPC,"CLS_ING_CIBORG",1);
        DelayCommand(RoundsToSeconds(iCasterLevel), DeleteLocalInt(oPC,"CLS_ING_CIBORG"));
    }

    //////////////////////
    //CAMPO DE DETECCION//
    //////////////////////
    if(GetSpellId() == 1411)
    {
        //Borramos los efectos de CIBORG, ANTIMAGIA.
        gsSPRemoveEffect(oPC,1410,oPC);
        gsSPRemoveEffect(oPC,1415,oPC);

        effect eAOE = EffectAreaOfEffect(35);
        effect eDur1 = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
        effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = EffectLinkEffects(eDur1, eDur2);

        //Make sure duration does no equal 0
        if (iCasterLevel < 1)
        {
            iCasterLevel = 1;
        }
        //Create an instance of the AOE Object using the Apply Effect function
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, TurnsToSeconds(iCasterLevel));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, TurnsToSeconds(iCasterLevel));

        //Literalmente es un cast purgar la invisibilidad.
        //ActionCastSpellAtLocation(91,lLocation,METAMAGIC_ANY,TRUE,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
    }

    ///////////////
    //PROPULSORES//
    ///////////////
    if(GetSpellId() == 1412)
    {
        //Borramos los efectos de CIBORG, ANTIMAGIA.
        gsSPRemoveEffect(oPC,1410,oPC);
        gsSPRemoveEffect(oPC,1415,oPC);

        //El lanzamiento de este "Poder Único", se considera hostil para quien lo recibe.
        SignalEvent (oTarget, EventSpellCastAt(oPC, GetSpellId()));

        //Literalmente es un cast volar.
        ActionCastSpellAtLocation(995,lLocation,METAMAGIC_ANY,TRUE,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
    }

    ///////////////
    //ROMPERROCAS//
    ///////////////
    if(GetSpellId() == 1413)
    {
        //Borramos los efectos de CIBORG, ANTIMAGIA.
        gsSPRemoveEffect(oPC,1410,oPC);
        gsSPRemoveEffect(oPC,1415,oPC);

        //El lanzamiento de este "Poder Único", se considera hostil para quien lo recibe.
        SignalEvent (oTarget, EventSpellCastAt(oPC, GetSpellId()));

        //Este ataque, de base, realiza ataque de toque a distancia.
        int nTouch = TouchAttackMelee(oTarget);

        //Si acierta el ataque de toque, pues le mete daño, añadimos también un efectito del "tiro".
        if(nTouch == 1)
        {
            //Calculamos las distancias, para hacer un Delay a la hora de aplicar efectos.
            float fDelay = GetDistanceBetween(oPC, oTarget)/20.0;
            //Aplicamos los efectos.
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDano, DAMAGE_TYPE_SONIC), oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SONIC), oTarget));
            //Tirada de voluntad.
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, iCD,SAVING_THROW_TYPE_MIND_SPELLS))
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, RoundsToSeconds(iCasterLevel/2)));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_STUN), oTarget));
            }

        }
        //Si es crítico x2 al daño, efecto visual incrementado.
        if(nTouch == 2)
        {
            iDano = iDano * 2;
            //Calculamos las distancias, para hacer un Delay a la hora de aplicar efectos.
            float fDelay = GetDistanceBetween(oPC, oTarget)/20.0;
            //Aplicamos los efectos.
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDano, DAMAGE_TYPE_MAGICAL), oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SONIC), oTarget));
            //Tirada de voluntad.
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, iCD,SAVING_THROW_TYPE_MIND_SPELLS))
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, RoundsToSeconds(iCasterLevel/2)));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_STUN), oTarget));
            }
        }
    }

    ////////////////
    //GOMA VISCOSA//
    ////////////////
    if(GetSpellId() == 1414)
    {
        //Borramos los efectos de CIBORG, ANTIMAGIA.
        gsSPRemoveEffect(oPC,1410,oPC);
        gsSPRemoveEffect(oPC,1415,oPC);

        //El lanzamiento de este "Poder Único", se considera hostil para quien lo recibe.
        SignalEvent (oTarget, EventSpellCastAt(oPC, GetSpellId()));

        //Este ataque, de base, realiza ataque de toque a distancia.
        int nTouch = TouchAttackMelee(oTarget);

        //Si acierta el ataque de toque, pues le mete daño, añadimos también un efectito del "tiro".
        if(nTouch == 1)
        {
            //Calculamos las distancias, para hacer un Delay a la hora de aplicar efectos.
            float fDelay = GetDistanceBetween(oPC, oTarget)/20.0;
            //Aplicamos los efectos.
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDano, DAMAGE_TYPE_SONIC), oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SONIC), oTarget));
            //Tirada de reflejos y solo un efecto a la vez.
            if(GetLocalInt(oTarget, "CLS_ING_GOMA") != 1)
            {
                if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, iCD))
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedDecrease(50), oTarget, RoundsToSeconds(iCasterLevel/2)));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackDecrease(5), oTarget, RoundsToSeconds(iCasterLevel/2)));
                    SetLocalInt(oTarget,"CLS_ING_GOMA",1);
                    DelayCommand(TurnsToSeconds(iCasterLevel/2), DeleteLocalInt(oTarget,"CLS_ING_GOMA"));
                }
            }
        }
        //Si es crítico x2 al daño, efecto visual incrementado.
        if(nTouch == 2)
        {
            iDano = iDano * 2;
            //Calculamos las distancias, para hacer un Delay a la hora de aplicar efectos.
            float fDelay = GetDistanceBetween(oPC, oTarget)/20.0;
            //Aplicamos los efectos.
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDano, DAMAGE_TYPE_MAGICAL), oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SONIC,FALSE,1.2), oTarget));
            //Tirada de reflejos y solo un efecto a la vez.
            if(GetLocalInt(oTarget, "CLS_ING_GOMA") != 1)
            {
                if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, iCD))
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedDecrease(50), oTarget, RoundsToSeconds(iCasterLevel/2)));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackDecrease(5), oTarget, RoundsToSeconds(iCasterLevel/2)));
                    SetLocalInt(oTarget,"CLS_ING_GOMA",1);
                    DelayCommand(TurnsToSeconds(iCasterLevel/2), DeleteLocalInt(oTarget,"CLS_ING_GOMA"));
                }
            }
        }
    }

    //////////////////
    //CAMPOANTIMAGIA//
    //////////////////
    if(GetSpellId() == 1415)
    {
        //Borramos los efectos de CIBORG, ANTIMAGIA.
        gsSPRemoveEffect(oPC,1410,oPC);
        gsSPRemoveEffect(oPC,1415,oPC);

        //Evitamos chetismos a acumular esta infusión con otros conjuros  que meten RC.
        RemoveEffectsFromSpell(oTarget, SPELL_LESSER_SPELL_MANTLE);
        RemoveEffectsFromSpell(oTarget, SPELL_GREATER_SPELL_MANTLE);

        //Fire cast spell at event for the specified target
        SignalEvent (oTarget, EventSpellCastAt(oPC, GetSpellId(), FALSE));

        effect eVis = EffectVisualEffect(VFX_DUR_SPELLTURNING);
        effect eRC = EffectSpellResistanceIncrease(15 + GetLevelByClass(CLASS_TYPE_INGENIERO, oPC));
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = EffectLinkEffects(eVis, eRC);
        eLink = EffectLinkEffects(eLink, eDur);

        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(iCasterLevel));
    }

    /////////////////
    //CAMPOANTIDANO//
    /////////////////
    if(GetSpellId() == 1416)
    {
        //Borramos los efectos de CIBORG, ANTIMAGIA.
        gsSPRemoveEffect(oPC,1410,oPC);
        gsSPRemoveEffect(oPC,1415,oPC);

        //Evitamos chetismos a acumular esta infusión con otros conjuros  que meten RC.
        gsSPRemoveEffect(oTarget, SPELL_LESSER_SPELL_MANTLE);
        gsSPRemoveEffect(oTarget, SPELL_GREATER_SPELL_MANTLE);

        //Fire cast spell at event for the specified target
        SignalEvent (oTarget, EventSpellCastAt(oPC, GetSpellId(), FALSE));

        effect eReduc = EffectDamageReduction(20, DAMAGE_POWER_PLUS_SIX);
        effect eDur = EffectVisualEffect(VFX_DUR_AURA_BROWN);
        effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
        effect eLink = EffectLinkEffects(eReduc, eDur);

        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(iCasterLevel));
    }


    ///////////
    //REPELER//
    ///////////
    if(GetSpellId() == 1417)
    {
        //Metemos el efecto de la explosión.
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_ELECTRIC_EXPLOSION), lLocation);
        //En este caso, el objetivo es la criatura que esté en el área de actuación.
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oPC), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        while (GetIsObjectValid(oTarget))
        {
            //No a nosotros.
            if (oTarget != oPC && !GetIsReactionTypeFriendly(oTarget))
            {
                //El lanzamiento de este "Poder Único", se considera hostil para quien lo recibe.
                SignalEvent (oTarget, EventSpellCastAt(oPC, GetSpellId()));

                //Calculamos las distancias, para hacer un Delay a la hora de aplicar efectos.
                float fDelay = GetDistanceBetween(oPC, oTarget)/20.0;

                if (!MyResistSpell(oPC, oTarget, fDelay))
                {
                    iDano = iDANOING (oPC);
                    //Tirada de reflejos para el daño.
                    iDano = GetReflexAdjustedDamage(iDano, oTarget, iCD, SAVING_THROW_TYPE_FIRE);
                    if(iDano>0)
                    {
                        //Aplicamos el daño.
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDano, DAMAGE_TYPE_SONIC), oTarget));
                        //Aplicamos el efecto visual.
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SONIC), oTarget));
                    }
                    if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, iCD))
                    {
                        float fDistance = 1.0 + d6();
                        ActionRepel(oTarget, fDistance, 12.0);
                    }
                 }
            }
           //Siguiente objetivo
           oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oPC), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
    }

    /*//Metemos la var de la info usada.
    SetLocalInt(GetModule(),"CLS_ING_SPELLUSADO"+sNombre,GetSpellId());
    SetLocalInt(GetModule(),"CLS_ING_TSPELLUSADO"+sNombre,SQLite_GetTimeStamp() + 8);
    DelayCommand(8.0, DeleteLocalInt(GetModule(),"CLS_ING_SPELLUSADO"+sNombre));
    DelayCommand(9.0, Tiempo (oPC, sNombre));*/

    //Metemos la var de la info usada.
    SetLocalInt(oPC,"CLS_ING_SPELLUSADO",GetSpellId());
    SetLocalInt(oPC,"CLS_ING_TSPELLUSADO",SQLite_GetTimeStamp() + 8);
    DelayCommand(8.0, DeleteLocalInt(oPC,"CLS_ING_SPELLUSADO"));
    DelayCommand(9.0, Tiempo (oPC, sNombre));
}
