//::///////////////////////////////////////////////
//:: CONJURO CREAR COMIDA Y AGUA
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
  Crea diez raciones de comida y una columna de agua.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 22/08/2012
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
  /*
    Spellcast Hook Code
    Added 2003-07-07 by Georg Zoeller
    If you want to make changes to all spells,
    check x2_inc_spellhook.nss to find out more
  */

  if (!X2PreSpellCastCode())
  {
      // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
      return;
  }

  location lLugarConjuro = GetSpellTargetLocation();

  object oComida1 = CreateItemOnObject("comida");
  object oComida2 = CreateItemOnObject("comida");
  object oComida3 = CreateItemOnObject("comida");
  object oComida4 = CreateItemOnObject("comida");
  object oComida5 = CreateItemOnObject("comida");
  object oComida6 = CreateItemOnObject("comida");
  object oComida7 = CreateItemOnObject("comida");
  object oComida8 = CreateItemOnObject("comida");
  object oComida9 = CreateItemOnObject("comida");
  object oComida0 = CreateItemOnObject("comida");

  SetPlotFlag(oComida1, TRUE);
  SetPlotFlag(oComida2, TRUE);
  SetPlotFlag(oComida3, TRUE);
  SetPlotFlag(oComida4, TRUE);
  SetPlotFlag(oComida5, TRUE);
  SetPlotFlag(oComida6, TRUE);
  SetPlotFlag(oComida7, TRUE);
  SetPlotFlag(oComida8, TRUE);
  SetPlotFlag(oComida9, TRUE);
  SetPlotFlag(oComida0, TRUE);

  object oAgua = CreateObject(OBJECT_TYPE_PLACEABLE, "conj_agua", lLugarConjuro);
  DestroyObject(oAgua, HoursToSeconds(1));

  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(149), lLugarConjuro);
  DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
