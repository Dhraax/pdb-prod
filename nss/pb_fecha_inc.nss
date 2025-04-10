/*
    Algoritmo obtenido de
    http://ptspts.blogspot.com.es/2009/11/how-to-convert-unix-timestamp-to-civil.html
    - object oPJ: Individuo que vera en pantalla el mensaje
    - int unix_time: Timestamp de unix (Segundos desde 01/01/1970)
*/

void PrintHumanDate(object oPC, object oObjetivo, int unix_time, int iAjusteHorario, int iFechaCreacion=FALSE)
{

    int dia, mes , anyo;
    int segundos, minutos, horas;
    int aux, aux2,aux3;

    unix_time = unix_time + iAjusteHorario;

    /*
    // Calculamos la hora con precision del timestamp..hasta aqui solo es
    // cuestion de tomar como premisa que:
    // 1 día = 86400 secs
    // 1 minuto = 60 secs
    // 1 hora = 3600 secs
    */

    segundos = unix_time % 86400;
    unix_time /= 86400;

    horas = segundos/3600;
    minutos = segundos/60%60;
    segundos = segundos%60;

    /*
    // Esta parte del codigo es dificil de explicar...basicamente
    // resolvemos la congruencia de Zoeller para determinar dias que
    // tiene un mes, dias que tiene el anyo en el que estamos..bla bla
    */

    aux = (unix_time*4+102032)/146097+15;
    aux2 = unix_time+2442113+aux-(aux/4);

    anyo = (aux2*20-2442)/7305;

    aux3 = aux2-365*anyo-anyo/4;

    mes = aux3*1000/30601;
    dia = aux3-mes*30-mes*601/1000;

    // Ajuste de anyo bisiesto
    if (mes <14)
    {
        anyo = anyo-4716;
        mes = mes -1;
    }
    else
    {
        anyo = anyo-4715;
        mes = mes -13;
    }

   if(iFechaCreacion == TRUE)
   {

       SendMessageToPC(oPC,"<c´þd>"+GetName(oObjetivo)+" se creó a las "+IntToString(horas)+":"+IntToString(minutos)+":"+IntToString(segundos)+" horas del "+IntToString(dia)+"/"+IntToString(mes)+"/"+IntToString(anyo));
   }
   else
   {
       SendMessageToPC(oPC,"<c´þd>Son las "+IntToString(horas)+":"+IntToString(minutos)+":"+IntToString(segundos)+" horas del "+IntToString(dia)+"/"+IntToString(mes)+"/"+IntToString(anyo));
   }
}

//Devuelve la Fecha y Hora de los segundos desde 1/1/1970.
string GetFechaCreacion (int unix_time, int iAjusteHorario) {
    int dia, mes , anyo;
    int segundos, minutos, horas;
    int aux, aux2,aux3;

    unix_time = unix_time + iAjusteHorario;

    /*
    // Calculamos la hora con precision del timestamp..hasta aqui solo es
    // cuestion de tomar como premisa que:
    // 1 día = 86400 secs
    // 1 minuto = 60 secs
    // 1 hora = 3600 secs
    */

    segundos = unix_time % 86400;
    unix_time /= 86400;

    horas = segundos/3600;
    minutos = segundos/60%60;
    segundos = segundos%60;

    /*
    // Esta parte del codigo es dificil de explicar...basicamente
    // resolvemos la congruencia de Zoeller para determinar dias que
    // tiene un mes, dias que tiene el anyo en el que estamos..bla bla
    */

    aux = (unix_time*4+102032)/146097+15;
    aux2 = unix_time+2442113+aux-(aux/4);

    anyo = (aux2*20-2442)/7305;

    aux3 = aux2-365*anyo-anyo/4;

    mes = aux3*1000/30601;
    dia = aux3-mes*30-mes*601/1000;

    // Ajuste de anyo bisiesto
    if (mes <14)
    {
        anyo = anyo-4716;
        mes = mes -1;
    }
    else
    {
        anyo = anyo-4715;
        mes = mes -13;
    }

    string sDia, sMes, sHora, sMin, sSeg, sFechaCreacion;

    if (dia<10){
        sDia = "0" + IntToString(dia);
    }
    sDia = IntToString(dia);
    if (mes<10){
        sDia = "0" + IntToString(mes);
    }
    sMes = IntToString(mes);
    if (horas<10){
        sDia = "0" + IntToString(horas);
    }
    sHora = IntToString(horas);
    if (minutos<10){
        sMin = "0" + IntToString(minutos);
    }
    sMin = IntToString(minutos);
    if (segundos<10){
        sMin = "0" + IntToString(segundos);
    }
    sSeg = IntToString(segundos);

    sFechaCreacion = sDia + "/" + sMes + "/" + IntToString(anyo) + " " + sHora + ":" + sMin + ":" + sSeg;
    return sFechaCreacion;
}
