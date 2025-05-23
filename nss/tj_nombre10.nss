#include "tj_inc"
void main()
{
  object oPC = GetPCSpeaker();

  object oNuevoCartel = CreateObject(OBJECT_TYPE_PLACEABLE, ColorCartel(oPC), GetLocation(OBJECT_SELF));
  SetName(oNuevoCartel, "Utensilios, herramientas, aparatos, artilugios... Todo lo que no usaría nunca, ¡aquí!");
  string sIdentidad = GetName(oPC,TRUE) + GetPCPublicCDKey(oPC);
  SetLocalString(oNuevoCartel, "TJIDENTIDAD", sIdentidad);
  DestroyObject(OBJECT_SELF);

  SetLocalInt(oPC, "TJNOMBRE", 10);
  SetLocalObject(oPC, "TJUBICADO2", oNuevoCartel);
}
