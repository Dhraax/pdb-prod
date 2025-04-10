void main()
{
string sParameter = GetScriptParam("Armadura");
object oPC = GetPCSpeaker();
//SetLocalString(GetObjectByTag(oObjeto,"Ench","Armadura");
if(sParameter != "")
    {
     SendMessageToPC(oPC,"Prueba 1");
    }
    sParameter = GetScriptParam("Yelmo");
    if(sParameter != "")
    {
        SendMessageToPC(oPC,"Prueba 2");
    }
    sParameter = GetScriptParam("Capa");
    if(sParameter != "")
    {
       SendMessageToPC(oPC,"Prueba 3");
    }
    sParameter = GetScriptParam("Cinturón");
    if(sParameter != "")
    {
        /*object oItem = CreateItemOnObject(sParameter, oPC, 1);
        if(!GetIsObjectValid(oItem))
        {
            SpeakString("ERROR: Item parameter invalid: " + sParameter, TALKVOLUME_SHOUT);
        } */
    }

}
