//:://////////////////////////////////////////////////
//:: NW_C2_DEFAULT7
/*
  Default OnDeath event handler for NPCs.

  Adjusts killer's alignment if appropriate and
  alerts allies to our death.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/22/2002
//:://////////////////////////////////////////////////

#include "x2_inc_compon"
#include "x0_i0_spawncond"
#include "corpse_functions"
void main()
{
    object oKiller = GetLastKiller();

    // SISTEMA DE SEGURIDAD POR SI LA CRIATURA SE MATA A SI MISMA
    if(oKiller == OBJECT_SELF) return;

    // EXPERIENCIA
    ExecuteScript("pwfxp",OBJECT_SELF);

    // CLERIGOS DE PURSKUL, AL MATAR 3 APARECE EL PORTAL
    object oMod = GetModule();
    object oPuntoRuta = GetWaypointByTag("aparece_portal");
    location lLugar = GetLocation(oPuntoRuta);
    effect eEfecto1 = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
    int iVariablesPortal = GetLocalInt(oMod, "PORTALTRESVARIABLES");
    iVariablesPortal = iVariablesPortal + 1;

    SetLocalInt(oMod, "PORTALTRESVARIABLES", iVariablesPortal);

    if(GetLocalInt(oMod, "PORTALTRESVARIABLES") == 3)
    {
        CreateObject(OBJECT_TYPE_PLACEABLE, "portal_patio_psk", lLugar);
        DeleteLocalInt(oMod, "PORTALTRESVARIABLES");
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEfecto1, lLugar);
    }

    // Call to allies to let them know we're dead
    SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);

    //Shout Attack my target, only works with the On Spawn In setup
    SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);

    // NOTE: the OnDeath user-defined event does not
    // trigger reliably and should probably be removed
    if(GetSpawnInCondition(NW_FLAG_DEATH_EVENT))
    {
         SignalEvent(OBJECT_SELF, EventUserDefined(1007));
    }

    // CADAVERES USABLES AL MORIR
    corpse_InitializeCorpse(OBJECT_SELF);

    // EVITAR DOBLE MENSAJE DE EXPERIENCIA
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetMaxHitPoints()), OBJECT_SELF);
}
