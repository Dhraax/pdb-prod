// hcr3
// took out multiclass code as fixed.
// sr6.0
// added check for making sure you dont go into neg. hitpoints from losing a level.
// also current hitpoints should remain the same unless total hitpoints drops them.
// 5.4
// added check to make sure xp would never be less than 1.
// 5.3 changed public cd key to player name
// to use this script set local int TAKEXP
// to the experience you want to take then execute this script.
#include "hc_inc_pwdb_func"
// hcr3
// this should be called every time you take xp from a player.
// this fixes problems with losing levels making you die due to low hitpoints.
// you need to set localint "TAKEEXP" to xp to lose for the pc before you execute this script.

#include "hc_text_health"

void main()
{
    object oObject = OBJECT_SELF;
    int iCurrXP = GetXP(oObject);
    int iExp = GetLocalInt(oObject, "TAKEXP");
    DeleteLocalInt(oObject, "TAKEXP");
    object oMod = GetModule();
    int nHD = GetHitDice(oObject);
    int nExp = (iCurrXP-iExp);
    // sr6.0
    int nCurrHP = GetCurrentHitPoints(oObject);
    // 5.4 change
    if (nExp < 1) nExp = 1;
    SetXP(oObject, nExp);
    // sr6.0 losing levels can never cause negative hitpoints.
    // and should almost never be less than current (BW BUG).
    if (nCurrHP > GetMaxHitPoints(oObject))
        nCurrHP = GetMaxHitPoints(oObject);
    if (GetCurrentHitPoints(oObject) < 1)
    {
        int nHeal = (nCurrHP - GetCurrentHitPoints(oObject));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oObject);
    }
    else if (nCurrHP < GetCurrentHitPoints(oObject))
    {
        int nHeal = (GetCurrentHitPoints(oObject) - nCurrHP);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oObject);
    }
}

