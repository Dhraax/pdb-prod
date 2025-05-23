// sr5.4
// Added code to check to see if resting in armor is set on if not do not display
// this option for party rest.
#include "hc_inc_pwdb_func"
#include "hc_inc_timecheck"

int StartingConditional()
{
    int iResult = FALSE;
    object oMod = GetModule();
    object oPC = GetPCSpeaker();
    int nSSB=SecondsSinceBegin();
    int iMinRest = GetLocalInt(oMod,"RESTBREAK")*nConv;
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST);
    if (GetItemACValue(oArmor) > 5 && GetLocalInt(GetModule(),"RESTARMORPEN"))
        {
        int iLastRest = GetPersistentInt(oMod, ("LastRest" + GetName(oPC, TRUE) + GetPCPlayerName(oPC)));
        int iRESTSYSTEM = GetLocalInt(oMod, "RESTSYSTEM");
        if (iRESTSYSTEM && iLastRest && ((iLastRest+iMinRest) > nSSB) && !GetPersistentInt(GetArea(oPC), "ALLOWREST"))
           iResult = FALSE;
        else
           iResult = TRUE;
        }
    return iResult;
}
