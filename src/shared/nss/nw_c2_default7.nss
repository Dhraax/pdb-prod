    //:://////////////////////////////////////////////////
//:: NW_C2_DEFAULT7
/*
  Default OnDeath event handler for NPCs.

  Adjusts killer's alignment if appropriate and
  alerts allies to our death.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/22/2002
//:: modified by: Dhraax
//:://////////////////////////////////////////////////

#include "x2_inc_compon"
#include "x0_i0_spawncond"
#include "corpse_functions"
#include "mti_libreria"
#include "sys_quest_death"

void CreateCreatureQuest(string sCreature, location lDest)
{
    if(GetObjectByTag(sCreature) == OBJECT_INVALID ) CreateObject(OBJECT_TYPE_CREATURE, sCreature, lDest, FALSE);
}

void main()
{
    object oKiller = GetLastKiller();
    object oParty;
    string sSpawnPoint;
    object oTarget;
    location lDest;

    // SISTEMA DE SEGURIDAD, POR SI LA CRIATURA SE MATA A SI MISMA
    if(oKiller == OBJECT_SELF) return;

    // EXPERIENCIA
    ExecuteScript("pwfxp",OBJECT_SELF);

    // REG. DE TESOROS EN GRUPO

    //Hay un nivel que es nivel 40 o superior, esos son los titánicos: Ahí pondría que 16 (incluido) para arriba.
    //Los de nivel 30 a 39, esos son los legendarios: Ahí pondría nivel 13 para arriba
    //Los de nivel 21 a 29, esos son los poderosos: Ahí pondría de nivel 12 hasta 20 (incluido)
    //Los de nivel 16 a 20 (incluido), esos son los azul claros: Ahí pondrái de nivel 12 (incluido) para abajo.
    //Los grises que creo que no hay ningún bicho en el serv: Ahí pondría de nivel 8 para abajo
    if(GetLocalInt(OBJECT_SELF, "JEFAZO") > 0)
    {
          object oTesoro;
          int nDG = GetHitDice(OBJECT_SELF);
          int iCalidad;
          int nContador = GetLocalInt(oKiller, "TESOROGRUPO");
          string sArea = GetTag(GetArea(oKiller));


        //Segun el nivel del boss generamos mejor loot
            if(nDG >= 22)               iCalidad = 5; // RANGO 1: Niveles 1-9
       else if(nDG >= 18 && nDG <= 21)  iCalidad = 4; // RANGO 2: Niveles 15-19
       else if(nDG >= 14 && nDG <= 17)  iCalidad = 3; // RANGO 3: Niveles 20-29
       else if(nDG >= 10 && nDG <= 13)  iCalidad = 2; // RANGO 4: Niveles 30-39
       else if(nDG <= 9)               iCalidad = 1; // RANGO 5: Niveles >= 40

              //Chequeamos que el grupo este en el mismo area y tengan el nivel minimo segun el DG del boss
              object oParty = GetFirstFactionMember(oKiller);
                 while (GetIsObjectValid(oParty) && GetIsPC(oParty))
             {
                string pArea = GetTag(GetArea(oParty));
                            if(sArea == pArea)
                {
                               if(nDG >= 22 && GetHitDice(oParty) >= 16) nContador = nContador +1;
                               else if(nDG >= 18 && nDG < 21 && GetHitDice(oParty) >= 13) nContador = nContador +1;
                               else if(nDG >= 14 && nDG < 17 && GetHitDice(oParty) >= 12) nContador = nContador +1;
                               else if(nDG >= 10 && nDG < 13 && GetHitDice(oParty) <= 12) nContador = nContador +1;
                               else if(nDG < 9 && GetHitDice(oParty) <= 8) nContador = nContador +1;
                   }
                        oParty = GetNextFactionMember(oKiller);
                            }

          //Generamos tesoro segun seamos 3 o mas
             oTesoro = CreateObject(OBJECT_TYPE_PLACEABLE, "cofreboss", GetLocation(OBJECT_SELF));
             DelayCommand(0.3, SetLocalInt(oTesoro, "TIPOTESORO", iCalidad));
             DelayCommand(0.3, SetLocalInt(oTesoro, "TESOROBOSS", 1));
             SetName(oTesoro, "Cofre de "+GetName(OBJECT_SELF));
             float fFacing = GetFacing(oKiller);
             AssignCommand(oTesoro, SetFacing(fFacing));

          //Si eres nivel 16 o mas y el boss 20 o menos no hay recompensa.
          if(GetHitDice(OBJECT_SELF) <= 13 && GetHitDice(oKiller) >= 16) {
            DestroyObject(oTesoro, 0.2);
            SendMessageToPC(oKiller, "Tienes demasiado nivel para obtener recompensas de esta criatura, busca nuevos desafios.");
            }
          if(nContador >= 3) {
             oTesoro = CreateObject(OBJECT_TYPE_PLACEABLE, "cofreboss", GetLocation(OBJECT_SELF));
             DelayCommand(0.3, SetLocalInt(oTesoro, "TIPOTESORO", iCalidad));
             DelayCommand(0.3, SetLocalInt(oTesoro, "TESOROBOSS", 1));
             SetName(oTesoro, "Cofre de "+GetName(OBJECT_SELF));
             AssignCommand(oTesoro, SetFacing(fFacing));
                }
          if(nContador >= 6) {
             oTesoro = CreateObject(OBJECT_TYPE_PLACEABLE, "cofreboss", GetLocation(OBJECT_SELF));
             DelayCommand(0.3, SetLocalInt(oTesoro, "TIPOTESORO", iCalidad));
             DelayCommand(0.3, SetLocalInt(oTesoro, "TESOROBOSS", 1));
             SetName(oTesoro, "Cofre de "+GetName(OBJECT_SELF));
             AssignCommand(oTesoro, SetFacing(fFacing));
                }
          if(nContador >= 9) {
             oTesoro = CreateObject(OBJECT_TYPE_PLACEABLE, "cofreboss", GetLocation(OBJECT_SELF));
             DelayCommand(0.3, SetLocalInt(oTesoro, "TIPOTESORO", iCalidad));
             DelayCommand(0.3, SetLocalInt(oTesoro, "TESOROBOSS", 1));
             SetName(oTesoro, "Cofre de "+GetName(OBJECT_SELF));
             AssignCommand(oTesoro, SetFacing(fFacing));
                }

    DeleteLocalInt(oKiller, "TESOROGRUPO");
    }

    // Call to allies to let them know we're dead
    SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);

    //Shout Attack my target, only works with the On Spawn In setup
    SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);

    // NOTE: the OnDeath user-defined event does not
    // trigger reliably and should probably be removed
    if(GetSpawnInCondition(NW_FLAG_DEATH_EVENT))
    {
         SignalEvent(OBJECT_SELF, EventUserDefined(1007));
    }

    // CADAVERES USABLES AL MORIR
    corpse_InitializeCorpse(OBJECT_SELF);



    // La piel de lobo invernal se queda: la cuenta la quest de Salvya
    // (qui_questsalvya3 y 4). Las de rata y oso se retiran: ahora las da
    // el desollado del CNR, y solo el.
    // Pieles de Lobo Invernal
    if(GetTag(OBJECT_SELF) == "NW_WOLFWINT" && !GetIsObjectValid(GetItemPossessedBy(OBJECT_SELF, "pieldeloboinvern")))
    CreateItemOnObject("pieldeloboinvern", OBJECT_SELF);

    //Chequeamos que el grupo este en el mismo area y tengan la variable correspondiente.
     oParty = GetFirstFactionMember(oKiller);
     int iQuest = GetLocalInt(oParty, "QUEST_ALEATORIA");
     while (GetIsObjectValid(oParty) && GetIsPC(oParty))
    {
        string sArea = GetTag(GetArea(oParty));
        string pArea = GetTag(GetArea(oKiller));
        if(sArea == pArea || oParty == oKiller)
        {
            if(GetLocalInt(OBJECT_SELF, "TENGO_QUEST") == 14 && GetLocalInt(oParty, "QUEST_ALEATORIA") == 14 && GetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA") == 0)
            {
                SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 1);
                FloatingTextStringOnCreature("<c þ >*¡Has completado la quest, informa al reclutador!*</c>", oParty, FALSE);
            }
            else if(GetLocalInt(OBJECT_SELF, "TENGO_QUEST") == 13 && GetLocalInt(oParty, "QUEST_ALEATORIA") == 13 && GetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA") == 0)
            {
                SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 1);
                FloatingTextStringOnCreature("<c þ >*¡Has completado la quest, informa al reclutador!*</c>", oParty, FALSE);
            }
            else if(GetLocalInt(OBJECT_SELF, "TENGO_QUEST") == 11 && GetLocalInt(oParty, "QUEST_ALEATORIA") == 11 && GetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA") == 0)
            {
                SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 1);
                switch(d3())
                {
                    case 1: sSpawnPoint = "wp_qa_11_1"; break;
                    case 2: sSpawnPoint = "wp_qa_11_2"; break;
                    case 3: sSpawnPoint = "wp_qa_11_3"; break;
                }
                oTarget = GetWaypointByTag(sSpawnPoint);
                lDest = GetLocation(oTarget);
                DelayCommand(300.0, CreateCreatureQuest("qa_quest_11", lDest));
                FloatingTextStringOnCreature("<c þ >*¡Has completado la quest, informa al reclutador!*</c>", oParty, FALSE);
            }
            else if(GetLocalInt(OBJECT_SELF, "TENGO_QUEST") == 8 && GetLocalInt(oParty, "QUEST_ALEATORIA") == 8 && GetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA") == 0)
            {
                SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 1);
                FloatingTextStringOnCreature("<c þ >*¡Has completado la quest, informa al reclutador!*</c>", oParty, FALSE);
            }
            else if(GetLocalInt(OBJECT_SELF, "TENGO_QUEST") == 6 && GetLocalInt(oParty, "QUEST_ALEATORIA") == 6 && GetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA") == 0)
            {
                SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 1);
                FloatingTextStringOnCreature("<c þ >*¡Has completado la quest, informa al reclutador!*</c>", oParty, FALSE);
            }
            else if(GetLocalInt(OBJECT_SELF, "TENGO_QUEST") == 3 && GetLocalInt(oParty, "QUEST_ALEATORIA") == 3 && GetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA") == 0)
            {
                SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 1);
                FloatingTextStringOnCreature("<c þ >*¡Has completado la quest, informa al reclutador!*</c>", oParty, FALSE);
            }
            else if(GetLocalInt(OBJECT_SELF, "TENGO_QUEST") == 1 && GetLocalInt(oParty, "QUEST_ALEATORIA") == 1 && GetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA") == 0)
            {
                SetLocalInt(oParty, "QUEST_ALEATORIA_COMPLETA", 1);
                switch(d3())
                {
                    case 1: sSpawnPoint = "wp_qa_1_1"; break;
                    case 2: sSpawnPoint = "wp_qa_1_2"; break;
                    case 3: sSpawnPoint = "wp_qa_1_3"; break;
                }
                oTarget = GetWaypointByTag(sSpawnPoint);
                lDest = GetLocation(oTarget);
                DelayCommand(300.0, CreateCreatureQuest("qa_quest_1", lDest));
                FloatingTextStringOnCreature("<c þ >*¡Has completado la quest, informa al reclutador!*</c>", oParty, FALSE);
            }
            else if(GetLocalInt(OBJECT_SELF, "QUEST_VIUDA") == 1 && ObtenerIntPersistente(oParty, "quest_viuda") == 1)
                {
                 CreateItemOnObject("paquete_viuda", OBJECT_SELF);
                 FloatingTextStringOnCreature("<c þ >*¡Ves una extraña caja en el cadaver de la criatura!*</c>", oParty, FALSE);
                }
        }
        oParty = GetNextFactionMember(oKiller);
    }


    // EVITAR DOBLE MENSAJE DE EXPERIENCIA
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetMaxHitPoints()), OBJECT_SELF);

    QuestDeath (oKiller, OBJECT_SELF);
}
