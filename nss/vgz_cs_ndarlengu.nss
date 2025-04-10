#include "mti_libreria"
void main()
{

CreateItemOnObject("vgz_cs_lengsl",GetPCSpeaker());
GuardarIntPersistente(GetPCSpeaker(),"vgz_cs_lenguadeslaadhecho",1);
GiveXPToCreature(GetPCSpeaker(),350);

}
