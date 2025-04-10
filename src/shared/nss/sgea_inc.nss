location SGEA_PuntoGeneracion()
{
int SGEA_HABLOG = 0;
object oPC = GetEnteringObject();

//Localizacion de la Tabla de criaturas
object oTabla = GetNearestObjectByTag("SGEA_Tabla", oPC);

//string sTagRR_PG = GetLocalString(oTabla, "TAG_RR_GP");
int iNumPuntosG = GetLocalInt(oTabla, "NUMPUNTOSG");
string sPuntoG = IntToString(Random(iNumPuntosG)+1);

if(SGEA_HABLOG == 1)
    {
    SendMessageToPC(oPC, "Numero de puntos de geneacion: "+IntToString(iNumPuntosG));
    SendMessageToPC(oPC, "Numero seleccionado: "+sPuntoG);
    SendMessageToPC(oPC, "Etiqueta del PG: SGEA_PG_"+sPuntoG);
    }

//SendMessageToPC(oPC, "Etiqueta del punto de generacion: SGEA_PG_"+sTagPuntosG+"_"+sPuntoG);
return GetLocation(GetNearestObjectByTag("SGEA_PG_"+sPuntoG, oPC));
}

void SGEA_GenerarEncuentro(object oPC)
{
int SGEA_HABLOG = 0;
int nCount;
string sSegmento;
//object oPC = GetEnteringObject();

//Si no es un jugador no se ejecuta
if(!GetIsPC(oPC)) return;
if(GetIsDM(oPC)) return;

//Localizacion de la Tabla de criaturas
object oTabla = GetNearestObjectByTag("SGEA_Tabla", oPC);
if(oTabla == OBJECT_INVALID) return;

//Probabilidad de encuentro
int iProbabilidadEncuentro = GetLocalInt(oTabla, "PROBENCUENTRO");
if(d100() <= iProbabilidadEncuentro)
    {
    if(SGEA_HABLOG == 1) SendMessageToPC(oPC, "Probabilidad de encuentro: Exito.");
    }
else
    {
    if(SGEA_HABLOG == 1) SendMessageToPC(oPC, "Probabilidad de encuentro: Fracaso.");
    return;
    }

//VERIFICACION DE QUE EL ENCUENTRO NO ESTA YA ACTIVO
int iEncuentroActivo = 0;
object oArea = GetArea(oPC);
object oObjectInArea = GetFirstObjectInArea(oArea);
while(GetIsObjectValid(oObjectInArea))
    {
    if(GetLocalInt(oObjectInArea, "SGEA_ACTIVO") == 1) iEncuentroActivo = 1;
    oObjectInArea = GetNextObjectInArea(oArea);
    }
if(iEncuentroActivo == 1)
    {
    if(SGEA_HABLOG == 1) SendMessageToPC(oPC, "Hay encuentros activos.");
    return;
    }

//Cantidad de grupos de criaturas, longitud de tabla
int iSlotsGrupos = GetLocalInt(oTabla, "SLOTSGRUPOS");

if(iSlotsGrupos == 1) //Solo un grupo de criaturas
    {
    }
else                  //Multiples grupos de criaturas
    {
    int iDado100 = Random(100);
    string sGrupoSeleccion;
    string sSetupGrupo;
    int iRangoDePorcentageMenor;
    int iRangoDePorcentageMayor;
    //Seleccion del grupo de monstruos
    for(nCount = 1;nCount <= iSlotsGrupos; nCount++)
        {
        if(GetStringLength(IntToString(nCount)) == 1) sSegmento = "0"+IntToString(nCount);
        else sSegmento = IntToString(nCount);
        sSetupGrupo = GetLocalString(oTabla, "SETUPGRUPO"+sSegmento);
        iRangoDePorcentageMenor = StringToInt(GetStringLeft(sSetupGrupo, 2));
        iRangoDePorcentageMayor = StringToInt(GetSubString(sSetupGrupo, 3, 2));
        if(iDado100 >= iRangoDePorcentageMenor && iDado100 <= iRangoDePorcentageMayor) sGrupoSeleccion = sSegmento;
        }
    //Carga de configuracion de grupo
    int iNumCriaturas;
    int iSlotsGrupoSeleccion = GetLocalInt(oTabla, "SLOTSGRUPO"+sGrupoSeleccion);
    string sSetupGrupoSeleccion =GetLocalString(oTabla, "SETUPGRUPO"+sGrupoSeleccion);
    string sDadoNumCriaturas = GetStringRight(sSetupGrupoSeleccion, 4);
    if(sDadoNumCriaturas == "d1+0") iNumCriaturas = 1;
    else iNumCriaturas = Random(StringToInt(GetSubString(sDadoNumCriaturas, 1,1)))+1+StringToInt(GetStringRight(sDadoNumCriaturas,1));

    //Seleccion del punto de generacion
    location lPuntoGeneracion = SGEA_PuntoGeneracion();

    if(SGEA_HABLOG == 1) //Log para testeos
        {
        SendMessageToPC(oPC, "Grupo seleccionado: "+sGrupoSeleccion);
        SendMessageToPC(oPC, "Slots del grupo seleccionado: "+IntToString(iSlotsGrupoSeleccion));
        SendMessageToPC(oPC, "Setup del grupo seleccionado: "+sSetupGrupoSeleccion);
        SendMessageToPC(oPC, "Dado de criaturas del GS: "+sDadoNumCriaturas);
        SendMessageToPC(oPC, "Numero de criaturas a generar: "+IntToString(iNumCriaturas));
        }

    for(nCount = 1;nCount <= iNumCriaturas; nCount++)
        {
        string sCriatura = IntToString(Random(iSlotsGrupoSeleccion)+1);
        if(GetStringLength(sCriatura) == 1) sCriatura = "0"+sCriatura;
        if(SGEA_HABLOG == 1) SendMessageToPC(oPC, "Numero de criatura generada: "+sCriatura);
        string sRRCriatura = GetLocalString(oTabla, "CRIATURAGRUPO"+sGrupoSeleccion+"_"+sCriatura);
        if(SGEA_HABLOG == 1) SendMessageToPC(oPC, "ResRef de criatura generada: "+sRRCriatura);
        object oCriatura = CreateObject(OBJECT_TYPE_CREATURE, sRRCriatura, lPuntoGeneracion, FALSE);
        SetLocalInt(oCriatura, "X2_L_SPAWN_USE_AMBIENT", 1);
        SetLocalInt(oCriatura, "SGEA_ACTIVO", 1);
        }


    }
}
