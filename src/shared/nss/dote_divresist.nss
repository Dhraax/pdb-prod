//::///////////////////////////////////////////////
//:: Resistencia divina
//:://////////////////////////////////////////////
/*
    Con cada uso gastado de expulsar muertos el personaje y todos sus aliados
    en un radio de 60 pies reciben una reduccion al danio de frio/fuego/electricidad
    de 10 puntos durante asaltos/carisma.

*/
//:://////////////////////////////////////////////
//:: Created By: Idelish y modificado por Monti
//:: Created On: Mar 20, 2010
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

  // Se restan usos de Exulsar
  DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);

  // Se declaran las variables principales
  float fDelay;
  int nCharismaBonus = GetAbilityModifier(ABILITY_CHARISMA);
  effect eVis = EffectVisualEffect(VFX_DUR_PROT_EPIC_ARMOR);
  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
  effect eDamResist1 = EffectDamageResistance(DAMAGE_TYPE_FIRE, 10, 0);
  effect eDamResist2 = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 10, 0);
  effect eDamResist3 = EffectDamageResistance(DAMAGE_TYPE_COLD, 10, 0);
  effect eLink = EffectLinkEffects(eDamResist1, eDamResist2);
  eLink = EffectLinkEffects(eLink, eDamResist3);
  eLink = EffectLinkEffects(eLink, eDur);

  //Declarando variable de disipacion
    string sVarName = GetName(OBJECT_SELF, TRUE);
    sVarName += IntToString(GetSpellId());
    int nValue = GetLevelByClass(41, OBJECT_SELF);  //Sumamos niveles de caballero protector.
    nValue += GetLevelByClass(32, OBJECT_SELF);     //Sumamos niveles de campeon divino.
    nValue += GetLevelByClass(2, OBJECT_SELF);      //Sumamos niveles de clerigo
    nValue += GetLevelByClass(6, OBJECT_SELF);      //Sumamos niveles de paladin
    nValue += GetLevelByClass(50, OBJECT_SELF);     //Sumamos niveles de soldado de la luz

  // Aplicar impacto
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_PROT_EPIC_ARMOR_2), GetSpellTargetLocation());

  //Determina el primer objetivo en el radio del lanzador.
  object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 60.0, GetLocation(OBJECT_SELF));
  while(GetIsObjectValid(oTarget))
  {
      if(!GetIsReactionTypeHostile(oTarget))
      {
          // * Do not allow this to stack
          RemoveEffectsFromSpell(oTarget, GetSpellId());

          fDelay = GetRandomDelay(0.4, 1.1);
          //Fire spell cast at event for target
          SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 855, FALSE));
          //Aplica los VFX de impacto y los bonos
          DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
          DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCharismaBonus)));
          SetLocalInt(oTarget, sVarName, nValue);
      }

      //Determina quien es el siguiente objetivo alrededor del lanzador
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, 60.0, GetLocation(OBJECT_SELF));
  }
}
