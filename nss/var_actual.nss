int StartingConditional()
{
   object oContenedor = GetObjectByTag("spawn_encuentros");
   SetCustomToken(5002,IntToString(GetLocalInt(oContenedor,"Ench")));
    return TRUE;
}
