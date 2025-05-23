
void main()
{
  object oPC = GetPCSpeaker();

  // Se escucha un nombre correctamente
  int iCanal = GetListenPatternNumber();
  if(iCanal == 777)
  {
      // Cambio de nombre
      string sNombre = GetMatchedSubstring(0);
      SetName(OBJECT_SELF, sNombre);
  }

  // No se escucha un nombre correctamente
  else
  {
      SendMessageToPC(oPC, "<cþ<<>¡No has dicho nada! Di en voz alta un nombre y luego selecciona 'Hecho'.</c>");
  }
}
