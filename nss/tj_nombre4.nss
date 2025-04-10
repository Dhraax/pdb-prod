#include "tj_inc"
void main()
{
  object oPC = GetPCSpeaker();

  object oNuevoCartel = CreateObject(OBJECT_TYPE_PLACEABLE, ColorCartel(oPC), GetLocation(OBJECT_SELF));
  SetName(oNuevoCartel, "¡Despilfarre, despilfarre! ¡Cómpreme algo por favor!");
  string sIdentidad = GetName(oPC,TRUE) + GetPCPublicCDKey(oPC);
  SetLocalString(oNuevoCartel, "TJIDENTIDAD", sIdentidad);
  DestroyObject(OBJECT_SELF);

  SetLocalInt(oPC, "TJNOMBRE", 4);
  SetLocalObject(oPC, "TJUBICADO2", oNuevoCartel);
}
