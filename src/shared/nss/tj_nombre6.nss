#include "tj_inc"
void main()
{
  object oPC = GetPCSpeaker();

  object oNuevoCartel = CreateObject(OBJECT_TYPE_PLACEABLE, ColorCartel(oPC), GetLocation(OBJECT_SELF));
  SetName(oNuevoCartel, "¡Las mejores armas de toda Amn en mi tienda!");
  string sIdentidad = GetName(oPC,TRUE) + GetPCPublicCDKey(oPC);
  SetLocalString(oNuevoCartel, "TJIDENTIDAD", sIdentidad);
  DestroyObject(OBJECT_SELF);

  SetLocalInt(oPC, "TJNOMBRE", 6);
  SetLocalObject(oPC, "TJUBICADO2", oNuevoCartel);
}
