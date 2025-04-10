#include "lib_dm_vfx"

int StartingConditional()
{
    string sEyeStatus = ColorTexto("Ninguno",TXT_COLOR_ROJO);
    string sHairStatus = ColorTexto("Ninguno",TXT_COLOR_ROJO);
    string sHornsStatus = ColorTexto("Ninguno",TXT_COLOR_ROJO);
    string sHelmStatus = ColorTexto("Ninguno",TXT_COLOR_ROJO);

    object oPC = GetLocalObject(GetPCSpeaker(),VFX_TARGET);
    string sName = ColorTexto(GetName(oPC),TXT_COLOR_VERDE);
    int iEyes = ObtenerIntPersistente(oPC,EYES_VARIABLE_NAME);
    int iHorns = ObtenerIntPersistente(oPC,HORNS_VARIABLE_NAME);
    int iHelm = ObtenerIntPersistente(oPC,HELM_VARIABLE_NAME);
    int iHair = ObtenerIntPersistente(oPC,HAIR_VARIABLE_NAME);

    if(iEyes != 0){

        sEyeStatus = ColorTexto("Activo",TXT_COLOR_VERDE);
    }

    if(iHorns != 0){
        sHornsStatus = ColorTexto("Activo",TXT_COLOR_VERDE);
    }
    if(iHelm != 0){
        sHelmStatus = ColorTexto("Activo",TXT_COLOR_VERDE);
    }

    if(iHair != 0){
        sHairStatus = ColorTexto("Activo",TXT_COLOR_VERDE);
    }

    SetCustomToken(1500,sEyeStatus);
    SetCustomToken(1501,sHornsStatus);
    SetCustomToken(1502,sHelmStatus);
    SetCustomToken(1503,sHairStatus);
    SetCustomToken(1504,sName);

    int iResult = TRUE;

    return iResult;
}
