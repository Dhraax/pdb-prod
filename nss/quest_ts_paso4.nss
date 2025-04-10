#include "mti_libreria"
#include "inc_sqlite_time"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iVariable = ObtenerIntPersistente(oPC, "QUEST_TS");
  int iTiempoMemorizado = GetLocalInt(oPC, "QUEST_TS_TIEMPO");
  int iRestaTiempo = SQLite_GetTimeStamp() - iTiempoMemorizado;

  if(iVariable == 2 && ( iRestaTiempo == 0 || iRestaTiempo >= 4320))
  {
      GuardarIntPersistente(oPC, "QUEST_TS", 3);
      CreateItemOnObject("quest_ts_simb4", oPC);

      return TRUE;
  }

  return FALSE;
}
