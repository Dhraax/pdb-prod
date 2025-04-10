int StartingConditional()
{
    object oContenedor = GetObjectByTag("spawn_encuentros");
    object oCreatura = GetObjectByTag(GetLocalString(oContenedor, "Raza"));
    SetLocalInt(oContenedor, "iAc",0);
    SetCustomToken(2023, IntToString(GetAC(oCreatura)));

    return TRUE;
}
