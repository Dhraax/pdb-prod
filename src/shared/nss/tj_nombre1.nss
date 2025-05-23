#include "tj_inc"
void main()
{
  object oPC = GetPCSpeaker();
  string sNombre = PB_Disguise_GetNameOverride(oPC);

  object oNuevoCartel = CreateObject(OBJECT_TYPE_PLACEABLE, ColorCartel(oPC), GetLocation(OBJECT_SELF));
  SetName(oNuevoCartel, "¡Bienvenidos a la tienda de " + sNombre + "!");
  string sIdentidad = GetName(oPC,TRUE) + GetPCPublicCDKey(oPC);
  SetLocalString(oNuevoCartel, "TJIDENTIDAD", sIdentidad);
  DestroyObject(OBJECT_SELF);

  SetLocalInt(oPC, "TJNOMBRE", 1);
  SetLocalObject(oPC, "TJUBICADO2", oNuevoCartel);
}
