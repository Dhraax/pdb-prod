#include "nw_i0_plot"
void main()
{
// Abre la tienda con esta etiqueta o bien hace saber al usuario que no existe tienda alguna.
object oStore = GetNearestObjectByTag("mer_te_im");
if(GetObjectType(oStore) == OBJECT_TYPE_STORE)
    gplotAppraiseOpenStore(oStore, GetPCSpeaker());
else
    ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}
