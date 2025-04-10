    #include "pb_inc_mmf"
#include "nwnx_events"

//Script que se subscribe en los eventos NWNX_ON_ITEM_EQUIP_BEFORE
//Gestiona el equipo permitido para cada forma

void main()
{
    object oPC = OBJECT_SELF;
    string sEvent = NWNX_Events_GetCurrentEvent();
    if(!ObtenerIntPersistente(oPC,"POLYMORPHED") || GetLocalInt(oPC,"MMF_WEAPON_DELETE")) return;

    object oItem = StringToObject(NWNX_Events_GetEventData("ITEM"));
    string sEquipSlot = Get2DAString("baseitems","EquipableSlots",GetBaseItemType(oItem));
    int iConstant = ObtenerIntPersistente(oPC,"POLYMORPHED_FORM");
    int iMergeW = StringToInt(Get2DAString(sPoly2DA,"MergeW",iConstant));
    int iMergeA = StringToInt(Get2DAString(sPoly2DA,"MergeA",iConstant));

    if(sEvent == NWNX_ON_ITEM_EQUIP_BEFORE)
    {
        if(!iMergeA)
        {
            if(sEquipSlot != EQUIPABLE_SLOT_1H_MAIN_HAND && sEquipSlot != EQUIPABLE_SLOT_1H_OFF_HAND &&
                sEquipSlot != EQUIPABLE_SLOT_2H_RANGED && sEquipSlot != EQUIPABLE_SLOT_2H_MELE &&
                sEquipSlot != EQUIPABLE_SLOT_1H_LR && sEquipSlot != EQUIPABLE_SLOT_CREATURE_W &&
                sEquipSlot != EQUIPABLE_SLOT_CREATURE_H && sEquipSlot != EQUIPABLE_SLOT_ARROW &&
                sEquipSlot != EQUIPABLE_SLOT_BOLT && sEquipSlot != EQUIPABLE_SLOT_BULLET){
                SendMessageToPC(oPC,"No puedes equiparte esto mientras estas en esta forma.");
                //DelayCommand(0.2,WrapNWNX_Creature_RunUnequip(oPC,oItem));
                NWNX_Events_SkipEvent();
            }
        }
        if(iMergeW)
        {
            if(sEquipSlot == EQUIPABLE_SLOT_1H_MAIN_HAND || sEquipSlot == EQUIPABLE_SLOT_1H_OFF_HAND ||
                sEquipSlot == EQUIPABLE_SLOT_2H_RANGED || sEquipSlot == EQUIPABLE_SLOT_2H_MELE ||
                sEquipSlot == EQUIPABLE_SLOT_1H_LR || sEquipSlot == EQUIPABLE_SLOT_ARROW ||
                sEquipSlot == EQUIPABLE_SLOT_BOLT || sEquipSlot == EQUIPABLE_SLOT_BULLET){
                SendMessageToPC(oPC,"No puedes equiparte esto mientras estas en esta forma.");
                //DelayCommand(0.2,WrapNWNX_Creature_RunUnequip(oPC,oItem));
                NWNX_Events_SkipEvent();
            }
        }
    }
    else if(sEvent == NWNX_ON_ITEM_UNEQUIP_BEFORE)
    {
        if(!iMergeA)
        {
            if(sEquipSlot != EQUIPABLE_SLOT_1H_MAIN_HAND && sEquipSlot != EQUIPABLE_SLOT_1H_OFF_HAND &&
                sEquipSlot != EQUIPABLE_SLOT_2H_RANGED && sEquipSlot != EQUIPABLE_SLOT_2H_MELE &&
                sEquipSlot != EQUIPABLE_SLOT_1H_LR && sEquipSlot != EQUIPABLE_SLOT_CREATURE_W &&
                sEquipSlot != EQUIPABLE_SLOT_CREATURE_H && sEquipSlot != EQUIPABLE_SLOT_ARROW &&
                sEquipSlot != EQUIPABLE_SLOT_BOLT && sEquipSlot != EQUIPABLE_SLOT_BULLET){
                SendMessageToPC(oPC,"No puedes desequiparte esto, esta fusionado con tu piel en esta forma.");
                //DelayCommand(0.2,WrapNWNX_Creature_RunUnequip(oPC,oItem));
                NWNX_Events_SkipEvent();
            }
        }
        if(iMergeW)
        {
            if(sEquipSlot == EQUIPABLE_SLOT_1H_MAIN_HAND || sEquipSlot == EQUIPABLE_SLOT_1H_OFF_HAND ||
                sEquipSlot == EQUIPABLE_SLOT_2H_RANGED || sEquipSlot == EQUIPABLE_SLOT_2H_MELE ||
                sEquipSlot == EQUIPABLE_SLOT_1H_LR || sEquipSlot == EQUIPABLE_SLOT_ARROW ||
                sEquipSlot == EQUIPABLE_SLOT_BOLT || sEquipSlot == EQUIPABLE_SLOT_BULLET){
                SendMessageToPC(oPC,"No puedes desequiparte esto, esta fusionado con tus garras / mordisco en esta forma.");
                NWNX_Events_SkipEvent();
            }
        }
    }
}
