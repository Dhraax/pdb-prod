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
Variable 11: Quest de Matar al Oso.  script: qa_ondeath.nss
Variable 12: Quest encontrar alijo en la Infraoscuridad. script: qa_encontrar.nss
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

    //QUEST NIVELES 16
    //Asignamos mision nivel 16 aleatoria
    switch(Random(3))
    {
        //Quest Criatura de la Infraoscuridad.
        case 0:
                oParty = GetFirstFactionMember(oPC, TRUE);
                switch(d3())
                {
                    case 1: sSpawnPoint = "wp_qa_11_1"; break;
                    case 2: sSpawnPoint = "wp_qa_11_2"; break;
                    case 3: sSpawnPoint = "wp_qa_11_3"; break;
                }
                oTarget = GetWaypointByTag(sSpawnPoint);
                lDest = GetLocation(oTarget);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 0)
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA", 11);
                            //CreateItemOnObject("quest_11", oParty);
                            AddJournalQuestEntry("quest_11", 1, oParty, FALSE);
                            if(GetObjectByTag("qa_quest_11") == OBJECT_INVALID ) oCreature = CreateObject(OBJECT_TYPE_CREATURE, "qa_quest_11", lDest, FALSE);
                            FloatingTextStringOnCreature("<c þ >*¡Se te ha asignado una misión! Revisa tu diario.*</c>", oParty, FALSE);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

        //Quest Encontrar Tesoro Infraoscuridad
        case 1:
                oParty = GetFirstFactionMember(oPC, TRUE);
                switch(d3())
                {
                    case 1: sSpawnPoint = "wp_qa_12_1"; break;
                    case 2: sSpawnPoint = "wp_qa_12_2"; break;
                    case 3: sSpawnPoint = "wp_qa_12_3"; break;
                }
                oTarget = GetWaypointByTag(sSpawnPoint);
                lDest = GetLocation(oTarget);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 0)
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA", 12);
                            //CreateItemOnObject("quest_12", oParty);
                            AddJournalQuestEntry("quest_12", 1, oParty, FALSE);
                            if(GetObjectByTag("qa_found_12") == OBJECT_INVALID ) CreateObject(OBJECT_TYPE_PLACEABLE, "qa_found_12", lDest, FALSE);
                            FloatingTextStringOnCreature("<c þ >*¡Se te ha asignado una misión! Revisa tu diario.*</c>", oParty, FALSE);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

         //Quest Sierpe Blanca
        case 2:
                oParty = GetFirstFactionMember(oPC, TRUE);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 0)
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA", 13);
                            //CreateItemOnObject("quest_13", oParty);
                            AddJournalQuestEntry("quest_13", 1, oParty, FALSE);
                            FloatingTextStringOnCreature("<c þ >*¡Se te ha asignado una misión! Revisa tu diario.*</c>", oParty, FALSE);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

          //Quest Arcano Peligroso
        case 3:
                oParty = GetFirstFactionMember(oPC, TRUE);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 0)
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA", 14);
                            //CreateItemOnObject("quest_14", oParty);
                            AddJournalQuestEntry("quest_14", 1, oParty, FALSE);
                            FloatingTextStringOnCreature("<c þ >*¡Se te ha asignado una misión! Revisa tu diario.*</c>", oParty, FALSE);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;
    }
}
