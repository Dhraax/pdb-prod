void main()
{
  object oPC = GetLastDisturbed();
  object iObjetoAlterado = GetInventoryDisturbItem();
  int iTipoDisturbio = GetInventoryDisturbType();

  if(iTipoDisturbio == INVENTORY_DISTURB_TYPE_REMOVED)
  {
      CopyItem(iObjetoAlterado, OBJECT_SELF);

      if(GetLocalInt(OBJECT_SELF, "ABUSOPERMITIDO") == FALSE)
      {
          if(GetLocalInt(OBJECT_SELF, "NOABUSAR" + GetName(oPC)) == TRUE)
          {
              SendMessageToPC(oPC, "¡No puedes coger más!");
              DestroyObject(iObjetoAlterado);
          }
          else SetLocalInt(OBJECT_SELF, "NOABUSAR" + GetName(oPC), TRUE);
      }
  }

  else if(GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_ADDED)
  {
      CopyObject(iObjetoAlterado, GetLocation(OBJECT_SELF), oPC);
      DestroyObject(iObjetoAlterado);
      SendMessageToPC(oPC, "¡No puedes meter nada aquí!");
  }
}
