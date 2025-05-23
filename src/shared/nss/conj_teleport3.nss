//::///////////////////////////////:: //
//:: TELEPORTAR Y TELEPORTAR MAYOR :: //
//::///////////////////////////////:: //

#include "conj_teleport2"

void main()
{
  object oPC = GetPCSpeaker();
  int TipoTeleportar = GetLocalInt(oPC, "TELEPORTAR");
  string sDestino = GetScriptParam("Destino");

  ConjuroTeleportar(oPC, sDestino, TipoTeleportar);
}
