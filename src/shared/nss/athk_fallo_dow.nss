void main()
{
object oPC = GetPCSpeaker();
SetLocalInt(oPC, "FALLO_CONV_SOLD_DROW", 1);
DelayCommand(300.0, DeleteLocalInt(oPC, "FALLO_CONV_SOLD_DROW"));
}
