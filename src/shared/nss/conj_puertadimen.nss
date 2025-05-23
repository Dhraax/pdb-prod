//::///////////////////////////////////////////////
//:: PUERTA DIMENSINAL
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Puerta Dimensional.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 29 de Marzo de 2011
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

  // End of Spell Cast Hook

  //Declare major variables
  object oLanzador = OBJECT_SELF;
  location lObjetivo = GetSpellTargetLocation();

  // En ciertas areas no se podra hacer la puerta dimensional
  if(GetLocalInt(GetArea(oLanzador), "NOPUERTADIMENSIONAL") == 1)
  {
      SendMessageToPC(oLanzador, "<cþ<<>Puerta dimensional no se puede usar aquí, algo te lo impide.</c>");
      return;
  }

  // Ancla dimensional
  if(GetHasSpellEffect(990))
  {
      FloatingTextStringOnCreature("<cþ<<>El ancla dimensional te impide usar Puerta dimensional.</c>", OBJECT_SELF);
      return;
  }

  // Si es umbra y es usado a traves de su habilidad, unos efectos distintos
  if(GetStringLowerCase(GetSubRace(oLanzador)) == "umbra" && GetSpellCastItem() != OBJECT_INVALID && GetTag(GetSpellCastItem()) == "crr_gtele")
  {
      effect eGrasa = EffectAreaOfEffect(AOE_PER_GREASE, "****", "****", "****");
      effect eNegrata = EffectVisualEffect(1599);
      effect eEstelaNegra = EffectVisualEffect(816);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oLanzador, 2.2);
      ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eGrasa, GetLocation(oLanzador), 2.0);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNegrata, oLanzador, 5.0);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEstelaNegra, oLanzador, 5.0);
      AssignCommand(oLanzador, PlayAnimation(ANIMATION_FIREFORGET_STEAL));
      DelayCommand(2.0, AssignCommand(oLanzador, ActionJumpToLocation(lObjetivo)));
      DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eGrasa, lObjetivo, 4.0));
  }
  else  // Efectos normales
  {
      effect eTelepor1 = EffectVisualEffect(VFX_FNF_PWSTUN);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oLanzador, 2.2);
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(776), GetLocation(oLanzador));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eTelepor1, oLanzador);
      DelayCommand(2.0, AssignCommand(oLanzador, ActionJumpToLocation(lObjetivo)));
      DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eTelepor1, lObjetivo));
      DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(777), lObjetivo));
      DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
  }
}
