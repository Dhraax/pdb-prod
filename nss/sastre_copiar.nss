//Copiamos el objeto del PJ al sastre.
void main()
{
    object oPC = GetPCSpeaker();
    int iTipo = StringToInt(GetScriptParam("Tipo"));
    object oCopiar;
    object oLimpiar;
    object oCopia;
    int Slot;

    //Armadura.
    if(iTipo == 1)
    {
        oCopiar = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
        oLimpiar = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
        Slot = INVENTORY_SLOT_CHEST;
    }
    //Yelmo
    else if(iTipo == 2)
    {
        oCopiar = GetItemInSlot(INVENTORY_SLOT_HEAD, oPC);
        oLimpiar = GetItemInSlot(INVENTORY_SLOT_HEAD, OBJECT_SELF);
        Slot = INVENTORY_SLOT_HEAD;
    }
    //Mano derecha
    else if(iTipo == 3)
    {
        oCopiar = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        oLimpiar = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
        Slot = INVENTORY_SLOT_RIGHTHAND;
    }
    //Mano izquierda
    else if(iTipo == 4)
    {
        oCopiar = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
        oLimpiar = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, OBJECT_SELF);
        Slot = INVENTORY_SLOT_LEFTHAND;
    }
    //Capa
    else if(iTipo == 5)
    {
        oCopiar = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);
        oLimpiar = GetItemInSlot(INVENTORY_SLOT_CLOAK, OBJECT_SELF);
        Slot = INVENTORY_SLOT_CLOAK;
    }
    //Copiamos el item al PNJ.
    oCopia = CopyItem(oCopiar, OBJECT_SELF, TRUE);
    //Destruimos el objeto que tenga equipado.
    DestroyObject(oLimpiar);
    //Equipamos el objeto.
    DelayCommand(0.5f, AssignCommand(OBJECT_SELF, ActionEquipItem(oCopia, Slot)));
}
