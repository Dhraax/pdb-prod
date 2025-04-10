void main()
{
object oPJ = GetEnteringObject();
DelayCommand(1.0, AssignCommand(oPJ, PlaySound("zep_harp")));
DelayCommand(4.0, AssignCommand(oPJ, PlaySound("zep_piano")));
}
