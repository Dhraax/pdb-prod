void main()
{
  object oPC = GetLastUsedBy();

  if(GetItemPossessedBy(oPC, "ko_llave_iniciadocyrita") == OBJECT_INVALID)
  {
      SendMessageToPC(oPC, "<cþ<<>No hay nada interesante aquí.</c>");
      return;
  }

  // Teleport
  object oDestino = GetWaypointByTag("WP_ko_sede_cyrita_entradanormal");
  SendMessageToPC(oPC, "<c´þd>* Las calaveras te reconocen, y se abre el paso secreto *</c>");
  DelayCommand(2.0, AssignCommand(oPC, ClearAllActions()));
  DelayCommand(2.1, AssignCommand(oPC, JumpToObject(oDestino)));
}
