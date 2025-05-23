void main()
{
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "gofcosaterraron");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
