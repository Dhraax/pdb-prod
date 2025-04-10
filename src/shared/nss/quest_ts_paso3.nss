#include "mti_libreria"
#include "inc_sqlite_time"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oFragmento1 = GetItemPossessedBy(oPC, "quest_ts_simb1");
  object oFragmento2 = GetItemPossessedBy(oPC, "quest_ts_simb2");
  object oFragmento3 = GetItemPossessedBy(oPC, "quest_ts_simb3");

  if(oFragmento1 == OBJECT_INVALID || oFragmento2 == OBJECT_INVALID || oFragmento3 == OBJECT_INVALID)
  {
      return TRUE;
  }
  else
  {
      DestroyObject(oFragmento1);
      DestroyObject(oFragmento2);
      DestroyObject(oFragmento3);

      GuardarIntPersistente(oPC, "QUEST_TS", 2);
      SetLocalInt(oPC, "QUEST_TS_TIEMPO", SQLite_GetTimeStamp() - 1);

      return FALSE;
  }
}
