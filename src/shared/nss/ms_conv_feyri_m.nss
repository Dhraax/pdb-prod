#include "mti_libreria"
#include "nwnx_creature"
#include "pb_constantes"

////////////////////////////////////////////////
/////////// ACCIONES DE LAS OPCIONES ///////////
////////////////////////////////////////////////

void ResetConversation(object oPC) {
    DeleteLocalInt(oPC, "CONV_FEYRI_FEATS_LENGTH");
    DeleteLocalInt(oPC, "CONV_FEYRI_FEATS_0");
    DeleteLocalInt(oPC, "CONV_FEYRI_FEATS_1");
    DeleteLocalInt(oPC, "CONV_FEYRI_FEATS_2");
    DeleteLocalInt(oPC, "CONV_FEYRI_FEATS_3");
    DeleteLocalInt(oPC, "CONV_FEYRI_SPECIAL");
    DeleteLocalInt(oPC, "CONV_FEYRI_CANFINISH");
}

void FinishFeatSelection(object oPC) {
    int i, nFeatTableLength = GetLocalInt(oPC, "CONV_FEYRI_FEATS_LENGTH");

    for (i = 0; i < nFeatTableLength; i++)
    {
        int nCurrentFeatId = GetLocalInt(oPC, "CONV_FEYRI_FEATS_" + IntToString(i));
        NWNX_Creature_AddFeat(oPC, nCurrentFeatId);

        string sItemResRef;
        if (nCurrentFeatId >= FEAT_APTDEM_CHARM_PERSON && nCurrentFeatId <= FEAT_APTDEM_SUGGESTION) {
            switch(nCurrentFeatId) {
                case FEAT_APTDEM_CHARM_PERSON:   sItemResRef = "crr_ogro_hecper";   break;
                case FEAT_APTDEM_CLAIRVOYANCE:   sItemResRef = "crr_clairvoyance";  break;
                case FEAT_APTDEM_ENERVATION:     sItemResRef = "crr_ennervation";   break;
                case FEAT_APTDEM_DARKNESS:       sItemResRef = "crr_subrace_2";     break;
                case FEAT_APTDEM_DIMENSION_DOOR: sItemResRef = "crr_gtele001";      break;
                case FEAT_APTDEM_SUGGESTION:     sItemResRef = "crr_suggestion";    break;
            }

            CreateItemOnObject(sItemResRef, oPC);
        }
    }
    GuardarIntPersistente(oPC, "FEYRI_APTDEM", TRUE);

    //Quitamos del jugador el modo cutsecene
    SetCutsceneMode(oPC, FALSE);
}

void main()
{
    object oPC = GetPCSpeaker();
    string sFunction = GetScriptParam("FUNCTION");

    if (sFunction == "SelectFeat") {
        int nFeatTableLength = GetLocalInt(oPC, "CONV_FEYRI_FEATS_LENGTH");
        int nFeatId = StringToInt(GetScriptParam("FEATID"));
        int bSpecial = StringToInt(GetScriptParam("SPECIAL"));

        SetLocalInt(oPC, "CONV_FEYRI_FEATS_" + IntToString(nFeatTableLength), nFeatId);
        SetLocalInt(oPC, "CONV_FEYRI_FEATS_LENGTH", nFeatTableLength + 1);
        if (bSpecial) SetLocalInt(oPC, "CONV_FEYRI_SPECIAL", TRUE);
        if (nFeatTableLength == 3) SetLocalInt(oPC, "CONV_FEYRI_CANFINISH", TRUE);
    }
    else if (sFunction == "Reset") {
        ResetConversation(oPC);
    }
    else if (sFunction == "Finish") {
        FinishFeatSelection(oPC);
        ResetConversation(oPC);
    }
}
