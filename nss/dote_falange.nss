//Area Dote Falange PdB//

#include "pb_nivellanzador"
#include "x0_i0_spells"

void main()
{
  object oPC = OBJECT_SELF;
  effect eCA = ExtraordinaryEffect(EffectACIncrease(1, AC_DODGE_BONUS));

  if(GetHasSpellEffect(1328))
  {
      FloatingTextStringOnCreature("<cþ<<>** Posición de Falange Desactivada **</c>", oPC, FALSE);
      RemoveEffectsFromSpell(oPC, 1328);
      return;
  }

  //Sin escudo paves no hay Falange
  object oManoIzq = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
  if(GetBaseItemType(oManoIzq) != BASE_ITEM_TOWERSHIELD )
  {
   FloatingTextStringOnCreature("<cþ<<>* Tienes que tener equipado un escudo paves! *</c>", OBJECT_SELF, FALSE);
   return;
  }

  // Con efectos dayninos no puedes usarla
  int iFalloDote = FALSE;
  if(GetIsResting(oPC) || GetLocalInt(oPC, "DERRIBADO") || GetLocalInt(oPC, "SLIDING")) iFalloDote = TRUE;

  effect eEfecto = GetFirstEffect(oPC);
  while(GetIsEffectValid(eEfecto))
  {
      if(GetEffectType(eEfecto) == EFFECT_TYPE_CHARMED ||           GetEffectType(eEfecto) == EFFECT_TYPE_CONFUSED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_CUTSCENE_PARALYZE || GetEffectType(eEfecto) == EFFECT_TYPE_CUTSCENEIMMOBILIZE ||
         GetEffectType(eEfecto) == EFFECT_TYPE_DAZED ||             GetEffectType(eEfecto) == EFFECT_TYPE_DOMINATED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_ENTANGLE ||          GetEffectType(eEfecto) == EFFECT_TYPE_FRIGHTENED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_PARALYZE ||          GetEffectType(eEfecto) == EFFECT_TYPE_PETRIFY ||
         GetEffectType(eEfecto) == EFFECT_TYPE_SLEEP ||             GetEffectType(eEfecto) == EFFECT_TYPE_STUNNED) iFalloDote = TRUE;

      eEfecto = GetNextEffect(oPC);
  }

  if(iFalloDote == TRUE)
  {
      FloatingTextStringOnCreature("<cþ<<>* En tu estado no puedes activar la Posición de Falange *</c>", OBJECT_SELF, FALSE);
      return;
  }

 //Set and apply AOE object
  FloatingTextStringOnCreature("<c´þd>** Posicion de Falange Activada **</c>", oPC, FALSE);
  DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_NORMAL_20), oPC));
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCA, oPC);
  AssignCommand(oPC, SpeakString("¡Formación de Falange!"));
  effect eAOE = EffectAreaOfEffect(AOE_MOB_PROTECTION, "dote_falangea", "****", "dote_falangec");
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oPC, HoursToSeconds(100));

}


