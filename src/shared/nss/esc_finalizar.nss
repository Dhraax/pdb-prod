void main()
{
  object oPC = GetPCSpeaker();
  object oEscritoGuardado = GetLocalObject(oPC, "ESC_PAPEL");

  SendMessageToPC(oPC, "<cþ<<>Este escrito está finalizado, ya no se podrá editar nunca más.</c>");
  SetLocalInt(oEscritoGuardado, "ESC_FINALIZADO", TRUE);
  SetItemCursedFlag(oEscritoGuardado, FALSE);
}
