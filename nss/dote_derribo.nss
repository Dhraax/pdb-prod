//::///////////////////////////////////////////////
//:: DOTE DERRIBO Y DERRIBO MEJORADO
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Ya no usara disciplina y se anyaden algunas mejoras.

    Pag. 137 y 157 Manual del Jugador 3.5
*/
//:://////////////////////////////////////////////
//:: Created By: Creadi por Monti y Vash y modificado por Asyel
//:: Created On: 22 de Marzo de 2012
//:://////////////////////////////////////////////

#include "mti_libreria"
#include "pb_tiradas_inc"
#include "inc_sqlite_time"

effect EffectDerribo(){
    // AJUSTE PARA ARCOS Y BALLESTAS
        object oMyWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
        int iArmaObjetoBase = GetBaseItemType(oMyWeapon);
        int iPenalizadorAtaque = 4;
        if(iArmaObjetoBase == BASE_ITEM_SHORTBOW || iArmaObjetoBase == BASE_ITEM_LONGBOW)
        {
            iPenalizadorAtaque = 20;
        }

    effect eReturn = EffectAttackDecrease(iPenalizadorAtaque);
           eReturn = EffectLinkEffects(eReturn, EffectACDecrease(4, AC_DODGE_BONUS));
           eReturn = EffectLinkEffects(eReturn, EffectCutsceneImmobilize());
           eReturn = EffectLinkEffects(eReturn, EffectVisualEffect(82));

    return eReturn;
}

int ArmaBonoDerribo(object oCriatura)
{
  object oArma = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCriatura);
  int iArma = GetBaseItemType(oArma);
  if(iArma == BASE_ITEM_HALBERD   ||
     iArma ==BASE_ITEM_WHIP       ||
     iArma ==BASE_ITEM_HEAVYFLAIL ||
     iArma ==BASE_ITEM_LIGHTFLAIL) return TRUE;

  return FALSE;
}

int BonoDerribo(object oCriatura)
{
  int nBono = 0;

  switch(GetRacialType(oCriatura))
  {
      case RACIAL_TYPE_DWARF:         nBono += 4; break;
      case RACIAL_TYPE_ANIMAL:        nBono += 4; break;
      case RACIAL_TYPE_BEAST:         nBono += 4; break;
      case RACIAL_TYPE_MAGICAL_BEAST: nBono += 4; break;
      case RACIAL_TYPE_VERMIN:        nBono += 4; break;
      case RACIAL_TYPE_OOZE:          nBono += 4; break;
  }

  switch(GetCreatureSize(oCriatura))
  {
      case CREATURE_SIZE_SMALL: nBono -= 4; break;
      case CREATURE_SIZE_TINY:  nBono -= 8; break;
      case CREATURE_SIZE_LARGE: nBono += 4; break;
      case CREATURE_SIZE_HUGE:  nBono += 8; break;
      case 22: nBono += 12; break;
      case 23: nBono += 14; break;
      case 20: nBono -= 12; break;
      case 21: nBono -= 14; break;
  }

  return nBono;
}

int Derribo(object oEjecutor, object oDefensor, int iContraDerribo = FALSE)
{
  // Solo a tamanyos validos
  if(VerSiEsTamanyoValido(oEjecutor, oDefensor) == FALSE)
  {
      if(iContraDerribo == FALSE) FloatingTextStringOnCreature("<cþ<<>* Derribo: fracaso, tamaño de criatura no válido *</c>", oEjecutor, FALSE);
      else FloatingTextStringOnCreature("<cþ<<>* Contra-Derribo: fracaso, tamaño de criatura no válido *</c>", oEjecutor, FALSE);
      return 2;
  }

  // Si es immune al derribo, nanay
  if(GetIsImmune(oDefensor, IMMUNITY_TYPE_KNOCKDOWN))
  {
      if(iContraDerribo == FALSE) FloatingTextStringOnCreature("<cþ<<>* Derribo: fracaso, criatura inmune *</c>", oEjecutor, FALSE);
      else FloatingTextStringOnCreature("<cþ<<>* Contra-Derribo: fracaso, criatura inmune *</c>", oEjecutor, FALSE);
      return 2;
  }

  // Si ya tiene derribo, nanay
  if(GetLocalInt(oDefensor, "DERRIBADO") || GetLocalInt(oDefensor, "SLIDING"))
  {
      if(iContraDerribo == FALSE) FloatingTextStringOnCreature("<cþ<<>* Derribo: fracaso, criatura ya derribada *</c>", oEjecutor, FALSE);
      else FloatingTextStringOnCreature("<cþ<<>* Contra-Derribo: fracaso, criatura ya derribada *</c>", oEjecutor, FALSE);
      return 2;
  }

  int iDadoEjecutor = d20();
  int iBonoEjecutor = GetAbilityModifier(ABILITY_STRENGTH, oEjecutor) + BonoDerribo(oEjecutor);
  if(GetHasFeat(1153, oEjecutor)) iBonoEjecutor += 4;
  int iTiradaEjecutor = iDadoEjecutor + iBonoEjecutor;

  int iDadoDefensor = d20();
  int iBonoDefensor = BonoDerribo(oDefensor);
  int iFuerzaDefensor = GetAbilityModifier(ABILITY_STRENGTH, oDefensor);
  int iDestrezaDefensor = GetAbilityModifier(ABILITY_DEXTERITY, oDefensor);
  if(ObtenerIntPersistente(oDefensor, "CAB_MONTADO") > 0)
  {
      int iMontar = GetSkillRank(SKILL_RIDE, oDefensor);
      if(iMontar > iFuerzaDefensor && iMontar > iDestrezaDefensor) iBonoDefensor += iMontar;
      else
      {
          if(iFuerzaDefensor >= iDestrezaDefensor) iBonoDefensor += iFuerzaDefensor;
          else iBonoDefensor += iDestrezaDefensor;
      }
  }
  else
  {
      if(iFuerzaDefensor >= iDestrezaDefensor) iBonoDefensor += iFuerzaDefensor;
      else iBonoDefensor += iDestrezaDefensor;
  }

  int iTiradaDefensor = iDadoDefensor + iBonoDefensor;

  if(iTiradaEjecutor > iTiradaDefensor) // Exito derribo
  {
      float fTimer = 6.0;
      if(ArmaBonoDerribo(oEjecutor) == TRUE || GetHasFeat(1153, oEjecutor) == TRUE) fTimer = 9.0;

      if(iContraDerribo == TRUE && ArmaBonoDerribo(oDefensor) == TRUE && d100() <= 33) // 33% de soltar el arma en el suelo y evitar el contraderribo
      {
          object oArmaDefensor = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oDefensor);
          if(GetIsPC(oDefensor) == FALSE) AssignCommand(oDefensor, ActionUnequipItem(oArmaDefensor));
          else
          {
              CopyObject(oArmaDefensor, GetLocation(oDefensor));
              DestroyObject(oArmaDefensor);
          }

          SendMessageToPC(oEjecutor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de fuerza enfrentada: *fallo*: soltó el arma.</c>");
          SendMessageToPC(oDefensor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de fuerza enfrentada: *fallo*: soltó el arma.</c>");
          FloatingTextStringOnCreature("<cþ<<>* Derribo: fracaso, el objetivo eludió el derribo soltando su arma *</c>", oEjecutor, FALSE);
          FloatingTextStringOnCreature("<c´þd>* Resistes un intento de derribo soltando tu arma *</c>", oDefensor, FALSE);
          return 2;
      }
      else
      {
          SetLocalInt(oDefensor, "DERRIBADO", TRUE);

          if(iContraDerribo == FALSE)
          {
              DelayCommand(fTimer, DeleteLocalInt(oDefensor, "DERRIBADO"));
              ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDerribo(), oDefensor, fTimer);
              FloatingTextStringOnCreature("<cþ<<>* ¡Te han derribado! *</c>", oDefensor, FALSE);
          }
          else
          {
              DelayCommand(4.0, DeleteLocalInt(oDefensor, "DERRIBADO"));
              ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDerribo(), oDefensor, 4.0);
              FloatingTextStringOnCreature("<cþ<<>* ¡Te han derribado! *</c>", oDefensor, FALSE);
          }

          SendMessageToPC(oEjecutor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de fuerza enfrentada: *éxito*: "+IntToString(iTiradaEjecutor)+" Vs "+IntToString(iTiradaDefensor)+"</c>");
          SendMessageToPC(oDefensor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de fuerza enfrentada: *éxito*: "+IntToString(iTiradaDefensor)+" Vs "+IntToString(iTiradaEjecutor)+"</c>");
          FloatingTextStringOnCreature("<cþ<<>* Te han derribado *</c>", oDefensor, FALSE);
          return 1;
      }
  }
  else
  {
      SendMessageToPC(oEjecutor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de fuerza enfrentada: *fallo*: "+IntToString(iTiradaEjecutor)+" Vs "+IntToString(iTiradaDefensor)+"</c>");
      SendMessageToPC(oDefensor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de fuerza enfrentada: *fallo*: "+IntToString(iTiradaDefensor)+" Vs "+IntToString(iTiradaEjecutor)+"</c>");
      FloatingTextStringOnCreature("<c´þd>* Resistes un intento de derribo *</c>", oDefensor, FALSE);
      return 0;
  }
}

void ContraDerribo(object oEjecutor, object oDefensor)
{
  int iDerribo = Derribo(oEjecutor, oDefensor, TRUE);

  if(iDerribo == 1) FloatingTextStringOnCreature("<c´þd>* Contra-Derribo: éxito *</c>", oEjecutor, FALSE);
  if(iDerribo == 2) return;
  else if(iDerribo == 0)FloatingTextStringOnCreature("<cþ<<>* Contra-Derribo: fracaso *</c>", oEjecutor, FALSE);
}

void main()
{
    object oEjecutor = OBJECT_SELF;
    object oDefensor = GetSpellTargetObject();
    float fContador;
    // No puedes desarmar a uno mismo
    if(oEjecutor == oDefensor) {
        FloatingTextStringOnCreature("<cþ<<>* ¡No puedes derribarte a ti mismo! *</c>", oEjecutor, FALSE);
        return;
    }
    // Contador: solo podemos usar la dote derribo cada 4 asaltos y derribo mejorado cada 3 asaltos.
    object oMod = GetModule();
    int iCurTime = SQLite_GetTimeStamp();
    int iCoolDown = GetLocalInt(oMod, "DERRI" + GetName(oEjecutor, TRUE));
    int iEspera = iCurTime - iCoolDown;

    if(GetHasFeat(1153,OBJECT_SELF)==FALSE) {
        if (iCurTime - iCoolDown < 24) {
            iEspera = 24 - iEspera;
            FloatingTextStringOnCreature("<cþ<<>* Debes esperar "+IntToString(iEspera)+" segundos antes de derribar de nuevo. *</c>", OBJECT_SELF, FALSE);
            return;
        }
    } else {
        if (iCurTime - iCoolDown < 16) {
            iEspera = 16 - iEspera;
            FloatingTextStringOnCreature("<cþ<<>* Debes esperar "+IntToString(iEspera)+" segundos antes de derribar de nuevo. *</c>", OBJECT_SELF, FALSE);
            return;
        }
    }

    // Antispam
    if(GetHasFeat(1153,OBJECT_SELF)==FALSE) {
        fContador = 24.0f;
    } else {
        fContador=16.0f;
    }

    SetLocalInt(oMod, "DERRI" + GetName(oEjecutor, TRUE), SQLite_GetTimeStamp());
    DelayCommand(fContador, DeleteLocalInt(oMod, "DERRI" + GetName(oEjecutor, TRUE)));
    DelayCommand(fContador, FloatingTextStringOnCreature("<c´þd>* Ya se puede utilizar derribo. *</c>", oEjecutor, FALSE));

    if(GetHasFeat(1153,OBJECT_SELF) == FALSE && ArmaBonoDerribo(oEjecutor) == FALSE) AtaqueOportunidad(oDefensor);

    AssignCommand(oEjecutor, ActionAttack(oDefensor, FALSE));

    if(!GetIsEnemy(oEjecutor, oDefensor) && !GetIsPC(oDefensor)) {
      AdjustReputation(oEjecutor, oDefensor, -100);
      AssignCommand(oDefensor, ActionAttack(oEjecutor));
    }

    if(TouchAttackMelee(oDefensor) > 0) {
        int iDerribo = Derribo(oEjecutor, oDefensor);
        if(iDerribo == 1) {
            FloatingTextStringOnCreature("<c´þd>* Derribo: éxito *</c>", oEjecutor, FALSE); // Exito derribo
        } else if(iDerribo == 2) {
            return;
        } else if(iDerribo == 0) {
            FloatingTextStringOnCreature("<cþ<<>* Derribo: fracaso *</c>", oEjecutor, FALSE);
            AssignCommand(oDefensor, SetFacingPoint(GetPosition(oEjecutor)));
            if(GetHasFeat(1153,OBJECT_SELF) == FALSE) {
                DelayCommand(0.5, AssignCommand(oDefensor, PlayAnimation(ANIMATION_LOOPING_CUSTOM19, 5.0, 1.0)));
                DelayCommand(1.5, AssignCommand(oDefensor, PlayAnimation(ANIMATION_LOOPING_CUSTOM19, 1.0, 0.1)));
                DelayCommand(1.0, ContraDerribo(oDefensor, oEjecutor));
            }
        }
    }
}

