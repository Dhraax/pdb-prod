//::///////////////////////////////////////////////
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
  Ataque furtivo improvisado, del Bribon Arcano
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 14/08/2012
//:://////////////////////////////////////////////

#include "x0_i0_spells"

void main()
{
  object oPC = OBJECT_SELF;
  object oObjetivo = GetSpellTargetObject();
  location lLugarObjetivo = GetItemActivatedTargetLocation();

  // Antisaturamiento
  if(GetLocalInt(oPC, "FINTA_NOSATURAR"))
  {
      FloatingTextStringOnCreature("<cþ<<>* No puedes realizar un ataque furtivo improvisado otra vez tan rápidamente *</c>", oPC, FALSE);
      return;
  }

  // A ti mismo no!
  if(oObjetivo == oPC)
  {
      FloatingTextStringOnCreature("<cþ<<>* Sólo puedes realizar un ataque furtivo improvisado a ti mismo *</c>", oPC, FALSE);
      return;
  }

  // Solo a criaturas
  if(GetObjectType(oObjetivo) != OBJECT_TYPE_CREATURE)
  {
      FloatingTextStringOnCreature("<cþ<<>* Sólo puedes realizar un ataque furtivo improvisado a criaturas *</c>", oPC, FALSE);
      return;
  }

  // Solo a los cercanos
  if(GetDistanceBetween(oPC, oObjetivo) > 4.0)
  {
      FloatingTextStringOnCreature("<cþ<<>* Estás demasiado lejos para realizar un ataque furtivo improvisado a esa criatura *</c>", oPC, FALSE);
      return;
  }

  // Si no nos esta atacando nanay
  // Pienso que el ataque furtivo improvisado no deberia tener esta parte
  /*if(GetAttackTarget(oObjetivo) != oPC)
  {
      FloatingTextStringOnCreature("<cþ<<>* No puedes realizar un ataque furtivo improvisado a una critura que no te ataca *</c>", oPC, FALSE);
      return;
  }*/


  // Animaciones
  effect eSan = EffectEthereal();
  AssignCommand(oPC, SetFacingPoint(GetPosition(oObjetivo)));
  DelayCommand(0.1, SetActionMode(oPC, ACTION_MODE_STEALTH, TRUE));
  DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSan, oPC, 4.0));
  DelayCommand(0.5, SetCommandable(FALSE,oPC));
  DelayCommand(2.0, AssignCommand(oPC, ActionAttack(oObjetivo)));
  DelayCommand(2.2, SetCommandable(TRUE,oPC));

  SetLocalInt(oPC, "FINTA_NOSATURAR", TRUE);
  DelayCommand(6.0, DeleteLocalInt(oPC, "FINTA_NOSATURAR"));
}

