void main()
{
object oPC = GetPCSpeaker();
SetLocalInt(oPC, "fallo_animar_lyretha", 1);
DelayCommand(600.0, DeleteLocalInt(oPC, "fallo_animar_lyretha"));
}
