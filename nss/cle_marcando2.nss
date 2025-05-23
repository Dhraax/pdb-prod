#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();
  object oArea = GetArea(oPC);
  string oNombreArea = GetName(oArea);

  if(GetLocalInt(oArea, "CLEREGRESABLE") == FALSE) SendMessageToPC(oPC, "<cþ<<>Este no es un refugio seguro para el Palabra de Regreso.</c>");

  else if(ObtenerIntPersistente(oPC, "PALABRA_REGRESO_LOC2") == FALSE)
  {
      GuardarIntPersistente(oPC, "PALABRA_REGRESO_LOC2", 1);
      GuardarStringPersistente(oPC, "PALABRA_REGRESO_LOC2_NOMBRE", oNombreArea);
      FloatingTextStringOnCreature("<c´þd>El segundo punto de marcación ha sido creado.</c>", oPC, FALSE);
  }
}
