void main()
{
  // Dar un poco de oro al que habla
  GiveGoldToCreature(GetPCSpeaker(), 300);

  // Eliminar objetos del inventario del jugador.
  object oLenyo = GetItemPossessedBy(GetPCSpeaker(), "gema_dia");
  if(GetIsObjectValid(oLenyo) != 0)
  {
    if(GetItemStackSize(oLenyo) > 1)
    {
    SetItemStackSize(oLenyo,GetItemStackSize(oLenyo)-1);
    }
    else
    {
    DestroyObject(oLenyo);
    }

   }


}
