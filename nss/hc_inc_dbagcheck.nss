// hcr3 7/27/2003

void CheckDbag(object oDropBag)
{
   object oItem = GetFirstItemInInventory(oDropBag);
   if (!GetIsObjectValid(oItem))
           DelayCommand(4.0, DestroyObject(oDropBag));
}
