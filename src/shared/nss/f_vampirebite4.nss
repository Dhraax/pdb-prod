#include "f_vampire_h"
#include "x2_inc_itemprop"

void makeThrall(object oTarget, object oPJ)
{


effect ePoly = SupernaturalEffect(EffectPolymorph(POLYMORPH_TYPE_ZOMBIE));
effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
effect eDom = SupernaturalEffect(EffectCutsceneDominated());
ePoly = SupernaturalEffect(EffectLinkEffects(eVis, ePoly));
eDom = SupernaturalEffect(EffectLinkEffects(ePoly, eDom));
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDom, oTarget);

//Colocar nueva apariencia.
int nRandom=1;
if (GetClassByPosition(1,oTarget)==CLASS_TYPE_CLERIC || GetClassByPosition(1,oTarget)==CLASS_TYPE_WIZARD || GetClassByPosition(1,oTarget)==CLASS_TYPE_SORCERER)
{
    do
    {
      nRandom = Random(148)+1;
    }while ((nRandom!=62) && (nRandom!=148));

}
else
{
    do
    {
      nRandom = Random(199)+1;
    }while (!((nRandom>=70) && (nRandom<=71)) && !((nRandom>=195) && (nRandom<=198)));
}

SetCreatureAppearanceType(oTarget,nRandom);

//Inmunidades de los zombis.

effect eIDisease = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_DISEASE));
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eIDisease, oTarget);

effect eIPoison = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_POISON));
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eIPoison, oTarget);

effect eIDeathSpells = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_DEATH));
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eIDeathSpells,oTarget);

effect eISneakAttack = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK));
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eISneakAttack, oTarget);

effect eINegative = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eINegative, oTarget);

effect eICriticalHit = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eICriticalHit, oTarget);

effect eImmuReduccionCaracteristica = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuReduccionCaracteristica, oTarget);

effect eImmuConjurosEnajenadores = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuConjurosEnajenadores, oTarget);

effect eImmuParalisis = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuParalisis, oTarget);



itemproperty ipAdd = ItemPropertySpecialWalk(1);
IPSafeAddItemProperty(oTarget, ipAdd);

  if(GetHasFeat(1203, OBJECT_SELF) == TRUE)  // Aumentar convocacion
  {
      SendMessageToPC(oPJ, "<cþ–2>Aumentar convocación: convocas una criatura con mejores aptitudes físicas (+4 a Fue y Con).</c>");
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAbilityIncrease(ABILITY_STRENGTH, 4)), oTarget);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAbilityIncrease(ABILITY_CONSTITUTION, 4)), oTarget);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(217), oTarget);
  }
}

void main()
{
  object oPC = OBJECT_SELF;
  object oTarget = GetLocalObject(OBJECT_SELF, "FALLEN_VAMPIRE_VICTIM");
  DeleteLocalObject(OBJECT_SELF, "FALLEN_VAMPIRE_VICTIM");
  if(!GetIsObjectValid(oTarget)) return;
  if(!GetIsBitable(oTarget) || GetIsPC(oTarget)) return;
  makeThrall(oTarget, oPC);
  ChangeToStandardFaction(oTarget, STANDARD_FACTION_HOSTILE);
  SetIsTemporaryFriend(oTarget);
  SetIsTemporaryFriend(OBJECT_SELF, oTarget);
  Vampire_Fresh_Blood(OBJECT_SELF); //for the blood hunger system
  if(Random(10) == 0 || GetBadBlood(oTarget))
  {
      DestroyObject(oTarget);
      if(GetBadBlood(oTarget))
      {
          ApplyBloodFX(OBJECT_SELF);
          FloatingTextStringOnCreature("Has fallado al crear a un esclavo, y la sangre era impura también.", OBJECT_SELF, FALSE);
      }
      else FloatingTextStringOnCreature("Has fallado al crear a un esclavo.", OBJECT_SELF, FALSE);
  }
  else
  {
      FloatingTextStringOnCreature("El esclavo fue creado satisfactoriamente.", OBJECT_SELF, FALSE);
      ExecuteScript("f_vampire_thrall", oTarget);
  }
}
