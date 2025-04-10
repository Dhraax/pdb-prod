void main()
{
    // Quitar algo de oro al jugador
    TakeGoldFromCreature(550, GetPCSpeaker(), TRUE);

    object oPC = GetPCSpeaker();
    object oBarco_Esmel_1 = GetObjectByTag("Purskul_Esmel_1");

    SetLocalInt(oPC, "HACIA_PURSKUL_ESMELTARAN", 1);
    AssignCommand(oPC,ClearAllActions());
    AssignCommand(oPC,JumpToObject(oBarco_Esmel_1));
}
