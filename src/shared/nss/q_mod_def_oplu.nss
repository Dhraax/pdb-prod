#include "x0_i0_henchman"
#include "q_inc_switches"

void main()
{
    object oPC = GetPCLevellingUp();

    // Level-up Henchmen
    if (GetModuleSwitchValue(MODULE_SWITCH_AUTO_LEVEL_HENCHMEN) == TRUE)
    {
         //Each time the PC advances a level, advance the henchman's level as well
         LevelUpXP1Henchman(oPC);
    }
}
