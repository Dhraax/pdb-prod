void main()
{
  object oPC = GetPCSpeaker();
  int IDretrato = GetPortraitId(oPC);

  if(IDretrato == PORTRAIT_INVALID) IDretrato = 0;
  else if((IDretrato + 1) > 1300) IDretrato = 0;

  SetPortraitId(oPC, IDretrato + 1);
  SendMessageToPC(oPC, "<ceî´>Aplicado retrato de Bioware número: " + IntToString(IDretrato + 1) + ".</c>");
}
