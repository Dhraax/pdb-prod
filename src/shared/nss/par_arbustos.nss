void main()
{
  object oPC = GetLastUsedBy();

  if(GetItemPossessedBy(oPC, "llave_paramos3") == OBJECT_INVALID &&
     GetItemPossessedBy(oPC, "llave_paramos4") == OBJECT_INVALID)
  {
      SendMessageToPC(oPC, "<cþ<<>No hay nada interesante aquí.</c>");
      return;
  }

  // Teleport
  object oDestino = GetWaypointByTag("par_faccion_dentro");
  SendMessageToPC(oPC, "<c´þd>* Los arbustos y raíces se abren mágicamente a tu paso revelando un sendero oculto *</c>");
  DelayCommand(2.0, AssignCommand(oPC, ClearAllActions()));
  DelayCommand(2.1, AssignCommand(oPC, JumpToObject(oDestino)));
}
