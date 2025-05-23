void main()
{
  object oPC = GetLastDisturbed();
  object oObjeto = GetInventoryDisturbItem();
  int iTipoDisturbio = GetInventoryDisturbType();

  if(iTipoDisturbio == INVENTORY_DISTURB_TYPE_ADDED)
  {
      SendMessageToPC(oPC, "¡No metas nada aquí coño!");
      CopyItem(oObjeto, oPC, TRUE);
      DestroyObject(oObjeto);
  }
  else if(iTipoDisturbio == INVENTORY_DISTURB_TYPE_REMOVED)
  {
      CopyItem(oObjeto, OBJECT_SELF, TRUE);
      if(GetTag(OBJECT_SELF) != "Esencias") SetLocalInt(oObjeto, "OFICIO_OBJETO_ENCANTABLE", TRUE);
  }
}
