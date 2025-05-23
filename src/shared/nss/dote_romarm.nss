//::///////////////////////////////////////////////
//:: DOTE ROMPER ARMA Y ROMPER ARMA MEJORADO
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Dote Romper Arma y Romper Arma Mejorado.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 4 de Abril de 2012
//:://////////////////////////////////////////////

#include "pb_tiradas_inc"
#include "x2_inc_itemprop"
#include "zep_inc_armas"

void main()
{
  object oEjecutor = OBJECT_SELF;
  object oDefensor = GetSpellTargetObject();

  // No puedes atacar tu propia arma
  if(oEjecutor == oDefensor)
  {
      FloatingTextStringOnCreature("<cþ<<>* ¡No puedes romper tu propia arma! *</c>", OBJECT_SELF, FALSE);
      return;
  }

  int iBonosEjecutor = 0;
  if(!GetHasFeat(1230, oEjecutor)) AtaqueOportunidad(oDefensor);
  else iBonosEjecutor += 4;

  AssignCommand(oEjecutor, ActionAttack(oDefensor, FALSE));

  if(!GetIsEnemy(oEjecutor, oDefensor) && !GetIsPC(oDefensor))
  {
      AdjustReputation(oEjecutor, oDefensor, -100);
      AssignCommand(oDefensor, ActionAttack(oEjecutor));
  }

  object oArmaEjecutor = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oEjecutor);
  object oArmaDefensor = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oDefensor);

  // Solo armas cuerpo a cuerpo
  if(!VerSiEsArmaCuerpoACuerpo(oArmaEjecutor))
  {
      FloatingTextStringOnCreature("<cþ<<>* Romper Arma: fracaso, arma cuerpo a cuerpo no equipada *</c>", oEjecutor, FALSE);
      return;
  }

  // No se puede romper arma con armas perforantes
  int iTipoArmaEquipada = GetBaseItemType(oArmaEjecutor);
  int iTipoDanyoArmaEquipada = StringToInt(Get2DAString("baseitems", "WeaponType", iTipoArmaEquipada)); // 1 = piercing; 2 = bludgeoning; 3 = slashing; 4 = piercing-slashing; 5 = bludgeoning-piercing.
  if(iTipoDanyoArmaEquipada == 1)
  {
      FloatingTextStringOnCreature("<cþ<<>* Romper Arma: fracaso, arma perforante equipada *</c>", oEjecutor, FALSE);
      return;
  }

  // Sin arma objetivo, no se rompe arma
  if(GetIsObjectValid(oArmaDefensor) == FALSE)
  {
      FloatingTextStringOnCreature("<cþ<<>* Romper Arma: fracaso, objetivo sin arma *</c>", oEjecutor, FALSE);
      return;
  }

  // Immunes a Romper arma
  if(GetIsDM(oDefensor) || GetIsDMPossessed(oDefensor) || GetPlotFlag(oDefensor) ||
     GetImmortal(oDefensor) || GetLocalInt(oDefensor, "JEFAZO"))
  {
      FloatingTextStringOnCreature("<cþ<<>* Romper Arma: fracaso, criatura inmune *</c>", oEjecutor, FALSE);
      return;
  }

  // Arma ya destrozada
  if(GetLocalInt(oArmaDefensor, "DOTE_ROMPERARMA_DESTROZADO"))
  {
      FloatingTextStringOnCreature("<cþ<<>* Romper Arma: fracaso, arma ya rota *</c>", oEjecutor, FALSE);
      return;
  }

  // Si es un arma magica superior, no nos deja
  if(BonoAtaqueMejoraMasAlto(oArmaEjecutor) < BonoAtaqueMejoraMasAlto(oArmaDefensor))
  {
      FloatingTextStringOnCreature("<cþ<<>* Romper Arma: fracaso, arma objetivo con un encantamiento superior *</c>", oEjecutor, FALSE);
      return;
  }

  int iAtaqueEjecutor1 = AtaqueCriatura(oEjecutor, oArmaEjecutor);
  int iCADefensor1 = GetAC(oDefensor);
  int iAtaqueEjecutor2 = AtaqueCriatura(oEjecutor, oArmaEjecutor) + BonoTamanyoArma(oEjecutor, oArmaEjecutor) + BonoTamanyoCriatura(oEjecutor, oDefensor) + iBonosEjecutor;
  int iAtaqueDefensor2 = AtaqueCriatura(oDefensor, oArmaDefensor) + BonoTamanyoArma(oDefensor, oArmaDefensor) + BonoTamanyoCriatura(oDefensor, oEjecutor);

  // Primero una tirada ataque vs CA
  if(iAtaqueEjecutor1 > iCADefensor1)
  {
      SendMessageToPC(oEjecutor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de ataque: *éxito*: "+IntToString(iAtaqueEjecutor1)+" Vs "+IntToString(iCADefensor1)+"</c>");
      SendMessageToPC(oDefensor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de ataque: *éxito*: "+IntToString(iAtaqueEjecutor1)+" Vs "+IntToString(iCADefensor1)+"</c>");

      // Segundo una tirada de ataque enfrentada
      if(iAtaqueEjecutor2 > iAtaqueDefensor2)
      {
          SendMessageToPC(oEjecutor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de ataque enfrentada: *éxito*: "+IntToString(iAtaqueEjecutor2)+" Vs "+IntToString(iAtaqueDefensor2)+"</c>");
          SendMessageToPC(oDefensor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de ataque enfrentada: *éxito*: "+IntToString(iAtaqueEjecutor2)+" Vs "+IntToString(iAtaqueDefensor2)+"</c>");

          int iMaximoGolpesArmaDefensor = StringToInt(Get2DAString("baseitems", "WeaponSize", GetBaseItemType(oArmaDefensor))); // 1 = tiny; 2 = small; 3 = medium; 4 = large.
          int iGolpesRecibidosArmaDefensor = GetLocalInt(oArmaDefensor, "DOTE_ROMPERARMA_GOLPES");
          int iDurezaArmaDefensor = iMaximoGolpesArmaDefensor - (iGolpesRecibidosArmaDefensor + 2);
          if(iDurezaArmaDefensor <= 0)
          {
              FloatingTextStringOnCreature("<c´þd>* Romper arma: éxito, arma rota *</c>", oEjecutor, FALSE);
              FloatingTextStringOnCreature("<cþ<<>* Te han roto el arma *</c>", oDefensor, FALSE);
              IPSafeAddItemProperty(oArmaDefensor, ItemPropertyEnhancementPenalty(5));
              IPRemoveMatchingItemProperties(oArmaDefensor, ITEM_PROPERTY_QUALITY, DURATION_TYPE_PERMANENT);
              IPSafeAddItemProperty(oArmaDefensor, ItemPropertyQuality(IP_CONST_QUALITY_DESTROYED));
              SetLocalInt(oArmaDefensor, "DOTE_ROMPERARMA_DESTROZADO", TRUE);
          }
          else
          {
              FloatingTextStringOnCreature("<c´þd>* Romper arma: éxito, arma del contrincante dañada *</c>", oEjecutor, FALSE);
              FloatingTextStringOnCreature("<cþ<<>* Te han dañado el arma *</c>", oDefensor, FALSE);
          }

          SendMessageToPC(oEjecutor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>daña el arma de su contrincante. Dureza: " + IntToString(iDurezaArmaDefensor) + ".</c>");
          SendMessageToPC(oDefensor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>daña el arma de su contrincante. Dureza: " + IntToString(iDurezaArmaDefensor) + ".</c>");
          SetLocalInt(oArmaDefensor, "DOTE_ROMPERARMA_GOLPES", iGolpesRecibidosArmaDefensor + 2);
      }
      else
      {
          SendMessageToPC(oEjecutor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de ataque enfrentada: *fallo*: "+IntToString(iAtaqueEjecutor2)+" Vs "+IntToString(iAtaqueDefensor2)+"</c>");
          SendMessageToPC(oDefensor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de ataque enfrentada: *fallo*: "+IntToString(iAtaqueEjecutor2)+" Vs "+IntToString(iAtaqueDefensor2)+"</c>");
          FloatingTextStringOnCreature("<cþ<<>* Romper arma: fracaso *</c>", oEjecutor, FALSE);
          FloatingTextStringOnCreature("<c´þd>* Resistes un intento de Romper Arma *</c>", oDefensor, FALSE);
      }
  }
  else
  {
      SendMessageToPC(oEjecutor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de ataque: *fallo*: "+IntToString(iAtaqueEjecutor1)+" Vs "+IntToString(iCADefensor1)+"</c>");
      SendMessageToPC(oDefensor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de ataque: *fallo*: "+IntToString(iAtaqueEjecutor1)+" Vs "+IntToString(iCADefensor1)+"</c>");
      FloatingTextStringOnCreature("<cþ<<>* Romper arma: fracaso *</c>", oEjecutor, FALSE);
      FloatingTextStringOnCreature("<c´þd>* Resistes un intento de Romper Arma *</c>", oDefensor, FALSE);
  }
}
