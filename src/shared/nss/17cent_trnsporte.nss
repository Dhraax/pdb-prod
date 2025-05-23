#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();
  object oMod = GetModule();
  string sID = "17CENT_TRANSP" + GetPCPlayerName(oPC) + GetName(oPC);

  if(GetLocalInt(oMod, sID) == TRUE)
  {
      SendMessageToPC(oPC, "Solo puedes usar el megalito druídico una vez cada 8 horas.");
      return;
  }

  else if(GetTag(OBJECT_SELF) == "megalito_druidico2")
  {
      Teletransporte(oPC, GetLocation(GetWaypointByTag("arboleda_meg2")));
      SetLocalInt(oMod, sID, TRUE);
      DelayCommand(960.0, DeleteLocalInt(oMod, sID));
      return;
  }

  else if(GetTag(OBJECT_SELF) == "megalito_druidico3")
  {
      Teletransporte(oPC, GetLocation(GetWaypointByTag("arboleda_meg4")));
      SetLocalInt(oMod, sID, TRUE);
      DelayCommand(960.0, DeleteLocalInt(oMod, sID));
      return;
  }
  else if(GetTag(OBJECT_SELF) == "megalito_druidico4")
  {
      Teletransporte(oPC, GetLocation(GetWaypointByTag("arboleda_meg3")));
      SetLocalInt(oMod, sID, TRUE);
      DelayCommand(960.0, DeleteLocalInt(oMod, sID));
      return;
  }
  else
  {
      Teletransporte(oPC, GetLocation(GetWaypointByTag("arboleda_meg1")));
      SetLocalInt(oMod, sID, TRUE);
      DelayCommand(960.0, DeleteLocalInt(oMod, sID));
  }
}
