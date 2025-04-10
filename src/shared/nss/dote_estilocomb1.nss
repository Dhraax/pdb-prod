//::///////////////////////////////////////////////
//:: ESTILO DE COMBATE (del explorador)
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Eleccion de combate con dos armas.
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

  GuardarIntPersistente(oPC, "ESTILO_COMBATE", 1);
  NWNX_Creature_RemoveFeat(oPC, 1314);
  NWNX_Creature_AddFeatByLevel(oPC, 1315, 2);
  NWNX_Creature_AddFeatByLevel(oPC, 1, 2);
  NWNX_Creature_AddFeatByLevel(oPC, 41, 2);
  SendMessageToPC(oPC, "<cÍþ>Has obtenido las siguientes dotes debido al estilo de combate escogido: Combate con dos armas y Ambidextrismo.</c>");
}
