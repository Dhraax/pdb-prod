//::///////////////////////////////////////////////
//:: DISPARO LOCALIZADO
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Disparo localizado, ya no usara disciplina.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 4 de Abril de 2012
//:://////////////////////////////////////////////

#include "nw_i0_generic"
#include "nw_i0_spells"
#include "pb_tiradas_inc"

void main()
{
  object oPC = OBJECT_SELF;
  object oDefensor = GetSpellTargetObject();

  // No puedes disparar a uno mismo
  if(oPC == oDefensor)
  {
      FloatingTextStringOnCreature("<cþ<<>* ¡No puedes dispararte a ti mismo! *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // Solo se usa con armas a distancia
  object oArmaEquipada = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
  if(GetWeaponRanged(oArmaEquipada) == FALSE)
  {
      FloatingTextStringOnCreature("<cþ<<>* ¡Disparo localizado sólo funciona con armas a distancia! *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // Eliminamos municion
  int iTipoArmaDistancia = GetBaseItemType(oArmaEquipada);
  int iTipoDanyo = DAMAGE_TYPE_PIERCING;
  if(iTipoArmaDistancia == BASE_ITEM_DART || iTipoArmaDistancia == BASE_ITEM_SHURIKEN || iTipoArmaDistancia == BASE_ITEM_THROWINGAXE)
  {
      if(iTipoArmaDistancia == BASE_ITEM_THROWINGAXE) iTipoDanyo = DAMAGE_TYPE_SLASHING;
      int iCantidadArmaArrojadiza = GetItemStackSize(oArmaEquipada);
      if(iCantidadArmaArrojadiza == 1) DestroyObject(oArmaEquipada);
      else SetItemStackSize(oArmaEquipada, iCantidadArmaArrojadiza - 1);
  }
  else
  {
      int iSlotMunicion, iObjetoBaseMunicion, iCantidadMunicion;
      if(iTipoArmaDistancia == BASE_ITEM_SHORTBOW || iTipoArmaDistancia == BASE_ITEM_LONGBOW) { iSlotMunicion = INVENTORY_SLOT_ARROWS; iObjetoBaseMunicion = BASE_ITEM_ARROW;}
      else if(iTipoArmaDistancia == BASE_ITEM_LIGHTCROSSBOW || iTipoArmaDistancia == BASE_ITEM_HEAVYCROSSBOW) { iSlotMunicion = INVENTORY_SLOT_BOLTS; iObjetoBaseMunicion = BASE_ITEM_BOLT;}
      else if(iTipoArmaDistancia == BASE_ITEM_SLING) { iSlotMunicion = INVENTORY_SLOT_BULLETS; iObjetoBaseMunicion = BASE_ITEM_BULLET; iTipoDanyo = DAMAGE_TYPE_BLUDGEONING;}

      object oMunicion = GetItemInSlot(iSlotMunicion, oPC);
      if(GetIsObjectValid(oMunicion) == FALSE)
      {
          object oBuscandoMunicion = GetFirstItemInInventory(oPC);
          int iMunicionEncontrada = FALSE;
          while(GetIsObjectValid(oBuscandoMunicion) == TRUE && iMunicionEncontrada == FALSE)
          {
              if(GetBaseItemType(oBuscandoMunicion) == iObjetoBaseMunicion)
              {
                  iCantidadMunicion = GetItemStackSize(oBuscandoMunicion);
                  if(iCantidadMunicion == 1) DestroyObject(oBuscandoMunicion);
                  else SetItemStackSize(oBuscandoMunicion, iCantidadMunicion - 1);

                  DelayCommand(0.4, AssignCommand(oPC, ActionEquipItem(oBuscandoMunicion, iSlotMunicion)));

                  iMunicionEncontrada = TRUE;
              }

              oBuscandoMunicion = GetNextItemInInventory(oPC);
          }

          if(iMunicionEncontrada == FALSE) // Si no hay municion, pues nanay
          {
              FloatingTextStringOnCreature("<cþ<<>* ¡No tienes munición! *</c>", OBJECT_SELF, FALSE);
              return;
          }
      }
      else
      {
          iCantidadMunicion = GetItemStackSize(oMunicion);
          if(iCantidadMunicion == 1) DestroyObject(oMunicion);
          else SetItemStackSize(oMunicion, iCantidadMunicion - 1);
      }
  }

  // Atacamos, hostilidad
  DelayCommand(0.8, AssignCommand(oPC, ActionAttack(oDefensor, FALSE)));

  if(!GetIsEnemy(oPC, oDefensor) && !GetIsPC(oDefensor))
  {
      AdjustReputation(oPC, oDefensor, -100);
      AssignCommand(oDefensor, ActionAttack(oPC));
  }

  // Tipo Disparo
  effect eLink;
  string sTipoDisparo;
  if(GetSpellId() == 912) sTipoDisparo = "brazo";
  else sTipoDisparo = "pierna";

  // Tirada
  int iNiveloPC = GetHitDice(oPC);
  int iCantidadDanyo, iTipoMejora, iExito;
  if(iNiveloPC <= 3) { iCantidadDanyo = d8(); iTipoMejora = DAMAGE_POWER_NORMAL;}
  else if(iNiveloPC <= 6) { iCantidadDanyo = d8() + 3; iTipoMejora = DAMAGE_POWER_NORMAL;}
  else if(iNiveloPC <= 9) { iCantidadDanyo = d8() + 6; iTipoMejora = DAMAGE_POWER_PLUS_ONE;}
  else if(iNiveloPC <= 12) { iCantidadDanyo = d8() + 9; iTipoMejora = DAMAGE_POWER_PLUS_TWO;}
  else if(iNiveloPC <= 15) { iCantidadDanyo = d8() + 12; iTipoMejora = DAMAGE_POWER_PLUS_THREE;}
  else if(iNiveloPC <= 18) { iCantidadDanyo = d8() + 15; iTipoMejora = DAMAGE_POWER_PLUS_FOUR;}
  else if(iNiveloPC <= 21) { iCantidadDanyo = d8() + 18; iTipoMejora = DAMAGE_POWER_PLUS_FIVE;}
  else if(iNiveloPC <= 25) { iCantidadDanyo = d8() + 21; iTipoMejora = DAMAGE_POWER_PLUS_SIX;}
  else if(iNiveloPC <= 30) { iCantidadDanyo = d8() + 24; iTipoMejora = DAMAGE_POWER_PLUS_SEVEN;}
  else { iCantidadDanyo = d8() + 27; iTipoMejora = DAMAGE_POWER_PLUS_EIGHT;}

  int iAtaquePC = AtaqueCriatura(oPC, oArmaEquipada) - 4;
  int iCaDefensor = GetAC(oDefensor);

  if(iAtaquePC >= iCaDefensor)
  {
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iCantidadDanyo, iTipoDanyo, iTipoMejora), oDefensor);
      SendMessageToPC(oPC, "<c›þþ>" + GetName(oPC) + "</c> <cþ–2>realiza un disparo localizado, "+sTipoDisparo+": *éxito*: "+IntToString(iAtaquePC)+" Vs "+IntToString(iCaDefensor)+"</c>");
      SendMessageToPC(oDefensor, "<c›þþ>" + GetName(oPC) + "</c> <cþ–2>realiza un disparo localizado, "+sTipoDisparo+": *éxito*: "+IntToString(iCaDefensor)+" Vs "+IntToString(iAtaquePC)+"</c>");
      if(FortitudeSave(oDefensor, 10 + iCantidadDanyo) == 0) iExito = TRUE;
      else iExito = FALSE;
  }
  else
  {
      SendMessageToPC(oPC, "<c›þþ>" + GetName(oPC) + "</c> <cþ–2>realiza un disparo localizado, "+sTipoDisparo+": *fallo*: "+IntToString(iAtaquePC)+" Vs "+IntToString(iCaDefensor)+"</c>");
      SendMessageToPC(oDefensor, "<c›þþ>" + GetName(oPC) + "</c> <cþ–2>realiza un disparo localizado, "+sTipoDisparo+": *fallo*: "+IntToString(iCaDefensor)+" Vs "+IntToString(iAtaquePC)+"</c>");
      iExito = FALSE;
  }

  if(iExito == TRUE)
  {
      object oMod = GetModule();
      string sID = "DOTE_DISLOC_" + GetName(oDefensor, TRUE) + GetPCPlayerName(oDefensor);
      int iGolpesDislocRecibidos = GetLocalInt(oMod, sID);
      SetLocalInt(oMod, sID , iGolpesDislocRecibidos + 1);
      DelayCommand(60.0, SetLocalInt(oMod, sID , iGolpesDislocRecibidos - 1));

      FloatingTextStringOnCreature("<c´þd>* Disparo localizado, "+sTipoDisparo+": éxito *</c>", oPC, FALSE);
      if(sTipoDisparo == "brazo")
      {
          RemoveEffectsFromSpell(oDefensor, 912);
          FloatingTextStringOnCreature("<cþ<<>* Te han disparado en el brazo *</c>", oDefensor, FALSE);
          eLink = ExtraordinaryEffect(EffectAttackDecrease((iGolpesDislocRecibidos + 1) * 2));
      }
      else
      {
          RemoveEffectsFromSpell(oDefensor, 913);
          FloatingTextStringOnCreature("<c´þd>* Te han disparado en la pierna *</c>", oDefensor, FALSE);
          eLink = ExtraordinaryEffect(EffectLinkEffects(EffectAbilityDecrease(ABILITY_DEXTERITY, (iGolpesDislocRecibidos + 1) * 2), EffectMovementSpeedDecrease((iGolpesDislocRecibidos + 1) * 20)));
      }

      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oDefensor, 60.0);
  }
  else
  {
      FloatingTextStringOnCreature("<cþ<<>* Disparo localizado, "+sTipoDisparo+": fracaso *</c>", oPC, FALSE);
      if(sTipoDisparo == "brazo") FloatingTextStringOnCreature("<c´þd>* Resistes un impacto localizado en el brazo *</c>", oDefensor, FALSE);
      else FloatingTextStringOnCreature("<c´þd>* Resistes un impacto localizado en la pierna *</c>", oDefensor, FALSE);
  }
}
