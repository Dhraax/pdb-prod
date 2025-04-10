void main()
{
  object oPC = GetLastUsedBy();

  if(GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0 || GetLevelByClass(CLASS_TYPE_RANGER, oPC) > 0) SendMessageToPC(oPC, "Podrías teleportarte a traves de este árbol si tuvieras aprendido un conjuro de 'Zancada arbórea'.");
  else SendMessageToPC(oPC, "Es un árbol normal y corriente, nada interesante.");
}
