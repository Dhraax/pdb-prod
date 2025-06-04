int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int iDisfraz = StringToInt(GetScriptParam("Disfraz"));
    int iPuntos = GetSkillRank(30, oPC, TRUE);

    //Disfraz ramdon, 1 punto.
    if(iDisfraz == 5)
    {
        if(iPuntos >= 1) return TRUE;
        else return FALSE;
    }
    //Disfraz 1, 1 puntos.
    else if(iDisfraz == 1)
    {
        if(iPuntos >= 1) return TRUE;
        else return FALSE;
    }
    //Disfraz 2, 9 puntos.
    else if(iDisfraz == 2)
    {
        if(iPuntos >= 9) return TRUE;
        else return FALSE;
    }
    //Disfraz 3, 17 puntos.
    else if(iDisfraz == 3)
    {
        if(iPuntos >= 17) return TRUE;
        else return FALSE;
    }
    return FALSE;
}
