//::///////////////////////////////////////////////
//:: FABRICAR OBJETO DE ARPISTA (insignia de arpista)
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Crea 1 insignia de arpista.
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
  int iRango = CalculoDelRangoArpista(oPC);

  // Limitacion de creacion por reinicios
  if(GetLocalInt(oPC, "ARPISTA_INSIGNIA") == TRUE)
  {
      FloatingTextStringOnCreature("¡No puedes crear más insignias hasta el próximo reinicio del servidor!", oPC, FALSE);
      return;
  }

  // Costes de Oro y bonos de XP
  if(Costes(oPC, 1000, 40) == FALSE) return;

  // Ajustes objeto
  FloatingTextStringOnCreature("* Creas una insignia arpista *", oPC);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DECK), oPC);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_KNOCK), oPC);
  object oObjetoCreado = CreateItemOnObject("pb_insigniarpist", oPC);
  DelayCommand(1.0, SetName(oObjetoCreado, GetName(oObjetoCreado) + " de " + GetName(oPC)));
  DelayCommand(1.0, SetDescription(oObjetoCreado, "Esta insignia arpista la creó " + GetName(oPC) + " gracias a sus habilidades como arpista."));
  DelayCommand(1.0, EncantamientoPropiedadBonificadorCaracteristica(oObjetoCreado, iRango));
  DelayCommand(1.0, EncantamientoPropiedadBonificadorHabilidad(oObjetoCreado, iRango));
  DelayCommand(1.0, EncantamientoPropiedadBonificadorHabilidad(oObjetoCreado, iRango));
  DelayCommand(1.0, EncantamientoPropiedadBonificadorHabilidad(oObjetoCreado, iRango));
  DelayCommand(1.0, SetIdentified(oObjetoCreado, TRUE));
  DelayCommand(1.0, SetPlotFlag(oObjetoCreado, TRUE));
  DelayCommand(1.0, SetStolenFlag(oObjetoCreado, TRUE));
  SetLocalInt(oPC, "ARPISTA_INSIGNIA", TRUE);
}
