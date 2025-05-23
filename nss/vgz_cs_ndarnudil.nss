#include "mti_libreria"
void main()
{

CreateItemOnObject("cs_cetronudill",GetPCSpeaker());
GuardarIntPersistente(GetPCSpeaker(),"vgz_cs_nudillohecho",1);
GiveXPToCreature(GetPCSpeaker(),200);

}
