#include "cle_inc"

void main()
{
  object oPC = GetPCSpeaker();

  string sArea = ObtenerNombreAreaMemorizadaPalabraRegreso1(oPC);
  AplicarTeleportPalabraRegreso(oPC, sArea);
}
