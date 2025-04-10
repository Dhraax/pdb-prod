#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();

  SetLocalInt(oPC, "AGATHA_NO_NO", 1);
  DelayCommand(300.0, DeleteLocalInt(oPC,"AGATHA_NO_NO"));
}
