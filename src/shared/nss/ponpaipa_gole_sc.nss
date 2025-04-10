#include "inc_sum_golem"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int iGolem = CheckGolemActive(oPC);
    string sType = GetScriptParam("GOLEM_CONDITIONAL");
    string sType2 = GetScriptParam("GOLEM_TYPE");
    object oGolem = GetActiveGolemFromPlayer(oPC);
    if (sType == "CONDITIONAL_1"){
        if (iGolem && GetMaxHitPoints(oGolem)!= GetCurrentHitPoints(oGolem)) {
            int iPrice = GetRepairPriceByGolemType(oGolem);
            string sPrice = ColorTexto(IntToString(iPrice),TXT_COLOR_AMARILLO);
            SetCustomToken(1505,GetName(oGolem));
            SetCustomToken(1506,sPrice);
            SetLocalInt(OBJECT_SELF,GOLEM_VAR_NAME_REPAIR_PRICE,iPrice);
            return TRUE;
        }
    }
    else if (sType == "CONDITIONAL_2") return GetRepairPriceByGolemType(oGolem) < GetGold(oPC);
    else if (sType == "CONDITIONAL_3" &&
            (ObtenerIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_FLESH)  || ObtenerIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_CLAY)   ||
            ObtenerIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_STONE)   || ObtenerIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_IRON)   ||
            ObtenerIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_MITHRIL) || ObtenerIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_SHIELD) ||
            ObtenerIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_HOMUNCULUS))) return TRUE;
    else if (sType == "CONDITIONAL_4") return GetLocalInt(OBJECT_SELF,GOLEM_VAR_NAME_REPAIR_PRICE) < GetGold(oPC);
    else if (sType2 == "FLESH") {
        SetCustomToken(1507,ColorTexto(IntToString(GOLEM_PRICE_REVIVE_FLESH),TXT_COLOR_AMARILLO));
        SetLocalInt(OBJECT_SELF,GOLEM_VAR_NAME_REPAIR_PRICE,GOLEM_PRICE_REVIVE_FLESH);
        return ObtenerIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_FLESH);
    }
    else if (sType2 == "CLAY") {
        SetCustomToken(1508,ColorTexto(IntToString(GOLEM_PRICE_REVIVE_CLAY),TXT_COLOR_AMARILLO));
        SetLocalInt(OBJECT_SELF,GOLEM_VAR_NAME_REPAIR_PRICE,GOLEM_PRICE_REVIVE_CLAY);
        return ObtenerIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_CLAY);
    }
    else if (sType2 == "STONE") {
        SetCustomToken(1509,ColorTexto(IntToString(GOLEM_PRICE_REVIVE_STONE),TXT_COLOR_AMARILLO));
        SetLocalInt(OBJECT_SELF,GOLEM_VAR_NAME_REPAIR_PRICE,GOLEM_PRICE_REVIVE_STONE);
        return ObtenerIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_STONE);
    }
    else if (sType2 == "IRON")  {
        SetCustomToken(1510,ColorTexto(IntToString(GOLEM_PRICE_REVIVE_IRON),TXT_COLOR_AMARILLO));
        SetLocalInt(OBJECT_SELF,GOLEM_VAR_NAME_REPAIR_PRICE,GOLEM_PRICE_REVIVE_IRON);
        return ObtenerIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_IRON);
    }
    else if (sType2 == "MITHRIL") {
        SetCustomToken(1511,ColorTexto(IntToString(GOLEM_PRICE_REVIVE_MITHRIL),TXT_COLOR_AMARILLO));
        SetLocalInt(OBJECT_SELF,GOLEM_VAR_NAME_REPAIR_PRICE,GOLEM_PRICE_REVIVE_MITHRIL);
        return ObtenerIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_MITHRIL);
    }
    else if (sType2 == "SHIELD") {
        SetCustomToken(1512,ColorTexto(IntToString(GOLEM_PRICE_REVIVE_SHIELD),TXT_COLOR_AMARILLO));
        SetLocalInt(OBJECT_SELF,GOLEM_VAR_NAME_REPAIR_PRICE,GOLEM_PRICE_REVIVE_SHIELD);
        return ObtenerIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_SHIELD);
    }
    else if (sType2 == "HOMUNCULUS") {
        SetCustomToken(1513,ColorTexto(IntToString(GOLEM_PRICE_REVIVE_HOMUNCULUS),TXT_COLOR_AMARILLO));
        SetLocalInt(OBJECT_SELF,GOLEM_VAR_NAME_REPAIR_PRICE,GOLEM_PRICE_REVIVE_HOMUNCULUS);
        return ObtenerIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_HOMUNCULUS);
    }
    return FALSE;
}
