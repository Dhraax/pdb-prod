// hcr3 8/3/2003
// fix partrest
// hc_c_plrest
// sr5.4
//pc pary leader rest from conversation
#include "hc_text_rest"

void main()
{
object oPC = GetLastSpeaker();
int iRestOption;
object oPlayer = GetFirstFactionMember(oPC);
while (GetIsObjectValid(oPlayer))
 {
     // hcr3 8/3/2003
     if (GetIsInCombat(oPlayer)|| (GetArea(oPC) != GetArea(oPlayer)
        && GetTag(GetArea(oPlayer)) != "plano_fuga")
        || IsInConversation(oPlayer))
     {
        if (oPlayer != oPC)
        {
          SendMessageToPC(oPC, PCANTREST);
          return;
        }
     }
     oPlayer = GetNextFactionMember(oPC);
 }
oPlayer = GetFirstFactionMember(oPC);
while (GetIsObjectValid(oPlayer))
  {
    iRestOption = GetLocalInt(oPlayer, "RestOption");
    if (oPC != oPlayer)
    {
    if (iRestOption == 0)
        {
          object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPlayer);
          if (GetIsObjectValid(oArmor) && GetItemACValue(oArmor) > 5 && GetLocalInt(GetModule(),"RESTARMORPEN"))
            AssignCommand(oPlayer, ActionUnequipItem(oArmor));
          SetLocalInt(oPlayer, "REST", 1);
          SendMessageToPC(oPlayer, "Option 0");
          DelayCommand(3.0, AssignCommand(oPlayer, ActionRest()));
        }
        else if (iRestOption == 1)
        {
          SetLocalInt(oPlayer, "REST", 1);
          SendMessageToPC(oPlayer, "Option 1");
          DelayCommand(3.0, AssignCommand(oPlayer, ActionRest()));
        }
    }
    oPlayer = GetNextFactionMember(oPC);
  }
SetLocalInt(oPC, "REST", 1);
SendMessageToPC(oPC, "Party Rest");
DelayCommand(2.0, AssignCommand(oPC, ActionRest()));
}

