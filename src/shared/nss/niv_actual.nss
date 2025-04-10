int StartingConditional()
{
object oContenedor = GetObjectByTag("spawn_encuentros");
int iNivel = GetLocalInt(oContenedor,"intLevel");
SetCustomToken(5100,IntToString(iNivel));
    return TRUE;
}
