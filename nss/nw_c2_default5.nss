//::///////////////////////////////////////////////
//:: Default On Attacked
//:: NW_C2_DEFAULT5
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If already fighting then ignore, else determine
    combat round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////

#include "hench_i0_ai"
#include "nw_i0_2q4luskan"
#include "mti_libreria"
#include "sute_libreria"


void main()
{
    if (!GetLocalInt(GetModule(),"X3_NO_MOUNTED_COMBAT_FEAT"))
    { // set variables on target for mounted combat
        SetLocalInt(OBJECT_SELF,"bX3_LAST_ATTACK_PHYSICAL",TRUE);
        SetLocalInt(OBJECT_SELF,"nX3_HP_BEFORE",GetCurrentHitPoints(OBJECT_SELF));
    } // set variables on target for mounted combat

    if(GetFleeToExit())
    {
        ActivateFleeToExit();
    }
    else if (GetSpawnInCondition(NW_FLAG_SET_WARNINGS))
    {
        // We give an attacker one warning before we attack
        // This is not fully implemented yet
        SetSpawnInCondition(NW_FLAG_SET_WARNINGS, FALSE);

        //Put a check in to see if this attacker was the last attacker
        //Possibly change the GetNPCWarning function to make the check
    }
    else if(!GetSpawnInCondition(NW_FLAG_SET_WARNINGS))
    {
        object oAttacker = GetLastAttacker();

        if (!GetIsObjectValid(oAttacker))
        {
            // Don't do anything, invalid attacker

        }
        else if (!GetIsFighting(OBJECT_SELF))
        {
            if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
            {
                if(GetArea(GetLastAttacker()) == GetArea(OBJECT_SELF))
                {
                    CheckRemoveStealth();
                }
                SetSummonHelpIfAttacked();
                HenchDetermineSpecialBehavior(GetLastAttacker());
            }
            else if(GetArea(GetLastAttacker()) == GetArea(OBJECT_SELF))
            {
                CheckRemoveStealth();
                SetSummonHelpIfAttacked();
                HenchDetermineCombatRound(GetLastAttacker());
            }
        }
    }
    if(GetSpawnInCondition(NW_FLAG_ATTACK_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_ATTACKED));
    }


    ///////////////// PELETERIA ////////////////////

if(GetLocalInt(OBJECT_SELF, "PIEL") > 0 && GetIsDead(OBJECT_SELF))
   {
  // ANTI-SATURAMIENTO DE LA VETA
  if(GetLocalInt(OBJECT_SELF,"LAVETANOSESATURA") == 1) return;
  SetLocalInt(OBJECT_SELF, "LAVETANOSESATURA", 1);
  DelayCommand(3.0, DeleteLocalInt(OBJECT_SELF, "LAVETANOSESATURA"));

  object oPC = GetLastAttacker();

  // SOLO CON EL CUCHILLO DESPELLEJAR
  string sPico = GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
  if(sPico != "desollador")
  {
      DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(0.3, FloatingTextStringOnCreature("*¡No puedes desollar sin cuchillo de despellejador!*", oPC));
      return;
  }

  // NECESITAS TENER NIVEL 1 O MAS PARA SEGUIR PICANDO
  int iNivelHabilidad = ObtenerIntPersistente(oPC, "NIVELDESOLLADOR");
  if(iNivelHabilidad == 0)
  {
      DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(2.0, FloatingTextStringOnCreature("*Quizás debería hablar con algún maestro de Peleteria antes de nada*", oPC, FALSE));
      return;
  }

  // PROBABILIDAD DE QUE SE ROMPA EL CUCHILLO
  object oPico = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
  int iUsosPico = GetLocalInt(oPico, "USOSPICO");
  int iTipoPiel;

  if(iUsosPico == 0) // El cuchillo es nuevo
  {
      if(sPico == "desollador") SetLocalInt(oPico, "USOSPICO", d6(20));
  }

  else if(iUsosPico > 0 && iUsosPico < 6) // El cuchillo se rompe
  {
      DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(0.5, AssignCommand(oPC,PlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED, 1.0, 2.5)));
      DelayCommand(0.8, FloatingTextStringOnCreature("*¡Tu cuchillo de desollar se ha roto!*", oPC));
      DestroyObject(oPico, 0.8);
      DelayCommand(1.8, PlayVoiceChat(VOICE_CHAT_CUSS, oPC));
      return;
  }

  else // El cuchillo se gasta
  {
      iTipoPiel = GetLocalInt(OBJECT_SELF, "PIEL");
      SetLocalInt(oPico, "USOSPICO", iUsosPico - 1);
  }

  // ANIMACIONES DEL PJ
  DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
  DelayCommand(0.5, AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 0.9)));
  DelayCommand(1.5, AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 1.5)));


  /*/ LESIONES DE MINERIA (LUXACION DE HOMBRO, LUMBALGIA Y FATIGA)
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
  }*/

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
      int iBonoFue = bonoRealCaracteristicaPJ(ABILITY_DEXTERITY, oPC) * 2;
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
          switch(iTipoPiel)
          {
              case 1:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Piel de rata!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pellejoderata", oPC));
                break;

             case 2:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Piel de tejon!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaCobre", oPC));
                break;

             case 3:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Piel de lobo!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaAcero", oPC));
                break;

             case 4:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Piel de serpiente!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaPlata", oPC));
                break;

             case 5:
                DelayCommand(1.5, FloatingTextStringOnCreature("**¡Has conseguido una Piel de lobo invernal!**", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaHierrofrio", oPC));
                break;

             case 6:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Piel de oso!*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaOro", oPC));
                break;

             case 7:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Piel de oso pardo*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaMithril", oPC));
                break;

             case 8:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Piel de reptil*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaAdamantita", oPC));
                break;

            case 9:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Piel de reptil*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaAdamantita", oPC));
                break;

            case 10:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Piel de reptil*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaAdamantita", oPC));
                break;

            case 11:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Piel de reptil*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaAdamantita", oPC));
                break;

            case 12:
                DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido una Piel de reptil*", oPC));
                DelayCommand(1.5, FuncionCrearObjetoYTag("pepitaAdamantita", oPC));
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
              DelayCommand(2.5, FloatingTextStringOnCreature("¡Has subido al nivel " + IntToString(iNivelHabilidad + 1) + " en Desollar!", oPC));
              DelayCommand(2.5, SetXP(oPC, GetXP(oPC) + iExperiencia));
              GuardarIntPersistente(oPC, "NIVELDESOLLADOR", iNivelHabilidad + 1);
          }
      }
      else
      {
          DelayCommand(1.5, SendMessageToPC(oPC, "*No consigues extraer ninguna piel*"));
      }
  }
  else
  {
      DelayCommand(1.5, SendMessageToPC(oPC, "*No consigues extraer ninguna piel*"));
  }
}

}
