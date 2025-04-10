void main()
{
    // Quitar algo de oro al jugador
    TakeGoldFromCreature(300, GetPCSpeaker(), TRUE);

    object oPC = GetPCSpeaker();
    object oBarco_Purskul_1 = GetObjectByTag("Purskul_Esmel_3");

    SetLocalInt(oPC, "HACIA_ESMELTARAN_PURSKUL", 1);
    AssignCommand(oPC,ClearAllActions());
    AssignCommand(oPC,JumpToObject(oBarco_Purskul_1));
}
