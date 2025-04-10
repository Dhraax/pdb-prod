#include "mti_libreria"
#include "lib_area_utils"
#include "x0_i0_position"

void SEGC_CrearObjeto(object oWP, string sResRef, location lLugar, string sTag)
{
    object oObjeto = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lLugar, FALSE, sTag);
    if(!GetIsObjectValid(oObjeto)) SendMessageToAllDMs("z0_area_onenter - Objeto no encontrado en la paleta: "+sResRef+" en el area: "+GetName(GetArea(oWP)));
    SetLocalInt(oObjeto, "SEGC_CriaturaSistema", 1);
    //Aumentamos la altura del npc.
    if (GetLocalInt(oWP, "CAB_ALTURA")==TRUE) { SetObjectVisualTransform (oObjeto, OBJECT_VISUAL_TRANSFORM_SCALE, GetLocalFloat(oWP, "IND_ALTURA")); }
    //Si el npc es tendero podemos aùadir/modificar la tienda por defecto.
    if (GetLocalInt(oWP, "tendero")==TRUE)
    {
        if (GetLocalString(oWP, "TIENDA")!="")
        {
           string sTienda =GetLocalString(oWP, "TIENDA");
           SetLocalString(oObjeto,"TIENDA",sTienda);
        }
        if (GetLocalString(oWP, "TIENDA2")!="")
        {
           string sTienda =GetLocalString(oWP, "TIENDA2");
           SetLocalString(oObjeto,"TIENDA2",sTienda);
        }
        if (GetLocalString(oWP, "TIENDA3")!="")
        {
           string sTienda =GetLocalString(oWP, "TIENDA3");
           SetLocalString(oObjeto,"TIENDA3",sTienda);
        }
    }
    //Cargando variables para el PNJ desde el punto de ruta
    string sVarPNJVar01 = GetLocalString(oWP, "ACT_VAR_PNJ_VAR01");
    string sVarPNJVar02 = GetLocalString(oWP, "ACT_VAR_PNJ_VAR02");
    string sVarPNJVar03 = GetLocalString(oWP, "ACT_VAR_PNJ_VAR03");
    int nVarPNJVal01 = GetLocalInt(oWP, "ACT_VAR_PNJ_VAL01");
    int nVarPNJVal02 = GetLocalInt(oWP, "ACT_VAR_PNJ_VAL02");
    int nVarPNJVal03 = GetLocalInt(oWP, "ACT_VAR_PNJ_VAL03");
    if(sVarPNJVar01 != "NULL" && sVarPNJVar01 != "" ) DelayCommand(1.0, SetLocalInt(oObjeto, sVarPNJVar01, nVarPNJVal01));
    if(sVarPNJVar02 != "NULL" && sVarPNJVar02 != "" ) DelayCommand(1.0, SetLocalInt(oObjeto, sVarPNJVar02, nVarPNJVal02));
    if(sVarPNJVar03 != "NULL" && sVarPNJVar03 != "" ) DelayCommand(1.0, SetLocalInt(oObjeto, sVarPNJVar03, nVarPNJVal03));
}

void main()
{
    object oEntering = OBJECT_SELF;

    //Si no es un jugador sale
    if(!GetIsPC(oEntering)) return;

    object oArea = GetArea(oEntering);
    location lItem;
    object oObjeto;
    int iHabilitarLog = 0;
    int iAleatorio;

    //sistema estatico de generacion de criaturas, los pnjs no aparecen hasta que no entra un jugador en el area
    if(GetLocalInt(oArea, "SEGC_HAB") == 1 && !GetLocalInt(oArea, "SEGC_HECHO"))
    {
        SetLocalInt(oArea,"SEGC_HECHO",1);
        object oWP = GetFirstObjectInArea(oArea);
        string sTagWP;
        string sTagPNJ;
        int nSEGC_NoGenerar;

        while (GetIsObjectValid(oWP))
        {
            sTagWP = GetTag(oWP);
            sTagPNJ = GetStringRight(sTagWP, GetStringLength(sTagWP)-5);
            nSEGC_NoGenerar = GetLocalInt(oWP, "SEGC_SP_NOGENERAR");

            if(GetObjectType(oWP) == OBJECT_TYPE_WAYPOINT && GetStringLeft(sTagWP, 4) == "SEGC" && nSEGC_NoGenerar == 0 && GetObjectByTagInArea(oArea, sTagPNJ) == OBJECT_INVALID)
            {
                DelayCommand(0.2, SEGC_CrearObjeto(oWP, GetName(oWP), GetLocation(oWP), sTagPNJ));
            }

            oWP = GetNextObjectInArea(oArea);
        }
    }
}