void main()
{
CreateItemOnObject("llavedecriptadep", GetPCSpeaker(), 1);
SetCampaignInt("QUESTPURSKUL", "AVANCE", 2, GetPCSpeaker());

object oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "MedallndeKhauntea");
if(GetIsObjectValid(oItemToTake)) DestroyObject(oItemToTake);
}
