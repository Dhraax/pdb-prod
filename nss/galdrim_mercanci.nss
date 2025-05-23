//::///////////////////////////////////////////////
//:: FileName galdrim_mercanci
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 03/04/2014 20:21:46
//:://////////////////////////////////////////////
#include "nw_i0_plot"

void main()
{

    // Abre la tienda con esta etiqueta o bien hace saber al usuario que no existe tienda alguna.
    object oStore = GetNearestObjectByTag("galdrim_mercanci");
    if(GetObjectType(oStore) == OBJECT_TYPE_STORE)
        gplotAppraiseOpenStore(oStore, GetPCSpeaker());
    else
        ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}
