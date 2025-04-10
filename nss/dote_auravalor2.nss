//::///////////////////////////////////////////////
//:: AURA DE VALOR (al entrar al aura)
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
    Aptitud sobrenatural de los Paladines a Nivel 3.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 6 de Octubre de 2011
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "inc_spells"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();

    effect eMoral = EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_FEAR);
    effect eFinEfecto = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eMoral, eFinEfecto);

    //Faction Check
    if(gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL_SELECTIVE, oCaster, oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
        if(GetHasSpellEffect(1104, oTarget) && oTarget != oCaster)
        {
            gsSPRemoveEffect(oTarget, 1104);
        }
        //Apply the VFX impact and effects
        gsSPApplyEffect(oTarget, eLink, 1104, GS_SP_DURATION_PERMANENT);
    }
}
