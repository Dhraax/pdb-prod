void main()
{
  // Dar un poco de oro al que habla
  GiveGoldToCreature(GetPCSpeaker(), 210);

  // Eliminar objetos del inventario del jugador.
  object oLenyo = GetItemPossessedBy(GetPCSpeaker(), "carptablon_alamo");
  if(GetIsObjectValid(oLenyo) != 0) DestroyObject(oLenyo);
}
