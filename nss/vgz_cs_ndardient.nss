#include "mti_libreria"
void main()
{

CreateItemOnObject("cs_trozodeanill1",GetPCSpeaker());
GuardarIntPersistente(GetPCSpeaker(),"vgz_cs_dientedebodakhecho",1);
GiveXPToCreature(GetPCSpeaker(),250);

}
