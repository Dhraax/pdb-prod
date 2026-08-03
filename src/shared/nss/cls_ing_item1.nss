#include "mti_libreria"
#include "X0_I0_SPELLS"
#include "inc_spells"
#include "cls_ing_lib"
#include "pb_nivellanzador"
#include "war_utilities"
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

    /*//Sin la ballesta, no funciona las infusiones.
    if(GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC)) != "cls_ing_item1")
    {
        SendMessageToPC(oPC, "<c´$$>¡No tienes tu ballesta de ingeniero equipada!</c>"); return;
    }
    //Si se ha usado una infusión diferente en menos de 20 segundos, cancelamos.
    if(GetLocalInt(GetModule(),"CLS_ING_SPELLUSADO"+sNombre) != 0 && GetLocalInt(GetModule(),"CLS_ING_SPELLUSADO"+sNombre) != GetSpellId())
    {
        SendMessageToPC(oPC, "<c´$$>¡No puedes cambiar de infusión en menos de 20 segundos!</c>"); return;
    }*/

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedIncrease(-50), oPC, 2.5);
    FloatingTextStringOnCreature("*Recargar de munición encantada tu ballesta te hace ir más lento.*",oPC,FALSE,FALSE);
    //////////////////////
    //PODER ÚNICO BÁSICO//
    //////////////////////
    if(GetSpellId() == 1427)
    {
        //El lanzamiento de este "Poder Único", se considera hostil para quien lo recibe.
        SignalEvent (oTarget, EventSpellCastAt(oPC, GetSpellId()));

        //Este ataque, de base, realiza ataque de toque a distancia.
        int nTouch = TouchAttackRanged(oTarget);

        //Si acierta el ataque de toque, pues le mete daño, añadimos también un efectito del "tiro".
        if(nTouch == 1)
        {
            //Calculamos las distancias, para hacer un Delay a la hora de aplicar efectos.
            float fDelay = GetDistanceBetween(oPC, oTarget)/20.0;
            //Aplicamos los efectos.
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDano, DAMAGE_TYPE_FUERZA), oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGBLUE), oTarget));
        }
        //Si es crítico x2 al daño, efecto visual incrementado.
        if(nTouch == 2)
        {
            iDano = iDano * 2;
            //Calculamos las distancias, para hacer un Delay a la hora de aplicar efectos.
            float fDelay = GetDistanceBetween(oPC, oTarget)/20.0;
            //Aplicamos los efectos.
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDano, DAMAGE_TYPE_FUERZA), oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGBLUE,FALSE,1.2), oTarget));
        }
    }

    ///////////////
    //LANZALLAMAS//
    ///////////////
    if(GetSpellId() == 1400)
    {
        //En todo que activa el item, hace el efecto visual de cono de fuego.
        //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(1548), oPC);
        //En este caso, el objetivo es la criatura que esté en el área de actuación.
        oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        while(GetIsObjectValid(oTarget))
        {
            //Afecta a todo el que esté dentro
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
            {
                //El lanzamiento de este "Poder Único", se considera hostil para quien lo recibe.
                SignalEvent (oTarget, EventSpellCastAt(oPC, GetSpellId()));

                //Calculamos las distancias, para hacer un Delay a la hora de aplicar efectos.
                float fDelay = GetDistanceBetween(oPC, oTarget)/20.0;

                if(!MyResistSpell(oPC, oTarget, fDelay) && (oTarget != oPC))
                {
                    iDano = iDANOING (oPC);
                    if(iDano>0)
                    {
                        //El poder mete un extra de daño.
                        iDano = iDano + d6(2);

                        //Hacemos tirada de reflejos.
                        iDano = GetReflexAdjustedDamage(iDano, oTarget, iCD, SAVING_THROW_TYPE_FIRE);

                        //Aplicamos los efectos correspondientes.
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDano, DAMAGE_TYPE_FIRE), oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_S), oTarget));

                        //Ahora aplicamos el efecto prendido, si no tiene mas efectos de impactos secundarios activos.
                        if(GetIsPC(oTarget) && GetLocalInt(oTarget, "CLS_ING_IMPACTOS") == 0){DelayCommand(fDelay+6.0,ImpactosSecundarios(oPC, oTarget, DAMAGE_TYPE_FIRE, iDano, iCD, VFX_IMP_FLAME_S, GetSpellId()));}
                        else if(!GetIsPC(oTarget) && GetLocalInt(oTarget, "CLS_ING_IMPACTOS") == 0){DelayCommand(fDelay+6.0,ImpactosSecundarios(oPC, oTarget, DAMAGE_TYPE_FIRE, iDano, iCD, VFX_IMP_FLAME_S, GetSpellId()));}
                   }
                }
            }
            //Select the next target within the spell shape.
            oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
    }

    ///////////////
    //HUMIFICADOR//
    ///////////////
    if(GetSpellId() == 1401)
    {
        //Solo un área de efecto a la vez.
        BorrarAreasEfecto (oPC, "VFX_PER_ING_HUMIFICADOR");
        //Asignamos los scripts
        effect eAOE = EffectAreaOfEffect(67,"cls_ing_humia","","cls_ing_humib");
        int iDuracion = iCasterLevel / 2;
        if(iDuracion == 0){iDuracion = 1;}
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLocation, RoundsToSeconds(iDuracion));
    }

    ///////////
    //BAZOOKA//
    ///////////
    if(GetSpellId() == 1402)
    {
        //Metemos el efecto de la explosión.
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_FIREBALL), lLocation);
        //En este caso, el objetivo es la criatura que esté en el área de actuación.
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        while (GetIsObjectValid(oTarget))
        {
            //Afecta a todo el que esté dentro
            //if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
            //{
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
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDano, DAMAGE_TYPE_FIRE), oTarget));
                        //Aplicamos el efecto visual.
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M), oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(498), oTarget, 30.0));
                        //Ahora aplicamos el efecto prendido, si no tiene mas efectos de impactos secundarios activos.
                        if(GetIsPC(oTarget) && GetLocalInt(oTarget, "CLS_ING_IMPACTOS") == 0){DelayCommand(fDelay+6.0,ImpactosSecundarios(oPC, oTarget, DAMAGE_TYPE_FIRE, iDano, iCD, VFX_IMP_FLAME_S, GetSpellId()));}
                        else if(!GetIsPC(oTarget) && GetLocalInt(oTarget, "CLS_ING_IMPACTOS") == 0){DelayCommand(fDelay+6.0,ImpactosSecundarios(oPC, oTarget, DAMAGE_TYPE_FIRE, iDano, iCD, VFX_IMP_FLAME_S, GetSpellId()));}
                    }
                 }
            //}
           //Siguiente objetivo
           oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
    }

    ///////////////
    //REVERSONICO//
    ///////////////
    if(GetSpellId() == 1403)
    {
        //En todo que activa el item, hace el efecto visual de cono de fuego.
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(1546), oPC);
        //En este caso, el objetivo es la criatura que esté en el área de actuación.
        oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        while(GetIsObjectValid(oTarget))
        {
            //Afecta a todo el que esté dentro
            //if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
            //{
                //El lanzamiento de este "Poder Único", se considera hostil para quien lo recibe.
                SignalEvent (oTarget, EventSpellCastAt(oPC, GetSpellId()));

                //Calculamos las distancias, para hacer un Delay a la hora de aplicar efectos.
                float fDelay = GetDistanceBetween(oPC, oTarget)/20.0;

                if(!MyResistSpell(oPC, oTarget, fDelay) && (oTarget != oPC))
                {
                    iDano = iDANOING (oPC);
                    if(iDano>0)
                    {
                        //Duración de los efectos.
                        int iDuracion = iCasterLevel / 2;
                        if(iDuracion == 0){iDuracion = 1;}

                        //El poder mete un extra de daño.
                        iDano = iDano/2;

                        //Hacemos tirada de reflejos.
                        iDano = GetReflexAdjustedDamage(iDano, oTarget, iCD, SAVING_THROW_TYPE_SONIC);

                        //Aplicamos los efectos correspondientes.
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDano, DAMAGE_TYPE_SONIC), oTarget));
                        if(!MySavingThrow(SAVING_THROW_WILL, oTarget, iCD, SAVING_THROW_TYPE_MIND_SPELLS))
                        {
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, RoundsToSeconds(iDuracion)));
                        }
                    }
                }
            //}
            //Select the next target within the spell shape.
            oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
    }

    //////////
    //ARIETE//
    //////////
    if(GetSpellId() == 1404)
    {
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
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDano, DAMAGE_TYPE_FUERZA), oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(DAMAGE_TYPE_MAGICAL), oTarget));
        }
        //Si es crítico x2 al daño, efecto visual incrementado.
        if(nTouch == 2)
        {
            iDano = iDano * 2;
            //Calculamos las distancias, para hacer un Delay a la hora de aplicar efectos.
            float fDelay = GetDistanceBetween(oPC, oTarget)/20.0;
            //Aplicamos los efectos.
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDano, DAMAGE_TYPE_FUERZA), oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(DAMAGE_TYPE_MAGICAL,FALSE,1.2), oTarget));
        }
        //Si impacta, pues intentamos empujar.
        if(nTouch != 0)
        {
            //Miramos los efectos, tamaño del objetivo y la distancia que empujaremos..
            effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
            int iSize = GetCreatureSize(oTarget);
            float fDistance = 1.0 + d6();

            //Si es enorme o grande no hay derribo
            if(iSize == CREATURE_SIZE_HUGE || iSize == 22 || iSize == 23) return;
            if(GetIsImmune(oTarget, IMMUNITY_TYPE_KNOCKDOWN)) return;

            //Si no tiene aún los efectos del conjuro
            if(!GetHasSpellEffect(1404, oTarget))
            {
                //Si no salva reflejos.
                if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, iCD))
                {
                    //Metemos el empujón, aplicamos los efectos y borramos la variable a los 6.0 segundos del efecto.
                    ActionRepel(oTarget, fDistance, 12.0);
                    ApplyEffectToObject (DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        }
    }

    //////////////////
    //ELECTROCUTADOR//
    //////////////////
    if(GetSpellId() == 1405)
    {
        //Contadores.
        int nCnt = 1;
        int nCnt2 = 0;
        //Efecto del rayo.
        effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oPC, BODY_NODE_HAND);
        //Comprobamos si hay otro objetivo cercano, en este caso, de nuestro PJ.
        object oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE, oPC, nCnt);
        //Objeto necesario.
        object oTarget3;
        //Si hay un objetivo acorde cercano.
        while(GetIsObjectValid(oTarget2))
        {
            //Buscamos al objetivo, dentro del área, el objetivo debe estar dentro de la línea de visión de nuestro PJ.
            oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 10.0, lLocation, TRUE, OBJECT_TYPE_CREATURE);
            //Bucle hasta que hagamos los objetivos posibles según el nivel: Nivel Artífice/5 (1 cada 5 niveles).
            while (GetIsObjectValid(oTarget) && GetCurrentHitPoints(oTarget) > -10 && nCnt2 < GetLevelByClass(CLASS_TYPE_INGENIERO,oPC)/5)
            {
               //Evitamos que la hostia nos la de al lanzador.
               if (oTarget != oPC && oTarget2 == oTarget)
               {
                    //El enemigo debe ser alguien hostil.
                    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
                    {
                        //Lanzamos el evento.
                        SignalEvent (oTarget, EventSpellCastAt(oPC, GetSpellId()));
                        //Hacemos resistencias a conjuros.
                        if (!MyResistSpell(OBJECT_SELF, oTarget))
                        {
                            iDano = iDANOING (oPC);
                            //El poder mete un extra de daño.
                            iDano = iDano + d6(2);
                            //Salvación de reflejos para el daño.
                            iDano = GetReflexAdjustedDamage(iDano, oTarget, iCD, SAVING_THROW_TYPE_ELECTRICITY);
                            if(iDano > 0)
                            {
                                float fDelay = GetSpellEffectDelay(GetLocation(oTarget), oTarget);
                                //Metemos los efectos.
                                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(iDano, DAMAGE_TYPE_ELECTRICAL),oTarget));
                                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_LIGHTNING_S),oTarget));
                            }
                        }
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,1.0);
                        //El siguiente rayo sale desde el objetivo actual.
                        oTarget3 = oTarget;
                        eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oTarget3, BODY_NODE_CHEST);
                        nCnt2++;
                    }
               }
               //Get the next object in the lightning cylinder
               oTarget = GetNextObjectInShape(SHAPE_SPHERE, 10.0, lLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            }
            nCnt++;
            oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, nCnt);
        }
    }

    //////////////////
    //BAZOOKA FUERZA//
    //////////////////
    if(GetSpellId() == 1406)
    {
        //Metemos el efecto de la explosión.
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_FIREBALL), lLocation);
        //En este caso, el objetivo es la criatura que esté en el área de actuación.
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        while (GetIsObjectValid(oTarget))
        {
            //Afecta a todo el que esté dentro
            //if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
            //{
                //El lanzamiento de este "Poder Único", se considera hostil para quien lo recibe.
                SignalEvent (oTarget, EventSpellCastAt(oPC, GetSpellId()));

                //Calculamos las distancias, para hacer un Delay a la hora de aplicar efectos.
                float fDelay = GetDistanceBetween(oPC, oTarget)/20.0;

                if (!MyResistSpell(oPC, oTarget, fDelay))
                {
                    //Tirada de reflejos para el daño.
                    iDano = iDANOING (oPC);
                    iDano = iDano + d6(2);
                    iDano = GetReflexAdjustedDamage(iDano, oTarget, iCD, SAVING_THROW_TYPE_FIRE);
                    if(iDano>0)
                    {
                        //Aplicamos el daño.
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDano, DAMAGE_TYPE_FUERZA), oTarget));
                        //Aplicamos el efecto visual.
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M), oTarget));
                        if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, iCD))
                        {
                            float fDistance = 1.0 + d6();
                            ActionRepel(oTarget, fDistance, 12.0);
                        }
                    }
                 }
            //}
           //Select the next target within the spell shape.
           oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
    }

    /////////////
    //PROTECTOR//
    /////////////
    if(GetSpellId() == 1407)
    {
        if(GetLocalInt(oPC, "CLS_ING_PROTECTOR") == 1)
        {
            SendMessageToPC(oPC, "<c´$$>¡No puedes usar esta infusión hasta que no se pase su tiempo de duración (esté o no disipada)!</c>"); return;
        }

        //Fire cast spell at event for the specified target
        SignalEvent (oTarget, EventSpellCastAt(oPC, GetSpellId(), FALSE));

        effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
        effect eHP = EffectTemporaryHitpoints(iDano);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = EffectLinkEffects(eHP, eDur);

        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(iCasterLevel));

        //Aplicamos la variable antiuso y la borramos cuando pase el tiempo.
        SetLocalInt(oPC,"CLS_ING_PROTECTOR",GetLocalInt(oPC, "CLS_ING_PROTECTOR") + 1);
        DelayCommand(RoundsToSeconds(iCasterLevel), DeleteLocalInt(oPC,"CLS_ING_PROTECTOR"));
    }

    /////////////
    //DISIPADOR//
    /////////////
    if(GetSpellId() == 1408)
    {
        effect   eVis         = EffectVisualEffect( VFX_IMP_BREACH );
        effect   eImpact      = EffectVisualEffect( VFX_FNF_DISPEL_GREATER );
        //Limitamos el Dispell a maximo nivel 15.
        if(iCasterLevel >15)
        {
            iCasterLevel = 15;
        }

        //Hay un objetivo.
        if (GetIsObjectValid(oTarget))
        {
            spellsDispelMagic(oTarget, iCasterLevel, eVis, eImpact);
        }
        //Zona de efecto.
        else
        {
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
            oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocation, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
            while (GetIsObjectValid(oTarget))
            {
                if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
                {
                    spellsDispelAoE(oTarget, OBJECT_SELF, iCasterLevel);
                }
                else if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
                {
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
                }
                else
                {
                    spellsDispelMagic(oTarget, iCasterLevel, eVis, eImpact, FALSE);
                }
                oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocation, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
            }
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
