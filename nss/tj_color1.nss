#include "tj_inc"
void main()
{
  object oPC = GetPCSpeaker();

  object oCartel = CreateObject(OBJECT_TYPE_PLACEABLE, "tj_cartel3", GetLocation(OBJECT_SELF));
  SetName(oCartel, NombreCartel(oPC));
  string sIdentidad = GetName(oPC,TRUE) + GetPCPublicCDKey(oPC);
  SetLocalString(oCartel, "TJIDENTIDAD", sIdentidad);
  DestroyObject(OBJECT_SELF);

  SetLocalInt(oPC, "TJCOLOR", 1);
  SetLocalObject(oPC, "TJUBICADO2", oCartel);
}
