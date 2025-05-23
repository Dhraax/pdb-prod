void main()
{
object oPC = GetEnteringObject();
object oTarget = GetObjectByTag("barco_purskul");
DelayCommand(150.0, AssignCommand(oPC, JumpToObject(oTarget)));
DelayCommand(151.0, DeleteLocalInt(oPC, "HACIA_ESMELTARAN_PURSKUL"));
}
