void main()
{
object oPC = GetPCSpeaker();

object oLlave = GetItemPossessedBy(oPC, "llavceldanashkel"); //Quitamos la llave del personaje
if(GetIsObjectValid(oLlave)) DestroyObject(oLlave);
GiveXPToCreature(GetPCSpeaker(), 500);
}

