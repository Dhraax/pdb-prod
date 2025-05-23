//::///////////////////////////////////////////////
//:: DOTE FORMA SALVAJE MAYOR / HUMANOIDE AMPLIADA
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Forma salvaje Mayor / Humanoide ampliada de Cambiantes.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 26 de Octubre de 2011
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "mti_libreria"
#include "nwnx_creature"
#include "lib_disguise"

void main()
{
  object oPC = OBJECT_SELF;

  // No en el mar
  string sNombreArea = GetName(GetArea(oPC));
  if(sNombreArea == "Mar de las Espadas"|| sNombreArea == "Mar Impenetrable")
  {
      FloatingTextStringOnCreature("<cþ<<>¡No puedes transformar tu barco!</c>", OBJECT_SELF, FALSE);
      return;
  }

  // No polimorfado
  if(GetHasEffect(EFFECT_TYPE_POLYMORPH))
  {
      FloatingTextStringOnCreature("<cþ<<>* Esta aptitud no se puede activar polimorfado *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // No funciona montado en montura
  if(ObtenerIntPersistente(OBJECT_SELF, "CAB_MONTADO") > 0)
  {
      FloatingTextStringOnCreature("<cþ<<>* Esta aptitud no se puede activar montado en montura *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // Nos destransformamos, estamos atentos si somos licantropos para eliminar sus bonos
  if(ObtenerIntPersistente(oPC, "APA_CAMBIADA") == TRUE)
  {
      // Efectos visuales
      effect eSuspiro = EffectVisualEffect(36);`
      effect eLuz = EffectVisualEffect(146);
      ApplyEffectToObject(DURATION_TYPE_INSTANT,eSuspiro , oPC);
      ApplyEffectToObject(DURATION_TYPE_INSTANT,eLuz , oPC);

      // Cambiamos las apariencias y alas
      SetCreatureAppearanceType(oPC, ObtenerIntPersistente(oPC, "APA_MEMORIZADA"));
      GuardarIntPersistente(oPC, "APA_CAMBIADA", FALSE);
      GuardarIntPersistente(oPC, "APA_MEMORIZADA", FALSE);
      SetLocalInt(oPC, "POLY_ON", 0);

      if(ObtenerIntPersistente(oPC, "ALAS_CAMBIADAS") == TRUE)
      {
          SetCreatureWingType(ObtenerIntPersistente(oPC, "ALAS_MEMORIZADAS"), oPC);
          GuardarIntPersistente(oPC, "ALAS_CAMBIADAS", FALSE);
          GuardarIntPersistente(oPC, "ALAS_MEMORIZADAS", FALSE);
      }

      // Si somos licantropos... ajustes de ficha
      if(ObtenerIntPersistente(oPC, "ESTADOLICANTROPIA") >= 1)
      {
          GuardarIntPersistente(oPC, "ESTADOLICANTROPIA", 0);

          // Dotes generales que se pierden
          if(ObtenerIntPersistente(oPC, "DOTEDERRIBO") == FALSE) NWNX_Creature_RemoveFeat(oPC, FEAT_KNOCKDOWN);
          if(ObtenerIntPersistente(oPC, "DOTEINICIATIVA") == FALSE) NWNX_Creature_RemoveFeat(oPC, FEAT_IMPROVED_INITIATIVE);
          if(ObtenerIntPersistente(oPC, "DOTEIMPACTOSAM") == FALSE) NWNX_Creature_RemoveFeat(oPC, FEAT_IMPROVED_UNARMED_STRIKE);

          // LICANTROPOS
          int iFue = NWNX_Creature_GetRawAbilityScore(oPC, ABILITY_STRENGTH);
          int iDes = NWNX_Creature_GetRawAbilityScore(oPC, ABILITY_DEXTERITY);
          int iCon = NWNX_Creature_GetRawAbilityScore(oPC, ABILITY_CONSTITUTION);
          if(GetStringLowerCase(GetSubRace(oPC)) == "licantropo")
          {
              if(ObtenerStringPersistente(oPC, "TIPOLICANTROPO") == "gato")
              {
                  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_STRENGTH, iFue + 4);
                  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDes - 6);
                  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCon - 2);
              }
              if(ObtenerStringPersistente(oPC, "TIPOLICANTROPO") == "jabali")
              {
                  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_STRENGTH, iFue - 4);
                  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCon - 6);
              }
              if(ObtenerStringPersistente(oPC, "TIPOLICANTROPO") == "lobo")
              {
                  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_STRENGTH, iFue - 2);
                  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDes - 4);
                  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCon - 4);
              }
              if(ObtenerStringPersistente(oPC, "TIPOLICANTROPO") == "murcielago")
              {
                  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_STRENGTH, iFue - 6);
                  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDes - 12);
                  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCon - 6);
              }
              if(ObtenerStringPersistente(oPC, "TIPOLICANTROPO") == "oso")
              {
                  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_STRENGTH, iFue - 16);
                  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDes - 2);
                  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCon - 8);
              }
              if(ObtenerStringPersistente(oPC, "TIPOLICANTROPO") == "rata")
              {
                  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDes - 6);
                  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCon - 2);
              }
              if(ObtenerStringPersistente(oPC, "TIPOLICANTROPO") == "tigre")
              {
                  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_STRENGTH, iFue - 12);
                  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDes - 4);
                  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCon - 6);
              }
          }

          // LYTHARIS
          else if(GetStringLowerCase(GetSubRace(oPC)) == "lythari")
          {
              NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_STRENGTH, iFue - 2);
              NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDes - 4);
              NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCon - 6);
          }

          ReaplicarEfectosPB(oPC,TRUE);
      }
  }
  else
  {
      // Si no te quedan usos de Forma Salvaje mayor o Humanoide, nanay
      if(GetHasFeat(FEAT_GREATER_WILDSHAPE_1) == FALSE &&
         GetHasFeat(FEAT_GREATER_WILDSHAPE_2) == FALSE &&
         GetHasFeat(FEAT_GREATER_WILDSHAPE_3) == FALSE &&
         GetHasFeat(FEAT_GREATER_WILDSHAPE_4) == FALSE &&
         GetHasFeat(FEAT_HUMANOID_SHAPE) == FALSE)
      {
          FloatingTextStringOnCreature("<cþ<<>¡No te quedan usos de Forma Salvaje mayor / Forma Humanoide!</c>", OBJECT_SELF, FALSE);
          return;
      }

      // Se abre la conversacion
      AssignCommand(oPC, ClearAllActions(TRUE));
      SetLocalInt(oPC, "TIPO_POLIMORFACION", 3);
      AssignCommand(oPC, ActionStartConversation(oPC, "dote_poliformas", TRUE, FALSE));
  }
}
