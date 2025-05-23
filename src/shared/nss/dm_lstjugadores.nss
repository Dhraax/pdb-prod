#include "inc_sqlite_time"

void main()
{
  if(GetLocalInt(OBJECT_SELF, "NOSATURAR") == TRUE) return;
  SetLocalInt(OBJECT_SELF, "NOSATURAR", TRUE);
  DelayCommand(10.0, DeleteLocalInt(OBJECT_SELF, "NOSATURAR"));

  object oPC = GetLastUsedBy();

  string sTexto;
  sTexto = "INFORME DEL SERVIDOR\n" +
           "--------------------\n" +
           "SystemTime: " + SQLite_GetSystemTime() + "\n" +
           //"ProcessMemoryUsage: " + IntToString(GetProcessMemoryUsage()) + "\n\n" +
           "INFORME DE JUGADORES\n" +
           "--------------------";
           //"ProcessMemoryUsage: " + IntToString(GetProcessMemoryUsage()) + "\n\n" +

  SendMessageToPC(oPC, sTexto);

  object oPlayer = GetFirstPC();
  while (oPlayer != OBJECT_INVALID)
  {
      int nLevel = GetHitDice(oPlayer);
      location lPlayerFind = GetLocation(oPlayer);
      object oArea = GetAreaFromLocation(lPlayerFind);
      string sLevel = IntToString(nLevel);
      string sArea = GetName(oArea);
      string sCharName = GetName(oPlayer, TRUE);
      string sLoginName = GetPCPlayerName(oPlayer);

      SendMessageToPC(oPC,"Nvl " + sLevel + " - " + sArea + ": " + sCharName + "(" + sLoginName +")");

      oPlayer = GetNextPC();
  }
}
