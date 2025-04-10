void main()
{
  // Dar un poco de oro al que habla
  GiveGoldToCreature(GetPCSpeaker(), 5);

  // Eliminar objetos del inventario del jugador.
  object oLenyo = GetItemPossessedBy(GetPCSpeaker(), "carplenyo_cipres");
  if(GetIsObjectValid(oLenyo) != 0) DestroyObject(oLenyo);
}
