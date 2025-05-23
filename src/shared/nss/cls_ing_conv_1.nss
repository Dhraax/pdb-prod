#include "mti_libreria"
#include "cls_ing_lib"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oObjetivo = GetLocalObject(oPC, "CLS_ING_DOTE");
    int iModo = StringToInt(GetScriptParam("Modo"));
    int iTipo = StringToInt(GetScriptParam("Tipo"));
    //Debemos elegir el tipo de ingeniero.
    if(iModo == 1)
    {
        //Si no tenemos elegido el tipo de ingeniero, aparece.
        if(ObtenerIntPersistente(oPC,"CLS_ING_TIPO") < 1 || GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) == 1)
        return TRUE;
    }
    //El resto de cosas aparecen cuando ya hemos elegido el tipo de ingeniero.
    if(iModo == 2)
    {
        //Si no tenemos elegido el tipo de ingeniero, aparece.
        if(ObtenerIntPersistente(oPC,"CLS_ING_TIPO") > 0)
        return TRUE;
    }
    //Intentamos elegir infusiones de x tipo.
    if(iModo == 3)
    {
        if(iTipo == 1 && ObtenerIntPersistente(oPC,"CLS_ING_TIPO") == 1)
        return TRUE;
        else if(iTipo == 2 && ObtenerIntPersistente(oPC,"CLS_ING_TIPO") == 2)
        return TRUE;
        else if(iTipo == 3 && ObtenerIntPersistente(oPC,"CLS_ING_TIPO") == 3)
        return TRUE;
        else if(iTipo == 4 && ObtenerIntPersistente(oPC,"CLS_ING_TIPO") == 4)
        return TRUE;
    }
    //Intentamos elegir infusiones de x nivel.
    if(iModo == 4)
    {
        if(iTipo == 1 && iLeerRestantes (oPC, 1) > 0)
        return TRUE;
        else if(iTipo == 2 && iLeerRestantes (oPC, 2) > 0)
        return TRUE;
        else if(iTipo == 3 && iLeerRestantes (oPC, 3) > 0)
        return TRUE;
        else if(iTipo == 4 && iLeerRestantes (oPC, 4) > 0)
        return TRUE;
    }

return FALSE;
}
