#include "nw_i0_generic"
#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();
  location lUbicacionMago = GetLocation(OBJECT_SELF);

  // Dar el Aviso
  int iAvisosTotales = ObtenerIntPersistente(oPC, "AVISOSMAGOS");
  GuardarIntPersistente(oPC, "AVISOSMAGOS", iAvisosTotales + 1);

  // Ajuste de faccion contra los Magos
  AdjustReputation(oPC, OBJECT_SELF, -100);
  AssignCommand(OBJECT_SELF, DetermineCombatRound(oPC));

  object oSpawn1 = CreateObject(OBJECT_TYPE_CREATURE, "magoencapuchado2", lUbicacionMago);
  object oSpawn2 = CreateObject(OBJECT_TYPE_CREATURE, "magaencapuchada", lUbicacionMago);
  object oSpawn3 = CreateObject(OBJECT_TYPE_CREATURE, "magaencapuchada", lUbicacionMago);
  DelayCommand(1.6, AssignCommand(oSpawn1, DetermineCombatRound(oPC)));
  DelayCommand(1.6, AssignCommand(oSpawn2, DetermineCombatRound(oPC)));
  DelayCommand(1.6, AssignCommand(oSpawn3, DetermineCombatRound(oPC)));

  // Evitar que le salgan mas magos en 3 min
  SetLocalString(GetModule(), "AVISOMAGO" + GetName(oPC), GetName(oPC));
  DelayCommand(180.0, DeleteLocalString(GetModule(), "AVISOMAGO" + GetName(oPC)));
}
