/////////////////////////////////////////////////
// viaje_enc_table
////////////////////////////////////////////////

#include "x0_i0_henchman"
#include "nwnx_creature"
#include "enc_apariencia"

void AsignarNombre(object oCreature, object oArea)
{
    string sNombre;
    int nClass = GetLocalInt(oCreature, "ENC_CLASS");

        if(nClass == CLASS_TYPE_WIZARD) sNombre = "Asaltante Arcano";
        else if(nClass == CLASS_TYPE_ROGUE) sNombre = "Asaltante Picaro";
        else if(nClass == CLASS_TYPE_FIGHTER || nClass == CLASS_TYPE_BARBARIAN) sNombre = "Asaltante Combatiente";
        else if(nClass == CLASS_TYPE_CLERIC) sNombre = "Asaltante Sacerdote";

    SetName(oCreature, sNombre);
}

void GenerarEncuentroViaje(int nTileSet, object oArea, object oPC);
void GenerarEncuentroViaje(int nTileSet, object oArea, object oPC)
{
  object oCreated;
  object oExit;
  int nNumMons, i;
  string creaturetype;
  int nClass;
  int nPack;
  int nLevel;
  int SP_cntr;
  int sEncuentro;
  int NUM_SPAWNPOINTS = 2;
  string SP_Num;
  string sDestinationWP = GetLocalString(oPC, "sTargetWP");

  int nTipoMon = d2();
  switch (nTipoMon)
        {
         case 1: sEncuentro = 0; nLevel = Random(4)+3; break; //Niveles de 3 a 6
         case 2: sEncuentro = 1; nLevel = Random(4)+6; break; //Niveles de 6 a 9
        }

  for ( SP_cntr=0; SP_cntr < NUM_SPAWNPOINTS; SP_cntr ++ )
  {

     //SP_ENC_0 y SP_ENC_1
     string SP_Num = IntToString(SP_cntr);
     string sSpawnPoint = "SP_ENC_"+SP_Num;
     object oTarget = GetNearestObjectByTag(sSpawnPoint, oPC);
     location lTargLoc =  GetLocation(oTarget);

    //Si ningun miembro del grupo ha generado el encuentro, lo creamos.
    if(GetLocalInt(oPC, "ENCUENTRO") == 0)
    {

        switch(nTileSet)
        {
            //Rural (Encuentros con humanos)
            case 1:
                    //Nivel de Encuentro
                    switch(sEncuentro)
                    {
                    case 0:
                        switch(d3())
                        {
                        case 1: SetLocalInt(oArea, "AparienciaEncuentro", 1); break;
                        case 2: SetLocalInt(oArea, "AparienciaEncuentro", 2); break;
                        case 3: SetLocalInt(oArea, "AparienciaEncuentro", 3); break;
                        }
                        break;
                    case 1:
                        switch(d3())
                        {
                        case 1: SetLocalInt(oArea, "AparienciaEncuentro", 4); break;
                        case 2: SetLocalInt(oArea, "AparienciaEncuentro", 5); break;
                        case 3: SetLocalInt(oArea, "AparienciaEncuentro", 6); break;
                        }
                        break;
                    }

                    //HUMANOS
                    nNumMons = d2(2)+1;
                    //Plantilla de los esbirros
                    creaturetype = "ENC_0_HUMANO";
                    for (i=0;i<nNumMons;i++) {
                    object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creaturetype, lTargLoc, FALSE);
                    switch(d20())
                    {
                    case 1:
                    case 2:
                    case 3:
                    case 4:
                    case 5: nClass = CLASS_TYPE_BARBARIAN; break;
                    case 6:
                    case 7:
                    case 8:
                    case 9:
                    case 10:
                    case 11:
                    case 12:
                    case 13: nClass = CLASS_TYPE_ROGUE; break;
                    case 14:
                    case 15:
                    case 16:
                    case 17: nClass = CLASS_TYPE_FIGHTER; break;
                    case 18:
                    case 19:
                    case 20: nClass = CLASS_TYPE_CLERIC; nPack = 22; break;

                    }

                    SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
                    SetLocalInt(oCreated, "ENC_CLASS", nClass);
                    DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevel, nClass, 22, 76, nPack));
                    DelayCommand(1.2, AsignarApariencia(nClass, oCreated, oArea));
                    DelayCommand(1.5, AsignarNombre(oCreated, oArea));
                    DelayCommand(3.0, ForceRest(oCreated));

                    }

                break;

            //Bosque (Encuentros con Bestias Antiguas)
            case 2:
            case 3:

                    //Nivel de Encuentro
                        switch(sEncuentro)
                        {
                        case 0:
                                switch(d3())
                                {
                                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 9); break;
                                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 10); break;
                                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 11); break;
                                }
                                break;
                        case 1:
                                switch(d3())
                                {
                                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 13); break;
                                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 14); break;
                                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 12); break;
                                }
                                break;
                        }


                //BESTIAS ANTIGUAS
                    nNumMons = d2(2)+1;
                    //Plantilla de los esbirros
                    creaturetype = "ENC_0_RAZAS";
                    for (i=0;i<nNumMons;i++) {
                    object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creaturetype, lTargLoc, FALSE);
                    switch(d20())
                    {
                    case 1:
                    case 2:
                    case 3:
                    case 4:
                    case 5:
                    case 6:
                    case 7:
                    case 8:
                    case 9:
                    case 10: nClass = CLASS_TYPE_BARBARIAN; break;
                    case 11:
                    case 12:
                    case 13:
                    case 14:
                    case 15:
                    case 16:
                    case 17: nClass = CLASS_TYPE_FIGHTER; break;
                    case 18:
                    case 19:
                    case 20: nClass = CLASS_TYPE_CLERIC; nPack = 22; break;

                    }

                    SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
                    SetLocalInt(oCreated, "ENC_CLASS", nClass);
                    DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevel, nClass, 22, 76, nPack));
                    DelayCommand(1.2, AsignarApariencia(nClass, oCreated, oArea));
                    DelayCommand(1.5, AsignarNombre(oCreated, oArea));
                    DelayCommand(3.0, ForceRest(oCreated));

                    }
                break;

            //Cueva y Barco (Encuentros con REPTILES)
            case 4:

                        //Nivel de Encuentro
                        switch(sEncuentro)
                        {
                        case 0:
                                switch(d3())
                                {
                                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 32); break;
                                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 33); break;
                                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 34); break;
                                }
                                break;
                        case 1:
                                switch(d3())
                                {
                                case 1: SetLocalInt(oArea, "AparienciaEncuentro", 35); break;
                                case 2: SetLocalInt(oArea, "AparienciaEncuentro", 24); break;
                                case 3: SetLocalInt(oArea, "AparienciaEncuentro", 37); break;
                                }
                                break;
                        }


                    //REPTILES
                    nNumMons = d2(2)+1;
                    //Plantilla de los esbirros
                    creaturetype = "ENC_0_REPTIL";
                    for (i=0;i<nNumMons;i++) {
                    //Posibilidad de nomuertos
                    if(GetLocalInt(oArea, "AparienciaEncuentro") == 24)
                            {
                           creaturetype = "ENC_0_MUERTOS";
                           CreateObject( OBJECT_TYPE_PLACEABLE, "x3_plc_mist", lTargLoc, FALSE);
                            }
                    object oCreated = CreateObject( OBJECT_TYPE_CREATURE, creaturetype, lTargLoc, FALSE);
                    switch(d20())
                    {
                    case 1:
                    case 2:
                    case 3:
                    case 4:
                    case 5:
                    case 6:
                    case 7:
                    case 8:
                    case 9:
                    case 10: nClass = CLASS_TYPE_BARBARIAN; break;
                    case 11:
                    case 12:
                    case 13:
                    case 14:
                    case 15:
                    case 16: nClass = CLASS_TYPE_FIGHTER; break;
                    case 17:
                    case 18:
                    case 19:
                    case 20: nClass = CLASS_TYPE_CLERIC; nPack = 22; break;

                    }

                    SetLocalInt(oCreated, "X0_L_LEVELRULES", 1);
                    SetLocalInt(oCreated, "ENC_CLASS", nClass);
                    DelayCommand(1.0, LevelHenchmanUpTo(oCreated, nLevel, nClass, 22, 76, nPack));
                    DelayCommand(1.2, AsignarApariencia(nClass, oCreated, oArea));
                    DelayCommand(1.5, AsignarNombre(oCreated, oArea));
                    DelayCommand(3.0, ForceRest(oCreated));

                    }
                break;
        }

    }

 }// End of While Loop


  //Asignamos variable de encuentro creado al grupo para evitar doble encuentro
    object oParty = GetFirstFactionMember(oPC, TRUE);
    while(GetIsObjectValid(oParty))
    {
    if(GetLocalString(oParty, "sTargetWP") == sDestinationWP)
        SetLocalInt(oParty, "ENCUENTRO", 1);

    oParty = GetNextFactionMember(oPC, TRUE);
    }// End of while
}





