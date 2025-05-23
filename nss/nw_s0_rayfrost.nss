//::///////////////////////////////////////////////
//:: Ray of Frost
//:: [NW_S0_RayFrost.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If the caster succeeds at a ranged touch attack
    the target takes 1d4 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: feb 4, 2001
//:://////////////////////////////////////////////
//:: Bug Fix: Andrew Nobbs, April 17, 2003
//:: Notes: Took out ranged attack roll.
//:://////////////////////////////////////////////


#include "x0_i0_spells"
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    int nCasterLevel = GetTotalCasterLevel(OBJECT_SELF);
    int nDam = d4(1) + 1;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eRay = EffectBeam(VFX_BEAM_COLD, OBJECT_SELF, BODY_NODE_HAND);
    effect eVelocidad = EffectMovementSpeedDecrease(10);
    effect eVis2 = EffectVisualEffect(VFX_IMP_SLOW);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_FROST));
        //Efecto del rayo.
        eRay = EffectBeam(VFX_BEAM_COLD, OBJECT_SELF, BODY_NODE_HAND);
        //Hacemos tirada de resistencia.
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            //Ajustamos los daños.
            int nDice = 8; //Es d8.
            int nNumberOfDice; //Veces que tira
            int CDEscalado;

            //Escalado de poder según el nivel.
            if(nCasterLevel >= 1 && nCasterLevel < 8) {nNumberOfDice = 1;}
            else if(nCasterLevel >= 8 && nCasterLevel < 12) {nNumberOfDice = 2;  CDEscalado= CDEscalado + 1;}
            else if(nCasterLevel >= 12 && nCasterLevel < 16) {nNumberOfDice = 3; CDEscalado= CDEscalado + 2;}
            else if(nCasterLevel >= 16 && nCasterLevel < 20) {nNumberOfDice = 4; CDEscalado= CDEscalado + 3;}
            else if(nCasterLevel >= 20) {nNumberOfDice = 5;  CDEscalado= CDEscalado + 4;}

            //Metamagias.
            nDam =  MaximizeOrEmpower(nDice, nNumberOfDice, GetMetaMagicFeat());
            //Hacemos tirada de toque.
            int nTouch = TouchAttackRanged(oTarget);
            if(nDam == 0) {nTouch = 0;}
            if(nTouch > 0)
            {
                //Mejoramos el daño por el crítico.
                if(nTouch == 2)
                {
                    nDam *= 2;
                }
                //Ajusted del archimago.
                eDam = EffectDamage(nDam, ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_COLD));
                //Aplicamos los efectos.
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVelocidad, oTarget, 6.0);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
            }
        }
    }
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
