void main()
{
object oPC = GetPCSpeaker();

SetCampaignInt("PESCADERO_MURAN", "ESPECIES", 1, oPC);
CreateItemOnObject("asy_muranespecies", oPC, 1);
}
