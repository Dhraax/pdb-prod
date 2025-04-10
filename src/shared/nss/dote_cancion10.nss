//::///////////////////////////////////////////////
//:: IRRISORIO JOLGORIO DE JEBKIAH
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Inmoviliza y hacer reir a los hostiles durante 20 segundos.
    Luego aplica reduccion a la resistencia magica durante 5 asaltos.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 10 de Abril de 2011
//:://////////////////////////////////////////////

#include "x0_i0_spells"

void main()
{
  int nModifier;
  int nLevel = GetLevelByClass(CLASS_TYPE_BARD);
  int nPerform = GetSkillRank(SKILL_PERFORM);
  int iCD = 10 + (nPerform/2);
  int nDuration = 5;
  int nSolturaEncant = 0;
  float fD6 = IntToFloat(d6());
  effect eKO = EffectKnockdown();
  effect eResMagDis = EffectSpellResistanceDecrease(nLevel);

  //Declarando variable de disipacion
  string sVarName = GetName(OBJECT_SELF, TRUE);
  sVarName += IntToString(GetSpellId());
  int nValue = nLevel;

  // Si no tenemos usos de cancion de bardo, nanay!
  if(GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF) == FALSE)
  {
      FloatingTextStringOnCreature("Necesitas tener usos disponibles de la Canción de bardo para poder cantar esta canción.", OBJECT_SELF, FALSE);
      return;
  }

  // Minimo de Interpretar requerido
  if(nPerform < 8)
  {
      FloatingTextStringOnCreature("Necesitas 8 rangos en Interpretar para poder cantar esta canción.", OBJECT_SELF, FALSE);
      return;
  }

  // Silenciados no se canta
  if(GetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
  {
      FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
      return;
  }

  //Comprobamos si tiene soltura o soltura mayor
  if(GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT) ) nSolturaEncant = 6;
  else if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT) ) nSolturaEncant = 4;
  else if(GetHasFeat(FEAT_SPELL_FOCUS_ENCHANTMENT) ) nSolturaEncant = 2;

  //Check to see if the caster has Lasting Impression and increase duration.
  if(GetHasFeat(870))
  {
      nDuration *= 10;
  }

  // lingering song
  if(GetHasFeat(424)) // lingering song
  {
      nDuration += 5;
  }

  AssignCommand(OBJECT_SELF,PlaySound("al_pl_x2bongolp1"));
  DelayCommand(0.1,AssignCommand(OBJECT_SELF,ActionPlayAnimation(ANIMATION_LOOPING_SPASM,1.0,7.0)));
  DelayCommand(0.2,SetCommandable(FALSE,OBJECT_SELF));
  DelayCommand(1.0,AssignCommand(OBJECT_SELF,SpeakString("La-la-lá, ¡te hieden los pieees!")));
  DelayCommand(5.0,AssignCommand(OBJECT_SELF,SpeakString("La-la-laaa, ¡huelen a jureeel!")));
  DelayCommand(7.1,SetCommandable(TRUE,OBJECT_SELF));
  DelayCommand(7.2,AssignCommand(OBJECT_SELF,ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2,1.0)));
  DelayCommand(7.3,SetCommandable(FALSE,OBJECT_SELF));
  DelayCommand(9.9,SetCommandable(TRUE,OBJECT_SELF));
  DelayCommand(10.0,AssignCommand(OBJECT_SELF,ActionPlayAnimation(ANIMATION_LOOPING_SPASM,1.0,10.0)));
  DelayCommand(10.0,AssignCommand(OBJECT_SELF,SpeakString("La-la-lá, ¡me ahogo otra veeez!")));
  DelayCommand(10.1,SetCommandable(FALSE,OBJECT_SELF));
  DelayCommand(15.0,AssignCommand(OBJECT_SELF,SpeakString("La-la-laaa, ¡yo no se qué haceeer!")));
  DelayCommand(20.0,SetCommandable(TRUE,OBJECT_SELF));
  DelayCommand(20.1,AssignCommand(OBJECT_SELF,ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1,1.0)));

  object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
  while(GetIsObjectValid(oTarget))
  {
      if(oTarget != OBJECT_SELF)
      {
          //Make SR Check
          if(!MyResistSpell(OBJECT_SELF, oTarget))
          {
              // * creatures of different race find different things funny
              if(GetRacialType(oTarget) != GetRacialType(OBJECT_SELF)) nModifier = 4;
              else nModifier = 0;

              if(WillSave(oTarget, iCD - nModifier + nSolturaEncant, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF) == 0)
              {
                  AssignCommand(oTarget, ClearAllActions(TRUE));
                  DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(1855), oTarget, 20.0));
                  DelayCommand(1.1,SetCommandable(FALSE,oTarget));
                  DelayCommand(1.0,AssignCommand(oTarget,ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING,1.0,20.0)));
                  DelayCommand(1.0+fD6,PlayVoiceChat(VOICE_CHAT_LAUGH,oTarget));
                  DelayCommand(8.0+fD6,PlayVoiceChat(VOICE_CHAT_LAUGH,oTarget));
                  DelayCommand(12.0+fD6,PlayVoiceChat(VOICE_CHAT_LAUGH,oTarget));
                  DelayCommand(20.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eKO,oTarget,5.0));
                  DelayCommand(20.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eResMagDis,oTarget,RoundsToSeconds(nDuration)));
                  DelayCommand(20.0,SetCommandable(TRUE,oTarget));
                  DelayCommand(20.0, SetLocalInt(oTarget, sVarName, nValue));
              }
          }
      }

      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
  }

  DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(1855), OBJECT_SELF, 20.0);
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(1846), GetLocation(OBJECT_SELF));
}
