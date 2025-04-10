//::///////////////////////////////////////////////
//:: FABRICAR OBJETO DE ARPISTA (pocion de Sabiduría de Lechuza mayor)
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Crea 1 pocion de Sabiduría de Lechuza mayor.
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
  FloatingTextStringOnCreature("* Creas una poción de Sabiduría de Lechuza *", oPC);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DECK), oPC);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_KNOCK), oPC);
  object oObjetoCreado = CreateItemOnObject("nw_it_mpotion018", oPC);
  DelayCommand(1.0, SetName(oObjetoCreado, "Poción de Sabiduría de Lechuza"));
  DelayCommand(1.0, SetDescription(oObjetoCreado, "Esta poción de Sabiduría de Lechuza la creó " + GetName(oPC) + " gracias a sus habilidades como arpista."));
  DelayCommand(1.0, IPRemoveAllItemProperties(oObjetoCreado, DURATION_TYPE_PERMANENT));
  DelayCommand(1.2, EncantamientoPociones(oObjetoCreado, 5));
  DelayCommand(1.0, SetIdentified(oObjetoCreado, TRUE));
  DelayCommand(1.0, SetStolenFlag(oObjetoCreado, TRUE));
  SetLocalInt(oPC, "ARPISTA_POCIONES", iNumPocionesCreadas + 1);
}
