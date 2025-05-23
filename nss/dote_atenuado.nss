//::///////////////////////////////////////////////
//:: DOTE DANYO ATENUADO
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Dote danyo atenuado.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 23 de Septiembre de 2012
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "mti_libreria"

void main()
{
  object oPC = OBJECT_SELF;

  if(GetLocalInt(oPC, "SUBDUAL"))
  {
      DeleteLocalInt(oPC,"SUBDUAL");
      FloatingTextStringOnCreature("<c´þd>* Activado modo daño completo *</c>",oPC,FALSE);
      ReaplicarEfectosPB(oPC,TRUE, FALSE, TRUE);
  }
  else
  {
      SetLocalInt(oPC,"SUBDUAL", TRUE);
      FloatingTextStringOnCreature("<c´þd>* Activado modo daño no letal *</c>",oPC,FALSE);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackDecrease(4)), oPC);
  }
}
