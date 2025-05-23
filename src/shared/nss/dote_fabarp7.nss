//::///////////////////////////////////////////////
//:: FABRICAR OBJETO DE ARPISTA (guitarra)
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Crea 1 guitarra magica.
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
  if(GetLocalInt(oPC, "ARPISTA_INSTMAGICO") == TRUE)
  {
      FloatingTextStringOnCreature("¡No puedes crear más instrumentos mágicos hasta el próximo reinicio del servidor!", oPC, FALSE);
      return;
  }

  // Costes de Oro y bonos de XP
  if(Costes(oPC, 500, 20) == FALSE) return;

  // Ajustes objeto
  FloatingTextStringOnCreature("* Creas una guitarra mágica *", oPC);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DECK), oPC);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_KNOCK), oPC);
  object oObjetoCreado = CreateItemOnObject("zep_guitar", oPC);
  DelayCommand(1.0, SetName(oObjetoCreado, "Guitarra mágica de " + GetName(oPC)));
  DelayCommand(1.0, SetDescription(oObjetoCreado, "Esta guitarra mágica la creó " + GetName(oPC) + " gracias a sus habilidades como arpista. Es mágica y contiene un poderoso hechizo mágico que puede descargarse."));
  DelayCommand(1.0, EncantamientoPropiedadLanzarConjuro(oObjetoCreado, iRango));
  DelayCommand(1.0, EncantamientoPropiedadBonificadorHabilidad(oObjetoCreado, iRango, 11));
  DelayCommand(1.0, SetIdentified(oObjetoCreado, TRUE));
  DelayCommand(1.0, SetPlotFlag(oObjetoCreado, TRUE));
  DelayCommand(1.0, SetStolenFlag(oObjetoCreado, TRUE));
  SetLocalInt(oPC, "ARPISTA_INSTMAGICO", TRUE);
}
