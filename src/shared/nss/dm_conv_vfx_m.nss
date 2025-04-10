#include "lib_dm_vfx"
#include "mti_libreria"

void main()
{
    object oPC = GetLocalObject(GetPCSpeaker(),VFX_TARGET);
    string sType = GetScriptParam("TYPE");
    string sModel = GetScriptParam("MODEL");

    if(sType == "EYE") {
        ApplyEyesVFX_DM(oPC,sModel);
    }
    else if (sType == "HELM") {
        ApplyHelmVFX_DM(oPC,sModel);
    }
    else if (sType == "HORNS") {
        ApplyHornsVFX_DM(oPC,sModel);
    }
    else if (sType == "HAIR") {
        ApplyHairVFX_DM(oPC,sModel);
    }
    else if (sType == "REMOVE_EYES") {
        RemoveEyesDMVFX(oPC);
        BorrarIntPersistente(oPC,EYES_VARIABLE_NAME);
    }
    else if (sType == "REMOVE_HELM") {
        RemoveHelmDMVFX(oPC);
        BorrarIntPersistente(oPC,HELM_VARIABLE_NAME);
    }
    else if (sType == "REMOVE_HORNS") {
        RemoveHornsDMVFX(oPC);
        BorrarIntPersistente(oPC,HORNS_VARIABLE_NAME);
    }
    else if (sType == "REMOVE_HAIR") {
        RemoveHairDMVFX(oPC);
        BorrarIntPersistente(oPC,HAIR_VARIABLE_NAME);
    }
    else if (sType == "REMOVE_ALL") {
        RemoveAllDMVFX(oPC);
        BorrarIntPersistente(oPC,EYES_VARIABLE_NAME);
        BorrarIntPersistente(oPC,HELM_VARIABLE_NAME);
        BorrarIntPersistente(oPC,HORNS_VARIABLE_NAME);
        BorrarIntPersistente(oPC,HAIR_VARIABLE_NAME);
    }
}
