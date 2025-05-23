//::///////////////////////////////////////////////
//:: REDUCCION DE VELOCIDAD DE LAS ARMADURAS
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
    Regula el efecto de reduccion de movimiento al equiparte armadura
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 27/03/2012
//:://////////////////////////////////////////////

#include "mti_libreria"
#include "lib_race"

void main()
{
  object oPC = OBJECT_SELF;

  object oArmadura = GetItemInSlot(INVENTORY_SLOT_CHEST);

  if(!GetIsObjectValid(oArmadura) || PB_Race_GetIsDwarf(oPC) || GetRacialType(oPC) == RACIAL_TYPE_DUERGAR) return;

  int iEntrenamiento2 = ObtenerIntPersistente(oPC, "ENTRENAMIENTOGU2");
  int iTipoArmadura = GetArmorType(oArmadura);

  if(iTipoArmadura >= 1 && iTipoArmadura <= 3) ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectMovementSpeedDecrease(5)), oPC);
  else if(iTipoArmadura == 4 || iTipoArmadura == 5) ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectMovementSpeedDecrease(10 - iEntrenamiento2)), oPC);
  else if(iTipoArmadura >= 6 && iTipoArmadura <= 8) ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectMovementSpeedDecrease(20 - iEntrenamiento2)), oPC);
  GuardarIntPersistente(oPC, "bReduccion_Vel",1);
}
