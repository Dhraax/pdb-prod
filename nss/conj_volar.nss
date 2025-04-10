//::///////////////////////////////////////////////
//:: VOLAR
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Volar.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 8 de Noviembre de 2011
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "mti_libreria"

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

  // End of Spell Cast Hook
  object oPC = OBJECT_SELF;
  string sNombreArea = GetName(GetArea(oPC));
  int iFallo = 0;
  effect eVolar;

  // En ciertas areas no se podra hacer la puerta dimensional
  if(GetLocalInt(GetArea(oPC), "NOPUERTADIMENSIONAL") == 1)
  {
      SendMessageToPC(oPC, "<cþ<<>Volar no se puede usar aquí, algo te lo impide.</c>");
      return;
  }

  if(GetIsAreaInterior(GetArea(oPC)) == TRUE) iFallo = 10;

  object oArmadura = GetItemInSlot(INVENTORY_SLOT_CHEST);
  if(GetIsObjectValid(oArmadura) == TRUE)
  {
      if(GetArmorType(oArmadura) > 3) iFallo = iFallo + 10;
  }

  // Vuelo
  if(d100() < iFallo) // Fracaso
  {
      eVolar = EffectDisappearAppear(GetLocation(oPC));
      DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVolar, oPC, 3.0));
      DelayCommand(1.1, SetImmortal(oPC, TRUE));
      DelayCommand(3.0, FadeToBlack(oPC, FADE_SPEED_FASTEST));
      DelayCommand(4.2, SetImmortal(oPC, FALSE));
      DelayCommand(4.2, FadeFromBlack(oPC, FADE_SPEED_FASTEST));
      DelayCommand(4.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(2), DAMAGE_TYPE_BLUDGEONING), oPC));
      DelayCommand(4.5, FloatingTextStringOnCreature("<cþ<<>¡El intento de volar fracasó y caes durante el vuelo!</c>", oPC, FALSE));
      DelayCommand(4.5, AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 5.0)));
  }
  else // Exito
  {
      eVolar = EffectDisappearAppear(GetSpellTargetLocation());
      DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVolar, oPC, 4.0));
      DelayCommand(1.1, SetImmortal(oPC, TRUE));
      DelayCommand(3.0, FadeToBlack(oPC, FADE_SPEED_FASTEST));
      DelayCommand(5.2, SetImmortal(oPC, FALSE));
      DelayCommand(5.2, FadeFromBlack(oPC, FADE_SPEED_FASTEST));
  }

  SignalEvent(oPC, EventSpellCastAt(oPC, GetSpellId(), FALSE));
  DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
