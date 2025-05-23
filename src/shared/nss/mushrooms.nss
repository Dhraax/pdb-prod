void main()
{
object oPC = GetLastUsedBy();

if (!GetIsPC(oPC)) return;

if(GetLocalInt(GetModule(), "SETAPARAMOS") == 0)
    {
     FloatingTextStringOnCreature("*Coges una seta*", oPC);
     CreateItemOnObject("setaparamos", oPC);
     SetLocalInt(GetModule(), "SETAPARAMOS", 1);
     DelayCommand(200.0, DeleteLocalInt(GetModule(), "SETAPARAMOS"));
    }
else
    {
     FloatingTextStringOnCreature("*Estas setas son muy pequeñas, tendría que dejarlas crecer.*", oPC);
    }
}
