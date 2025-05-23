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


//Inclusion de librerias..
#include "inc_sqlite_time"
#include "pb_tesoro_gold"
#include "pb_tesoro_scroll"
#include "pb_tesoro_potion"
#include "pb_tesoro_ccweap"
#include "pb_tesoro_diweap"
#include "pb_tesoro_munici"
#include "pb_tesoro_magos"
#include "pb_tesoro_escudo"
#include "pb_tesoro_miscel"
#include "pb_tesoro_armor"


void CreamosRecompensaEspecial(object oParty, int nDG)
{
    //Creamos recompensa Especial según la clase y nivel de quest
    if(GetLevelByClass(CLASS_TYPE_BARBARIAN, oParty) > 0 ||
        GetLevelByClass(CLASS_TYPE_FIGHTER, oParty) > 0 ||
        GetLevelByClass(CLASS_TYPE_CLERIC, oParty) > 0 ||
        GetLevelByClass(CLASS_TYPE_PALADIN, oParty) > 0 )
        {
            switch(d3())
            {
                case 1: DelayCommand(2.0,crearArmaCC(oParty, nDG)); break;
                case 2: DelayCommand(2.0,crearEscudo(oParty, nDG)); break;
                case 3: DelayCommand(2.0,crearMiscelaneo(oParty, nDG)); break;
            }
        }

    else if(GetLevelByClass(CLASS_TYPE_SORCERER, oParty) > 0 ||
        GetLevelByClass(CLASS_TYPE_WIZARD, oParty) > 0 ||
        GetLevelByClass(57, oParty) > 0 )
        {
            switch(d3())
            {
                case 1: DelayCommand(2.0,crearBastonMago(oParty, nDG)); break;
                case 2: DelayCommand(2.0,crearCetrosVaras(oParty, nDG)); break;
                case 3: DelayCommand(2.0,crearMiscelaneo(oParty, nDG)); break;
            }
        }
    else if(GetLevelByClass(CLASS_TYPE_RANGER, oParty) > 0 || GetLevelByClass(42, oParty) > 0 )
        {
            switch(d3())
            {
                case 1: DelayCommand(2.0,crearArmaDI(oParty, nDG)); break;
                case 2: DelayCommand(2.0,crearMunicion(oParty, nDG)); break;
                case 3: DelayCommand(2.0,crearMiscelaneo(oParty, nDG)); break;
            }
        }
    else if(GetLevelByClass(CLASS_TYPE_MONK, oParty) > 0 )
        {
        switch(d3())
            {
                case 1: DelayCommand(2.0,crearMiscelaneo(oParty, nDG)); break;
                case 2: DelayCommand(2.0,crearGuantesMonje(oParty, nDG)); break;
                case 3: DelayCommand(2.0,crearArmadura(oParty, nDG)); break;
            }
        }
    else
            {
   switch(d4())
   {
                case 1: DelayCommand(2.0,crearArmaCC(oParty, nDG)); break;
                case 2: DelayCommand(2.0,crearArmaDI(oParty, nDG)); break ;
                case 3: DelayCommand(2.0,crearArmadura(oParty, nDG)); break;
                case 4: DelayCommand(2.0,crearMiscelaneo(oParty, nDG)); break;
   }
            }

}

void main()
{

    object oPC = GetPCSpeaker();
    string sArea = GetTag(GetArea(oPC));
    object oMod = GetModule();
    object oItem;
    object oParty;
    int nDG;

    int iQuest = GetLocalInt(oPC, "QUEST_ALEATORIA");

    //RECOMPENSAS
    switch (iQuest)
    {
        //Quest traer la cabeza del Oso
        case 1:
                oParty = GetFirstFactionMember(oPC, TRUE);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 1)
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA", 0);
                            SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 0);
                            SetLocalInt(oPC, "QUEST_CD", (SQLite_GetTimeStamp() + 3000));
                            oItem = GetItemPossessedBy(oParty, "quest_1");
                            switch(d2())
                            {
                                case 1: nDG = 12; break;
                                case 2: nDG = 16; break;
                            }
                            CreamosRecompensaEspecial(oParty, nDG);
                            DestroyObject(oItem, 0.5);
                            RemoveJournalQuestEntry("quest_1", oParty, FALSE);
                            GiveXPToCreature(oParty, 500);
                            GiveGoldToCreature(oParty, 2000);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

        //Quest Encontrar al Noble
        case 2:
                oParty = GetFirstFactionMember(oPC, TRUE);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 2)
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA", 0);
                            SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 0);
                            SetLocalInt(oPC, "QUEST_CD", (SQLite_GetTimeStamp() + 3000));
                            oItem = GetItemPossessedBy(oParty, "quest_2");
                            switch(d2())
                            {
                                case 1: nDG = 12; break;
                                case 2: nDG = 16; break;
                            }
                            CreamosRecompensaEspecial(oParty, nDG);
                            DestroyObject(oItem, 0.5);
                            RemoveJournalQuestEntry("quest_2", oParty, FALSE);
                            GiveXPToCreature(oParty, 500);
                            GiveGoldToCreature(oParty, 2000);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

        //Quest de Matar Jefe Reptiliano (Matar a un boss reptil de nivel 1)
        case 3:
                oParty = GetFirstFactionMember(oPC, TRUE);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 3)
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA", 0);
                            SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 0);
                            SetLocalInt(oPC, "QUEST_CD", (SQLite_GetTimeStamp() + 3000));
                            oItem = GetItemPossessedBy(oParty, "quest_3");
                            switch(d2())
                            {
                                case 1: nDG = 12; break;
                                case 2: nDG = 16; break;
                            }
                            CreamosRecompensaEspecial(oParty, nDG);
                            DestroyObject(oItem, 0.5);
                            RemoveJournalQuestEntry("quest_3", oParty, FALSE);
                            GiveXPToCreature(oParty, 500);
                            GiveGoldToCreature(oParty, 2000);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

        //Quest encontrar soldados muertos
        case 4:
                oParty = GetFirstFactionMember(oPC, TRUE);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 4)
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA", 0);
                            SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 0);
                            SetLocalInt(oPC, "QUEST_CD", (SQLite_GetTimeStamp() + 3000));
                            oItem = GetItemPossessedBy(oParty, "quest_4");
                            switch(d2())
                            {
                                case 1: nDG = 12; break;
                                case 2: nDG = 16; break;
                            }
                            CreamosRecompensaEspecial(oParty, nDG);
                            DestroyObject(oItem, 0.5);
                            RemoveJournalQuestEntry("quest_4", oParty, FALSE);
                            GiveXPToCreature(oParty, 500);
                            GiveGoldToCreature(oParty, 2000);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

        //Quest encontrar cargamento perdido.
        case 5:
                oParty = GetFirstFactionMember(oPC, TRUE);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 5)
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA", 0);
                            SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 0);
                            SetLocalInt(oPC, "QUEST_CD", (SQLite_GetTimeStamp() + 3000));
                            switch(d2())
                            {
                                case 1: nDG = 12; break;
                                case 2: nDG = 16; break;
                            }
                            CreamosRecompensaEspecial(oParty, nDG);
                            oItem = GetItemPossessedBy(oParty, "quest_5");
                            DestroyObject(oItem, 0.5);
                            RemoveJournalQuestEntry("quest_5", oParty, FALSE);
                            GiveXPToCreature(oParty, 500);
                            GiveGoldToCreature(oParty, 2000);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

        //Quest de Matar Bestia Magica. (Matar a un boss bestia magica de nivel 2)
        case 6:
                oParty = GetFirstFactionMember(oPC, TRUE);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 6)
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA", 0);
                            SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 0);
                            SetLocalInt(oPC, "QUEST_CD", (SQLite_GetTimeStamp() + 3000));
                            oItem = GetItemPossessedBy(oParty, "quest_6");
                            switch(d2())
                            {
                                case 1: nDG = 16; break;
                                case 2: nDG = 20; break;
                            }
                            CreamosRecompensaEspecial(oParty, nDG);
                            DestroyObject(oItem, 0.5);
                            RemoveJournalQuestEntry("quest_6", oParty, FALSE);
                            GiveXPToCreature(oParty, 1000);
                            GiveGoldToCreature(oParty, 5000);
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
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 7)
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA", 0);
                            SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 0);
                            SetLocalInt(oPC, "QUEST_CD", (SQLite_GetTimeStamp() + 3000));
                            oItem = GetItemPossessedBy(oParty, "quest_7");
                        switch(d2())
                            {
                                case 1: nDG = 16; break;
                                case 2: nDG = 20; break;
                            }
                            CreamosRecompensaEspecial(oParty, nDG);
                            DestroyObject(oItem, 0.5);
                            RemoveJournalQuestEntry("quest_7", oParty, FALSE);
                            GiveXPToCreature(oParty, 1000);
                            GiveGoldToCreature(oParty, 5000);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

        //Quest de Matar Jefe Bandido. (Matar a un boss humano de nivel 2)
        case 8:
                oParty = GetFirstFactionMember(oPC, TRUE);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 8)
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA", 0);
                            SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 0);
                            SetLocalInt(oPC, "QUEST_CD", (SQLite_GetTimeStamp() + 3000));
                            oItem = GetItemPossessedBy(oParty, "quest_8");
                            switch(d2())
                            {
                                case 1: nDG = 16; break;
                                case 2: nDG = 20; break;
                            }
                            CreamosRecompensaEspecial(oParty, nDG);
                            DestroyObject(oItem, 0.5);
                            RemoveJournalQuestEntry("quest_8", oParty, FALSE);
                            GiveXPToCreature(oParty, 1000);
                            GiveGoldToCreature(oParty, 5000);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

        //Quest encontrar cargamento en Imnoscuro.
        case 9:
                oParty = GetFirstFactionMember(oPC, TRUE);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 9)
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA", 0);
                            SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 0);
                            SetLocalInt(oPC, "QUEST_CD", (SQLite_GetTimeStamp() + 3000));
                            oItem = GetItemPossessedBy(oParty, "quest_9");
                            switch(d2())
                            {
                                case 1: nDG = 16; break;
                                case 2: nDG = 20; break;
                            }
                            CreamosRecompensaEspecial(oParty, nDG);
                            DestroyObject(oItem, 0.5);
                            RemoveJournalQuestEntry("quest_9", oParty, FALSE);
                            GiveXPToCreature(oParty, 1000);
                            GiveGoldToCreature(oParty, 5000);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

        //Quest encontrar cargamento perdido en Glaxtroxx.
        case 10:
                oParty = GetFirstFactionMember(oPC, TRUE);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 10)
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA", 0);
                            SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 0);
                            SetLocalInt(oPC, "QUEST_CD", (SQLite_GetTimeStamp() + 3000));
                            oItem = GetItemPossessedBy(oParty, "quest_10");
                        switch(d2())
                            {
                                case 1: nDG = 16; break;
                                case 2: nDG = 20; break;;
                            }
                            CreamosRecompensaEspecial(oParty, nDG);
                            DestroyObject(oItem, 0.5);
                            RemoveJournalQuestEntry("quest_10", oParty, FALSE);
                            GiveXPToCreature(oParty, 1000);
                            GiveGoldToCreature(oParty, 5000);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

        //Quest de criatura de la infraoscuridad.  (Matar a un boss de la infra de nivel 3)
        case 11:
                oParty = GetFirstFactionMember(oPC, TRUE);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 11)
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA", 0);
                            SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 0);
                            SetLocalInt(oPC, "QUEST_CD", (SQLite_GetTimeStamp() + 3000));
                            oItem = GetItemPossessedBy(oParty, "quest_11");
                            switch(d2())
                            {
                                case 1: nDG = 30; break;
                                case 2: nDG = 40; break;
                            }
                            CreamosRecompensaEspecial(oParty, nDG);
                            DestroyObject(oItem, 0.5);
                            RemoveJournalQuestEntry("quest_11", oParty, FALSE);
                            GiveXPToCreature(oParty, 2500);
                            GiveGoldToCreature(oParty, 10000);
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
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 12)
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA", 0);
                            SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 0);
                            SetLocalInt(oPC, "QUEST_CD", (SQLite_GetTimeStamp() + 3000));
                            oItem = GetItemPossessedBy(oParty, "quest_12");
                            switch(d2())
                            {
                                case 1: nDG = 30; break;
                                case 2: nDG = 40; break;;
                            }
                            CreamosRecompensaEspecial(oParty, nDG);
                            DestroyObject(oItem, 0.5);
                            RemoveJournalQuestEntry("quest_12", oParty, FALSE);
                            GiveXPToCreature(oParty, 2500);
                            GiveGoldToCreature(oParty, 10000);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

        //Quest Matar Sierpe Blanca
        case 13:
                oParty = GetFirstFactionMember(oPC, TRUE);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 13)
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA", 0);
                            SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 0);
                            SetLocalInt(oPC, "QUEST_CD", (SQLite_GetTimeStamp() + 3000));
                            oItem = GetItemPossessedBy(oParty, "quest_13");
                            switch(d2())
                            {
                                case 1: nDG = 30; break;
                                case 2: nDG = 40; break;
                            }
                            CreamosRecompensaEspecial(oParty, nDG);
                            DestroyObject(oItem, 0.5);
                            RemoveJournalQuestEntry("quest_13", oParty, FALSE);
                            GiveXPToCreature(oParty, 2500);
                            GiveGoldToCreature(oParty, 10000);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;

        //Quest Matar LordMimo
        case 14:
                oParty = GetFirstFactionMember(oPC, TRUE);
                while(GetIsObjectValid(oParty) && GetIsPC(oParty))
                {
                    if(sArea ==  GetTag(GetArea(oParty)))
                        {
                            if(GetLocalInt(oParty, "QUEST_ALEATORIA") == 14)
                            {
                            SetLocalInt(oParty, "QUEST_ALEATORIA", 0);
                            SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 0);
                            SetLocalInt(oPC, "QUEST_CD", (SQLite_GetTimeStamp() + 3000));
                            oItem = GetItemPossessedBy(oParty, "quest_14");
                            switch(d2())
                            {
                                case 1: nDG = 30; break;
                                case 2: nDG = 40; break;
                            }
                            CreamosRecompensaEspecial(oParty, nDG);
                            DestroyObject(oItem, 0.5);
                            RemoveJournalQuestEntry("quest_14", oParty, FALSE);
                            GiveXPToCreature(oParty, 2500);
                            GiveGoldToCreature(oParty, 10000);
                            }
                        }
                    oParty = GetNextFactionMember(oPC, TRUE);
                }
                break;
    }
}
