#include "x0_i0_petrify"

int VerSiConjuroLuz()
{
  if(GetHasSpellEffect(1061, OBJECT_SELF) || GetHasSpellEffect(1062, OBJECT_SELF) ||
     GetHasSpellEffect(1063, OBJECT_SELF) || GetHasSpellEffect(1064, OBJECT_SELF) ||
     GetHasSpellEffect(1065, OBJECT_SELF) || GetHasSpellEffect(1066, OBJECT_SELF) ||
     GetHasSpellEffect(1067, OBJECT_SELF) || GetHasSpellEffect(1068, OBJECT_SELF) ||
     GetHasSpellEffect(1069, OBJECT_SELF) || GetHasSpellEffect(1070, OBJECT_SELF)) return TRUE;

  return FALSE;
}

void Curar()
{
  if(GetCurrentHitPoints() > 0)
  {
      if(!GetImmortal()) SetImmortal(OBJECT_SELF, TRUE);
      DeleteLocalInt(OBJECT_SELF, "LORD_RESURRECCION");
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(180 + d20(2)), OBJECT_SELF);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HARM), OBJECT_SELF);
  }
}

void main()
{
  object oPC = GetLastDamager();
  int iPuntosVidaActuales = GetCurrentHitPoints();

  if(iPuntosVidaActuales == 1)
  {
      if(GetLocalInt(OBJECT_SELF, "LORD_RESURRECCION") == FALSE)
      {
          RemoveEffectOfType(OBJECT_SELF, EFFECT_TYPE_VISUALEFFECT);
          //ClearAllActions(TRUE);
          //PlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 30.0);
          //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), OBJECT_SELF, 30.0);
          //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), OBJECT_SELF, 30.0);
          SetLocalInt(OBJECT_SELF, "LORD_RESURRECCION", TRUE);
          DelayCommand(30.0, Curar());
      }

      // Esta inmovilizado en el suelo
      else
      {
          // El Jefazo puede morir
          if(VerSiConjuroLuz())
          {
              SetImmortal(OBJECT_SELF, FALSE);
          }

          // No tiene conjuros de luz y le pegamos indefenso? Danyo a tutiplen
          else
          {
              FloatingTextStringOnCreature("<cþ<<>* Tu ataque es inefectivo y resultas dañado *</c>", oPC, FALSE);
              ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE ), oPC);
              ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d10(), DAMAGE_TYPE_NEGATIVE), oPC);
              ActionCastSpellAtObject(SPELL_DARKNESS, oPC, METAMAGIC_ANY, TRUE, 15, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
          }
      }
  }
  else
  {
      if(!VerSiConjuroLuz()) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(d6()), OBJECT_SELF);
      ExecuteScript("nw_c2_default6", OBJECT_SELF);
  }
}
