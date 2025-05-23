void main()
{
  object oPC = GetLastUsedBy();

  if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL)
  {
      SendMessageToPC(oPC, "*No pasa nada*");
      return;
  }

  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_TIME_STOP), oPC);
  ActionStartConversation(oPC, "", TRUE, FALSE);
}
