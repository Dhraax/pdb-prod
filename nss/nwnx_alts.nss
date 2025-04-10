#include "nwnx_creature"
#include "nwnx_weapon"

/* Adds nFeat to oCreature. Does not check if the creature already knows
 * the feat. If the feat has limited uses per day and is added to a PC,
 * the PC must relog for proper use limiting. If nLevel is specified,
 * the feat will also be added to the specified level stat list. */
int AddKnownFeat (object oCreature, int nFeat, int nLevel=-1);
int GetLevelByClassLevel(object oPC, int nClass, int nLevel);
/////////////////////
// implementations //
/////////////////////


int ModifyAbilityScore (object oCreature, int nAbility, int nValue) {
  if (NWNX_Creature_GetRawAbilityScore(oCreature, nAbility) + nValue < 3) {
    NWNX_Creature_SetRawAbilityScore(oCreature, nAbility, 3);
  }
  else
    NWNX_Creature_ModifyRawAbilityScore(oCreature, nAbility, nValue);

  return 1;
}

int AddKnownFeat (object oCreature, int nFeat, int nLevel=-1) {

  if (nLevel == 0)
      nLevel = GetHitDice(oCreature);

  if (nLevel > 0) {
    NWNX_Creature_AddFeatByLevel(oCreature, nFeat, nLevel);
  } else {
    NWNX_Creature_AddFeat(oCreature, nFeat);
  }

  return 1;

}

//::///////////////////////////////////////////////
//:: GetLevelByClassLevel
//:://////////////////////////////////////////////
/*
    Returns the level at which the PC had
    taken nLevels of nClass (e.g. for a PC
    that had taken their 9th ranger level at
    level 13, the parameters nClass =
    CLASS_TYPE_RANGER and nLevel = 9 would return
    13.)

    Returns -1 on error.
*/
//:://////////////////////////////////////////////
int GetLevelByClassLevel(object oPC, int nClass, int nLevel)
{
    int nClassLevel;
    int i;

    if(GetLevelByClass(nClass, oPC) < nLevel) return -1;

    for(i = 1; i <= GetHitDice(oPC); i++)
    {
        if(NWNX_Creature_GetClassByLevel(oPC, i) == nClass)
        {
            nClassLevel++;
        }
        if(nClassLevel == nLevel)
        {
            return i;
        }
    }

    return -1;
}
