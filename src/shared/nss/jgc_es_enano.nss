int StartingConditional()
{
    object oPC= GetLastSpeaker();
    if(GetRacialType(oPC) == IP_CONST_RACIALTYPE_DWARF ||
       GetItemPossessedBy(oPC, "jj_llaveenanos") != OBJECT_INVALID  ) return TRUE;
     else return FALSE;
}
