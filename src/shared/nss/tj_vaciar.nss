#include "tj_inc"
void main()
{
  object oPC = GetPCSpeaker();
  object oUbicado1 = GetLocalObject(oPC, "TJUBICADO1");
  TJVaciarInventario(oUbicado1);
  DestroyObject(oUbicado1, 0.1);

  string sIdentidad = GetName(oPC,TRUE) + GetPCPublicCDKey(oPC);
  location lNuevoMostrador = GetLocalLocation(oPC, "TJLUGARMOSTRADOR");
  object oNuevoMostrador = CreateObject(OBJECT_TYPE_PLACEABLE, "tj_mostrador", lNuevoMostrador);
  SetName(oNuevoMostrador, "Puesto de venta de " + PB_Disguise_GetNameOverride(oPC));
  SetLocalString(oNuevoMostrador, "TJIDENTIDAD", sIdentidad);
  SetLocalObject(oPC, "TJUBICADO1", oNuevoMostrador);
  FloatingTextStringOnCreature("*¡Mostrador vaciado!*", oPC, FALSE);
}
