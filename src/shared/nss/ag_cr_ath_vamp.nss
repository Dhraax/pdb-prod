void main()
{
object oPJ = OBJECT_SELF;
object oBarco_Agujas_1 = GetObjectByTag("Athk_Aguj_3");
if((GetTimeHour()== 21)&&(GetLocalInt(oPJ, "HACIA_AGUJAS_ATHKATLA_VAMP") == 1)||(GetTimeHour()== 21)&&(GetLocalInt(oPJ, "HACIA_AGUJAS_CRIMMOR_VAMP") == 1))
   {
    AssignCommand(oPJ,ClearAllActions());
    AssignCommand(oPJ,JumpToObject(oBarco_Agujas_1));
   }
else
   {
    if((GetLocalInt(oPJ, "HACIA_AGUJAS_ATHKATLA_VAMP") == 1)||(GetLocalInt(oPJ, "HACIA_AGUJAS_CRIMMOR_VAMP") == 1))
       {
        DelayCommand(5.0, ExecuteScript("ag_cr_ath_vamp", oPJ));
        }
   }
}
