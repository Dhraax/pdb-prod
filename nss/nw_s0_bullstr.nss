/////////////////////////////////////////////////
// Bull's Strength
//-----------------------------------------------
// Created By: Brenon Holmes
// Created On: 10/12/2000
// Description: This script changes someone's strength
// Updated 2003-07-17 to fix stacking issue with blackguard
/////////////////////////////////////////////////

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
        SendMessageToPC(OBJECT_SELF,ColorToken(33,33,180) + "¡El conjuro parece haberse potenciado con el extracto del fruto fantasma!</c>");
    }

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(1263);
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
    RemoveEffectsFromSpell(oTarget, 9);
    RemoveEffectsFromSpell(oTarget, 360);
    RemoveEffectsFromSpell(oTarget, 614);
    RemoveEffectsFromSpell(oTarget, 1043);
    RemoveEffectsFromSpell(oTarget, 1082);

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nModify = 6;
    }
    if (nMetaMagic == METAMAGIC_EXTEND)
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

    //Signal the spell cast at event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BULLS_STRENGTH, FALSE));

    //Appyly the VFX impact and ability bonus effect
    DoNoStackAbilityBonus(OBJECT_SELF, oTarget, nModify, ABILITY_STRENGTH, fDuration);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
