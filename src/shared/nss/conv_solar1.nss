#include "pb_constantes"
#include "mti_libreria"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int iModo = StringToInt(GetScriptParam("Modo"));
    string sTag = GetScriptParam("Tag");
    int iRaza = GetRacialType(oPC);
    string sSubRace = GetStringLowerCase(GetSubRace(oPC));
    int bNeedsApproval = StringToInt(Get2DAString("racialtypes", "NeedsApproval", iRaza));

    ////////////////////////
    //REQUISITOS INICIALES//
    ////////////////////////

    //Miramos si tiene deidad.
    if(iModo == 1)
    {
        if(GetDeity(oPC) == "")  return TRUE;
    }

    //Miramos si tiene la var de los idiomas.
    if(iModo == 2)
    {
        if(ObtenerIntPersistente(oPC, "ConvIdiomasBasicos") != 1) return TRUE;
    }

    //Raza no válida.
    if(iModo == 3)
    {
        if(iRaza == RACIAL_TYPE_HUMAN){return FALSE;}
        else if(iRaza == APPEARANCE_TYPE_HALF_ELF){return FALSE;}
        else if(iRaza == RACIAL_TYPE_SEMIELFO2){return FALSE;}
        else if(iRaza == RACIAL_TYPE_HALFORC){return FALSE;}
        else if(iRaza == RACIAL_TYPE_SOLAR_ELF){return FALSE;}
        else if(iRaza == RACIAL_TYPE_ELF){return FALSE;}
        else if(iRaza == RACIAL_TYPE_WOOD_ELF){return FALSE;}
        else if(iRaza == RACIAL_TYPE_DWARF){return FALSE;}
        else if(iRaza == RACIAL_TYPE_DWARF_DORADO){return FALSE;}
        else if(iRaza == RACIAL_TYPE_DRACONIDO){return FALSE;}
        else if(iRaza == RACIAL_TYPE_HALFLING){return FALSE;}
        else if(iRaza == RACIAL_TYPE_FORTECOR){return FALSE;}
        else if(iRaza == RACIAL_TYPE_GNOME){return FALSE;}
        else if(iRaza == RACIAL_TYPE_TIEFLING){return FALSE;}
        else if(sSubRace == "Tiflin" || sSubRace == "tiflin"){return FALSE;}
        else if(iRaza == RACIAL_TYPE_TRASGO){return FALSE;}
        else if(iRaza == RACIAL_TYPE_GRAN_TRASGO){return FALSE;}
        else if(iRaza == RACIAL_TYPE_ORCO_MONTANA){return FALSE;}
        else if(iRaza == RACIAL_TYPE_KOBOLD){return FALSE;}
        else if(iRaza == RACIAL_TYPE_DUERGAR){return FALSE;}
        else if(iRaza == RACIAL_TYPE_DROW){return FALSE;}
        else if(iRaza == RACIAL_TYPE_DROW_BASICO){return FALSE;}
        else if(iRaza == RACIAL_TYPE_GNOLL){return FALSE;}
        else if(iRaza == RACIAL_TYPE_WIGHT){return FALSE;}
        else if(iRaza == RACIAL_TYPE_SEMIOGRO){return FALSE;}
        else if(sSubRace == "Engendro" || sSubRace == "engendro"){return FALSE;}
        else if(iRaza == RACIAL_TYPE_ESTRELLAS_ELF){return FALSE;}
        else if(iRaza == RACIAL_TYPE_SALVAJE_ELF){return FALSE;}
        else if(iRaza == RACIAL_TYPE_SHADARKAI){return FALSE;}
        else if(iRaza == RACIAL_TYPE_AVARIEL){return FALSE;}
        else if(iRaza == RACIAL_TYPE_CELADRIN){return FALSE;}
        else if (sSubRace == "Lythari" || sSubRace == "lythari"){return FALSE;}
        else if(iRaza == RACIAL_TYPE_DWARF_ARTICO){return FALSE;}
        else if(iRaza == RACIAL_TYPE_AZERBLOOD){return FALSE;}
        else if(iRaza == RACIAL_TYPE_AASIMAR){return FALSE;}
        else if(iRaza == RACIAL_TYPE_GAGUA){return FALSE;}
        else if(iRaza == RACIAL_TYPE_GAIRE){return FALSE;}
        else if(iRaza == RACIAL_TYPE_GFUEGO){return FALSE;}
        else if(iRaza == RACIAL_TYPE_GTIERRA){return FALSE;}
        else if(iRaza == RACIAL_TYPE_OSGO){return FALSE;}
        else if(iRaza == RACIAL_TYPE_GOLIAT){return FALSE;}
        else if(iRaza == RACIAL_TYPE_KENKU){return FALSE;}
        else if (sSubRace == "Licantropo" || sSubRace == "licantropo"){return FALSE;}
        else if(iRaza == RACIAL_TYPE_YUANTI){return FALSE;}
        else if(iRaza == RACIAL_TYPE_GITHZERAI){return FALSE;}
        else if (sSubRace == "Semifata" || sSubRace == "semifata"){return FALSE;}
        else if(iRaza == RACIAL_TYPE_TANARUKK){return FALSE;}
        else if(iRaza == RACIAL_TYPE_OGRO){return FALSE;}
        else if(iRaza == RACIAL_TYPE_MINOTAURO){return FALSE;}
        else if (sSubRace == "Vampiro" || sSubRace == "vampiro"){return FALSE;}
        else if (sSubRace == "Liche" || sSubRace == "liche"){return FALSE;}
        else if(iRaza == RACIAL_TYPE_OGROHECHICERO){return FALSE;}
        else if (sSubRace == "Umbra" || sSubRace == "umbra"){return FALSE;}
        else if(iRaza == RACIAL_TYPE_FEYRI){return FALSE;}
        else if(iRaza == RACIAL_TYPE_SHAPECHANGER && GetLevelByClass(63,oPC) >= 10){return FALSE;}//Maestro Multiples Formas
        else return TRUE;
    }

    //Raza no aprobada.
    if(iModo == 4)
    {
        if(ObtenerIntPersistente(oPC, "SUBRAZAACEPTADA") == 0 &&
            (bNeedsApproval ||
            sSubRace == "Tiflin" || sSubRace == "tiflin" ||
            sSubRace == "Lythari" || sSubRace == "lythari" ||
            sSubRace == "Licantropo" || sSubRace == "licantropo" ||
            sSubRace == "Semifata" || sSubRace == "semifata" ||
            sSubRace == "Vampiro" || sSubRace == "vampiro" ||
            sSubRace == "Liche" || sSubRace == "liche" ||
            sSubRace == "Umbra" || sSubRace == "umbra")) return TRUE;
        else return FALSE;
    }

    /////////////////////////
    //SELECCION DE ESTATUAS//
    /////////////////////////
    if(iModo == 5)
    {
        if(sTag == GetTag(OBJECT_SELF)) return TRUE;
        else return FALSE;
    }

    ///////////////////////////////////////
    //SETEO DE LAS BAJADAS SEGUN LA RAZA.//
    ///////////////////////////////////////
    int iLlanos , iMurann , iAlandor, iGambiton, iKazad, iBodhi, iLythari;

    if(iRaza == RACIAL_TYPE_HUMAN)
    {
        iLlanos = TRUE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == APPEARANCE_TYPE_HALF_ELF || iRaza == RACIAL_TYPE_SEMIELFO2)
    {
        iLlanos = TRUE;
        iMurann = FALSE;
        iAlandor = TRUE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_HALFORC)
    {
        iLlanos = TRUE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_SOLAR_ELF)
    {
        iLlanos = TRUE;
        iMurann = FALSE;
        iAlandor = TRUE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_ELF)
    {
        iLlanos = TRUE;
        iMurann = FALSE;
        iAlandor = TRUE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_WOOD_ELF)
    {
        iLlanos = TRUE;
        iMurann = FALSE;
        iAlandor = TRUE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_DWARF)
    {
        iLlanos = TRUE;
        iMurann = FALSE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = TRUE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_DWARF_DORADO)
    {
        iLlanos = TRUE;
        iMurann = FALSE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = TRUE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_DRACONIDO)
    {
        iLlanos = TRUE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_HALFLING)
    {
        iLlanos = TRUE;
        iMurann = FALSE;
        iAlandor = FALSE;
        iGambiton = TRUE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_FORTECOR)
    {
        iLlanos = TRUE;
        iMurann = FALSE;
        iAlandor = FALSE;
        iGambiton = TRUE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_GNOME)
    {
        iLlanos = TRUE;
        iMurann = FALSE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = TRUE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_TIEFLING || sSubRace == "Tiflin" || sSubRace == "tiflin")
    {
        iLlanos = TRUE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_TRASGO)
    {
        iLlanos = FALSE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_GRAN_TRASGO)
    {
        iLlanos = FALSE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_ORCO_MONTANA)
    {
        iLlanos = FALSE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_KOBOLD)
    {
        iLlanos = FALSE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_DUERGAR)
    {
        iLlanos = FALSE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_DROW || iRaza == RACIAL_TYPE_DROW_BASICO)
    {
        iLlanos = FALSE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_GNOLL)
    {
        iLlanos = FALSE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_WIGHT)
    {
        iLlanos = FALSE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_SEMIOGRO)
    {
        iLlanos = FALSE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(sSubRace == "Engendro" || sSubRace == "engendro")
    {
        iLlanos = TRUE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = TRUE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_ESTRELLAS_ELF)
    {
        iLlanos = TRUE;
        iMurann = FALSE;
        iAlandor = TRUE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_SALVAJE_ELF)
    {
        iLlanos = TRUE;
        iMurann = FALSE;
        iAlandor = TRUE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_SHADARKAI)
    {
        iLlanos = TRUE;
        iMurann = FALSE;
        iAlandor = TRUE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_AVARIEL)
    {
        iLlanos = TRUE;
        iMurann = FALSE;
        iAlandor = TRUE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_CELADRIN)
    {
        iLlanos = TRUE;
        iMurann = FALSE;
        iAlandor = TRUE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if (sSubRace == "Lythari" || sSubRace == "lythari")
    {
        iLlanos = TRUE;
        iMurann = FALSE;
        iAlandor = TRUE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = TRUE;
    }
    else if(iRaza == RACIAL_TYPE_DWARF_ARTICO)
    {
        iLlanos = TRUE;
        iMurann = FALSE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = TRUE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_AZERBLOOD)
    {
        iLlanos = TRUE;
        iMurann = FALSE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = TRUE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_AASIMAR)
    {
        iLlanos = TRUE;
        iMurann = FALSE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_GAGUA)
    {
        iLlanos = TRUE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_GAIRE)
    {
        iLlanos = TRUE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_GFUEGO)
    {
        iLlanos = TRUE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_GTIERRA)
    {
        iLlanos = TRUE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_OSGO)
    {
        iLlanos = TRUE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_GOLIAT)
    {
        iLlanos = TRUE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_KENKU)
    {
        iLlanos = TRUE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if (sSubRace == "Licantropo" || sSubRace == "licantropo")
    {
        iLlanos = TRUE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_YUANTI)
    {
        iLlanos = FALSE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_GITHZERAI)
    {
        iLlanos = TRUE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if (sSubRace == "Semifata" || sSubRace == "semifata")
    {
        iLlanos = TRUE;
        iMurann = FALSE;
        iAlandor = TRUE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = TRUE;
    }
    else if(iRaza == RACIAL_TYPE_TANARUKK)
    {
        iLlanos = FALSE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_OGRO)
    {
        iLlanos = FALSE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_MINOTAURO)
    {
        iLlanos = FALSE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if (sSubRace == "Vampiro" || sSubRace == "vampiro")
    {
        iLlanos = TRUE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = TRUE;
        iLythari = FALSE;
    }
    else if (sSubRace == "Liche" || sSubRace == "liche")
    {
        iLlanos = TRUE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_OGROHECHICERO)
    {
        iLlanos = FALSE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if (sSubRace == "Umbra" || sSubRace == "umbra")
    {
        iLlanos = TRUE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    else if(iRaza == RACIAL_TYPE_FEYRI)
    {
        iLlanos = TRUE;
        iMurann = TRUE;
        iAlandor = FALSE;
        iGambiton = FALSE;
        iKazad = FALSE;
        iBodhi = FALSE;
        iLythari = FALSE;
    }
    ///////////////////////////////////////
    //SETEO DE LAS BAJADAS SEGUN ALIADOS.//
    ///////////////////////////////////////
    //Aliado de los elfos.
    if(GetIsObjectValid(GetItemPossessedBy(oPC, "AliadodeSuldanessalar"))) {iAlandor = TRUE;}
    if(GetIsObjectValid(GetItemPossessedBy(oPC, "aliadoanm"))) {iLlanos = TRUE;}
    if(GetIsObjectValid(GetItemPossessedBy(oPC, "mascara_nocturna"))) {iBodhi = TRUE;}
    if(GetIsObjectValid(GetItemPossessedBy(oPC, "aliadomurann"))) {iMurann = TRUE;}

    ////////////
    //BAJADAS.//
    ////////////
    //BAJAR EN LOS LLANOS.
    if (iModo == 6)
    {
        if(iLlanos == TRUE) return TRUE;
        else return FALSE;
    }

    //BAJAR EN LOS MURANN.
    if (iModo == 7)
    {
        if(iMurann == TRUE) return TRUE;
        else return FALSE;
    }

    //BAJAR EN LOS ALANDOR.
    if (iModo == 8)
    {
        if(iAlandor == TRUE) return TRUE;
        else return FALSE;
    }

    //BAJAR EN LOS GAMBITON.
    if (iModo == 9)
    {
        if(iGambiton == TRUE) return TRUE;
        else return FALSE;
    }

    //BAJAR EN LOS KAZAD.
    if (iModo == 10)
    {
        if(iKazad == TRUE) return TRUE;
        else return FALSE;
    }

    //BAJAR EN BODHI.
    if (iModo == 11)
    {
        if(iBodhi == TRUE) return TRUE;
        else return FALSE;
    }

    //BAJAR EN LYTHARI.
    if (iModo == 12)
    {
        if(iLythari == TRUE) return TRUE;
        else return FALSE;
    }
    return FALSE;
}
