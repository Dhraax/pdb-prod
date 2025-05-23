//::///////////////////////////////////////////////
//:: DOTE DESARME Y DESARME MEJORADO
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Ya no usara disciplina y se anyaden algunas mejoras.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 25 de Mayo de 2011
//:://////////////////////////////////////////////

#include "nw_i0_generic"
#include "pb_tiradas_inc"

void CopyItemVoid(object oCopiaArma, object oDefensor)
{
    object oNuevaCopia = CopyItem(oCopiaArma, oDefensor, TRUE);
    if(GetLocalInt(oNuevaCopia, "DESARME_SAQUEABLE") == TRUE)
    {
        SetDroppableFlag(oNuevaCopia, TRUE);
        DeleteLocalInt(oNuevaCopia, "DESARME_SAQUEABLE");
    }
    else SetDroppableFlag(oNuevaCopia, FALSE);
}

int Desarme(object oEjecutor, object oDefensor, int iContraDesarme = FALSE)
{
  object oArmaEjecutor = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oEjecutor);
  object oArmaDefensor = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oDefensor);

  // Sin arma objetivo, no se desarma
  if(GetIsObjectValid(oArmaDefensor) == FALSE)
  {
      if(iContraDesarme == FALSE) FloatingTextStringOnCreature("<cþ<<>* Desarme: fracaso, objetivo sin arma *</c>", oEjecutor, FALSE);
      else FloatingTextStringOnCreature("<cþ<<>* Contra-Desarme: fracaso, objetivo sin arma *</c>", oEjecutor, FALSE);
      return 2;
  }

  // A los polimorfados no se desarma por bugs
  if(GetHasEffect(EFFECT_TYPE_POLYMORPH, oDefensor))
  {
      if(iContraDesarme == FALSE) FloatingTextStringOnCreature("<cþ<<>* Desarme: fracaso, objetivo polimorfado *</c>", oEjecutor, FALSE);
      else FloatingTextStringOnCreature("<cþ<<>* Contra-Desarme: fracaso, objetivo polimorfado *</c>", oEjecutor, FALSE);
      return 2;
  }

  // Immunes a desarme
  if(GetIsDM(oDefensor) || GetIsDMPossessed(oDefensor) || GetPlotFlag(oDefensor) ||
     GetImmortal(oDefensor) || GetLocalInt(oDefensor, "JEFAZO"))
  {
      if(iContraDesarme == FALSE) FloatingTextStringOnCreature("<cþ<<>* Desarme: fracaso, criatura inmune *</c>", oEjecutor, FALSE);
      else FloatingTextStringOnCreature("<cþ<<>* Contra-Desarme: fracaso, criatura inmune *</c>", oEjecutor, FALSE);
      return 2;
  }

  //Seguridad por si los items son antiguos items.
  //Ejecutor
  string sPCNameEjecutor = GetName(oEjecutor, TRUE);
  string sPCCDKeyEjecutor = GetPCPublicCDKey(oEjecutor);
  string sSavedNameEjecutor = GetLocalString(oArmaEjecutor, sPCCDKeyEjecutor);
  //Defensor
  string sPCNameDefensor = GetName(oDefensor, TRUE);
  string sPCCDKeyDefensor = GetPCPublicCDKey(oDefensor);
  string sSavedNameDefensor = GetLocalString(oArmaDefensor, sPCCDKeyDefensor);

  //Seguridad del ejecutor.
  if(sPCNameEjecutor!=sSavedNameEjecutor)
  {
    FloatingTextStringOnCreature("<cþ<<>* El arma es un arma que puede desaparecer por el sistema de seguridad antitraspaso de items *</c>", oEjecutor, FALSE);
    return 2;
  }
  //Seguridad del defensor.
  if(sPCNameDefensor!=sSavedNameDefensor)
  {
    FloatingTextStringOnCreature("<cþ<<>* El arma es un arma que puede desaparecer por el sistema de seguridad antitraspaso de items *</c>", oEjecutor, FALSE);
    return 2;
  }

  int iBonosEjecutor = 0;
  int iBonosDefensor = 0;
  if(GetIsObjectValid(oArmaEjecutor) == FALSE) iBonosEjecutor -= 4;
  if(GetHasFeat(1155, oEjecutor)) iBonosEjecutor += 4;
  if(GetWeaponRanged(oArmaDefensor)) iBonosDefensor -= 4;

  int iAtaqueEjecutor1 = AtaqueCriatura(oEjecutor, oArmaEjecutor);
  int iCADefensor1 = GetAC(oDefensor);
  int iAtaqueEjecutor2 = AtaqueCriatura(oEjecutor, oArmaEjecutor) + BonoTamanyoArma(oEjecutor, oArmaEjecutor) + BonoTamanyoCriatura(oEjecutor, oDefensor) + iBonosEjecutor;
  int iAtaqueDefensor2 = AtaqueCriatura(oDefensor, oArmaDefensor) + BonoTamanyoArma(oDefensor, oArmaDefensor) + BonoTamanyoCriatura(oDefensor, oEjecutor) + iBonosDefensor;

  // Primero una tirada ataque vs CA
  if(iAtaqueEjecutor1 > iCADefensor1)
  {
      SendMessageToPC(oEjecutor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de ataque: *éxito*: "+IntToString(iAtaqueEjecutor1)+" Vs "+IntToString(iCADefensor1)+"</c>");
      SendMessageToPC(oDefensor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de ataque: *éxito*: "+IntToString(iAtaqueEjecutor1)+" Vs "+IntToString(iCADefensor1)+"</c>");

      // Segundo una tirada de ataque enfrentada
      if(iAtaqueEjecutor2 > iAtaqueDefensor2)
      {
          if(GetIsPC(oDefensor) == FALSE)
          {
              //AssignCommand(oDefensor, ActionUnequipItem(oArmaDefensor));
              if(GetDroppableFlag(oArmaDefensor)) SetLocalInt(oArmaDefensor, "DESARME_SAQUEABLE", TRUE);
              object oCopiaArma = CopyItem(oArmaDefensor, GetObjectByTag("ClothingBuilder"), TRUE);
              DestroyObject(oArmaDefensor);
              DelayCommand(12.0, CopyItemVoid(oCopiaArma, oDefensor));
              DelayCommand(12.0, DestroyObject(oCopiaArma));
          }
          else
          {
              if(GetIsObjectValid(oArmaEjecutor) == FALSE)
              {
                  CopyItem(oArmaDefensor, oEjecutor, TRUE);
                  DestroyObject(oArmaDefensor);
              }
              else
              {
                  CopyObject(oArmaDefensor, GetLocation(oDefensor));
                  DestroyObject(oArmaDefensor);
              }
          }

          SendMessageToPC(oEjecutor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de ataque enfrentada: *éxito*: "+IntToString(iAtaqueEjecutor2)+" Vs "+IntToString(iAtaqueDefensor2)+"</c>");
          SendMessageToPC(oDefensor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de ataque enfrentada: *éxito*: "+IntToString(iAtaqueEjecutor2)+" Vs "+IntToString(iAtaqueDefensor2)+"</c>");
          FloatingTextStringOnCreature("<cþ<<>* Te han desarmado *</c>", oDefensor, FALSE);
          return 1;
      }
      else
      {
          SendMessageToPC(oEjecutor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de ataque enfrentada: *fallo*: "+IntToString(iAtaqueEjecutor2)+" Vs "+IntToString(iAtaqueDefensor2)+"</c>");
          SendMessageToPC(oDefensor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de ataque enfrentada: *fallo*: "+IntToString(iAtaqueEjecutor2)+" Vs "+IntToString(iAtaqueDefensor2)+"</c>");
          FloatingTextStringOnCreature("<c´þd>* Resistes un intento de desarme *</c>", oDefensor, FALSE);
          return 0;
      }
  }
  else
  {
      SendMessageToPC(oEjecutor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de ataque: *fallo*: "+IntToString(iAtaqueEjecutor1)+" Vs "+IntToString(iCADefensor1)+"</c>");
      SendMessageToPC(oDefensor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de ataque: *fallo*: "+IntToString(iAtaqueEjecutor1)+" Vs "+IntToString(iCADefensor1)+"</c>");
      FloatingTextStringOnCreature("<c´þd>* Resistes un intento de desarme *</c>", oDefensor, FALSE);
      return 0;
  }
}

void ContraDesarme(object oEjecutor, object oDefensor)
{
  int iDesarme = Desarme(oEjecutor, oDefensor, TRUE);

  if(iDesarme == 1) FloatingTextStringOnCreature("<c´þd>* Contra-Desarme: éxito *</c>", oEjecutor, FALSE);
  if(iDesarme == 2) return;
  else if(iDesarme == 0)FloatingTextStringOnCreature("<cþ<<>* Contra-Desarme: fracaso *</c>", oEjecutor, FALSE);
}

void main()
{
  object oEjecutor = OBJECT_SELF;
  object oDefensor = GetSpellTargetObject();

  // No puedes desarmar a uno mismo
  if(oEjecutor == oDefensor)
  {
      FloatingTextStringOnCreature("<cþ<<>* ¡No puedes desarmarte a ti mismo! *</c>", OBJECT_SELF, FALSE);
      return;
  }

  if(GetHasFeat(1155,OBJECT_SELF) == FALSE) AtaqueOportunidad(oDefensor);

  AssignCommand(oEjecutor, ActionAttack(oDefensor, FALSE));

  if(!GetIsEnemy(oEjecutor, oDefensor) && !GetIsPC(oDefensor))
  {
      AdjustReputation(oEjecutor, oDefensor, -100);
      AssignCommand(oDefensor, ActionAttack(oEjecutor));
  }

  int iDesarme = Desarme(oEjecutor, oDefensor);
  if(iDesarme == 1) FloatingTextStringOnCreature("<c´þd>* Desarme: éxito *</c>", oEjecutor, FALSE); // Exito desarme
  else if(iDesarme == 2) return;
  else if(iDesarme == 0)
  {
      FloatingTextStringOnCreature("<cþ<<>* Desarme: fracaso *</c>", oEjecutor, FALSE);
      AssignCommand(oDefensor, SetFacingPoint(GetPosition(oEjecutor)));
      if(GetHasFeat(1155,OBJECT_SELF) == FALSE)
      {
          DelayCommand(0.5, AssignCommand(oDefensor, PlayAnimation(ANIMATION_LOOPING_CUSTOM19, 5.0, 1.0)));
          DelayCommand(1.5, AssignCommand(oDefensor, PlayAnimation(ANIMATION_LOOPING_CUSTOM19, 1.0, 0.1)));
          DelayCommand(1.0, ContraDesarme(oDefensor, oEjecutor));
      }
  }
}
