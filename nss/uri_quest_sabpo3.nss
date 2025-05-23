int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetLocalInt(oPC, "QUEST_SABER_POP_MERCADERES_FALLO");

if(!(nComprobarVar == 1)) return FALSE;

return TRUE;
}
