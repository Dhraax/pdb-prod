//::///////////////////////////////////////////////
//:: EMPATIA ANIMAL MEJORADA
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Empatia animal mejorada, dote que reciben druidas
    y exploradores a nivel 1.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 6 de Junio de 2010
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "nw_i0_spells"

void main()
{
  /*
    Spellcast Hook Code
    Added 2003-07-07 by Georg Zoeller
    If you want to make changes to all spells,
    check x2_inc_spellhook.nss to find out more
  */

  if (!X2PreSpellCastCode())
  {
      // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
      return;
  }

  // End of Spell Cast Hook

  object oPC = OBJECT_SELF;
  int iEmpatiaAnimal = GetSkillRank(SKILL_ANIMAL_EMPATHY, oPC);

  /*
    Calculamos el tiempo del efecto de miedo sobre los animales con respecto
    a la mitad de la habilidad del usuario. Asi:
    Principiante (5 rangos): 2-3 asaltos, tiempo justo para huir
    Veterano (10 rangos): 5 asaltos, tiempo para alejarse tranquilamente
    Maestro (20 rangos): 10 asaltos, posibilidad de manejar cualquier situacion
  */

  float duracionMiedo= RoundsToSeconds(iEmpatiaAnimal / 2);

  /*
    Preparamos el efecto miedo exactamente igual que el conjuro, tan solo cambiamos:
    - Centrado en el usuario
    - Solo afecta a animales, bestias, alimañas y animales magicos
    - Sin resistencia magica
    - La tirada de salvación de voluntad contra miedo se hace contra
    una DC de 10+ la habilidad de Empatia del usuario. Asi:
    Principiante (5 rangos): CD 15
    Veterano (10 rangos): CD 20
    Maestro (20 rangos): CD 30
    - La tirada de salvacion se modifica segun el tipo racial del animal
    a ahuyentar. Asi:
    Animal corriente (RACIAL_TYPE_ANIMAL): CD anterior
    Bestia (RACIAL_TYPE_BEAST): CD anterior - 5
    Alimaña (RACIAL_TYPE_VERMIN): CD anterior -10
    Bestia magica (RACIAL_TYPE_MAGICAL_BEAST): CD anterior -15
  */

  int DCTotal;
  effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
  effect eFear = EffectFrightened();
  effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
  effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
  float fDelay;
  //Link the fear and mind effects
  effect eLink = EffectLinkEffects(eFear, eMind);
  eLink = EffectLinkEffects(eLink, eDur);

  object oTarget;
  //Apply Impact
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetLocation(oPC));
  //Get first target in the spell cone
  oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oPC), TRUE);
  while(GetIsObjectValid(oTarget))
  {
      if(GetIsEnemy(oPC, oTarget) == TRUE)
      {
          if(GetRacialType(oTarget) == RACIAL_TYPE_ANIMAL ||
             GetRacialType(oTarget) == RACIAL_TYPE_BEAST  ||
             GetRacialType(oTarget) == RACIAL_TYPE_VERMIN ||
             GetRacialType(oTarget) == RACIAL_TYPE_MAGICAL_BEAST)
          {
              fDelay = GetRandomDelay();
              //Fire cast spell at event for the specified target
              SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FEAR));

              //Asignamos una DC dependiendo del tipo de animal a ahuyentar
              if(GetRacialType(oTarget) == RACIAL_TYPE_ANIMAL) DCTotal= 10 + iEmpatiaAnimal;
              else if(GetRacialType(oTarget) == RACIAL_TYPE_BEAST) DCTotal= 10 + iEmpatiaAnimal - 5;
              else if(GetRacialType(oTarget) == RACIAL_TYPE_VERMIN) DCTotal= 10 + iEmpatiaAnimal - 10;
              else if(GetRacialType(oTarget) == RACIAL_TYPE_MAGICAL_BEAST) DCTotal= 10+ iEmpatiaAnimal - 15;

              if(!MySavingThrow(SAVING_THROW_WILL, oTarget, DCTotal, SAVING_THROW_TYPE_FEAR, OBJECT_SELF, fDelay))
              {
                  //Apply the linked effects and the VFX impact
                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, duracionMiedo));
              }
          }
      }

      //Get next target in the spell cone
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(oPC), TRUE);
  }
}
