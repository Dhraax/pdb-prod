void main()
{
  object oPC = GetPCSpeaker();

  int nCantidad= 0;
  object oLenyo = GetFirstItemInInventory(oPC);
  while(GetIsObjectValid(oLenyo))
  {
      if(GetTag(oLenyo) == "cartablon_fresn")
      {
          nCantidad = nCantidad + 1;
          DestroyObject(oLenyo);
      }

      oLenyo = GetNextItemInInventory(oPC);
  }

  GiveGoldToCreature(oPC, 990*nCantidad);
}
