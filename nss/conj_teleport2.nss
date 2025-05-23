//::///////////////////////////////////////////////
//:: TELEPORTAR Y TELEPORTAR MAYOR (Libreria)
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Teleportar y Teleportar mayor (libreria).
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 10 de Febrero de 2012
//:://////////////////////////////////////////////

#include "mti_libreria"
#include "lib_object"
#include "inc_timelock"

void ConjuroTeleportar(object oLanzador, string sDestino, int TipoTeleportar)
{
    // Cooldown check.
    if(GetIsTimelocked(oLanzador, "Teleportar"))
    {
        TimelockErrorMessage(oLanzador, "Teleportar");
        return;
    }
    // Imposibilidades
    if (GetHasSpellEffect(990))
    {
        FloatingTextStringOnCreature("<cþ<<>El ancla dimensional te impide usar Teleportar.</c>", oLanzador);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_30), GetLocation(oLanzador));
        return;
    }

    else if (GetLocalInt(GetArea(oLanzador), "NOTELEPORT") == 1)
    {
        FloatingTextStringOnCreature("<cþ<<>Este conjuro no se puede usar aquí, algo te lo impide.</c>", oLanzador);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_30), GetLocation(oLanzador));
        return;
    }

    // Declaracion de variables
    int iNivelLanzador = GetLocalInt(oLanzador, "NIVEL_LANZADOR_TELEPORTAR");
    int iNumeroMaximoTeleportPJs = iNivelLanzador / 3;

    // Porcentaje de fracaso
    if (TipoTeleportar == 1)
    {
        int iFallo = 5;

        if ((sDestino == "atk_inicio"        && ObtenerIntPersistente(oLanzador, "TEL_ATHKATLA") == FALSE) ||
           (sDestino == "uri_agujasoro_tel" && ObtenerIntPersistente(oLanzador, "TEL_AGUJASORO") == FALSE) ||
           (sDestino == "crimmor_tel"       && ObtenerIntPersistente(oLanzador, "TEL_CRIMMOR") == FALSE) ||
           (sDestino == "purskul_tel"       && ObtenerIntPersistente(oLanzador, "TEL_PURSKUL") == FALSE) ||
           (sDestino == "imnescar_tel"      && ObtenerIntPersistente(oLanzador, "TEL_IMNESCAR") == FALSE) ||
           (sDestino == "nashkel_tel"       && ObtenerIntPersistente(oLanzador, "TEL_NASHKEL") == FALSE) ||
           (sDestino == "caravasar_tel"     && ObtenerIntPersistente(oLanzador, "TEL_CARAVASAR") == FALSE) ||
           (sDestino == "mti_murann_tel"    && ObtenerIntPersistente(oLanzador, "TEL_MURANN") == FALSE) ||
           (sDestino == "vallemisnor_tel"   && ObtenerIntPersistente(oLanzador, "TEL_VALLEMISNOR") == FALSE) ||
           (sDestino == "ideepton_tel"      && ObtenerIntPersistente(oLanzador, "TEL_IDEEPTON") == FALSE) ||
           (sDestino == "edive_tel"         && ObtenerIntPersistente(oLanzador, "TEL_EDIVE") == FALSE) ||
           (sDestino == "uri_gambiton_tel"  && ObtenerIntPersistente(oLanzador, "TEL_GAMBITON") == FALSE) ||
           (sDestino == "brynnley_tel"      && ObtenerIntPersistente(oLanzador, "TEL_BRYNNLEY") == FALSE) ||
           (sDestino == "WP_ko_kazad_salones_entrada"&& ObtenerIntPersistente(oLanzador, "TEL_KAZAD") == FALSE) ||
           (sDestino == "WP_Suldanessalar"  && ObtenerIntPersistente(oLanzador, "TEL_SULDA") == FALSE)
           )
        {
            iFallo += 70;
        }

        if(d100() <= iFallo)
        {
            //sDestino = "fallo_teleport_" + IntToString(Random(5)+1); (Anulado de momento)
            FloatingTextStringOnCreature("<c´$$>¡El conjuro Teleportar ha fallado!</c>", oLanzador);
            SendMessageToPC(oLanzador, "<c´$$>El fallo te ha agotado, tendras que recuperarte antes de intentarlo nuevamente.</c>");
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_30), GetLocation(oLanzador));
            SetTimelock(oLanzador, 240, "Teleportar", 0, 0);
            return;
        }
    }

    // Teleport
    location lDestino = GetLocation(GetWaypointByTag(sDestino));
    Teletransporte2(oLanzador, lDestino);

    //Modificación 28/09/2024: Teleportar, limitado al individuo.
    //Solo teleportamos al grupo en el Teleportar mayor.
    if (TipoTeleportar == 2)
    {
        object oPJCercanoGrupo = GetFirstFactionMember(oLanzador, TRUE);
        while (GetIsObjectValid(oPJCercanoGrupo) == TRUE)
        {
            if (iNumeroMaximoTeleportPJs > 0 &&
                PB_Object_IsWithinRange(oLanzador, oPJCercanoGrupo, 0.1, 3.0) &&
                GetIsDM(oPJCercanoGrupo) == FALSE && oPJCercanoGrupo != oLanzador)
            {
                Teletransporte2(oPJCercanoGrupo, lDestino);

                iNumeroMaximoTeleportPJs = iNumeroMaximoTeleportPJs - 1;
            }

            oPJCercanoGrupo = GetNextFactionMember(oLanzador, TRUE);
        }
    }

    // Borrar variable
    DeleteLocalInt(oLanzador, "TELEPORTAR");
}
