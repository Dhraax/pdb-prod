void main()
{
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "qui_componieve");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
