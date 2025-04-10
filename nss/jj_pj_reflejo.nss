/* se abre si es miembro de los reflejos de la mirada*/

int StartingConditional()
{
object oPC = GetPCSpeaker();

if (GetItemPossessedBy(oPC, "jj_llavebardos") == OBJECT_INVALID) return FALSE;

return TRUE;
}
