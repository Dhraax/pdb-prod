void main()
{
    string sTirada = "1d8";
    int iDado = Random(8)+1;
    string sResultado;

    sResultado = "<c þþ>"+IntToString(iDado)+"</c>";
if(GetLocalInt(GetPCSpeaker(), "iDadosDms") == 1)
        SendMessageToAllDMs(GetName(GetPCSpeaker())+": "+"Tirada de <cþ~ >"+ sTirada +"</c>, resultado = "+ sResultado +".");
    else
    AssignCommand(GetPCSpeaker(), ActionSpeakString("Tirada de <cþ~ >"+ sTirada +"</c>, resultado = "+ sResultado +"."));
}
