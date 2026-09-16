int StartingConditional()
{
object oPC = GetPCSpeaker();

if (GetItemPossessedBy(oPC, "cnr_p_flor") == OBJECT_INVALID) return FALSE;

if (GetItemPossessedBy(oPC, "bastndemadera") == OBJECT_INVALID) return FALSE;

if (GetItemPossessedBy(oPC, "anillodemaderaco") == OBJECT_INVALID) return FALSE;

return TRUE;
}

