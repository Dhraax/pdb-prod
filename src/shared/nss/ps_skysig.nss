void main()
{
  object oPC = GetPCSpeaker();
  object oArea = GetArea(oPC);
  int iCieloArea = GetSkyBox(oArea);

  if(iCieloArea == 10) iCieloArea = 30;
  else if(iCieloArea == 34) iCieloArea = 44;
  else if(iCieloArea == 85) iCieloArea = 102;
  else if(iCieloArea == 103) iCieloArea = 0;
  else iCieloArea++;

  SendMessageToPC(oPC, "Cielo número: " + IntToString(iCieloArea));
  SetSkyBox(iCieloArea, oArea);
}
