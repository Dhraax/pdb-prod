#include "pb_constantes"
#include "mti_libreria"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int iRaza = GetRacialType(oPC);
    string sSubRaza = GetSubRace(oPC);
    string sIdioma = GetScriptParam("Idioma");
    int iIdioma = ObtenerIntPersistente(oPC, "ConvIdiomasBasicos");

    //Tiene la variable.
    if(iIdioma != 0){return FALSE;}
    //Idiomas regionales humanos.
    else if(iIdioma == 0 && (sIdioma == "Shou" || sIdioma == "Mulano" || sIdioma == "Nexalano" || sIdioma == "Alzhedo" || sIdioma == "Iluskano" || sIdioma == "Chondathano"))
    {
        if(iRaza == RACIAL_TYPE_HUMAN){return TRUE;}
        else if(iRaza == RACIAL_TYPE_AASIMAR){return TRUE;}
        else if(iRaza == APPEARANCE_TYPE_HALF_ELF){return TRUE;}
        else if(iRaza == RACIAL_TYPE_SEMIELFO2){return TRUE;}
        else if(iRaza == RACIAL_TYPE_HALFORC){return TRUE;}
        else if(iRaza == RACIAL_TYPE_TIEFLING){return TRUE;}
        else if(sSubRaza == "Tiflin" || sSubRaza == "tiflin"){return TRUE;}
        else if(iRaza == RACIAL_TYPE_WIGHT){return TRUE;}
        else if(sSubRaza == "Engendro" || sSubRaza == "engendro"){return TRUE;}
        else if(iRaza == RACIAL_TYPE_KENKU){return TRUE;}
        else if(sSubRaza == "Licantropo" || sSubRaza == "licantropo"){return TRUE;}
        else if(sSubRaza == "Vampiro" || sSubRaza == "vampiro"){return TRUE;}
        else if(sSubRaza == "Liche" || sSubRaza == "liche" ){return TRUE;}
        else if(sSubRaza == "Umbra" || sSubRaza == "umbra"){return TRUE;}
        else return FALSE;
    }

    //Idioma élfico.
    else if(sIdioma == "Elfico" && iIdioma == 0)
    {
        if(iRaza == RACIAL_TYPE_ELF){return TRUE;}
        else if(iRaza == RACIAL_TYPE_SOLAR_ELF){return TRUE;}
        else if(iRaza == APPEARANCE_TYPE_HALF_ELF){return TRUE;}
        else if(iRaza == RACIAL_TYPE_SEMIELFO2){return TRUE;}
        else if(iRaza == RACIAL_TYPE_WOOD_ELF){return TRUE;}
        else if(iRaza == RACIAL_TYPE_WIGHT){return TRUE;}
        else if(sSubRaza == "Engendro" || sSubRaza == "engendro"){return TRUE;}
        else if(iRaza == RACIAL_TYPE_ESTRELLAS_ELF){return TRUE;}
        else if(iRaza == RACIAL_TYPE_SALVAJE_ELF){return TRUE;}
        else if(iRaza == RACIAL_TYPE_AVARIEL){return TRUE;}
        else if(iRaza == RACIAL_TYPE_SHADARKAI){return TRUE;}
        else if(iRaza == RACIAL_TYPE_CELADRIN){return TRUE;}
        else if(sSubRaza == "Licantropo" || sSubRaza == "licantropo"){return TRUE;}
        else if(sSubRaza == "Vampiro" || sSubRaza == "vampiro"){return TRUE;}
        else if(sSubRaza == "Liche" || sSubRaza == "liche" ){return TRUE;}
        else if(sSubRaza == "Umbra" || sSubRaza == "umbra"){return TRUE;}
        else if(iRaza == RACIAL_TYPE_DROW){return TRUE;}
        else if(iRaza == RACIAL_TYPE_DROW_BASICO){return TRUE;}
        else if(iRaza == RACIAL_TYPE_FEYRI){return TRUE;}
        else if(sSubRaza == "Lythari" || sSubRaza == "lythari") return TRUE;
        else return FALSE;
    }

    //Idioma enano.
    else if(sIdioma == "Enano" && iIdioma == 0)
    {
        if(iRaza == RACIAL_TYPE_DWARF){return TRUE;}
        else if(iRaza == RACIAL_TYPE_DWARF_DORADO){return TRUE;}
        else if(iRaza == RACIAL_TYPE_DUERGAR){return TRUE;}
        else if(iRaza == RACIAL_TYPE_WIGHT){return TRUE;}
        else if(sSubRaza == "Engendro" || sSubRaza == "engendro"){return TRUE;}
        else if(iRaza == RACIAL_TYPE_DWARF_ARTICO){return TRUE;}
        else if(iRaza == RACIAL_TYPE_AZERBLOOD){return TRUE;}
        else if(sSubRaza == "Licantropo" || sSubRaza == "licantropo"){return TRUE;}
        else if(sSubRaza == "Vampiro" || sSubRaza == "vampiro"){return TRUE;}
        else if(sSubRaza == "Liche" || sSubRaza == "liche" ){return TRUE;}
        else if(sSubRaza == "Umbra" || sSubRaza == "umbra"){return TRUE;}
        else return FALSE;
    }

    //Idioma gigante.
    else if(sIdioma == "Gigante" && iIdioma == 0)
    {
        if(iRaza == RACIAL_TYPE_WIGHT){return TRUE;}
        else if(iRaza == RACIAL_TYPE_SEMIOGRO){return TRUE;}
        else if(iRaza == RACIAL_TYPE_WIGHT){return TRUE;}
        else if(sSubRaza == "Engendro" || sSubRaza == "engendro"){return TRUE;}
        else if(iRaza == RACIAL_TYPE_GOLIAT){return TRUE;}
        else if(sSubRaza == "Licantropo" || sSubRaza == "licantropo"){return TRUE;}
        else if(iRaza == RACIAL_TYPE_OGRO){return TRUE;}
        else if(iRaza == RACIAL_TYPE_MINOTAURO){return TRUE;}
        else if(sSubRaza == "Vampiro" || sSubRaza == "vampiro"){return TRUE;}
        else if(sSubRaza == "Liche" || sSubRaza == "liche" ){return TRUE;}
        else if(iRaza == RACIAL_TYPE_OGROHECHICERO){return TRUE;}
        else if(sSubRaza == "Umbra" || sSubRaza == "umbra"){return TRUE;}
        else return FALSE;
    }

    //Idioma goblin.
    else if(sIdioma == "Goblin" && iIdioma == 0)
    {
        if(iRaza == RACIAL_TYPE_GRAN_TRASGO){return TRUE;}
        else if(iRaza == RACIAL_TYPE_TRASGO){return TRUE;}
        else if(iRaza == RACIAL_TYPE_WIGHT){return TRUE;}
        else if(sSubRaza == "Engendro" || sSubRaza == "engendro"){return TRUE;}
        else if(iRaza == RACIAL_TYPE_OSGO){return TRUE;}
        else if(sSubRaza == "Licantropo" || sSubRaza == "licantropo"){return TRUE;}
        else if(sSubRaza == "Vampiro" || sSubRaza == "vampiro"){return TRUE;}
        else if(sSubRaza == "Liche" || sSubRaza == "liche" ){return TRUE;}
        else if(sSubRaza == "Umbra" || sSubRaza == "umbra"){return TRUE;}
        else return FALSE;
    }

    //Idioma orco.
    else if(sIdioma == "Orco" && iIdioma == 0)
    {
        if(iRaza == RACIAL_TYPE_HALFORC){return TRUE;}
        else if(iRaza == RACIAL_TYPE_ORCO_MONTANA){return TRUE;}
        else if(iRaza == RACIAL_TYPE_WIGHT){return TRUE;}
        else if(sSubRaza == "Engendro" || sSubRaza == "engendro"){return TRUE;}
        else if(iRaza == RACIAL_TYPE_TANARUKK){return TRUE;}
        else if(sSubRaza == "Licantropo" || sSubRaza == "licantropo"){return TRUE;}
        else if(sSubRaza == "Vampiro" || sSubRaza == "vampiro"){return TRUE;}
        else if(sSubRaza == "Liche" || sSubRaza == "liche" ){return TRUE;}
        else if(sSubRaza == "Umbra" || sSubRaza == "umbra"){return TRUE;}
        else return FALSE;
    }

    //Idioma gnomo.
    else if(sIdioma == "Gnomo" && iIdioma == 0)
    {
        if(iRaza == RACIAL_TYPE_GNOME){return TRUE;}
        else if(iRaza == RACIAL_TYPE_WIGHT){return TRUE;}
        else if(sSubRaza == "Engendro" || sSubRaza == "engendro"){return TRUE;}
        else if(sSubRaza == "Licantropo" || sSubRaza == "licantropo"){return TRUE;}
        else if(sSubRaza == "Vampiro" || sSubRaza == "vampiro"){return TRUE;}
        else if(sSubRaza == "Liche" || sSubRaza == "liche" ){return TRUE;}
        else if(sSubRaza == "Umbra" || sSubRaza == "umbra"){return TRUE;}
        else return FALSE;
    }

    //Idioma mediano.
    else if(sIdioma == "Mediano" && iIdioma == 0)
    {
        if(iRaza == APPEARANCE_TYPE_HALFLING){return TRUE;}
        if(iRaza == RACIAL_TYPE_FORTECOR){return TRUE;}
        else if(iRaza == RACIAL_TYPE_WIGHT){return TRUE;}
        else if(sSubRaza == "Engendro" || sSubRaza == "engendro"){return TRUE;}
        else if(sSubRaza == "Licantropo" || sSubRaza == "licantropo"){return TRUE;}
        else if(sSubRaza == "Vampiro" || sSubRaza == "vampiro"){return TRUE;}
        else if(sSubRaza == "Liche" || sSubRaza == "liche" ){return TRUE;}
        else if(sSubRaza == "Umbra" || sSubRaza == "umbra"){return TRUE;}
        else return FALSE;
    }

    //Idioma dracónido.
    else if(sIdioma == "Draconido" && iIdioma == 0)
    {
        if(iRaza == RACIAL_TYPE_DRACONIDO){return TRUE;}
        if(iRaza == RACIAL_TYPE_KOBOLD){return TRUE;}
        else if(iRaza == RACIAL_TYPE_WIGHT){return TRUE;}
        else if(sSubRaza == "Engendro" || sSubRaza == "engendro"){return TRUE;}
        else if(sSubRaza == "Licantropo" || sSubRaza == "licantropo"){return TRUE;}
        else if(iRaza == RACIAL_TYPE_YUANTI){return TRUE;}
        else if(sSubRaza == "Vampiro" || sSubRaza == "vampiro"){return TRUE;}
        else if(sSubRaza == "Liche" || sSubRaza == "liche" ){return TRUE;}
        else if(sSubRaza == "Umbra" || sSubRaza == "umbra"){return TRUE;}
        else return FALSE;
    }

    //Idioma gnoll.
    else if(sIdioma == "Gnoll" && iIdioma == 0)
    {
        if(iRaza == RACIAL_TYPE_GNOLL){return TRUE;}
        else if(iRaza == RACIAL_TYPE_WIGHT){return TRUE;}
        else if(sSubRaza == "Engendro" || sSubRaza == "engendro"){return TRUE;}
        else if(sSubRaza == "Licantropo" || sSubRaza == "licantropo"){return TRUE;}
        else if(sSubRaza == "Vampiro" || sSubRaza == "vampiro"){return TRUE;}
        else if(sSubRaza == "Liche" || sSubRaza == "liche" ){return TRUE;}
        else if(sSubRaza == "Umbra" || sSubRaza == "umbra"){return TRUE;}
        else return FALSE;
    }

    //Idioma silvano.
    else if(sIdioma == "Silvano" && iIdioma == 0)
    {
        if(iRaza == RACIAL_TYPE_WIGHT){return TRUE;}
        else if(sSubRaza == "Engendro" || sSubRaza == "engendro"){return TRUE;}
        else if(iRaza == RACIAL_TYPE_SHADARKAI){return TRUE;}
        else if(iRaza == RACIAL_TYPE_CELADRIN){return TRUE;}
        else if(sSubRaza == "Licantropo" || sSubRaza == "licantropo"){return TRUE;}
        else if(sSubRaza == "Semifata" || sSubRaza == "semifata") return TRUE;
        else if(sSubRaza == "Vampiro" || sSubRaza == "vampiro"){return TRUE;}
        else if(sSubRaza == "Liche" || sSubRaza == "liche" ){return TRUE;}
        else if(sSubRaza == "Umbra" || sSubRaza == "umbra"){return TRUE;}
        else return FALSE;
    }

    //Idioma primordial.
    else if(sIdioma == "Primordial" && iIdioma == 0)
    {
        if(iRaza == RACIAL_TYPE_WIGHT){return TRUE;}
        else if(sSubRaza == "Engendro" || sSubRaza == "engendro"){return TRUE;}
        else if(iRaza == RACIAL_TYPE_GAGUA){return TRUE;}
        else if(iRaza == RACIAL_TYPE_GAIRE){return TRUE;}
        else if(iRaza == RACIAL_TYPE_GFUEGO){return TRUE;}
        else if(iRaza == RACIAL_TYPE_GTIERRA){return TRUE;}
        else if(sSubRaza == "Licantropo" || sSubRaza == "licantropo"){return TRUE;}
        else if(sSubRaza == "Vampiro" || sSubRaza == "vampiro"){return TRUE;}
        else if(sSubRaza == "Liche" || sSubRaza == "liche" ){return TRUE;}
        else if(sSubRaza == "Umbra" || sSubRaza == "umbra"){return TRUE;}
        else return FALSE;
    }
    //Idioma profundidades
    else if(sIdioma == "Profundidades" && iIdioma == 0)
    {
        if(iRaza == RACIAL_TYPE_WIGHT){return TRUE;}
        else if(sSubRaza == "Engendro" || sSubRaza == "engendro"){return TRUE;}
        else if(iRaza == RACIAL_TYPE_GITHZERAI){return TRUE;}
        else if(sSubRaza == "Licantropo" || sSubRaza == "licantropo"){return TRUE;}
        else if(sSubRaza == "Vampiro" || sSubRaza == "vampiro"){return TRUE;}
        else if(sSubRaza == "Liche" || sSubRaza == "liche" ){return TRUE;}
        else if(sSubRaza == "Umbra" || sSubRaza == "umbra"){return TRUE;}
        else return FALSE;
    }
    //Idiomas regionales humanos.
    else if(sIdioma == "Infernal" && iIdioma == 0)
    {
        if(iRaza == RACIAL_TYPE_TIEFLING){return TRUE;}
        else if(sSubRaza == "Tiflin" || sSubRaza == "tiflin"){return TRUE;}
        else return FALSE;
    }
    else return FALSE;
}

//void main(){}
