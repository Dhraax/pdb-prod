void main()
{
    int nCantidad= 0;
    object oPC= GetPCSpeaker();
    object oObjeto= GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oObjeto)){
       if (GetTag(oObjeto)=="frutoFantasma"){
          nCantidad= nCantidad+ 1;
          DestroyObject(oObjeto);
       }
       oObjeto= GetNextItemInInventory(oPC);
    }

    GiveGoldToCreature(GetPCSpeaker(), 48*nCantidad);
}
