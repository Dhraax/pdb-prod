// Created By Scarface
void main()
{
    object oDM = GetPCSpeaker();
    object oPC = GetLocalObject(oDM, "VCA_OBJETIVO");
    int iPartNum = GetCreatureBodyPart(CREATURE_PART_HEAD, oPC) + 1;
    if (iPartNum > 34) iPartNum = 1;
    SetCreatureBodyPart(CREATURE_PART_HEAD,  iPartNum, oPC);
}
