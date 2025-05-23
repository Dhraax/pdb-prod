int StartingConditional()
{
object oModule = GetModule();
int nComprobarVar = GetLocalInt(oModule, "entra_relikias");

if(!(nComprobarVar == 1)) return FALSE;

return TRUE;
}
