//::///////////////////////////////////////////////
//:: Cat's Grace
//:: NW_S0_CatGrace
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// The transmuted creature becomes more graceful,
// agile, and coordinated. The spell grants an
// enhancement  bonus to Dexterity of 1d4+1
// points, adding the usual benefits to AC,
// Reflex saves, Dexterity-based skills, etc.
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 18, 2000
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk
//:: Last Updated On: April 5th, 2001

#include "vgz_libreria"
#include "x2_inc_spellhook"
#include "NW_I0_SPELLS"
#include "nostack_inc"
#include "pb_nivellanzador"
#include "colors_inc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    // POTENCIACION DE CONJURO
    object oItm = GetSpellCastItem();
    if(oItm == OBJECT_INVALID && GetItemPossessedBy(OBJECT_SELF, "extractofantasma") != OBJECT_INVALID)
    {
        pentagramahaciasi(GetLocation(OBJECT_SELF), VFX_BEAM_HOLY, 1.0);
        SendMessageToPC(OBJECT_SELF, ColorToken(33,33,180) + "!El conjuro parece haberse potenciado con el extracto del fruto fantasma!</c>");
    }

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(1264);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nCasterLvl = GetTotalCasterLevel(OBJECT_SELF);
    int nModify = 4;
    float fDuration = HoursToSeconds(nCasterLvl);
    int nMetaMagic = oItm==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;

    //GoLoT: Comprobar pocion mayor
    if(oItm != OBJECT_INVALID && (GetBaseItemType(oItm) == BASE_ITEM_POTIONS || GetBaseItemType(oItm) == BASE_ITEM_ENCHANTED_POTION)) {
        //if(GetMetaMagicFeat() == METAMAGIC_EMPOWER)
        if(nCasterLvl == 20)
            nMetaMagic = METAMAGIC_EMPOWER;
    }

    // No apilamiento de conjuros similares
    RemoveEffectsFromSpell(oTarget, 13);
    RemoveEffectsFromSpell(oTarget, 361);
    RemoveEffectsFromSpell(oTarget, 481);
    RemoveEffectsFromSpell(oTarget, 1010);
    RemoveEffectsFromSpell(oTarget, 1044);
    RemoveEffectsFromSpell(oTarget, 1117);

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nModify = 6; //Damage/Healing is +50%
    }
    else if (nMetaMagic == METAMAGIC_EXTEND)
    {
        fDuration = fDuration * 2.0;    //Duration is +100%
    }

    // POTENCIACION DE CONJURO
    if(oItm == OBJECT_INVALID && GetItemPossessedBy(OBJECT_SELF, "extractofantasma")!= OBJECT_INVALID)
    {
        object oIngrediente = GetItemPossessedBy(OBJECT_SELF, "extractofantasma");
        DestroyObject(oIngrediente);

        effect eSagrado = EffectVisualEffect(87); //explosion naranja
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSagrado, oTarget);

        nModify = nModify + d2();
    }

    //Signal spell cast at event to fire on the target.
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CATS_GRACE, FALSE));

    //Apply visual and bonus effects
    DoNoStackAbilityBonus(OBJECT_SELF, oTarget, nModify, ABILITY_DEXTERITY, fDuration);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
