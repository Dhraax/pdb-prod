#include "x0_i0_spells"
#include "pb_nivellanzador"
#include "x2_inc_spellhook"
#include "war_utilities"

void PerdicionSobrenatural(int nBaseDam, int nCap, int nSpell, int nMIRV = VFX_IMP_MIRV, int nVIS = VFX_IMP_MAGBLUE, int nDAMAGETYPE = DAMAGE_TYPE_MAGICAL, int nONEHIT = FALSE, int nReflexSave = FALSE, float fEffectDelay = 25.0, int nModAptitud = 0)
{
    object oTarget = OBJECT_INVALID;
    int nCasterLvl = GetTotalCasterLevel(OBJECT_SELF);
    int nCnt = 1;
    effect eMissile = EffectVisualEffect(nMIRV);
    effect eVis = EffectVisualEffect(nVIS);
    float fDist = 0.0;
    float fDelay = 0.0;
    float fDelay2, fTime;
    location lTarget = GetSpellTargetLocation(); // missile spread centered around caster
    int nMissiles = nCasterLvl;
    int nEsencia = GetLocalInt(OBJECT_SELF, "esencia_ajustes");

    if (nMissiles > nCap)
    {
        nMissiles = nCap;
    }

        /* New Algorithm
            1. Count # of targets
            2. Determine number of missiles
            3. First target gets a missile and all Excess missiles
            4. Rest of targets (max nMissiles) get one missile
       */
    int nEnemies = 0;

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget) )
    {
        // * caster cannot be harmed by this spell
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && (oTarget != OBJECT_SELF))
        {
            // GZ: You can only fire missiles on visible targets
            if (GetObjectSeen(oTarget,OBJECT_SELF))
            {
                nEnemies++;
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
     }

     if (nEnemies == 0) return; // * Exit if no enemies to hit
     int nExtraMissiles = nMissiles / nEnemies;
     // April 2003
     // * if more enemies than missiles, need to make sure that at least
     // * one missile will hit each of the enemies
     if (nExtraMissiles <= 0)
     {
        nExtraMissiles = 1;
     }

     // by default the Remainder will be 0 (if more than enough enemies for all the missiles)
     int nRemainder = 0;

     if (nExtraMissiles >0)
        nRemainder = nMissiles % nEnemies;

     if (nEnemies > nMissiles)
        nEnemies = nMissiles;

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget) && nCnt <= nEnemies)
    {
        // * caster cannot be harmed by this spell
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && (oTarget != OBJECT_SELF) && (GetObjectSeen(oTarget,OBJECT_SELF)))
        {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));

                // * recalculate appropriate distances
                fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
                fDelay = fDist/(3.0 * log(fDist) + fEffectDelay);

                // Firebrand.
                // It means that once the target has taken damage this round from the
                // spell it won't take subsequent damage
                if (nONEHIT == TRUE)
                {
                    nExtraMissiles = 1;
                    nRemainder = 0;
                }

                int i = 0;
                //--------------------------------------------------------------
                // GZ: Moved SR check out of loop to have 1 check per target
                //     not one check per missile, which would rip spell mantels
                //     apart
                //--------------------------------------------------------------
                if (nEsencia == WARLOCK_ESENCIA_CAUSTICA || !MyResistSpell(OBJECT_SELF, oTarget, fDelay))
                {
                    for (i=1; i <= nExtraMissiles + nRemainder; i++)
                    {
                        //Roll damage
                        int nDam = nBaseDam;

                        // Jan. 29, 2004 - Jonathan Epp
                        // Reflex save was not being calculated for Firebrand
                        if(nReflexSave)
                        {
                            if(nDAMAGETYPE == DAMAGE_TYPE_MAGICAL) nDam = GetReflexAdjustedDamage(nDam, oTarget, GetWarlockSpellDC(OBJECT_SELF, FALSE, TRUE), SAVING_THROW_TYPE_SPELL);
                            else if(nDAMAGETYPE == DAMAGE_TYPE_FIRE) nDam = GetReflexAdjustedDamage(nDam, oTarget, GetWarlockSpellDC(OBJECT_SELF, FALSE, TRUE), SAVING_THROW_TYPE_FIRE);
                            else if(nDAMAGETYPE == DAMAGE_TYPE_COLD) nDam = GetReflexAdjustedDamage(nDam, oTarget, GetWarlockSpellDC(OBJECT_SELF, FALSE, TRUE), SAVING_THROW_TYPE_COLD);
                            else if(nDAMAGETYPE == DAMAGE_TYPE_ACID) nDam = GetReflexAdjustedDamage(nDam, oTarget, GetWarlockSpellDC(OBJECT_SELF, FALSE, TRUE), SAVING_THROW_TYPE_ACID);
                            else if(nDAMAGETYPE == DAMAGE_TYPE_NEGATIVE) nDam = GetReflexAdjustedDamage(nDam, oTarget, GetWarlockSpellDC(OBJECT_SELF, FALSE, TRUE), SAVING_THROW_TYPE_NEGATIVE);
                        }

                        fTime = fDelay;
                        fDelay2 += 0.1;
                        fTime += fDelay2;

                        //Set damage effect
                        effect eDam = EffectDamage(nDam, nDAMAGETYPE);

                        //Los nomuertos se curan
                        if (nEsencia == WARLOCK_ESENCIA_TENEBROSA && PB_Race_GetIsUndead(oTarget)) {
                            eDam = EffectHeal(nDam);
                            eVis = EffectVisualEffect(VFX_IMP_HEALING_S);
                            }
                        //Apply the MIRV and damage effect
                        DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
                        DelayCommand(fDelay2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
                        DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                        if (nEsencia && !GetIsDead(oTarget)) DelayCommand(fTime, AjusteEsencia(oTarget, nModAptitud));
                    } // for
                }
                else
                {  // * apply a dummy visual effect
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
                }
                nCnt++;// * increment count of missiles fired
                nRemainder = 0;
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}

void main()
{

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    if (!CheckWarlockSpellCharisma()) return;

    int nLevel = GetLevelByClass(57, OBJECT_SELF);

    //Variables del Brujo
    int nBaseDam = GetWarlockExplosionDamage();
    int nEsencia = GetLocalInt(OBJECT_SELF, "esencia_ajustes");
    int nDamageType = GetLocalInt(OBJECT_SELF, "esencia_sobrenatural");
    int nModAptitud = GetLocalInt(OBJECT_SELF, "war_mod_aptitud");

    if (nModAptitud) UsoModAptitud();

    int nImpact = 76;
    int eMissile = 1581;
    float fEffectDelay = 25.0;

    if (nEsencia == WARLOCK_ESENCIA_TENEBROSA)      { nImpact = 288; eMissile = 1583; }
    else if (nEsencia == WARLOCK_ESENCIA_AZUFRE )   { nImpact = 280; eMissile = 1584; }
    else if (nEsencia == WARLOCK_ESENCIA_CAUSTICA ) { nImpact = 283; eMissile = 1580; }
    else if (nEsencia == WARLOCK_ESENCIA_INFERNAL ) { nImpact = 281; eMissile = 1581; }
    else if (nEsencia == WARLOCK_ESENCIA_DERRIBO )  { nImpact = 284; eMissile = 1572; }


    PerdicionSobrenatural(nBaseDam, nLevel, SPELL_ISAACS_GREATER_MISSILE_STORM, eMissile, nImpact, nDamageType ? nDamageType : DAMAGE_TYPE_MAGICAL, TRUE, TRUE, fEffectDelay, nModAptitud);
}

