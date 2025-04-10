#include "nw_i0_2q4luskan"
#include "mti_libreria"
#include "sute_libreria"

void main()
{
  // ANTI-SATURAMIENTO DE LA VETA
  if(GetLocalInt(OBJECT_SELF,"LAVETANOSESATURA") == 1) return;
  SetLocalInt(OBJECT_SELF, "LAVETANOSESATURA", 1);
  DelayCommand(3.0, DeleteLocalInt(OBJECT_SELF, "LAVETANOSESATURA"));

  object oPC = GetLastAttacker();

  // SOLO SE PICA CON UN PICO O MAZO DE MINERO
  string sPico = GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
  if(sPico != "mazodeminero" && sPico != "picodeminero")
  {
      DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(0.3, FloatingTextStringOnCreature("*¡No puedes picar la piedra sin un pico o mazo de minero equipado!*", oPC));
      return;
  }

  // NECESITAS TENER NIVEL 1 O MAS PARA SEGUIR PICANDO
  int iNivelHabilidad = ObtenerIntPersistente(oPC, "NIVELMINERIA");
  if(iNivelHabilidad == 0)
  {
      DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(2.0, FloatingTextStringOnCreature("*Quizás debería hablar con algún maestro de Herrería antes de nada*", oPC, FALSE));
      return;
  }

  // EFECTO VISUAL Y SONIDOS DE PIEDRAS
  effect ePiedras = EffectVisualEffect(353);
  string sSonidoPiedrasAleatorio;
  int iTiradaSonidoPiedras = d6();
  if(iTiradaSonidoPiedras == 1) sSonidoPiedrasAleatorio = "as_na_x2iccrmb7";
  else if(iTiradaSonidoPiedras == 2) sSonidoPiedrasAleatorio = "as_na_x2iccrmb6";
  else if(iTiradaSonidoPiedras == 3) sSonidoPiedrasAleatorio = "as_na_x2iccrmb5";
  else if(iTiradaSonidoPiedras == 4) sSonidoPiedrasAleatorio = "as_na_x2iccrmb4";
  else if(iTiradaSonidoPiedras == 5) sSonidoPiedrasAleatorio = "as_na_x2iccrmb3";
  else sSonidoPiedrasAleatorio = "as_na_x2iccrmb2";
  DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePiedras, OBJECT_SELF));
  DelayCommand(0.5, PlaySound(sSonidoPiedrasAleatorio));

  // PROBABILIDAD DE QUE EL PICO O MAZO DE MINERO SE ROMPA
  object oPico = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
  int iUsosPico = GetLocalInt(oPico, "USOSPICO");
  int iTipoPiedra;

  if(iUsosPico == 0) // El pico o mazo es nuevo
  {
      if(sPico == "mazodeminero") SetLocalInt(oPico, "USOSPICO", d6(13));
      else SetLocalInt(oPico, "USOSPICO", d6(20));
  }

  else if(iUsosPico > 0 && iUsosPico < 6) // El pico o mazo se rompe
  {
      DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(0.5, AssignCommand(oPC,PlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED, 1.0, 2.5)));
      DelayCommand(0.8, FloatingTextStringOnCreature("*¡Tu herramienta de minero se ha roto!*", oPC));
      DestroyObject(oPico, 0.8);
      DelayCommand(1.8, PlayVoiceChat(VOICE_CHAT_CUSS, oPC));
      return;
  }

  else // El pico o mazo se gasta
  {
      iTipoPiedra = GetLocalInt(OBJECT_SELF, "TIPOPIEDRA");
      if(iTipoPiedra > 5) // Oro, mithril y adamantita consumen mas rapidamente el pico o mazo
      {
          if(iTipoPiedra == 6)
          {
              SetLocalInt(oPico, "USOSPICO", iUsosPico - d2());
          }

          else if(iTipoPiedra == 7)
          {
              SetLocalInt(oPico, "USOSPICO", iUsosPico - d3());
          }

          else
          {
              SetLocalInt(oPico, "USOSPICO", iUsosPico - d4());
          }
      }

      else
      {
          SetLocalInt(oPico, "USOSPICO", iUsosPico - 1);
      }
  }

  // ANIMACIONES DEL PJ
  DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
  DelayCommand(0.5, AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 0.9)));
  DelayCommand(1.5, AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 1.5)));


  //SEGUN EL TIPO DE VETA NOS HACE DAÑO
  effect eDamage = EffectDamage(2,DAMAGE_TYPE_FIRE);
  if(iTipoPiedra == 12 || iTipoPiedra == 17) ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC);
  else if(iTipoPiedra == 15){ eDamage = EffectDamage(2,DAMAGE_TYPE_ACID); ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC); }
  else if(iTipoPiedra == 5) { eDamage = EffectDamage(2,DAMAGE_TYPE_COLD); ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC); }

  // LA VETA SE AGOTA A DETERMINADOS USOS
  int iUsosVeta = GetLocalInt(OBJECT_SELF, "USOSVETA"); // En las variables del ubicado
  if(iUsosVeta == 0)
  {
      object oGemas;
      // 60% de que salga un yacimiento de gemas
      if(d100() <= 60)
      {
          int id100 = d100();
          if(id100 >= 0 &&  id100 <= 15)            //15%
          {
              oGemas = CreateObject(OBJECT_TYPE_PLACEABLE,"veta_meta",GetLocation(OBJECT_SELF),FALSE);
              DelayCommand(0.8, FloatingTextStringOnCreature("*¡Al agotarse la veta descubres un yacimiento de Piedras Metamórficas!*", oPC));
          }
          else if(id100 >= 16 &&  id100 <= 30)      //15%
          {
              oGemas = CreateObject(OBJECT_TYPE_PLACEABLE,"veta_berilo",GetLocation(OBJECT_SELF),FALSE);
              DelayCommand(0.8, FloatingTextStringOnCreature("*¡Al agotarse la veta descubres un yacimiento de Berilo!*", oPC));
          }
          else if(id100 >= 31 &&  id100 <= 44)       //14%
          {
              oGemas = CreateObject(OBJECT_TYPE_PLACEABLE,"veta_opalos",GetLocation(OBJECT_SELF),FALSE);
              DelayCommand(0.8, FloatingTextStringOnCreature("*¡Al agotarse la veta descubres un yacimiento de Ópalos!*", oPC));
          }
          else if(id100 >= 45 &&  id100 <= 57)        //13%
          {
              oGemas = CreateObject(OBJECT_TYPE_PLACEABLE,"veta_cristal",GetLocation(OBJECT_SELF),FALSE);
              DelayCommand(0.8, FloatingTextStringOnCreature("*¡Al agotarse la veta descubres un yacimiento de Cristal!*", oPC));
          }
          else if(id100 >= 58 &&  id100 <= 69)         //12%
          {
              oGemas = CreateObject(OBJECT_TYPE_PLACEABLE,"veta_maravillosa",GetLocation(OBJECT_SELF),FALSE);
              DelayCommand(0.8, FloatingTextStringOnCreature("*¡Al agotarse la veta descubres un yacimiento de maravillosa!*", oPC));
          }
          else if(id100 >= 70 &&  id100 <= 80)          //11%
          {
              oGemas = CreateObject(OBJECT_TYPE_PLACEABLE,"veta_diamante",GetLocation(OBJECT_SELF),FALSE);
              DelayCommand(0.8, FloatingTextStringOnCreature("*¡Al agotarse la veta descubres un yacimiento de diamante!*", oPC));
          }
          else if(id100 >= 81 &&  id100 <= 90)           //10%
          {
              oGemas = CreateObject(OBJECT_TYPE_PLACEABLE,"veta_costera",GetLocation(OBJECT_SELF),FALSE);
              DelayCommand(0.8, FloatingTextStringOnCreature("*¡Al agotarse la veta descubres un yacimiento de veta costera!*", oPC));
          }
          else if(id100 >= 91 &&  id100 <= 100)         //10%
          {
              oGemas = CreateObject(OBJECT_TYPE_PLACEABLE,"veta_corindon",GetLocation(OBJECT_SELF),FALSE);
              DelayCommand(0.8, FloatingTextStringOnCreature("*¡Al agotarse la veta descubres un yacimiento de Corindón!*", oPC));
          }
      }
      //Tras crear la gema sustituta, si es que se crea...
      //Mensaje.
      DelayCommand(0.8, FloatingTextStringOnCreature("*¡La veta se ha agotado completamente!*", oPC));
      //A las 12 horas, creamos una copia del ubicado actual.
      string sTagUbicado = GetTag(OBJECT_SELF);
      location lLugarActual = GetLocation(OBJECT_SELF);
      DelayCommand(2280.0, CreateObjectVoid(OBJECT_TYPE_PLACEABLE, sTagUbicado, lLugarActual, FALSE));
      //Y cuando se cree, quitamos la pepita de gemas.
      if(GetIsObjectValid(oGemas))
      {DestroyObject(oGemas, 2280.0);}
      SetLocalInt(oGemas, "Heredado", 1);
      //Destruímos finalmente el yacimiento por desgaste.
      DestroyObject(OBJECT_SELF, 0.8);
      return;
  }
  else
  {
      SetLocalInt(OBJECT_SELF, "USOSVETA", (iUsosVeta - 1));
  }

  // LESIONES DE MINERIA (LUXACION DE HOMBRO, LUMBALGIA Y FATIGA)
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
          DelayCommand(2.0, FloatingTextStringOnCreature("*¡Te has fatigado enormemente picando!*", oPC, FALSE));
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
      int iRaza = GetRacialType(oPC);
      int iBonusRacial;
      if(iRaza == RACIAL_TYPE_DWARF) iBonusRacial = d6();
      else if(iRaza == RACIAL_TYPE_HUMAN) iBonusRacial = d3();
      else if(iRaza == RACIAL_TYPE_HALFELF) iBonusRacial = d3();
      else if(iRaza == RACIAL_TYPE_GNOME) iBonusRacial = d4();
      else iBonusRacial = 0;

      //Probabilidad de conseguirlo
      float fProbabilidadExito = (1-((IntToFloat(iDificultad -(iNivelHabilidad * 5 + iBonoFue + iBonusRacial)))/80))*100;
      if(IntToFloat(iTiradaExito) <= (fProbabilidadExito + IntToFloat(GetSkillRank(22,oPC))) )
      {
          //Animacion al conseguirlo
          switch(iTipoPiedra)
          {
              case 1:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Pepita de Hierro!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaHierro", oPC));
                break;

             case 2:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Pepita de Cobre!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaCobre", oPC));
                break;

             case 3:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Pepita de Acero!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaAcero", oPC));
                break;

             case 4:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Pepita de Plata!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaPlata", oPC));
                break;

             case 5:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Pepita de Hierrofrío!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaHierrofrio", oPC));
                break;

             case 6:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Pepita de Oro!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaOro", oPC));
                break;

             case 7:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Pepita de Mithril!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaMithril", oPC));
                break;

             case 8:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Pepita de Adamantita!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaAdamantita", oPC));
                break;

             //deposito de piedra:
             case 9:
                DelayCommand(1.5, FloatingTextStringOnCreature("*Picas la piedra y la mueves a un lado*", oPC));
                break;

             case 10:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Pepita de Dlarun!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaDlarun", oPC));
                break;

            case 11:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Pepita de Hizagkuur!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaHizagkuur", oPC));
                break;

             case 12:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Pepita de Hierro meteórico!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaAceroscuro", oPC));
                break;

             case 13:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Pepita de Platino!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaPlatino", oPC));
                break;

             case 14:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Pepita de Arandur!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaArandur", oPC));
                break;

             case 15:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Pepita de Metal vivo!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaMetalvivo", oPC));
                break;

            case 16:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Pepita de Carbón!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaCarbon", oPC));
                break;

            case 17:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Pepita de Metal derretido!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaDerretido", oPC));
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
              DelayCommand(2.5, PlaySound("gui_level_up"));
              DelayCommand(2.5, FloatingTextStringOnCreature("¡Has subido al nivel " + IntToString(iNivelHabilidad + 1) + " en Minería!", oPC));
              DelayCommand(2.5, SetXP(oPC, GetXP(oPC) + iExperiencia));
              GuardarIntPersistente(oPC, "NIVELMINERIA", iNivelHabilidad + 1);
          }
      }
      else
      {
          DelayCommand(1.5, SendMessageToPC(oPC, "*No consigues extraer ninguna pepita*"));
      }
  }
  else
  {
      DelayCommand(1.5, SendMessageToPC(oPC, "*No consigues extraer ninguna pepita*"));
  }
}
