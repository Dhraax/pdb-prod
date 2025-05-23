#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();
  object oArea = GetArea(oPC);
  string oNombreArea = GetName(oArea);

  if(GetLocalInt(GetArea(oPC), "CLEREGRESABLE") == FALSE) SendMessageToPC(oPC, "<cþ<<>Este no es un refugio seguro para el Palabra de Regreso.</c>");

  else if(ObtenerIntPersistente(oPC, "PALABRA_REGRESO_LOC3") == FALSE)
  {
      GuardarIntPersistente(oPC, "PALABRA_REGRESO_LOC3", TRUE);
      GuardarStringPersistente(oPC, "PALABRA_REGRESO_LOC3_NOMBRE", oNombreArea);
      FloatingTextStringOnCreature("<c´þd>El tercer punto de marcación ha sido creado.</c>", oPC, FALSE);
  }
}
