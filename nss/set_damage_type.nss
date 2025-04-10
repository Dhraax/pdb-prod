void main()
{


object oCaster = OBJECT_SELF;
object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster);
string sItem = GetTag(oItem);
//SendMessageToPC(oCaster, sItem);


/* Archmage feat: Mastery of Elements */
if(GetLocalInt(oCaster, "archmage_mastery_elements") > 0)
{
    SetLocalInt(oCaster,"X2_L_LAST_RETVAR", GetLocalInt(oCaster, "archmage_mastery_elements"));
    return;
}

SetLocalInt(oCaster,"X2_L_LAST_RETVAR", 0);
}
