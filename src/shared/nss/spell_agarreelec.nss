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
    int nDam;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);


    if(!GetIsReactionTypeFriendly(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
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
            int nTouch = TouchAttackMelee(oTarget);
            if(nDam == 0) {nTouch = 0;}
            if(nTouch > 0)
            {
                //Mejoramos el daño por el crítico.
                if(nTouch == 2)
                {
                    nDam *= 2;
                }
                //Ajusted del archimago.
                eDam = EffectDamage(nDam, ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_ELECTRICAL));
                //Aplicamos los efectos.
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                //Tirada de voluntad para el aturdir.
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC() + GetChangesToSaveDC(OBJECT_SELF) + CDEscalado,SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //Aplicamos los efectos.
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, 6.0);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_STUN), oTarget);
                }
            }
        }
    }

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
