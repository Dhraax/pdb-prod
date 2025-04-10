int StartingConditional()
{
object oPC = GetPCSpeaker();

if(GetItemPossessedBy(oPC, "libro_ae") == OBJECT_INVALID) return FALSE;
return TRUE;
}
