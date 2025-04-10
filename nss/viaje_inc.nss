/////////////////////////////////////////////////
// viaje_inc
////////////////////////////////////////////////
/*
void DoViaje(string sDestinationWP, int nEncounterFrequency, int nTileSet, object oPC)

sDestinationWP = El waypoint de destino
nEncounterFrequency = % de posibilidad de ser asaltados
nTileSet = El tipo de tileset para los encuentros.
    1 = Rural
    2 = Bosque
    3 = Cuevas, subterraneos
    4 = Barco
*/
////////////////////////////////////////////////
// Created By: Darth
////////////////////////////////////////////////

#include "viaje_enc_table"

void ContinueTravelAfterEncounter(object oPC);
void CreateBarcoEnemigo(object oPC);
void GotoEncounter(object oPC, location lLocation);
location DetermineDestination(int nTileSet, object oPC);

void GotoEncounter(object oPC, location lLocation)
{
string sDestino = GetLocalString(oPC, "DESTINO");
object oDestino = GetWaypointByTag(sDestino);
location lDestino = GetLocation(oDestino);
AssignCommand(oPC, ClearAllActions());
AssignCommand(oPC, ActionJumpToLocation(lLocation));
}

void CreateBarcoEnemigo(object oPC)
{
string sSpawnPoint = "WP_BARCO_PIRATA";
object oBarcoSpawn = GetNearestObjectByTag(sSpawnPoint, oPC);
location lTargLoc =  GetLocation(oBarcoSpawn);

object oBarco = CreateObject(OBJECT_TYPE_PLACEABLE, "BarcoAsaltante", lTargLoc);
DestroyObject(oBarco, 15.0);
}

location DetermineDestination(int nTileSet, object oPC)
{

    location lLocation;
    string sWaypoint;
    object oWaypoint;
    int sNum = -1;

    switch(nTileSet)
    {
          // Rural
          case 1:

          // Subterraneo
          case 2:

          // Bosque
          case 3:
            if(!GetLocalInt(GetObjectByTag("caravana_enc1"), "OCUPADA")){oWaypoint = GetWaypointByTag("WP_caravana_enc1"); sNum = 1; sWaypoint = "WP_caravana_enc1";}
            else if(!GetLocalInt(GetObjectByTag("caravana_enc2"), "OCUPADA")){oWaypoint = GetWaypointByTag("WP_caravana_enc2");sNum = 2; sWaypoint = "WP_caravana_enc2";}
            else if(!GetLocalInt(GetObjectByTag("caravana_enc3"), "OCUPADA")){oWaypoint = GetWaypointByTag("WP_caravana_enc3");sNum = 3; sWaypoint = "WP_caravana_enc3";}
            else
            {
            FloatingTextStringOnCreature("<cþ<<>Parece que habia algo acercandose, pero se ha alejado...</c>", oPC);
            }
            if(sNum > 0)
            {
            //Marcamos como ocupado la caravana
            string SP_Num = IntToString(sNum);
            object oArea = GetObjectByTag("caravana_enc"+SP_Num);
            SetLocalInt(oArea, "OCUPADA", 1);
            SetLocalObject(oPC, "AREA_ENCUENTRO", oArea);
            SetLocalString(oPC, "DESTINO", sWaypoint);
            //Asignamso localizacion
            lLocation = GetLocation(oWaypoint);
            //DelayCommand(25.0, GenerarEncuentroViaje(nTileSet, oArea, oWaypoint));
            }
            break;

          // Barco
          case 4:
             //Chekeamos transporte libre
            if(!GetLocalInt(GetObjectByTag("viaje_encuentro1"), "OCUPADA")){oWaypoint = GetWaypointByTag("WP_encuentro1"); sNum = 1; sWaypoint = "WP_encuentro1";}
            else if(!GetLocalInt(GetObjectByTag("viaje_encuentro2"), "OCUPADA")){oWaypoint = GetWaypointByTag("WP_encuentro2");sNum = 2; sWaypoint = "WP_encuentro2";}
            else if(!GetLocalInt(GetObjectByTag("viaje_encuentro3"), "OCUPADA")){oWaypoint = GetWaypointByTag("WP_encuentro3");sNum = 3; sWaypoint = "WP_encuentro3";}
            else
            {
            FloatingTextStringOnCreature("<cþ<<>Parece que habia algo acercandose, pero se ha alejado...</c>", oPC);
            }
            if(sNum > 0) {
            //Marcamos como ocupado el barco
            string SP_Num = IntToString(sNum);
            object oArea = GetObjectByTag("viaje_encuentro"+SP_Num);
            SetLocalInt(oArea, "OCUPADA", 1);
            SetLocalObject(oPC, "AREA_ENCUENTRO", oArea);
            SetLocalString(oPC, "DESTINO", sWaypoint);
            //Asignamso localizacion
            lLocation = GetLocation(oWaypoint);
            DelayCommand(25.0, GenerarEncuentroViaje(nTileSet, oArea, oWaypoint));
            }
            break;

    }

       //Devolvemos el nuevo destino creado en el area nueva
    return lLocation;
}

void DoViaje(string sDestinationWP, int nEncounterFrequency, int nTileSet, object oPC)
{

    // Guardamos las variables necesarias
    SetLocalString(oPC, "sTargetWP",sDestinationWP);
    SetLocalInt(oPC, "TileSet", nTileSet);

       //Asignamos el destino
    string sNextWP = sDestinationWP;
    string sArea = GetTag(GetArea(oPC));

    // Lanzamos el dado para determinar si nos asaltan
     int nRoll = 0;
     nRoll = d100();

 //Si el valor es igual o menor a la frecuencia de encuentro
    if(nRoll <= nEncounterFrequency)
        {
            //Asignamos area de encuentro
            location lNextWP = DetermineDestination(nTileSet, oPC);

            //Movemos al grupo al area del encuentro
            object oParty = GetFirstFactionMember(oPC, TRUE);
            while(GetIsObjectValid(oParty))
                {
                if(GetLocalInt(oParty, "VIAJEENCUENTRO") == 0 && sArea == GetTag(GetArea(oParty)))
                   {
                    SetLocalInt(oParty, "VIAJEENCUENTRO", 1);
                    int iAvistar = d20(1) + GetSkillRank(SKILL_SPOT, oParty);
                    int iDC = 18;
                    if(iAvistar > iDC) { FloatingTextStringOnCreature("<c þ >*¡Avistas algo acercandose en el horizonte!*</c>", oParty, FALSE); }
                    DelayCommand(15.0, FloatingTextStringOnCreature("<cþ<<>*¡Os están asaltando!*</c>", oParty, FALSE));
                    //Añadimos el ubicado de barco acercandose(Cuando sepamos cual es...)
                    //DelayCommand(10.0, CreateBarcoEnemigo(oPC));
                    DelayCommand(25.0, GotoEncounter(oParty, lNextWP));
                   }

            oParty = GetNextFactionMember(oPC, TRUE);
                }   // End of while

        }
    else
        {
             // Movemos al grupo al area de destino y liberamos el barco
             object oWaypoint = GetWaypointByTag(sNextWP);
             location lLocation = GetLocation(oWaypoint);

             object oParty = GetFirstFactionMember(oPC, TRUE);
             while(GetIsObjectValid(oParty))
               {
                 if(sArea == GetTag(GetArea(oParty)))
                       {
                        FloatingTextStringOnCreature("<c þ >*¡Estas llegando a tu destino!*</c>", oParty, FALSE);
                        DelayCommand(20.0, ContinueTravelAfterEncounter(oParty));
                       }

            oParty = GetNextFactionMember(oPC, TRUE);
               }// End of while
        }
}

void ContinueTravelAfterEncounter(object oPC)
{
    //Rescatamos las variables guardadas para continuar el viaje tras el asalto
    string sNextWP = GetLocalString(oPC, "sTargetWP");
    object oWaypoint = GetWaypointByTag(sNextWP);
    location lLocation = GetLocation(oWaypoint);
    object oArea = GetLocalObject(oPC, "TRANSPORTE");
    object oEncuentro = GetLocalObject(oPC, "AREA_ENCUENTRO");
    object oMod = GetModule();

    //Movemos al jugador al destino
    SetLocalInt(oPC, "ENCUENTRO", 0);
    SetLocalInt(oPC, "VIAJELOCATION", 0);
    SetLocalInt(oPC, "VIAJEENCUENTRO", 0);
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionJumpToLocation(lLocation));
    DeleteLocalInt(oMod, "TIEMPO_VIAJE" + GetName(oPC));

    //Liberamos el barco
    if(oArea != OBJECT_INVALID) {
    DeleteLocalInt(oArea, "OCUPADA");
    DeleteLocalInt(oEncuentro, "OCUPADA");
    DeleteLocalObject(oPC, "TRANSPORTE");
    DeleteLocalObject(oPC, "AREA_ENCUENTRO");
    }



}
