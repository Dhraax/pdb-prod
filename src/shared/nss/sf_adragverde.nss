// Created By Monti
void main()
{
    object oDM = GetPCSpeaker();
    object oPC = GetLocalObject(oDM, "VCA_OBJETIVO");
    SetCreatureWingType(40, oPC);
}
