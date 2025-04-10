void main()
{
  // Dar un poco de oro al que habla
  GiveGoldToCreature(GetPCSpeaker(), 19);

  // Eliminar objetos del inventario del jugador.
  object oLenyo = GetItemPossessedBy(GetPCSpeaker(), "gema_obs");
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
