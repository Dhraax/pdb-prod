#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();
  string sCdkey = GetPCPublicCDKey(oPC);
  string sSerie = GetLocalString(oPC, "SEGSERIE");

  DeleteLocalInt(oPC, "SEG_OCUPADO");
  GuardarStringPersistente(oPC, "CDKEY", sCdkey);
  GuardarStringPersistente(oPC, "SEGCONTRASENYA", sSerie);
  SetCutsceneMode(oPC, FALSE);
  SendMessageToPC(oPC, "<c´þd>Tu contraseña de PJ es: "+sSerie+". Guárdala y no la pierdas jamás. En caso de problemas, consulta a los DMs.</c>");

  // SUBRAZAS: APLICAR AJUSTES INICIALES
  if(ObtenerIntPersistente(oPC, "LETO_APLICADO") == FALSE && GetSubRace(oPC) != "")
  {
      SetCutsceneMode(oPC, TRUE);
      FloatingTextStringOnCreature("<c´þd>* Ajustes iniciales de subraza aplicándose *</c>", oPC, FALSE);
      DelayCommand(4.0, AssignCommand(oPC, ActionStartConversation(oPC, "ms_convgeneral", TRUE)));
      return;
  }
}
