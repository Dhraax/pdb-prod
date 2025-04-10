int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int iNivelPj = GetHitDice (oPC);
    /*int iDesbloqueo6 = GetCampaignInt("DESBLOQUEO", "NIVEL6", oPC);
    int iDesbloqueo11 = GetCampaignInt("DESBLOQUEO", "NIVEL11", oPC);
    int iDesbloqueo16 = GetCampaignInt("DESBLOQUEO", "NIVEL16", oPC);
    int iDesbloqueo21 = GetCampaignInt("DESBLOQUEO", "NIVEL21", oPC);

    if ((iNivelPj > 5)||
        (iDesbloqueo6 == 1)||
        (iDesbloqueo11 == 1)||
        (iDesbloqueo16 == 1)||
        (iDesbloqueo21 == 1))
        {
        return TRUE;
        }
    else{
        return FALSE;} */

    int iDesbloqueo8 = GetCampaignInt("DESBLOQUEO", "NIVEL9", oPC);
    int iDesbloqueo12 = GetCampaignInt("DESBLOQUEO", "NIVEL13", oPC);
    int iDesbloqueo16 = GetCampaignInt("DESBLOQUEO", "NIVEL17", oPC);
    int iDesbloqueo20 = GetCampaignInt("DESBLOQUEO", "NIVEL21", oPC);
    int iDesbloqueo21 = GetCampaignInt("DESBLOQUEO", "NIVEL22", oPC);
    int iDesbloqueo23 = GetCampaignInt("DESBLOQUEO", "NIVEL24", oPC);
    int iDesbloqueo25 = GetCampaignInt("DESBLOQUEO", "NIVEL26", oPC);
    if ((iNivelPj > 7)||
        (iDesbloqueo8 == 1)||
        (iDesbloqueo12 == 1)||
        (iDesbloqueo16 == 1)||
        (iDesbloqueo20 == 1)||
        (iDesbloqueo21 == 1)||
        (iDesbloqueo23 == 1)||
        (iDesbloqueo25 == 1))
        {
        return TRUE;
        }
    else{
        return FALSE;}
}
