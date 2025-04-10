//::///////////////////////////////////////////////
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
  Juego de manos a distancia, del Bribon Arcano
  Chekea por orden:
  1. Si el objetivo es valido, las puertas y ubicados cerrados, para abrirlos
  2. Si el objetivo es valido, las puertas y ubicados con trampas, para desactivarlos
  3. Si el objetivo es valido, las puertas y ubicados abiertos, para cerrarlos
  4. Si el objetivo es valido, las criaturas para robarles
  5. Si el objetivo no es valido, los desencadenantes de trampas, para inutilizarlas

  Nunca abrira, cerrara, desactivara o robara cosas que no se podrian en el juego normal
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 14/08/2012
//:://////////////////////////////////////////////

void UsoJuegoDeManosDistancia()
{
  object oPC = OBJECT_SELF;
  object oObjetoActivado = GetSpellTargetObject();
  int iTipoObjetoActivado = GetObjectType(oObjetoActivado);
  int iCD;

  // 0. No a nosotros mismos
  if(oPC == oObjetoActivado)
  {
      FloatingTextStringOnCreature("<cþ<<>* No has seleccionado un objetivo válido para esta aptitud *</c>", oPC, FALSE);
      IncrementRemainingFeatUses(oPC, 1292);
      return;
  }

  // 1. Si el objetivo es valido, las puertas y ubicados cerrados, para abrirlos
  else if((iTipoObjetoActivado == OBJECT_TYPE_DOOR || iTipoObjetoActivado == OBJECT_TYPE_PLACEABLE) && GetLocked(oObjetoActivado))
  {
      if(GetSkillRank(SKILL_OPEN_LOCK, oPC, TRUE) == 0)
      {
          FloatingTextStringOnCreature("<cþ<<>* No tienes entrenada la habilidad de Abrir cerraduras *</c>", oPC, FALSE);
          IncrementRemainingFeatUses(oPC, 1292);
          return;
      }

      if(!GetLockKeyRequired(oObjetoActivado))
      {
          iCD = GetLockUnlockDC(oObjetoActivado);
          iCD = iCD + 5;
          if(GetIsSkillSuccessful(oPC, SKILL_OPEN_LOCK, iCD))
          {
              FloatingTextStringOnCreature("<c´þd>* Abriste con éxito la cerradura del ubicado/puerta seleccionado *</c>", oPC, FALSE);
              SetLocked(oObjetoActivado, FALSE);
          }
          else FloatingTextStringOnCreature("<cþ<<>* Fallaste al intentar abrir la cerradura del ubicado/puerta seleccionado *</c>", oPC, FALSE);
      }
      else
      {
          FloatingTextStringOnCreature("<cþ<<>* La cerradura del ubicado/puerta seleccionado requiere una llave concreta *</c>", oPC, FALSE);
          IncrementRemainingFeatUses(oPC, 1292);
      }
  }

  // 2. Si el objetivo es valido, las puertas y ubicados con trampas, para desactivarlos
  else if((iTipoObjetoActivado == OBJECT_TYPE_DOOR || iTipoObjetoActivado == OBJECT_TYPE_PLACEABLE) && GetIsTrapped(oObjetoActivado))
  {
      if(GetTrapDetectable(oObjetoActivado) && GetTrapDisarmable(oObjetoActivado))
      {
          iCD = GetTrapDisarmDC(oObjetoActivado);
          iCD = iCD + 5;
          if(GetIsSkillSuccessful(oPC, SKILL_DISABLE_TRAP, iCD))
          {
              FloatingTextStringOnCreature("<c´þd>* Desactivaste con éxito la trampa del ubicado/puerta seleccionado *</c>", oPC, FALSE);
              SetTrapDisabled(oObjetoActivado);
          }
          else FloatingTextStringOnCreature("<cþ<<>* Fallaste al intentar desactivar la trampa del ubicado/puerta seleccionado *</c>", oPC, FALSE);
      }
      else
      {
          FloatingTextStringOnCreature("<cþ<<>* No se puede desactivar la trampa del ubicado/puerta seleccionado *</c>", oPC, FALSE);
          IncrementRemainingFeatUses(oPC, 1292);
      }
  }

  // 3. Si el objetivo es valido, las puertas y ubicados abiertos, para cerrarlos
  else if((iTipoObjetoActivado == OBJECT_TYPE_DOOR || iTipoObjetoActivado == OBJECT_TYPE_PLACEABLE) && !GetLocked(oObjetoActivado))
  {
      if(GetSkillRank(SKILL_OPEN_LOCK, oPC, TRUE) == 0)
      {
          FloatingTextStringOnCreature("<cþ<<>* No tienes entrenada la habilidad de Abrir cerraduras *</c>", oPC, FALSE);
          IncrementRemainingFeatUses(oPC, 1292);
          return;
      }

      if(GetLockLockable(oObjetoActivado))
      {
          iCD = GetLockLockDC(oObjetoActivado);
          iCD = iCD + 5;
          if(GetIsSkillSuccessful(oPC, SKILL_OPEN_LOCK, iCD))
          {
              FloatingTextStringOnCreature("<c´þd>* Cerraste con éxito la cerradura del ubicado/puerta seleccionado *</c>", oPC, FALSE);
              SetLocked(oObjetoActivado, TRUE);
          }
          else FloatingTextStringOnCreature("<cþ<<>* Fallaste al intentar cerrar la cerradura del ubicado/puerta seleccionado *</c>", oPC, FALSE);
      }
      else
      {
          FloatingTextStringOnCreature("<cþ<<>* No se puede cerrar la cerradura del ubicado/puerta seleccionado *</c>", oPC, FALSE);
          IncrementRemainingFeatUses(oPC, 1292);
      }
  }

  // 4. Si el objetivo es valido, las criaturas para robarles
  else if(iTipoObjetoActivado == OBJECT_TYPE_CREATURE)
  {
      if(GetSkillRank(SKILL_PICK_POCKET, oPC, TRUE) == 0)
      {
          FloatingTextStringOnCreature("<cþ<<>* No tienes entrenada la habilidad de Juego de manos *</c>", oPC, FALSE);
          IncrementRemainingFeatUses(oPC, 1292);
          return;
      }

      iCD = 25;
      if(GetIsEnemy(oPC, oObjetoActivado)) iCD = 35;

      int iTiradaJuegoDeManos = d20() + GetSkillRank(SKILL_PICK_POCKET, oPC);
      int iTiradaAvistar = d20() + 10 + GetSkillRank(SKILL_SPOT, oObjetoActivado);

      if(iTiradaJuegoDeManos >= iCD) // Tirada de juego de Manos
      {
          if(d2() == 1) // 50% robamos oro
          {
              int iOroCriatura = GetGold(oObjetoActivado);
              if(iOroCriatura > 0)
              {
                  int iOroARobar = 10 + d10(3) + GetHitDice(oPC);
                  if(iOroARobar > iOroCriatura) iOroARobar = iOroCriatura;
                  TakeGoldFromCreature(iOroARobar, oObjetoActivado);
                  FloatingTextStringOnCreature("<c´þd>* Robaste con éxito "+IntToString(iOroARobar)+" monedas de oro de "+GetName(oObjetoActivado)+" ("+IntToString(iTiradaJuegoDeManos)+" vs CD "+IntToString(iCD)+") *</c>", oPC, FALSE);
              }
              else FloatingTextStringOnCreature("<cþ<<>* "+GetName(oObjetoActivado)+" no parece tener monedas de oro encima ("+IntToString(iTiradaJuegoDeManos)+" vs CD "+IntToString(iCD)+") *</c>", oPC, FALSE);
          }
          else // 50% robamos objetos
          {
              int iPararBusqueda = FALSE;
              object oObjetoARobar = GetFirstItemInInventory(oObjetoActivado);
              while(GetIsObjectValid(oObjetoARobar) && iPararBusqueda == FALSE)
              {
                  if(GetGoldPieceValue(oObjetoARobar) < 2000 &&
                     GetWeight(oObjetoARobar) < 50 && !GetPlotFlag(oObjetoARobar)) iPararBusqueda = TRUE;

                  oObjetoARobar = GetNextItemInInventory(oObjetoActivado);
              }

              if(GetIsObjectValid(oObjetoARobar))
              {
                  FloatingTextStringOnCreature("<c´þd>* Robaste con éxito el objeto "+GetName(oObjetoARobar)+" de "+GetName(oObjetoActivado)+" ("+IntToString(iTiradaJuegoDeManos)+" vs CD "+IntToString(iCD)+") *</c>", oPC, FALSE);
                  CopyItem(oObjetoARobar, oPC, TRUE);
                  DestroyObject(oObjetoARobar, 0.1);
              }
              else FloatingTextStringOnCreature("<cþ<<>* "+GetName(oObjetoActivado)+" no parece tener objetos interesantes que se puedan robar encima ("+IntToString(iTiradaJuegoDeManos)+" vs CD "+IntToString(iCD)+") *</c>", oPC, FALSE);
          }
      }
      else FloatingTextStringOnCreature("<cþ<<>* Fallaste el intento de hurto ("+IntToString(iTiradaJuegoDeManos)+" vs CD "+IntToString(iCD)+") *</c>", oPC, FALSE);

      if(iTiradaAvistar >= iTiradaJuegoDeManos) // Tirada de Avistar
      {
          FloatingTextStringOnCreature("<cþ<<>¡Han detectado tu intento de hurto! ("+IntToString(iTiradaJuegoDeManos)+" vs CD "+IntToString(iTiradaAvistar)+") </c>", oPC, FALSE);
          FloatingTextStringOnCreature("<cþ<<>¡"+GetName(oPC)+" está intentando hurtarte! ("+IntToString(iTiradaAvistar)+" vs CD "+IntToString(iTiradaJuegoDeManos)+") </c>", oObjetoActivado, FALSE);

          if(!GetIsEnemy(oPC, oObjetoActivado) && !GetIsPC(oObjetoActivado))
          {
              AdjustReputation(oPC, oObjetoActivado, -100);
              AssignCommand(oObjetoActivado, ActionAttack(oPC));
          }
      }
  }

  // 5. Si el objetivo no es valido, los desencadenantes de trampas, para inutilizarlas
  else
  {
      location lLugarActivado = GetSpellTargetLocation();
      int iPararBusqueda = FALSE;
      int iContador = 1;
      object oTrampa = GetNearestObjectToLocation(OBJECT_TYPE_TRIGGER, lLugarActivado, iContador);

      while(GetIsObjectValid(oTrampa) && GetDistanceBetweenLocations(lLugarActivado, GetLocation(oTrampa)) <= 10.0 && iPararBusqueda == FALSE)
      {
          if(GetIsTrapped(oTrampa) && GetTrapDetectable(oTrampa) && GetTrapDisarmable(oTrampa))
          {
              iCD = GetTrapDisarmDC(oTrampa) + 5;
              if(GetIsSkillSuccessful(oPC, SKILL_DISABLE_TRAP, iCD))
              {
                  FloatingTextStringOnCreature("<c´þd>* Desactivaste con éxito una trampa del suelo *</c>", oPC, FALSE);
                  SetTrapDisabled(oTrampa);
              }
              else FloatingTextStringOnCreature("<cþ<<>* Fallaste al intentar desactivar una trampa del suelo *</c>", oPC, FALSE);

              iPararBusqueda = TRUE;
          }

          iContador++;
          oTrampa = GetNearestObjectToLocation(OBJECT_TYPE_TRIGGER, lLugarActivado, iContador);
      }

      if(iPararBusqueda == FALSE)
      {
          FloatingTextStringOnCreature("<cþ<<>* No encontraste ninguna trampa en el suelo que desactivar *</c>", oPC, FALSE);
          IncrementRemainingFeatUses(oPC, 1292);
      }
  }
}

void main()
{
  // Antisaturamiento
  if(GetLocalInt(OBJECT_SELF, "JUEMANDIS_NOSATURAR"))
  {
      FloatingTextStringOnCreature("<cþ<<>* No puedes realizar una prueba de Juego de manos a distancia otra vez tan rápidamente *</c>", OBJECT_SELF, FALSE);
      IncrementRemainingFeatUses(OBJECT_SELF, 1292);
      return;
  }

  SetLocalInt(OBJECT_SELF, "JUEMANDIS_NOSATURAR", TRUE);
  DelayCommand(8.0, DeleteLocalInt(OBJECT_SELF, "JUEMANDIS_NOSATURAR"));

  // Animaciones y acciones
  DelayCommand(0.0, AssignCommand(OBJECT_SELF, PlaySound("as_cv_ropepully1")));
  DelayCommand(0.1, AssignCommand(OBJECT_SELF, PlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 5.9)));
  DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), OBJECT_SELF, 5.8));
  DelayCommand(6.0, UsoJuegoDeManosDistancia());
  DelayCommand(6.1, AssignCommand(OBJECT_SELF, PlaySound("gui_trapdisarm")));
}

