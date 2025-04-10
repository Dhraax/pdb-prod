#include "inc_sqlite_time"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iTiempoMemorizado = GetLocalInt(oPC, "QUEST_TS_TIEMPO");
  int iRestaTiempo = SQLite_GetTimeStamp() - iTiempoMemorizado;

  if(iRestaTiempo > 0 && iRestaTiempo < 4320) return TRUE;

  return FALSE;
}
