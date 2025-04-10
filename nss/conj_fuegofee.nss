//::///////////////////////////////////////////////
//:: FUEGO FEERICO
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Fuego Feerico.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 25 de Marzo de 2011
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "x0_i0_petrify"
#include "nw_i0_spells"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
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

  //Declare major variables
  object oCaster = OBJECT_SELF;
  int nCasterLvl = GetTotalCasterLevel(oCaster);
  location lTarget = GetSpellTargetLocation();

  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_NORMAL_10), lTarget);

  // Azul, verdoso o violaceo
  int iDado3 = d3();
  int iLuz1, iLuz2;
  if(iDado3 == 1) {iLuz1 = VFX_DUR_LIGHT_BLUE_5; iLuz2 = VFX_DUR_AURA_BLUE;}
  if(iDado3 == 2) {iLuz1 = 177; iLuz2 = VFX_DUR_AURA_GREEN;}
  else {iLuz1 = VFX_DUR_LIGHT_PURPLE_5; iLuz2 = VFX_DUR_AURA_PURPLE;}

  //Declare the spell shape, size and the location.  Capture the first target object in the shape.
  object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 5.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
  //Cycle through the targets within the spell shape until an invalid object is captured.
  while (GetIsObjectValid(oTarget))
  {
      //Fire spell cast at event for target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

      if(!MyResistSpell(oCaster, oTarget, 0.5))
      {
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(796), oTarget);
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(iLuz1), oTarget, 10.0);
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(iLuz2), oTarget, 10.0);
          RemoveEffectOfType(oTarget, EFFECT_TYPE_IMPROVEDINVISIBILITY);
          RemoveEffectOfType(oTarget, EFFECT_TYPE_INVISIBILITY);
          RemoveEffectOfType(oTarget, EFFECT_TYPE_DARKNESS);
          RemoveEffectOfType(oTarget, EFFECT_TYPE_CONCEALMENT);
      }

      //Select the next target within the spell shape.
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, 5.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
      DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
  }
}
