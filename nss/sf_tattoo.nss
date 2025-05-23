// Created By Scarface
void main()
{
    object oDM = GetPCSpeaker();
    object oPC = GetLocalObject(oDM, "VCA_OBJETIVO");
    SetCreatureBodyPart(CREATURE_PART_TORSO, CREATURE_MODEL_TYPE_TATTOO, oPC);
}
