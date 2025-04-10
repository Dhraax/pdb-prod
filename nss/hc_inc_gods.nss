//::////////////////////////////////////////////////////////////////////////////
//:: Nombre del guion:  hc_inc_gods                                       //:://
//::////////////////////////////////////////////////////////////////////////////
//:: GUION ORIGINAL HCR 3.3b                                              //:://
//:: Modificado para el servidor Puerta de Baldur                         //:://
//::////////////////////////////////////////////////////////////////////////////
#include "hc_inc"
#include "hc_inc_remeff"
#include "mti_libreria"
#include "tj_inc"

int ResurrecionDeidad(object oJugador)
{
        int nrezpercent = GetLocalInt(oMod, "GODCHANCE") + (GetHitDice(oJugador)/4);

        if(GetDeity(oJugador) == "")
        {
            SendMessageToPC(oJugador, "<cþ>¡No tienes Dios que escuche tus pregarias!</c>");
            return 0;
        }
        else if(d100() > nrezpercent)
        {
            if(GetDeity(oJugador)!= "") SendMessageToPC(oJugador, "<cþ>¡"+GetDeity(oJugador)+" rechaza oir tus pregarias!</c>");

            // VARIABLE PARA EVITAR ABUSO CON LA RESURRECCION POR DEIDAD
            GuardarIntPersistente(oJugador, "NORESDEIDAD", 1);
            return 0;
        }

        // ELIMINAR LAS VARIABLES DEL PUESTO DE VENTA (si lo tiene montado)
        DelayCommand(1.0, EliminarVariablesTJ(oJugador));

        // ¡¡NUESTRO DIOS NOS HA ESCUCHADO!!
        SendMessageToPC(oJugador, "<c þ >¡"+GetDeity(oJugador)+" ha concedido tu petición y te ha resucitado!</c>");

        // SI EL SANGRAMIENTO ESTA ACTIVADO, MARCAMOS AL JUGADOR COMO QUE ESTA VIVO
        if(GetLocalInt(oMod, "BLEEDSYSTEM")) SPS(oJugador, PWS_PLAYER_STATE_ALIVE);

        // RESUCITAMOS, CURAMOS Y MANDAMOS AL JUGADOR A LA BOLSA PLANAR
        DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oJugador));
        DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oJugador)), oJugador));
        DelayCommand(0.4, AssignCommand(oJugador, JumpToLocation(GetStartingLocation())));

        // LE CURAMOS AL JUGADOR CUALQUIER EFECTO NEGATIVO
        RemoveEffectsHCR(oJugador);

        // APLICAMOS LOS EFECTOS DE LAS SUBRAZAS, MONTURAS Y ARMADURAS
        ReaplicarEfectosPB(oJugador,TRUE);

        return 1;
}
