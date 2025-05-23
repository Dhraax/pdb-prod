#include "nwnx_object"

void main()
{
    object oTarget = GetLocalObject(OBJECT_SELF, "DM_PAA_oTarget");
    int iModo = StringToInt(GetScriptParam("Modo"));
    int iApariencia = NWNX_Object_GetAppearance(oTarget);
    int iAparienciaNueva;
    int iMaximo = 34896;
    int iMinimo = 0;
    if(iModo == 1)
    {
        iAparienciaNueva = NWNX_Object_GetAppearance(oTarget) + 1;
        if(iAparienciaNueva > iMaximo) iAparienciaNueva = iMinimo;
    }
    if(iModo == 2)
    {
        iAparienciaNueva = NWNX_Object_GetAppearance(oTarget) -1;
        if(iAparienciaNueva < iMinimo) iAparienciaNueva = iMaximo;
    }
    //Añadimos la apariencia.
    NWNX_Object_SetAppearance(oTarget, iAparienciaNueva);
    //Le ponemos el nombre para que lo pueda detectar la peonza.
    SetName(oTarget, "DMAPA_"+IntToString(iAparienciaNueva));
    object oUbicadoNuevo = CopyObject(oTarget, GetLocation(oTarget),OBJECT_INVALID,GetTag(oTarget),TRUE);
    DestroyObject(oTarget);
    SetLocalObject(OBJECT_SELF, "DM_PAA_oTarget", oUbicadoNuevo);
}
