#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();
  object oPieles = GetFirstItemInInventory(oPC);
  int iContadoPieles = 0;

  while(GetIsObjectValid(oPieles) == TRUE && iContadoPieles < 5)
  {
      if(GetTag(oPieles) == "pieldeloboinvern")
      {
          iContadoPieles++;
          DestroyObject(oPieles);
      }
      oPieles = GetNextItemInInventory(oPC);
  }

  GuardarIntPersistente(oPC, "LITHQUESTSALVYA", 2);
  SetXP(oPC, GetXP(oPC) + 600);
  CreateItemOnObject("qui_mantoblanco", oPC);
}
