////////////////////////////////////////////////
//////// CONDICIONES PARA MOSTRAR TEXTO ////////
////////////////////////////////////////////////
int CheckIfFeatHasBeenSelected(object oPC, int nFeatId) {
    int i, nFeatTableLength = GetLocalInt(oPC, "CONV_FEYRI_FEATS_LENGTH");

    for (i = 0; i < nFeatTableLength; i++)
    {
        int nCurrentFeatId = GetLocalInt(oPC, "CONV_FEYRI_FEATS_" + IntToString(i));
        if (nCurrentFeatId == nFeatId) return TRUE;
    }

    return FALSE;
}

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    string sFunction = GetScriptParam("FUNCTION");

    if (sFunction == "ShouldSeeFeat") {
        int nFeatId = StringToInt(GetScriptParam("FEATID"));
        int bSpecial = StringToInt(GetScriptParam("SPECIAL"));
        int bCanFinish = GetLocalInt(oPC, "CONV_FEYRI_CANFINISH");

        if (bCanFinish) return FALSE;
        if (bSpecial && GetLocalInt(oPC, "CONV_FEYRI_SPECIAL")) return FALSE;
        if (CheckIfFeatHasBeenSelected(oPC, nFeatId)) return FALSE;
    }
    else if (sFunction == "CanFinish") {
        if (GetLocalInt(oPC, "CONV_FEYRI_CANFINISH")) {
            return TRUE;
        }
        else return FALSE;
    }

    return TRUE;
}
