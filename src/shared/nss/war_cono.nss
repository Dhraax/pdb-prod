#include "x0_i0_spells"
#include "pb_nivellanzador"
#include "x2_inc_spellhook"
#include "war_utilities"

void main()
{

    if (!X2PreSpellCastCode())
    {
        return;
    }
    if (!CheckWarlockSpellCharisma()) return;

    //Variables del Brujo
    int nLevel = GetLevelByClass(57, OBJECT_SELF);
    int nDam = GetWarlockExplosionDamage(OBJECT_SELF);
    int nEsencia = GetLocalInt(OBJECT_SELF, "esencia_ajustes");
    int nDamageType = GetLocalInt(OBJECT_SELF, "esencia_sobrenatural");
    int nModAptitud = GetLocalInt(OBJECT_SELF, "war_mod_aptitud");

    if (nModAptitud) UsoModAptitud();

    effect eDam = EffectDamage(nDam, nDamageType ? nDamageType : DAMAGE_TYPE_MAGICAL);
    object oTarget;
    float fDelay;

    int nImpact = 76;
    int nCone = 1593;

    if (nEsencia == WARLOCK_ESENCIA_TENEBROSA)      { nImpact = 288; nCone = 1592; }
    else if (nEsencia == WARLOCK_ESENCIA_AZUFRE )   { nImpact = 280; nCone = 1551; }
    else if (nEsencia == WARLOCK_ESENCIA_CAUSTICA ) { nImpact = 283; nCone = 1550; }
    else if (nEsencia == WARLOCK_ESENCIA_INFERNAL ) { nImpact = 281; nCone = 1546; }
    else if (nEsencia == WARLOCK_ESENCIA_DERRIBO )  { nImpact = 284; nCone = 1555; }

    // Aplicacion de efectovisual
   // ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nCone), OBJECT_SELF);

    /*/Get first target in spell area
    location lTargetLocation = GetSpellTargetLocation();
    location lFinalTarget = GetLocation(OBJECT_SELF);

      vector lTargetPosition = GetPositionFromLocation(lFinalTarget);
      vector vFinalPosition;
      vFinalPosition.x = lTargetPosition.x +  cos(GetFacing(OBJECT_SELF));
      vFinalPosition.y = lTargetPosition.y +  sin(GetFacing(OBJECT_SELF));
      lTargetLocation = Location(GetAreaFromLocation(lFinalTarget),vFinalPosition,GetFacingFromLocation(lFinalTarget)); */

    location lTargetLocation = GetSpellTargetLocation();
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONE_OF_COLD));
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20.0;

            if(nEsencia == WARLOCK_ESENCIA_CAUSTICA || !MyResistSpell(OBJECT_SELF, oTarget, fDelay) && (oTarget != OBJECT_SELF))
            {
                //Adjust damage according to Reflex Save, Evasion or Improved Evasion
                nDam = GetReflexAdjustedDamage(nDam, oTarget, GetWarlockSpellDC(), SAVING_THROW_TYPE_NONE);
                effect eVis = EffectVisualEffect(nImpact);

                //Los nomuertos se curan
                        if (nEsencia == WARLOCK_ESENCIA_TENEBROSA && PB_Race_GetIsUndead(oTarget)) {
                            eDam = EffectHeal(nDam);
                            eVis = EffectVisualEffect(VFX_IMP_HEALING_S);
                            }

                if(nDam > 0)
                {
                    //Apply delayed effects
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    if (nEsencia && !GetIsDead(oTarget)) AjusteEsencia(oTarget, nModAptitud);
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
  //  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectBeam(nCone, OBJECT_SELF, BODY_NODE_HAND),oTarget,0.3);
}
