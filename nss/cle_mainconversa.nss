#include "mti_libreria"
#include "nwnx_player"

int StartingConditional()
{
  object oPC = GetPCSpeaker();

  string oArea1 = ObtenerStringPersistente(oPC, "PALABRA_REGRESO_LOC1_NOMBRE");
  string oArea2 = ObtenerStringPersistente(oPC, "PALABRA_REGRESO_LOC2_NOMBRE");
  string oArea3 = ObtenerStringPersistente(oPC, "PALABRA_REGRESO_LOC3_NOMBRE");
  if(oArea1 == "") oArea1 = "<LOCALIZACION SIN MARCAR>";
  if(oArea2 == "") oArea2 = "<LOCALIZACION SIN MARCAR>";
  if(oArea3 == "") oArea3 = "<LOCALIZACION SIN MARCAR>";

  NWNX_Player_SetCustomToken(oPC, 6661, oArea1);
  NWNX_Player_SetCustomToken(oPC, 6662, oArea2);
  NWNX_Player_SetCustomToken(oPC, 6663, oArea3);

  return TRUE;
}
