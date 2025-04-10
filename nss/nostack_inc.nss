#include "x2_inc_itemprop"
#include "nw_o0_itemmaker"
#include "nw_i0_spells"

struct HighestAbilityItem
{
// for returning the highest scoring ability item of a particular ability score
object oItem;
int nScore;
};

struct ItemProperty
{
// for returning an item propery and modifier
    itemproperty ip;
    int nModifier;
    int nFound;
};
//This function safely adds an ability bonus effect to a target, checking for stacking
void DoNoStackAbilityBonus(object oCaster, object oTarget, int nModifier, int nAbility, float fDuration);
//Esta función añade un bonificador a una habilidad sin que se apile a los objetos.
void DoNoStackSkillBonus(object oCaster, object oTarget, int nModifier, int nSkill, float fDuration, int iSpell = -1);
//Esta función añade una bonificacin de salvacin especifica o universal (si es 0) al objetivo sin apilarla con objetos.
void DoNoStackSavingThrowBonus(object oCaster, object oTarget, int nModifier, int nSaving, float fDuration);
// removes ability bonus spells for the ability constant nAbility
void RemoveMagicAbilityBonus(object oTarget, int nAbility);
// elimina los bonos de habilidad de indentificacion nSkill
void RemoveMagicSkillBonus(object oPC, int nSkill, int iSpell = -1);
// elimina los bonos de salvacion de indentificacion nSvaing, 0 es universal.
void RemoveMagicSavingBonus(object oPC, int nSaving);
// applies a penalty of nPenalty score to ability nAbility
void ApplyAbilityPenalty(object oItem, int nPenalty, int nAbility);
// removes a property of nItemPropertyType and Subtype from oItem and returns the property's modifier
int RemovePropertyAndReturnModifier(object oItem, int nItemPropertyType, int nItemPropertySubType = -1);
//Finds the highest bonus item of nType and nSubtype and returns it as well as its score
struct HighestAbilityItem GetHighestBonusItem(object oPC, int nType, int nSubType);
//Finds the highest bonus item of nType and nSubtype on a PC, excluding one item
struct HighestAbilityItem GetHighestBonusItemExcludeOne(object oPC, int nType, int nSubType, object oExclude);
//Finds the highest bonus item of nType and nSubtype on a PC, excluding two item
struct HighestAbilityItem GetHighestBonusItemExcludeTwo(object oPC, int nType, int nSubType, object oExclude, object oExclude2);
//Finds the highest bonus item of nType and nSubtype on a PC, excluding three item
struct HighestAbilityItem GetHighestBonusItemExcludeThree(object oPC, int nType, int nSubType, object oExclude, object oExclude2, object oExclude3);
//Gets the total bonus from all items to a particular ability score
int GetTotalAbilityItemBonus(object oPC, int nAbility, int nExclude=0);
//Obtiene la salvaciones de todos los objeto de una salvacion concreta.
int GetTotalSavingSpecificItemBonus(object oPC, int nSaving, int nIndex=0);
//Obtiene la regeneracin de todos los objetos
int GetTotalRegItemBonus(object oPC, int nReg);
//Gets the item property of nType and nSubType on oItem
struct ItemProperty GetItemProperty(object oItem, int nType, int nSubType);
//Restores all items to original state. If nSkill is 0, ability items, if it's 1, skill items. nSkill=2 Salvasciones.
void RestoreAllItems(object oPC, int nAbility, int nSkill = 0);
//Restores an ability item that's been penalized by this script
void RestoreAbilityItem(object oItem, int nAbility);
//Checks what ability bonuses an item has and writes to nAbilityBonus0-5, local vars on the item
void HasItemAbilityBonus(object oItem);
//Checks of an item has skill bonuses on it and writes to nSkillBonus0-26, local vars on the item
void HasItemSkillBonus(object oItem);
//Chequea si el objeto tiene salvaciones concretas
void HasItemSavingBonus(object oItemEquipped);
//Chequea si el objeto tiene salvaciones universales
void HasItemSavingUniversal(object oItemEquipped);
//chequea si el objeto tiene regeneracin
void HasItemRegBonus(object oItemEquipped);
//Restores a skill item neutralized by this script
void RestoreSkillItem(object oItem, int nSkill);
//Restaura una salvacion
void RestoreSavingThrowItem(object oItem, int nSkill);
//Restaura una regeneracion
void RestoreRegItem(object oItem, int nSkill);
//Neutralizes a skill item and sets its old bonus to
//nSkillX local var on the item where X is the row number of the skill from 0-26
void NeutralizeSkillItem(object oItem, int nSkill);
//Neutraliza una salvacion concreta de un objeto
void NeutralizeSavingThrowItem(object oItem, int nSkill);
//Neutraliza una caracteristica de un objeto
void NeutralizeAllAbility( object oItem, int nAbility);
//Neutraliza una regeneracion
void NeutralizeRegItem( object oItem, int nReg);
//Neutraliza todos los objetos con una salvacion concreta, menos uno
void NeutralizeAllSavingThrowExcludeOne(object oPC, int nSkill, object oExclude);
//Neutraliza todos los objetos con una salvacion concreta, menos dos
void NeutralizeAllSavingThrowExcludeTwo(object oPC, int nSkill, object oExclude, object oExclude2);
//Neutraliza todos los objetos con una regeneracion, menos uno
void NeutralizeAllRegExcludeOne(object oPC, int nReg, object oExclude);
//Neutraliza todos los objetos con una regeneracion, menos dos
void NeutralizeAllRegExcludeTwo(object oPC, int nReg, object oExclude, object oExclude2);
//Neutraliza todos los objetos con una regeneracion, menos tres
void NeutralizeAllRegExcludeThree(object oPC, int nReg, object oExclude, object oExclude2, object oExclude3);
//Neutraliza todos los objetos con una regeneracion, menos cuatro
void NeutralizeAllRegExcludeFour(object oPC, int nReg, object oExclude, object oExclude2, object oExclude3, object oExclude4);
//Neutralizes all items but one on a PC for the skill nSkill
void NeutralizeAllExcludeOne(object oPC, int nSkill, object oExclude);
//Neutralizes all items but two on a PC for the skill nSkill
void NeutralizeAllExcludeTwo(object oPC, int nSkill, object oExclude, object oExclude2);
//Neutraliza todos los objetos excepto uno
void NeutralizeAllAbilityExcludeOne( object oPC, int nAbility, object oExclude);
//Neutraliza todos los objetos excepto dos
void NeutralizeAllAbilityExcludeTwo( object oPC, int nAbility, object oExclude, object oExclude2);

//This function is to be placed in the OnEquip event if you want to ensure 3E skill stacking
//MAKE SURE YOU PLACE NoSkillStackOnUnEquip in the corresponding OnUnEquip event
void NoSkillStackOnEquip(object oPCEquipper, object oItemEquipped)
{
    int nHasSkill = 0; //do they have the skill?
    struct HighestAbilityItem iHighest; //highest skill bonus score item
    int i; // to cycle skills from 0 to 38

    HasItemSkillBonus(oItemEquipped);

    for (i=0; i<39; ++i) {
        //Does the item equipped have a SkillBonus of type i?
        nHasSkill = GetLocalArrayInt(oItemEquipped, "nSkillBonus", i);
        if (nHasSkill) {
            AssignCommand(oItemEquipped, RemoveMagicSkillBonus(oPCEquipper, i));
            //Restore all the neutralized skill items
            RestoreAllItems(oPCEquipper, i, 1);
            //find the highest skill item for skill i and neutralize all items except it
            iHighest = GetHighestBonusItem(oPCEquipper, ITEM_PROPERTY_SKILL_BONUS, i);
            NeutralizeAllExcludeOne(oPCEquipper, i, iHighest.oItem);
        }
        nHasSkill = 0;
    }
return;

}
//This function is to be placed in the OnEquip event if you want to ensure 3E Ability stacking
//MAKE SURE YOU PLACE NoAbilityStackOnUnEquip in the corresponding OnUnEquip event
void NoAbilityStackOnEquip(object oPCEquipper, object oItemEquipped)
{
    struct HighestAbilityItem iHighest;
    int i;
    int nTotal = 0; //total ability bonus
    int nDifference = 0; //difference between total and highest single item
    int nHasAbility = 0; //does the item even have an ability bonus?
    HasItemAbilityBonus(oItemEquipped); //set local vars on object if it has ability bonuses

    for (i=0;i<6;++i) {
        nHasAbility = GetLocalArrayInt(oItemEquipped, "nAbilityBonus", i);
        if (nHasAbility) {
            // Remove buffs for the corresponding ability score.
            AssignCommand(oItemEquipped, RemoveMagicAbilityBonus(oPCEquipper, i));
            RestoreAllItems(oPCEquipper, i);
            // get the highest item and total and the difference between them
            iHighest = GetHighestBonusItem(oPCEquipper, ITEM_PROPERTY_ABILITY_BONUS, i);
            NeutralizeAllAbilityExcludeOne(oPCEquipper, i, iHighest.oItem);
/*            nTotal = GetTotalAbilityItemBonus(oPCEquipper, i);
            nDifference = nTotal - iHighest.nScore;
            // If there is a difference, compensate with a penalty on the highest item.
            if (nDifference > 0){
                ApplyAbilityPenalty(iHighest.oItem, nDifference, i);
                SendMessageToPC(oPCEquipper, "Te has equipado múltiples objetos que otorgan un bonificador de característica. No se apilarán.");
            }*/
        }
        nHasAbility = 0; //loop again
    }
}

//Esta funcion debe colocarse en el evento de OnEquip para eliminar el apilamiento de salvaciones.
//ASEGURARSE DE QUE SE COLOCA NoSavingThrowStackOnUnEquip en el correspondiente evento OnUnEquip
void NoSavingThrowStackOnEquip(object oPCEquipper, object oItemEquipped)
{
    int nHasSaving = 0; //tiene Salvacion?
    struct HighestAbilityItem iHighest;
    int i;
    int nTotal = 0; //total saving bonus
    int nDifference = 0; //difference between total and highest single item

    //Salvaciones universales
    HasItemSavingUniversal(oItemEquipped);
    if(GetLocalInt(oItemEquipped, "nSavingUniversal")){
            AssignCommand(oItemEquipped, RemoveMagicSavingBonus(oPCEquipper, 0));
            RestoreAllItems(oPCEquipper, ITEM_PROPERTY_SAVING_THROW_BONUS, 2);
            // get the highest item and total and the difference between them
            iHighest = GetHighestBonusItem(oPCEquipper, ITEM_PROPERTY_SAVING_THROW_BONUS, SAVING_THROW_ALL);
            NeutralizeAllSavingThrowExcludeOne(oPCEquipper, SAVING_THROW_ALL, iHighest.oItem);
    }

    //Salvaciones especificas
    HasItemSavingBonus(oItemEquipped); //set local vars on object if it has saving bonuses
    for (i=1;i<4;++i) {
        nHasSaving = GetLocalArrayInt(oItemEquipped, "nSavingThrowArray", i);

        if (nHasSaving) {
            AssignCommand(oItemEquipped, RemoveMagicSavingBonus(oPCEquipper, i));
            // Remove buffs for the corresponding saving score.
            RestoreAllItems(oPCEquipper, i, 2);
            // get the highest item and total and the difference between them
            iHighest = GetHighestBonusItem(oPCEquipper, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, i);
            NeutralizeAllSavingThrowExcludeOne(oPCEquipper, i, iHighest.oItem);
            iHighest = GetHighestBonusItem(oPCEquipper, ITEM_PROPERTY_SAVING_THROW_BONUS, SAVING_THROW_ALL);
            NeutralizeAllSavingThrowExcludeOne(oPCEquipper, SAVING_THROW_ALL, iHighest.oItem);
        }
        nHasSaving = 0; //loop again
    }
}
//Esta funcin debe colocarse en el evento de OnEquip para eliminar el apilamiento de regeneracin.
//ASEGURARSE DE QUE SE COLOCA NoREgStackOnEquip en el correspondiente evento OnUnEquip
void NoRegStackOnEquip(object oPCEquipper, object oItemEquipped, int regMax)
{
    int nHasReg = 0; //Tiene regeneracion?
    struct HighestAbilityItem iHighest; //Bono de regeneracion mas alto
    struct HighestAbilityItem iHighest2; //segundo bono mas alto
    struct HighestAbilityItem iHighest3; //segundo bono mas alto
    int i;
    itemproperty ipReg;

    HasItemRegBonus(oItemEquipped);
    //Tiene el objeto equipado regeneracion?
    if(GetLocalInt(oItemEquipped, "nReg") ){
        RestoreAllItems(oPCEquipper, 3, 3);
        iHighest = GetHighestBonusItem(oPCEquipper, ITEM_PROPERTY_REGENERATION,-1);
        iHighest2 = GetHighestBonusItemExcludeOne(oPCEquipper, ITEM_PROPERTY_REGENERATION,-1, iHighest.oItem);
        iHighest3 = GetHighestBonusItemExcludeTwo(oPCEquipper, ITEM_PROPERTY_REGENERATION,-1, iHighest.oItem, iHighest2.oItem);
        switch (regMax){
            case 1:
                NeutralizeAllRegExcludeOne(oPCEquipper, 1, iHighest.oItem);
            break;
            case 2:
                if(iHighest.nScore == 3){
                    NeutralizeAllRegExcludeOne(oPCEquipper, 3, iHighest.oItem);
                    NeutralizeRegItem(iHighest.oItem, 0);
                    // le quitamos la reg 3 y le ponemos 1
                    ipReg = ItemPropertyRegeneration(2);
                    IPSafeAddItemProperty(iHighest.oItem, ipReg);
                    // pero guardamos que es 3 aunque tenga 2 para recueparlo
                    SetLocalInt( iHighest.oItem, "nReg", 3);
                }
                if(iHighest.nScore == 2) NeutralizeAllRegExcludeOne(oPCEquipper, 2, iHighest.oItem);
                if(iHighest.nScore ==1 && iHighest2.nScore == 1) {
                    NeutralizeAllRegExcludeTwo(oPCEquipper, 2, iHighest.oItem, iHighest2.oItem);
                }
            break;
            case 3:
                if(iHighest.nScore == 3) NeutralizeAllRegExcludeOne(oPCEquipper, 3, iHighest.oItem);
                if(iHighest.nScore == 2){
                    if(iHighest2.nScore == 1) NeutralizeAllRegExcludeTwo(oPCEquipper, 2, iHighest.oItem, iHighest2.oItem);
                    else {
                         NeutralizeAllRegExcludeTwo(oPCEquipper, 2, iHighest.oItem, iHighest2.oItem);
                         NeutralizeRegItem(iHighest2.oItem, 0);
                         // le quitamos la reg 2 y le ponemos 1
                         ipReg = ItemPropertyRegeneration(1);
                         IPSafeAddItemProperty(iHighest2.oItem, ipReg);
                         // pero guardamos que es 2 aunque tenga 1 para recuperarlo
                         SetLocalInt( iHighest2.oItem, "nReg", 2);
                    }

                }
                if(iHighest.nScore == 1){
                    iHighest2 = GetHighestBonusItemExcludeOne(oPCEquipper, ITEM_PROPERTY_REGENERATION,-1, iHighest.oItem);
                    NeutralizeAllRegExcludeThree(oPCEquipper, 1, iHighest.oItem, iHighest2.oItem, iHighest3.oItem);
                }
            break;
        }
    }

}

//This function MUST be in the OnUnEquip event if you are using NoSkillStackOnEquip
void NoSkillStackOnUnEquip(object oPCEquipper, object oItemEquipped)
{
//This is similar to the Equip event, except that you must compensate for the fact
//that the unequipped item is still on the character when this even triggers.
//Thus, you must exclude it when calculating the bonuses.
    int i;
    int nHasSkill = 0;
    struct HighestAbilityItem iHighest;

    for (i=0; i<39; ++i) {
        nHasSkill = GetLocalArrayInt(oItemEquipped, "nSkillBonus", i);
        if (nHasSkill) {
            RestoreAllItems(oPCEquipper, i, 1);
            iHighest = GetHighestBonusItemExcludeOne(oPCEquipper, ITEM_PROPERTY_SKILL_BONUS, i, oItemEquipped);
            NeutralizeAllExcludeTwo(oPCEquipper, i, iHighest.oItem, oItemEquipped);
        }
        nHasSkill = 0;
    }
    return;
}

//This function MUST be in the OnUnEquip event if you are using NoAbilityStackOnEquip
void NoAbilityStackOnUnEquip(object oPCEquipper, object oItemEquipped)
{
//See noSkillStackOnUnEquip for explanation of the exclusions of particular items
//Bioware writes very strange Event triggers
    struct HighestAbilityItem iHighest;
    struct ItemProperty isProp;
    int i;
    int nUnEquipValue = 0;
    int nTotal = 0;
    int nDifference = 0;
    int nHasAbility = 0;

    for (i=0; i<6;++i) {
        nHasAbility = GetLocalArrayInt(oItemEquipped, "nAbilityBonus", i);
        if (nHasAbility) {
            RestoreAllItems(oPCEquipper, i, 0);
            iHighest = GetHighestBonusItemExcludeOne(oPCEquipper, ITEM_PROPERTY_ABILITY_BONUS, i, oItemEquipped);
            NeutralizeAllAbilityExcludeTwo(oPCEquipper, i, iHighest.oItem, oItemEquipped);
//            RestoreAbilityItem(oItemEquipped, i);
/*            isProp = GetItemProperty(oItemEquipped, ITEM_PROPERTY_ABILITY_BONUS, i);
            nUnEquipValue = isProp.nModifier;
            RestoreAbilityItem(oItemEquipped, i);
            iHighest = GetHighestBonusItemExcludeOne(oPCEquipper, ITEM_PROPERTY_ABILITY_BONUS, i, oItemEquipped);
            nTotal = GetTotalAbilityItemBonus(oPCEquipper, i, nUnEquipValue);
            nDifference = nTotal - iHighest.nScore;
            RestoreAbilityItem(iHighest.oItem, i);
            if (nDifference > 0)
                ApplyAbilityPenalty(iHighest.oItem, nDifference, i);*/
        }
        nHasAbility = 0;
    }
    return;
}
//Esta funcion DEBE estar en el evento de OnUnEquip si usas NoSavingThrowStackOnEquip
void NoSavingThrowStackOnUnEquip(object oPCEquipper, object oItemEquipped)
{
//This is similar to the Equip event, except that you must compensate for the fact
//that the unequipped item is still on the character when this even triggers.
//Thus, you must exclude it when calculating the bonuses.
    int i;
    int nHasSavingThrow = 0;
    struct HighestAbilityItem iHighest;

    //salvaciones universales
    HasItemSavingUniversal(oItemEquipped);
    if(GetLocalInt(oItemEquipped, "nSavingUniversal")){
        RestoreAllItems(oPCEquipper, ITEM_PROPERTY_SAVING_THROW_BONUS, 2);
        iHighest = GetHighestBonusItemExcludeOne(oPCEquipper, ITEM_PROPERTY_SAVING_THROW_BONUS, SAVING_THROW_ALL, oItemEquipped);
        NeutralizeAllSavingThrowExcludeTwo(oPCEquipper, SAVING_THROW_ALL, iHighest.oItem, oItemEquipped);
    }

    //Salvaciones concretas
    for (i=1; i<4; ++i) {
        nHasSavingThrow = GetLocalArrayInt(oItemEquipped, "nSavingThrowArray", i);
        if (nHasSavingThrow) {
            RestoreAllItems(oPCEquipper, i, 2);
            iHighest = GetHighestBonusItemExcludeOne(oPCEquipper, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, i, oItemEquipped);
            NeutralizeAllSavingThrowExcludeTwo(oPCEquipper, i, iHighest.oItem, oItemEquipped);
            iHighest = GetHighestBonusItemExcludeOne(oPCEquipper, ITEM_PROPERTY_SAVING_THROW_BONUS, SAVING_THROW_ALL, oItemEquipped);
            NeutralizeAllSavingThrowExcludeTwo(oPCEquipper, SAVING_THROW_ALL, iHighest.oItem, oItemEquipped);
        }
        nHasSavingThrow = 0;
    }
    return;
}
//Esta funcion DEBE estar en el evento de OnUnEquip si usas NoRgeStackOnEquip
void NoRegStackOnUnEquip(object oPCEquipper, object oItemEquipped, int regMax)
{
    int nHasReg = 0; //Tiene regeneracion?
    struct HighestAbilityItem iHighest; //Bono de regeneracion mas alto
    struct HighestAbilityItem iHighest2; //segundo bono mas alto
    struct HighestAbilityItem iHighest3; //segundo bono mas alto
    int i;
    itemproperty ipReg;

    HasItemRegBonus(oItemEquipped);
    //Tiene el objeto equipado regeneracion?
    if(GetLocalInt(oItemEquipped, "nReg") ){
        RestoreAllItems(oPCEquipper, 3, 3);
        iHighest = GetHighestBonusItemExcludeOne(oPCEquipper,ITEM_PROPERTY_REGENERATION, -1, oItemEquipped);
        iHighest2 = GetHighestBonusItemExcludeTwo(oPCEquipper, ITEM_PROPERTY_REGENERATION,-1, oItemEquipped, iHighest.oItem);
        iHighest3 = GetHighestBonusItemExcludeThree(oPCEquipper, ITEM_PROPERTY_REGENERATION,-1,  oItemEquipped, iHighest.oItem, iHighest2.oItem);

        switch (regMax){
            case 1:
                NeutralizeAllRegExcludeTwo(oPCEquipper, 1, oItemEquipped, iHighest.oItem);
            break;
            case 2:
                if(iHighest.nScore == 3){
                    NeutralizeAllRegExcludeTwo(oPCEquipper, 3, oItemEquipped, iHighest.oItem);
                    NeutralizeRegItem(iHighest.oItem, 0);
                    // le quitamos la reg 3 y le ponemos 2
                    ipReg = ItemPropertyRegeneration(2);
                    IPSafeAddItemProperty(iHighest.oItem, ipReg);
                    // pero guardamos que es 3 aunque tenga 2 para recueparlo
                    SetLocalInt( iHighest.oItem, "nReg", 3);
                }
                if(iHighest.nScore == 2) NeutralizeAllRegExcludeTwo(oPCEquipper, 2, oItemEquipped, iHighest.oItem);
                if(iHighest.nScore ==1 && iHighest2.nScore == 1) {
                    NeutralizeAllRegExcludeThree(oPCEquipper, 2, oItemEquipped, iHighest.oItem, iHighest2.oItem);
                }
            break;
            case 3:
                if(iHighest.nScore == 3) NeutralizeAllRegExcludeTwo(oPCEquipper, 3, oItemEquipped, iHighest.oItem);
                if(iHighest.nScore == 2){
                    if(iHighest2.nScore == 1) NeutralizeAllRegExcludeThree(oPCEquipper, 2, oItemEquipped, iHighest.oItem, iHighest2.oItem);
                    else {
                         NeutralizeAllRegExcludeThree(oPCEquipper, 2, oItemEquipped, iHighest.oItem, iHighest2.oItem);
                         NeutralizeRegItem(iHighest2.oItem, 0);
                         // le quitamos la reg 2 y le ponemos 1
                         ipReg = ItemPropertyRegeneration(1);
                         IPSafeAddItemProperty(iHighest2.oItem, ipReg);
                         // pero guardamos que es 2 aunque tenga 1 para recuperarlo
                         SetLocalInt( iHighest2.oItem, "nReg", 2);
                    }

                }
                if(iHighest.nScore == 1){
                    iHighest2 = GetHighestBonusItemExcludeTwo(oPCEquipper, ITEM_PROPERTY_REGENERATION,-1, oItemEquipped, iHighest.oItem);
                    NeutralizeAllRegExcludeFour(oPCEquipper, 1, oItemEquipped, iHighest.oItem, iHighest2.oItem, iHighest3.oItem);
                }
            break;
        }
        RestoreRegItem(oItemEquipped, 3);
    }

}

void DoNoStackAbilityBonus(object oCaster, object oTarget, int nModifier, int nAbility, float fDuration)
{
    effect eAbil;
    struct HighestAbilityItem sItem;

    sItem = GetHighestBonusItem(oTarget, ITEM_PROPERTY_ABILITY_BONUS, nAbility);
    nModifier -= sItem.nScore;
    RemoveMagicAbilityBonus(oTarget, nAbility);
    if (nModifier < 1)
        SendMessageToPC(oCaster, "¡El bonificador de característica del objetivo es muy poderoso para este conjuro, no tendrá efecto alguno!");
    else {
        eAbil = EffectAbilityIncrease(nAbility,nModifier);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAbil, oTarget, fDuration);
    }
}
void DoNoStackSkillBonus(object oCaster, object oTarget, int nModifier, int nSkill, float fDuration, int iSpell)
{
    effect eSkill;
    struct HighestAbilityItem sItem;

    sItem = GetHighestBonusItem(oTarget, ITEM_PROPERTY_SKILL_BONUS, nSkill);
    nModifier -= sItem.nScore;
    RemoveMagicSkillBonus(oTarget, nSkill, iSpell);
    if (nModifier < 1)
        SendMessageToPC(oCaster, "¡El bonificador de habilidad del objetivo es muy poderoso para este conjuro, no tendrá efecto alguno!");
    else {
        eSkill = EffectSkillIncrease(nSkill,nModifier);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSkill, oTarget, fDuration);
    }
}
void DoNoStackSavingThrowBonus(object oCaster, object oTarget, int nModifier, int nSaving, float fDuration)
{
    effect eSaving;
    struct HighestAbilityItem sItem;
    if (nSaving == 0) sItem = GetHighestBonusItem(oTarget, ITEM_PROPERTY_SAVING_THROW_BONUS, SAVING_THROW_ALL);
    else sItem = GetHighestBonusItem(oTarget, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, nSaving);
    nModifier -= sItem.nScore;
    if (nModifier < 1)
        SendMessageToPC(oCaster, "¡El bonificador de salvación del objetivo es muy poderoso para este conjuro, no tendrá efecto alguno!");
    else {
        if (nSaving == 0) eSaving = EffectSavingThrowIncrease(nSaving,nModifier);
        else eSaving = EffectSavingThrowIncrease(nSaving,nModifier, nSaving);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSaving, oTarget, fDuration);
    }
}

void RemoveMagicAbilityBonus(object oPC, int nAbility)
{
    switch (nAbility)
    {
        case ABILITY_STRENGTH:
            RemoveEffectsFromSpell(oPC, 9);    // Fuerza de toro
            RemoveEffectsFromSpell(oPC, 360);  // Fuerza de toro mayor (que ahora es normal)
            RemoveEffectsFromSpell(oPC, 614);  // Fuerza de toro guardia negro (antigua)
            RemoveEffectsFromSpell(oPC, 1043); // Fuerza de toro en grupo
            RemoveEffectsFromSpell(oPC, 1082); // Fuerza de toro guardia negro
            RemoveEffectsFromSpell(oPC, 555);  // Piedra ioun fuerza
            RemoveEffectsFromSpell(oPC, 996);  // Cuerpo ferreo
            RemoveEffectsFromSpell(oPC, 422);  // Frenesi de sangre
            RemoveEffectsFromSpell(oPC, 370);  // Explosion de energia negativa
            RemoveEffectsFromSpell(oPC, 42);   // Poder divino
            RemoveEffectsFromSpell(oPC, 372);  // Aura de vitalidad
            RemoveEffectsFromSpell(oPC, 1421); // Berserker (Artífice)
        break;
        case ABILITY_DEXTERITY:
            RemoveEffectsFromSpell(oPC, 13);   // Gracia felina
            RemoveEffectsFromSpell(oPC, 361);  // Gracia felina mayor (que ahora es normal)
            RemoveEffectsFromSpell(oPC, 481);  // Gracia felina (otra normal, no se donde se usara)
            RemoveEffectsFromSpell(oPC, 1010); // Gracia felina asesino
            RemoveEffectsFromSpell(oPC, 1044); // Gracia felina en grupo
            RemoveEffectsFromSpell(oPC, 1117); // Gracia felina agente arpista
            RemoveEffectsFromSpell(oPC, 558);  // Piedra ioun destreza
            RemoveEffectsFromSpell(oPC, 372);  // Aura de vitalidad
        break;
        case ABILITY_CONSTITUTION:
            RemoveEffectsFromSpell(oPC, 49);   // Aguante
            RemoveEffectsFromSpell(oPC, 362);  // Aguante mayor (que ahora es normal)
            RemoveEffectsFromSpell(oPC, 1046); // Aguante en grupo
            RemoveEffectsFromSpell(oPC, 559);  // Piedra ioun constitucion
            RemoveEffectsFromSpell(oPC, 422);  // Frenesi de sangre
            RemoveEffectsFromSpell(oPC, 372);  // Aura de vitalidad
            RemoveEffectsFromSpell(oPC, 856);  // Vigor divino
        break;
        case ABILITY_INTELLIGENCE:
            RemoveEffectsFromSpell(oPC, 356);  // Astucia de zorro
            RemoveEffectsFromSpell(oPC, 359);  // Astucia de zorro mayor (que ahora es normal)
            RemoveEffectsFromSpell(oPC, 1008); // Astucia de zorro asesino
            RemoveEffectsFromSpell(oPC, 1047); // Astucia de zorro en grupo
            RemoveEffectsFromSpell(oPC, 556);  // Piedra ioun inteligencia
            RemoveEffectsFromSpell(oPC, 1421); // Berserker (Artífice)
        break;
        case ABILITY_WISDOM:
            RemoveEffectsFromSpell(oPC, 355);  // Sabiduria de luchuza
            RemoveEffectsFromSpell(oPC, 358);  // Sabiduria de luchuza mayor (que ahora es normal)
            RemoveEffectsFromSpell(oPC, 1048); // Sabiduria de luchuza en grupo
            RemoveEffectsFromSpell(oPC, 557);  // Piedra ioun sabiduria
            RemoveEffectsFromSpell(oPC, 438);  // Perspicacia del buho
        break;
        case ABILITY_CHARISMA:
            RemoveEffectsFromSpell(oPC, 354);  // Esplendor de aguila
            RemoveEffectsFromSpell(oPC, 357);  // Esplendor de aguila mayor (que ahora es normal)
            RemoveEffectsFromSpell(oPC, 482);  // Esplendor de aguila (otra normal, no se donde se usara)
            RemoveEffectsFromSpell(oPC, 1045); // Esplendor de aguila en grupo
            RemoveEffectsFromSpell(oPC, 1116); // Esplendor de aguila agente arpista
            RemoveEffectsFromSpell(oPC, 560);  // Piedra ioun carisma
            RemoveEffectsFromSpell(oPC, 429);  // Aura de virtud
        break;
    }
}

void RemoveMagicSkillBonus(object oPC, int nSkill, int iSpell)
{
//conjuros que den habilidades, nSkill es el identificador de la habilidad.
//Solo es necesario rellenar las habilidades que tienen un conjuro que las aumente.
//No borra el efecto de un spell, si el spell es el mismo que el lanzado (para evitar borrar efectos de varias mejoras en un mismo conjuro)
    switch (nSkill)
    {
        case 0: // Trato con los animales
            if(iSpell != 420) RemoveEffectsFromSpell(oPC, 420); // Unirse a la tierra
        break;
        case 2: // Inutilizar mecanismo
            if(iSpell != 385) RemoveEffectsFromSpell(oPC, 385); // Pocion Astucia Picaro
        break;
        case 5: // Esconderse
            if(iSpell != 385) RemoveEffectsFromSpell(oPC, 385); // Pocion Astucia Picaro
            if(iSpell != 532) RemoveEffectsFromSpell(oPC, 532); // Extender enredaderas, camuflar
            if(iSpell != 421) RemoveEffectsFromSpell(oPC, 421); // Camuflar
            if(iSpell != 455) RemoveEffectsFromSpell(oPC, 455); // Camuflar a las masas
            if(iSpell != 420) RemoveEffectsFromSpell(oPC, 420); // Unirse a la tierra
        break;
        case 6: // Escuchar
            if(iSpell != 20) RemoveEffectsFromSpell(oPC, 20);   // Clariaudiencia/clarividencia
            if(iSpell != 1020) RemoveEffectsFromSpell(oPC, 1020); // Clariaudiencia/clarividencia (asesino)
            if(iSpell != 1122) RemoveEffectsFromSpell(oPC, 1122); // Clariaudiencia/clarividencia (agente arpista)
            if(iSpell != 442) RemoveEffectsFromSpell(oPC, 442);  // Amplificar
        break;
        case 7: // Saber (arcano)
            if(iSpell != 376) RemoveEffectsFromSpell(oPC, 376); // Conocimiento de leyendas
        break;
        case 8: // Moverse sigilosamente
            if(iSpell != 385) RemoveEffectsFromSpell(oPC, 385); // Pocion Astucia Picaro
            if(iSpell != 421) RemoveEffectsFromSpell(oPC, 421); // Camuflar
            if(iSpell != 455) RemoveEffectsFromSpell(oPC, 455); // Camuflar a las masas
            if(iSpell != 420) RemoveEffectsFromSpell(oPC, 420); // Unirse a la tierra
        break;
        case 9: // Abrir cerraduras
            if(iSpell != 385) RemoveEffectsFromSpell(oPC, 385); // Pocion Astucia Picaro
        break;
        case 13: // Juego de manos
            if(iSpell != 385) RemoveEffectsFromSpell(oPC, 385); // Pocion Astucia Picaro
        break;
        case 14: // Buscar
            if(iSpell != 385) RemoveEffectsFromSpell(oPC, 385); // Pocion Astucia Picaro
        break;
        case 15: // Poner trampas
            if(iSpell != 385) RemoveEffectsFromSpell(oPC, 385); // Pocion Astucia Picaro
            if(iSpell != 420) RemoveEffectsFromSpell(oPC, 420); // Unirse a la tierra
        break;
        case 17: // Avistar
            if(iSpell != 20) RemoveEffectsFromSpell(oPC, 20);   // Clariaudiencia/clarividencia
            if(iSpell != 1020) RemoveEffectsFromSpell(oPC, 1020); // Clariaudiencia/clarividencia (asesino)
            if(iSpell != 1122) RemoveEffectsFromSpell(oPC, 1122); // Clariaudiencia/clarividencia (agente arpista)
        break;
        case 25: // Nadar
            if(iSpell != 1410) RemoveEffectsFromSpell(oPC, 1410); // Ciborg (Artífice)
        break;
        case 26: // Saltar
            if(iSpell != 1006) RemoveEffectsFromSpell(oPC, 1006); // Salto (asesino)
            if(iSpell != 1113) RemoveEffectsFromSpell(oPC, 1113); // Salto (agente arpista)
            if(iSpell != 1127) RemoveEffectsFromSpell(oPC, 1127); // Salto
            if(iSpell != 1410) RemoveEffectsFromSpell(oPC, 1410); // Ciborg (Artífice)
        break;
        case 30: // Disfrazarse
            if(iSpell != 1005) RemoveEffectsFromSpell(oPC, 1005); // Disfrazarse (asesino)
            if(iSpell != 1139) RemoveEffectsFromSpell(oPC, 1139); // Disfrazarse
        break;
        case 36: // Supervivencia
            if(iSpell != 420) RemoveEffectsFromSpell(oPC, 420); // Unirse a la tierra
        break;
        case 37: // Trepar
            if(iSpell != 1106) RemoveEffectsFromSpell(oPC, 1106); // Trepar cual aracnido
            if(iSpell != 1112) RemoveEffectsFromSpell(oPC, 1112); // Trepar cual aracnido (agente arpista)
            if(iSpell != 1410) RemoveEffectsFromSpell(oPC, 1410); // Ciborg (Artífice)
        break;
    }
}

void RemoveMagicSavingBonus(object oPC, int nSaving)
{
//conjuros que den salvaciones, nSaving es el identificador de la salvación. 0 es universal
    switch (nSaving)
    {
        case 0: // Salvaciones universales
            RemoveEffectsFromSpell(oPC, 151); // Resistencia
        break;
        case SAVING_THROW_FORT:
//            RemoveEffectsFromSpell(oPC, 13);
        break;
        case SAVING_THROW_REFLEX:
//            RemoveEffectsFromSpell(oPC, 49);
        break;
        case SAVING_THROW_WILL:
//            RemoveEffectsFromSpell(oPC, 356);
        break;
    }
}

void HasItemAbilityBonus(object oItem)
{
    itemproperty ip = GetFirstItemProperty(oItem);

    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_ABILITY_BONUS)
            SetLocalArrayInt(oItem, "nAbilityBonus", GetItemPropertySubType(ip), 1);
        ip = GetNextItemProperty(oItem);
    }
}

void HasItemSavingUniversal(object oItemEquipped)
{
    itemproperty ip = GetFirstItemProperty(oItemEquipped);

    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_SAVING_THROW_BONUS)
            if(GetItemPropertySubType(ip) ==  SAVING_THROW_ALL){
                SetLocalInt(oItemEquipped, "nSavingUniversal", 1);
            }
    ip = GetNextItemProperty(oItemEquipped);
    }

}
void HasItemRegBonus(object oItemEquipped)
{
    itemproperty ip = GetFirstItemProperty(oItemEquipped);
    int reg;

    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_REGENERATION){
            reg = GetItemPropertyCostTableValue(ip);
            if(GetLocalInt(oItemEquipped, "nReg") <= 0) SetLocalInt(oItemEquipped, "nReg", reg);
        }

    ip = GetNextItemProperty(oItemEquipped);
    }


}

void HasItemSavingBonus(object oItemEquipped)
{
    itemproperty ip = GetFirstItemProperty(oItemEquipped);

    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC)
            SetLocalArrayInt(oItemEquipped, "nSavingThrowArray", GetItemPropertySubType(ip), 1);
        ip = GetNextItemProperty(oItemEquipped);
    }

}

void RestoreAbilityItem(object oItem, int nAbility)
{
      int nModifier = 0;
      itemproperty ipAbil;
      nModifier = GetLocalInt( oItem, "nAbility" + IntToString(nAbility));


      if (nModifier > 0 ) {
        ipAbil = ItemPropertyAbilityBonus( nAbility, nModifier);
        IPSafeAddItemProperty(oItem, ipAbil);
        DeleteLocalInt(oItem, "nAbility" + IntToString(nAbility));
      }
}

void RestoreSkillItem(object oItem, int nSkill)
{
    int nModifier = 0;
    itemproperty ipAbil;
    nModifier = GetLocalInt(oItem, "nSkill" + IntToString(nSkill));

    if (nModifier > 0) {
        ipAbil = ItemPropertySkillBonus(nSkill, nModifier);
        IPSafeAddItemProperty(oItem, ipAbil);
        DeleteLocalInt(oItem, "nSkill" + IntToString(nSkill));
    }
}

void RestoreSavingThrowItem(object oItem, int nSkill)
{
    int nModifier = 0;
    itemproperty ipAbil;

    //Salvacin Universal
    nModifier = GetLocalInt(oItem, "nSavingUniversalBonus");
    if (nModifier > 0) {
        ipAbil = ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, nModifier);
        IPSafeAddItemProperty(oItem, ipAbil);
        DeleteLocalInt(oItem, "nSavingUniversalBonus");
    }

    //Salvaciones concretas
    nModifier = GetLocalInt(oItem, "nSavingThrow" + IntToString(nSkill));
    if (nModifier > 0) {
        ipAbil = ItemPropertyBonusSavingThrow(nSkill, nModifier);
        IPSafeAddItemProperty(oItem, ipAbil);
        DeleteLocalInt(oItem, "nSavingThrow" + IntToString(nSkill));
    }
}
void RestoreRegItem(object oItem, int nReg){
    int nModifier = 0;
    itemproperty ipReg;
    nModifier = GetLocalInt(oItem, "nReg" );
    if (nModifier > 0){
        //eliminamos la regeneracion por si tenia un valor diferente al de restaurar.
        if (nModifier > nReg ) NeutralizeRegItem(oItem, 0);
        ipReg = ItemPropertyRegeneration(nModifier);
        IPSafeAddItemProperty(oItem, ipReg);
//        if (nModifier <= nReg ) DeleteLocalInt(oItem, "nReg" );
    }
}

void RestoreAllItems(object oPC, int nAbility,int nSkill)
{
    int i;
    object oSlot;

    for (i = 0; i < NUM_INVENTORY_SLOTS; ++i) {
        oSlot=GetItemInSlot(i, oPC);
        if (GetIsObjectValid(oSlot))
            switch (nSkill)
            {
                case 0:
                    RestoreAbilityItem(oSlot, nAbility);
                break;
                case 1:
                    RestoreSkillItem(oSlot, nAbility);
                break;
                case 2:
                    RestoreSavingThrowItem(oSlot, nAbility);
                break;
                case 3:
                    RestoreRegItem(oSlot, nAbility);
                break;
            }
/*            if (nSkill=1) //habilidad
                RestoreSkillItem(oSlot, nAbility);
            else if (nSkill=2) //salvacion  universal y concreta
                RestoreSavingThrowItem(oSlot, nAbility);
            else  // caracteristica
                RestoreAbilityItem(oSlot, nAbility);*/
    }
}

void ApplyAbilityPenalty(object oItem, int nPenalty, int nAbility)
{
    itemproperty ipAbil;


    if (nPenalty > 10)
        nPenalty = 10;

    ipAbil = ItemPropertyDecreaseAbility(nAbility, nPenalty);
    IPSafeAddItemProperty(oItem, ipAbil);
}
void HasItemSkillBonus(object oItem)
{
    itemproperty ip = GetFirstItemProperty(oItem);

    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_SKILL_BONUS)
            SetLocalArrayInt(oItem, "nSkillBonus", GetItemPropertySubType(ip), 1);
        ip = GetNextItemProperty(oItem);
    }
}
void NeutralizeSkillItem(object oItem, int nSkill)
{
    int nModifier = 0;

    nModifier = RemovePropertyAndReturnModifier(oItem, ITEM_PROPERTY_SKILL_BONUS, nSkill);

    if (nModifier > 0) {
        SetLocalInt(oItem, "nSkill" + IntToString(nSkill), nModifier);
    }
}

void NeutralizeSavingThrowItem(object oItem, int nSkill)
{
    int nModifier = 0;
    struct ItemProperty IP;
    if(nSkill == 0){
        nModifier = RemovePropertyAndReturnModifier(oItem, ITEM_PROPERTY_SAVING_THROW_BONUS, nSkill);
        if (nModifier > 0) SetLocalInt(oItem, "nSavingUniversalBonus", nModifier);
    }
    else {    nModifier = RemovePropertyAndReturnModifier(oItem, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, nSkill);
        if (nModifier > 0) {
            SetLocalInt(oItem, "nSavingThrow" + IntToString(nSkill), nModifier);
        }
    }
}
void NeutralizeAllAbility( object oItem, int nAbility)
{
    int nModifier = 0;

    nModifier = RemovePropertyAndReturnModifier(oItem, ITEM_PROPERTY_ABILITY_BONUS, nAbility);

    if (nModifier > 0) {
        SetLocalInt(oItem, "nAbility" + IntToString(nAbility), nModifier);
    }
}
void NeutralizeRegItem( object oItem, int nReg)
{
    int nModifier = 0;

    nModifier = RemovePropertyAndReturnModifier(oItem, ITEM_PROPERTY_REGENERATION);

    if( nModifier > 0 && nReg != 0) {
        if(GetLocalInt(oItem, "nReg") <= 0) SetLocalInt(oItem, "nReg", nModifier);
    }
}
void NeutralizeAllSavingThrowExcludeOne(object oPC, int nSkill, object oExclude)
{
    int i;
    object oSlot;

    for (i = 0; i < NUM_INVENTORY_SLOTS; ++i) {
        oSlot=GetItemInSlot(i, oPC);
        if (GetIsObjectValid(oSlot))
        if (oExclude != oSlot)
           NeutralizeSavingThrowItem(oSlot, nSkill);
    }
}

void NeutralizeAllSavingThrowExcludeTwo(object oPC, int nSkill, object oExclude, object oExclude2)
{
    int i;
    object oSlot;

    for (i = 0; i < NUM_INVENTORY_SLOTS; ++i) {
        oSlot=GetItemInSlot(i, oPC);
        if (GetIsObjectValid(oSlot))
        if (oExclude != oSlot && oExclude2 != oSlot)
           NeutralizeSavingThrowItem(oSlot, nSkill);
    }
}
void NeutralizeAllRegExcludeOne(object oPC, int nReg, object oExclude)
{
    int i;
    object oSlot;
    itemproperty ipReg;
    for (i=0; i< NUM_INVENTORY_SLOTS; ++i){
        oSlot=GetItemInSlot(i, oPC);
        HasItemRegBonus(oSlot);
        if(GetIsObjectValid(oSlot)){
            if(oExclude != oSlot)
               NeutralizeRegItem(oSlot, nReg);
            else {
               if(GetLocalInt(oSlot, "nReg")> nReg && GetStringLeft(GetTag(oExclude),3) != "MMF") {
                   NeutralizeRegItem(oSlot, 0);
                   ipReg = ItemPropertyRegeneration(nReg);
                   IPSafeAddItemProperty(oSlot, ipReg);
                }
            }
        }
    }
}
void NeutralizeAllRegExcludeTwo(object oPC, int nReg, object oExclude, object oExclude2)
{
    int i;
    object oSlot;
    itemproperty ipReg;
    for (i=0; i< NUM_INVENTORY_SLOTS; ++i){
        oSlot=GetItemInSlot(i, oPC);
        if(GetIsObjectValid(oSlot)){
            if(oExclude != oSlot && oExclude2 != oSlot)
               NeutralizeRegItem(oSlot, nReg);
            else {
               if(GetLocalInt(oSlot, "nReg")> nReg){
                   NeutralizeRegItem(oSlot, 0);
                   ipReg = ItemPropertyRegeneration(nReg);
                   IPSafeAddItemProperty(oSlot, ipReg);
               }
            }

        }
    }
}
void NeutralizeAllRegExcludeThree(object oPC, int nReg, object oExclude, object oExclude2, object oExclude3)
{
    int i;
    object oSlot;
    itemproperty ipReg;
    for (i=0; i< NUM_INVENTORY_SLOTS; ++i){
        oSlot=GetItemInSlot(i, oPC);
        if(GetIsObjectValid(oSlot)){
            if(oExclude != oSlot && oExclude2 != oSlot && oExclude3 != oSlot )
               NeutralizeRegItem(oSlot, nReg);
            else {
               if(GetLocalInt(oSlot, "nReg")> nReg){
                   NeutralizeRegItem(oSlot, 0);
                   ipReg = ItemPropertyRegeneration(nReg);
                   IPSafeAddItemProperty(oSlot, ipReg);
               }
            }
        }
    }
}

void NeutralizeAllRegExcludeFour(object oPC, int nReg, object oExclude, object oExclude2, object oExclude3, object oExclude4)
{
    int i;
    object oSlot;
    itemproperty ipReg;
    for (i=0; i< NUM_INVENTORY_SLOTS; ++i){
        oSlot=GetItemInSlot(i, oPC);
        if(GetIsObjectValid(oSlot)){
            if(oExclude != oSlot && oExclude2 != oSlot && oExclude3 != oSlot && oExclude4 != oSlot )
               NeutralizeRegItem(oSlot, nReg);
            else {
               if(GetLocalInt(oSlot, "nReg")> nReg){
                   NeutralizeRegItem(oSlot, 0);
                   ipReg = ItemPropertyRegeneration(nReg);
                   IPSafeAddItemProperty(oSlot, ipReg);
                }
            }
        }
    }
}

void NeutralizeAllExcludeOne(object oPC, int nSkill, object oExclude)
{
    int i;
    object oSlot;
    int nTriggered;

    for (i = 0; i < NUM_INVENTORY_SLOTS; ++i) {
        oSlot=GetItemInSlot(i, oPC);
        if (GetIsObjectValid(oSlot))
        if (oExclude != oSlot)
           NeutralizeSkillItem(oSlot, nSkill);
    }
}
void NeutralizeAllExcludeTwo(object oPC, int nSkill, object oExclude, object oExclude2)
{
    int i;
    object oSlot;

    for (i = 0; i < NUM_INVENTORY_SLOTS; ++i) {
        oSlot=GetItemInSlot(i, oPC);
        if (GetIsObjectValid(oSlot))
        if (oExclude != oSlot && oExclude2 != oSlot)
           NeutralizeSkillItem(oSlot, nSkill);
    }
}
void NeutralizeAllAbilityExcludeOne( object oPC, int nAbility, object oExclude)
{
    int i;
    object oSlot;

    for (i = 0; i < NUM_INVENTORY_SLOTS; ++i) {
        oSlot=GetItemInSlot(i, oPC);
        if (GetIsObjectValid(oSlot))
        if (oExclude != oSlot)
           NeutralizeAllAbility(oSlot, nAbility);
    }
}
void NeutralizeAllAbilityExcludeTwo( object oPC, int nAbility, object oExclude, object oExclude2)
{
    int i;
    object oSlot;

    for (i = 0; i < NUM_INVENTORY_SLOTS; ++i) {
        oSlot=GetItemInSlot(i, oPC);
        if (GetIsObjectValid(oSlot))
        if (oExclude != oSlot && oExclude2 != oSlot)
           NeutralizeAllAbility(oSlot, nAbility);
    }
}
struct HighestAbilityItem GetHighestBonusItem(object oPC, int nType, int nSubType)
{
    struct HighestAbilityItem iHighest;
    struct ItemProperty isProp;
    object oSlot;
    int i;
    itemproperty ipAbil;
    iHighest.nScore = 0;

    for (i = 0; i < NUM_INVENTORY_SLOTS; ++i) {
        oSlot=GetItemInSlot(i, oPC);
        if (GetIsObjectValid(oSlot)) {
            isProp = GetItemProperty(oSlot, nType, nSubType);
            if (isProp.nFound) {
                if (isProp.nModifier > iHighest.nScore) {
                    iHighest.nScore = isProp.nModifier;
                    iHighest.oItem = oSlot;
                }
            }
        }
    }

    return iHighest;
}


struct HighestAbilityItem GetHighestBonusItemExcludeOne(object oPC, int nType, int nSubType, object oExclude)
{
    struct HighestAbilityItem iHighest;
    struct ItemProperty isProp;
    object oSlot;
    int i;
    itemproperty ipAbil;
    iHighest.nScore = 0;

    for (i = 0; i < NUM_INVENTORY_SLOTS; ++i) {
        oSlot=GetItemInSlot(i, oPC);
        if (GetIsObjectValid(oSlot)) {
             isProp = GetItemProperty(oSlot, nType, nSubType);
             if (oExclude != oSlot)
                if (isProp.nFound) {

                    if (isProp.nModifier > iHighest.nScore) {
                        iHighest.nScore = isProp.nModifier;
                        iHighest.oItem = oSlot;
                }
            }
        }
    }

    return iHighest;
}
struct HighestAbilityItem GetHighestBonusItemExcludeTwo(object oPC, int nType, int nSubType, object oExclude, object oExclude2)
{
    struct HighestAbilityItem iHighest;
    struct ItemProperty isProp;
    object oSlot;
    int i;
    itemproperty ipAbil;
    iHighest.nScore = 0;

    for (i = 0; i < NUM_INVENTORY_SLOTS; ++i) {
        oSlot=GetItemInSlot(i, oPC);
        if (GetIsObjectValid(oSlot)) {
             isProp = GetItemProperty(oSlot, nType, nSubType);
             if (oExclude != oSlot && oExclude2 != oSlot)
                if (isProp.nFound) {

                    if (isProp.nModifier > iHighest.nScore) {
                        iHighest.nScore = isProp.nModifier;
                        iHighest.oItem = oSlot;
                }
            }
        }
    }

    return iHighest;
}
struct HighestAbilityItem GetHighestBonusItemExcludeThree(object oPC, int nType, int nSubType, object oExclude, object oExclude2, object oExclude3)
{
    struct HighestAbilityItem iHighest;
    struct ItemProperty isProp;
    object oSlot;
    int i;
    itemproperty ipAbil;
    iHighest.nScore = 0;

    for (i = 0; i < NUM_INVENTORY_SLOTS; ++i) {
        oSlot=GetItemInSlot(i, oPC);
        if (GetIsObjectValid(oSlot)) {
             isProp = GetItemProperty(oSlot, nType, nSubType);
             if (oExclude != oSlot && oExclude2 != oSlot && oExclude3 != oSlot )
                if (isProp.nFound) {

                    if (isProp.nModifier > iHighest.nScore) {
                        iHighest.nScore = isProp.nModifier;
                        iHighest.oItem = oSlot;
                }
            }
        }
    }

    return iHighest;
}
int GetTotalAbilityItemBonus(object oPC, int nAbility, int nSubtract=0)
{
    int i;
    struct ItemProperty isProp;
    object oSlot;
    int nTotal = 0;
    for (i = 0; i < NUM_INVENTORY_SLOTS; ++i) {
            oSlot = GetItemInSlot(i, oPC);
            isProp = GetItemProperty(oSlot, ITEM_PROPERTY_ABILITY_BONUS, nAbility);
            nTotal += isProp.nModifier;
    }
    nTotal -= nSubtract;
    if (nTotal > 12) nTotal = 12;

    return nTotal;
}

int GetTotalSavingSpecificItemBonus(object oPC, int nSaving, int nIndex=0)
{
    int i;
    struct ItemProperty isProp;
    object oSlot;
    int nTotal = 0;
    for (i = 0; i < NUM_INVENTORY_SLOTS; ++i) {
            oSlot = GetItemInSlot(i, oPC);
            isProp = GetItemProperty(oSlot, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, nSaving);
            nTotal += isProp.nModifier;
    }

    return nTotal;
}
int GetTotalRegItemBonus(object oPC, int nReg){
    int i;
    struct ItemProperty isProp;
    object oSlot;
    int nTotal = 0;
    for (i=0; 1 < NUM_INVENTORY_SLOTS; ++i){
        oSlot = GetItemInSlot(i, oPC);
        isProp = GetItemProperty(oSlot, ITEM_PROPERTY_REGENERATION, nReg);
        nTotal += isProp.nModifier;
    }
    return nTotal;
}

struct ItemProperty GetItemProperty(object oItem, int nType, int nSubType)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    struct ItemProperty isProp;
    isProp.nFound = 0;
    isProp.nModifier = 0;
    //PrintString ("Filter - T:" + IntToString(GetItemPropertyType(ipCompareTo))+ " S: " + IntToString(GetItemPropertySubType(ipCompareTo)) + " (Ignore: " + IntToString (bIgnoreSubType) + ") D:" + IntToString(nDurationCompare));
    while (GetIsItemPropertyValid(ip))
    {
        // PrintString ("Testing - T: " + IntToString(GetItemPropertyType(ip)));
        if ((GetItemPropertyType(ip) == nType))
        {
             //PrintString ("**Testing - S: " + IntToString(GetItemPropertySubType(ip)));
             if (GetItemPropertySubType(ip) == nSubType)
             {
               // PrintString ("***Testing - d: " + IntToString(GetItemPropertyDurationType(ip)));
                if (GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
                {
                    //PrintString ("***FOUND");
                    isProp.nFound = 1;
                    isProp.nModifier = GetItemPropertyCostTableValue(ip);  //eliminado para usar otra funcion abajo
//                    isProp.nModifier = GetItemPropertyParam1Value(ip);
                    isProp.ip = ip;
                      return isProp; // if duration is not ignored and durationtypes are equal, true
                 }
            }
        }
        ip = GetNextItemProperty(oItem);
    }
    return isProp;
}
int RemovePropertyAndReturnModifier(object oItem, int nItemPropertyType, int nItemPropertySubType = -1)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    int nBonus = 0;
    // valid ip?
    while (GetIsItemPropertyValid(ip))
    {
        // same property type?
        if ((GetItemPropertyType(ip) == nItemPropertyType))
        {
            // permanent property?
            if (GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
            {
                 // same subtype or subtype ignored
                 if  (GetItemPropertySubType(ip) == nItemPropertySubType || nItemPropertySubType == -1)
                 {
                      nBonus = GetItemPropertyCostTableValue(ip);
                      RemoveItemProperty(oItem, ip);
                 }
            }
        }
        ip = GetNextItemProperty(oItem);
    }
    return nBonus;
}

//Obtenemos el total de inmunidad al daño del PJ.
int GetTotalDamageImmunity(object oPC, int nDamage)
{
    int nTotal;
    int iCantidad;
    object Brazales = GetItemInSlot(INVENTORY_SLOT_ARMS,oPC);
    object Cinturon = GetItemInSlot(INVENTORY_SLOT_BELT,oPC);
    object Botas = GetItemInSlot(INVENTORY_SLOT_BOOTS,oPC);
    object Armadura = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
    object Capa = GetItemInSlot(INVENTORY_SLOT_CLOAK,oPC);
    object Yelmo = GetItemInSlot(INVENTORY_SLOT_HEAD,oPC);
    object Escudo = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
    object Anillo1 = GetItemInSlot(INVENTORY_SLOT_LEFTRING,oPC);
    object Amuleto = GetItemInSlot(INVENTORY_SLOT_NECK,oPC);
    object Arma = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    object Anillo2 = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oPC);

    nTotal = nTotal + GetLocalInt(Brazales, "DAMAGE_IMMUNITY_CANTIDAD"+IntToString(nDamage));
    nTotal = nTotal + GetLocalInt(Cinturon, "DAMAGE_IMMUNITY_CANTIDAD"+IntToString(nDamage));
    nTotal = nTotal + GetLocalInt(Botas,    "DAMAGE_IMMUNITY_CANTIDAD"+IntToString(nDamage));
    nTotal = nTotal + GetLocalInt(Armadura, "DAMAGE_IMMUNITY_CANTIDAD"+IntToString(nDamage));
    nTotal = nTotal + GetLocalInt(Capa,     "DAMAGE_IMMUNITY_CANTIDAD"+IntToString(nDamage));
    nTotal = nTotal + GetLocalInt(Yelmo,    "DAMAGE_IMMUNITY_CANTIDAD"+IntToString(nDamage));
    nTotal = nTotal + GetLocalInt(Escudo,   "DAMAGE_IMMUNITY_CANTIDAD"+IntToString(nDamage));
    nTotal = nTotal + GetLocalInt(Anillo1,  "DAMAGE_IMMUNITY_CANTIDAD"+IntToString(nDamage));
    nTotal = nTotal + GetLocalInt(Amuleto,  "DAMAGE_IMMUNITY_CANTIDAD"+IntToString(nDamage));
    nTotal = nTotal + GetLocalInt(Arma,     "DAMAGE_IMMUNITY_CANTIDAD"+IntToString(nDamage));
    nTotal = nTotal + GetLocalInt(Anillo2,  "DAMAGE_IMMUNITY_CANTIDAD"+IntToString(nDamage));
    //SendMessageToPC(oPC,"CANTIDAD TOTAL DE INMUNIDAD "+IntToString(nDamage)+" ES: "+IntToString(nTotal));
    return nTotal;

}

//void main(){}
