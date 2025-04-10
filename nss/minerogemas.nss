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
  if(sPico != "picodegemas" && sPico != "mazodeminero" && sPico != "picodeminero")
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
      if(sPico == "picodegemas") SetLocalInt(oPico, "USOSPICO", d6(15));
      else SetLocalInt(oPico, "USOSPICO", d6(20));
  }

  else if(iUsosPico > 0 && iUsosPico < 6) // El pico o mazo se rompe
  {
      DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(0.5, AssignCommand(oPC,PlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED, 1.0, 2.5)));
      DelayCommand(0.8, FloatingTextStringOnCreature("*¡Tu pico de gemas se ha roto!*", oPC));
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

  // LA VETA SE AGOTA A DETERMINADOS USOS
  int iUsosVeta = GetLocalInt(OBJECT_SELF, "USOSVETA"); // En las variables del ubicado
  if(iUsosVeta == 0)
  {
      DelayCommand(0.8, FloatingTextStringOnCreature("*¡El yacimiento se ha agotado completamente!*", oPC));
      //A las 12 horas, creamos una copia del ubicado actual.
      string sTagUbicado = GetTag(OBJECT_SELF);
      location lLugarActual = GetLocation(OBJECT_SELF);
      if(GetLocalInt(OBJECT_SELF, "Heredado") != 1)
      {
        DelayCommand(2280.0, CreateObjectVoid(OBJECT_TYPE_PLACEABLE, sTagUbicado, lLugarActual, FALSE));
      }
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
      else if(iRaza == RACIAL_TYPE_GNOME) iBonusRacial = d6();
      else iBonusRacial = 0;

      //Probabilidad de conseguirlo
      float fProbabilidadExito = (1-((IntToFloat(iDificultad -(iNivelHabilidad * 5 + iBonoFue + iBonusRacial)))/80))*100;
      if(IntToFloat(iTiradaExito) <= fProbabilidadExito)
      {
          int id100 = d100();
          //Animacion al conseguirlo
          switch(iTipoPiedra)
          {
case 1:
                               if(id100 >= 0 &&  id100 <= 35)            //35%
                                    {
                                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un Cuarzo hilaino en bruto!*", oPC));
                                DelayCommand(1.5, FuncionCrearObjetoYTag("bru_cuarzo", oPC));
                                    }
                               else if(id100 >= 36 &&  id100 <= 65)     //30%
                                    {
                                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Obsidiana  en bruto!*", oPC));
                                DelayCommand(1.5, FuncionCrearObjetoYTag("bru_obs", oPC));
                                    }
                                else if(id100 >= 66 &&  id100 <= 85)   //20%
                                    {
                               DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un Azabache en bruto!*", oPC));
                               DelayCommand(1.5, FuncionCrearObjetoYTag("bru_aza", oPC));
                                    }
                               else if(id100 >= 86 &&  id100 <= 95)            //10%
                        {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Amatista en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_per", oPC));
                        }
                    else if(id100 >= 96 &&  id100 <= 100)            //5%
                        {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un Corvidar en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_cor", oPC));
                        }
                    break;

case 2:
                    if(id100 >= 0 &&  id100 <= 55)            //55%
                        {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Amatista en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_per", oPC));
                    }
                    else if(id100 >= 56 &&  id100 <= 85)     //30%
                    {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un Topacio en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_top", oPC));
                    }
                    else if(id100 >= 86 &&  id100 <= 100)     //15%
                    {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Esmeralda en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_esme", oPC));
                    }
                    break;

case 3:
                    if(id100 >= 0 &&  id100 <= 40)            //35%
                    {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un Ópalo común en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_opalo", oPC));
                    }
                    else if(id100 >= 41 &&  id100 <= 60)     //30%
                    {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Ópalo de agua  en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_opaloa", oPC));
                    }
                    else if(id100 >= 61 &&  id100 <= 80)   //20%
                    {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un Ópalo de fuego en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_opalof", oPC));
                    }
                    else if(id100 >= 81 &&  id100 <= 100)            //10%
                    {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un Ópalo negro en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_opalon", oPC));
                    }
                    break;

case 4:
                    if(id100 >= 0 &&  id100 <= 35)            //35%
                    {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Lágrima roja en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_lagrimar", oPC));
                    }
                    else if(id100 >= 36 &&  id100 <= 60)     //30%
                    {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un Orblen en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_orblen", oPC));
                    }
                    else if(id100 >= 61 &&  id100 <= 85)   //20%
                    {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un Orlo en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_orlo", oPC));
                    }
                    else if(id100 >= 86 &&  id100 <= 100)            //10%
                    {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un Zendalur en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_zen", oPC));
                    }
                break;

case 5:
                    if(id100 >= 0 &&  id100 <= 40)            //35%
                    {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un Beljuril en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_bel", oPC));
                    }
                    else if(id100 >= 41 &&  id100 <= 80)     //30%
                    {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un Orblen en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_orblen", oPC));
                    }
                    else if(id100 >= 81 &&  id100 <= 90)   //20%
                    {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Lágrima del Rey en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_lagrey", oPC));
                    }
                    else if(id100 >= 91 &&  id100 <= 100)            //10%
                    {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Piedra pícara en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_picara", oPC));
                    }
                break;

case 6:
                    if(id100 >= 0 &&  id100 <= 60)            //35%
                    {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un Jade de tumba en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_jade", oPC));
                    }
                    else if(id100 >= 61 &&  id100 <= 80)     //30%
                    {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Amarazha en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_amar", oPC));
                    }
                    else if(id100 >= 81 &&  id100 <= 100)   //20%
                    {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Barra lunar en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_barra", oPC));
                    }
                break;

case 7:
                if(id100 >= 0 &&  id100 <= 50)            //35%
                    {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un Zafiro en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_zaf", oPC));
                    }
                    else if(id100 >= 51 &&  id100 <= 80)     //30%
                    {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un Rubí en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_rubi", oPC));
                    }
                    else if(id100 >= 81 &&  id100 <= 95)   //20%
                    {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un Jacinto en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_jac", oPC));
                    }
                    else if(id100 >= 96 &&  id100 <= 98)            //10%
                    {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Zafiro negro en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_zafnegro", oPC));
                    }
                    else if(id100 == 99)            //1%
                    {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un Zafiro estrella en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_zafestre", oPC));
                    }
                    else  //1%
                    {
                    DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un Rubí estrella en bruto!*", oPC));
                    DelayCommand(1.5, FuncionCrearObjetoYTag("bru_rubiestre", oPC));
                    }
                break;

case 8:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido un Diamante en bruto!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("bru_diam", oPC));
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
          DelayCommand(1.5, SendMessageToPC(oPC, "*No consigues extraer ninguna gema*"));
      }
  }
  else
  {
      DelayCommand(1.5, SendMessageToPC(oPC, "*No consigues extraer ninguna gema*"));
  }
}
