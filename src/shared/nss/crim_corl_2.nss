void main()
{
object oPC = GetPCSpeaker();

CreateItemOnObject("informedelalcald", oPC);

SetCampaignInt("QUESTCAMINOORCO", "AVANCE", 3, oPC);
}
