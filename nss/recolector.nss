#include "nw_i0_2q4luskan"
#include "mti_libreria"
#include "sute_libreria"
#include "lib_race"

void main()
{
    //Variable para que no sature el script
    if(GetLocalInt(OBJECT_SELF,"LAPLANTANOSESATURA") == 1) return;
    SetLocalInt(OBJECT_SELF, "LAPLANTANOSESATURA", 1);
    DelayCommand(3.0, DeleteLocalInt(OBJECT_SELF, "LAPLANTANOSESATURA"));

    object oPC = GetLastAttacker();

    //Comprobamos si tiene equipado el cuchillo de recolector
    string sCuchillo = GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
    if((sCuchillo != "cuchillorecolector")&&(sCuchillo != "hozrecolector")){
        DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
        DelayCommand(0.3, FloatingTextStringOnCreature("*¡No puedes recoger plantas sin un cuchillo de recolección equipado!*", oPC));
        return;
    }

    //Condiciones especiales
    int iTipoPlanta= GetLocalInt(OBJECT_SELF, "TIPOPLANTA");
    if (iTipoPlanta>5){
       if ((iTipoPlanta==6)&&(GetIsDay()==FALSE)){
          DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
          DelayCommand(0.3, FloatingTextStringOnCreature("*¡Las Flores Luminosas solo salen de día!*", oPC));
          return;
       }else if ((iTipoPlanta==7)&&(GetIsNight()==FALSE)){
          DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
          DelayCommand(0.3, FloatingTextStringOnCreature("*¡Las Setas Nocturnas solo surgen de noche!*", oPC));
          return;
       }else if ((iTipoPlanta==8)&&(!GetHasEffect(EFFECT_TYPE_SEEINVISIBLE,oPC))&&(!GetHasEffect(EFFECT_TYPE_TRUESEEING,oPC))){
          DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
          DelayCommand(0.3, FloatingTextStringOnCreature("*¡No puedes recolectar Frutos Fantasma, no los ves!*", oPC));
          return;
       }
    }

    //Sonido de recolectar plantas
    string sSonidoPlantasAleatorio;
    int iTiradaSonidoPlantas = d6();
    if(iTiradaSonidoPlantas == 1) sSonidoPlantasAleatorio = "as_na_bushmove1";
    else if(iTiradaSonidoPlantas == 2) sSonidoPlantasAleatorio = "as_na_bushmove2";
    else if(iTiradaSonidoPlantas == 3) sSonidoPlantasAleatorio = "as_na_leafmove1";
    else if(iTiradaSonidoPlantas == 4) sSonidoPlantasAleatorio = "as_na_leafmove2";
    else if(iTiradaSonidoPlantas == 5) sSonidoPlantasAleatorio = "as_na_leafmove3";
    else sSonidoPlantasAleatorio = "as_na_branchsnp1";
    DelayCommand(0.3, PlaySound(sSonidoPlantasAleatorio));
    int iUsosPlanta= GetLocalInt(OBJECT_SELF, "USOSPLANTA");
    if (iUsosPlanta== 0)
    {
        DelayCommand(0.8, FloatingTextStringOnCreature("*¡La planta se ha agotado completamente!*", oPC));
        //A las 12 horas, creamos una copia del ubicado actual.
        string sTagUbicado = GetTag(OBJECT_SELF);
        location lLugarActual = GetLocation(OBJECT_SELF);
        DelayCommand(2280.0, CreateObjectVoid(OBJECT_TYPE_PLACEABLE, sTagUbicado, lLugarActual, FALSE));
        return;
    }
    else
    {
       SetLocalInt(OBJECT_SELF, "USOSPLANTA", (iUsosPlanta-1));
    }

    //Ponemos la probabilidad de que el cuchillo se rompa
    object oCuchillo = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    int iUsosCuchillo= GetLocalInt(oCuchillo, "USOSCUCHILLO");
    if(iUsosCuchillo == 0){
       if (sCuchillo == "cuchillorecolector"){
          SetLocalInt(oCuchillo, "USOSCUCHILLO", d6(6));
       }else{
          SetLocalInt(oCuchillo, "USOSCUCHILLO", d6(24));
       }
    }else if(iUsosCuchillo == 1){
        DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
        DelayCommand(0.5, AssignCommand(oPC,PlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED, 1.0, 2.5)));
        DelayCommand(0.8, FloatingTextStringOnCreature("*¡Tu herramienta de recolección se ha roto!*", oPC));
        DestroyObject(oCuchillo, 0.8);
        DelayCommand(1.8, PlayVoiceChat(VOICE_CHAT_CUSS ,oPC));
        return;
    }
    else SetLocalInt(oCuchillo, "USOSCUCHILLO", iUsosCuchillo - 1);

    //Posibilidad de lesiones
    int iLesion = d100(1);
    if (iLesion <= 3){
        //Envenenamiento
        if(iLesion == 1){
            effect e2 = EffectPoison(POISON_WRAITH_SPIDER_VENOM);
            DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oPC));
            DelayCommand(2.0, FloatingTextStringOnCreature("*¡Te ha picado algo!*", oPC));
            DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(84), GetLocation(oPC)));
            return;
        }
        //Lumbalgia
        if(iLesion == 2){
            effect e1 = EffectAbilityDecrease(ABILITY_CONSTITUTION,3);
            effect e2 = EffectAbilityDecrease(ABILITY_DEXTERITY,3);
            effect e3 = EffectMovementSpeedDecrease(30);
            DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e3, oPC));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oPC));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oPC));
            DelayCommand(2.0, FloatingTextStringOnCreature("*¡Te ha dado un terrible dolor de espalda!*", oPC));
            DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(75), GetLocation(oPC)));
            return;
        }
        //Luxacion de munyeca
        if(iLesion == 3){
            int iHP = GetCurrentHitPoints(oPC);
            effect e1 = EffectAbilityDecrease(ABILITY_STRENGTH,2);
            effect e2 = EffectAbilityDecrease(ABILITY_DEXTERITY,2);
            effect e3 = EffectDamage(iHP/8,DAMAGE_TYPE_SLASHING,DAMAGE_POWER_PLUS_TWENTY);
            DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oPC));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oPC));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oPC));
            DelayCommand(2.0, FloatingTextStringOnCreature("*¡Te has hecho un esguince en la mano!*", oPC));
            DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(75), GetLocation(oPC)));
            return;
        }
    }

    //Animacion del PJ
    DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
    DelayCommand(0.5, AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 0.9)));
    DelayCommand(1.5, AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 1.5)));

    //Porcentage de acceso a la formula de exito
    int iNivelHabilidad = ObtenerIntPersistente(oPC, "NIVELRECOLECCION");
    //No tiene ni el nivel 1 en la habilidad
    if (iNivelHabilidad==0){
        DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
        DelayCommand(2.0, FloatingTextStringOnCreature("*Quizá deberías hablar con algún Maestro de Herboristería antes de nada...*", oPC, FALSE));
        return;
    }
    int iTiradaAcceso = d100();
    int iBonoTiradaAcceso = (iNivelHabilidad/4);
    //25% a nivel 0 // 30% a nivel 20 // 40% a nivel 60 // etc. (maximo 50%)
    if(iTiradaAcceso + iBonoTiradaAcceso >= 75){
       //Formula de exito
       int iTiradaExito = d100();
       int iBonoSab = bonoRealCaracteristicaPJ(ABILITY_WISDOM, oPC)*2;
       int iDificultad= GetLocalInt(OBJECT_SELF, "DIFICULTAD");

       //Bono de raza
       int iRaza= GetRacialType(oPC);
       int iBonusRacial;
       if(PB_Race_GetIsElf(oPC)) iBonusRacial = d6();
       else if(iRaza == RACIAL_TYPE_HUMAN) iBonusRacial = d3();
       else if(iRaza == RACIAL_TYPE_HALFELF) iBonusRacial = d3();
       else if(PB_Race_GetIsHalfling(oPC)) iBonusRacial = d4();
       else iBonusRacial = 0;

       //Probabilidad de conseguirlo
       float fProbabilidadExito= (1-((IntToFloat(iDificultad-(iNivelHabilidad*5 + iBonoSab + iBonusRacial)))/80))*100;
       if(IntToFloat(iTiradaExito) <= (fProbabilidadExito+ IntToFloat(GetSkillRank(22,oPC))) ){
          //Animacion al conseguirlo
          effect ePlantas;
          switch (iTipoPlanta){
             case 1:
                ePlantas = EffectVisualEffect(149);
                DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, ePlantas, GetLocation(OBJECT_SELF)));
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Baya Acuosa!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("bayaAcuosa", oPC));
                break;
             case 2:
                ePlantas = EffectVisualEffect(62);
                DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, ePlantas, GetLocation(OBJECT_SELF)));
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Brisa Susurrante!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("brisaSusurrante", oPC));
                break;
             case 3:
                ePlantas = EffectVisualEffect(353);
                DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePlantas, OBJECT_SELF));
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un poco de Resina Subterránea!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("resinaSubterranea", oPC));
                break;
             case 4:
                ePlantas = EffectVisualEffect(60);
                DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, ePlantas, GetLocation(OBJECT_SELF)));
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un Ardor Desértico!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("ardorDesertico", oPC));
                break;
             case 5:
                ePlantas = EffectVisualEffect(302);
                DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, ePlantas, GetLocation(OBJECT_SELF)));
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Raíz Pétrea!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("raizPetrea", oPC));
                break;
             case 6:
                ePlantas = EffectVisualEffect(98);
                DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, ePlantas, GetLocation(OBJECT_SELF)));
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Flor Luminosa!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("florLuminosa", oPC));
                break;
             case 7:
                ePlantas = EffectVisualEffect(217);
                DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, ePlantas, GetLocation(OBJECT_SELF)));
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Seta Nocturna!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("setaNocturna", oPC));
                break;
             case 8:
                ePlantas = EffectVisualEffect(407);
                DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, ePlantas, GetLocation(OBJECT_SELF)));
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un Fruto Fantasma!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("frutoFantasma", oPC));
                break;
             default:
                break;
          }
          // Formula de subida de nivel
          int iTiradaAprendizaje = d100();
          int iBonoInt = bonoRealCaracteristicaPJ(ABILITY_INTELLIGENCE, oPC);
          float fProbablidadAprendizaje= ((IntToFloat(iDificultad-(iNivelHabilidad*5)+iBonoInt))/80)*100;
          if((iNivelHabilidad<100)&&(IntToFloat(iTiradaAprendizaje) <= fProbablidadAprendizaje)){
              int iExperiencia = (iNivelHabilidad + 1)/2;
              if(iExperiencia == 0) iExperiencia = 1;
              else if(iExperiencia > 50) iExperiencia = 50;
              DelayCommand(2.5, PlaySound("gui_level_up"));
              DelayCommand(2.5, FloatingTextStringOnCreature("¡Has subido al nivel " + IntToString(iNivelHabilidad + 1) + " en Recolección!", oPC));
              DelayCommand(2.5, SetXP(oPC, GetXP(oPC) + iExperiencia));
              GuardarIntPersistente(oPC, "NIVELRECOLECCION", iNivelHabilidad + 1);
          }
      }
    }
}
