void main()
{
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "gof_sacomolido");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
