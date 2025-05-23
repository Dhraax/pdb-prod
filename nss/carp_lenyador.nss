#include "nw_i0_2q4luskan"
#include "mti_libreria"
#include "sute_libreria"
#include "lib_race"

void CrearToconConDelay(location lLugar)
{
    CreateObject(OBJECT_TYPE_PLACEABLE, "carp_tocon", lLugar);
}

void main()
{
  // ANTI-SATURAMIENTO DEL ARBOL
  if(GetLocalInt(OBJECT_SELF,"ELARBOLNOSESATURA") == 1) return;
  SetLocalInt(OBJECT_SELF, "ELARBOLNOSESATURA", 1);
  DelayCommand(3.0, DeleteLocalInt(OBJECT_SELF, "ELARBOLNOSESATURA"));

  object oPC = GetLastAttacker();

  // SOLO SE TALA CON UN HACHA DE LENYADOR
  string sHacha = GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
  if(sHacha != "carp_hl" && sHacha != "carp_hlp")
  {
      DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(0.3, FloatingTextStringOnCreature("*¡No puedes talar el árbol sin un hacha de leñador equipada!*", oPC));
      return;
  }

  // NECESITAS TENER NIVEL 1 O MAS PARA SEGUIR TALANDO
  int iNivelHabilidad = ObtenerIntPersistente(oPC, "NIVELLENYADOR");
  if(iNivelHabilidad == 0)
  {
      DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(2.0, FloatingTextStringOnCreature("*Quizás debería hablar con algún maestro de Carpintería antes de nada*", oPC, FALSE));
      return;
  }

  // EFECTO VISUAL Y SONIDOS DE MADERA
  effect eAire = EffectVisualEffect(460);
  string sSonidoMaderaAleatorio;
  int iTiradaSonidoMadera = d4();
  if(iTiradaSonidoMadera == 1) sSonidoMaderaAleatorio = "as_cv_woodbreak1";
  else if(iTiradaSonidoMadera == 2) sSonidoMaderaAleatorio = "as_cv_woodbreak2";
  else if(iTiradaSonidoMadera == 3) sSonidoMaderaAleatorio = "as_cv_woodbreak3";
  else sSonidoMaderaAleatorio = "cb_bu_woodsml";

  DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eAire, GetLocation(OBJECT_SELF)));
  DelayCommand(0.5, AssignCommand(OBJECT_SELF, PlaySound(sSonidoMaderaAleatorio)));

  // PROBABILIDAD DE QUE EL HACHA DE LENYADOR DE ROMPA
  object oHacha = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
  int iUsosHacha = GetLocalInt(oHacha, "USOSHACHA");
  int iTipoArbol;

  if(iUsosHacha == 0) // El hacha es nueva
  {
      if(sHacha == "carp_hlp") SetLocalInt(oHacha, "USOSHACHA", d6(11));
      else SetLocalInt(oHacha, "USOSHACHA", d6(20));
  }

  else if(iUsosHacha > 0 && iUsosHacha < 6) // El hacha se rompe
  {
      DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(0.5, AssignCommand(oPC,PlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED, 1.0, 2.5)));
      DelayCommand(0.8, FloatingTextStringOnCreature("*¡Tu herramienta de leñador se ha roto!*", oPC));
      DestroyObject(oHacha, 0.8);
      DelayCommand(1.8, PlayVoiceChat(VOICE_CHAT_CUSS, oPC));
      return;
  }

  else // El hacha se gasta
  {
      iTipoArbol = GetLocalInt(OBJECT_SELF, "TIPOARBOL");
      if(iTipoArbol > 5) // Olmo, roble y fresno consumen mas rapidamente el hacha
      {
          if(iTipoArbol == 6)
          {
              SetLocalInt(oHacha, "USOSHACHA", iUsosHacha - d2());
          }

          else if(iTipoArbol == 7)
          {
              SetLocalInt(oHacha, "USOSHACHA", iUsosHacha - d3());
          }

          else
          {
              SetLocalInt(oHacha, "USOSHACHA", iUsosHacha - d4());
          }
      }

      else
      {
          SetLocalInt(oHacha, "USOSHACHA", iUsosHacha - 1);
      }
  }

  // ANIMACIONES DEL PJ
  DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
  DelayCommand(0.5, AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 0.9)));
  DelayCommand(1.5, AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 1.5)));

  // EL ARBOL SE AGOTA A DETERMINADOS USOS
  int iUsosArbol = GetLocalInt(OBJECT_SELF, "USOSARBOL"); // En las variables del ubicado
  if(iUsosArbol == 0)
  {
      //Creamos un tocón.
      object oTocon = CreateObject(OBJECT_TYPE_PLACEABLE, "carp_tocon", GetLocation(OBJECT_SELF));
      //Lanzamos el mensjae.
      DelayCommand(0.7, FloatingTextStringOnCreature("*¡Has talado por completo el árbol!*", oPC));
      //A las 12 horas, creamos una copia del ubicado actual.
      string sTagUbicado = GetTag(OBJECT_SELF);
      location lLugarActual = GetLocation(OBJECT_SELF);
      DelayCommand(2280.0, CreateObjectVoid(OBJECT_TYPE_PLACEABLE, sTagUbicado, lLugarActual, FALSE));
      //Y cuando se cree, quitamos el tocón.
      if(GetIsObjectValid(oTocon))
      {DestroyObject(oTocon, 2280.0);}
      //Destruímos finalmente el árbol.
      DestroyObject(OBJECT_SELF, 0.8);
      return;
  }
  else
  {
      SetLocalInt(OBJECT_SELF, "USOSARBOL", iUsosArbol - 1);
  }

  // LESIONES DE LEÑADOR (LUXACION DE HOMBRO, LUMBALGIA Y FATIGA)
  int iLesion = d100(1);
  if(iLesion <= 3)
  {
      // Luxacion de hombro
      if(iLesion == 1)
      {
          int iHP = GetCurrentHitPoints(oPC);
          effect e1 = EffectAbilityDecrease(ABILITY_STRENGTH,6);
          effect e2 = EffectAbilityDecrease(ABILITY_DEXTERITY,6);
          effect e3 = EffectDamage(iHP/4,DAMAGE_TYPE_SLASHING,DAMAGE_POWER_PLUS_TWENTY);
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oPC));
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oPC));
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oPC));
          DelayCommand(2.0, FloatingTextStringOnCreature("*¡Te has hecho una luxación en el hombro!*", oPC, FALSE));
          return;
      }

      // Lumbalgia
      else if(iLesion == 2)
      {
          effect e1 = EffectAbilityDecrease(ABILITY_CONSTITUTION,3);
          effect e2 = EffectAbilityDecrease(ABILITY_DEXTERITY,3);
          effect e3 = EffectMovementSpeedDecrease(30);
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e3, oPC));
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oPC));
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oPC));
          DelayCommand(2.0, FloatingTextStringOnCreature("*¡Te ha dado un terrible dolor de espalda!*", oPC, FALSE));
          return;
      }

      // Fatiga
      else
      {
          effect e1 = EffectAbilityDecrease(ABILITY_CONSTITUTION,4);
          effect e2 = EffectMovementSpeedDecrease(20);
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oPC));
          DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oPC));
          DelayCommand(2.0, FloatingTextStringOnCreature("*¡Te has fatigado enormemente talando!*", oPC, FALSE));
          return;
      }
  }

  // ACCESO A LA FORMULA DE EXITO (PRIMERA TIRADA)
  int iTiradaAcceso = d100();
  int iBonoTiradaAcceso = (iNivelHabilidad/2);

  // 25% a nivel 0
  // 35% a nivel 20
  // 55% a nivel 60
  // 75% a nivel 100
  if(iTiradaAcceso + iBonoTiradaAcceso >= 75)
  {
      // FORMULA DE EXITO (SEGUNDA TIRADA)
      int iTiradaExito = d100();
      int iBonoFue = bonoRealCaracteristicaPJ(ABILITY_STRENGTH, oPC) * 2;
      int iDificultad = GetLocalInt(OBJECT_SELF, "DIFICULTAD");

      // Bonos raciales
      int iRaza= GetRacialType(oPC);
      int iBonusRacial;
      if(PB_Race_GetIsElf(oPC)) iBonusRacial = d6();
      else if(iRaza == RACIAL_TYPE_HALFELF) iBonusRacial = d4();
      else if(iRaza == RACIAL_TYPE_DWARF) iBonusRacial = d3();
      else if(iRaza == RACIAL_TYPE_HUMAN) iBonusRacial = d3();
      else if(iRaza == RACIAL_TYPE_GNOME) iBonusRacial = d3();
      else iBonusRacial = 0;

      //Probabilidad de conseguirlo
      float fProbabilidadExito = (1-((IntToFloat(iDificultad -(iNivelHabilidad * 5 + iBonoFue + iBonusRacial)))/80))*100;
      if(IntToFloat(iTiradaExito) <= (fProbabilidadExito + IntToFloat(GetSkillRank(22,oPC)) ) )
      {
          //Animacion al conseguirlo
          switch(iTipoArbol)
          {
              case 1:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un leño de pino!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("carplenyo_pino", oPC));
                break;

             case 2:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un leño de cedro!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("carplenyo_cipres", oPC));
                break;

             case 3:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un leño de abeto!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("carplenyo_abeto", oPC));
                break;

             case 4:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un leño de roble!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("carplenyo_cedro", oPC));
                break;

             case 5:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un leño de sombralto!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("carplenyo_alamo", oPC));
                break;

             case 6:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un leño de arbol del crepusculo!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("carplenyo_olmo", oPC));
                break;

             case 7:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un leño de zalantar!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("carplenyo_roble", oPC));
                break;

             case 8:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un leño de maderadique!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("carplenyo_fresno", oPC));
                break;

             default:
                break;
          }

          // SUBIDA DE NIVEL (TERCERA TIRADA)
          int iTiradaAprendizaje = d100();
          int iBonoInt = bonoRealCaracteristicaPJ(ABILITY_INTELLIGENCE, oPC);
          float fProbablidadAprendizaje= ((IntToFloat(iDificultad-(iNivelHabilidad*5)+iBonoInt))/80)*100;

          if(iNivelHabilidad < 100 && (IntToFloat(iTiradaAprendizaje) <= fProbablidadAprendizaje))
          {
              int iExperiencia = (iNivelHabilidad + 1)/2;
              if(iExperiencia == 0) iExperiencia = 1;
              else if(iExperiencia > 50) iExperiencia = 50;
              DelayCommand(2.5, AssignCommand(OBJECT_SELF, PlaySound("gui_level_up")));
              DelayCommand(2.5, FloatingTextStringOnCreature("¡Has subido al nivel " + IntToString(iNivelHabilidad + 1) + " en Tala de árboles!", oPC));
              DelayCommand(2.5, SetXP(oPC, GetXP(oPC) + iExperiencia));
              GuardarIntPersistente(oPC, "NIVELLENYADOR", iNivelHabilidad + 1);
          }
      }
      else
      {
          DelayCommand(1.5, SendMessageToPC(oPC, "*No consigues talar ningún leño*"));
      }
  }
  else
  {
      DelayCommand(1.5, SendMessageToPC(oPC, "*No consigues talar ningún leño*"));
  }
}
