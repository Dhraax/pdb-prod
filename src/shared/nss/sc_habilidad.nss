// 0 = Empatía animal

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int nSkill = StringToInt(GetScriptParam("SKILL"));
    int nCD = StringToInt(GetScriptParam("CD"));
    int nBaseSkill = StringToInt(GetScriptParam("BASE"));

    int nPCSkill = GetSkillRank(nSkill, oPC, nBaseSkill);
    int nTirada = d20() + nPCSkill;

    if (nTirada >= nCD) return TRUE;

    return FALSE;
}
