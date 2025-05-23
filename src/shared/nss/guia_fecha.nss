#include "mti_libreria"
#include "pb_fecha_inc"

void main()
{
  // Variables
  object oPC = GetPCSpeaker();
  int iUnixTime = ObtenerIntPersistente(oPC, "PB_FECHA_CREACION");
  int iAjusteHorario = 7200;

  if(GetCampaignInt("AJUSTEHORARIO", "AJUSTEHORARIO", GetModule()) == TRUE) iAjusteHorario = 3600;

  PrintHumanDate(oPC, oPC, iUnixTime, iAjusteHorario, TRUE);
}
