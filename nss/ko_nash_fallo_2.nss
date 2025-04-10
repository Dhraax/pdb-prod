void main()
{
object oPC = GetPCSpeaker();
SetLocalInt(oPC, "fallo_convencer_enterrador", 1);
DelayCommand(600.0, DeleteLocalInt(oPC, "fallo_convencer_enterrador"));
}
