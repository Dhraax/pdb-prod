#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();

  GuardarStringPersistente(oPC, "PALABRA_REGRESO_LOC1_NOMBRE", "<LOCALIZACION SIN MARCAR>");
  GuardarIntPersistente(oPC, "PALABRA_REGRESO_LOC1", 0);
  FloatingTextStringOnCreature("<cþ<<>El primer punto de marcación ha sido borrado.</c>", oPC);
}
