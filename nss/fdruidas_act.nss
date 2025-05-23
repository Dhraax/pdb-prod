#include "mti_libreria"
#include "nwnx_creature"

void main()
{
  object oPC = GetItemActivator();
  object oItem = GetItemActivated();
  string sTag = GetTag(oItem);

  int iFue = NWNX_Creature_GetRawAbilityScore(oPC, ABILITY_STRENGTH);
  int iDes = NWNX_Creature_GetRawAbilityScore(oPC, ABILITY_DEXTERITY);
  int iCon = NWNX_Creature_GetRawAbilityScore(oPC, ABILITY_CONSTITUTION);

  // NO NOS PODEMOS POLIMORFAR CUANDO YA LO ESTAMOS O ESTAMOS MONTADO A CABALLO
  if(ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0)
  {
      SendMessageToPC(oPC, "<cþ>No puedes polimorfarte cuando estás montado a caballo.</c>");
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

  // Como no estamos transformados, usamos la habilidad
  else
  {
      AssignCommand(oPC, ClearAllActions(TRUE));
      AssignCommand(oPC, ActionStartConversation(oPC, "fdruidas", TRUE, FALSE));
  }
}
