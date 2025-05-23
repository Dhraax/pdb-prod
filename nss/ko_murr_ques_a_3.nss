void main()//Quitar llave oxidada
{


    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "kollaveoxidada");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
