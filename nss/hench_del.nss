#include "x0_i0_henchman"
#include "mti_libreria"

void main()
{
    object oPC = GetPCSpeaker();
    string sHench;

    //Recuperamos la variable para los aliados
    GuardarIntPersistente(oPC, "DOTE_REPUTACION1", FALSE);
    GuardarIntPersistente(oPC, "LADMUERTO1", 0);
    sHench = GetName(oPC) + "conj_ladsombras1";
    DeleteCampaignDBVariable(oPC, sHench);

    GuardarIntPersistente(oPC, "DOTE_REPUTACION2", FALSE);
    GuardarIntPersistente(oPC, "LADMUERTO2", 0);
    sHench = GetName(oPC) + "conj_ladsombras2";
    DeleteCampaignDBVariable(oPC, sHench);

    GuardarIntPersistente(oPC, "DOTE_REPUTACION3", FALSE);
    GuardarIntPersistente(oPC, "LADMUERTO3", 0);
    sHench = GetName(oPC) + "conj_ladsombras3";
    DeleteCampaignDBVariable(oPC, sHench);

    GuardarIntPersistente(oPC, "WAR_AXE", FALSE);
    GuardarIntPersistente(oPC, "AXEMUERTO", 0);
    sHench = GetName(oPC) + "ow_sum_axe";
    DeleteCampaignDBVariable(oPC, sHench);

    GuardarIntPersistente(oPC, "WAR_BARB", FALSE);
    GuardarIntPersistente(oPC, "BARBMUERTO", 0);
    sHench = GetName(oPC) + "ow_sum_barb";
    DeleteCampaignDBVariable(oPC, sHench);

    GuardarIntPersistente(oPC, "WAR_FGHT", FALSE);
    GuardarIntPersistente(oPC, "FGHTMUERTO", 0);
    sHench = GetName(oPC) + "ow_sum_fght";
    DeleteCampaignDBVariable(oPC, sHench);

    GuardarIntPersistente(oPC, "WAR_SHAM", FALSE);
    GuardarIntPersistente(oPC, "SHAMMUERTO", 0);
    sHench = GetName(oPC) + "ow_sum_sham";
    DeleteCampaignDBVariable(oPC, sHench);

    GuardarIntPersistente(oPC, "DOTE_LIDERAZGO", FALSE);
    GuardarIntPersistente(oPC, "ALIADOGUERRERO", 0);
    sHench = GetName(oPC) + "conj_lider";
    DeleteCampaignDBVariable(oPC, sHench);

    GuardarIntPersistente(oPC, "DOTE_MDL", FALSE);
    GuardarIntPersistente(oPC, "ALIADOMDL", 0);
    sHench = GetName(oPC) + "conj_mdl";
    DeleteCampaignDBVariable(oPC, sHench);

    SendMessageToPC(oPC, "Tus aliados han sido borrados");

}
