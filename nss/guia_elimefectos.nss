void BorrarConjurosPropios(object oPC, object oObjetivo)
{
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(52), oObjetivo);

  effect eEfecto = GetFirstEffect(oObjetivo);
  while(GetIsEffectValid(eEfecto))
  {
     if((GetEffectCreator(eEfecto) == oPC || ((GetAssociateType(oObjetivo) == ASSOCIATE_TYPE_FAMILIAR || GetAssociateType(oObjetivo) == ASSOCIATE_TYPE_ANIMALCOMPANION) && GetEffectCreator(eEfecto) == oObjetivo))  &&
         GetEffectSubType(eEfecto) == SUBTYPE_MAGICAL &&
        (GetEffectType(eEfecto) == EFFECT_TYPE_ABILITY_INCREASE ||
         GetEffectType(eEfecto) == EFFECT_TYPE_AC_INCREASE ||
         GetEffectType(eEfecto) == EFFECT_TYPE_ATTACK_INCREASE ||
         GetEffectType(eEfecto) == EFFECT_TYPE_CONCEALMENT ||
         GetEffectType(eEfecto) == EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE ||
         GetEffectType(eEfecto) == EFFECT_TYPE_DAMAGE_INCREASE ||
         GetEffectType(eEfecto) == EFFECT_TYPE_DAMAGE_REDUCTION ||
         GetEffectType(eEfecto) == EFFECT_TYPE_DAMAGE_RESISTANCE ||
         GetEffectType(eEfecto) == EFFECT_TYPE_ELEMENTALSHIELD ||
         GetEffectType(eEfecto) == EFFECT_TYPE_ETHEREAL ||
         GetEffectType(eEfecto) == EFFECT_TYPE_HASTE ||
         GetEffectType(eEfecto) == EFFECT_TYPE_IMMUNITY ||
         GetEffectType(eEfecto) == EFFECT_TYPE_IMPROVEDINVISIBILITY ||
         GetEffectType(eEfecto) == EFFECT_TYPE_INVISIBILITY ||
         GetEffectType(eEfecto) == EFFECT_TYPE_INVULNERABLE ||
         GetEffectType(eEfecto) == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE ||
         GetEffectType(eEfecto) == EFFECT_TYPE_POLYMORPH ||
         GetEffectType(eEfecto) == EFFECT_TYPE_REGENERATE ||
         GetEffectType(eEfecto) == EFFECT_TYPE_SANCTUARY ||
         GetEffectType(eEfecto) == EFFECT_TYPE_SAVING_THROW_INCREASE ||
         GetEffectType(eEfecto) == EFFECT_TYPE_SEEINVISIBLE ||
         GetEffectType(eEfecto) == EFFECT_TYPE_SKILL_INCREASE ||
         GetEffectType(eEfecto) == EFFECT_TYPE_SPELL_IMMUNITY ||
         GetEffectType(eEfecto) == EFFECT_TYPE_SPELL_RESISTANCE_INCREASE ||
         GetEffectType(eEfecto) == EFFECT_TYPE_SPELLLEVELABSORPTION ||
         GetEffectType(eEfecto) == EFFECT_TYPE_TEMPORARY_HITPOINTS ||
         GetEffectType(eEfecto) == EFFECT_TYPE_TRUESEEING ||
         GetEffectType(eEfecto) == EFFECT_TYPE_TURN_RESISTANCE_INCREASE ||
         GetEffectType(eEfecto) == EFFECT_TYPE_ULTRAVISION ||
         GetEffectType(eEfecto) == EFFECT_TYPE_VISUALEFFECT))
      {
          RemoveEffect(oObjetivo, eEfecto);
      }

      // Parche para que elimine los efectos malignos de cuerpo ferreo
      else if(GetEffectCreator(eEfecto) == oPC && GetEffectSpellId(eEfecto) == 996)
      {
          RemoveEffect(oObjetivo, eEfecto);
      }

      eEfecto = GetNextEffect(oObjetivo);
  }
}

void main()
{
  object oPC = GetPCSpeaker();
  object oObjetivo =  GetLocalObject(oPC, "GUIAPB_OBJETIVO");

  if(GetObjectType(oObjetivo) != OBJECT_TYPE_CREATURE)
  {
      SendMessageToPC(oPC, "<cþ<<>¡El objetivo no era ninguna criatura!</c>");
      return;
  }

  BorrarConjurosPropios(oPC, oObjetivo);
}
