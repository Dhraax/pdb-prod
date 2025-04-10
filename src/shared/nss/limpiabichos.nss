int SiPC()
{
object oPC = GetFirstObjectInArea();
 //Scripts para eliminar los pnj del área.
  ExecuteScript ("z0_area_onexit", oPC);
while(GetIsObjectValid(oPC))
    {
    if(GetIsPC(oPC))
        {
        return TRUE;
        break;
        }
    oPC = GetNextObjectInArea();
    }
return FALSE;
}
void main()
{
object oPC = GetExitingObject();
if (SiPC()==TRUE)return;
DelayCommand(30.0, ExecuteScript("limpiabichos_inc", OBJECT_SELF));

}
