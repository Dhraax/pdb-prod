// Created By Scarface
void main()
{
    object oDM = GetPCSpeaker();
    object oPC = GetLocalObject(oDM, "VCA_OBJETIVO");
    SetCreatureWingType(CREATURE_WING_TYPE_BAT, oPC);
}
