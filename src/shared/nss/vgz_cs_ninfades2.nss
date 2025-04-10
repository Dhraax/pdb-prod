void main()
{
object oPC = GetPCSpeaker();
object oEspejo = GetItemPossessedBy(oPC,"espejodeplatasilver");

DestroyObject(oEspejo);

}
