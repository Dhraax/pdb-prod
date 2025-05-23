void main()
{
    //BeginConversation();


    int nMatch = GetListenPatternNumber();
    if(nMatch == 2001){
        //SpeakString("FUNCIONA");
    SendMessageToPC(GetPCSpeaker(),"FUNCIONA");

    }
}
