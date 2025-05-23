void main()
{
object oPC = GetPCSpeaker();
object oEspejo = GetItemPossessedBy(oPC,"espejodemano");

DestroyObject(oEspejo);

}
