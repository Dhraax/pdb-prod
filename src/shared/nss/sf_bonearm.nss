// Created By Scarface
void main()
{
    object oDM = GetPCSpeaker();
    object oPC = GetLocalObject(oDM, "VCA_OBJETIVO");
    SetCreatureBodyPart(CREATURE_PART_LEFT_BICEP, CREATURE_MODEL_TYPE_UNDEAD, oPC);
    SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, CREATURE_MODEL_TYPE_UNDEAD, oPC);
    SetCreatureBodyPart(CREATURE_PART_LEFT_HAND, CREATURE_MODEL_TYPE_UNDEAD, oPC);
}
