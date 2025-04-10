#include "sastre_inc"
#include "nwnx_item"
void main()
{
    int iColor = StringToInt(GetScriptParam("Color"));
    int iParte = GetLocalInt(OBJECT_SELF, "ColorZona");
    //Se identifica el "material"
    if(iColor < 50)
    {
        object oPC = GetPCSpeaker();
        int iObjetoColor = GetLocalInt(OBJECT_SELF, "ObjetoColor");
        object oItem = GetItemInSlot(iObjetoColor, OBJECT_SELF);
        int iMaterialToDye = iColor;
        SetLocalInt(OBJECT_SELF, "MaterialToDye", iMaterialToDye);
        int iColor;
        //Si estamos coloreando por partes.
        if(iParte > 0){iParte = iParte - 1;}
        //Si estamos coloreando completo, se toma como base el torso.
        if(iParte <1){iParte = 7;}
        //6 + (Modelo + 6) + Material
        iParte = 6 + (iParte * 6) + iMaterialToDye;
        if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR){iColor = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, iParte);}
        else if(GetBaseItemType(oItem) == BASE_ITEM_HELMET){iColor = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, iMaterialToDye);}
        else if(GetBaseItemType(oItem) == BASE_ITEM_CLOAK){iColor = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, iMaterialToDye);}

        if(ClothColor(iColor) == "")
        {
            iColor = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, GetLocalInt(OBJECT_SELF,"MaterialToDye"));
        }
        SendMessageToPC(oPC, "Color actual: " + ClothColor(iColor));
    }
    //Se identifica el "grupo de color"
    else if(iColor >= 50 && iColor < 100)
    {
        SetLocalInt(OBJECT_SELF, "ColorGroup", iColor - 50);
    }
    //Se localiza el color
    else if(iColor >= 100)
    {
        SetLocalInt(OBJECT_SELF, "ColorToDye", iColor - 100);
        int iMaterialToDye = GetLocalInt(OBJECT_SELF, "MaterialToDye");
        int iColorGroup = GetLocalInt(OBJECT_SELF, "ColorGroup");
        int iColorToDye = GetLocalInt(OBJECT_SELF, "ColorToDye");
        int iObjetoColor = GetLocalInt(OBJECT_SELF, "ObjetoColor");
        int iColor = (iColorGroup * 8) + iColorToDye;
        object oItem = GetItemInSlot(iObjetoColor, OBJECT_SELF);
        int iSlot = iObjetoColor;

        if (GetIsObjectValid(oItem))
        {
            object oDyedItem, oDyedItem0, oDyedItem1, oDyedItem2, oDyedItem3, oDyedItem4, oDyedItem5, oDyedItem6, oDyedItem7, oDyedItem8, oDyedItem9, oDyedItem10, oDyedItem11, oDyedItem12, oDyedItem13, oDyedItem14, oDyedItem15, oDyedItem16, oDyedItem17;
            if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
            {
                //Coloreado completo.
                if(iParte <1)
                {
                    oDyedItem0 = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, 6 + (0 * 6) + iMaterialToDye, iColor, TRUE);
                    DestroyObject(oItem);
                    oDyedItem1 = CopyItemAndModify(oDyedItem0, ITEM_APPR_TYPE_ARMOR_COLOR, 6 + (1 * 6) + iMaterialToDye, iColor, TRUE);
                    DestroyObject(oDyedItem0);
                    oDyedItem2 = CopyItemAndModify(oDyedItem1, ITEM_APPR_TYPE_ARMOR_COLOR, 6 + (2 * 6) + iMaterialToDye, iColor, TRUE);
                    DestroyObject(oDyedItem1);
                    oDyedItem3 = CopyItemAndModify(oDyedItem2, ITEM_APPR_TYPE_ARMOR_COLOR, 6 + (3 * 6) + iMaterialToDye, iColor, TRUE);
                    DestroyObject(oDyedItem2);
                    oDyedItem4 = CopyItemAndModify(oDyedItem3, ITEM_APPR_TYPE_ARMOR_COLOR, 6 + (4 * 6) + iMaterialToDye, iColor, TRUE);
                    DestroyObject(oDyedItem3);
                    oDyedItem5 = CopyItemAndModify(oDyedItem4, ITEM_APPR_TYPE_ARMOR_COLOR, 6 + (5 * 6) + iMaterialToDye, iColor, TRUE);
                    DestroyObject(oDyedItem4);
                    oDyedItem6 = CopyItemAndModify(oDyedItem5, ITEM_APPR_TYPE_ARMOR_COLOR, 6 + (6 * 6) + iMaterialToDye, iColor, TRUE);
                    DestroyObject(oDyedItem5);
                    oDyedItem7 = CopyItemAndModify(oDyedItem6, ITEM_APPR_TYPE_ARMOR_COLOR, 6 + (7 * 6) + iMaterialToDye, iColor, TRUE);
                    DestroyObject(oDyedItem6);
                    oDyedItem8 = CopyItemAndModify(oDyedItem7, ITEM_APPR_TYPE_ARMOR_COLOR, 6 + (8 * 6) + iMaterialToDye, iColor, TRUE);
                    DestroyObject(oDyedItem7);
                    oDyedItem9 = CopyItemAndModify(oDyedItem8, ITEM_APPR_TYPE_ARMOR_COLOR, 6 + (9 * 6) + iMaterialToDye, iColor, TRUE);
                    DestroyObject(oDyedItem8);
                    oDyedItem10 = CopyItemAndModify(oDyedItem9, ITEM_APPR_TYPE_ARMOR_COLOR, 6 + (10 * 6) + iMaterialToDye, iColor, TRUE);
                    DestroyObject(oDyedItem9);
                    oDyedItem11 = CopyItemAndModify(oDyedItem10, ITEM_APPR_TYPE_ARMOR_COLOR, 6 + (11 * 6) + iMaterialToDye, iColor, TRUE);
                    DestroyObject(oDyedItem10);
                    oDyedItem12 = CopyItemAndModify(oDyedItem11, ITEM_APPR_TYPE_ARMOR_COLOR, 6 + (12 * 6) + iMaterialToDye, iColor, TRUE);
                    DestroyObject(oDyedItem11);
                    oDyedItem13 = CopyItemAndModify(oDyedItem12, ITEM_APPR_TYPE_ARMOR_COLOR, 6 + (13 * 6) + iMaterialToDye, iColor, TRUE);
                    DestroyObject(oDyedItem12);
                    oDyedItem14 = CopyItemAndModify(oDyedItem13, ITEM_APPR_TYPE_ARMOR_COLOR, 6 + (14 * 6) + iMaterialToDye, iColor, TRUE);
                    DestroyObject(oDyedItem13);
                    oDyedItem15 = CopyItemAndModify(oDyedItem14, ITEM_APPR_TYPE_ARMOR_COLOR, 6 + (15 * 6) + iMaterialToDye, iColor, TRUE);
                    DestroyObject(oDyedItem14);
                    oDyedItem16 = CopyItemAndModify(oDyedItem15, ITEM_APPR_TYPE_ARMOR_COLOR, 6 + (16 * 6) + iMaterialToDye, iColor, TRUE);
                    DestroyObject(oDyedItem15);
                    oDyedItem17 = CopyItemAndModify(oDyedItem16, ITEM_APPR_TYPE_ARMOR_COLOR, 6 + (17 * 6) + iMaterialToDye, iColor, TRUE);
                    DestroyObject(oDyedItem16);
                    oDyedItem = CopyItemAndModify(oDyedItem17, ITEM_APPR_TYPE_ARMOR_COLOR, 6 + (18 * 6) + iMaterialToDye, iColor, TRUE);
                    DestroyObject(oDyedItem17);
                }
                if(iParte > 0)
                {
                    iParte = iParte - 1;
                    //6 + (Modelo + 6) + Material
                    iParte = 6 + (iParte * 6) + iMaterialToDye;
                    oDyedItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, iParte, iColor, TRUE);
                }
            }
            else if(GetBaseItemType(oItem) == BASE_ITEM_HELMET){oDyedItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, iMaterialToDye, iColor, TRUE);}
            else if(GetBaseItemType(oItem) == BASE_ITEM_CLOAK){oDyedItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, iMaterialToDye, iColor, TRUE);}
            DestroyObject(oItem);
            DelayCommand(0.5f, AssignCommand(OBJECT_SELF, ActionEquipItem(oDyedItem, iSlot)));
        }
    }
}
