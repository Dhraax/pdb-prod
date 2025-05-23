int StartingConditional()
{
    object oContenedor = GetObjectByTag("spawn_encuentros");
    object oCreatura = GetObjectByTag(GetLocalString(oContenedor, "Raza"));
    string sNivel = IntToString(GetLocalInt(oContenedor,"iNivel"));
    int iLvl = GetHitDice(oCreatura);

 //   SetLocalInt(oContenedor, "iNivel", 0);
    SetCustomToken(2022,IntToString(iLvl));

    return TRUE;
}

