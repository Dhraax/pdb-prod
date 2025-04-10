#include "inc_sum_golem"

void main()
{
    object oPC = GetPCSpeaker();
    object oGolem = GetActiveGolemFromPlayer(oPC);
    string sParam = GetScriptParam("GOLEM_ACTION");

    if (sParam == "REPAIR"){
        RepairDamagedGolem(oGolem);
        BorrarIntPersistente(oPC,GOLEM_VAR_NAME_HP);
        TakeGoldFromCreature(GetLocalInt(OBJECT_SELF,GOLEM_VAR_NAME_REPAIR_PRICE),oPC);
    }
    else if(sParam == "RESTORE_FLESH") {
        BorrarIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_FLESH);
        TakeGoldFromCreature(GOLEM_PRICE_REVIVE_FLESH,oPC);
    }
    else if(sParam == "RESTORE_CLAY") {
        BorrarIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_CLAY);
        TakeGoldFromCreature(GOLEM_PRICE_REVIVE_CLAY,oPC);
    }
    else if(sParam == "RESTORE_STONE") {
        BorrarIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_STONE);
        TakeGoldFromCreature(GOLEM_PRICE_REVIVE_STONE,oPC);
    }
    else if(sParam == "RESTORE_IRON") {
        BorrarIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_IRON);
        TakeGoldFromCreature(GOLEM_PRICE_REVIVE_IRON,oPC);
    }
    else if(sParam == "RESTORE_MITHRIL") {
        BorrarIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_MITHRIL);
        TakeGoldFromCreature(GOLEM_PRICE_REVIVE_MITHRIL,oPC);
    }
    else if(sParam == "RESTORE_SHIELD") {
        BorrarIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_SHIELD);
        TakeGoldFromCreature(GOLEM_PRICE_REVIVE_SHIELD,oPC);
    }
    else if(sParam == "RESTORE_HOMUNCULUS") {
        BorrarIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_HOMUNCULUS);
        TakeGoldFromCreature(GOLEM_PRICE_REVIVE_HOMUNCULUS,oPC);
    }
}
