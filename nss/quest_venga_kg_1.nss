void main()
{
object oPC = GetPCSpeaker();
SetLocalInt(oPC, "MIKAEL_CAGADA", 1);
DelayCommand(10.0, DeleteLocalInt(oPC, "MIKAEL_CAGADA"));
}
