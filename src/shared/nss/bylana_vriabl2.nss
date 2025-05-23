int StartingConditional()
{
object oPC = GetPCSpeaker();

if (GetItemPossessedBy(oPC, "relikia") == OBJECT_INVALID)
return FALSE;
return TRUE;
}
