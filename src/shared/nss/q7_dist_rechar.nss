/*MONTI: SI SE ANYADE UN OBJETO EN EL INVENTARIO DEL UBICADO CUANDO YA HAY UNO
DENTRO, ESTE IRA A TU INVENTARIO, EN EL ONDISTURBED*/
void main()
{

if(GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_ADDED)
    {
      object oPC = GetLastDisturbed();
      object oItem = GetInventoryDisturbItem();

      //check to see if there is more than one item in the recharger
      object oInv = GetFirstItemInInventory();
      oInv = GetNextItemInInventory();
      //if there is more than one item - get rid of the old one and give it back to the pc
      if(GetIsObjectValid(oInv) == TRUE)
         {
           CopyObject(oInv, GetLocation(OBJECT_SELF), oPC);
           DestroyObject(oInv);
         }
    }
}
