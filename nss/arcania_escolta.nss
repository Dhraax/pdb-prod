void main()
{

object oPC = GetPCSpeaker();
string nombre = GetName(oPC);
string cuenta = GetPCPlayerName(oPC);

DelayCommand(2.5, AddHenchman(oPC, OBJECT_SELF));
}
