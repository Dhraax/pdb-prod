void main()
{
  object oPC = GetPCSpeaker();

  int nCantidad= 0;
  object oLenyo = GetFirstItemInInventory(oPC);
  while(GetIsObjectValid(oLenyo))
  {
      if(GetTag(oLenyo) == "gema_cua")
      {
      int iCuantos = GetItemStackSize(oLenyo);
          nCantidad = nCantidad + iCuantos;
          DestroyObject(oLenyo);
      }

      oLenyo = GetNextItemInInventory(oPC);
  }

  GiveGoldToCreature(oPC, 900*nCantidad);
}
