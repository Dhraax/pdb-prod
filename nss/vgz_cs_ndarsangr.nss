#include "mti_libreria"
void main()
{

CreateItemOnObject("cs_hondadrag",GetPCSpeaker());
GuardarIntPersistente(GetPCSpeaker(),"vgz_cs_sangrededragonhecho",1);
GiveXPToCreature(GetPCSpeaker(),500);

}
