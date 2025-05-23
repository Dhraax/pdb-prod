int StartingConditional()
{
    object oContenedor = GetObjectByTag("spawn_encuentros");
    object oCreatura = GetObjectByTag(GetLocalString(oContenedor, "Raza"));
    string sRaza = GetLocalString(oContenedor, "Res");
    string sAlig = GetLocalString(oContenedor, "Alig");

 //   SetLocalInt(oContenedor, "iNivel", 0);
    SetCustomToken(2022, IntToString(GetLocalInt(oContenedor,"iNivel")));
    SetCustomToken(2023, IntToString(GetLocalInt(oContenedor,"iCA")));


    if(sRaza == "drugo"){
    SetCustomToken(3000, "Gnomo");
    } else if (sRaza != "0") {
    SetCustomToken(3000, "Nada");
    }
    else
    {
    SetCustomToken(3000, sRaza);
    }
    SetCustomToken(3001, sAlig);
    return TRUE;
}



