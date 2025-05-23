#include "x0_i0_petrify"
void main()
{
  object oPJ = GetExitingObject();
  effect eDesaparecer = EffectDisappear();

  // TORRE DE AMNAGUA
  object oMonst1 = GetObjectByTag("GETURAK");
  object oMonst2 = GetObjectByTag("DTURAK");
  object oMonst3 = GetObjectByTag("GATURAK");
  object oMonst4 = GetObjectByTag("ATURAK");
  object oMonst5 = GetObjectByTag("MTURAK");
  object oMonst6 = GetObjectByTag("GOTURAK");

  if(GetLocalInt(oPJ, "NIVELTORRE") > 0)
  {
      DeleteLocalInt(GetModule(), "TORREOCUPADA");

      DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDesaparecer, oMonst1));
      DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDesaparecer, oMonst2));
      DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDesaparecer, oMonst3));
      DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDesaparecer, oMonst4));
      DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDesaparecer, oMonst5));
      DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDesaparecer, oMonst6));
  }

  // DROWS, PLANO THORMALLEM
  if(GetLocalInt(oPJ, "ESTOYENTHORMALLEM") == 1) DeleteLocalInt(GetModule(), "THORMALLEMOCUPAO");

  // DROWS, PLANO THORMALLEM 2
  if(GetLocalInt(oPJ, "ESTOYENTHORMALLEM2") == 1) DeleteLocalInt(GetModule(), "THORMALLEMOCUPAO2");

  // ZAPATILLAS SUNE
  if(GetLocalInt(oPJ, "ESTOYENZAPSUNE") > 0)
  {
      object oArmario = GetObjectByTag("armario_entrada_zs");
      effect eArmarioEfecto = EffectVisualEffect(VFX_FNF_PWSTUN);
      RemoveEffectOfType(oArmario,EFFECT_TYPE_VISUALEFFECT);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eArmarioEfecto, oArmario);
      DeleteLocalInt(oArmario, "GUARDIA_SUNE_MAGA");
  }
}
