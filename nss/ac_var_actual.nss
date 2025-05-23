int StartingConditional()
{
   object oContenedor = GetObjectByTag("spawn_encuentros");
   SetCustomToken(6666,IntToString(GetLocalInt(oContenedor,"ACadd")));
    return TRUE;
}
