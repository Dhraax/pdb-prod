#include "cle_inc"

void main()
{
  object oPC = GetPCSpeaker();

  string sArea = ObtenerNombreAreaMemorizadaPalabraRegreso2(oPC);

  AplicarTeleportPalabraRegreso(oPC, sArea);
}
