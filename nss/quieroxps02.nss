#include "nw_i0_tool"
void main()
{
  object oPC = GetLastHostileActor();

  if(GetIsPC(oPC) != TRUE) return;

  if(GetLevelByClass(CLASS_TYPE_BARD, oPC) ||
     GetLevelByClass(CLASS_TYPE_ROGUE, oPC) ||
     GetLevelByClass(CLASS_TYPE_WIZARD, oPC) ||
     GetLevelByClass(CLASS_TYPE_SORCERER, oPC))
  {
      if(GetXP(oPC) < 3000)
      {
          RewardPartyXP(d2(2)+11, oPC, FALSE);
      }

      else
      {
          SendMessageToPC(oPC, "Ya has entrenado bastante. No te dará más experiencia.");
      }
  }

  else
  {
      SendMessageToPC(oPC, "Golpear a este estafermo no te supone ningún reto.");
  }
}

