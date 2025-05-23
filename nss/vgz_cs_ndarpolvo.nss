#include "mti_libreria"
void main()
{

CreateItemOnObject("cs_hadabotella",GetPCSpeaker());
GuardarIntPersistente(GetPCSpeaker(),"vgz_cs_polvodefatahecho",1);
GiveXPToCreature(GetPCSpeaker(),200);

}
