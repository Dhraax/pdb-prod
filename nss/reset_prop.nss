void main()
{
object oPC=GetPCSpeaker();
object oContenedor = GetObjectByTag("spawn_encuentros");

object oItem = GetItemInSlot(GetLocalInt(oContenedor,"Sel"),oPC);

if (!GetIsObjectValid(oItem)) return;

itemproperty ipLoop=GetFirstItemProperty(oItem);


while (GetIsItemPropertyValid(ipLoop))
   {
      RemoveItemProperty(oItem, ipLoop);

   ipLoop=GetNextItemProperty(oItem);
   }
}
