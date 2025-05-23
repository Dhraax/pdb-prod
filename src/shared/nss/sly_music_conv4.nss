void main()
{
    int nMod = 4;
    object oPC = GetPCSpeaker();
    object oArea = GetArea(oPC);
    object oModule = GetModule();
    int    nCurrent = GetLocalInt(oPC, "sly_music_current");
    int    nTrack = GetLocalInt(oModule, "sly_music_track_"+IntToString(nCurrent+nMod));
    string sName = GetLocalString(oModule, "sly_music_name_"+IntToString(nCurrent+nMod));
    int    nMusicType = GetLocalInt(oPC, "sly_music_type");

    if (sName == "" || sName == "****")
        sName = "Pista desconocida";

    string sType = " ";
    if (nMusicType == 1)     sType = " música del día número ";
    else if(nMusicType == 2) sType = " música de la noche número ";
    else if(nMusicType == 3) sType = " música de batalla número ";
    SendMessageToPC(oPC, "Ahora escuchando" + sType + IntToString(nTrack) + ": " + sName);

    if (nMusicType <= 2)
    {
        MusicBackgroundStop(oArea);
        if (nMusicType == 0 || nMusicType == 1)
            MusicBackgroundChangeDay(oArea, nTrack);
        if (nMusicType == 0 || nMusicType == 2)
            MusicBackgroundChangeNight(oArea, nTrack);
        MusicBackgroundPlay(oArea);
    }
    else if (nMusicType == 3)
    {
        MusicBattleStop(oArea);
        MusicBattleChange(oArea, nTrack);
        MusicBattlePlay(oArea);
    }
}
