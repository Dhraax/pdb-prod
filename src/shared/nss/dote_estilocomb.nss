//::///////////////////////////////////////////////
//:: ESTILO DE COMBATE (del explorador)
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Este escript regula las dotes que se quitan o se anyaden segun el estilo
    de combate escogido por el explorador. Hay que poner tambien una comprobacion
    por si se baja de nivel y se tienen que perder las dotes (por ejemplo, al
    salir de la Bolsa Planar).

    Tiro con Arco:
    A nivel 2, Disparo rapido.
    A nivel 6, Disparos multiples.
    A nivel 11, Disparos multiples mejorado.

    Combate con dos armas:
    A nivel 2, Combate con dos armas (antigua Blandir dos armas).
    A nivel 6, Combate con dos armas mejorado.
    A nivel 11, Combate con dos armas mayor.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 20 de Octubre de 2011
//:://////////////////////////////////////////////

#include "nwnx_creature"
#include "mti_libreria"

void main()
{
  object oPC = OBJECT_SELF;
  string sMensaje;

  // NIVEL 11, MAESTRIA CON EL ESTILO DE COMBATE
  if(GetHasFeat(1322) || GetHasFeat(1323)) SendMessageToPC(oPC, "<cÍþ>Has alcanzado la maestría con el estilo de combate escogido y ya no aprenderás más dotes. Consulta la descripción de Maestría con el estilo de combate para más información.</c>");

  else if(GetHasFeat(1321))
  {
      // Quitar dotes, dar dotes
      if(ObtenerIntPersistente(oPC, "ESTILO_COMBATE") == 2) // Dote 1320
      {
          NWNX_Creature_RemoveFeat(oPC, 1320);
          NWNX_Creature_AddFeatByLevel(oPC, 1323, 11);
          NWNX_Creature_AddFeatByLevel(oPC, 1329, 11);
          sMensaje = "Disparos múltiples mejorado";
      }
      else if(ObtenerIntPersistente(oPC, "ESTILO_COMBATE") == 1) // Dote 1318
      {
          NWNX_Creature_RemoveFeat(oPC, 1318);
          NWNX_Creature_AddFeatByLevel(oPC, 1322, 11);
          NWNX_Creature_AddFeatByLevel(oPC, 1202, 11);
          sMensaje = "Combate con dos armas mayor";
      }

      NWNX_Creature_RemoveFeat(oPC, 1321);
      AssignCommand(oPC, ClearAllActions(TRUE));
      SendMessageToPC(oPC, "<cÍþ>Has obtenido la siguiente dote debido a la Maestria con el estilo de combate escogido: "+sMensaje+".</c>");
  }

  // NIVEL 6, ESTILO DE COMBATE MEJORADO
  else if(GetHasFeat(1318) || GetHasFeat(1320)) SendMessageToPC(oPC, "<cÍþ>Ya has obtenido las dotes gratuitas del estilo de combate mejorado escogido y no aprenderás más hasta el 11º nivel de explorador. Consulta la descripción de Estilo de combate mejorado para más información.</c>");

  else if(GetHasFeat(1317))
  {
      // Quitar dotes, dar dotes
      if(ObtenerIntPersistente(oPC, "ESTILO_COMBATE") == 2) // Dote 1316
      {
          NWNX_Creature_RemoveFeat(oPC, 1316);
          NWNX_Creature_AddFeatByLevel(oPC, 1320, 6);
          NWNX_Creature_AddFeatByLevel(oPC, 1328, 6);
          sMensaje = "Disparos múltiples";
      }
      else if(ObtenerIntPersistente(oPC, "ESTILO_COMBATE") == 1) // Dote 1315
      {
          NWNX_Creature_RemoveFeat(oPC, 1315);
          NWNX_Creature_AddFeatByLevel(oPC, 1318, 6);
          NWNX_Creature_AddFeatByLevel(oPC, 20, 6);
          sMensaje = "Combate con dos armas mejorado";
      }

      NWNX_Creature_RemoveFeat(oPC, 1317);
      SendMessageToPC(oPC, "<cÍþ>Has obtenido la siguiente dote debido al estilo de combate mejorado escogido: "+sMensaje+".</c>");
  }

  // NIVEL 2, ESTILO DE COMBATE
  else if(GetHasFeat(1315) || GetHasFeat(1316)) SendMessageToPC(oPC, "<cÍþ>Ya has obtenido las dotes gratuitas del estilo de combate escogido y no aprenderás más hasta el 6º nivel de explorador. Consulta la descripción de Estilo de combate para más información.</c>");

  else if(GetHasFeat(1314))
  {
      // Conversacion inicial de eleccion de estilo. Dotes que se dan:
      AssignCommand(oPC, ClearAllActions(TRUE));
      AssignCommand(oPC, ActionStartConversation(oPC, "dote_estilocomb", TRUE, FALSE));
  }
}
