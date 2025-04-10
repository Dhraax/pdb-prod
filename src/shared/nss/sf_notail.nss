// Created By Scarface
void main()
{
    object oDM = GetPCSpeaker();
    object oPC = GetLocalObject(oDM, "VCA_OBJETIVO");
    SetCreatureTailType(CREATURE_TAIL_TYPE_NONE, oPC);
}
