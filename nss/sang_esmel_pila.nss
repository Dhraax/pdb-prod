#include "f_vampire_spls_h"
#include "f_vampire_h"
void main()
{
  object oPJ = GetLastUsedBy();
  string sSubraza = GetStringLowerCase(GetSubRace(oPJ));
  effect eDanyar = EffectVisualEffect(VFX_IMP_HARM);
  effect eRegenerar = EffectRegenerate(d6(), 5.0);

  if(GetLocalInt(oPJ, "VAMP_BEBER_SANGRE") == 1)
  {
      FloatingTextStringOnCreature("*Tu sed de sangre ha sido saciada*", oPJ);
      Vampire_Fresh_Blood(oPJ);
      return;
  }

  if(GetIsVampire(oPJ))
  {
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eDanyar, oPJ);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRegenerar, oPJ, 300.0);
      SetLocalInt(oPJ, "VAMP_BEBER_SANGRE", 1);
      DelayCommand(300.0, DeleteLocalInt(oPJ, "VAMP_BEBER_SANGRE"));
      Vampire_Fresh_Blood(oPJ);
      return;
  }
  else
  {
      FloatingTextStringOnCreature("*Miras la pila llena de sangre caliente y te entran náuseas*", oPJ);
  }
}

