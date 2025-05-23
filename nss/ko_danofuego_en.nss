// En el OnEnter del desencadenante
void main()
{
  object oPC = GetEnteringObject();

  if(GetIsPC(oPC) != TRUE) return;

  effect eEfecto1 = EffectDamage(30 + d10(), DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL);
  effect eEfecto2 = EffectVisualEffect(VFX_IMP_FLAME_M);

  if(GetLocalInt(oPC, "ko_pupa_fuego") == 0)
  {
      SetLocalInt(oPC, "ko_pupa_fuego", 1);

      ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto1, oPC);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto2, oPC);
      PlayVoiceChat(VOICE_CHAT_PAIN1, oPC);
      DelayCommand(6.0, ExecuteScript("ko_danofuego",oPC));
  }
}
