// sr5.2
void main()
{
object oPC = GetLastSpeaker();
object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
if (GetIsObjectValid(oArmor))
    ActionUnequipItem(oArmor);
SetLocalInt(oPC, "REST", 1);
DelayCommand(2.0, AssignCommand(oPC, ActionRest()));
}
