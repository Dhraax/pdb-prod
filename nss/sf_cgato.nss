// Created By Monti
void main()
{
    object oDM = GetPCSpeaker();
    object oPC = GetLocalObject(oDM, "VCA_OBJETIVO");
    SetCreatureTailType(30, oPC);
}
