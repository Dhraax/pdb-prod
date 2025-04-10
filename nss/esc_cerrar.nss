void main()
{
  object oPC = GetPCSpeaker();
  object oEscritoGuardado = GetLocalObject(oPC, "ESC_PAPEL");

  if(GetLocalInt(oPC, "MODOESCRITURA") > 0)
  {
      SendMessageToPC(oPC, "<cÍþ>Has salido del <cþ>[Modo Escritura]</c>, ya podrás hablar con normalidad.</c>");
      DeleteLocalInt(oPC, "MODOESCRITURA");
  }

  SetItemCursedFlag(oEscritoGuardado, FALSE);
  DeleteLocalObject(oPC, "ESC_PAPEL");
}
