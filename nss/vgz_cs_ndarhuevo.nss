#include "mti_libreria"
void main()
{

CreateItemOnObject("X0_IT_MGLOVE002",GetPCSpeaker());
GuardarIntPersistente(GetPCSpeaker(),"vgz_cs_huevodedragonhecho",1);
GiveXPToCreature(GetPCSpeaker(),500);

}
