int StartingConditional()
{
object oPC = GetPCSpeaker();

if (GetItemPossessedBy(oPC, "florLuminosa") == OBJECT_INVALID) return FALSE;

if (GetItemPossessedBy(oPC, "bastndemadera") == OBJECT_INVALID) return FALSE;

if (GetItemPossessedBy(oPC, "anillodemaderaco") == OBJECT_INVALID) return FALSE;

return TRUE;
}

