void main()
{
object oPC = GetEnteringObject();
object oTarget = GetObjectByTag("Purskul_Esmel_4");
DelayCommand(150.0, AssignCommand(oPC, JumpToObject(oTarget)));
}
