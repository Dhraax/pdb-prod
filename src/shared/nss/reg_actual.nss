int StartingConditional()
{
   object oContenedor = GetObjectByTag("spawn_encuentros");
   int iVar = GetLocalInt(oContenedor,"Reg");

   SetCustomToken(5202,IntToString(iVar));

    return TRUE;
}
