int StartingConditional()
{
object oMod = GetModule();

if(GetLocalInt(oMod, "TORREOCUPADA") == 1)
return TRUE;
return FALSE;
}
