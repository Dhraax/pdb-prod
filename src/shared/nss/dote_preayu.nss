#include "lib_disguise"
//::///////////////////////////////////////////////
//:: DOTE PRESTAR AYUDA
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Dote Prestar Ayuda.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 16 de Junio de 2011
//:://////////////////////////////////////////////

void main()
{
  object oPC = OBJECT_SELF;
  object oObjetivo = GetSpellTargetObject();

  // Solo se ayuda a las criaturas amigas
  if(GetObjectType(oObjetivo) != OBJECT_TYPE_CREATURE || GetIsEnemy(oObjetivo))
  {
      FloatingTextStringOnCreature("<cþ<<>* Sólo puedes prestar ayuda a criaturas amistosas *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // No se puedes prestar ayudo a uno mismo
  if(oObjetivo == oPC)
  {
      FloatingTextStringOnCreature("<cþ<<>* ¡No puedes prestarte ayuda a ti mismo! *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // Imposible ayudar si ya le has ayudado hace poco
  effect eEfecto = GetFirstEffect(oObjetivo);
  while(GetIsEffectValid(eEfecto))
  {
      if(GetEffectSpellId(eEfecto) == 895 || GetEffectSpellId(eEfecto) == 896)
      {
          if(GetEffectCreator(eEfecto) == oPC)
          {
              FloatingTextStringOnCreature("<cþ<<>* Ya le has prestado ayuda recientemente *</c>", OBJECT_SELF, FALSE);
              return;
          }
      }

      eEfecto = GetNextEffect(oObjetivo);
  }

  // Tirada de ataque VS. CA 10
  int iCaracteristica;
  if(GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND))) iCaracteristica = GetAbilityModifier(ABILITY_DEXTERITY);
  else iCaracteristica = GetAbilityModifier(ABILITY_STRENGTH);

  int iDado20 = d20();
  int iAtaque = GetBaseAttackBonus(oPC) + iCaracteristica;
  if(iDado20 + iAtaque >= 10 && iDado20 != 1) DelayCommand(2.0, SendMessageToPC(oPC, "<c›þþ>" + PB_Disguise_GetNameOverride(oPC) + "</c> <cþ–2>realiza una tirada de ataque contra CD 10: *éxito*: ("+IntToString(iDado20)+" + "+IntToString(iAtaque)+" = "+IntToString(iDado20+iAtaque)+")</c>"));
  else
  {
      DelayCommand(2.0, FloatingTextStringOnCreature("<cþ<<>* Fracasas al intentar prestar ayuda *</c>", OBJECT_SELF, FALSE));
      DelayCommand(2.0, SendMessageToPC(oPC, "<c›þþ>" + PB_Disguise_GetNameOverride(oPC) + "</c> <cþ–2>realiza una tirada de ataque contra CD 10: *fallo*: ("+IntToString(iDado20)+" + "+IntToString(iAtaque)+" = "+IntToString(iDado20+iAtaque)+")</c>"));
      return;
  }

  // Aplicacion del bono y mensajes
  int iConjuro = GetSpellId();
  effect eBono;
  string sTipoAyuda;

  if(iConjuro == 895)
  {
      eBono = ExtraordinaryEffect(EffectAttackIncrease(2));
      sTipoAyuda = "Ataque";
  }
  else if(iConjuro == 896)
  {
      eBono = ExtraordinaryEffect(EffectACIncrease(2));
      sTipoAyuda = "Defensa";
  }

  DelayCommand(2.0, FloatingTextStringOnCreature("<c´þd>* ¡Prestas ayuda ["+sTipoAyuda+"] a "+PB_Disguise_GetNameOverride(oObjetivo)+"! *</c>", oPC));
  if(GetIsPC(oObjetivo)) DelayCommand(2.0, FloatingTextStringOnCreature("<c´þd>* ¡"+PB_Disguise_GetNameOverride(oPC)+" te está prestando ayuda ["+sTipoAyuda+"]! *</c>", oObjetivo));
  DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBono, oObjetivo, 9.0));

  // Animacion del lanzador
  AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM16, 4.0, 6.0));
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 5.0);
}
