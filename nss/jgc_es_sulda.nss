int StartingConditional()
{
    object oPC= GetLastSpeaker();
    if(GetItemPossessedBy( oPC, "AliadodeSuldanessalar") != OBJECT_INVALID) return TRUE;
    else return FALSE;
}
