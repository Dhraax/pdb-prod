void main()
{
object oPC = GetPCSpeaker();
object oContenedor = GetObjectByTag("spawn_encuentros");
object oItem = GetItemInSlot(GetLocalInt(oContenedor,"Sel"),oPC);


CopyItem(oItem,oPC,FALSE);

}
