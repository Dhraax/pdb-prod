#include "bbs_include"
void main()
{
  object oPC = GetPCSpeaker();
  object oNotice = GetItemPossessedBy(oPC, "bbs_notice");
  if (GetIsObjectValid(oNotice)) {
    if(GetStealthMode(oPC) == STEALTH_MODE_DISABLED) {
        string nPoster = GetName(oPC) + " (" + GetPCPlayerName(oPC) + ")";
        string nTitle = GetLocalString(oNotice,"#T");
        string nMessage = GetLocalString(oNotice,"#M");
        string sRegion = GetLocalString(OBJECT_SELF, "REG");
        ActionTakeItem(oNotice, oPC);
        bbs_add_notice(OBJECT_SELF, nPoster, nTitle, nMessage, "", "", sRegion);
        bbs_change_page(-1000);
    } else {
        FloatingTextStringOnCreature("No puedes colgar carteles regionales anónimos", GetPCSpeaker());
    }
  }
}
