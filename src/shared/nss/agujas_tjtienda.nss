int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetGold(oPC) < 500) return FALSE;

  int iTirada = d20() + GetSkillRank(SKILL_APPRAISE, oPC);
  int iResultadoTirada = iTirada - 12;

  if(iResultadoTirada < 0)
  {
      SetLocalInt(oPC, "PUESTO_VENTA_SPAM", TRUE);
      SendMessageToPC(oPC, "<c›þþ>" + GetName(oPC) + "</c> <cþ–2>realiza una prueba de 'Tasación': *fracaso*: "+IntToString(iTirada)+" contra CD 12</c>");
      return FALSE;
  }

  SendMessageToPC(oPC, "<c›þþ>" + GetName(oPC) + "</c> <cþ–2>realiza una prueba de 'Tasación': *éxito*: "+IntToString(iTirada)+" contra CD 12</c>");
  TakeGoldFromCreature(500, oPC, TRUE);
  CreateItemOnObject("tj_tienda", oPC);
  return TRUE;
}
