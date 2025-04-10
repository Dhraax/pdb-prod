#include "tj_inc"
void main()
{
  object oPC = GetPCSpeaker();

  object oNuevoCartel = CreateObject(OBJECT_TYPE_PLACEABLE, ColorCartel(oPC), GetLocation(OBJECT_SELF));
  SetName(oNuevoCartel, "Tápese los ojos al ver mi mostrador, el brillo de mis objetos le deslumbrará");
  string sIdentidad = GetName(oPC,TRUE) + GetPCPublicCDKey(oPC);
  SetLocalString(oNuevoCartel, "TJIDENTIDAD", sIdentidad);
  DestroyObject(OBJECT_SELF);

  SetLocalInt(oPC, "TJNOMBRE", 12);
  SetLocalObject(oPC, "TJUBICADO2", oNuevoCartel);
}
