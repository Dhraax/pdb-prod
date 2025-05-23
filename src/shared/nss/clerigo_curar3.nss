void main()
{
    object oPC = GetPCSpeaker();
    string sSubraza = GetStringLowerCase(GetSubRace(oPC));
    int iOro = 100;

    if(GetGold(oPC) >= iOro)
    {
        AssignCommand(oPC, TakeGoldFromCreature(iOro, oPC, TRUE));
        ActionCastSpellAtObject(SPELL_GREATER_RESTORATION, oPC, METAMAGIC_ANY, TRUE);
    }
    else SendMessageToPC(oPC, "¡No tienes " + IntToString(iOro) + " monedas de oro!");
}
