//::///////////////////////////////////////////////
//:: Wild Shape
//:: NW_S2_WildShape
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Allows the Druid to change into animal forms.

    Updated: Sept 30 2003, Georg Z.
      * Made Armor merge with druid to make forms
        more useful.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 22, 2002
//:://////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified Date: January 15th-16th, 2008
//:://////////////////////////////////////////////
/*
    Modified to insure no shapeshifting spells are castable upon
    mounted targets.  This prevents problems that can occur due
    to dismounting after shape shifting, or other issues that can
    occur due to preserved appearances getting out of synch.

    This can additional check can be disabled by setting the variable
    X3_NO_SHAPESHIFT_SPELL_CHECK to 1 on the module object.  If this
    variable is set then this script will function as it did prior to
    this modification.

*/

#include "x2_inc_itemprop"
#include "x3_inc_horse"
#include "lib_disguise"

void main()
{
    if(GetLevelByClass(51) > 0) {
        FloatingTextStringOnCreature("Un ex-druida no puede usar habilidades de druida!", OBJECT_SELF, FALSE);
        return;
    }
    //Declare major variables
    int nSpell = GetSpellId();
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect ePoly;
    int nPoly;
    int nMetaMagic = GetMetaMagicFeat();
    int nDruidLevel = GetLevelByClass(CLASS_TYPE_DRUID);
    int nWizardLevel = GetLevelByClass(CLASS_TYPE_WIZARD);
    int nSorcererLevel = GetLevelByClass(CLASS_TYPE_SORCERER);
    int nMMFLevel = GetLevelByClass(63);

    int nDuration = 0;

    if(nDruidLevel >= nWizardLevel && nDruidLevel >= nSorcererLevel && nDruidLevel >= nMMFLevel) nDuration = nDruidLevel;
    else if(nWizardLevel >= nDruidLevel && nWizardLevel >= nSorcererLevel && nWizardLevel >= nMMFLevel) nDuration = nWizardLevel;
    else if(nSorcererLevel >= nWizardLevel && nSorcererLevel >= nDruidLevel && nSorcererLevel >= nMMFLevel) nDuration = nSorcererLevel;
    else if(nMMFLevel >= nWizardLevel && nMMFLevel >= nSorcererLevel && nMMFLevel >= nDruidLevel) nDuration = nMMFLevel;

    string sNombre;
    if (!GetLocalInt(GetModule(),"X3_NO_SHAPESHIFT_SPELL_CHECK"))
    { // check to see if abort due to being mounted
        if (HorseGetIsMounted(oTarget))
        { // abort
            if (GetIsPC(oTarget)) FloatingTextStrRefOnCreature(111982,oTarget,FALSE);
            return;
        } // abort
    } // check to see if abort due to being mounted
    /*//Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    } */

    //Determine Polymorph subradial type
    if(nSpell == 401)
    {
        nPoly = 109; //POLYMORPH_TYPE_BLACK_BEAR
        if (nDuration >= 8 && nDuration < 12)
        {
            nPoly = POLYMORPH_TYPE_BROWN_BEAR;
            sNombre = "Oso Pardo";
        }
        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_BROWN_BEAR;
            sNombre = "Oso Pardo Terrible";
        }

    }
    else if (nSpell == 402)
    {
        nPoly = POLYMORPH_TYPE_PANTHER;
        sNombre = "Pantera";
        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_PANTHER;
            sNombre = "Pantera Terrible";
        }
    }
    else if (nSpell == 403)
    {
        nPoly = POLYMORPH_TYPE_WOLF;
        sNombre = "Lobo";
        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_WOLF;
            sNombre = "Lobo Terrible";
        }
    }
    else if (nSpell == 404)
    {
        nPoly = POLYMORPH_TYPE_BOAR;
        sNombre = "Oso";
        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_BOAR;
            sNombre = "Oso Terrible";
        }
    }
    else if (nSpell == 405)
    {
        nPoly = POLYMORPH_TYPE_BADGER;
        sNombre = "Tejon";
        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_BADGER;
            sNombre = "Tejon Terrible";
        }
    }
    ePoly = EffectPolymorph(nPoly);
    ePoly = ExtraordinaryEffect(ePoly);
    //Fire cast spell at event for the specified target
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



    //Apply the VFX impact and effects
    ClearAllActions(); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, OBJECT_SELF, HoursToSeconds(nDuration));
    string sNombreReal = GetName(OBJECT_SELF, TRUE);
    string sNombreFalso = PB_Disguise_GetNameOverride(OBJECT_SELF);
    PB_Disguise_SetNameOverride(OBJECT_SELF, sNombre, NWNX_RENAME_PLAYERNAME_OVERRIDE);
    WriteTimestampedLogEntry("Informe: El PJ: " + sNombreReal + " de la cuenta: "  + GetPCPlayerName(OBJECT_SELF) + " se ha transformado en : " + sNombreFalso + ".");
    SetLocalInt(OBJECT_SELF, "POLY_ON", 1);
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

}
