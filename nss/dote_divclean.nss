//::///////////////////////////////////////////////
//:: Limpieza divina
//:://////////////////////////////////////////////
/*
    Con cada uso gastado de expulsar muertos el personaje y todos sus aliados
    en un radio de 60 pies reciben un +2 a las pruebas de fortaleza.
*/
//:://////////////////////////////////////////////
//:: Created By: Idelish y modificado por Monti
//:: Created On: Feb 25, 2010
//:://////////////////////////////////////////////

#include "x0_i0_spells"

void main()
{
  // Hay que tener usos de Expulsar o reprender muertos vivientes
  if(!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
  {
      SendMessageToPC(OBJECT_SELF, "<cþ<<>" + GetStringByStrRef(40550) + "</c>");
      return;
  }

  // Se restan usos de Expulsar
  DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);

  //Se declaran las variables principales
  float fDelay;
  int nCharismaBonus = GetAbilityModifier(ABILITY_CHARISMA);
  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
  effect eSave2 = EffectSavingThrowIncrease(SAVING_THROW_FORT, 2, SAVING_THROW_TYPE_SPELL);
  effect eSave = EffectSavingThrowIncrease(SAVING_THROW_FORT, 2, SAVING_THROW_TYPE_POISON);
  effect eLink = EffectLinkEffects(eSave2, eSave);
  eLink = EffectLinkEffects(eLink, eDur);

  //Declarando variable de disipacion
    string sVarName = GetName(OBJECT_SELF, TRUE);
    sVarName += IntToString(GetSpellId());
    int nValue = GetLevelByClass(41, OBJECT_SELF);  //Sumamos niveles de caballero protector.
    nValue += GetLevelByClass(32, OBJECT_SELF);     //Sumamos niveles de campeon divino.
    nValue += GetLevelByClass(2, OBJECT_SELF);      //Sumamos niveles de clerigo
    nValue += GetLevelByClass(6, OBJECT_SELF);      //Sumamos niveles de paladin
    nValue += GetLevelByClass(50, OBJECT_SELF);     //Sumamos niveles de soldado de la luz


  //Determina el primer objetivo en el radio del lanzador.
  object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL * 2, GetLocation(OBJECT_SELF));
  while(GetIsObjectValid(oTarget))
  {
      if(!GetIsReactionTypeHostile(oTarget))
      {
          // * Do not allow this to stack
          RemoveEffectsFromSpell(oTarget, GetSpellId());

          fDelay = GetRandomDelay(0.4, 1.1);
          //Fire spell cast at event for target
          SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 847, FALSE));
            SetLocalInt(oTarget, sVarName, nValue);
          //Aplica los VFX de impacto y los bonos
          DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUPER_HEROISM), oTarget));
          DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCharismaBonus)));
      }

  //Determina quien es el siguiente objetivo alrededor del lanzador
  oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL * 2, GetLocation(OBJECT_SELF));
  }
}
