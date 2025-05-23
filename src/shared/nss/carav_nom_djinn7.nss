#include "mti_libreria"
#include "x2_inc_compon"
#include "x0_i0_spawncond"
#include "corpse_functions"
void main()
{
  object oKiller = GetLastKiller();

  // No saturamiento cuando se mata la criatura a si misma al final del script
  if(oKiller == OBJECT_SELF) return;

  // Quest Rakshasa
  object anciana = GetObjectByTag("pnj_carintIhtafeer"); //Ihtafeercamuflada
  object punto1 = GetWaypointByTag("Quest_Ihtafeer_01");
  location lTarget1 = GetLocation(punto1);
  AssignCommand(anciana,ActionJumpToLocation(lTarget1));

  if(!GetIsObjectValid(anciana))
  {
    anciana = CreateObject(OBJECT_TYPE_CREATURE, "pnj_carintIhtafeer", lTarget1 ,FALSE);
  }

  while(GetIsObjectValid(GetMaster(oKiller)))
  {
      oKiller = GetMaster(oKiller);
  }

  if(GetIsPC(oKiller) == TRUE)
  {
      if(ObtenerIntPersistente(oKiller, "QUEST_CARAVASAR_DJINN") == 1) GuardarIntPersistente(oKiller, "QUEST_CARAVASAR_DJINN", 2);
      FloatingTextStringOnCreature("El ser cae abatido y cuando examinas la instancia encuentras a la verdadera anciana maniatada, decides liberarla y regresar a Caravasar.",oKiller,TRUE);
  }

  // EXPERIENCIA
  ExecuteScript("pwfxp",OBJECT_SELF);

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
