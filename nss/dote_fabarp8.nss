//::///////////////////////////////////////////////
//:: FABRICAR OBJETO DE ARPISTA (pocion de fuerza de toro mayor)
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Crea 1 pocion de fuerza de toro mayor.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 2 de Mayo de 2011
//:://////////////////////////////////////////////

#include "dote_fabarp_inc"

void main()
{
  // Variables
  object oPC = GetPCSpeaker();

  // Limitacion de creacion por reinicios
  int iNumPocionesCreadas = GetLocalInt(oPC, "ARPISTA_POCIONES");
  if(iNumPocionesCreadas >= 5)
  {
      FloatingTextStringOnCreature("¡No puedes crear más pociones hasta el próximo reinicio del servidor!", oPC, FALSE);
      return;
  }

  // Costes de Oro y bonos de XP
  if(Costes(oPC, 100, 5) == FALSE) return;

  // Ajustes objeto
  FloatingTextStringOnCreature("* Creas una poción de Fuerza de Toro *", oPC);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DECK), oPC);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_KNOCK), oPC);
  object oObjetoCreado = CreateItemOnObject("nw_it_mpotion015", oPC);
  DelayCommand(1.0, SetName(oObjetoCreado, "Poción de Fuerza de Toro"));
  DelayCommand(1.0, SetDescription(oObjetoCreado, "Esta poción de Fuerza de Toro la creó " + GetName(oPC) + " gracias a sus habilidades como arpista."));
  DelayCommand(1.0, IPRemoveAllItemProperties(oObjetoCreado, DURATION_TYPE_PERMANENT));
  DelayCommand(1.2, EncantamientoPociones(oObjetoCreado, 1));
  DelayCommand(1.0, SetIdentified(oObjetoCreado, TRUE));
  DelayCommand(1.0, SetStolenFlag(oObjetoCreado, TRUE));
  SetLocalInt(oPC, "ARPISTA_POCIONES", iNumPocionesCreadas + 1);
}
