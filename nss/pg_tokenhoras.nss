#include "mti_libreria"
#include "inc_sqlite_time"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    //Obtenemos los segundos que tenía que esperar.
    int iHorasPlanoFuga = ObtenerIntPersistente(oPC, "ESTOY_EN_PLANOFUGA");
    //Miramos cuantos segundos faltan.
    int iSegundosRestantes = iHorasPlanoFuga - SQLite_GetTimeStamp();

    //Si ya ha pasado los segundos que se necesitaba, no mostramos el texto.
    if(iHorasPlanoFuga < SQLite_GetTimeStamp()) return FALSE;
    //Si aún tenemos que esperar.
    else
    {
        //Asignamos el token, con el texto correcto.
        string sHoras = IntToString(iSegundosRestantes) + " segundos";
        SetCustomToken(666, sHoras);
        return TRUE;
    }
}
