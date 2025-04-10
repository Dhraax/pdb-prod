#include "btlr__inc"
#include "sastre_inc"
#include "mti_libreria"

// Get a Cached 2DA string, and if its not cached read it from the 2DA file and cache it.
string GetCachedACBonus(string sFile, int iRow);

// Get the Cached Upper limit for a 2DA file.  If not cached, determine the Limit and cache it.
int GetCachedLimitev(string sFile);

string GetCachedACBonusArmor(string sFile, int iRow);

string GetSpokenPart();

//Copiamos el objeto del PJ al sastre.
void main()
{
    object oPC = GetPCSpeaker();
    int iTipo = StringToInt(GetScriptParam("Modo"));

    //Le borramos los items.
    if(iTipo == 1)
    {
        DestruirItemEquipados (OBJECT_SELF);
        DestruirItemsInventario(OBJECT_SELF,"",1);
        object oArmadura = CreateItemOnObject("Clothing", OBJECT_SELF, 1);
        ActionEquipItem(oArmadura, INVENTORY_SLOT_CHEST);
    }
    //Borramos items y reseteamos apariencia.
    else if(iTipo == 2)
    {
        DestruirItemEquipados (OBJECT_SELF);
        DestruirItemsInventario(OBJECT_SELF,"",1);
        SetCreatureWingType(0, OBJECT_SELF);
        SetCreatureTailType(0, OBJECT_SELF);
        SetCreatureBodyPart(CREATURE_PART_HEAD, 1, OBJECT_SELF);
        SetCreatureBodyPart(CREATURE_PART_LEFT_BICEP, 1, OBJECT_SELF);
        SetCreatureBodyPart(CREATURE_PART_LEFT_FOOT, 1, OBJECT_SELF);
        SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, 1, OBJECT_SELF);
        SetCreatureBodyPart(CREATURE_PART_LEFT_HAND, 1, OBJECT_SELF);
        SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, 1, OBJECT_SELF);
        SetCreatureBodyPart(CREATURE_PART_LEFT_THIGH, 1, OBJECT_SELF);
        SetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP, 1, OBJECT_SELF);
        SetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT, 1, OBJECT_SELF);
        SetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM, 1, OBJECT_SELF);
        SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, 1, OBJECT_SELF);
        SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, 1, OBJECT_SELF);
        SetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH, 1, OBJECT_SELF);
        SetCreatureBodyPart(CREATURE_PART_NECK, 1, OBJECT_SELF);
        SetCreatureBodyPart(CREATURE_PART_PELVIS, 1, OBJECT_SELF);
        SetCreatureBodyPart(CREATURE_PART_TORSO, 1, OBJECT_SELF);
        ApplyEyes(0, OBJECT_SELF);
        SetPhenoType(PHENOTYPE_NORMAL);
        SetColor(OBJECT_SELF, COLOR_CHANNEL_SKIN, 0);
        SetColor(OBJECT_SELF, COLOR_CHANNEL_HAIR, 0);
        SetColor(OBJECT_SELF, COLOR_CHANNEL_TATTOO_1, 0);
        SetColor(OBJECT_SELF, COLOR_CHANNEL_TATTOO_2, 0);
    }
    //Reequipamos el equipamiento para quitar fallos.
    else if(iTipo == 3)
    {
        object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
        object oHelmet = GetItemInSlot(INVENTORY_SLOT_HEAD, OBJECT_SELF);
        object oCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK, OBJECT_SELF);
        AssignCommand(OBJECT_SELF, ActionUnequipItem(oArmor));
        AssignCommand(OBJECT_SELF, ActionUnequipItem(oHelmet));
        AssignCommand(OBJECT_SELF, ActionUnequipItem(oCloak));
        DelayCommand(2.0f, AssignCommand(OBJECT_SELF, ActionEquipItem(oArmor, INVENTORY_SLOT_CHEST)));
        DelayCommand(2.0f, AssignCommand(OBJECT_SELF, ActionEquipItem(oHelmet, INVENTORY_SLOT_HEAD)));
        DelayCommand(2.0f, AssignCommand(OBJECT_SELF, ActionEquipItem(oCloak, INVENTORY_SLOT_CLOAK)));
    }
    //Siguiente/Anterior apariencia
    else if(iTipo == 4 || iTipo == 5)
    {
        //Modificamos la armadura.
        object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
        if(!GetIsObjectValid(oItem)){SendMessageToPC(oPC, "<c´$$>El modelo sastre no tiene equipada ninguna armadura.</c>");return;}
        //Numero de la modificación actual.
        int iToModify = GetLocalInt(OBJECT_SELF, "ToModify");
        string s2DAFile = GetLocalString(OBJECT_SELF, "2DAFile");

        int iNewApp;
        //Nueva apariencia.
        if(iTipo == 4)
        {
            iNewApp = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, iToModify) + 1;
            string s2DA_ACBonus = GetCachedACBonus(s2DAFile, iNewApp);
            while (s2DA_ACBonus == "SKIP" || s2DA_ACBonus == "FAIL")
            {
                //if(iNewApp > 255) iNewApp = 0;
                if (s2DA_ACBonus == "FAIL")
                {
                    iNewApp = 1;
                }
                else
                {
                    iNewApp++;
                }
                s2DA_ACBonus = GetCachedACBonus(s2DAFile, iNewApp);
            }
        }
        if(iTipo == 5)
        {
            iNewApp = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, iToModify) - 1;
            string s2DA_ACBonus = GetCachedACBonus(s2DAFile, iNewApp);
            while (s2DA_ACBonus == "SKIP" || s2DA_ACBonus == "FAIL")
            {
                //if(iNewApp < 0) iNewApp = 255;
                if (s2DA_ACBonus == "FAIL")
                {
                    iNewApp = GetCachedLimitev(s2DAFile);
                }
                else
                {
                    iNewApp--;
                }
                s2DA_ACBonus = GetCachedACBonus(s2DAFile, iNewApp);
            }
        }

        object oNewItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, iToModify, iNewApp, TRUE);

        DestroyObject(oItem);
        SendMessageToPC(oPC, "<c þ >Nueva apariencia: " + IntToString(iNewApp) + "</c>");

        AssignCommand(OBJECT_SELF, ActionEquipItem(oNewItem, INVENTORY_SLOT_CHEST));

        if(GetLocalInt(OBJECT_SELF, "Simetria") == 1)
        {
            int iSimetria;

            switch (iToModify)
            {
                case ITEM_APPR_ARMOR_MODEL_RBICEP:
                {
                    iSimetria = ITEM_APPR_ARMOR_MODEL_LBICEP;
                    break;
                }
                case ITEM_APPR_ARMOR_MODEL_RFOOT:
                {
                    iSimetria = ITEM_APPR_ARMOR_MODEL_LFOOT;
                    break;
                }
                case ITEM_APPR_ARMOR_MODEL_RFOREARM:
                {
                    iSimetria = ITEM_APPR_ARMOR_MODEL_LFOREARM;
                    break;
                }
                case ITEM_APPR_ARMOR_MODEL_RHAND:
                {
                    iSimetria = ITEM_APPR_ARMOR_MODEL_LHAND;
                    break;
                }
                case ITEM_APPR_ARMOR_MODEL_RSHIN:
                {
                    iSimetria = ITEM_APPR_ARMOR_MODEL_LSHIN;
                    break;
                }
                case ITEM_APPR_ARMOR_MODEL_RSHOULDER:
                {
                    iSimetria = ITEM_APPR_ARMOR_MODEL_LSHOULDER;
                    break;
                }
                case ITEM_APPR_ARMOR_MODEL_RTHIGH:
                {
                    iSimetria = ITEM_APPR_ARMOR_MODEL_LTHIGH;
                    break;
                }
                case ITEM_APPR_ARMOR_MODEL_LBICEP:
                {
                    iSimetria = ITEM_APPR_ARMOR_MODEL_RBICEP;
                    break;
                }
                case ITEM_APPR_ARMOR_MODEL_LFOOT:
                {
                    iSimetria = ITEM_APPR_ARMOR_MODEL_RFOOT;
                    break;
                }
                case ITEM_APPR_ARMOR_MODEL_LFOREARM:
                {
                    iSimetria = ITEM_APPR_ARMOR_MODEL_RFOREARM;
                    break;
                }
                case ITEM_APPR_ARMOR_MODEL_LHAND:
                {
                    iSimetria = ITEM_APPR_ARMOR_MODEL_RHAND;
                    break;
                }
                case ITEM_APPR_ARMOR_MODEL_LSHIN:
                {
                    iSimetria = ITEM_APPR_ARMOR_MODEL_RSHIN;
                    break;
                }
                case ITEM_APPR_ARMOR_MODEL_LSHOULDER:
                {
                    iSimetria = ITEM_APPR_ARMOR_MODEL_RSHOULDER;
                    break;
                }
                case ITEM_APPR_ARMOR_MODEL_LTHIGH:
                {
                    iSimetria = ITEM_APPR_ARMOR_MODEL_RTHIGH;
                    break;
                }
                default:  return;
            }
            object oNewItemSimetria = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_MODEL, iSimetria, iNewApp, TRUE);
            DestroyObject(oNewItem);
            AssignCommand(OBJECT_SELF, ActionEquipItem(oNewItemSimetria, INVENTORY_SLOT_CHEST));
         }
    }
    //Sastre escucha ON.
    else if(iTipo == 6)
    {
        SetListenPattern(OBJECT_SELF, "**", 8888);
        SetListening(OBJECT_SELF, TRUE);
        SetLocalObject(OBJECT_SELF, "tlr_Client", GetPCSpeaker());
    }
    //Sastre escucha, armadura.
    else if(iTipo == 7)
    {
        //Modificamos la armadura.
        object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
        if(!GetIsObjectValid(oItem)){SendMessageToPC(oPC, "<c´$$>El modelo sastre no tiene equipada ninguna armadura.</c>");return;}
        //Numero de la modificación actual.
        int iToModify = GetLocalInt(OBJECT_SELF, "ToModify");
        int iNewApp = StringToInt(GetSpokenPart());
        if(iNewApp < 0) iNewApp = 255;
        object oNewItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, iToModify, iNewApp, TRUE);
        DestroyObject(oItem);
        SendMessageToPC(oPC, "<c þ >Nueva apariencia: " + IntToString(iNewApp) + "</c>");
        AssignCommand(OBJECT_SELF, ActionEquipItem(oNewItem, INVENTORY_SLOT_CHEST));
    }
    //Sastre escucha OFF.
    else if(iTipo == 8)
    {
        SetListening(OBJECT_SELF, FALSE);
    }
    //Copiar de un lado
    else if(iTipo == 9)
    {

        object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
        if(!GetIsObjectValid(oItem)){SendMessageToPC(oPC, "<c´$$>El modelo sastre no tiene equipada ninguna armadura.</c>");return;}
        int iToModify = GetLocalInt(OBJECT_SELF, "ToModify");
        int iNewLook;
        switch (iToModify)
        {
            case ITEM_APPR_ARMOR_MODEL_RBICEP: {  iNewLook = ITEM_APPR_ARMOR_MODEL_LBICEP; break; }
            case ITEM_APPR_ARMOR_MODEL_RFOOT: {  iNewLook = ITEM_APPR_ARMOR_MODEL_LFOOT; break; }
            case ITEM_APPR_ARMOR_MODEL_RFOREARM: {  iNewLook = ITEM_APPR_ARMOR_MODEL_LFOREARM; break; }
            case ITEM_APPR_ARMOR_MODEL_RHAND: {  iNewLook = ITEM_APPR_ARMOR_MODEL_LHAND; break; }
            case ITEM_APPR_ARMOR_MODEL_RSHIN: {  iNewLook = ITEM_APPR_ARMOR_MODEL_LSHIN; break; }
            case ITEM_APPR_ARMOR_MODEL_RSHOULDER: {  iNewLook = ITEM_APPR_ARMOR_MODEL_LSHOULDER; break; }
            case ITEM_APPR_ARMOR_MODEL_RTHIGH: {  iNewLook = ITEM_APPR_ARMOR_MODEL_LTHIGH; break; }
            case ITEM_APPR_ARMOR_MODEL_LBICEP: {  iNewLook = ITEM_APPR_ARMOR_MODEL_RBICEP; break; }
            case ITEM_APPR_ARMOR_MODEL_LFOOT: {  iNewLook = ITEM_APPR_ARMOR_MODEL_RFOOT; break; }
            case ITEM_APPR_ARMOR_MODEL_LFOREARM: {  iNewLook = ITEM_APPR_ARMOR_MODEL_RFOREARM; break; }
            case ITEM_APPR_ARMOR_MODEL_LHAND: {  iNewLook = ITEM_APPR_ARMOR_MODEL_RHAND; break; }
            case ITEM_APPR_ARMOR_MODEL_LSHIN: {  iNewLook = ITEM_APPR_ARMOR_MODEL_RSHIN; break; }
            case ITEM_APPR_ARMOR_MODEL_LSHOULDER: {  iNewLook = ITEM_APPR_ARMOR_MODEL_RSHOULDER; break; }
            case ITEM_APPR_ARMOR_MODEL_LTHIGH: {  iNewLook = ITEM_APPR_ARMOR_MODEL_RTHIGH; break; }
            default:  return;
        }
        int iNewApp = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, iNewLook);
        object oNewItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, iToModify, iNewApp, TRUE);
        DestroyObject(oItem);
        DelayCommand(0.5f, AssignCommand(OBJECT_SELF, ActionEquipItem(oNewItem, INVENTORY_SLOT_CHEST)));
    }
    //Copiar de un lado
    else if(iTipo == 10)
    {

        object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
        if(!GetIsObjectValid(oItem)){SendMessageToPC(oPC, "<c´$$>El modelo sastre no tiene equipada ninguna armadura.</c>");return;}
        int iToModify = GetLocalInt(OBJECT_SELF, "ToModify");
        int iNewLook;
        switch (iToModify)
        {
            case ITEM_APPR_ARMOR_MODEL_RBICEP:
            {
                iNewLook = ITEM_APPR_ARMOR_MODEL_RBICEP;
                iToModify = ITEM_APPR_ARMOR_MODEL_LBICEP;
                break;
            }
            case ITEM_APPR_ARMOR_MODEL_RFOOT:
            {
                iNewLook = ITEM_APPR_ARMOR_MODEL_RFOOT;
                iToModify = ITEM_APPR_ARMOR_MODEL_LFOOT;
                break;
            }
            case ITEM_APPR_ARMOR_MODEL_RFOREARM:
            {
                iNewLook = ITEM_APPR_ARMOR_MODEL_RFOREARM;
                iToModify = ITEM_APPR_ARMOR_MODEL_LFOREARM;
                break;
            }
            case ITEM_APPR_ARMOR_MODEL_RHAND:
            {
                iNewLook = ITEM_APPR_ARMOR_MODEL_RHAND;
                iToModify = ITEM_APPR_ARMOR_MODEL_LHAND;
                break;
            }
            case ITEM_APPR_ARMOR_MODEL_RSHIN:
            {
                iNewLook = ITEM_APPR_ARMOR_MODEL_RSHIN;
                iToModify = ITEM_APPR_ARMOR_MODEL_LSHIN;
                break;
            }
            case ITEM_APPR_ARMOR_MODEL_RSHOULDER:
            {
                iNewLook = ITEM_APPR_ARMOR_MODEL_RSHOULDER;
                iToModify = ITEM_APPR_ARMOR_MODEL_LSHOULDER;
                break;
            }
            case ITEM_APPR_ARMOR_MODEL_RTHIGH:
            {
                iNewLook = ITEM_APPR_ARMOR_MODEL_RTHIGH;
                iToModify = ITEM_APPR_ARMOR_MODEL_LTHIGH;
                break;
            }
            case ITEM_APPR_ARMOR_MODEL_LBICEP:
            {
                iNewLook = ITEM_APPR_ARMOR_MODEL_LBICEP;
                iToModify = ITEM_APPR_ARMOR_MODEL_RBICEP;
                break;
            }
            case ITEM_APPR_ARMOR_MODEL_LFOOT:
            {
                iNewLook = ITEM_APPR_ARMOR_MODEL_LFOOT;
                iToModify = ITEM_APPR_ARMOR_MODEL_RFOOT;
                break;
            }
            case ITEM_APPR_ARMOR_MODEL_LFOREARM:
            {
                iNewLook = ITEM_APPR_ARMOR_MODEL_LFOREARM;
                iToModify = ITEM_APPR_ARMOR_MODEL_RFOREARM;
                break;
            }
            case ITEM_APPR_ARMOR_MODEL_LHAND:
            {
                iNewLook = ITEM_APPR_ARMOR_MODEL_LHAND;
                iToModify = ITEM_APPR_ARMOR_MODEL_RHAND;
                break;
            }
            case ITEM_APPR_ARMOR_MODEL_LSHIN:
            {
                iNewLook = ITEM_APPR_ARMOR_MODEL_LSHIN;
                iToModify = ITEM_APPR_ARMOR_MODEL_RSHIN;
                break;
            }
            case ITEM_APPR_ARMOR_MODEL_LSHOULDER:
            {
                iNewLook = ITEM_APPR_ARMOR_MODEL_LSHOULDER;
                iToModify = ITEM_APPR_ARMOR_MODEL_RSHOULDER;
                break;
            }
            case ITEM_APPR_ARMOR_MODEL_LTHIGH:
            {
                iNewLook = ITEM_APPR_ARMOR_MODEL_LTHIGH;
                iToModify = ITEM_APPR_ARMOR_MODEL_RTHIGH;
                break;
            }
            default:  return;
        }
        int iNewApp = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, iNewLook);
        object oNewItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, iToModify, iNewApp, TRUE);
        DestroyObject(oItem);
        DelayCommand(0.5f, AssignCommand(OBJECT_SELF, ActionEquipItem(oNewItem, INVENTORY_SLOT_CHEST)));
    }
    //Sastre elimina pieza
    else if(iTipo == 11)
    {
        //Modificamos la armadura.
        object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
        if(!GetIsObjectValid(oItem)){SendMessageToPC(oPC, "<c´$$>El modelo sastre no tiene equipada ninguna armadura.</c>");return;}
        //Numero de la modificación actual.
        int iToModify = GetLocalInt(OBJECT_SELF, "ToModify");
        int iNewApp = 0;
        object oNewItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, iToModify, iNewApp, TRUE);
        DestroyObject(oItem);
        SendMessageToPC(oPC, "<c þ >Nueva apariencia: " + IntToString(iNewApp) + "</c>");
        AssignCommand(OBJECT_SELF, ActionEquipItem(oNewItem, INVENTORY_SLOT_CHEST));
    }
    //Giramos el modelo en sentido del reloj.
    else if(iTipo == 12)
    {
        float fNewFace = GetFacing(OBJECT_SELF) - 30.0;
        if (fNewFace < 0.0) fNewFace += 360.0;
        AssignCommand(OBJECT_SELF, SetFacing(fNewFace));
    }
    //Giramos el modelo en contrasentido del reloj.
    else if(iTipo == 13)
    {
        float fNewFace = GetFacing(OBJECT_SELF) + 30.0;
        if (fNewFace > 360.0) fNewFace -= 360.0;
        AssignCommand(OBJECT_SELF, SetFacing(fNewFace));
    }
    //Cambiamos el torso.
    else if(iTipo == 14 || iTipo == 15)
    {
        object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
        if(!GetIsObjectValid(oItem)){SendMessageToPC(oPC, "<c´$$>El modelo sastre no tiene equipada ninguna armadura.</c>");return;}
        int iToModify = GetLocalInt(OBJECT_SELF, "ToModify");
        string s2DAFile = "parts_chest";
        int iNewApp = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, iToModify);
        int iFilter = GetArmorType(oItem);
        if(iTipo == 14)
        {
            iNewApp = iNewApp + 1;
            string s2DA_ACBonus = GetCachedACBonusArmor(s2DAFile, iNewApp);
            while (StringToInt(s2DA_ACBonus) != iFilter)
            {
                if (s2DA_ACBonus == "-2")
                {
                    iNewApp = 1;
                }
                else
                {
                    iNewApp++;
                }
                if(iNewApp > 255) {iNewApp = 0;}
                s2DA_ACBonus = GetCachedACBonusArmor(s2DAFile, iNewApp);

            }
        }
        if(iTipo == 15)
        {
            iNewApp = iNewApp - 1;
            string s2DA_ACBonus = GetCachedACBonusArmor(s2DAFile, iNewApp);
            while (StringToInt(s2DA_ACBonus) != iFilter)
            {
                if (s2DA_ACBonus == "-2")
                {
                    iNewApp = 1;
                }
                else
                {
                    iNewApp--;
                }
                if(iNewApp < 0) {iNewApp = 255;}
                s2DA_ACBonus = GetCachedACBonusArmor(s2DAFile, iNewApp);
            }
        }

        object oNewItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, iToModify, iNewApp, TRUE);
        DestroyObject(oItem);
        int iAC = GetArmorType(oNewItem);
        SendMessageToPC(oPC, "<c þ >Nueva apariencia: " + IntToString(iNewApp) + ", CA: "+ IntToString(iAC) +".</c>");
        AssignCommand(OBJECT_SELF, ActionEquipItem(oNewItem, INVENTORY_SLOT_CHEST));
    }
    //Siguiente yelmo.
    else if(iTipo == 16)
    {
        object oHelmet = GetItemInSlot(INVENTORY_SLOT_HEAD, OBJECT_SELF);
        if(!GetIsObjectValid(oHelmet)){SendMessageToPC(oPC, "<c´$$>El modelo sastre no tiene equipado ningún yelmo.</c>");return;}
        RemakeHelm(OBJECT_SELF, oHelmet, PART_NEXT);
    }
    //Anterior yelmo.
    else if(iTipo == 17)
    {
        object oHelmet = GetItemInSlot(INVENTORY_SLOT_HEAD, OBJECT_SELF);
        if(!GetIsObjectValid(oHelmet)){SendMessageToPC(oPC, "<c´$$>El modelo sastre no tiene equipado ningún yelmo.</c>");return;}
        RemakeHelm(OBJECT_SELF, oHelmet, PART_PREV);
    }
    //Eliminar el yelmo.
    else if(iTipo == 18)
    {
        object oHelm = GetItemInSlot(INVENTORY_SLOT_HEAD, OBJECT_SELF);
        if(!GetIsObjectValid(oHelm)){SendMessageToPC(oPC, "<c´$$>El modelo sastre no tiene equipado ningún yelmo.</c>");return;}
        DelayCommand(0.5f, AssignCommand(OBJECT_SELF, ActionUnequipItem(oHelm)));
        DestroyObject(oHelm,0.6f);
    }
    //Siguiente capa.
    else if(iTipo == 19)
    {
        object oHelmet = GetItemInSlot(INVENTORY_SLOT_CLOAK, OBJECT_SELF);
        if(!GetIsObjectValid(oHelmet)){SendMessageToPC(oPC, "<c´$$>El modelo sastre no tiene equipada ninguna capa.</c>");return;}
        RemakeCloak(OBJECT_SELF, oHelmet, PART_NEXT);
    }
    //Anterior capa.
    else if(iTipo == 20)
    {
        object oHelmet = GetItemInSlot(INVENTORY_SLOT_CLOAK, OBJECT_SELF);
        if(!GetIsObjectValid(oHelmet)){SendMessageToPC(oPC, "<c´$$>El modelo sastre no tiene equipada ninguna capa.</c>");return;}
        RemakeCloak(OBJECT_SELF, oHelmet, PART_PREV);
    }
    //Eliminar el capa.
    else if(iTipo == 21)
    {
        object oHelm = GetItemInSlot(INVENTORY_SLOT_CLOAK, OBJECT_SELF);
        if(!GetIsObjectValid(oHelm)){SendMessageToPC(oPC, "<c´$$>El modelo sastre no tiene equipada ninguna capa.</c>");return;}
        DelayCommand(0.5f, AssignCommand(OBJECT_SELF, ActionUnequipItem(oHelm)));
        DestroyObject(oHelm,0.6f);
    }
    //Incrementar escudo.
    else if(iTipo == 22)
    {
        object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, OBJECT_SELF);
        if(!GetIsObjectValid(oItem)){SendMessageToPC(oPC, "<c´$$>El modelo sastre no tiene equipado ningún escudo.</c>");return;}
        RemakeShield(OBJECT_SELF, oItem, PART_NEXT);
    }
    //Reducir escudo.
    else if(iTipo == 23)
    {
        object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, OBJECT_SELF);
        if(!GetIsObjectValid(oItem)){SendMessageToPC(oPC, "<c´$$>El modelo sastre no tiene equipado ningún escudo.</c>");return;}
        RemakeShield(OBJECT_SELF, oItem, PART_PREV);
    }
    //Eliminar escudo.
    else if(iTipo == 24)
    {
        object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, OBJECT_SELF);
        if(!GetIsObjectValid(oItem)){SendMessageToPC(oPC, "<c´$$>El modelo sastre no tiene equipado ningún escudo.</c>");return;}
        DestroyObject(oItem);
    }
    //Incrementar arma.
    else if(iTipo == 25)
    {
        int iZona = GetLocalInt(OBJECT_SELF, "ArmaZona");
        object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
        if(!GetIsObjectValid(oItem)){SendMessageToPC(oPC, "<c´$$>El modelo sastre no tiene equipada ninguna arma.</c>");return;}
        RemakeWeapon(OBJECT_SELF, oItem, iZona, PART_NEXT);
    }
    //Reducir arma.
    else if(iTipo == 26)
    {
        int iZona = GetLocalInt(OBJECT_SELF, "ArmaZona");
        object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
        if(!GetIsObjectValid(oItem)){SendMessageToPC(oPC, "<c´$$>El modelo sastre no tiene equipada ninguna arma.</c>");return;}
        RemakeWeapon(OBJECT_SELF, oItem, iZona, PART_PREV);
    }
    //Incrementar color arma.
    else if(iTipo == 27)
    {
        int iZona = GetLocalInt(OBJECT_SELF, "ArmaZona");
        object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
        if(!GetIsObjectValid(oItem)){SendMessageToPC(oPC, "<c´$$>El modelo sastre no tiene equipada ninguna arma.</c>");return;}
        ColorItem(OBJECT_SELF, oItem, iZona, COLOR_NEXT);
    }
    //Reducir color arma.
    else if(iTipo == 28)
    {
        int iZona = GetLocalInt(OBJECT_SELF, "ArmaZona");
        object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
        if(!GetIsObjectValid(oItem)){SendMessageToPC(oPC, "<c´$$>El modelo sastre no tiene equipada ninguna arma.</c>");return;}
        ColorItem(OBJECT_SELF, oItem, iZona, COLOR_PREV);
    }
    //Eliminar arma.
    else if(iTipo == 29)
    {
        object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
        if(!GetIsObjectValid(oItem)){SendMessageToPC(oPC, "<c´$$>El modelo sastre no tiene equipada ninguna arma.</c>");return;}
        DestroyObject(oItem);
    }

    //Cambiar la apariencia del modelo.
    else if(iTipo == 30){SetCreatureAppearanceType(OBJECT_SELF, APPEARANCE_TYPE_DWARF);}
    else if(iTipo == 31){SetCreatureAppearanceType(OBJECT_SELF, APPEARANCE_TYPE_ELF);}
    else if(iTipo == 32){SetCreatureAppearanceType(OBJECT_SELF, APPEARANCE_TYPE_GNOME);}
    else if(iTipo == 33){SetCreatureAppearanceType(OBJECT_SELF, APPEARANCE_TYPE_HALFLING);}
    else if(iTipo == 34){SetCreatureAppearanceType(OBJECT_SELF, APPEARANCE_TYPE_HALF_ELF);}
    else if(iTipo == 35){SetCreatureAppearanceType(OBJECT_SELF, APPEARANCE_TYPE_HALF_ORC);}
    else if(iTipo == 36){SetCreatureAppearanceType(OBJECT_SELF, APPEARANCE_TYPE_HUMAN);}
    else if(iTipo == 38){SetCreatureAppearanceType(OBJECT_SELF, 7528);}
    else if(iTipo == 39){SetCreatureAppearanceType(OBJECT_SELF, 7527);}
    //CA del Torso
    else if(iTipo == 37)
    {
        int iApa = StringToInt(GetScriptParam("Apariencia"));
        object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
        object oNewItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, 7, iApa, TRUE);
        DestroyObject(oItem);
        int iAC = GetArmorType(oNewItem);
        SendMessageToPC(oPC, "<c þ >Nueva apariencia: " + IntToString(iApa) + ", CA: "+ IntToString(iAC) +".</c>");
        AssignCommand(OBJECT_SELF, ActionEquipItem(oNewItem, INVENTORY_SLOT_CHEST));
    }
}



















string GetCachedACBonus(string sFile, int iRow)
{
    string sACBonus = GetLocalString(GetModule(), sFile + IntToString(iRow));
    if (sACBonus == "")
    {
        sACBonus = Get2DAString(sFile, "ACBONUS", iRow);
        if (sACBonus == "" || Get2DAString(sFile, "HASMODEL", iRow) == "")
        {
            sACBonus = "SKIP";
            string sCost = Get2DAString(sFile, "COSTMODIFIER", iRow);
            if (sCost == "") { sACBonus = "FAIL"; }
        }
        SetLocalString(GetModule(), sFile + IntToString(iRow), sACBonus);
    }
    return sACBonus;
}

int GetCachedLimitev(string sFile)
{
    int iLimit = GetLocalInt(GetModule(), sFile + "Limit");

    if (iLimit == 0) {
        int iCount = 0;

        while (Get2DAString(sFile, "COSTMODIFIER", iCount + 1) != "")
        {
            iCount++;
        }

        SetLocalInt(GetModule(), sFile + "Limit", iCount);
        iLimit = iCount;
    }
    return iLimit;
}

string GetCachedACBonusArmor(string sFile, int iRow)
{
    string sACBonus = GetLocalString(GetModule(), sFile + IntToString(iRow));

    if (sACBonus == "")
    {
        sACBonus = Get2DAString(sFile, "ACBONUS", iRow);

        if (sACBonus == "")
        {
            sACBonus = "-1";
            string sCost = Get2DAString(sFile, "COSTMODIFIER", iRow);
            if (sCost == "" )
            {
                sACBonus = "-2";
            }
        }

        SetLocalString(GetModule(), sFile + IntToString(iRow), sACBonus);
    }

    return sACBonus;
}

//Get Spoken Clothing Part for CEP
string GetSpokenPart()
{
    int iCount = 0;
    int iMax = GetMatchedSubstringsCount();
    string sName;
    int iListen = GetListenPatternNumber();

    //Added DMFI support for CEP
    if(iListen == 8888 ||
       iListen == 20600)
        {
        while(iCount<iMax)
            {
            sName = sName+GetMatchedSubstring(iCount);
            iCount++;
            }
        }
    SetListening(OBJECT_SELF, FALSE);
    return sName;
}
