//::///////////////////////////////////////////////
//:: ESTILO DE COMBATE (del explorador)
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Eleccion de tiro con arco.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 20 de Octubre de 2011
//:://////////////////////////////////////////////

#include "nwnx_creature"
#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();

  GuardarIntPersistente(oPC, "ESTILO_COMBATE", 2);
  NWNX_Creature_RemoveFeat(oPC, 1314);
  NWNX_Creature_AddFeatByLevel(oPC, 1316, 2);
  NWNX_Creature_AddFeatByLevel(oPC, 30, 2);
  SendMessageToPC(oPC, "<cÍþ>Has obtenido las siguientes dotes debido al estilo de combate escogido: Disparo rápido.</c>");
}
