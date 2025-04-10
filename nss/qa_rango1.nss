//////////////////////////////////////////////
// Sistema de Quest Aleatorias              //
// Para niveles 8   Variables 1 - 5         //
// Para niveles 12  Variables 6 - 11        //
// Para niveles 16  Variables 12 - 17       //
//////////////////////////////////////////////

/*PNJ - Reclutador.

- ¡Buenas Aventurero! Tengo algunas misiones que podrian interesar a alguien como tu y tu grupo... ¿Que me dices? La paga será buena. (Condicional no tiene mision, variable "QUEST_ALEATORIA" == 0 ) script qa_nomision.nss
    + Por supuesto.
        - Bien, pues dependiendo de tus habilidades, tengo diferentes grados, a mayor grado, mayor recompensa.
            + Dime las de rango bajo.
                - Las misiones de rango bajo están destinadas a Aventureros que estan empezando. ¿Quereis que os asigne a una de ellas?
                    + Me parece bien, adelante. (Condicional somos menor de nivel 12) script qa_reqrango2.nss
                        - Asi sea. Os daré un documento a cada miembro de tu grupo con toda la información, cuando la completeis, venir a verme para vuestra recompensa.
                            + Perfecto. (Asignamos la mision con un random)  Script - qa_rango1.nss
                    + No, prefiero mirar otras opciones.
            + Dime las de rango medio.
                - Las misiones de rango medio están destinadas a Aventureros que ya han vivido muchas aventuras. ¿Quereis que os asigne a una de ellas?
                    + Me parece bien, adelante. (Condicional somos menor de nivel 16 script) qa_reqrango2.nss
                        - Asi sea. Os daré un documento a cada miembro de tu grupo con toda la información, cuando la completeis, venir a verme para vuestra recompensa.
                            + Perfecto. (Asignamos la mision con un random)  Script - qa_rango2.nss
                    + No, prefiero mirar otras opciones.
            + Dime las de rango alto.
                - Las misiones de rango alto están destinadas a Aventureros expertos, estan suponen un riesgo alto. ¿Quereis que os asigne a una de ellas?
                    + Me parece bien, adelante. (Condicional somos mayor o de nivel 16) script qa_reqrango3.nss
                        - Asi sea. Os daré un documento a cada miembro de tu grupo con toda la información, cuando la completeis, venir a verme para vuestra recompensa.
                            + Perfecto. (Asignamos la mision con un random) Script - qa_rango3.nss
                    + No, prefiero mirar otras opciones.
    + No da igual...
        Fin de la conversación

- ¡Has vuelto! ¿Ya has completado la misión? (Condicional tiene mision activa, variable "QUEST_ALEATORIA" > 0 ) script qa_mision.nss
    + Si. (Condicional tiene mision completa, variable "QUEST_ALEATORIA_COMPLETA" == 1 ) script qa_misionfin.nss
        - ¡Genial! Aqui tienes tu recompensa. (Asignamos script recompensas) Script qa_recompensa.nss
    + Todavia no.
        Fin de la conversación

//Listado de quest
Variable 1: Quest de Matar al Oso.  script: qa_ondeath.nss
Variable 2: Quest encontrar Arthur Main. script: qa_encontrar.nss
Variable 3: Quest de Matar Jefe Bandido. script: qa_ondeath.nss
Variable 4: Quest encontrar Gato Perdido. script: qa_encontrar.nss
Variable 5: Quest encontrar cargamento perdido. script: qa_encontrar.nss
*/

#include "inc_sqlite_time"

void main()
{

    object oPC = GetPCSpeaker();
    string sArea = GetTag(GetArea(oPC));
    object oParty;
    object oCreature;
    location lDest;
    string sSpawnPoint;
    object oTarget;


    //Solo una Quest por reinicio
    if(GetLocalInt(oPC, "QUEST_CD") > SQLite_GetTimeStamp()) {
        FloatingTextStringOnCreature("<cþ<<>*No puedes iniciar otra misión tan rapido*</c>", oPC, FALSE);
        return;
    }

    //QUEST NIVELES 8
    //Asignamos mision nivel 8 aleatoria
    switch (Random(5))
    {
        //Quest traer la cabeza del Oso
        case 0:
                oParty = GetFirstFactionMember(oPC, TRUE);
                switch(d3())
                {
                    case 1: sSpawnPoint = "wp_qa_1_1"; break;
                    case 2: sSpawnPoint = "wp_qa_1_2"; break;
                    case 3: sSpawnPoint = "wp_qa_1_3"; break;
                }
                oTarget = GetWaypointByTag(sSpawnPoint);
                lDest = GetLocation(oTarget);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 0)
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA", 1);
                            //CreateItemOnObject("quest_1", oParty);
                            AddJournalQuestEntry("quest_1", 1, oParty, FALSE);
                            if(GetObjectByTag("qa_quest_1") == OBJECT_INVALID ) oCreature = CreateObject(OBJECT_TYPE_CREATURE, "qa_quest_1", lDest, FALSE);
                            FloatingTextStringOnCreature("<c þ >*¡Se te ha asignado una misión! Revisa tu diario.*</c>", oParty, FALSE);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

        //Quest Encontrar noble
        case 1:
                oParty = GetFirstFactionMember(oPC, TRUE);
                switch(d3())
                {
                    case 1: sSpawnPoint = "wp_qa_2_1"; break;
                    case 2: sSpawnPoint = "wp_qa_2_2"; break;
                    case 3: sSpawnPoint = "wp_qa_2_3"; break;
                }
                oTarget = GetWaypointByTag(sSpawnPoint);
                lDest = GetLocation(oTarget);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 0)
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA", 2);
                            //CreateItemOnObject("quest_2", oParty);
                            AddJournalQuestEntry("quest_2", 1, oParty, FALSE);
                            if(GetObjectByTag("qa_quest_2") == OBJECT_INVALID ) oCreature = CreateObject(OBJECT_TYPE_CREATURE, "qa_quest_2", lDest, FALSE);
                            FloatingTextStringOnCreature("<c þ >*¡Se te ha asignado una misión! Revisa tu diario.*</c>", oParty, FALSE);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

        //Quest traer la cabeza del reptiliano
        case 2:
                oParty = GetFirstFactionMember(oPC, TRUE);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 0)
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA", 3);
                            //CreateItemOnObject("quest_3", oParty);
                            AddJournalQuestEntry("quest_3", 1, oParty, FALSE);
                            FloatingTextStringOnCreature("<c þ >*¡Se te ha asignado una misión! Revisa tu diario.*</c>", oParty, FALSE);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

        //Quest Encontrar Soldados Desaparecidos
        case 3:
                oParty = GetFirstFactionMember(oPC, TRUE);
                switch(d3())
                {
                    case 1: sSpawnPoint = "wp_qa_4_1"; break;
                    case 2: sSpawnPoint = "wp_qa_4_2"; break;
                    case 3: sSpawnPoint = "wp_qa_4_3"; break;
                }
                oTarget = GetWaypointByTag(sSpawnPoint);
                lDest = GetLocation(oTarget);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 0)
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA", 4);
                            //CreateItemOnObject("quest_4", oParty);
                            AddJournalQuestEntry("quest_4", 1, oParty, FALSE);
                            if(GetObjectByTag("qa_found_4") == OBJECT_INVALID )
                            {
                                CreateObject(OBJECT_TYPE_PLACEABLE, "qa_found_4", lDest, FALSE);
                            }
                            FloatingTextStringOnCreature("<c þ >*¡Se te ha asignado una misión! Revisa tu diario.*</c>", oParty, FALSE);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

        //Quest Encontrar Cargamento perdido
        case 4:
                oParty = GetFirstFactionMember(oPC, TRUE);
                switch(d3())
                {
                    case 1: sSpawnPoint = "wp_qa_5_1"; break;
                    case 2: sSpawnPoint = "wp_qa_5_2"; break;
                    case 3: sSpawnPoint = "wp_qa_5_3"; break;
                }
                oTarget = GetWaypointByTag(sSpawnPoint);
                lDest = GetLocation(oTarget);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 0)
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA", 5);
                            //CreateItemOnObject("quest_5", oParty);
                            AddJournalQuestEntry("quest_5", 1, oParty, FALSE);
                            if(GetObjectByTag("qa_found_5") == OBJECT_INVALID ) CreateObject(OBJECT_TYPE_PLACEABLE, "qa_found_5", lDest, FALSE);
                            FloatingTextStringOnCreature("<c þ >*¡Se te ha asignado una misión! Revisa tu diario.*</c>", oParty, FALSE);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;
    }

   //DEBUG
    if(oTarget == OBJECT_INVALID)
        {
          SendMessageToPC(oPC, "Ha habido un error con el waypoint:  "+sSpawnPoint+", reporta esto a Darth");
        }
}
