#include "mti_libreria"
#include "nwnx_creature"

void main()
{
    object oPC = OBJECT_SELF;

    // El leto ha sido aplicado

    GuardarIntPersistente(oPC, "DOTE_SOMBRIA", TRUE);

    // Efecto visual

    DelayCommand(0.3, FloatingTextStringOnCreature("*La Urdimbre Sombria te hace perder parte del juicio!*", oPC));

    // Ajuste de caracteristica
    NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, -2);
}
