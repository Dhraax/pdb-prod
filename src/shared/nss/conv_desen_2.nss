int StartingConditional()
{
    int iResult;
    int iModo = StringToInt(GetScriptParam("Modo"));

    //Comprobamos que existe el ubicado en la lista.
    if(iModo == 1)
    {
        string sSeleccion = GetScriptParam("Seleccion");
        object oTarget = GetLocalObject(OBJECT_SELF, "DM_DESEN_UBICADO"+sSeleccion);

        iResult = GetIsObjectValid(oTarget);
    }

    //Comprobamos si hay 10 menos.
    if(iModo == 2)
    {
        int iOffset = GetLocalInt(OBJECT_SELF, "DM_DESEN_CONTEO");
        iResult = iOffset > 10;
    }

    //COmprobamos si hay 10 más.
    if(iModo == 3)
    {
        object oMore = GetLocalObject(OBJECT_SELF, "DM_DESEN_MAS");
        iResult = GetIsObjectValid(oMore);
    }

    return iResult;
}

