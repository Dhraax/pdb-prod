//::///////////////////////////////////////////////
//:: Electric Jolt
//:: [x0_s0_ElecJolt.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
1d3 points of electrical damage to one target.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 17 2002
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"

void main()
{
    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = GetSpellTargetObject();
    int nCasterLevel = GetTotalCasterLevel(OBJECT_SELF);
    effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);

    //Debe ser enemigo.
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ELECTRIC_JOLT));
        //Resistencia a conjuros.
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            //Realizamos ataque de toque.
            int nTouch = TouchAttackRanged(oTarget);
            if(nTouch > 0)
            {
                //Ajustamos los daños.
                int nDice = 8; //Es d8.
                int nNumberOfDice; //Veces que tira

                //Escalado de poder según el nivel.
                if(nCasterLevel >= 1 && nCasterLevel < 8) {nNumberOfDice = 1;}
                else if(nCasterLevel >= 8 && nCasterLevel < 12) {nNumberOfDice = 2;}
                else if(nCasterLevel >= 12 && nCasterLevel < 16) {nNumberOfDice = 3;}
                else if(nCasterLevel >= 16 && nCasterLevel < 20) {nNumberOfDice = 4;}
                else if(nCasterLevel >= 20) {nNumberOfDice = 5;}
                //Metamagias y ajuste al crítico.
                int nDam =  MaximizeOrEmpower(nDice, nNumberOfDice, GetMetaMagicFeat());
                if(nTouch == 2){nDam *= 2;}
                //Ajustes del archimago.
                effect eBad = EffectDamage(nDam, ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_ELECTRICAL));

                //Aplicamos los efectos.
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eBad, oTarget);
            }
        }
    }
}






