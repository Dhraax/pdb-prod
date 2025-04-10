#include "cle_inc"

void main()
{
  object oPC = GetPCSpeaker();

  string sArea = ObtenerNombreAreaMemorizadaPalabraRegreso3(oPC);
  AplicarTeleportPalabraRegreso(oPC, sArea);
}
