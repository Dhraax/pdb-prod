void main()
{
  object oPC = GetLastUsedBy();
  string sEtiquetaLlave = GetLockKeyTag(OBJECT_SELF);
  object oDestino = GetWaypointByTag("WP_despachodentro");

  // La puerta necesita un objeto
  if(GetLocked(OBJECT_SELF) == TRUE)
  {
      if(GetItemPossessedBy(oPC, sEtiquetaLlave) == OBJECT_INVALID)
      {
          SendMessageToPC(oPC, "<cáá{>*Ves un monton de botellas de vino en el botellero*</c>");
          return;
      }

      SendMessageToPC(oPC, "<cáá{>*Reorganizas las botellas del modo correcto y se abren unas escaleras ante ti*</c>");
  }

  // Teleport al despacho
  DelayCommand(0.1, AssignCommand(oPC, ClearAllActions()));
  DelayCommand(0.2, AssignCommand(oPC, JumpToObject(oDestino)));
}
