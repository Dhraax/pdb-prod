// HCR v3.2.0 - Fixed negative hitpoint bug.
//::////////////////////////////////////////////////////////////////////////////
//:: FileName:  HC_Take_Level
//::////////////////////////////////////////////////////////////////////////////
/*

*/
//::////////////////////////////////////////////////////////////////////////////
#include "HC_Inc_PWDB_Func"
#include "HC_Text_Health"
//::////////////////////////////////////////////////////////////////////////////
void main()
{
  object oRespawner = OBJECT_SELF;
  int nHD = GetHitDice(oRespawner);
  int nNewXP = (((nHD * (nHD - 1)) / 2) * 1000) - (((nHD - 1) * 1000) / 2);
  SetXP(oRespawner, nNewXP);

  // Hark - Prevent loss of level from putting the PC at negative hitpoints.
  int nCHP = GetCurrentHitPoints(oRespawner);
  if (nCHP < 1)
    {
     int nHeal = (abs(nCHP) + 1);
     effect eHeal = EffectHeal(nHeal);
     ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oRespawner);
    }
}
//::////////////////////////////////////////////////////////////////////////////
