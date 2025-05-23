int Blig_UndeadWildShapeLarge = 1291;
int Blig_UndeadWildShapeIncorp = 1292;
int Blig_UndeadWildShapeHuge = 1293;
int Blig_UndeadWildShape = 1294;
int Feat_Blig_UndeadWildShape = 1402;
int Feat_Blig_S_BadgerShape = 1295;
int Feat_Blig_S_BatShape = 1296;
int Feat_Blig_S_Boar = 1297;
int Feat_Blig_S_Rat = 1298;
int Feat_Blig_L_Wolf = 1299;
int Feat_Blig_L_Tiger = 1300;
int Feat_Blig_L_Panther = 1301;
int Feat_Blig_H_Bear = 1303;
int Feat_Blig_H_PackLeader = 1304;

#include "x2_inc_itemprop"
#include "x3_inc_horse"

void main()
{
    int nSpell = GetSpellId();
    if(nSpell > 1298)
        if(!GetHasFeat(Feat_Blig_UndeadWildShape)) {
            FloatingTextStringOnCreature("No te quedan usos diarios de forma salvaje.", OBJECT_SELF, FALSE);
            return;
        }
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect ePoly;
    int nPoly = -1;
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetLevelByClass(CLASS_TYPE_DRUID) + GetLevelByClass(CLASS_TYPE_BLIGHTER);
    if (!GetLocalInt(GetModule(),"X3_NO_SHAPESHIFT_SPELL_CHECK"))
    {
        if (HorseGetIsMounted(oTarget))
        {
            if (GetIsPC(oTarget)) FloatingTextStrRefOnCreature(111982,oTarget,FALSE);
            return;
        }
    }
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;
    }

    if(nSpell == Feat_Blig_S_BadgerShape)
    {
        nPoly = POLYMORPH_TYPE_BADGER;
        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_BADGER;
        }
    } else if(nSpell == Feat_Blig_S_BatShape)
    {
        FloatingTextStringOnCreature("Implementar polymorph: Murcielago", OBJECT_SELF, FALSE);
    } else if(nSpell == Feat_Blig_S_Boar) {
        nPoly = 121;
        if (nDuration >= 12)
        {
            nPoly = 126;
        }
    } else if(nSpell == Feat_Blig_S_Rat) {
        FloatingTextStringOnCreature("Implementar polymorph: Rata", OBJECT_SELF, FALSE);
    } else if(nSpell == Feat_Blig_L_Wolf) {
        nPoly = 120;

        if (nDuration >= 12)
        {
            nPoly = 125;
        }
    } else if(nSpell == Feat_Blig_L_Tiger) {
        FloatingTextStringOnCreature("Implementar polymorph: Tigre", OBJECT_SELF, FALSE);
    } else if(nSpell == Feat_Blig_L_Panther) {
        nPoly = 119;
        if (nDuration >= 12)
        {
            nPoly = 124;
        }
    } else if(nSpell == Feat_Blig_H_Bear) {
        nPoly = 118;
        if (nDuration >= 12)
        {
            nPoly = 123;
        }
    } else if(nSpell == Feat_Blig_H_PackLeader) {
        FloatingTextStringOnCreature("Implementar polymorph: Huargo", OBJECT_SELF, FALSE);
    } else {
        FloatingTextStringOnCreature("Forma no implementada!", OBJECT_SELF, FALSE);
    }
    if (nPoly == -1) return;

    DecrementRemainingFeatUses(OBJECT_SELF, Feat_Blig_UndeadWildShape);

    ePoly = EffectPolymorph(nPoly);
    ePoly = ExtraordinaryEffect(ePoly);
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_WILD_SHAPE, FALSE));

    int bWeapon = StringToInt(Get2DAString("polymorph","MergeW",nPoly)) == 1;
    int bArmor  = StringToInt(Get2DAString("polymorph","MergeA",nPoly)) == 1;
    int bItems  = StringToInt(Get2DAString("polymorph","MergeI",nPoly)) == 1;

    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oArmorOld = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);
    object oRing1Old = GetItemInSlot(INVENTORY_SLOT_LEFTRING,OBJECT_SELF);
    object oRing2Old = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,OBJECT_SELF);
    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,OBJECT_SELF);
    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,OBJECT_SELF);
    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,OBJECT_SELF);
    object oBeltOld = GetItemInSlot(INVENTORY_SLOT_BELT,OBJECT_SELF);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,OBJECT_SELF);
    object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);
    if (GetIsObjectValid(oShield))
    {
        if (GetBaseItemType(oShield) !=BASE_ITEM_LARGESHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_SMALLSHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_TOWERSHIELD)
        {
            oShield = OBJECT_INVALID;
        }
    }
    ClearAllActions();
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, OBJECT_SELF, HoursToSeconds(nDuration));
    object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);
    if (bWeapon)
    {
            IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew, TRUE);
    }
    if (bArmor)
    {
        IPWildShapeCopyItemProperties(oShield,oArmorNew);
        IPWildShapeCopyItemProperties(oHelmetOld,oArmorNew);
        IPWildShapeCopyItemProperties(oArmorOld,oArmorNew);
    }
    if (bItems)
    {
        IPWildShapeCopyItemProperties(oRing1Old,oArmorNew);
        IPWildShapeCopyItemProperties(oRing2Old,oArmorNew);
        IPWildShapeCopyItemProperties(oAmuletOld,oArmorNew);
        IPWildShapeCopyItemProperties(oCloakOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBootsOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBeltOld,oArmorNew);
    }
    IPSafeAddItemProperty(oArmorNew, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
    IPSafeAddItemProperty(oArmorNew, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
    IPSafeAddItemProperty(oArmorNew, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DEATH_MAGIC), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
    IPSafeAddItemProperty(oArmorNew, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
    IPSafeAddItemProperty(oArmorNew, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
    IPSafeAddItemProperty(oArmorNew, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
    IPSafeAddItemProperty(oArmorNew, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
    IPSafeAddItemProperty(oArmorNew, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

    IPSafeAddItemProperty(oArmorNew, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_BLUDGEONING, 5), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
    IPSafeAddItemProperty(oArmorNew, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

}