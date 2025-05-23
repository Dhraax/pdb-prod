void main()
{
  effect eEfecto1 = EffectDamage(30 + d10(), DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL);
  effect eEfecto2 = EffectVisualEffect(VFX_IMP_FLAME_M);

  if(GetLocalInt(OBJECT_SELF,"ko_pupa_fuego") == 1)
  {
      PlayVoiceChat(VOICE_CHAT_PAIN1, OBJECT_SELF);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto1, OBJECT_SELF);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto2, OBJECT_SELF);
      DelayCommand(6.0, ExecuteScript("ko_danofuego", OBJECT_SELF));
  }
}
