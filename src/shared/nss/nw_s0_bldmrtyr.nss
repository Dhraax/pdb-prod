//::///////////////////////////////////////////////
//:: Blood of the Martyr
//:: NW_S0_bldmrtyr
//:: Created By: Mimiqp (mimiqp100@gmail.com)
//:: Created On: Jun 03, 2024
//:://////////////////////////////////////////////
/*
    You may transfer your own hit points directly to a target creature within range.
    You must transfer at least 20 points.
    Transferred hit points are damage to you.
    The creature takes your transferred hit points as if receiving a cure wounds spell and cannot gain more hit points than its maximum allows; any excess points are lost.
    This spell transfers only actual hit points, not temporary hit points.
    An unconscious target is considered a "willing creature" for purposes of this spell.
*/


#include "dote_curaumenta"
#include "x2_inc_spellhook"

const int SPELL_BLOOD_MARTYR_20 = 1394;
const int SPELL_BLOOD_MARTYR_40 = 1395;
const int SPELL_BLOOD_MARTYR_60 = 1396;
const int VFX_IMP_BLOOD_MARTYR = 7207;

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/
    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //--------------------------------------------------------------------------
    //Check that the creature has enough hit points to cast the spell

    int nCurrentHitPoints = GetCurrentHitPoints(OBJECT_SELF);

    //If the creature has less than 20 hit points, send an error message and
    //end the spell
    if(nCurrentHitPoints < 20)
    {
        string sInfo = "Tienes que tener al menos 20 puntos de golpe para lanzar este conjuro.";

        //sInfo = GetStringColoredRGB(sInfo, 255, 0, 0);

        SendMessageToPC(OBJECT_SELF, sInfo);
    }
    //If the caster has 20 hit points or more, then execute the spell
    else
    {
        object oTarget = GetSpellTargetObject();

        int nSpellID = GetSpellId();
        int nPercentage = 0;

        //Determine the healing based on the variant of the spell chosen from
        //the radial menu
        switch(nSpellID)
        {
            case SPELL_BLOOD_MARTYR_20: nPercentage = 20; break;
            case SPELL_BLOOD_MARTYR_40: nPercentage = 40; break;
            case SPELL_BLOOD_MARTYR_60: nPercentage = 60;
        }

        //Calculate the amount of points sacrificed
        int nSacrificedHealth = (nPercentage * GetMaxHitPoints(OBJECT_SELF)) / 100;

        //If the amount of points to be sacrificed is higher than the current
        //hit points, then replace the value with the current hit points
        if(nSacrificedHealth > nCurrentHitPoints)
        {
            nSacrificedHealth = nCurrentHitPoints;
        }

        //Define the damage effect for the caster
        effect eDamage = EffectDamage(nSacrificedHealth, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_NORMAL);

        //Visual effect
        effect eSacrifice = EffectVisualEffect(VFX_IMP_BLOOD_MARTYR);//Blood spray effect
        eSacrifice = EffectLinkEffects(eSacrifice, EffectVisualEffect(VFX_IMP_PULSE_HOLY));//Light shockwave effect
        eSacrifice = EffectLinkEffects(eSacrifice, EffectVisualEffect(VFX_IMP_SUNSTRIKE));//Impact searing light

        //Apply the damage on the caster
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, OBJECT_SELF, 0.0f);

        //Apply the special effects on caster
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSacrifice, OBJECT_SELF, 0.0f);


        //Parameters:
        //1st: amount to heal
        //2nd: max extra healing (e.g. when healing +1 HP per caster level
        //3rd: healing when maximised (for this spell there is no change as the original amount healed, maximizing won't do anything)
        //4th: visual effect for damage (e.g. vs undead)
        //5th: visual effect for healing
        ConjuroCuracion(nSacrificedHealth, 0, nSacrificedHealth, VFX_IMP_SUNSTRIKE, VFX_IMP_HEALING_S, GetSpellId());
    }

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}


