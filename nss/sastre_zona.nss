void main()
{
    int iZona = StringToInt(GetScriptParam("Zona"));
    int iSimetria = StringToInt(GetScriptParam("Simetria"));

    if(iZona == -1){DeleteLocalInt(OBJECT_SELF, "Simetria");}
    if(iSimetria == 1){SetLocalInt(OBJECT_SELF, "Simetria", 1);}

    //ARMADURAS//
    //Cuello.
    if(iZona == 1)
    {
        SetLocalInt(OBJECT_SELF, "ToModify", ITEM_APPR_ARMOR_MODEL_NECK);
        SetLocalString(OBJECT_SELF, "2DAFile", "parts_neck");
    }
    //Torso
    else if(iZona == 2)
    {
        SetLocalInt(OBJECT_SELF, "ToModify", ITEM_APPR_ARMOR_MODEL_TORSO);
        SetLocalString(OBJECT_SELF, "2DAFile", "parts_chest");
    }
    //Cinturon
    else if(iZona == 3)
    {
        SetLocalInt(OBJECT_SELF, "ToModify", ITEM_APPR_ARMOR_MODEL_BELT);
        SetLocalString(OBJECT_SELF, "2DAFile", "parts_belt");
    }
    //Pelvis
    else if(iZona == 4)
    {
        SetLocalInt(OBJECT_SELF, "ToModify", ITEM_APPR_ARMOR_MODEL_PELVIS);
        SetLocalString(OBJECT_SELF, "2DAFile", "parts_pelvis");
    }
    //Hombro derecho
    else if(iZona == 5)
    {
        SetLocalInt(OBJECT_SELF, "ToModify", ITEM_APPR_ARMOR_MODEL_RSHOULDER);
        SetLocalString(OBJECT_SELF, "2DAFile", "parts_shoulder");
    }
    //Hombro izquierdo
    else if(iZona == 6)
    {
        SetLocalInt(OBJECT_SELF, "ToModify", ITEM_APPR_ARMOR_MODEL_LSHOULDER);
        SetLocalString(OBJECT_SELF, "2DAFile", "parts_shoulder");
    }
    //Bíceps derecho
    else if(iZona == 7)
    {
        SetLocalInt(OBJECT_SELF, "ToModify", ITEM_APPR_ARMOR_MODEL_RBICEP);
        SetLocalString(OBJECT_SELF, "2DAFile", "parts_bicep");
    }
    //Bíceps izquierdo
    else if(iZona == 8)
    {
        SetLocalInt(OBJECT_SELF, "ToModify", ITEM_APPR_ARMOR_MODEL_LBICEP);
        SetLocalString(OBJECT_SELF, "2DAFile", "parts_bicep");
    }
    //Antebrazo derecho
    else if(iZona == 9)
    {
        SetLocalInt(OBJECT_SELF, "ToModify", ITEM_APPR_ARMOR_MODEL_RFOREARM);
        SetLocalString(OBJECT_SELF, "2DAFile", "parts_forearm");
    }
    //Antebrazo izquierdo
    else if(iZona == 10)
    {
        SetLocalInt(OBJECT_SELF, "ToModify", ITEM_APPR_ARMOR_MODEL_LFOREARM);
        SetLocalString(OBJECT_SELF, "2DAFile", "parts_forearm");
    }
    //Mano derecha
    else if(iZona == 11)
    {
        SetLocalInt(OBJECT_SELF, "ToModify", ITEM_APPR_ARMOR_MODEL_RHAND);
        SetLocalString(OBJECT_SELF, "2DAFile", "parts_hand");
    }
    //Mano izquierda.
    else if(iZona == 12)
    {
        SetLocalInt(OBJECT_SELF, "ToModify", ITEM_APPR_ARMOR_MODEL_LHAND);
        SetLocalString(OBJECT_SELF, "2DAFile", "parts_hand");
    }
    //Muslo derecho.
    else if(iZona == 13)
    {
        SetLocalInt(OBJECT_SELF, "ToModify", ITEM_APPR_ARMOR_MODEL_RTHIGH);
        SetLocalString(OBJECT_SELF, "2DAFile", "parts_legs");
    }
    //Muslo izquierdo.
    else if(iZona == 14)
    {
        SetLocalInt(OBJECT_SELF, "ToModify", ITEM_APPR_ARMOR_MODEL_LTHIGH);
        SetLocalString(OBJECT_SELF, "2DAFile", "parts_legs");
    }
    //Espinilla derecha.
    else if(iZona == 15)
    {
    SetLocalInt(OBJECT_SELF, "ToModify", ITEM_APPR_ARMOR_MODEL_RSHIN);
    SetLocalString(OBJECT_SELF, "2DAFile", "parts_shin");
    }
    //Espinilla izquierda.
    else if(iZona == 16)
    {
        SetLocalInt(OBJECT_SELF, "ToModify", ITEM_APPR_ARMOR_MODEL_LSHIN);
        SetLocalString(OBJECT_SELF, "2DAFile", "parts_shin");
    }
    //Pie derecho.
    else if(iZona == 17)
    {
        SetLocalInt(OBJECT_SELF, "ToModify", ITEM_APPR_ARMOR_MODEL_RFOOT);
        SetLocalString(OBJECT_SELF, "2DAFile", "parts_foot");
    }
    //Pie izquierdo.
    else if(iZona == 18)
    {
        SetLocalInt(OBJECT_SELF, "ToModify", ITEM_APPR_ARMOR_MODEL_LFOOT);
        SetLocalString(OBJECT_SELF, "2DAFile", "parts_foot");
    }
    //Túnica.
    else if(iZona == 19)
    {
        SetLocalInt(OBJECT_SELF, "ToModify", ITEM_APPR_ARMOR_MODEL_ROBE);
        SetLocalString(OBJECT_SELF, "2DAFile", "parts_robe");
    }

    //TIPO DE TORSOS
    else if(iZona == 20)
    {
        SetLocalInt(OBJECT_SELF, "TorsoFilter", iZona-20);
    }
    else if(iZona == 21)
    {
        SetLocalInt(OBJECT_SELF, "TorsoFilter", iZona-20);
    }
    else if(iZona == 22)
    {
        SetLocalInt(OBJECT_SELF, "TorsoFilter", iZona-20);
    }
    else if(iZona == 23)
    {
        SetLocalInt(OBJECT_SELF, "TorsoFilter", iZona-20);
    }
    else if(iZona == 24)
    {
        SetLocalInt(OBJECT_SELF, "TorsoFilter", iZona-20);
    }
    else if(iZona == 25)
    {
        SetLocalInt(OBJECT_SELF, "TorsoFilter", iZona-20);
    }
    else if(iZona == 26)
    {
        SetLocalInt(OBJECT_SELF, "TorsoFilter", iZona-20);
    }
    else if(iZona == 27)
    {
        SetLocalInt(OBJECT_SELF, "TorsoFilter", iZona-20);
    }
    else if(iZona == 28)
    {
        SetLocalInt(OBJECT_SELF, "TorsoFilter", iZona-20);
    }

    //Colorear la armadura.
    else if(iZona == 29)
    {
        SetLocalInt(OBJECT_SELF, "ObjetoColor", INVENTORY_SLOT_CHEST);
    }
    else if(iZona == 30)
    {
        SetLocalInt(OBJECT_SELF, "ObjetoColor", INVENTORY_SLOT_HEAD);
    }
    else if(iZona == 31)
    {
        SetLocalInt(OBJECT_SELF, "ObjetoColor", INVENTORY_SLOT_CLOAK);
    }

    //Armas.
    else if(iZona == 32)
    {
        SetLocalInt(OBJECT_SELF, "ArmaZona", ITEM_APPR_WEAPON_MODEL_TOP);
    }
    else if(iZona == 33)
    {
        SetLocalInt(OBJECT_SELF, "ArmaZona", ITEM_APPR_WEAPON_MODEL_MIDDLE);
    }
    else if(iZona == 34)
    {
        SetLocalInt(OBJECT_SELF, "ArmaZona", ITEM_APPR_WEAPON_MODEL_BOTTOM);
    }
    else if(iZona > 99)
    {
        SetLocalInt(OBJECT_SELF, "ColorZona", iZona - 100);
    }
}
