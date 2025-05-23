void main()
{
  object oPC = GetPCSpeaker();

  int nCantidad= 0;
  object oLenyo = GetFirstItemInInventory(oPC);
  while(GetIsObjectValid(oLenyo))
  {
      if(GetTag(oLenyo) == "carplenyo_cipres")
      {
          nCantidad = nCantidad + 1;
          DestroyObject(oLenyo);
      }

      oLenyo = GetNextItemInInventory(oPC);
  }

  GiveGoldToCreature(oPC, 5*nCantidad);
}
