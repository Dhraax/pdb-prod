#include "pjr_chat_inc"
void main()
{
  object oPC = GetItemActivator();
  object oObjetoActivado = GetItemActivated();
  string sTagDelObjeto = GetTag(oObjetoActivado);

  int bSpeaking = GetLocalInt(oPC, "pr_speaking");
  if(!bSpeaking)
  {
      int iLan = GetLanguageNumber(sTagDelObjeto);
      string sSpeaking = GetLanguageName(iLan);
      SetLocalInt(oPC, "pr_language", iLan);
      SetLocalInt(oPC, "pr_speaking", TRUE);
      FloatingTextStringOnCreature(TMESSAGE_TEXT+"Ahora hablarás "+sSpeaking+". Para volver a hablar común, usa esta herramienta de nuevo."+COLOR_END, oPC, FALSE);
      return;
  }

  DeleteLocalInt(oPC,"pr_speaking");
  DeleteLocalInt(oPC,"pr_language");
  FloatingTextStringOnCreature(TMESSAGE_TEXT+"Ahora hablarás común."+COLOR_END, oPC, FALSE);
  return;
}
