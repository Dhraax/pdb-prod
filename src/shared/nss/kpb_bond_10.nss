////////////////////////////////////////////
//  Kittrell's Persistent Banking System  //
//  Designed by: Brian J. Kittrell        //
//                                        //
//  This script does the following:       //
//                                        //
//  kpb_bond_10 - This script allows      //
//  players to receive a bullion bank     //
//  bond for 5,000 gold coins.           //
////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    string sItem = "bullionbond10";
    float fComi= 0.05;
    int nCost = 5000;

    nCost = FloatToInt((1.0+fComi)*IntToFloat(nCost));
    int nGold = GetGold(oPC);

    if (nGold < nCost)
    {
        SpeakString("¡Debes de tener  5.000 po + " + FloatToString(fComi*5000.0) + " po de comisión para conseguir una fianza de un lingote de oro valorado en 5.000 po!");
        return;
    }
    if (nGold >= nCost)
    {
        CreateItemOnObject(sItem, oPC);
        TakeGoldFromCreature(nCost, oPC, TRUE);
        SpeakString("Muy bien. He cambiado tu oro por una fianza.");
        ExportSingleCharacter(oPC);
    }
}
