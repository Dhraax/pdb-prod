// Explosion Sobrenatural Brujo //

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"
#include "war_utilities"

void main()
{
    if (!CheckWarlockSpellCharisma()) return;
    if (!X2PreSpellCastCode()) return;

    // Declaraci?n de variables
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nLevel = GetLevelByClass(57, oPC);

    // Variables del Brujo
    int nDam = GetWarlockExplosionDamage(oPC);
    int nEsencia = GetLocalInt(oPC, "esencia_ajustes");
    int nDamageType = GetLocalInt(oPC, "esencia_sobrenatural");
    int nModAptitud = GetLocalInt(oPC, "war_mod_aptitud");

    if (nModAptitud) UsoModAptitud();

    // Efectos
    effect nImpact;
    effect eMissile;
    int bBeam = FALSE;
    float fEffectDuration = 0.0;
    float fEffectDelay = 25.0;
    float fDist = 0.0;
    float fDelay = 0.0;
    effect eDam;

    if (nEsencia == WARLOCK_ESENCIA_TENEBROSA)      { nImpact = EffectVisualEffect(288); eMissile = EffectVisualEffect(1583); }
    else if (nEsencia == WARLOCK_ESENCIA_CAUSTICA ) { nImpact = EffectVisualEffect(283); eMissile = EffectVisualEffect(1580); }
    else if (nEsencia == WARLOCK_ESENCIA_DERRIBO )  { nImpact = EffectVisualEffect(284); eMissile = EffectVisualEffect(1572); }
    else if (nEsencia == WARLOCK_ESENCIA_AZUFRE )   { nImpact = EffectVisualEffect(280); bBeam = TRUE; eMissile = EffectBeam(444, OBJECT_SELF, BODY_NODE_HAND); fEffectDuration = 1.5; fDelay = GetDistanceBetween(oTarget, OBJECT_SELF)/13; }
    else if (nEsencia == WARLOCK_ESENCIA_INFERNAL ) { nImpact = EffectVisualEffect(281); bBeam = TRUE; eMissile = EffectBeam(VFX_BEAM_SILENT_LIGHTNING, OBJECT_SELF, BODY_NODE_HAND); fEffectDuration = 1.5; fDelay = 0.2; }
    else                                            { nImpact = EffectVisualEffect(76);  bBeam = TRUE; eMissile = EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF, BODY_NODE_HAND); fEffectDuration = 1.5; fDelay = 0.2; }

    fDist = GetDistanceBetween(OBJECT_SELF, oTarget);

    if (!bBeam) fDelay = fDist/(3.0 * log(fDist) + fEffectDelay);


    int nTouchAttack = TouchAttackRanged(oTarget);

     //Los nomuertos se curan
   if (nEsencia == WARLOCK_ESENCIA_TENEBROSA && PB_Race_GetIsUndead(oTarget))
     {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_ENFEEBLEMENT, FALSE));
        if (!bBeam) ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
        else        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMissile, oTarget, fEffectDuration);
       eDam = EffectHeal(nDam);
       nImpact = EffectVisualEffect(VFX_IMP_HEALING_S);
       DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, nImpact, oTarget));
       DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
     }

    //Si no son Undead, ataque de toque
   else if (nTouchAttack)
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_ENFEEBLEMENT));
        // Comprobar si se produce un cr?tico
        if (nTouchAttack == 2) nDam *= 2;
        eDam = EffectDamage(nDam, nDamageType ? nDamageType : DAMAGE_TYPE_MAGICAL);

        // Make SR check
        if (nEsencia == WARLOCK_ESENCIA_CAUSTICA || !MyResistSpell(OBJECT_SELF, oTarget))
        {
            if (!bBeam) ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
            else        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMissile, oTarget, fEffectDuration);

            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, nImpact, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            if (nEsencia && !GetIsDead(oTarget)) DelayCommand(fDelay, AjusteEsencia(oTarget, nModAptitud));
        }
    }
    else {
        if (!bBeam) ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
        else        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMissile, oTarget, fEffectDuration);
    }
}

