#include "x0_i0_henchman"


void GuardarHenchmen(object oPC);
void GuardarHenchmen(object oPC)
{
    object oHench, oDupe;
    string sHench;
    int ret, iSlot, iMax = 4;

    for (iSlot = 1; iSlot <= iMax; iSlot++)
    {
        oHench = GetHenchman(oPC, iSlot);
        if (!GetIsObjectValid(oHench))
            DBG_msg("No valid henchman to store");
        else
        {
            DBG_msg("Storing henchman: " + GetTag(oHench));
            sHench = GetName(oPC, TRUE) + IntToString(iSlot);
            ret = StoreCampaignDBObject(oPC, sHench, oHench);
            if (!ret)
                DBG_msg("Error attempting to store henchman " + GetName(oHench));
            else
                DBG_msg("Henchman " + GetName(oHench) + " stored successfully");
                SendMessageToPC(oPC, GetName(oHench) + "ha sido guardado");

        }

    }
}

void RestaurarHenchmen(object oPC);
void RestaurarHenchmen(object oPC)
{
    string sHench;
    object oHench, oDupe;
    location lLoc = GetLocation(oPC);
    int iSlot, iMax = 4;

    for (iSlot = 1; iSlot <= iMax; iSlot++)
    {
        sHench = GetName(oPC, TRUE) + IntToString(iSlot);
        oHench = RetrieveCampaignDBObject(oPC, sHench, lLoc);
        DelayCommand(0.5, DeleteCampaignDBVariable(oPC, sHench));
        if (GetIsObjectValid(oHench))
        {
            DelayCommand(0.5, HireHenchman(oPC, oHench));
            oDupe = GetNearestObjectByTag(GetTag(oHench), oHench);
            if ((oDupe != OBJECT_INVALID) && (oDupe != oHench))
            {
                AssignCommand(oDupe, SetIsDestroyable(TRUE));
                SetPlotFlag(oDupe,FALSE);
                SetImmortal(oDupe,FALSE);
                DestroyObject(oDupe);
            }
        }
        else
            DBG_msg("No valid henchman retrieved");
    }
}

void GuardarOrcBarb(object oPC);
void GuardarOrcBarb(object oPC)
{
    object oHench;
    int ret;
    string sHench;
    string sTag = "ow_sum_barb";

    if(GetTag(GetHenchman(oPC, 1)) == "ow_sum_barb" ) oHench = GetHenchman(oPC, 1);
    else if(GetTag(GetHenchman(oPC, 2)) == "ow_sum_barb" ) oHench = GetHenchman(oPC, 2);
    else if(GetTag(GetHenchman(oPC, 3)) == "ow_sum_barb" ) oHench = GetHenchman(oPC, 3);
    else if(GetTag(GetHenchman(oPC, 4)) == "ow_sum_barb" ) oHench = GetHenchman(oPC, 4);

    if (!GetIsObjectValid(oHench)) DBG_msg("No valid henchman to store");
    else
    {
        SetLocalString(oHench, "AMO", GetName(oPC, TRUE));
        RemoveHenchman(oPC, oHench);
        SetDidQuit(oPC, oHench);

        DBG_msg("Storing henchman: " + GetTag(oHench));
        string sPJNombre = GetName(oPC, TRUE);
        sHench = sPJNombre + sTag;
        //Si se pasa del límite de caracteres...
        if(GetStringLength(sHench)>32)
        {
            int iTagCriaturaCaracter = GetStringLength(sTag);
            int iNamePJCaracter = 32 - iTagCriaturaCaracter;
            string sPJNombreFinal = GetStringLeft(sPJNombre, iNamePJCaracter);
            sHench = sPJNombreFinal + sTag;
        }

        ret = StoreCampaignDBObject(oPC, sHench, oHench);
        if (!ret) DBG_msg("Error attempting to store henchman " + GetName(oHench));
        else
            DBG_msg("Henchman " + GetName(oHench) + " stored successfully");
            AddHenchman(oPC, oHench);
            SetLocalObject(oPC,"WAR_BARB_PNJ",oHench);
            SendMessageToPC(oPC, "Barbaro Guardado");
    }
}


void RestaurarOrcBarb(object oPC);
void RestaurarOrcBarb(object oPC)
{
    string sHench;
    object oHench, oDupe;
    string sTag = "ow_sum_barb";
    location lLoc = GetLocation(oPC);
    effect eSummon = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    effect eHeal = EffectResurrection();

    string sPJNombre = GetName(oPC, TRUE);
    sHench = sPJNombre + sTag;
    //Si se pasa del límite de caracteres...
    if(GetStringLength(sHench)>32)
    {
        int iTagCriaturaCaracter = GetStringLength(sTag);
        int iNamePJCaracter = 32 - iTagCriaturaCaracter;
        string sPJNombreFinal = GetStringLeft(sPJNombre, iNamePJCaracter);
        sHench = sPJNombreFinal + sTag;
    }
    oHench = RetrieveCampaignDBObject(oPC, sHench, lLoc);
    DelayCommand(0.5, DeleteCampaignDBVariable(oPC, sHench));
    if (GetIsObjectValid(oHench))
    {
        DelayCommand(0.5, HireHenchman(oPC, oHench));
        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSummon, oHench));
        if(GetCurrentHitPoints(oHench) < 1 ) DelayCommand(0.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , oHench));
    }
    else
        DBG_msg("No valid henchman retrieved");
}

void GuardarOrcAxe(object oPC);
void GuardarOrcAxe(object oPC)
{
    object oHench;
    int ret;
    string sHench;
    string sTag = "ow_sum_axe";

    if(GetTag(GetHenchman(oPC, 1)) == "ow_sum_axe" ) oHench = GetHenchman(oPC, 1);
    else if(GetTag(GetHenchman(oPC, 2)) == "ow_sum_axe" ) oHench = GetHenchman(oPC, 2);
    else if(GetTag(GetHenchman(oPC, 3)) == "ow_sum_axe" ) oHench = GetHenchman(oPC, 3);
    else if(GetTag(GetHenchman(oPC, 4)) == "ow_sum_axe" ) oHench = GetHenchman(oPC, 4);

    if (!GetIsObjectValid(oHench)) DBG_msg("No valid henchman to store");
    else
    {
        SetLocalString(oHench, "AMO", GetName(oPC, TRUE));
        RemoveHenchman(oPC, oHench);
        SetDidQuit(oPC, oHench);
        DBG_msg("Storing henchman: " + GetTag(oHench));
        string sPJNombre = GetName(oPC, TRUE);
        sHench = sPJNombre + sTag;
        //Si se pasa del límite de caracteres...
        if(GetStringLength(sHench)>32)
        {
            int iTagCriaturaCaracter = GetStringLength(sTag);
            int iNamePJCaracter = 32 - iTagCriaturaCaracter;
            string sPJNombreFinal = GetStringLeft(sPJNombre, iNamePJCaracter);
            sHench = sPJNombreFinal + sTag;
        }
        ret = StoreCampaignDBObject(oPC, sHench, oHench);
        if (!ret) DBG_msg("Error attempting to store henchman " + GetName(oHench));
        else
            DBG_msg("Henchman " + GetName(oHench) + " stored successfully");
            AddHenchman(oPC, oHench);
            SetLocalObject(oPC,"WAR_AXE_PNJ",oHench);
            SendMessageToPC(oPC, "Explorador Guardado");
    }
}

void RestaurarOrcAxe(object oPC);
void RestaurarOrcAxe(object oPC)
{
    string sHench;
    object oHench, oDupe;
    string sTag = "ow_sum_axe";
    location lLoc = GetLocation(oPC);
    effect eSummon = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    effect eHeal = EffectResurrection();

    string sPJNombre = GetName(oPC, TRUE);
    sHench = sPJNombre + sTag;
    //Si se pasa del límite de caracteres...
    if(GetStringLength(sHench)>32)
    {
        int iTagCriaturaCaracter = GetStringLength(sTag);
        int iNamePJCaracter = 32 - iTagCriaturaCaracter;
        string sPJNombreFinal = GetStringLeft(sPJNombre, iNamePJCaracter);
        sHench = sPJNombreFinal + sTag;
    }
    oHench = RetrieveCampaignDBObject(oPC, sHench, lLoc);
    DelayCommand(0.5, DeleteCampaignDBVariable(oPC, sHench));
    if (GetIsObjectValid(oHench))
    {
        DelayCommand(0.5, HireHenchman(oPC, oHench));
        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSummon, oHench));
        if(GetCurrentHitPoints(oHench) < 1 ) DelayCommand(0.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , oHench));
    }
    else
        DBG_msg("No valid henchman retrieved");
}

void GuardarOrcSham(object oPC);
void GuardarOrcSham(object oPC)
{
    object oHench;
    int ret;
    string sHench;
    string sTag = "ow_sum_sham";

    if(GetTag(GetHenchman(oPC, 1)) == "ow_sum_sham" ) oHench = GetHenchman(oPC, 1);
    else if(GetTag(GetHenchman(oPC, 2)) == "ow_sum_sham" ) oHench = GetHenchman(oPC, 2);
    else if(GetTag(GetHenchman(oPC, 3)) == "ow_sum_sham" ) oHench = GetHenchman(oPC, 3);
    else if(GetTag(GetHenchman(oPC, 4)) == "ow_sum_sham" ) oHench = GetHenchman(oPC, 4);

    if (!GetIsObjectValid(oHench)) DBG_msg("No valid henchman to store");
    else
    {
        SetLocalString(oHench, "AMO", GetName(oPC, TRUE));
        RemoveHenchman(oPC, oHench);
        SetDidQuit(oPC, oHench);
        DBG_msg("Storing henchman: " + GetTag(oHench));
        string sPJNombre = GetName(oPC, TRUE);
        sHench = sPJNombre + sTag;
        //Si se pasa del límite de caracteres...
        if(GetStringLength(sHench)>32)
        {
            int iTagCriaturaCaracter = GetStringLength(sTag);
            int iNamePJCaracter = 32 - iTagCriaturaCaracter;
            string sPJNombreFinal = GetStringLeft(sPJNombre, iNamePJCaracter);
            sHench = sPJNombreFinal + sTag;
        }
        ret = StoreCampaignDBObject(oPC, sHench, oHench);
        if (!ret) DBG_msg("Error attempting to store henchman " + GetName(oHench));
        else
            DBG_msg("Henchman " + GetName(oHench) + " stored successfully");
            AddHenchman(oPC, oHench);
            SetLocalObject(oPC,"WAR_SHAM_PNJ",oHench);
            SendMessageToPC(oPC, "Mago Guardado");
    }
}

void RestaurarOrcSham(object oPC);
void RestaurarOrcSham(object oPC)
{
    string sHench;
    object oHench, oDupe;
    string sTag = "ow_sum_sham";
    location lLoc = GetLocation(oPC);
    effect eSummon = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    effect eHeal = EffectResurrection();

    string sPJNombre = GetName(oPC, TRUE);
    sHench = sPJNombre + sTag;
    //Si se pasa del límite de caracteres...
    if(GetStringLength(sHench)>32)
    {
        int iTagCriaturaCaracter = GetStringLength(sTag);
        int iNamePJCaracter = 32 - iTagCriaturaCaracter;
        string sPJNombreFinal = GetStringLeft(sPJNombre, iNamePJCaracter);
        sHench = sPJNombreFinal + sTag;
    }
    oHench = RetrieveCampaignDBObject(oPC, sHench, lLoc);
    DelayCommand(0.5, DeleteCampaignDBVariable(oPC, sHench));
    if (GetIsObjectValid(oHench))
    {
        DelayCommand(0.5, HireHenchman(oPC, oHench));
        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSummon, oHench));
        if(GetCurrentHitPoints(oHench) < 1 ) DelayCommand(0.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , oHench));
    }
    else
        DBG_msg("No valid henchman retrieved");
}

void GuardarOrcFght(object oPC);
void GuardarOrcFght(object oPC)
{
    object oHench;
    int ret;
    string sHench;
    string sTag = "ow_sum_fght";

    if(GetTag(GetHenchman(oPC, 1)) == "ow_sum_fght" ) oHench = GetHenchman(oPC, 1);
    else if(GetTag(GetHenchman(oPC, 2)) == "ow_sum_fght" ) oHench = GetHenchman(oPC, 2);
    else if(GetTag(GetHenchman(oPC, 3)) == "ow_sum_fght" ) oHench = GetHenchman(oPC, 3);
    else if(GetTag(GetHenchman(oPC, 4)) == "ow_sum_fght" ) oHench = GetHenchman(oPC, 4);

    if (!GetIsObjectValid(oHench)) DBG_msg("No valid henchman to store");
    else
    {
        SetLocalString(oHench, "AMO", GetName(oPC, TRUE));
        RemoveHenchman(oPC, oHench);
        SetDidQuit(oPC, oHench);
        DBG_msg("Storing henchman: " + GetTag(oHench));
        string sPJNombre = GetName(oPC, TRUE);
        sHench = sPJNombre + sTag;
        //Si se pasa del límite de caracteres...
        if(GetStringLength(sHench)>32)
        {
            int iTagCriaturaCaracter = GetStringLength(sTag);
            int iNamePJCaracter = 32 - iTagCriaturaCaracter;
            string sPJNombreFinal = GetStringLeft(sPJNombre, iNamePJCaracter);
            sHench = sPJNombreFinal + sTag;
        }
        ret = StoreCampaignDBObject(oPC, sHench, oHench);
        if (!ret) DBG_msg("Error attempting to store henchman " + GetName(oHench));
        else
            DBG_msg("Henchman " + GetName(oHench) + " stored successfully");
            AddHenchman(oPC, oHench);
            SetLocalObject(oPC,"WAR_FGHT_PNJ",oHench);
            SendMessageToPC(oPC, "Guerrero Guardado");
    }

}

void RestaurarOrcFght(object oPC);
void RestaurarOrcFght(object oPC)
{
    string sHench;
    object oHench, oDupe;
    string sTag = "ow_sum_fght";
    location lLoc = GetLocation(oPC);
    effect eSummon = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    effect eHeal = EffectResurrection();

    string sPJNombre = GetName(oPC, TRUE);
    sHench = sPJNombre + sTag;
    //Si se pasa del límite de caracteres...
    if(GetStringLength(sHench)>32)
    {
        int iTagCriaturaCaracter = GetStringLength(sTag);
        int iNamePJCaracter = 32 - iTagCriaturaCaracter;
        string sPJNombreFinal = GetStringLeft(sPJNombre, iNamePJCaracter);
        sHench = sPJNombreFinal + sTag;
    }
    oHench = RetrieveCampaignDBObject(oPC, sHench, lLoc);
    DelayCommand(0.5, DeleteCampaignDBVariable(oPC, sHench));
    if (GetIsObjectValid(oHench))
    {
        DelayCommand(0.5, HireHenchman(oPC, oHench));
        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSummon, oHench));
        if(GetCurrentHitPoints(oHench) < 1 ) DelayCommand(0.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , oHench));
    }
    else
        DBG_msg("No valid henchman retrieved");
}

void GuardarLadron1(object oPC);
void GuardarLadron1(object oPC)
{
    object oHench;
    int ret;
    string sHench;
    string sTag = "conj_ladsombras";

    if(GetTag(GetHenchman(oPC, 1)) == "conj_ladsombras" ) oHench = GetHenchman(oPC, 1);
    else if(GetTag(GetHenchman(oPC, 2)) == "conj_ladsombras" ) oHench = GetHenchman(oPC, 2);
    else if(GetTag(GetHenchman(oPC, 3)) == "conj_ladsombras" ) oHench = GetHenchman(oPC, 3);
    else if(GetTag(GetHenchman(oPC, 4)) == "conj_ladsombras" ) oHench = GetHenchman(oPC, 4);

    if (!GetIsObjectValid(oHench)) DBG_msg("No valid henchman to store");
    else
    {
        SetLocalString(oHench, "AMO", GetName(oPC, TRUE));
        RemoveHenchman(oPC, oHench);
        SetDidQuit(oPC, oHench);
        DBG_msg("Storing henchman: " + GetTag(oHench));
        string sPJNombre = GetName(oPC, TRUE);
        sHench = sPJNombre + sTag;
        //Si se pasa del límite de caracteres...
        if(GetStringLength(sHench)>32)
        {
            int iTagCriaturaCaracter = GetStringLength(sTag);
            int iNamePJCaracter = 32 - iTagCriaturaCaracter;
            string sPJNombreFinal = GetStringLeft(sPJNombre, iNamePJCaracter);
            sHench = sPJNombreFinal + sTag;
        }
        ret = StoreCampaignDBObject(oPC, sHench, oHench);
        if (!ret) DBG_msg("Error attempting to store henchman " + GetName(oHench));
        else
            DBG_msg("Henchman " + GetName(oHench) + " stored successfully");
            AddHenchman(oPC, oHench);
            SetLocalObject(oPC,"DOTE_REPUTACION1_PNJ",oHench);
            SendMessageToPC(oPC, "Aliado Guardado");
    }
}

void RestaurarLadron1(object oPC);
void RestaurarLadron1(object oPC)
{
    string sHench;
    object oHench, oDupe;
    string sTag = "conj_ladsombras";
    location lLoc = GetLocation(oPC);
    effect eSummon = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    effect eHeal = EffectResurrection();

    string sPJNombre = GetName(oPC, TRUE);
    sHench = sPJNombre + sTag;
    //Si se pasa del límite de caracteres...
    if(GetStringLength(sHench)>32)
    {
        int iTagCriaturaCaracter = GetStringLength(sTag);
        int iNamePJCaracter = 32 - iTagCriaturaCaracter;
        string sPJNombreFinal = GetStringLeft(sPJNombre, iNamePJCaracter);
        sHench = sPJNombreFinal + sTag;
    }
    oHench = RetrieveCampaignDBObject(oPC, sHench, lLoc);
    DelayCommand(0.5, DeleteCampaignDBVariable(oPC, sHench));
    if (GetIsObjectValid(oHench))
    {
        DelayCommand(0.5, HireHenchman(oPC, oHench));
        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSummon, oHench));
        if(GetCurrentHitPoints(oHench) < 1 ) DelayCommand(0.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , oHench));
    }
    else
        DBG_msg("No valid henchman retrieved");
}

void GuardarLadron2(object oPC);
void GuardarLadron2(object oPC)
{
    object oHench;
    int ret;
    string sHench;
    string sTag = "conj_ladsombras2";

    if(GetTag(GetHenchman(oPC, 1)) == "conj_ladsombras2" ) oHench = GetHenchman(oPC, 1);
    else if(GetTag(GetHenchman(oPC, 2)) == "conj_ladsombras2" ) oHench = GetHenchman(oPC, 2);
    else if(GetTag(GetHenchman(oPC, 3)) == "conj_ladsombras2" ) oHench = GetHenchman(oPC, 3);
    else if(GetTag(GetHenchman(oPC, 4)) == "conj_ladsombras2" ) oHench = GetHenchman(oPC, 4);

    if (!GetIsObjectValid(oHench)) DBG_msg("No valid henchman to store");
    else
    {
        SetLocalString(oHench, "AMO", GetName(oPC, TRUE));
        RemoveHenchman(oPC, oHench);
        SetDidQuit(oPC, oHench);
        DBG_msg("Storing henchman: " + GetTag(oHench));
        string sPJNombre = GetName(oPC, TRUE);
        sHench = sPJNombre + sTag;
        //Si se pasa del límite de caracteres...
        if(GetStringLength(sHench)>32)
        {
            int iTagCriaturaCaracter = GetStringLength(sTag);
            int iNamePJCaracter = 32 - iTagCriaturaCaracter;
            string sPJNombreFinal = GetStringLeft(sPJNombre, iNamePJCaracter);
            sHench = sPJNombreFinal + sTag;
        }
        ret = StoreCampaignDBObject(oPC, sHench, oHench);
        if (!ret) DBG_msg("Error attempting to store henchman " + GetName(oHench));
        else
            DBG_msg("Henchman " + GetName(oHench) + " stored successfully");
            AddHenchman(oPC, oHench);
            SetLocalObject(oPC,"DOTE_REPUTACION2_PNJ",oHench);
            SendMessageToPC(oPC, "Aliado Guardado");
    }
}

void RestaurarLadron2(object oPC);
void RestaurarLadron2(object oPC)
{
    string sHench;
    object oHench, oDupe;
    string sTag = "conj_ladsombras2";
    location lLoc = GetLocation(oPC);
    effect eSummon = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    effect eHeal = EffectResurrection();

    string sPJNombre = GetName(oPC, TRUE);
    sHench = sPJNombre + sTag;
    //Si se pasa del límite de caracteres...
    if(GetStringLength(sHench)>32)
    {
        int iTagCriaturaCaracter = GetStringLength(sTag);
        int iNamePJCaracter = 32 - iTagCriaturaCaracter;
        string sPJNombreFinal = GetStringLeft(sPJNombre, iNamePJCaracter);
        sHench = sPJNombreFinal + sTag;
    }
    oHench = RetrieveCampaignDBObject(oPC, sHench, lLoc);
    DelayCommand(0.5, DeleteCampaignDBVariable(oPC, sHench));
    if (GetIsObjectValid(oHench))
    {
        DelayCommand(0.5, HireHenchman(oPC, oHench));
        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSummon, oHench));
        if(GetCurrentHitPoints(oHench) < 1 ) DelayCommand(0.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , oHench));
    }
    else
        DBG_msg("No valid henchman retrieved");
}

void GuardarLadron3(object oPC);
void GuardarLadron3(object oPC)
{
    object oHench;
    int ret;
    string sHench;
    string sTag = "conj_ladsombras3";

    if(GetTag(GetHenchman(oPC, 1)) == "conj_ladsombras3" ) oHench = GetHenchman(oPC, 1);
    else if(GetTag(GetHenchman(oPC, 2)) == "conj_ladsombras3" ) oHench = GetHenchman(oPC, 2);
    else if(GetTag(GetHenchman(oPC, 3)) == "conj_ladsombras3" ) oHench = GetHenchman(oPC, 3);
    else if(GetTag(GetHenchman(oPC, 4)) == "conj_ladsombras3" ) oHench = GetHenchman(oPC, 4);

    if (!GetIsObjectValid(oHench)) DBG_msg("No valid henchman to store");
    else
    {
        SetLocalString(oHench, "AMO", GetName(oPC, TRUE));
        RemoveHenchman(oPC, oHench);
        SetDidQuit(oPC, oHench);
        DBG_msg("Storing henchman: " + GetTag(oHench));
        string sPJNombre = GetName(oPC, TRUE);
        sHench = sPJNombre + sTag;
        //Si se pasa del límite de caracteres...
        if(GetStringLength(sHench)>32)
        {
            int iTagCriaturaCaracter = GetStringLength(sTag);
            int iNamePJCaracter = 32 - iTagCriaturaCaracter;
            string sPJNombreFinal = GetStringLeft(sPJNombre, iNamePJCaracter);
            sHench = sPJNombreFinal + sTag;
        }
        ret = StoreCampaignDBObject(oPC, sHench, oHench);
        if (!ret) DBG_msg("Error attempting to store henchman " + GetName(oHench));
        else
            DBG_msg("Henchman " + GetName(oHench) + " stored successfully");
            AddHenchman(oPC, oHench);
            SetLocalObject(oPC,"DOTE_REPUTACION3_PNJ",oHench);
            SendMessageToPC(oPC, "Aliado Guardado");
    }
}

void RestaurarLadron3(object oPC);
void RestaurarLadron3(object oPC)
{
    string sHench;
    object oHench, oDupe;
    string sTag = "conj_ladsombras3";
    location lLoc = GetLocation(oPC);
    effect eSummon = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    effect eHeal = EffectResurrection();

    string sPJNombre = GetName(oPC, TRUE);
    sHench = sPJNombre + sTag;
    //Si se pasa del límite de caracteres...
    if(GetStringLength(sHench)>32)
    {
        int iTagCriaturaCaracter = GetStringLength(sTag);
        int iNamePJCaracter = 32 - iTagCriaturaCaracter;
        string sPJNombreFinal = GetStringLeft(sPJNombre, iNamePJCaracter);
        sHench = sPJNombreFinal + sTag;
    }
    oHench = RetrieveCampaignDBObject(oPC, sHench, lLoc);
    DelayCommand(0.5, DeleteCampaignDBVariable(oPC, sHench));
    if (GetIsObjectValid(oHench))
    {
        DelayCommand(0.5, HireHenchman(oPC, oHench));
        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSummon, oHench));
        if(GetCurrentHitPoints(oHench) < 1 ) DelayCommand(0.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , oHench));
    }
    else
        DBG_msg("No valid henchman retrieved");
}

void GuardarLiderazgo(object oPC);
void GuardarLiderazgo(object oPC)
{
    object oHench;
    int ret;
    string sHench;
    string sTag = "conj_lider";

    if(GetTag(GetHenchman(oPC, 1)) == "conj_lider" ) oHench = GetHenchman(oPC, 1);
    else if(GetTag(GetHenchman(oPC, 2)) == "conj_lider" ) oHench = GetHenchman(oPC, 2);
    else if(GetTag(GetHenchman(oPC, 3)) == "conj_lider" ) oHench = GetHenchman(oPC, 3);
    else if(GetTag(GetHenchman(oPC, 4)) == "conj_lider" ) oHench = GetHenchman(oPC, 4);

    if (!GetIsObjectValid(oHench)) DBG_msg("No valid henchman to store");
    else
    {
        SetLocalString(oHench, "AMO", GetName(oPC, TRUE));
        RemoveHenchman(oPC, oHench);
        SetDidQuit(oPC, oHench);
        DBG_msg("Storing henchman: " + GetTag(oHench));
        string sPJNombre = GetName(oPC, TRUE);
        sHench = sPJNombre + sTag;
        //Si se pasa del límite de caracteres...
        if(GetStringLength(sHench)>32)
        {
            int iTagCriaturaCaracter = GetStringLength(sTag);
            int iNamePJCaracter = 32 - iTagCriaturaCaracter;
            string sPJNombreFinal = GetStringLeft(sPJNombre, iNamePJCaracter);
            sHench = sPJNombreFinal + sTag;
        }
        ret = StoreCampaignDBObject(oPC, sHench, oHench);
        if (!ret) DBG_msg("Error attempting to store henchman " + GetName(oHench));
        else
            DBG_msg("Henchman " + GetName(oHench) + " stored successfully");
            AddHenchman(oPC, oHench);
            SetLocalObject(oPC,"DOTE_LIDERAZGO_PNJ",oHench);
            SendMessageToPC(oPC, "Aliado Guardado");
    }
}

void RestaurarLiderazgo(object oPC);
void RestaurarLiderazgo(object oPC)
{
    string sHench;
    object oHench, oDupe;
    string sTag = "conj_lider";
    location lLoc = GetLocation(oPC);
    effect eSummon = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    effect eHeal = EffectResurrection();

    string sPJNombre = GetName(oPC, TRUE);
    sHench = sPJNombre + sTag;
    //Si se pasa del límite de caracteres...
    if(GetStringLength(sHench)>32)
    {
        int iTagCriaturaCaracter = GetStringLength(sTag);
        int iNamePJCaracter = 32 - iTagCriaturaCaracter;
        string sPJNombreFinal = GetStringLeft(sPJNombre, iNamePJCaracter);
        sHench = sPJNombreFinal + sTag;
    }
    oHench = RetrieveCampaignDBObject(oPC, sHench, lLoc);
    DelayCommand(0.5, DeleteCampaignDBVariable(oPC, sHench));
    if (GetIsObjectValid(oHench))
    {
        DelayCommand(0.5, HireHenchman(oPC, oHench));
        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSummon, oHench));
        if(GetCurrentHitPoints(oHench) < 1 ) DelayCommand(0.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , oHench));
    }
    else
        DBG_msg("No valid henchman retrieved");
}

void GuardarMDL(object oPC);
void GuardarMDL(object oPC)
{
    object oHench;
    int ret;
    string sHench;
    string sTag = "conj_mdl";

    if(GetTag(GetHenchman(oPC, 1)) == "conj_mdl" ) oHench = GetHenchman(oPC, 1);
    else if(GetTag(GetHenchman(oPC, 2)) == "conj_mdl" ) oHench = GetHenchman(oPC, 2);
    else if(GetTag(GetHenchman(oPC, 3)) == "conj_mdl" ) oHench = GetHenchman(oPC, 3);
    else if(GetTag(GetHenchman(oPC, 4)) == "conj_mdl" ) oHench = GetHenchman(oPC, 4);

    if (!GetIsObjectValid(oHench)) DBG_msg("No valid henchman to store");
    else
    {
        SetLocalString(oHench, "AMO", GetName(oPC, TRUE));
        RemoveHenchman(oPC, oHench);
        SetDidQuit(oPC, oHench);
        DBG_msg("Storing henchman: " + GetTag(oHench));
        string sPJNombre = GetName(oPC, TRUE);
        sHench = sPJNombre + sTag;
        //Si se pasa del límite de caracteres...
        if(GetStringLength(sHench)>32)
        {
            int iTagCriaturaCaracter = GetStringLength(sTag);
            int iNamePJCaracter = 32 - iTagCriaturaCaracter;
            string sPJNombreFinal = GetStringLeft(sPJNombre, iNamePJCaracter);
            sHench = sPJNombreFinal + sTag;
        }
        ret = StoreCampaignDBObject(oPC, sHench, oHench);
        if (!ret) DBG_msg("Error attempting to store henchman " + GetName(oHench));
        else
        DBG_msg("Henchman " + GetName(oHench) + " stored successfully");
        AddHenchman(oPC, oHench);
        SetLocalObject(oPC,"DOTE_MDL_PNJ",oHench);
        SendMessageToPC(oPC, "Aliado Guardado");
    }
}

void RestaurarMDL(object oPC);
void RestaurarMDL(object oPC)
{
    string sHench;
    object oHench, oDupe;
    string sTag = "conj_mdl";
    location lLoc = GetLocation(oPC);
    effect eSummon = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    effect eHeal = EffectResurrection();

    string sPJNombre = GetName(oPC, TRUE);
    sHench = sPJNombre + sTag;
    //Si se pasa del límite de caracteres...
    if(GetStringLength(sHench)>32)
    {
        int iTagCriaturaCaracter = GetStringLength(sTag);
        int iNamePJCaracter = 32 - iTagCriaturaCaracter;
        string sPJNombreFinal = GetStringLeft(sPJNombre, iNamePJCaracter);
        sHench = sPJNombreFinal + sTag;
    }
    oHench = RetrieveCampaignDBObject(oPC, sHench, lLoc);
    DelayCommand(0.5, DeleteCampaignDBVariable(oPC, sHench));
    if (GetIsObjectValid(oHench))
    {
        DelayCommand(0.5, HireHenchman(oPC, oHench));
        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSummon, oHench));
        if(GetCurrentHitPoints(oHench) < 1 ) DelayCommand(0.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal , oHench));
    }
    else
    DBG_msg("No valid henchman retrieved");
}




//void main(){}





