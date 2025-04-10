//::///////////////////////////////////////////////
//:: AURA DE DESESPERACION
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
    -2 a los TS, radio de 10 metros. Dura 5 asaltos.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 15 de Octubre de 2011
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "inc_spells"

void main()
{
    object oPC = OBJECT_SELF;

    //Si el jugador ya activó la aura de efecto, se le desactiva y borra.
    if(GetHasSpellEffect(1102, oPC))
    {
        gsSPRemoveEffect(oPC, 1102);
        IncrementRemainingFeatUses(oPC, 1304);
        FloatingTextStringOnCreature("<cþ<<>** Aura de desesperación desactivada **</c>", oPC);
        return;
    }

    //Si el jugador tiene los efectos del aura de efecto por alguien ajeno, borra los efectos sobre sí mismo y aplica los suyos propios.
    if(GetHasSpellEffect(1102)){gsSPRemoveEffect(oPC, 1102);}

    //Set and apply AOE object
    FloatingTextStringOnCreature("<c´þd>** Aura de desesperación activada **</c>", oPC);
    effect eAOE = EffectAreaOfEffect(AOE_MOB_CIRCGOOD, "dote_auradessp2", "****", "dote_auradessp3");
    gsSPApplyEffect(oPC, eAOE, 1102, GS_SP_DURATION_PERMANENT);
}
