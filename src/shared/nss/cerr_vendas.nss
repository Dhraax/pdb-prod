void removeEfects(object oTarget, int nSkill){
    effect eSearch = GetFirstEffect(oTarget);
    int nType;
    int bDelete;
    int bCurado = 0;
    string sMessage = "<cÇ™Ò>Estados curados: <c¹¸>";
    while(GetIsEffectValid(eSearch)){
        nType = GetEffectType(eSearch);
        bDelete = FALSE;
        if( GetEffectSubType(eSearch) != SUBTYPE_SUPERNATURAL &&
            GetEffectSubType(eSearch) != SUBTYPE_EXTRAORDINARY){
            if(nSkill >= 5 && nType == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE){
                if(bCurado) sMessage += ", ";
                sMessage += "velocidad de movimiento reducido";
                bDelete = TRUE;
                bCurado = TRUE;
            }
            if(nSkill >= 10 && nType == EFFECT_TYPE_SKILL_DECREASE){
                if(bCurado) sMessage += ", ";
                sMessage += "modificador de habilidad reducido";
                bDelete = TRUE;
                bCurado = TRUE;
            }
            if(nSkill >= 15 && nType == EFFECT_TYPE_AC_DECREASE){
                if(bCurado) sMessage += ", ";
                sMessage += "categoría de armadura reducida";
                bDelete = TRUE;
                bCurado = TRUE;
            }
            if(nSkill >= 20 && nType == EFFECT_TYPE_DAMAGE_DECREASE){
                if(bCurado) sMessage += ", ";
                sMessage += "bonificador de daño reducido";
                bDelete = TRUE;
                bCurado = TRUE;
            }
            if(nSkill >= 25 && nType == EFFECT_TYPE_ATTACK_DECREASE){
                if(bCurado) sMessage += ", ";
                sMessage += "bonificador de ataque reducido";
                bDelete = TRUE;
                bCurado = TRUE;
            }
            if(nSkill >= 30 && nType == EFFECT_TYPE_SAVING_THROW_DECREASE){
                if(bCurado) sMessage += ", ";
                sMessage += "bonificador a la tirada de salvación reducido";
                bDelete = TRUE;
                bCurado = TRUE;
            }
            if(nSkill >= 35 && nType == EFFECT_TYPE_POISON){
                if(bCurado) sMessage += ", ";
                sMessage += "envenenamiento";
                bDelete = TRUE;
                bCurado = TRUE;
            }
            if(nSkill >= 40 && nType == EFFECT_TYPE_ABILITY_DECREASE){
                if(bCurado) sMessage += ", ";
                sMessage += "puntuación de característica reducida";
                bDelete = TRUE;
                bCurado = TRUE;
            }
        }
        if(bDelete){
            RemoveEffect(oTarget, eSearch);
        }
        eSearch = GetNextEffect(oTarget);
    }
    if(!bCurado){
        sMessage += "ninguno.";
    } else {
        sMessage += ".";
    }
    SendMessageToPC(OBJECT_SELF, sMessage);
}

void curarCriatura(int puntosCurados, object oTarget, effect fxEffect, int nSkill){
    //El mensaje de informacion de los efectos curados sera
    //visto unicamente por el lanzador.
    removeEfects(oTarget, nSkill);

    effect eHeal = EffectHeal(puntosCurados);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, fxEffect, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
}

void main()
{
    object oActivated = GetItemActivated();
    object oTarget = GetItemActivatedTarget();
    string sTarget = GetTag(oActivated);

    if( GetSubString(sTarget,0,6) == "vendas"){
        int nBono = StringToInt(GetSubString(sTarget,10,2));
        int nTira = d20();
        int nSkill = GetSkillRank(SKILL_HEAL, OBJECT_SELF);
        int nBaseSkill = GetSkillRank(SKILL_HEAL, OBJECT_SELF,TRUE);
        int nHeal = nTira + (nBaseSkill * 2)+ nBono;

        effect fxHeal;

        //Comprueba si es un objetivo valido.
        if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE){
            //Si no es asi lanza un aviso pero las vendas se pierden.
            FloatingTextStringOnCreature("No ha seleccionado un objetivo válido, el material de curandero se pierde.", OBJECT_SELF);
        } else {
            //Obtenemos la cantidad de puntos de golpe del objetivo.
            int nHP = GetCurrentHitPoints(oTarget);

            //Si el objetivo posee mas de 0 puntos de vida.
            if(nHP > 0){
                //Comprobamos que el usuario no se encuentra en combate.
                if(GetIsInCombat(OBJECT_SELF)){
                    //Si se intenta curar a alguien vivo en
                    //combate lanza el mensaje de aviso.
                    FloatingTextStringOnCreature("No es posible utilizar material de curandero en combate.", OBJECT_SELF);
                } else {
                    //En funcion de los puntos de golpe curados se desencadena
                    //un efecto visual distinto.
                    if(nHeal <= 20){
                        fxHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
                    }
                    if(nHeal > 20 && nHeal <=40){
                        fxHeal = EffectVisualEffect(VFX_IMP_HEALING_S);
                    }
                    if(nHeal > 40 && nHeal <=60){
                        fxHeal = EffectVisualEffect(VFX_IMP_HEALING_L);
                    }
                    if(nHeal > 60 && nHeal <=80){
                        fxHeal = EffectVisualEffect(VFX_IMP_HEALING_G);
                    }
                    if(nHeal > 100) {
                        fxHeal = EffectVisualEffect(VFX_IMP_HEALING_X);
                    }

                    //Retenemos al lanzador para evitar su movimiento durante
                    //el asalto de accion.
                    effect eInmobilizado = EffectCutsceneImmobilize();
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInmobilizado, OBJECT_SELF, RoundsToSeconds(1));
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInmobilizado, oTarget, RoundsToSeconds(1));
                    if(oTarget != OBJECT_SELF){
                        AssignCommand(OBJECT_SELF, ClearAllActions(TRUE));
                        AssignCommand(OBJECT_SELF, PlayAnimation(ANIMATION_LOOPING_GET_LOW,1.0,RoundsToSeconds(1)));
                        AssignCommand(oTarget, ClearAllActions(TRUE));
                        AssignCommand(oTarget, PlayAnimation(ANIMATION_LOOPING_SIT_CROSS,1.0,RoundsToSeconds(1)));
                    } else {
                        AssignCommand(OBJECT_SELF, ClearAllActions(TRUE));
                        AssignCommand(OBJECT_SELF, PlayAnimation(ANIMATION_LOOPING_SIT_CROSS,1.0,RoundsToSeconds(1)));
                    }


                    //Al transcurrir el asalto de curacion se curaran tantos
                    //puntos de golpe como puntos se obtuvieron.
                    DelayCommand(RoundsToSeconds(1), curarCriatura(nHeal, oTarget, fxHeal, nSkill));
                }
            } else {
                //Si el objetivo posee menos de 0 puntos de golpe.
                //y si esta agonizando al no haber llegado a -11
                if(nHP > -10){
                    //Curamos la cantidad de puntos necesaria para dejarlo a 0
                    //y evitar que muera en el siguiente asalto.
                    effect eHeal = EffectHeal(abs(nHP));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
                    nTira = d6(3);

                    //Retenemos al lanzador para evitar su movimiento durante
                    //el asalto de accion.
                    effect eInmobilizado = EffectCutsceneImmobilize();
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInmobilizado, OBJECT_SELF, RoundsToSeconds(1));
                    AssignCommand(OBJECT_SELF, ClearAllActions(TRUE));
                    AssignCommand(OBJECT_SELF, PlayAnimation(ANIMATION_LOOPING_GET_LOW,1.0,RoundsToSeconds(1)));

                    //Al transcurrir el asalto de curacion se curaran tantos
                    //puntos de golpe como puntos se obtuvieron.
                    DelayCommand(RoundsToSeconds(1), curarCriatura(nTira, oTarget, EffectVisualEffect(VFX_IMP_RAISE_DEAD), nSkill));
                }
            }
       }
    }
}
