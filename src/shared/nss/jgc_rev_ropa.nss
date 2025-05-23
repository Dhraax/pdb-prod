void main(){
    object oPC = GetPCSpeaker();
    object oObjetivo = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    //aplicamos al objeto el poder unico para si e inicializamos las variables para RopasReversibles
    object nRopa;
    int i, ropas, color;
    int rType=GetBaseItemType(oObjetivo);
    int iCost=GetLocalInt(OBJECT_SELF, "CURRENTPRICE");

    if( GetTag(oObjetivo)!="RopasReversibles" ){

//recuperamos valor de hacer reversible del maniqui
        if (GetGold(oPC) < iCost) {
            SendMessageToPC(oPC, "¡Este atuendo cuesta " + IntToString(iCost) + " monedas de oro hacerlo reversible!");
            return;
        }
        TakeGoldFromCreature(iCost, oPC, TRUE);

//comprobamos que no son ya "reversibles"
        nRopa=CopyObject(oObjetivo, GetLocation(oPC), oPC, "RopasReversibles");
        DestroyObject(oObjetivo);
        AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyCastSpell( IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE), nRopa, 0.0);
        if(rType==BASE_ITEM_ARMOR){//son ropas
            for(i=0;i<=19;i++){
                ropas=GetItemAppearance(nRopa, ITEM_APPR_TYPE_ARMOR_MODEL, i);
                SetLocalInt(nRopa, "ropas"+IntToString(i), ropas);
            }
        }else SendMessageToPC(oPC, "no es un objeto valido");
        for(i=0;i<=5;i++){//los colores
            color=GetItemAppearance(nRopa, ITEM_APPR_TYPE_ARMOR_COLOR, i);
            SetLocalInt(nRopa, "color"+IntToString(i), color);
        }
        AssignCommand(oPC, ActionEquipItem(nRopa,INVENTORY_SLOT_CHEST));
    }else SendMessageToPC(oPC, "ya tiene la propiedad de reversible");
    return;
}
