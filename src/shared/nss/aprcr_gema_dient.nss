int StartingConditional()
{
object oPC = GetPCSpeaker();

if (GetItemPossessedBy(oPC, "ZEP_CRE_EMTG") == OBJECT_INVALID)
return FALSE;
return TRUE;
}
