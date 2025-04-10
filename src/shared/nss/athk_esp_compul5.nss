int StartingConditional()
{
object oPC = GetPCSpeaker();

if (GetItemPossessedBy(oPC, "Alian_Eldur") == OBJECT_INVALID) return FALSE;

return TRUE;
}


