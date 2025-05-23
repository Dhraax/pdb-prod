#include "mti_libreria"
#include "sute_libreria"
#include "lib_race"

void main()
{
    object oPC= GetLastClosedBy();
    object oMarmita= OBJECT_SELF;
    object oBorrado;

    if(GetLocalInt(oMarmita, "PASO")==0){
       oBorrado = GetFirstItemInInventory();
       while (GetIsObjectValid(oBorrado)){
          DestroyObject(oBorrado);
          oBorrado = GetNextItemInInventory();
       }
       return;
    }

    //Posibilidad de lesiones
    int iLesion = d100(1);
    if (iLesion <= 3){
       //Inhalación
       if(iLesion == 1){
          effect e1 = EffectAbilityDecrease(ABILITY_CONSTITUTION,4);
          effect e2 = EffectPoison(POISON_WRAITH_SPIDER_VENOM);
          DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oPC));
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oPC));
          DelayCommand(2.0, FloatingTextStringOnCreature("*¡Has inhalado vapores nocivos!*", oPC));
          DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(84), GetLocation(oPC)));
       }
       //Cae la Marmita
       if(iLesion == 2){
          effect e2 = EffectAbilityDecrease(ABILITY_DEXTERITY,4);
          effect e3 = EffectMovementSpeedDecrease(30);
          DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e3, oPC));
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oPC));
          DelayCommand(2.0, FloatingTextStringOnCreature("*¡Se te ha caído la marmita en el pie!*", oPC));
          DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(75), GetLocation(oPC)));
       }
       //Quemadura
       if(iLesion == 3){
          int iHP = GetCurrentHitPoints(oPC);
          effect e1 = EffectAbilityDecrease(ABILITY_CHARISMA,2);
          effect e2 = EffectAbilityDecrease(ABILITY_DEXTERITY,2);
          effect e3 = EffectDamage(iHP/8,DAMAGE_TYPE_ACID,DAMAGE_POWER_PLUS_TWENTY);
          DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oPC));
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oPC));
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oPC));
          DelayCommand(2.0, FloatingTextStringOnCreature("*¡Te has quemado con una salpicadura!*", oPC));
          DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(61), GetLocation(oPC)));
       }
       oBorrado = GetFirstItemInInventory();
       effect eFracaso= EffectVisualEffect(57);
       DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFracaso, GetLocation(OBJECT_SELF)));
       while (GetIsObjectValid(oBorrado)){
          DestroyObject(oBorrado);
          oBorrado = GetNextItemInInventory();
       }
       SetLocalInt(oMarmita, "PASO", 0);
       return;
    }

    // Animacion del PJ
    DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
    DelayCommand(0.5, AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 0.9)));

    //Porcentage de acceso a la formula de exito
    int iNivelHabilidad = ObtenerIntPersistente(oPC, "NIVELCOCINA");
    //No tiene ni el nivel 1 en la habilidad
    if (iNivelHabilidad==0){
        DelayCommand(1.5, AssignCommand(oPC,ClearAllActions(TRUE)));
        DelayCommand(1.5, FloatingTextStringOnCreature("*Quizá deberías hablar con algún Maestro de Herboristería antes de nada...*", oPC));
        SetLocalInt(oMarmita, "PASO", 0);
        return;
    }
    int iTiradaAcceso = d100();
    int iBonoTiradaAcceso = (iNivelHabilidad/4);
    //70% a nivel 0 // 75% a nivel 20 // 85% a nivel 60 // etc. (mínimo 95%)
    if(iTiradaAcceso + iBonoTiradaAcceso >= 30){
       //Miramos cantidades de plantas y su tipo
       int nBayaAcuosa = 0;
       int nBrisaSusurrante = 0;
       int nResinaSubterranea = 0;
       int nArdorDesertico= 0;
       int nRaizPetrea= 0;
       int nFlorLuminosa= 0;
       int nSetaNocturna= 0;
       int nFrutoFantasma= 0;
       string sIngredienteTag;
       object oIngrediente = GetFirstItemInInventory();
       while (GetIsObjectValid(oIngrediente))
           {
           sIngredienteTag = GetTag(oIngrediente);
           if(sIngredienteTag == "bayaAcuosa"){
              nBayaAcuosa = nBayaAcuosa + 1;
           }else if(sIngredienteTag == "brisaSusurrante"){
              nBrisaSusurrante = nBrisaSusurrante + 1;
           }else if(sIngredienteTag == "resinaSubterranea"){
              nResinaSubterranea = nResinaSubterranea + 1;
           }else if(sIngredienteTag == "ardorDesertico"){
              nArdorDesertico = nArdorDesertico + 1;
           }else if(sIngredienteTag == "raizPetrea"){
              nRaizPetrea = nRaizPetrea + 1;
           }else if(sIngredienteTag == "florLuminosa"){
              nFlorLuminosa = nFlorLuminosa + 1;
           }else if(sIngredienteTag == "setaNocturna"){
              nSetaNocturna = nSetaNocturna + 1;
           }else if(sIngredienteTag == "frutoFantasma"){
              nFrutoFantasma = nFrutoFantasma + 1;
           }
           oIngrediente = GetNextItemInInventory();
       }

        string sTipoPlanta= "";
        int iDificultad= 0;
        string sComponente;
        string sComponenteTag;
        effect eExito;
        if(nBayaAcuosa>2){
           sTipoPlanta= "bayaAcuosa";
           iDificultad= 80;
           sComponente= "Zumo Acuoso";
           sComponenteTag= "zumoAcuoso";
           eExito= EffectVisualEffect(149);
        }else if(nBrisaSusurrante>2){
           sTipoPlanta= "brisaSusurrante";
           iDificultad= 145;
           sComponente= "Humo Gaseoso";
           sComponenteTag= "humoGaseoso";
           eExito= EffectVisualEffect(62);
        }else if(nResinaSubterranea>2){
           sTipoPlanta= "resinaSubterranea";
           iDificultad= 205;
           sComponente= "Pasta Terrosa";
           sComponenteTag= "pastaTerrosa";
           eExito= EffectVisualEffect(353);
        }else if(nArdorDesertico>2){
           sTipoPlanta= "ardorDesertico";
           iDificultad= 270;
           sComponente= "Especia Sulfurosa";
           sComponenteTag= "especiaSulfurosa";
           eExito= EffectVisualEffect(60);
        }else if(nRaizPetrea>2){
           sTipoPlanta= "raizPetrea";
           iDificultad= 330;
           sComponente= "Picada Rocosa";
           sComponenteTag= "picadaRocosa";
           eExito= EffectVisualEffect(302);
        }else if(nFlorLuminosa>2){
           sTipoPlanta= "florLuminosa";
           iDificultad= 395;
           sComponente= "Virutas Resplandecientes";
           sComponenteTag= "virutasResplandecientes";
           eExito= EffectVisualEffect(98);
        }else if(nSetaNocturna>2){
           sTipoPlanta= "setaNocturna";
           iDificultad= 455;
           sComponente= "Limo Putrefacto";
           sComponenteTag= "limoPutrefacto";
           eExito= EffectVisualEffect(217);
        }else if(nFrutoFantasma>2){
           sTipoPlanta= "frutoFantasma";
           iDificultad= 520;
           sComponente= "Esencia Invisible";
           sComponenteTag= "esenciaInvisible";
           eExito= EffectVisualEffect(407);
        }else{
           DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
           DelayCommand(2.0, FloatingTextStringOnCreature("*¡No has puesto las cantidades exactas y se te han quemado las plantas!*", oPC));
           oBorrado = GetFirstItemInInventory();
           effect eFracaso= EffectVisualEffect(57);
           DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFracaso, GetLocation(OBJECT_SELF)));
           while (GetIsObjectValid(oBorrado)){
              DestroyObject(oBorrado);
              oBorrado = GetNextItemInInventory();
           }
           SetLocalInt(oMarmita, "PASO", 0);
           return;
        }

        //Formula de exito
        int iTiradaExito = d100();
        int iBonoSab = bonoRealCaracteristicaPJ(ABILITY_WISDOM, oPC)*2;

        //Bono Racial
        int iRaza= GetRacialType(oPC);
        int iBonusRacial;
        if(PB_Race_GetIsElf(oPC)) iBonusRacial = d6();
        else if(iRaza == RACIAL_TYPE_HUMAN) iBonusRacial = d3();
        else if(iRaza == RACIAL_TYPE_HALFELF) iBonusRacial = d3();
        else if(PB_Race_GetIsHalfling(oPC)) iBonusRacial = d4();
        else iBonusRacial = 0;

        //Probabilidad de conseguirlo
        float fProbabilidadExito= (1-((IntToFloat(iDificultad-(iNivelHabilidad*5 + iBonoSab + iBonusRacial)))/80))*100;
        if(IntToFloat(iTiradaExito) <= (fProbabilidadExito + IntToFloat(GetSkillRank(22,oPC)) ) )
        {
          DelayCommand(2.0, FloatingTextStringOnCreature(("*¡Has conseguido el ingrediente: "+ sComponente+ "!*"), oPC));
          DelayCommand(2.0, FuncionCrearObjetoYTag(sComponenteTag, oPC));
          DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExito, GetLocation(OBJECT_SELF)));

          //Formula de subida de nivel
          int iTiradaAprendizaje = d100();
          int iBonoInt = bonoRealCaracteristicaPJ(ABILITY_INTELLIGENCE, oPC);
          float fProbablidadAprendizaje= ((IntToFloat(iDificultad-(iNivelHabilidad*5)+iBonoInt))/80)*100;
          if((iNivelHabilidad<100)&&(IntToFloat(iTiradaAprendizaje) <= fProbablidadAprendizaje))
          {
              int iExperiencia = (iNivelHabilidad + 1)/2;
              if(iExperiencia == 0) iExperiencia = 1;
              else if(iExperiencia > 50) iExperiencia = 50;
              DelayCommand(2.5, PlaySound("gui_level_up"));
              DelayCommand(2.5, FloatingTextStringOnCreature("¡Has subido al nivel " + IntToString(iNivelHabilidad + 1) + " en Cocina!", oPC));
              DelayCommand(2.5, SetXP(oPC, GetXP(oPC) + iExperiencia));
              GuardarIntPersistente(oPC, "NIVELCOCINA", iNivelHabilidad + 1);
          }
       }else{
          DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
          DelayCommand(2.0, FloatingTextStringOnCreature("*Vaya, se te han quemado las plantas...*", oPC));
          effect eFracaso= EffectVisualEffect(57);
          DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFracaso, GetLocation(OBJECT_SELF)));
       }
       oBorrado = GetFirstItemInInventory();
       while (GetIsObjectValid(oBorrado)){
          DestroyObject(oBorrado);
          oBorrado = GetNextItemInInventory();
       }
       SetLocalInt(oMarmita, "PASO", 0);
       return;
    }else{
       DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
       DelayCommand(2.0, FloatingTextStringOnCreature("*Vaya, se te han quemado las plantas...*", oPC));
       effect eFracaso= EffectVisualEffect(57);
       DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFracaso, GetLocation(OBJECT_SELF)));
       oBorrado = GetFirstItemInInventory();
       while (GetIsObjectValid(oBorrado)){
          DestroyObject(oBorrado);
          oBorrado = GetNextItemInInventory();
       }
       SetLocalInt(oMarmita, "PASO", 0);
       return;
    }
    SetLocalInt(oMarmita, "PASO", 0);
}
