#include "pb_nivellanzador"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x2_i0_spells"


/*
 * This is the spellhook code, called when the Arcane Fire feat is activated
 * Turns the spell into an arcane fire
 */
void main()
{
    //Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
    object oTarget = GetLocalObject(OBJECT_SELF, "arcane_fire_target");
    int nCasterLvl = GetLevelByClass(53, OBJECT_SELF);
    int nDamage = 0;
    int nMetaMagic = GetMetaMagicFeat();
    int nCnt;
    int nSpellPowerLevels = 0;
    effect eMissile = EffectVisualEffect(1577); //1587
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
    effect eVis2 = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
    effect eVis3 = EffectVisualEffect(VFX_DUR_SPELLTURNING);
    effect eVis4 = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);


    float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
    float fDelay = 1.0;
    float fDelay2, fTime;
    string nSpellLevel = Get2DAString("spells", "Wiz_Sorc", GetSpellId());

    if (GetHasFeat(FEAT_SPELL_POWER_V, OBJECT_SELF))  nSpellPowerLevels = 5;
         else if (GetHasFeat(FEAT_SPELL_POWER_IV, OBJECT_SELF))  nSpellPowerLevels = 4;
         else if (GetHasFeat(FEAT_SPELL_POWER_III, OBJECT_SELF))  nSpellPowerLevels = 3;
         else if (GetHasFeat(FEAT_SPELL_POWER_II, OBJECT_SELF))  nSpellPowerLevels = 2;
         else if (GetHasFeat(FEAT_SPELL_POWER_I, OBJECT_SELF))  nSpellPowerLevels = 1;

     nCasterLvl += nSpellPowerLevels;

    /* Tell to not execute the original spell */
    SetModuleOverrideSpellScriptFinished();

    /* Whatever happens next we must restore the hook */
    SetModuleOverrideSpellscript(GetLocalString(GetModule(), "archmage_save_overridespellscript"));

    /* Allow to use it once again */
    SetLocalInt(OBJECT_SELF, "arcane_fire_active", 0);

    /* Paranoia -- should never happen */
    if (!GetHasFeat(FEAT_ARCANE_FIRE, OBJECT_SELF)) return;

    /* Only wizard/sorc spells */
    if (nSpellLevel == "")
    {
        FloatingTextStringOnCreature("Fuego Arcano debe usarse con conjuros memorizados.", OBJECT_SELF, FALSE);
        return;
    }

    /* No item casting */
    if (GetIsObjectValid(GetSpellCastItem()))
    {
        FloatingTextStringOnCreature("Fuego Arcano debe usarse con conjuros memorizados", OBJECT_SELF, FALSE);
        return;
    }

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_MISSILE));

        //Make ranged touch attack check
        if (TouchAttackRanged(oTarget, FALSE))
        {
                //Roll damage
                int nDam = d6(nCasterLvl + StringToInt(nSpellLevel));

                fTime = fDelay;
                fDelay2 += 0.1;
                fTime += fDelay2;

                //Set damage effect
                effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
                //Apply the MIRV and damage effect
                DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis3, OBJECT_SELF);
                DelayCommand(fDelay2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));

         }
         else

         {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis3, OBJECT_SELF);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis4, oTarget);

         }
     }
}

