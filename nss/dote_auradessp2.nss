//::///////////////////////////////////////////////
//:: AURA DE DESESPERACION (al entrar al aura)
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
    -2 a los TS, radio de 10 metros. Dura 5 asaltos.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 15 de Octubre de 2011
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "inc_spells"

void main()
{
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();

    //Solo a enemigos.
    if(gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, oCaster, oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
        if(GetHasSpellEffect(1102, oTarget) && oTarget != oCaster)
        {
            gsSPRemoveEffect(oTarget, 1102);
        }

        //Solo los efectos de un aura, no varios.
        if(!GetHasSpellEffect(1102))
        {
            //Aplicamos los efectos.
            gsSPApplyEffect(oTarget, EffectSavingThrowDecrease(SAVING_THROW_ALL, 2), 1102, RoundsToSeconds(5));
            gsSPApplyEffect(oTarget, EffectVisualEffect(VFX_IMP_DOOM), 1102, GS_SP_DURATION_INSTANT);
        }
    }


}
