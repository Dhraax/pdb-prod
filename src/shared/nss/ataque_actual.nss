int StartingConditional()
{
   object oContenedor = GetObjectByTag("spawn_encuentros");
   int iVar = GetLocalInt(oContenedor,"Bono");
   SetCustomToken(8000,IntToString(iVar));

    return TRUE;
}
