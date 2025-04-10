#include "conv_inc"

void main()
{
  object oPC = OBJECT_SELF;
  int nCasterLevel = GetHitDice(oPC);
  int nDuration = nCasterLevel;
  if(nDuration < 5) nDuration = 5;

  effect eInvocacion = EffectSummonCreature("entdeguerra", VFX_FNF_NATURES_BALANCE , 0.5, TRUE);
  ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eInvocacion, GetLocation(oPC), TurnsToSeconds(nDuration));

  // Aumentar convocacion
  DelayCommand(2.0, BonosConvocarCriatura(oPC));
}
