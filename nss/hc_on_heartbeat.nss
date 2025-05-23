//::////////////////////////////////////////////////////////////////////////////
//:: Nombre del guion:  hc_on_heartbeat                                    //:://
//::////////////////////////////////////////////////////////////////////////////
//:: GUION ORIGINAL HCR 3.3b                                              //:://
//:: Modificado para el servidor Puerta de Baldur                         //:://
//::////////////////////////////////////////////////////////////////////////////

#include "HC_Inc_HTF"
#include "HC_Inc_TimeCheck"
#include "meteo_library"
#include "inc_sqlite_time"

void main()
{
    int ndia= d4(1);
    // SOLUCION ANTE EL PROBLEMA DEL AVANCE DE LA HORA EN MODULOS GRANDES
    SetTime(GetTimeHour(), GetTimeMinute(), GetTimeSecond(), GetTimeMillisecond());

    // hunger, thirst and fatigue system check
    object oMod = GetModule();
    if(SecondsSinceBegin() > GetLocalInt(oMod, "NEXTHTFCHECK")) SignalEvent(oMod, EventUserDefined(HTFCHKEVENTNUM));

    // BUCLE que mira a todos los PJs cada 6 segundos

    // Mira solo, si hay un cambio de hora.
    int iHoraActual = GetTimeHour();
    int iHoraGuardada = GetLocalInt(oMod, "HORAMODULO");
    if(iHoraGuardada != iHoraActual) SetLocalInt(oMod, "HORAMODULO", iHoraActual);
    // Anulamos el bucle antiguo, pre cambio a 15 minutos de las horas del juego.
    /*object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC))
    {
        // EVENTO: ONHORA
        if(iHoraGuardada != iHoraActual)
        {
            ExecuteScript("wrap_mod_onhora", oPC); // Principal evento OnHora
            ExecuteScript("hc_fb_play_rest", oPC); // Sistema de Descanso (actualizar gui button)
            SetLocalInt(oMod, "HORAMODULO", iHoraActual);
        }

        oPC = GetNextPC();
    }*/

    // Script que salta emulando las horas antiguas (de 3 minutos).
    int iSegundosActual = SQLite_GetTimeStamp();
    int iSegundosGuardados = GetLocalInt(oMod, "TIMESTAMPSMODULO");

    if(iSegundosActual >  iSegundosGuardados)
    {
        // Cuando termine de enviar las cosas, existan o no jugadores, el sistema debe lanzarse 180 segundos (3 minutos) después de cuando se lanzó (que no de cuando terminó).ó).
        SetLocalInt(oMod, "TIMESTAMPSMODULO", SQLite_GetTimeStamp() + 180);
        //Hacemos a los PJS lo que se tenga que hacer.
        object oPC = GetFirstPC();
        while (GetIsObjectValid(oPC))
        {
            // EVENTO: ONHORA
            ExecuteScript("wrap_mod_onhora", oPC); // Principal evento OnHora
            ExecuteScript("hc_fb_play_rest", oPC); // Sistema de Descanso (actualizar gui button)

            oPC = GetNextPC();
        }
    }

    //EVENTO: Meteorológico.
    if (GetLocalInt(oMod, "INI_METEO")==0)
    {
        SetLocalInt(oMod, "INI_METEO",1);
        Reinciar_ClimaAreas();
        Indicar_ClimaAreas();
        DelayCommand(4320.0*ndia,SetLocalInt(oMod, "INI_METEO",0)); //4320s = 24h del servidor
    }

    //EVENTO: Limpieza de Tiendas
    if ((GetLocalInt(oMod,"Limpieza")==0) && (iHoraActual==4))
    {
        ExecuteScript("pb_limpiatodas", oMod);
    }
}
