#include "mti_libreria"

void main()
{
    object oPC = GetPCSpeaker();
    string sPunto = GetScriptParam("Tag");
    object oPunto = GetObjectByTag(sPunto);

    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, JumpToObject(oPunto));
}

