#include "f_vampire_h"

void main()
{
  object oTarget = GetLocalObject(OBJECT_SELF, "FALLEN_VAMPIRE_VICTIM");
  DeleteLocalObject(OBJECT_SELF, "FALLEN_VAMPIRE_VICTIM");
  if(!GetIsObjectValid(oTarget)) return;
  if(!GetIsBitable(oTarget)) return;
  int targetHD = GetHitDice(oTarget);
  int myNeed = GetMaxHitPoints() - GetCurrentHitPoints();
  int iDuration = Determine_Vampire_Level(OBJECT_SELF);
  if(iDuration < 1) iDuration = 1;
  int myDrain = iDuration / 10;
  if(myDrain < 2) myDrain = 2;

  effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
  effect eVis2 = EffectVisualEffect(VFX_COM_BLOOD_CRT_RED);
  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
  effect eDrain = EffectNegativeLevel(Random(myDrain) + 1);
  effect eLink = EffectLinkEffects(eDrain, eDur);
  effect eRegen = SupernaturalEffect(EffectRegenerate(1, 1.0));

  Vampire_Fresh_Blood(OBJECT_SELF); //for the blood hunger system
  if(myNeed > 0)
  {
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRegen, OBJECT_SELF, IntToFloat(myNeed));
      if(GetBadBlood(oTarget))
      {
          ApplyBloodFX(OBJECT_SELF);
          FloatingTextStringOnCreature("La sangre fresca te refuerza, pero era impura.", OBJECT_SELF, FALSE);
      }
      else FloatingTextStringOnCreature("La sangre fresca te refuerza.", OBJECT_SELF, FALSE);
  }

  AssignCommand(OBJECT_SELF, ClearAllActions(TRUE));
  AssignCommand(OBJECT_SELF, ActionCastSpellAtObject(SPELL_ENDURANCE, OBJECT_SELF, METAMAGIC_ANY, TRUE, 3, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
  DelayCommand(0.2, SetCommandable(FALSE, OBJECT_SELF));
  DelayCommand(2.0, SetCommandable(TRUE, OBJECT_SELF));

  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(iDuration));
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
  FloatingTextStringOnCreature(GetName(OBJECT_SELF) + " drena tu esencia vital mientras estás indefenso.", oTarget);
}
