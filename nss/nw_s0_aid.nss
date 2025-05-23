//::///////////////////////////////////////////////
//:: Aid
//:: NW_S0_Aid.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target creature gains +1 to attack rolls and
    saves vs fear. Also gain +1d8 temporary HP.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 6, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
#include "vgz_libreria"
#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);

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
    if(oItm == OBJECT_INVALID && GetItemPossessedBy(OBJECT_SELF, "extractoflorlum") != OBJECT_INVALID)
    {
        pentagramahaciasi(GetLocation(OBJECT_SELF), VFX_BEAM_HOLY, 1.0);
        SendMessageToPC(OBJECT_SELF, "!El conjuro parece haberse potenciado con el extracto de flor luminosa!");
    }

    //Declare major variables
    int nDuration = GetTotalCasterLevel(OBJECT_SELF);
    int nBonus = d8(1);
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nBonus = 8;//Damage is at max
    }
    else if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nBonus = nBonus + (nBonus/2); //Damage/Healing is +50%
    }
    else if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    object oTarget = GetSpellTargetObject();

    effect eSave;
    effect eAttack = EffectAttackIncrease(1);
    effect eHP = EffectTemporaryHitpoints(nBonus);
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);

    // POTENCIACION DE CONJURO
    if(oItm == OBJECT_INVALID && GetItemPossessedBy(OBJECT_SELF, "extractoflorlum")!= OBJECT_INVALID)
    {
        object oIngrediente = GetItemPossessedBy(OBJECT_SELF, "extractoflorlum");
        DestroyObject(oIngrediente);

        effect eSagrado = EffectVisualEffect(55); //sagrado
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSagrado, oTarget);

        eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 3, SAVING_THROW_TYPE_FEAR); // Salvacion de miedo + 2
    }
    else eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);

    effect eLink = EffectLinkEffects(eAttack, eSave);
    eLink = EffectLinkEffects(eLink, eDur);

    // No se apila
    RemoveEffectsFromSpell(oTarget, SPELL_AID);
	   AntiStackMoral(oTarget);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_AID, FALSE));

    //Apply the VFX impact and effects

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, TurnsToSeconds(nDuration));
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
