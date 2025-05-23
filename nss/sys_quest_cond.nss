#include "mti_libreria"
#include "nwnx_creature"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oPNJ = OBJECT_SELF;
    //Leemos el nombre de la quest.
    string sTrama = GetScriptParam("NombreQuest");
    //Leemos del jugador el estado de la quest.
    int iTrama = ObtenerIntPersistente(oPC,sTrama);
    //Leemos que estado de la trama se necesita.
    int iEstado = StringToInt(GetScriptParam("EstadoQuest"));
    //Leemos que estado de la trama no queremos que tenga.
    int iNoEstado = StringToInt(GetScriptParam("NoEstadoQuest"));
    //Por si hay llave.
    string sPrueba = GetScriptParam("Prueba");
    //Requerimos de un alineamiento.
    string sAlineamiento = GetScriptParam("Alineamiento");
    int iAlineamiento = StringToInt(sAlineamiento);

    //Si no se tiene la variable igual a la que queremos.
    if(GetScriptParam("EstadoQuest") != "")
    {
        if(iTrama != iEstado)
        return FALSE;
    }

    //Si no se tiene la variable igual a la que queremos.
    if(GetScriptParam("NoEstadoQuest") != "")
    {
        if(iTrama == iNoEstado)
        return FALSE;
    }

    //Si se necesita un objeto y no lo tiene, nada.
    if(sPrueba != "" && !SiObjetoInventario (oPC,sPrueba))
    return FALSE;

    //Si requerimos de mirar alineamientos, los neutrales no entran en la posibilidad.
    if(sAlineamiento != "")
    {
        //Bueno o malo.
        if(iAlineamiento == 4 || iAlineamiento == 5)
        {
            if (!(GetAlignmentGoodEvil(oPC)==iAlineamiento)) return FALSE;
        }
        //Legal o caótico.
        if(iAlineamiento == 2 || iAlineamiento == 3)
        {
            if (!(GetAlignmentLawChaos(oPC)==iAlineamiento)) return FALSE;
        }
        //Neutral.
        if(iAlineamiento == 1)
        {
            if (!(GetAlignmentLawChaos(oPC)!=-1)) return FALSE;
            if (!(GetAlignmentGoodEvil(oPC)!=-1)) return FALSE;
        }
    }

    //Si está todo correcto, pues lo muestra.
    return TRUE;
    }

