void main()
{
    string sTirada = "1d20";
    int iDado = Random(20)+1;
    string sFraseCompilada = "";

    // Ejemplos:
    //    Tirada de 1d20, resultado = 1 Fallo. Tirada de Fallo critico = 18.
    //    Tirada de 1d20, resultado = 20 Exito. Tirada de Exito critico = 13.
    //    Tirada de 1d20, resultado = 12.

    sFraseCompilada = "Tirada de <cþ~ >"+ sTirada +"</c>, resultado = ";

    if (iDado==1) {
        sFraseCompilada = sFraseCompilada + "<cþ  >1 Fallo</c>. Tirada de Fallo critico = ";
        iDado = Random (20)+1; //Volvemos a tirar el dado para fallo critico
        sFraseCompilada = sFraseCompilada + "<c þþ>" + IntToString(iDado) + "</c>.";
    }
    else if (iDado==20) {
        sFraseCompilada = sFraseCompilada + "<c þ >20 Exito</c>. Tirada de Exito critico = ";
        iDado = Random (20)+1; //Volvemos a tirar el dado para exito critico
        sFraseCompilada = sFraseCompilada + "<c þþ>" + IntToString(iDado) + "</c>.";
    }
    else {
        sFraseCompilada = sFraseCompilada + "<c þþ>"+IntToString(iDado)+"</c>.";
    }
if(GetLocalInt(GetPCSpeaker(), "iDadosDms") == 1)
        SendMessageToAllDMs(GetName(GetPCSpeaker())+": "+sFraseCompilada);
    else
    AssignCommand(GetPCSpeaker(), ActionSpeakString(sFraseCompilada));
    return;
}
