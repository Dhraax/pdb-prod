#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();

  GuardarStringPersistente(oPC, "PALABRA_REGRESO_LOC3_NOMBRE", "<LOCALIZACION SIN MARCAR>");
  GuardarIntPersistente(oPC, "PALABRA_REGRESO_LOC3", 0);
  FloatingTextStringOnCreature("<cþ<<>El tercer punto de marcación ha sido borrado.</c>", oPC);
}
