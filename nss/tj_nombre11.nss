#include "tj_inc"
void main()
{
  object oPC = GetPCSpeaker();

  object oNuevoCartel = CreateObject(OBJECT_TYPE_PLACEABLE, ColorCartel(oPC), GetLocation(OBJECT_SELF));
  SetName(oNuevoCartel, "Mire, compare y juzgue. ¡Le devolveremos el doble de lo que pagó si no está satisfecho!");
  string sIdentidad = GetName(oPC,TRUE) + GetPCPublicCDKey(oPC);
  SetLocalString(oNuevoCartel, "TJIDENTIDAD", sIdentidad);
  DestroyObject(OBJECT_SELF);

  SetLocalInt(oPC, "TJNOMBRE", 11);
  SetLocalObject(oPC, "TJUBICADO2", oNuevoCartel);
}
