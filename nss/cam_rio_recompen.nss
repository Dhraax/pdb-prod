#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();

  // Dar un poco de oro al que habla
  GiveGoldToCreature(oPC, 250);

  // Dar algunos PX al que habla
  GiveXPToCreature(oPC, 400);

  // Eliminar objetos del inventario del jugador.
  object oIntrucciones = GetItemPossessedBy(oPC, "Instrucciones_avanzadilla");
  if(GetIsObjectValid(oIntrucciones) == TRUE) DestroyObject(oIntrucciones);

  // Fijar variables
  GuardarIntPersistente(oPC, "QUESTINSTRUCCIONESAMN", 1);
}
