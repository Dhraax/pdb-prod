#include "mti_libreria"
void main()
{

CreateItemOnObject("vgz_cs_ojoraksh",GetPCSpeaker());
GuardarIntPersistente(GetPCSpeaker(),"vgz_cs_ojoderakshashahecho",1);
GiveXPToCreature(GetPCSpeaker(),250);

}
