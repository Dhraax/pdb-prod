int StartingConditional()
{
string sNPC = GetTag(OBJECT_SELF);
string sVarName = "MIKAEL_CAGADA";
if(!(GetLocalInt(GetPCSpeaker(), sVarName) == 1))
    return FALSE;
return TRUE;
}


