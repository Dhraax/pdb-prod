#include "pb_fecha_inc"
#include "inc_sqlite_time"

void main()
{
  object oPC = GetPCChatSpeaker();
  int iUnixTime = SQLite_GetTimeStamp();
  int iAjusteHorario = 7200;

  if(GetCampaignInt("AJUSTEHORARIO", "AJUSTEHORARIO", GetModule()) == TRUE) iAjusteHorario = 3600;

  PrintHumanDate(oPC, oPC, iUnixTime, iAjusteHorario);
}
