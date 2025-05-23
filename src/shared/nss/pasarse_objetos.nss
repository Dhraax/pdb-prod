/* SEGURIDAD: PASARSE OBJETOS */
#include "mti_libreria"
void main()
{
object oItem = GetModuleItemAcquired();
object oPC = GetItemPossessor(oItem);
object oSource = GetModuleItemAcquiredFrom();
string sPCCDKey = GetPCPublicCDKey(oPC);
string sPCName = GetName(oPC, TRUE);
string sSavedName = GetLocalString(oItem, sPCCDKey);

if(!GetIsPC(oPC))  return;

if(GetIsDM(oPC) || GetIsDMPossessed(oPC)) return;

// Marcamos el objeto adquirido
if(sSavedName=="" || GetIsDM(oSource) || GetIsDMPossessed(oSource))
{
  SetLocalString(oItem, sPCCDKey, sPCName); return;
}

// Hemos cazao a un contrabandista de objetos ;)
if(sPCName!=sSavedName)
{
  string sHelper = GetName(oSource, TRUE);
  string sHelperKey = GetPCPublicCDKey(oSource);

  DestroyObject(oItem,0.1);

  FloatingTextStringOnCreature("¡¡Pasarte objetos entre personajes de tu propia cuenta está prohibido!! Tus datos han sido guardados.", oPC);

  SendMessageToAllDMs(GetName(oPC, TRUE) + ", es decir, " + GetPCPlayerName(oPC)
  + ", ha intentando pasarse objetos entre pjs de su su misma cuenta. Objeto eliminado: " + GetName(oItem) + ".");

  WriteTimestampedLogEntry("[SISTEMA DE SEGURIDAD] ¡¡CONTRABANDO DE OBJETOS!!: "
  + GetName(oPC, TRUE) + ", es decir, " + GetPCPlayerName(oPC) + ", ha intentado"
  + " pasarse objetos entre personajes de su misma cuenta. Objeto eliminado: " + GetName(oItem) + ".");
}
}
