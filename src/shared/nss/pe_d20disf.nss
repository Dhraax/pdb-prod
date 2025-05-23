void main()
{
  // Bono dote soltura
  int iBono = 0;
  if(GetHasFeat(1241, GetPCSpeaker())) iBono = 10;      // Soltura epica
  else if(GetHasFeat(1225, GetPCSpeaker())) iBono = 3;  // Soltura normal

  string sTirada = "Disfrazarse";
  int iDado = Random(20)+1;
  int iRangos = GetSkillRank(30, GetPCSpeaker()) + iBono;
  string sFraseCompilada = "";
  string sRangos = "";

  sFraseCompilada = "Tirada de <cþ~ >"+ sTirada +"</c>, resultado ";

  if(iDado==1)
  {
      sFraseCompilada = sFraseCompilada + "= <cþ  >1 Fallo</c>. Tirada de Fallo crítico ";
      iDado = Random (20)+1;
  }
  else if (iDado==20)
  {
      sFraseCompilada = sFraseCompilada + "= <c þ >20 Éxito</c>. Tirada de Éxito crítico ";
      iDado = Random (20)+1;
  }

  if(iRangos<0) sRangos = IntToString(iRangos);
  else sRangos = "+"+IntToString(iRangos);
  sFraseCompilada = sFraseCompilada + "<c þþ>" + IntToString(iDado)+sRangos +"="+IntToString(iDado+iRangos) +"</c>.";

  if(GetLocalInt(GetPCSpeaker(), "iDadosDms") == 1) SendMessageToAllDMs(GetName(GetPCSpeaker())+": "+sFraseCompilada);
  else AssignCommand(GetPCSpeaker(), ActionSpeakString(sFraseCompilada));
}
