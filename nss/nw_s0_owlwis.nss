//::///////////////////////////////////////////////
//:: Owl's Wisdom
//:: NW_S0_OwlWis
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Raises targets Wis by 1d4+1
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 15, 2001
//:://////////////////////////////////////////////

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
    if(oItm == OBJECT_INVALID && GetItemPossessedBy(OBJECT_SELF, "extractobaya") != OBJECT_INVALID)
    {
        pentagramahaciasi(GetLocation(OBJECT_SELF), VFX_BEAM_HOLY, 1.0);
        SendMessageToPC(OBJECT_SELF,ColorToken(33,33,180) + "!El conjuro parece haberse potenciado con el extracto de baya acuosa!</c>");
    }

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(1267);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);


    int nMetaMagic = oItm==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    int nRaise = 4;
    int nDuration = GetTotalCasterLevel(OBJECT_SELF);

    //GoLoT: Comprobar pocion mayor
    if(oItm != OBJECT_INVALID && (GetBaseItemType(oItm) == BASE_ITEM_POTIONS || GetBaseItemType(oItm) == BASE_ITEM_ENCHANTED_POTION)) {
        //if(GetMetaMagicFeat() == METAMAGIC_EMPOWER)
        if(nDuration == 20)
            nMetaMagic = METAMAGIC_EMPOWER;
    }

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nRaise = 6; //Damage/Healing is +50%
    }
    else if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    // No apilamiento de conjuros similares
    RemoveEffectsFromSpell(oTarget, 355);
    RemoveEffectsFromSpell(oTarget, 358);
    RemoveEffectsFromSpell(oTarget, 1048);

    // POTENCIACION DE CONJURO
    if(oItm == OBJECT_INVALID && GetItemPossessedBy(OBJECT_SELF, "extractobaya")!= OBJECT_INVALID)
    {
        object oIngrediente = GetItemPossessedBy(OBJECT_SELF, "extractobaya");
        DestroyObject(oIngrediente);

        effect eSagrado = EffectVisualEffect(87); //explosion naranja
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSagrado, oTarget);

        nRaise = nRaise + d2();
    }

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_OWLS_WISDOM, FALSE));

    //Apply the VFX impact and effects
    DoNoStackAbilityBonus(OBJECT_SELF, oTarget, nRaise, ABILITY_WISDOM, HoursToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, HoursToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
