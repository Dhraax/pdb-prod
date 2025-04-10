int StartingConditional()
{
    object oPC=GetPCSpeaker();

    if(GetItemPossessedBy(oPC, "mek_RefugioSalida1")==OBJECT_INVALID) return FALSE;
    return TRUE;
}
