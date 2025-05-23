int StartingConditional()
{
   object oContenedor = GetObjectByTag("spawn_encuentros");
   SetCustomToken(1992,IntToString(GetLocalInt(oContenedor,"AICantidad")));
    return TRUE;
}
