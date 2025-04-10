#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();

  GuardarStringPersistente(oPC, "PALABRA_REGRESO_LOC2_NOMBRE", "<LOCALIZACION SIN MARCAR>");
  GuardarIntPersistente(oPC, "PALABRA_REGRESO_LOC2", 0);
  FloatingTextStringOnCreature("<cþ<<>El segundo punto de marcación ha sido borrado.</c>", oPC);
}
