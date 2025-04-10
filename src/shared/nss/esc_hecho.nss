void main()
{
  object oPC = GetPCSpeaker();

  SendMessageToPC(oPC, "<cÍþ>Has salido del <cþ>[Modo Escritura]</c>, ya podrás hablar con normalidad.</c>");

  DeleteLocalInt(oPC, "MODOESCRITURA");
}
