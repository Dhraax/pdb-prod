#include "x0_i0_spells"
#include "pb_nivellanzador"


void main()
{
  object oPC = OBJECT_SELF;

  if(GetHasSpellEffect(1148))
  {
      FloatingTextStringOnCreature("<cþ<<>** Hedor a Carroña desactivado **</c>", oPC);
      RemoveEffectsFromSpell(oPC, 1148);
      return;
  }

  //Set and apply AOE object
  FloatingTextStringOnCreature("<c´þd>** Hedor a Carroña Activado **</c>", oPC);
  effect eAOE = EffectAreaOfEffect(AOE_PER_FOGGHOUL, "prc_to_carriona", "****", "****");
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, HoursToSeconds(100));
}
