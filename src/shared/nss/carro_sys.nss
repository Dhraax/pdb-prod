#include "viaje_inc"
#include "inc_sqlite_time"
/*

void DoViaje(string sDestinationWP, int nEncounterFrequency,int nTileSet, object oPC)

sDestinationWP = El waypoint de destino
nEncounterFrequency = % de posibilidad de ser asaltados
nTileSet = El tipo de tileset para los encuentros.
    1 = Rural
    2 = Bosque
    3 = Cuevas, subterraneos
    4 = Barco

    //Poner en el OnEnter del servidor
    string sWaypoint = GetLocalString(oPC, "sTargetWP");
    object oWaypoint = GetWaypointByTag(sWaypoint);
    location lLocation = GetLocation(oWaypoint);
    object oArea = GetLocalObject(oPC, "TRANSPORTE");
    if(GetLocalInt(oPC, "VIAJE") == 1) {
        SetLocalInt(oPC, "VIAJE", 0);
        SetLocalInt(oPC, "ENCUENTRO", 0);
        DeleteLocalString(oPC, "ESTOYVIAJANDO");
        DeleteLocalInt(oArea, "OCUPADA");
        DeleteLocalObject(oPC, "TRANSPORTE");
        AssignCommand(oPC, ClearAllActions());
        AssignCommand(oPC, ActionJumpToLocation(lLocation));
        }
*/

void main()
{

    object oPC = GetPCSpeaker();
    object oWaypoint;
    string sArea = GetTag(GetArea(oPC));
    object oMod = GetModule();
    string sDestinationWP = GetScriptParam("Destino"); //Viajamos al destino

    //NO VIAJAMOS SI EL DESTINO ES EL MISMO QUE EL DEL VIAJE.
    if(GetArea(GetObjectByTag(sDestinationWP)) == GetArea(oPC))
    {
        FloatingTextStringOnCreature("<cþ<<>Lo sentimos, pero has elegido un destino en el que ya estás. Selecciona otro destino.</c>", oPC);
        return;
    }

 //Chekeamos transporte libre
    int sNum = -1;
    string sWaypoint;
    if(!GetLocalInt(GetObjectByTag("caravana1"), "OCUPADA")){oWaypoint = GetWaypointByTag("WP_caravana1"); sNum = 1; sWaypoint = "WP_caravana1";}
    else if(!GetLocalInt(GetObjectByTag("caravana2"), "OCUPADA")){oWaypoint = GetWaypointByTag("WP_caravana2");sNum = 2; sWaypoint = "WP_caravana2";}
    else if(!GetLocalInt(GetObjectByTag("caravana3"), "OCUPADA")){oWaypoint = GetWaypointByTag("WP_caravana3");sNum = 3; sWaypoint = "WP_caravana3";}
    else if(!GetLocalInt(GetObjectByTag("caravana4"), "OCUPADA")){oWaypoint = GetWaypointByTag("WP_caravana4");sNum = 4; sWaypoint = "WP_caravana4";}

    else
        {
      FloatingTextStringOnCreature("<cþ<<>Lo sentimos pero las 5 caravanas que tiene habilitado el servidor están ocupadas. Inténtalo más tarde.</c>", oPC);
      return;
        }

    //Asignamos transporte
    location lLocation = GetLocation(oWaypoint);

    //Ajustes del viaje
    int nTileSet = 3; //bosque
    int nEncounterFrequency = 99; //Probabilidad de encuentro
    int nTime = 120; //Duración del viaje en segundos
    int nOro = 300; //Coste del viaje
    float fTime = IntToFloat(nTime);
    float fRandom;


    //Hacemos que los encuentros sean aleatorios en tiempo
       switch (Random(4))
                {
              case 0: fRandom = 25.0; break;
              case 1: fRandom = 45.0; break;
              case 2: fRandom = 65.0; break;
              case 3: fRandom = 35.0; break;
                }

    //Marcamos como ocupado el barco
    string SP_Num = IntToString(sNum);
    object oArea = GetObjectByTag("caravana"+SP_Num);
    SetLocalInt(oArea, "OCUPADA", 1);
    SetLocalObject(oPC, "TRANSPORTE", oArea);

    //Movemos al grupo hacia el transporte
       object oParty = GetFirstFactionMember(oPC, TRUE);
    while(GetIsObjectValid(oParty))
    {
        if(sArea == GetTag(GetArea(oParty)) && GetDistanceBetween(oPC, oParty) <= 5.0 && GetDistanceBetween(oPC, oParty) >= 0.1 || oPC == oParty)
        {
                   if(GetGold(oParty) >= nOro)
                                {
                            TakeGoldFromCreature(nOro, oParty, TRUE);
                            SetLocalInt(oParty, "ENCUENTRO", 0);
                            SetLocalString(oParty, "sTargetWP", sDestinationWP);
                            SetLocalString(oParty, "WAYPOINT", sWaypoint);
                            SetLocalInt(oMod, "TIEMPO_VIAJE" + GetName(oParty), SQLite_GetTimeStamp() + nTime +65);
                            DelayCommand(fTime+fRandom+30.0, DeleteLocalInt(oMod, "TIEMPO_VIAJE" + GetName(oParty)));
                            AssignCommand(oParty, ClearAllActions());
                            AssignCommand(oParty, ActionJumpToLocation(lLocation));
                            DelayCommand(fTime-fRandom, DoViaje(sDestinationWP, nEncounterFrequency, nTileSet, oPC));
                }
            else SendMessageToPC(oParty, "No tienes suficiente oro para viajar.");
        }
            oParty = GetNextFactionMember(oPC, TRUE);

   }// End of while

}


