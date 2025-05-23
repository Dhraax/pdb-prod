///
///Test custom polymorph
///
#include "pb_inc_mmf"

void RemoveOldPolymorphMMF(object oPC, int iValue)
{
    effect e = GetFirstEffect(oPC);

    while(GetIsEffectValid(e))
    {
        if(iValue == 1 && GetEffectTag(e) == "MDF_POLYMORPH_1") {RemoveEffect(oPC,e);break;}
        else if( iValue != 1 && GetEffectTag(e) == "MDF_POLYMORPH_2") {RemoveEffect(oPC,e);break;}
        e = GetNextEffect(oPC);
    }
}

void main()
{
    // Get the event type
    int nEvent = GetLastRunScriptEffectScriptType();
    // Get original effect
    effect eOriginal = GetLastRunScriptEffect();
    // Get creator
    object oCaster = GetEffectCreator(eOriginal);
    // Get damage type from the value stored in sData
    int iConstant = StringToInt(GetEffectString(eOriginal, 0));

    object oContainer = GetItemPossessedBy(oCaster,"dmfi_pc_emote");
    int iMergeW = StringToInt(Get2DAString(sPoly2DA,"MergeW",iConstant));
    int iMergeA = StringToInt(Get2DAString(sPoly2DA,"MergeA",iConstant));
    json jOldEquipment = GetLocalJson(oContainer,"OLD_EQUIPMENT");
    switch(nEvent)
    {
        case RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_APPLIED:
        {
            StoreOriginalData(oCaster,iConstant);
            StoreOriginalEquipment(oCaster,iConstant);
            if(iMergeA && ObtenerIntPersistente(oCaster,"MMF_NO_MERGE_ARMOR")) {
                if(ObtenerIntPersistente(oCaster,"CRIT_RANGE_MODIFIED") == TRUE) NWNX_Creature_SetCriticalRangeOverride(oCaster,-1);
                LoadOriginalEquipment(oCaster);
            }
            EffectMDFPolymorph(oCaster,iConstant);
            NWNX_Race_SuppressCreatureRaceEffects(oCaster);
            if(ObtenerIntPersistente(oCaster,"POLYMORPHED") && !iMergeW)
            {
                object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
                object oWeapon2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
                if(GetIsObjectValid(oWeapon)){
                    DelayCommand(0.2, WrapNWNX_Creature_RunEquip(oCaster,oWeapon,INVENTORY_SLOT_RIGHTHAND));
                    if(GetIsObjectValid(oWeapon2)){
                        DelayCommand(0.2,WrapNWNX_Creature_RunEquip(oCaster,oWeapon2,INVENTORY_SLOT_LEFTHAND));
                    }
                }
            }

            GuardarIntPersistente(oCaster,"POLYMORPHED",TRUE);
            GuardarIntPersistente(oCaster,"POLYMORPHED_FORM",iConstant);
            if(ObtenerIntPersistente(oCaster,"POLYMORPH_COUNT_1")) RemoveOldPolymorphMMF(oCaster,2);
            else if(ObtenerIntPersistente(oCaster,"POLYMORPH_COUNT_2")) RemoveOldPolymorphMMF(oCaster,1);
            break;
        }
        case RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_REMOVED:
        {
            int count1 = ObtenerIntPersistente(oCaster,"POLYMORPH_COUNT_1");
            int count2 = ObtenerIntPersistente(oCaster,"POLYMORPH_COUNT_2");
            if(count1) {BorrarIntPersistente(oCaster,"POLYMORPH_COUNT_1"); count1--;}
            else if(count2) {BorrarIntPersistente(oCaster,"POLYMORPH_COUNT_2");count2--;}

            if(!count1 && !count2 && !ObtenerIntPersistente(oCaster,"LOGGED_OUT_POLYMORPHED"))
            {
                effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
                int iSpell1 = StringToInt(Get2DAString(sPoly2DA,"SPELL1",iConstant));
                int iSpell2 = StringToInt(Get2DAString(sPoly2DA,"SPELL2",iConstant));
                int iSpell3 = StringToInt(Get2DAString(sPoly2DA,"SPELL3",iConstant));

                if(iSpell1) BorrarIntPersistente(oCaster,"MMF_SPELL_USES"+IntToString(iSpell1));
                if(iSpell2) BorrarIntPersistente(oCaster,"MMF_SPELL_USES"+IntToString(iSpell2));
                if(iSpell3) BorrarIntPersistente(oCaster,"MMF_SPELL_USES"+IntToString(iSpell3));

                BorrarIntPersistente(oCaster,"POLYMORPHED");
                BorrarIntPersistente(oCaster,"POLYMORPHED_FORM");
                DeleteLocalJson(oContainer,"MF_OR_WEAPON");
                BorrarIntPersistente(oCaster,"MMF_NO_MERGE_ARMOR");
                BorrarIntPersistente(oCaster,"GENDER_RELATED");
                BorrarIntPersistente(oCaster,"ORIGINAL_GENDER");
                BorrarIntPersistente(oCaster,"POLYMORPH_COUNT_1");
                BorrarIntPersistente(oCaster,"POLYMORPH_COUNT_2");
                if(iConstant == MDF_RACIALTYPE_DUERGAR && GetAppearanceType(oCaster) == APPEARANCE_TYPE_DWARF) BorrarIntPersistente(oCaster,"MMF_DINAMIC_DWARF");

                LoadOriginalData(oCaster);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
                if(ObtenerIntPersistente(oCaster,"CRIT_RANGE_MODIFIED") == TRUE) NWNX_Creature_SetCriticalRangeOverride(oCaster,-1);
                BorrarIntPersistente(oCaster,"CRIT_RANGE_MODIFIED");
                RemoveAllMDFSpecialAbility(oCaster);

                effect eFirst = GetFirstEffect(oCaster);
                while(GetIsEffectValid(eFirst))
                {
                    if(GetEffectTag(eFirst) == "POLY_HP_BONUS" || GetEffectSpellId(eFirst)== 412 || GetEffectTag(eFirst) == "MMF_MOV_SPEED") RemoveEffect(oCaster,eFirst);
                    eFirst = GetNextEffect(oCaster);
                }
                NWNX_Race_ReactivateCreatureRaceEffects(oCaster);
                LoadOriginalEquipment(oCaster);
                if(ObtenerIntPersistente(oCaster,"LOGGED_OUT_REEQUIP")){

                    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST);
                    object oHelm = GetItemInSlot(INVENTORY_SLOT_HEAD);
                    object oCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK);

                    if(GetIsObjectValid(oArmor)) {WrapNWNX_Creature_RunUnequip(oCaster,oArmor); DelayCommand(0.3,WrapNWNX_Creature_RunEquip(oCaster,oArmor,INVENTORY_SLOT_CHEST));}
                    if(GetIsObjectValid(oHelm))  {WrapNWNX_Creature_RunUnequip(oCaster,oHelm);  DelayCommand(0.4,WrapNWNX_Creature_RunEquip(oCaster,oHelm,INVENTORY_SLOT_HEAD));}
                    if(GetIsObjectValid(oCloak)) {WrapNWNX_Creature_RunUnequip(oCaster,oCloak); DelayCommand(0.5,WrapNWNX_Creature_RunEquip(oCaster,oCloak,INVENTORY_SLOT_CLOAK));}
                    BorrarIntPersistente(oCaster,"LOGGED_OUT_REEQUIP");
                }

                object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
                object oWeapon2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
                if(GetIsObjectValid(oWeapon)){
                    DelayCommand(0.2, WrapNWNX_Creature_RunEquip(oCaster,oWeapon,INVENTORY_SLOT_RIGHTHAND));
                    if(GetIsObjectValid(oWeapon2)){
                        DelayCommand(0.2,WrapNWNX_Creature_RunEquip(oCaster,oWeapon2,INVENTORY_SLOT_LEFTHAND));
                    }
                }
            }
            break;
        }
    }
}




