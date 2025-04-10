int StartingConditional()
{
object oPC = GetPCSpeaker();

if(GetLocalInt(oPC, "QUEST_ALEATORIA") == 0 ) return TRUE;
else return FALSE;
}
