void main()
{
  object oPC = GetExitingObject();
  if(GetIsPC(oPC))
  {
      DeleteLocalInt(oPC, "estaEnDesencadentanteParaDescanso");
      SendMessageToPC(oPC, "<cþ>Abandonas un refugio seguro para descansar.</c>");
  }
}
