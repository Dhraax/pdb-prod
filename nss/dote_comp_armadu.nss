//::///////////////////////////////////////////////
//:: COMPETENCIAS CON ARMADURAS
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
    Regula las competencias con armaduras
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 18 de Mayo de 2011
//:://////////////////////////////////////////////


#include "mti_libreria"

void AplicarCompetenciaArmadura(object oPC, object oObjeto)
{
  int iDoteCompetencia, iAtaque;

  switch(GetArmorType(oObjeto))
  {
      case 1: iAtaque = 0; iDoteCompetencia = 1205; break; // Padded
      case 2: iAtaque = 0; iDoteCompetencia = 1205; break; // Leather
      case 3: iAtaque = 1; iDoteCompetencia = 1205; break; // Studded Leather / Hide
      case 4: iAtaque = 2; iDoteCompetencia = 1206; break; // Chain Shirt / Scale Mail
      case 5: iAtaque = 5; iDoteCompetencia = 1206; break; // Chainmail / Breastplate
      case 6: iAtaque = 7; iDoteCompetencia = 1207; break; // Splint Mail / Banded Mail
      case 7: iAtaque = 7; iDoteCompetencia = 1207; break; // Half-Plate
      case 8: iAtaque = 8; iDoteCompetencia = 1207; break; // Full Plate
      default:  iDoteCompetencia = FALSE; break;
  }

  // Si nos equipamos un objeto que no requiere competencia, no pasa nada
  if(iDoteCompetencia == FALSE) return;

  if(GetHasFeat(iDoteCompetencia, oPC) == FALSE)
  {
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackDecrease(iAtaque)), oPC);
      if(GetLocalInt(oPC, "PB_EFECTOS_EVENTO_EQUIPAR"))
      {
          FloatingTextStringOnCreature("<cþ<<>* No eres competente con "+GetName(oObjeto)+" *</c>",oPC, FALSE);
          DelayCommand(0.2, SendMessageToPC(oPC, "<cþ>" + GetName(oObjeto)+" te aplica un penalizador de <cþ>-"+IntToString(iAtaque)+"</c> al Ataque.</c>"));
          DeleteLocalInt(oPC, "PB_EFECTOS_EVENTO_EQUIPAR");
      }
  }
}

void main()
{
  object oArmadura = GetItemInSlot(INVENTORY_SLOT_CHEST);

  if(!GetIsObjectValid(oArmadura)) return;

  AplicarCompetenciaArmadura(OBJECT_SELF, oArmadura);
}
