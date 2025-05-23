void main()
{
  object oPC = GetPCSpeaker();
  object oArea = GetArea(oPC);
  int iCieloArea = GetSkyBox(oArea);

  if(iCieloArea == 0) iCieloArea = 103;
  else if(iCieloArea == 102) iCieloArea = 85;
  else if(iCieloArea == 44) iCieloArea = 34;
  else if(iCieloArea == 30) iCieloArea = 10;
  else iCieloArea--;

  SendMessageToPC(oPC, "Cielo número: " + IntToString(iCieloArea));
  SetSkyBox(iCieloArea, oArea);
}
