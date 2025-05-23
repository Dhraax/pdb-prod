#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"
#include "war_utilities"
#include "lib_race"

void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    if (!CheckWarlockSpellCharisma()) return;

    int nLevel = GetLevelByClass(57, OBJECT_SELF);
    int nTouchAttack;

    //Variables del Brujo
    int nDam = GetWarlockExplosionDamage(OBJECT_SELF);
    int nCntDam;
    int nEsencia = GetLocalInt(OBJECT_SELF, "esencia_ajustes");
    int nDamageType = GetLocalInt(OBJECT_SELF, "esencia_sobrenatural");
    int nModAptitud = GetLocalInt(OBJECT_SELF, "war_mod_aptitud");

    if (nModAptitud) UsoModAptitud();

    //Declare lightning effect connected the casters hands
    effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF, BODY_NODE_HAND);
    effect eVis;
    effect eDam;
    object oFirstTarget = GetSpellTargetObject();
    object oHolder;
    object oTarget;
    location lSpellLocation;

    // Ajuste de efectos de impacto según la esencia
    if (nEsencia == WARLOCK_ESENCIA_TENEBROSA)        eVis = EffectVisualEffect(288);
    else if (nEsencia == WARLOCK_ESENCIA_CAUSTICA )   eVis = EffectVisualEffect(283);
    else if (nEsencia == WARLOCK_ESENCIA_DERRIBO )    eVis = EffectVisualEffect(284);
    else if (nEsencia == WARLOCK_ESENCIA_AZUFRE )     eVis = EffectVisualEffect(280);
    else if (nEsencia == WARLOCK_ESENCIA_INFERNAL )   eVis = EffectVisualEffect(281);
    else                                              eVis = EffectVisualEffect(76);

    if (spellsIsTarget(oFirstTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
    {

        //Make an SR Check
        //Fire cast spell at event for the specified target
        if((nEsencia == WARLOCK_ESENCIA_TENEBROSA && PB_Race_GetIsUndead(oFirstTarget) && GetIsReactionTypeFriendly(oFirstTarget)))
            SignalEvent(oFirstTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_ENFEEBLEMENT, FALSE));
        else
            SignalEvent(oFirstTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_ENFEEBLEMENT));

        nTouchAttack = TouchAttackRanged(oFirstTarget);
        if((nEsencia == WARLOCK_ESENCIA_TENEBROSA && PB_Race_GetIsUndead(oFirstTarget) && GetIsReactionTypeFriendly(oFirstTarget)) ||
            nTouchAttack && (nEsencia == WARLOCK_ESENCIA_CAUSTICA || !MyResistSpell(OBJECT_SELF, oFirstTarget)))
        {
                if (nTouchAttack == 2) nCntDam = nDam * 2;
                else nCntDam = nDam;
                eDam = EffectDamage(nCntDam, nDamageType ? nDamageType : DAMAGE_TYPE_MAGICAL);
                //Los nomuertos se curan
                if (nEsencia == WARLOCK_ESENCIA_TENEBROSA && PB_Race_GetIsUndead(oFirstTarget)) {
                    eDam = EffectHeal(nDam);
                    eVis = EffectVisualEffect(VFX_IMP_HEALING_S);
                }

                ApplyEffectToObject(DURATION_TYPE_INSTANT,eDam,oFirstTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oFirstTarget);
                if (nEsencia && !GetIsDead(oFirstTarget)) AjusteEsencia(oFirstTarget, nModAptitud);
        }
    }
    //Apply the lightning stream effect to the first target, connecting it with the caster
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oFirstTarget,0.5);

    // Si el primer ataque de toque falla, no encadenar.
    if (!nTouchAttack) return;

    //Reinitialize the lightning effect so that it travels from the first target to the next target
    eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oFirstTarget, BODY_NODE_CHEST);

    float fDelay = 0.2;
    int nCnt = 0;
    int nMaxCnt = nLevel/5;
    if (nMaxCnt < 1) nMaxCnt = 2;

    // *
    // * Secondary Targets
    // *

    //Get the first target in the spell shape
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget) && nCnt < nMaxCnt)
    {
        //Make sure the caster's faction is not hit and the first target is not hit
        if (oTarget != oFirstTarget && spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
            //Connect the new lightning stream to the older target and the new target
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,0.5));

            //Fire cast spell at event for the specified target
        if((nEsencia == WARLOCK_ESENCIA_TENEBROSA && PB_Race_GetIsUndead(oTarget) && GetIsReactionTypeFriendly(oTarget)))
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_ENFEEBLEMENT, FALSE));
        else
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_ENFEEBLEMENT));
            //Do an SR check

            nTouchAttack = TouchAttackRanged(oTarget);
            if((nEsencia == WARLOCK_ESENCIA_TENEBROSA && PB_Race_GetIsUndead(oTarget) && GetIsReactionTypeFriendly(oTarget)) ||
                nTouchAttack && (nEsencia == WARLOCK_ESENCIA_CAUSTICA || !MyResistSpell(OBJECT_SELF, oTarget)))
            {
                if (nTouchAttack == 2) nCntDam = nDam * 2;
                else nCntDam = nDam;
                eDam = EffectDamage(nCntDam, nDamageType ? nDamageType : DAMAGE_TYPE_MAGICAL);
                //Los nomuertos se curan
                if (nEsencia == WARLOCK_ESENCIA_TENEBROSA && PB_Race_GetIsUndead(oTarget)) {
                    eDam = EffectHeal(nDam);
                    eVis = EffectVisualEffect(VFX_IMP_HEALING_S);
                }

                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDam,oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
                if (nEsencia && !GetIsDead(oTarget)) AjusteEsencia(oTarget, nModAptitud);
            }

            oHolder = oTarget;

            //change the currect holder of the lightning stream to the current target
            if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
            {
                eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oHolder, BODY_NODE_CHEST);
            }
            else
            {
                // * April 2003 trying to make sure beams originate correctly
                effect eNewLightning = EffectBeam(VFX_BEAM_LIGHTNING, oHolder, BODY_NODE_CHEST);
                if(GetIsEffectValid(eNewLightning))
                {
                    eLightning =  eNewLightning;
                }
            }

            nCnt++;
            fDelay = fDelay + 0.1f;
        }

       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE);
    }
}

