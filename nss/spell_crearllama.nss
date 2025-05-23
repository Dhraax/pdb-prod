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
    effect eVisLuz = EffectVisualEffect(VFX_DUR_LIGHT_RED_15);
    effect eVisImpacto = EffectVisualEffect(VFX_IMP_FLAME_S);

    //Si el usuario no tiene el efecto del conjuro y usa el conjuro sobre sí mismo.
    if(!GetHasSpellEffect(GetSpellId(), OBJECT_SELF) && oTarget == OBJECT_SELF)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVisLuz, oTarget, 600.0); //Efecto dura siempre 10 minutos.

    }
    //Si el objetivo no es el propio lanzador.
    if(oTarget != OBJECT_SELF)
    {
        //Debe ser enemigo.
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Resistencia a conjuros.
            if(!MyResistSpell(OBJECT_SELF, oTarget))
            {
                //Hacemos ataque de toque.
                int nTouch = TouchAttackRanged(oTarget);
                if(nTouch > 0)
                {
                    //Ajuste del daño.
                    int nDice = 8; //Es d8.
                    int nNumberOfDice; //Veces que tira

                    //Escalado de poder según el nivel.
                    if(nCasterLevel >= 1 && nCasterLevel < 8) {nNumberOfDice = 1;}
                    else if(nCasterLevel >= 8 && nCasterLevel < 12) {nNumberOfDice = 2;}
                    else if(nCasterLevel >= 12 && nCasterLevel < 16) {nNumberOfDice = 3;}
                    else if(nCasterLevel >= 16 && nCasterLevel < 20) {nNumberOfDice = 4;}
                    else if(nCasterLevel >= 20) {nNumberOfDice = 5;}
                    //Metamagias y crítico con el ataque de toque.
                    int nDam =  MaximizeOrEmpower(nDice, nNumberOfDice, GetMetaMagicFeat());
                    if(nTouch == 2){nDam *= 2;}
                    //Ajustes del archimago.
                    effect eBad = EffectDamage(nDam, ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_FIRE));

                    //Aplicamos el efecto.
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisImpacto, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eBad, oTarget);
                }
            }
            //Borramos el efecto de luz del PJ.
            if(GetHasSpellEffect(GetSpellId(), OBJECT_SELF)){RemoveSpellEffects(GetSpellId(),OBJECT_SELF,OBJECT_SELF);}
        }
    }
}

