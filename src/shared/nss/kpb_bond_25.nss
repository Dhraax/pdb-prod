////////////////////////////////////////////
//  Kittrell's Persistent Banking System  //
//  Designed by: Brian J. Kittrell        //
//                                        //
//  This script does the following:       //
//                                        //
//  kpb_bond_25 - This script allows      //
//  players to receive a bullion bank     //
//  bond for 10,000 gold coins.           //
////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    string sItem = "bullionbond25";
    float fComi= 0.05;
    int nCost = 10000;
    nCost = FloatToInt((1.0+fComi)*IntToFloat(nCost));
    int nGold = GetGold(oPC);

    if (nGold < nCost)
    {

        SpeakString("¡Debes de tener  10.000 po + " + FloatToString(fComi*10000.0) + " po de comisión para conseguir una fianza de un lingote de oro valorado en 10.000 po!");
        return;

    }
    if (nGold >= nCost)
    {
        CreateItemOnObject(sItem, oPC);
        TakeGoldFromCreature(10000, oPC, TRUE);
        SpeakString("Muy bien. He cambiado tu oro por una fianza");
        ExportSingleCharacter(oPC);
    }
}
