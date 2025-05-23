#include "mti_libreria"
#include "nwnx_creature"


void main()
{
  object oPC = OBJECT_SELF;
  int iArchi = GetLevelByClass(53, oPC);

 if(iArchi > 0)
  {
  // Ya tiene las dotes.
  GuardarIntPersistente(oPC, "ARCHIMAGO", TRUE);

  //Dotes
  NWNX_Creature_AddFeat(oPC, 1420);
  NWNX_Creature_AddFeat(oPC, 1421);
  NWNX_Creature_AddFeat(oPC, 1422);
  NWNX_Creature_AddFeat(oPC, 1423);
  NWNX_Creature_AddFeat(oPC, 1424);
  SendMessageToPC(oPC, "Se han agregado las dotes de Maestria Elemental");
  }

}
