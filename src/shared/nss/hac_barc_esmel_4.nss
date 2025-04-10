void main()
{
object oPC = GetEnteringObject();
object oTarget = GetObjectByTag("barco_esmel");
DelayCommand(150.0, AssignCommand(oPC, JumpToObject(oTarget)));
DelayCommand(151.0, DeleteLocalInt(oPC, "HACIA_PURSKUL_ESMELTARAN"));
}
