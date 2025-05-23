//::///////////////////////////////////////////////
//:: FileName posada_rey
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 06/05/2004 17:03:36
//:://////////////////////////////////////////////
#include "nw_i0_plot"

void main()
{

    // Abre la tienda con esta etiqueta o bien hace saber al usuario que no existe tienda alguna.
    object oStore = GetNearestObjectByTag("Posada_luz");
    if(GetObjectType(oStore) == OBJECT_TYPE_STORE)
        gplotAppraiseOpenStore(oStore, GetPCSpeaker());
    else
        ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}
