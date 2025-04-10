int StartingConditional()
{
object oPC = GetPCSpeaker();

if(GetLocalInt(oPC, "QUEST_ALEATORIA_COMPLETA") == 1 ) return TRUE;
else return FALSE;
}
