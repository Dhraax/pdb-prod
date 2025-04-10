#include "f_vampire_defs"
#include "f_vampire_spls_h"

void VampireAcquireItem()
{
object oPC = GetModuleItemAcquiredBy();
if(!GetIsVampire(oPC)) return;
object oO = GetModuleItemAcquired();
string sTag = GetTag(oO);
effect eE = EffectDamage(d4(2), DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY);
effect eVis = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
eE = EffectLinkEffects(eVis, eE);
if(WildRosesBurn && sTag == "FALLEN_VAMPIRE_WILDROSE")
    {
    FloatingTextStringOnCreature("La rosa salvaje se marchita y se convierte en humo en tus manos, quemándote con su pureza.", oPC, FALSE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eE, oPC);
    DestroyObject(oO);
    }
else if(HolyWaterExplodes && (sTag == "X1_WMGRENADE005" || sTag == "NW_IT_MSMLMISC15"))
    { //These are tags for the 2 types of holy water (grenade and armor ingredient).
    FloatingTextStringOnCreature("La botella de agua bendita explota cuando la tocas, quemándote con su energía divina.", oPC, FALSE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eE, oPC);
    DestroyObject(oO);
    }
else if(CannotTouchSilver && FindSubString(GetStringLowerCase(sTag + " " + GetName(oO)), "silver") != -1)
    { //silver is not something to hold as a vampire =p
    eE = EffectDamage(d4(3), DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY);
    eVis = EffectVisualEffect(VFX_COM_SPARKS_PARRY);
    eE = EffectLinkEffects(eVis, eE);
    FloatingTextStringOnCreature("La plata de este objeto te daña y no tienes más remedio que soltarlo.", oPC, FALSE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eE, oPC);
    //CopyObject(oO, GetLocation(oPC));
    DestroyObject(oO);
    }
}

