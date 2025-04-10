void main()
{
object oPC = GetPCSpeaker();
SetLocalInt(oPC, "FALLO_PERSUADIR_DRIADA", 1);
DelayCommand(2000.0, SetLocalInt(oPC, "FALLO_PERSUADIR_DRIADA", 0));
}
