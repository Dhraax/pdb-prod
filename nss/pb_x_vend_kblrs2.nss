/*COMPRADOR DE CABELLERAS, VENDER OBJETOS*/
void main()
{
  object oPJ = GetPCSpeaker();
  object oObj = GetFirstItemInInventory(oPJ);

  /*Cabelleras*/
  string sTag = "Cabelleradebandido";
  int iPrecio = 40;
  int iOro = 0;
  int iStack = 0;

  while(GetIsObjectValid(oObj))
  {
      if(GetTag(oObj) == sTag)
      {
          iStack = GetNumStackedItems(oObj);//Numero de objetos apilados
          if(iStack < 2) iOro += iPrecio;
          else iOro+= (iPrecio*iStack);
          DestroyObject(oObj);
      }
      oObj = GetNextItemInInventory(oPJ);
  }

  GiveGoldToCreature(oPJ,iOro);
}
