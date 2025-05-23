void main()
{
    //Variables e inicializaciones.
    string sTirada = "Saber (arcano)";                                         //Tipo de tirada, este texto aparecera en la frase que dice el personaje
    int iDado = Random(20)+1;                                           // Dado que se tira, a esto hay que sumarle los rangos
    int iRangos = GetSkillRank(SKILL_LORE, GetPCSpeaker());         // Rangos de la criatura que activa la bolsa de dados
    string sFraseCompilada = "";                                        // Frase que dira el pj con el resultado de la tirada
    string sRangos = "";

    // Ejemplos:
    //    Tirada de <habilidad>, resultado = 1 Fallo. Tirada de Fallo critico 17+33=50.
    //    Tirada de <habilidad>, resultado = 20 Exito. Tirada de Exito critico 13+33=46.
    //    Tirada de <habilidad>, resultado 12+33=45.
    // Observaciones: Al final siempre acaba con iDado+iRangos=Total. Esto se resumira
    //  al final para abreviar el script

    sFraseCompilada = "Tirada de <cþ~ >"+ sTirada +"</c>, resultado ";

    if (iDado==1) {
        sFraseCompilada = sFraseCompilada
                        + "= <cþ  >1 Fallo</c>. Tirada de Fallo crítico ";
        iDado = Random (20)+1; //Volvemos a tirar el dado para fallo critico
        // La parte que continuaria, se pone al final de los condicionales, dado que
        // es la misma para las 3 posibilidades
    }
    else if (iDado==20) {
        sFraseCompilada = sFraseCompilada
                        + "= <c þ >20 Éxito</c>. Tirada de Éxito crítico ";
        iDado = Random (20)+1; //Volvemos a tirar el dado para fallo critico
        // La parte que continuaria, se pone al final de los condicionales, dado que
        // es la misma para las 3 posibilidades
    }

    // tanto si es pifia, como exito, como una tirada normal, lo que viene al final
    // es lo que continua aqui. <iDado>+<iRangos>=<Total>.  ejemplo: 12+33=45.
    if (iRangos<0) sRangos = IntToString(iRangos); // Si es negativo, ya lleva signo
    else sRangos = "+"+IntToString(iRangos); // Sino, es positivo
    sFraseCompilada = sFraseCompilada
                        + "<c þþ>" //Color cyan
                        + IntToString(iDado)+sRangos //Dado+Rangos
                        +"="+IntToString(iDado+iRangos) // = Total
                        +"</c>."; // Fin de la frase
   if(GetLocalInt(GetPCSpeaker(), "iDadosDms") == 1)
        SendMessageToAllDMs(GetName(GetPCSpeaker())+": "+sFraseCompilada);
    else
    AssignCommand(GetPCSpeaker(), ActionSpeakString(sFraseCompilada));
    return;
}
