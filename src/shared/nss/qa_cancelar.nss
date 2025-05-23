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
    + Quiero cancelar la misión. (script qa_mision.nss)
        - ¡Vaya! Si anulas la misión no podre asignarte otra hasta pasado un tiempo... ¿Estas seguro?
            - Si, anula la misión. (qa_cancelar.nss)
            - No, he cambiado de idea. Cumpliré la misión.
        Fin de la conversación

Variable 1: Quest de Matar al Oso Blanco de los Picos.
Variable 2: Quest encontrar Arthur Main en Crimmor.
Variable 3: Quest de Matar Jefe Bandido. (Matar a un boss humano de nivel 1)
Variable 4: Quest encontrar Gato Perdido en Purskul.
Variable 5: Quest encontrar cargamento perdido.
Variable 6: Quest de Matar Bestia Magica. (Matar a un boss bestia magica de nivel 2)
Variable 7: Quest encontrar Prisioneros.
Variable 8: Quest de Matar Jefe Bandido. (Matar a un boss humano de nivel 2)
Variable 9: Quest encontrar cargamento en Fortaleza Humedales.
Variable 10: Quest encontrar cargamento perdido en Nermiak.
Variable 11: Quest de criatura de la infraoscuridad.  (Matar a un boss de la infra de nivel 3)
Variable 12: Quest encontrar alijo en la Infraoscuridad.
Variable 13: Quest Sierpe Blanca (Matar dragon blanco de los picos)
Variable 14: Quest Arcano Peligroso. (Matar Lordmimo)
*/

#include "inc_sqlite_time"

void main()
{

    object oPC = GetPCSpeaker();

    int iQuest = GetLocalInt(oPC, "QUEST_ALEATORIA");

    //Solo una Quest cada 50 minutos
    if(GetLocalInt(oPC, "QUEST_CD") > SQLite_GetTimeStamp()) {
        FloatingTextStringOnCreature("<cþ<<>*No puedes descartar otra misión tan rapido*</c>", oPC, FALSE);
        return;
    }

    //QUEST ACTIVAS
    switch (iQuest)
    {
        //Quest
  case 1: RemoveJournalQuestEntry("quest_1", oPC, FALSE); break;
        case 2: RemoveJournalQuestEntry("quest_2", oPC, FALSE); break;;
        case 3: RemoveJournalQuestEntry("quest_3", oPC, FALSE); break;;
        case 4: RemoveJournalQuestEntry("quest_4", oPC, FALSE); break;
        case 5: RemoveJournalQuestEntry("quest_5", oPC, FALSE); break;
        case 6: RemoveJournalQuestEntry("quest_6", oPC, FALSE); break;
        case 7: RemoveJournalQuestEntry("quest_7", oPC, FALSE); break;
        case 8: RemoveJournalQuestEntry("quest_8", oPC, FALSE); break;
        case 9: RemoveJournalQuestEntry("quest_9", oPC, FALSE); break;
        case 10: RemoveJournalQuestEntry("quest_10", oPC, FALSE); break;
        case 11: RemoveJournalQuestEntry("quest_11", oPC, FALSE); break;
        case 12: RemoveJournalQuestEntry("quest_12", oPC, FALSE); break;
        case 13: RemoveJournalQuestEntry("quest_13", oPC, FALSE); break;
        case 14: RemoveJournalQuestEntry("quest_14", oPC, FALSE); break;
    }

  //Solo podemos decartar una vez cada 50 minutos.
  SetLocalInt(oPC, "QUEST_CD", (SQLite_GetTimeStamp() + 3000));
  SendMessageToPC(oPC, "Has renunciado a la misión, podrás solicitar otra pasados 50 minutos.");
  DeleteLocalInt(oPC, "QUEST_ALEATORIA");
}
