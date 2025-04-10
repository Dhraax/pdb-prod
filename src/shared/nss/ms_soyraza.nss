#include "pb_constantes"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int iRaza = GetRacialType(OBJECT_SELF);
    string sSubRaza = GetSubRace(OBJECT_SELF);
    int iModo = StringToInt(GetScriptParam("Modo"));

    //Conversación general.
    if(iModo == 1)
    {
        if(iRaza == RACIAL_TYPE_AASIMAR) return TRUE;
        else if(iRaza == RACIAL_TYPE_CELADRIN)   return TRUE;
        else if(iRaza == RACIAL_TYPE_DROW)   return TRUE;
        else if(iRaza == RACIAL_TYPE_DROW_BASICO)   return TRUE;
        else if(iRaza == RACIAL_TYPE_DUERGAR) return TRUE;
        else if(iRaza == RACIAL_TYPE_AVARIEL) return TRUE;
        else if(iRaza == RACIAL_TYPE_DWARF_ARTICO) return TRUE;
        else if(iRaza == RACIAL_TYPE_GAGUA) return TRUE;
        else if(iRaza == RACIAL_TYPE_GAIRE) return TRUE;
        else if(iRaza == RACIAL_TYPE_GFUEGO) return TRUE;
        else if(iRaza == RACIAL_TYPE_GTIERRA) return TRUE;
        else if(iRaza == RACIAL_TYPE_GITHZERAI) return TRUE;
        else if(iRaza == RACIAL_TYPE_GNOLL) return TRUE;
        else if(iRaza == RACIAL_TYPE_GRAN_TRASGO) return TRUE;
        else if(iRaza == RACIAL_TYPE_KOBOLD) return TRUE;
        else if(sSubRaza == "Liche" || sSubRaza == "liche" ) return TRUE;
        else if(sSubRaza == "Lythari" || sSubRaza == "lythari") return TRUE;
        else if(iRaza == RACIAL_TYPE_MINOTAURO) return TRUE;
        else if(iRaza == RACIAL_TYPE_OGRO) return TRUE;
        else if(iRaza == RACIAL_TYPE_OGROHECHICERO) return TRUE;
        else if(iRaza == RACIAL_TYPE_ORCO_MONTANA) return TRUE;
        else if(iRaza == RACIAL_TYPE_OSGO) return TRUE;
        else if(iRaza == RACIAL_TYPE_SEMIOGRO) return TRUE;
        else if(iRaza == RACIAL_TYPE_TIEFLING) return TRUE;
        else if(sSubRaza == "Tiflin" || sSubRaza == "tiflin") return TRUE;
        else if(iRaza == RACIAL_TYPE_TRASGO) return TRUE;
        else if(sSubRaza == "Umbra" || sSubRaza == "umbra") return TRUE;
        else if(sSubRaza == "Semifata" || sSubRaza == "semifata") return TRUE;
        else if(sSubRaza == "Vampiro" || sSubRaza == "vampiro") return TRUE;
        else if(sSubRaza == "Engendro" || sSubRaza == "engendro") return TRUE;
        else if(iRaza == RACIAL_TYPE_KENKU) return TRUE;
        else if(iRaza == RACIAL_TYPE_GOLIAT) return TRUE;
        else if(iRaza == RACIAL_TYPE_SHADARKAI) return TRUE;
        else if(iRaza == RACIAL_TYPE_TANARUKK) return TRUE;
        else
        return FALSE;
    }
    /*//Elección de apariencias.
    else if(iModo == 2)
    {
        if(iRaza == RACIAL_TYPE_GNOLL) return TRUE;
        else if(iRaza == RACIAL_TYPE_GRAN_TRASGO) return TRUE;
        else if(iRaza == RACIAL_TYPE_KOBOLD) return TRUE;
        else if(iRaza == RACIAL_TYPE_MINOTAURO) return TRUE;
        else if(iRaza == RACIAL_TYPE_ORCO_MONTANA) return TRUE;
        else if(iRaza == RACIAL_TYPE_OSGO) return TRUE;
        else if(iRaza == RACIAL_TYPE_TRASGO) return TRUE;
        else if(iRaza == RACIAL_TYPE_KENKU) return TRUE;
        else
        return FALSE;
    }*/
    //Elección de tipo de lican.
    else if(iModo == 3)
    {
        if(sSubRaza == "Licantropo" || sSubRaza == "licantropo") return TRUE;
        else
        return FALSE;
    }

    //APARTADO DE CONDICIONALES PARA CONVERSACIONES AJENAS A ms_conv_general.//
    //SOY VAMPIRO.
    else if(iModo == 4)
    {
        if(sSubRaza == "Vampiro" || sSubRaza == "vampiro") return TRUE;
        else if(sSubRaza == "Engendro" || sSubRaza == "engendro") return TRUE;
        else
        return FALSE;
    }
    //SOY DROW.
    else if(iModo == 5)
    {
        if(iRaza == RACIAL_TYPE_DROW)   return TRUE;
        else if(iRaza == RACIAL_TYPE_DROW_BASICO)   return TRUE;
        else
        return FALSE;
    }
    else
    return FALSE;

}

//void main(){}
