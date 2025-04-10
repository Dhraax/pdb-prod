// 5.3 changed public cd key to player name
/*
    hc_fb_play_rest
    by Celedhros, 26 July 2002

    If the Hardcore Resting System is in use, this script will check to see
    when the PC last rested and set the Resting Panel Button in the UI to
    flash if they are eligible to rest again.
*/

#include "hc_inc"
#include "hc_inc_timecheck"

void main()
{
    object oPC=OBJECT_SELF;
    object oBedroll;
    int iMinRest = GetLocalInt(oMod,"RESTBREAK")*nConv;
    int iBedroll;
    string sPCName=GetName(oPC, TRUE);
    string sCDK=GetPCPlayerName(oPC);
    string sID=sPCName+sCDK;
//  Check to see if the bedroll system is being used and whether or not the PC has one
    if(GetLocalInt(oMod,"BEDROLLSYSTEM"))
    {
        if(GetIsObjectValid(oBedroll=GetItemPossessedBy(oPC,"bedroll")))
            iBedroll=1;
    }

//  Get the time last rested and the current time.
    int iLastRest = GetPersistentInt(oMod, ("LastRest"+sID));
//  If PC does not have a bedroll, set rest period to 24 hours
    if(GetLocalInt(oMod,"BEDROLLSYSTEM") && !iBedroll)
    {
        iMinRest = 24*nConv;
    }
//  If it has been at least as long as the minimum rest period, set rest panel to flash
    if (GetLocalInt(oMod,"RESTSYSTEM") && iLastRest && (iLastRest+iMinRest >= SecondsSinceBegin()))
    {
        SetPanelButtonFlash(oPC,PANEL_BUTTON_REST,1);
    }
    return;
}
