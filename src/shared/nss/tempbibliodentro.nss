void main()
{
  object oPC = GetLastUsedBy();
  string sEtiquetaLlave = GetLockKeyTag(OBJECT_SELF);
  object oDestino = GetWaypointByTag("WP_bibliodentro");

  // Si la Puerta requiere llave
  if(GetLocked(OBJECT_SELF) == TRUE)
  {
      if(GetItemPossessedBy(oPC, sEtiquetaLlave) == OBJECT_INVALID)
      {
          SendMessageToPC(oPC, "<cþ<<>* Interesantes recetas culinarias *</c>");
          return;
      }

      SendMessageToPC(oPC, "<c´þd>* Extraes el libro adecuado para pasar *</c>");
  }

  // Teleport
  DelayCommand(0.1, AssignCommand(oPC, ClearAllActions()));
  DelayCommand(0.2, AssignCommand(oPC, JumpToObject(oDestino)));
}
