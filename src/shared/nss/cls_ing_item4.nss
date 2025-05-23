#include "mti_libreria"
#include "X0_I0_SPELLS"
#include "inc_spells"
#include "cls_ing_lib"
#include "pb_nivellanzador"
#include "war_utilities"
#include "nostack_inc"

//#include "x2_inc_spellhook"
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

    if(GetSpellId() != 1421)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedIncrease(-50), oPC, 2.5);
        FloatingTextStringOnCreature("*Rebuscar en tu cinturón los viales de alquimista te hace ir más lento.*",oPC,FALSE,FALSE);
    }

    //////////////////////
    //PODER ÚNICO BÁSICO//
    //////////////////////
    if(GetSpellId() == 1430)
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
                    //Hacemos tirada de reflejos.
                    iDano = GetReflexAdjustedDamage(iDano, oTarget, iCD, SAVING_THROW_TYPE_ACID);

                    //Aplicamos los efectos correspondientes.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDano, DAMAGE_TYPE_ACID), oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ACID_S), oTarget));
                }
            }
            //Select the next target within the spell shape.
            oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
    }

    //////////////////////////
    //ELIXIR DE CONOCIMIENTO//
    //////////////////////////
    if(GetSpellId() == 1418)
    {
        if(GetLocalInt(oPC, "CLS_ING_ELIXIRCON") == 1)
        {
            SendMessageToPC(oPC, "<c´$$>¡No puedes usar esta infusión hasta que no se pase su tiempo de duración (esté o no disipada)!</c>"); return;
        }

        //Fire cast spell at event for the specified target
        SignalEvent (oTarget, EventSpellCastAt(oPC, GetSpellId(), FALSE));

        effect eInt = EffectAbilityIncrease(ABILITY_INTELLIGENCE,4);
        effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);

        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        int iDuracion = iCasterLevel;
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInt, oTarget, TurnsToSeconds(iDuracion));

        //Aplicamos la variable antiuso y la borramos cuando pase el tiempo.
        //SetLocalInt(oPC,"CLS_ING_ELIXIRCON" ,SQLite_GetTimeStamp() + FloatToInt(TurnsToSeconds(iDuracion)));
        DelayCommand(TurnsToSeconds(iDuracion), DeleteLocalInt(oPC,"CLS_ING_ELIXIRCON"));
    }

    ///////////////////
    //BOMBA DE RAICES//
    ///////////////////
    if(GetSpellId() == 1419)
    {
        //Solo un área de efecto a la vez.
        BorrarAreasEfecto (oPC, "VFX_PER_BOMBARAICES");
        //Asignamos los scripts
        effect eAOE = EffectAreaOfEffect(68,"cls_ing_bomba","","cls_ing_bombab");
        int iDuracion = iCasterLevel / 2;
        if(iDuracion == 0){iDuracion = 1;}
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLocation, RoundsToSeconds(iDuracion));
    }

    /////////////////
    //BOMBRA DE GAS//
    /////////////////
    if(GetSpellId() == 1420)
    {
        //Solo un área de efecto a la vez.
        BorrarAreasEfecto (oPC, "VFX_PER_BOMBAGAS");
        //Asignamos los scripts
        effect eAOE = EffectAreaOfEffect(69,"cls_ing_bomb2a","","cls_ing_bomb2b");
        int iDuracion = iCasterLevel / 2;
        if(iDuracion == 0){iDuracion = 1;}
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLocation, RoundsToSeconds(iDuracion));
    }

    ///////////////////////
    //ELIXIR DE BERSERKER//
    ///////////////////////
    if(GetSpellId() == 1421)
    {
        //Fire cast spell at event for the specified target
        SignalEvent (oPC, EventSpellCastAt(oPC, GetSpellId(), FALSE));

        int nLevel = iCasterLevel;
        int oPCLevel = GetHitDice(oPC);
        int nModAttack;
        int nHP = nLevel;
        int nAttack = oPCLevel - GetBaseAttackBonus(oPC) ;
        int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
        int NAtaqueBase;
        if (GetBaseAttackBonus(oPC) <=5 )NAtaqueBase = 1;
        if (GetBaseAttackBonus(oPC) >=6 ) NAtaqueBase = 2;
        if (GetBaseAttackBonus(oPC) >=11 ) NAtaqueBase = 3;
        if (GetBaseAttackBonus(oPC) >=16 ) NAtaqueBase = 4;
        if (oPCLevel <=5 ) nModAttack = 1 - NAtaqueBase;
        if (oPCLevel >=6 ) nModAttack = 2 - NAtaqueBase;
        if (oPCLevel >=11 ) nModAttack = 3 - NAtaqueBase;
        if (oPCLevel >=16 ) nModAttack = 4 - NAtaqueBase;
        if(nModAttack < 0) nModAttack = 0;
        effect eFallo = EffectSpellFailure(100);
        effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
        effect eAttack = EffectAttackIncrease(nAttack);
        effect eAttackMod = EffectModifyAttacks(nModAttack);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = EffectLinkEffects(eAttack, eAttackMod);
        eLink = EffectLinkEffects(eLink, eDur);
        eLink = EffectLinkEffects(eLink, eFallo);
        effect eFuerza;
        effect eInt;
        //gsSPRemoveEffect(oPC, GetSpellId(), oPC);
        float fDuration = RoundsToSeconds(nLevel);

        //Efectos especiales.
        int iFuerza = GetAbilityScore(oPC, ABILITY_STRENGTH);
        int iInt = GetAbilityScore(oPC, ABILITY_INTELLIGENCE);
        //Cambios de la fuerza.
        if(iFuerza < iInt)
        {
            DoNoStackAbilityBonus(oPC, oPC, iInt - iFuerza, ABILITY_STRENGTH, fDuration);
        }
        if(iFuerza > iInt)
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_STRENGTH,iFuerza-iInt), oPC, fDuration);
        }
        //Cambios de la Int.
        if(iInt < iFuerza)
        {
            DoNoStackAbilityBonus(oPC, oPC, iFuerza - iInt, ABILITY_INTELLIGENCE, fDuration);
        }
        if(iInt > iFuerza)
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_INTELLIGENCE,iInt-iFuerza), oPC, fDuration);
        }
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);

        //Cambios de tamaño.
        if (ObtenerIntPersistente(oTarget, "CAB_ALTURA") == 1)
        {
            float fAltura = ObtenerFloatPersistente(oTarget, "IND_ALTURA");
            SetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_SCALE, fAltura+0.20);
            int ColorPiel =  GetColor(oTarget, COLOR_CHANNEL_SKIN);
            GuardarIntPersistente(oTarget,"BerserkerColorPiel",ColorPiel);
            SetColor(oTarget, COLOR_CHANNEL_SKIN, 45);
            //DelayCommand(fDuration,AlturaBerserker(oPC, fAltura));
        }
        // Con el cambio de altura del ingeniero, por si caso, aquellos PJs que no tienen seteada ninguna altura, los ponemos a 1.0.
        if (ObtenerIntPersistente(oTarget, "CAB_ALTURA") != 1)
        {
            SetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_SCALE, 1.2);
            int ColorPiel =  GetColor(oTarget, COLOR_CHANNEL_SKIN);
            GuardarIntPersistente(oTarget,"BerserkerColorPiel",ColorPiel);
            SetColor(oTarget, COLOR_CHANNEL_SKIN, 45);
            //DelayCommand(fDuration,AlturaBerserker(oPC, 1.0));
        }

        //Aplicamos la variable antiuso y la borramos cuando pase el tiempo.
        SetLocalInt(oPC,"CLS_ING_ELIXIRBERS",1);
        DelayCommand(fDuration, DeleteLocalInt(oPC,"CLS_ING_ELIXIRBERS"));
    }

    ///////////////////////
    //FUEGO DE ALQUIMISTA//
    ///////////////////////
    if(GetSpellId() == 1422)
    {
        //Solo un área de efecto a la vez.
        BorrarAreasEfecto (oPC, "VFX_PER_FUEGOALQUIMISTA");
        //Asignamos los scripts
        effect eAOE = EffectAreaOfEffect(70,"cls_ing_bomb3a","","cls_ing_bomb3b");
        int iDuracion = iCasterLevel / 2;
        if(iDuracion == 0){iDuracion = 1;}
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLocation, RoundsToSeconds(iDuracion));
    }

    ////////////////////
    //ROCIADOR DE AMOR//
    ////////////////////
    if(GetSpellId() == 1423)
    {
        //Enlistamos los efectos.
        effect eDom = EffectDominated();
        eDom = GetScaledEffect(eDom, oTarget);
        effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        effect eLink = EffectLinkEffects(eMind, eDom);
        eLink = EffectLinkEffects(eLink, eDur);
        effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
        //Duracion, 3 asaltos.
        float fDuration = RoundsToSeconds(3);
        //Miramos la raza.
        int nRacial = GetRacialType(oTarget);

        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        //El objetivo es hostil.
        if(!GetIsReactionTypeFriendly(oTarget))
        {
              //Comprobamos RC.
              if (!MyResistSpell(OBJECT_SELF, oTarget))
              {
                   //Si no salva.
                   if (!MySavingThrow(SAVING_THROW_WILL, oTarget, iCD, SAVING_THROW_TYPE_MIND_SPELLS))
                   {
                        //Apply linked effects and VFX Impact
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    }
               }
         }
    }

    //////////////////////
    //BOMBA POTENCIACIÓN//
    //////////////////////
    if(GetSpellId() == 1424)
    {
        if(GetLocalInt(oPC, "CLS_ING_POTENCIACION") == 1)
        {
            SendMessageToPC(oPC, "<c´$$>¡No puedes usar esta infusión hasta que no se pase su tiempo de duración (esté o no disipada)!</c>"); return;
        }
        effect eAttack = EffectAttackIncrease(2);
        effect eMov = EffectMovementSpeedIncrease(25);
        effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = EffectLinkEffects(eMov, eAttack);
               eLink = EffectLinkEffects(eLink, eDur);
        effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
        float fDelay;
        int nCount;
        int iDuracion = iCasterLevel / 2;
        if(iDuracion == 0){iDuracion = 1;}

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLocation);
        while(GetIsObjectValid(oTarget) && nCount < iCasterLevel)
        {
            fDelay = GetRandomDelay(0.0, 1.0);
            SignalEvent (oTarget, EventSpellCastAt(oPC, GetSpellId(),FALSE));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(iDuracion)));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            nCount++;
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLocation);
        }
        //Aplicamos la variable antiuso y la borramos cuando pase el tiempo.
        SetLocalInt(oPC,"CLS_ING_POTENCIACION",1);
        DelayCommand(RoundsToSeconds(iDuracion), DeleteLocalInt(oPC,"CLS_ING_POTENCIACION"));
    }

    /////////////
    //BOMBA TNT//
    /////////////
    if(GetSpellId() == 1425)
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
                    iDano = iDano + d6(2);
                    iDano = GetReflexAdjustedDamage(iDano, oTarget, iCD, SAVING_THROW_TYPE_FIRE);
                    if(iDano>0)
                    {
                        //Aplicamos el daño.
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDano, DAMAGE_TYPE_FIRE), oTarget));
                        //Aplicamos el efecto visual.
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M), oTarget));
                        // Resistencia a reflejos
                        if (!MySavingThrow(SAVING_THROW_REFLEX, oTarget, iCD))
                        {
                            //Aplicamos el efecto.
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectKnockdown(), oTarget, 12.0));
                        }
                    }
                 }
            //}
           //Siguiente objetivo
           oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
    }

    //////////////////
    //BOMBA CAMBIAZO//
    //////////////////
    if(GetSpellId() == 1426)
    {
        effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
        effect eFallo = EffectSpellFailure(100);
        effect eAttackDecrease = EffectAttackDecrease(20);
        effect eLink = EffectLinkEffects(eFallo, eAttackDecrease);
        effect ePoly;
        int nRacialType = GetRacialType(oTarget);
        int nDuration = GetLevelByClass(CLASS_TYPE_INGENIERO, OBJECT_SELF);

        // El conjuro no funciona contra constructos, no muertos o contra el mismo lanzador
        if (PB_Race_GetIsUndead(oTarget) || nRacialType == RACIAL_TYPE_CONSTRUCT || oTarget == OBJECT_SELF) return;

        // El conjuro solo dura un asalto contra el subtipo SHAPECHANGER o cambiaformas de nivel 10
        if (nRacialType == RACIAL_TYPE_SHAPECHANGER || GetLevelByClass(CLASS_TYPE_SHIFTER, oTarget) == 10) nDuration = 1;

        int iAparienciaAGuardar = GetAppearanceType(oTarget);
        int iAparienciaCambiada = ObtenerIntPersistente(oTarget, "APA_CAMBIADA");
        int iAparienciaOriginal = ObtenerIntPersistente(oTarget, "APA_MEMORIZADA");

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_POLYMORPH_SELF, FALSE));

        if(iAparienciaCambiada == 0) //Solo si no estamos poliformados ya
        {
            int iAparienciaCriatura;
            switch(Random(5))
            {
                case 0: iAparienciaCriatura = 136; break;
                case 1: iAparienciaCriatura = 132; break;
                case 2: iAparienciaCriatura = 133; break;
                case 3: iAparienciaCriatura = 134; break;
                case 4: iAparienciaCriatura = 135; break;
            }

            ePoly = EffectPolymorph(iAparienciaCriatura, TRUE);
            eLink = EffectLinkEffects(eLink, ePoly);

            //Apply the VFX impact and effects
            if(!MyResistSpell(OBJECT_SELF, oTarget))
            {
                if(!MySavingThrow(SAVING_THROW_FORT, oTarget, iCD))
                {
                    AssignCommand(oTarget, ClearAllActions()); // prevenimos cosas raras
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                }
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
