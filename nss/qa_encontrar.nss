//////////////////////////////////////////////
// Sistema de Quest Aleatorias              //
// Para niveles 8   Variables 1 - 5         //
// Para niveles 12  Variables 6 - 11        //
// Para niveles 16  Variables 12 - 17       //
//////////////////////////////////////////////

/*PNJ - Reclutador.

- Â¡Buenas Aventurero! Tengo algunas misiones que podrian interesar a alguien como tu y tu grupo... Â¿Que me dices? La paga serÃ¡ buena. (Condicional no tiene mision, variable "QUEST_ALEATORIA" == 0 ) script qa_nomision.nss
    + Por supuesto.
        - Bien, pues dependiendo de tus habilidades, tengo diferentes grados, a mayor grado, mayor recompensa.
            + Dime las de rango bajo.
                - Las misiones de rango bajo estÃ¡n destinadas a Aventureros que estan empezando. Â¿Quereis que os asigne a una de ellas?
                    + Me parece bien, adelante. (Condicional somos menor de nivel 12) script qa_reqrango2.nss
                        - Asi sea. Os darÃ© un documento a cada miembro de tu grupo con toda la informaciÃ³n, cuando la completeis, venir a verme para vuestra recompensa.
                            + Perfecto. (Asignamos la mision con un random)  Script - qa_rango1.nss
                    + No, prefiero mirar otras opciones.
            + Dime las de rango medio.
                - Las misiones de rango medio estÃ¡n destinadas a Aventureros que ya han vivido muchas aventuras. Â¿Quereis que os asigne a una de ellas?
                    + Me parece bien, adelante. (Condicional somos menor de nivel 16 script) qa_reqrango2.nss
                        - Asi sea. Os darÃ© un documento a cada miembro de tu grupo con toda la informaciÃ³n, cuando la completeis, venir a verme para vuestra recompensa.
                            + Perfecto. (Asignamos la mision con un random)  Script - qa_rango2.nss
                    + No, prefiero mirar otras opciones.
            + Dime las de rango alto.
                - Las misiones de rango alto estÃ¡n destinadas a Aventureros expertos, estan suponen un riesgo alto. Â¿Quereis que os asigne a una de ellas?
                    + Me parece bien, adelante. (Condicional somos mayor o de nivel 16) script qa_reqrango3.nss
                        - Asi sea. Os darÃ© un documento a cada miembro de tu grupo con toda la informaciÃ³n, cuando la completeis, venir a verme para vuestra recompensa.
                            + Perfecto. (Asignamos la mision con un random) Script - qa_rango3.nss
                    + No, prefiero mirar otras opciones.
    + No da igual...
        Fin de la conversaciÃ³n

- Â¡Has vuelto! Â¿Ya has completado la misiÃ³n? (Condicional tiene mision activa, variable "QUEST_ALEATORIA" > 0 ) script qa_mision.nss
    + Si. (Condicional tiene mision completa, variable "QUEST_ALEATORIA_COMPLETA" == 1 ) script qa_misionfin.nss
        - Â¡Genial! Aqui tienes tu recompensa. (Asignamos script recompensas) Script qa_recompensa.nss
    + Todavia no.
        Fin de la conversaciÃ³n

//Listado de quest
Variable 1: Quest de Matar al Oso.  script: qa_ondeath.nss
Variable 2: Quest encontrar Arthur Main. script: qa_encontrar.nss
Variable 3: Quest de Matar Jefe Bandido. script: qa_ondeath.nss
Variable 4: script: qa_encontrar.nss
Variable 5: Quest encontrar cargamento perdido. script: qa_encontrar.nss
Variable 6: Quest de Matar al Oso.  script: qa_ondeath.nss
Variable 7: Quest encontrar Arthur Main. script: qa_encontrar.nss
Variable 8: Quest de Matar Jefe Bandido. script: qa_ondeath.nss
Variable 9: Quest encontrar Gato Perdido. script: qa_encontrar.nss
Variable 10: Quest encontrar cargamento perdido. script: qa_encontrar.nss
Variable 11: Quest de Matar al Oso.  script: qa_ondeath.nss
Variable 12: Quest encontrar alijo en la Infraoscuridad. script: qa_encontrar.nss
*/

void main()
{

    object oPC = GetLastUsedBy();
    string sArea = GetTag(GetArea(oPC));
    object oMod = GetModule();
    object oParty;
    object oTarget;
    string sSpawnPoint;
    location lDest;

    int iQuest = GetLocalInt(OBJECT_SELF, "TENGO_QUEST");

    //RECOMPENSAS
    switch (iQuest)
    {
        //Quest Encontrar noble desaparecido
        case 2:
                oPC = GetPCSpeaker();

                switch(d3())
                {
                    case 1: sSpawnPoint = "wp_qa_2_1"; break;
                    case 2: sSpawnPoint = "wp_qa_2_2"; break;
                    case 3: sSpawnPoint = "wp_qa_2_3"; break;
                }
                oTarget = GetWaypointByTag(sSpawnPoint);
                lDest = GetLocation(oTarget);
                oParty = GetFirstFactionMember(oPC, TRUE);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)) || oParty == oPC)
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 2 && GetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA") == 0 )
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 1);
                            SpeakString("¡No quiero volver!");
                            DelayCommand(2.0, SpeakString("¡Ahora soy libre!"));
                            DelayCommand(4.0, SpeakString("*Sale corriendo y se oculta*"));
                            DelayCommand(6.0, ActionJumpToLocation(lDest));
                            FloatingTextStringOnCreature("<c þ >*¡Has completado la quest, informa al reclutador!*</c>", oParty, FALSE);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

        //Quest encontrar soldados desaparecidos.
        case 4:
                oParty = GetFirstFactionMember(oPC, TRUE);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 4 && GetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA") == 0 )
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 1);
                            FloatingTextStringOnCreature("<c þ >*¡Has completado la quest, informa al reclutador!*</c>", oParty, FALSE);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

        //Quest encontrar cargamento perdido
        case 5:
                oParty = GetFirstFactionMember(oPC, TRUE);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 5 && GetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA") == 0 )
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 1);
                            FloatingTextStringOnCreature("<c þ >*¡Has completado la quest, informa al reclutador!*</c>", oParty, FALSE);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

        //Quest encontrar Prisioneros.
        case 7:
                oParty = GetFirstFactionMember(oPC, TRUE);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 7 && GetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA") == 0 )
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 1);
                            FloatingTextStringOnCreature("<c þ >*¡Has completado la quest, informa al reclutador!*</c>", oParty, FALSE);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

        //Quest encontrar cargamento en Imnoscuro
        case 9:
                oParty = GetFirstFactionMember(oPC, TRUE);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 9 && GetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA") == 0 )
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 1);
                            FloatingTextStringOnCreature("<c þ >*¡Has completado la quest, informa al reclutador!*</c>", oParty, FALSE);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

        //Quest encontrar cargamento perdido en Glaxtrox
        case 10:
                oParty = GetFirstFactionMember(oPC, TRUE);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 10 && GetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA") == 0 )
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 1);
                            FloatingTextStringOnCreature("<c þ >*¡Has completado la quest, informa al reclutador!*</c>", oParty, FALSE);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

        //Quest encontrar cargamento perdido en la infraoscuridad
        case 12:
                oParty = GetFirstFactionMember(oPC, TRUE);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 12 && GetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA") == 0 )
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 1);
                            FloatingTextStringOnCreature("<c þ >*¡Has completado la quest, informa al reclutador!*</c>", oParty, FALSE);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

        //Quest Tesoro de la Sierpe Blanca
        case 13:
                oParty = GetFirstFactionMember(oPC, TRUE);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 13 && GetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA") == 0 )
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 1);
                            FloatingTextStringOnCreature("<c þ >*¡Has completado la quest, informa al reclutador!*</c>", oParty, FALSE);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

    }


}
