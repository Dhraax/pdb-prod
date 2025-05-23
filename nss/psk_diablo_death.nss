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

    // SISTEMA DE SEGURIDAD, POR SI LA CRIATURA SE MATA A SI MISMA
    if(oKiller == OBJECT_SELF) return;

    // EXPERIENCIA
    ExecuteScript("pwfxp",OBJECT_SELF);

    // RESPAWN DEL DIABLO, A LOS 3.000 SEG. DESPUES DE SU MUERTE NO VUELVE A APARECER
    DelayCommand(3000.0, DeleteLocalInt(GetModule(), "SACERDOTEPURSKUL"));

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
