//:://////////////////////////////////////////////////
//:: SISTEMA METEOROLÓGICO PARA PUERTA DE BALDUR. By Versus.
/*
  Este es la librería general del sistema meteorológico del
  servidor Puerta de Baldur.

  Variables:
    - RESP_CLIMA: Indica con el valor 1 ó 0, si se respeta o no el clima por defecto del área.
    - ESTACION: Indica la estación del año en la que se encuentra el servidor. Es una variable del Módulo.
    - PARTE_METEOZONA: Indica con el valor 1 ó 0, si el PJ a interactuado o no con el clima de una zona metereológica concreta.
    - ZONA_CLIMA: Indica la zona geográgica. Valor del 1 al 7. Amn Norte, Amn Centro-Norte, Amn Centro-Sur, Amn Sur, Valle de Minsor, Bosque de Tezhyr  y Archipiélago de Nelanzher.
    - FORZAR_NIEBLA: Indica con el 1 ó 0, si se fuerza la niebla en ese área debe ser establecida en las variables del área.
    - CANT_NIEBLA: Indica el valor adicional de niebla que se quiere añadir a cierta área. Se establecera en las variales del área.
    - Ind_Nieve, Ind_Lluvia, Ind_Sol, Ind_Niebla: Con estas varibles tanto en positivas como en negativas puedes indicar el grado deseado de incidencia en la zona geográfica.
 */
//:://////////////////////////////////////////////////
int Inicializar_Lluvia (int inum)
{
   int iLluvia;
   switch (inum)
        {
            case 1:    iLluvia=10; //Amn Norte
                       break;
            case 2:    iLluvia=2; //Amn Centro-Norte
                       break;
            case 3:    iLluvia=1; //Amn Centro-Sur
                       break;
            case 4:    iLluvia=0; //Amn Sur
                       break;
            case 5:    iLluvia=6; // Valle de Minsor
                       break;
            case 6:    iLluvia=7;  //Bosque de Tezhyr
                       break;
            case 7:    iLluvia=-10; //Islas Nelanzher
                       break;

            default:   iLluvia=0;
                       break;
        }


   return iLluvia;
}

int Inicializar_Nieve (int inum)
{
   int iNieve;
   switch (inum)
        {
            case 1:    //Amn Norte
                       iNieve= 30;
                       break;
            case 2:    //Amn Centro-Norte
                       iNieve= -58;
                       break;
            case 3:    //Amn Centro-Sur
                       iNieve= -68;
                       break;
            case 4:    //Amn Sur
                       iNieve= -78; //10% de que nieve
                       break;
            case 5:    // Valle de Minsor
                       iNieve= 7;
                       break;
            case 6:    //Bosque de Tezhyr
                       iNieve= -78; //10% de que nieve
                       break;
            case 7:    //Islas Nelanzher
                       iNieve= -87; //1% de que nieve.
                       break;

            default:   iNieve= 0;
                       break;
        }


   return iNieve;
}


int Inicializar_Sol (int inum)
{
   int iSol;
   switch (inum)
        {
            case 1:    //Amn Norte
                       iSol=-10;
                       break;
            case 2:    //Amn Centro-Norte
                       iSol=7;
                       break;
            case 3:    //Amn Centro-Sur
                       iSol=8;
                       break;
            case 4:    //Amn Sur
                       iSol=5;
                       break;
            case 5:    // Valle de Minsor
                       iSol=0;
                       break;
            case 6:    //Bosque de Tezhyr
                       iSol=2;
                       break;
            case 7:    //Islas Nelanzher
                       iSol=10;
                       break;

            default:   iSol=0;
                       break;
        }


   return iSol;
}

int Inicializar_Niebla (int inum)
{
   int iNiebla;
   switch (inum)
        {
            case 1:    //Amn Norte
                       iNiebla=10;
                       break;
            case 2:    //Amn Centro-Norte
                       iNiebla=1;
                       break;
            case 3:    //Amn Centro-Sur
                       iNiebla=0;
                       break;
            case 4:    //Amn Sur
                       iNiebla=0;
                       break;
            case 5:    // Valle de Minsor
                       iNiebla=5;
                       break;
            case 6:    //Bosque de Tezhyr
                       iNiebla=6;
                       break;
            case 7:    //Islas Nelanzher
                       iNiebla=-10;
                       break;

            default:
                       iNiebla=0;
                       break;
        }


   return iNiebla;
}



int Hay_Lluvia (string sEstacion, int Ind_Lluvia)
{
    int iRand;
    int iLlueve=FALSE;

    iRand= d100(1);
    if (sEstacion=="PRIMAVERA")
    {
        //Probabilidad de lluvias 27%

          if (iRand>=0 && iRand<=27+Ind_Lluvia) { iLlueve=TRUE; }
    }
    else if (sEstacion=="VERANO")
    {
        //Probabilidad de lluvias 2%
        if (iRand<=2+Ind_Lluvia) { iLlueve=TRUE; }
    }
    else if (sEstacion=="OTOÑO")
    {
        //Probabilidad de lluvias 45%
          if (iRand>55-Ind_Lluvia) {iLlueve=TRUE;}

     }
     else if (sEstacion=="INVIERNO")//Invierno
    {
      //Probabilidad de lluvias 11%
          if (iRand>0 && iRand<=11+Ind_Lluvia) { iLlueve=TRUE; }
    }
    return iLlueve;

}
int Hay_Nieve (string sEstacion, int Ind_Nieve)
{
    int iRand;
    int iNieva=FALSE;
    iRand= d100(1);
    if (sEstacion=="OTOÑO")
    {
        //Probabilidad de nieve 3%

          if (iRand>0 && iRand<3+Ind_Nieve) {iNieva=TRUE;}
     }
     else if (sEstacion=="INVIERNO")
    {
      //Probabilidad de nieve 88%

          if (iRand>12-Ind_Nieve) { iNieva=TRUE;}

    }
    else if (sEstacion=="PRIMAVERA")
    {
        //Probabilidad de nieve 1%
        if (iRand>0 && iRand<1+Ind_Nieve) { iNieva=TRUE; }
    }
    return iNieva;

}

int Hay_Niebla (string sEstacion)
{
    int iRand;
    int iNiebla =0;

    iRand= d100(1);

    if (sEstacion=="PRIMAVERA")
    {

            if (iRand > 98)
            {
                iNiebla = d100(1);
                while ((iNiebla>0 && iNiebla<15) || (iNiebla>24 && iNiebla<=100))
                {
                    iNiebla= d100(1);
                }

            }

    }
    else if (sEstacion=="OTOÑO")
    {

        //Probabilidad de nieblas solo cuando no hay viento y no llueve.
            if (iRand > 74)
            {
                iNiebla = d100(1);
                while ((iNiebla>0 && iNiebla<30) || (iNiebla>49 && iNiebla<=100))
                {
                    iNiebla= d100(1);
                }
            }



    }
    else if (sEstacion=="INVIERNO")//Invierno
    {

        //Probabilidad de nieblas solo cuando no hay viento y no llueve.
            if (iRand > 30)
            {
                iNiebla = d100(1);
                while ((iNiebla>0 && iNiebla<50) || (iNiebla>69 && iNiebla<=100))
                {
                    iNiebla= d100(1);
                }
            }
    }
    else if(sEstacion=="VERANO")
    {
        iNiebla=0;
    }



    return iNiebla;


}

void Cambiar_Clima (object oAreas, object oPJ, int Llueve, int Nieva, int iNiebla)
{
    if (GetLocalInt(oAreas, "RESP_CLIMA")==1)
    {
        return;
    }
    object oMods =  GetModule();
    string sEstacion = GetLocalString(oMods, "ESTACION");
    int iRand;
   /* SendMessageToPC(oPJ, "Estación: " + sEstacion);
    SendMessageToPC(oPJ, "METEOZONA " + IntToString(GetLocalInt(oPJ, "PARTE_METEOZONA")));
    SendMessageToPC(oPJ, "ZONA CLIMA " + IntToString(GetLocalInt(oAreas,"ZONA_CLIMA")));
    SendMessageToPC(oPJ, "CAMBIA CLIMA " + IntToString(GetLocalInt(oAreas,"CAMB_CLIMA")));  */

    //Indicar el tiempo que va tener el area.
    if (sEstacion=="PRIMAVERA")
    {
       if (Nieva==FALSE)
       {
            if (Llueve ==FALSE)
            {   //Probabilidad de nieblas solo cuando no llueve.
                SetWeather(oAreas, WEATHER_CLEAR);
                SetSkyBox(1, oAreas);

                if ((GetLocalInt(oPJ, "PARTE_METEOZONA"))!=(GetLocalInt(oAreas,"ZONA_CLIMA")))
                {
                    SendMessageToPC(oPJ, "Una suave brisa mece las hojas en estos días de primavera.");
                    SetLocalInt(oPJ, "PARTE_METEOZONA",GetLocalInt(oAreas,"ZONA_CLIMA"));
                }
            }
            else
            {
                SetWeather(oAreas,WEATHER_RAIN);
                SetSkyBox(2, oAreas);
                if (GetLocalInt(oPJ, "PARTE_METEOZONA")!=GetLocalInt(oAreas,"ZONA_CLIMA"))
                {
                     SendMessageToPC(oPJ, "Ligera tormenta primaveral.");
                    SetLocalInt(oPJ, "PARTE_METEOZONA",GetLocalInt(oAreas,"ZONA_CLIMA"));
                }
            }
        }
        else
        {
                SetWeather(oAreas, WEATHER_SNOW);  //Reducir Luz
                SetSkyBox(2, oAreas);
                if (GetLocalInt(oPJ, "PARTE_METEOZONA")!=GetLocalInt(oAreas,"ZONA_CLIMA"))
                {
                    SendMessageToPC(oPJ, "Ligera nevada primaveral.");
                    SetLocalInt(oPJ, "PARTE_METEOZONA",GetLocalInt(oAreas,"ZONA_CLIMA"));
                }
        }
    }
    else if (sEstacion=="VERANO")
    {

        if(Llueve==TRUE)
        {
            SetWeather(oAreas,WEATHER_RAIN);
            SetSkyBox(2, oAreas);
            if (GetLocalInt(oPJ, "PARTE_METEOZONA")!=GetLocalInt(oAreas,"ZONA_CLIMA"))
            {
                SendMessageToPC(oPJ, "Pequeña tormenta estival.");
                SetLocalInt(oPJ, "PARTE_METEOZONA",GetLocalInt(oAreas,"ZONA_CLIMA"));
            }


        }
        else
        {
            SetWeather(oAreas, WEATHER_CLEAR);
            SetSkyBox(1, oAreas);
            if (GetLocalInt(oPJ, "PARTE_METEOZONA")!=GetLocalInt(oAreas,"ZONA_CLIMA"))
            {
                SendMessageToPC(oPJ, "Parece hacer un caluroso día de verano.");
                SetLocalInt(oPJ, "PARTE_METEOZONA",GetLocalInt(oAreas,"ZONA_CLIMA"));
            }

        }

    }
    else if (sEstacion=="OTOÑO")
    {

        if (Nieva ==FALSE)
        {

            if(Llueve==FALSE)
            {
                SetWeather(oAreas, WEATHER_CLEAR);
                SetSkyBox(1, oAreas);
                if (GetLocalInt(oPJ, "PARTE_METEOZONA")!=GetLocalInt(oAreas,"ZONA_CLIMA"))
                {
                    SendMessageToPC(oPJ, "El cielo surge encapotado y las hojas de los árboles caen en estos días de otoño.");
                    SetLocalInt(oPJ, "PARTE_METEOZONA",GetLocalInt(oAreas,"ZONA_CLIMA"));
                }
            }
            else
            {

                SetWeather(oAreas,WEATHER_RAIN); //Reducir Luz
                SetSkyBox(2, oAreas);
                if (GetLocalInt(oPJ, "PARTE_METEOZONA")!=GetLocalInt(oAreas,"ZONA_CLIMA"))
                {
                    SendMessageToPC(oPJ, "Copiosa tormenta otoñal.");
                    SetLocalInt(oPJ, "PARTE_METEOZONA",GetLocalInt(oAreas,"ZONA_CLIMA"));
                }

            }
        }
        else
        {
                SetWeather(oAreas, WEATHER_SNOW);  //Reducir Luz
                SetSkyBox(2, oAreas);
                if (GetLocalInt(oPJ, "PARTE_METEOZONA")!=GetLocalInt(oAreas,"ZONA_CLIMA"))
                {
                    SendMessageToPC(oPJ, "Nevada otoñal.");
                    SetLocalInt(oPJ, "PARTE_METEOZONA",GetLocalInt(oAreas,"ZONA_CLIMA"));
                }

         }


    }
    else if (sEstacion=="INVIERNO")
    {

        if (Nieva ==FALSE)
        {

            if(Llueve==FALSE)
            {

                SetWeather(oAreas, WEATHER_CLEAR);
                SetSkyBox(1, oAreas);
                if (GetLocalInt(oPJ, "PARTE_METEOZONA")!=GetLocalInt(oAreas,"ZONA_CLIMA"))
                {
                     SendMessageToPC(oPJ, "El viento invernal sopla con aire gélido");
                     SetLocalInt(oPJ, "PARTE_METEOZONA",GetLocalInt(oAreas,"ZONA_CLIMA"));
                }




            }
            else
            {
                SetWeather(oAreas,WEATHER_RAIN);
                SetSkyBox(2, oAreas);
                if (GetLocalInt(oPJ, "PARTE_METEOZONA")!=GetLocalInt(oAreas,"ZONA_CLIMA"))
                {
                    SendMessageToPC(oPJ, "Lluvia torrencial con grandes ráfagas de viento gélido.");
                    SetLocalInt(oPJ, "PARTE_METEOZONA",GetLocalInt(oAreas,"ZONA_CLIMA"));
                }

            }

        }
        else
        {

                SetWeather(oAreas, WEATHER_SNOW); //Reducir luz
                SetSkyBox(2, oAreas);
                if (GetLocalInt(oPJ, "PARTE_METEOZONA")!=GetLocalInt(oAreas,"ZONA_CLIMA"))
                {
                    SendMessageToPC(oPJ, "Copiosa tormenta nevada.");
                    SetLocalInt(oPJ, "PARTE_METEOZONA",GetLocalInt(oAreas,"ZONA_CLIMA"));
                }


        }

    }
    //SetFogColor(FOG_TYPE_ALL, FOG_COLOR_WHITE, oAreas);
    SetFogAmount(FOG_TYPE_ALL, iNiebla, oAreas);
    SetLocalInt(oAreas, "CAMB_CLIMA", 1);
}

void Obtener_Clima (int iZona, object oArea, object oPC)
{
    object oMod = GetModule();
    int Lluvia, Nieve, Niebla;
    switch (iZona)
        {
            case 1: Lluvia = GetLocalInt(oMod, "Lluvia1");
                    Nieve =  GetLocalInt(oMod, "Nieve1");
                    Niebla = GetLocalInt(oMod, "Niebla1");
                    break;
            case 2: Lluvia = GetLocalInt(oMod, "Lluvia2");
                    Nieve =  GetLocalInt(oMod, "Nieve2");
                    Niebla = GetLocalInt(oMod, "Niebla2");
                    break;
            case 3: Lluvia = GetLocalInt(oMod, "Lluvia3");
                    Nieve =  GetLocalInt(oMod, "Nieve3");
                    Niebla = GetLocalInt(oMod, "Niebla3");
                    break;
            case 4: Lluvia = GetLocalInt(oMod, "Lluvia4");
                    Nieve =  GetLocalInt(oMod, "Nieve4");
                    Niebla = GetLocalInt(oMod, "Niebla4");
                    break;
            case 5: Lluvia = GetLocalInt(oMod, "Lluvia5");
                    Nieve =  GetLocalInt(oMod, "Nieve5");
                    Niebla = GetLocalInt(oMod, "Niebla5");
                    break;
            case 6: Lluvia = GetLocalInt(oMod, "Lluvia6");
                    Nieve =  GetLocalInt(oMod, "Nieve6");
                    Niebla = GetLocalInt(oMod, "Niebla6");
                    break;
            case 7: Lluvia = GetLocalInt(oMod, "Lluvia7");
                    Nieve =  GetLocalInt(oMod, "Nieve7");
                    Niebla = GetLocalInt(oMod, "Niebla7");
                    break;
            default:Lluvia = GetLocalInt(oMod, "Lluvia0");
                    Nieve =  GetLocalInt(oMod, "Nieve0");
                    Niebla = GetLocalInt(oMod, "Niebla0");
                    break;

        }

        if (GetLocalInt(oArea,"FORZAR_NIEBLA")==TRUE)
        {
            Niebla = Niebla + Inicializar_Niebla(GetLocalInt(oArea,"ZONA_CLIMA")) + GetLocalInt(oArea,"CANT_NIEBLA");
            if (GetLocalString(oMod, "ESTACION")=="VERANO")
            {
                  Niebla=0;
            }
        }


        Cambiar_Clima (oArea, oPC, Lluvia, Nieve, Niebla);
}
void Guardar_VarClimaticas (int iZona, int iLluvia=0, int iNieve=0, int iNiebla=0)
{
    object oMod = GetModule();
    switch (iZona)
    {
        case 1:
                SetLocalInt(oMod,"Lluvia1", iLluvia);
                SetLocalInt(oMod,"Nieve1", iNieve);
                SetLocalInt(oMod,"Niebla1", iNiebla);
                break;
        case 2:
                SetLocalInt(oMod,"Lluvia2", iLluvia);
                SetLocalInt(oMod,"Nieve2", iNieve);
                SetLocalInt(oMod,"Niebla2", iNiebla);
                break;
        case 3:
                SetLocalInt(oMod,"Lluvia3", iLluvia);
                SetLocalInt(oMod,"Nieve3", iNieve);
                SetLocalInt(oMod,"Niebla3", iNiebla);
                break;
        case 4:
                SetLocalInt(oMod,"Lluvia4", iLluvia);
                SetLocalInt(oMod,"Nieve4", iNieve);
                SetLocalInt(oMod,"Niebla4", iNiebla);
                break;
        case 5:
                SetLocalInt(oMod,"Lluvia5", iLluvia);
                SetLocalInt(oMod,"Nieve5", iNieve);
                SetLocalInt(oMod,"Niebla5", iNiebla);
                break;
        case 6:
                SetLocalInt(oMod,"Lluvia6", iLluvia);
                SetLocalInt(oMod,"Nieve6", iNieve);
                SetLocalInt(oMod,"Niebla6", iNiebla);
                break;
        case 7:
                SetLocalInt(oMod,"Lluvia7", iLluvia);
                SetLocalInt(oMod,"Nieve7", iNieve);
                SetLocalInt(oMod,"Niebla7", iNiebla);
                break;

        default: //Clima General

                SetLocalInt(oMod,"Lluvia0", iLluvia);
                SetLocalInt(oMod,"Nieve0", iNieve);
                SetLocalInt(oMod,"Niebla0", iNiebla);
                break;
    }

}

void Guardar_Clima (int iZona, string sEstacion, int Ind_Lluvia=0, int Ind_Nieve=0, int Ind_Sol=0, int Ind_Niebla=0)
{

    int iLluvia, iNieve, iHumedad, iNiebla;
    iHumedad = Ind_Lluvia - Ind_Sol;
    iLluvia = Hay_Lluvia(sEstacion, iHumedad);
    iNieve =  Hay_Nieve (sEstacion, Ind_Nieve);
    if (iHumedad >0) { iNiebla = Hay_Niebla(sEstacion);} else { iNiebla=0;}
    Guardar_VarClimaticas(iZona, iLluvia, iNieve, iNiebla);


}


void Reinciar_ClimaAreas()
{
    object oArea = GetFirstArea();
    while (oArea != OBJECT_INVALID)
    {
        if (GetLocalInt(oArea,"CAMB_CLIMA")==1)
        {
            SetLocalInt(oArea, "CAMB_CLIMA", 0);
        }
        oArea= GetNextArea();
    }

}


void Indicar_ClimaAreas()
{
    object oMods =  GetModule();
    object oArea = GetFirstArea();
    int i, nzonas, iLluvia, iNieve, iSol, iNiebla;
    nzonas=7;
    for (i=0; i<=nzonas; i++)
    {

        iLluvia = Inicializar_Lluvia(i);
        iNieve = Inicializar_Nieve(i);
        iSol = Inicializar_Sol(i);
        iNiebla = Inicializar_Niebla(i);
        Guardar_Clima (i, GetLocalString(oMods, "ESTACION"), iLluvia, iNieve, iSol, iNiebla);

    }

}
void Cambiar_ClimaZona (int n)
{

    object oMods =  GetModule();
    int iLluvia, iNieve, iSol, iNiebla;

    iLluvia = Inicializar_Lluvia(n);
    iNieve = Inicializar_Nieve(n);
    iSol = Inicializar_Sol(n);
    iNiebla = Inicializar_Niebla(n);

    object oArea = GetFirstArea();
    while (oArea != OBJECT_INVALID)
    {
        if (GetLocalInt(oArea,"ZONA_CLIMA")==n)
        {
            Guardar_Clima (n, GetLocalString(oMods, "ESTACION"), iLluvia, iNieve, iSol, iNiebla);
            if (GetLocalInt(oArea,"CAMB_CLIMA")==1)
            {
                SetLocalInt(oArea, "CAMB_CLIMA", 0);
            }
        }
        oArea= GetNextArea();
    }

}

