#include "x0_i0_spells"
#include "inc_spells"

void main()
{
    object oPC = OBJECT_SELF;

    //Creamos el aura de efecto.
    FloatingTextStringOnCreature("<c´þd>** Halo sagrado activado **</c>", oPC);
    effect eAOE = EffectAreaOfEffect(AOE_MOB_TIDE_OF_BATTLE, "dote_halosagra2", "****", "dote_halosagra3");
    effect eSalva = EffectSavingThrowIncrease(SAVING_THROW_ALL,3);

    //Duración de los efectos.
    float fDuracion = RoundsToSeconds(GetAbilityModifier(ABILITY_CHARISMA,oPC));

    //Aplicamos los efectos.
    gsSPApplyEffect(oPC, eAOE, GetSpellId(), fDuracion);
    gsSPApplyEffect(oPC, eSalva, GetSpellId(), fDuracion);
}
