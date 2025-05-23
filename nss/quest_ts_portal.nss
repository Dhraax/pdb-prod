#include "inc_sqlite_time"

void main()
{
  object oPC = GetLastUsedBy();

  if(GetLocalInt(OBJECT_SELF, "QUEST_TS_PORTAL_ACTIVO"))
  {
      // No puedes cruzarlo en combate
      if(GetIsInCombat(oPC))
      {
          SendMessageToPC(oPC, "<cþ<<>No puedes cruzar el portal estando en combate.</c>");
          return;
      }

      // Primero un aviso
      if(!GetLocalInt(oPC, "QUEST_TS_AVISO_PORTAL"))
      {
          SendMessageToPC(oPC, "<cþ<<>Una vez atravieses el portal no podrás volver atrás. ¿De verdad quieres hacer esto? Si estás decidido usa el portal de nuevo.</c>");
          SetLocalInt(oPC, "QUEST_TS_AVISO_PORTAL", TRUE);
          DelayCommand(500.0, DeleteLocalInt(oPC, "QUEST_TS_AVISO_PORTAL"));
      }

      // Viaje al plano
      else
      {
          SetLocalInt(oPC, "QUEST_TS_TIEMPO_PLANO", SQLite_GetTimeStamp());

          object oDestino = GetWaypointByTag("quest_ts_planosombras");
          location lDestino = GetLocation(oDestino);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oPC);
          DelayCommand(0.4, AssignCommand(oPC, ClearAllActions()));
          DelayCommand(0.5, AssignCommand(oPC, ActionJumpToLocation(lDestino)));
          return;
      }
  }

  else if(GetItemPossessedBy(oPC, "quest_ts_simb4") != OBJECT_INVALID)
  {
      // Primero un aviso
      if(!GetLocalInt(oPC, "QUEST_TS_AVISO_PORTAL"))
      {
          SendMessageToPC(oPC, "<cþ<<>Posees el Símbolo sagrado de Amaunator y por lo tanto podrías activar el portal. No sabes qué podría ocurrir y sabes que una vez atravieses el portal (si llegaras a hacerlo) no podrás volver atrás. ¿De verdad quieres hacer esto? Si estás decidido usa el portal de nuevo.</c>");
          SetLocalInt(oPC, "QUEST_TS_AVISO_PORTAL", TRUE);
          DelayCommand(500.0, DeleteLocalInt(oPC, "QUEST_TS_AVISO_PORTAL"));
      }

      // Activas el portal
      else
      {
          SetLocalInt(OBJECT_SELF, "QUEST_TS_PORTAL_ACTIVO", TRUE);
          DelayCommand(500.0, DeleteLocalInt(OBJECT_SELF, "QUEST_TS_PORTAL_ACTIVO"));

          PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
          DelayCommand(500.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));

          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), oPC);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(813), oPC);
          ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(1664), GetLocation(OBJECT_SELF));
          ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(1671), GetLocation(OBJECT_SELF));
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(oPC) + d3(2), DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_PLUS_TWENTY), oPC);

          CreateObject(OBJECT_TYPE_CREATURE, "quest_ts_sombra4", GetLocation(OBJECT_SELF), TRUE);
          CreateObject(OBJECT_TYPE_CREATURE, "quest_ts_sombra4", GetLocation(OBJECT_SELF), TRUE);
          CreateObject(OBJECT_TYPE_CREATURE, "quest_ts_sombra4", GetLocation(OBJECT_SELF), TRUE);
          CreateObject(OBJECT_TYPE_CREATURE, "quest_ts_sombra4", GetLocation(OBJECT_SELF), TRUE);
          CreateObject(OBJECT_TYPE_CREATURE, "quest_ts_sombra4", GetLocation(OBJECT_SELF), TRUE);
          CreateObject(OBJECT_TYPE_CREATURE, "quest_ts_sombra4", GetLocation(OBJECT_SELF), TRUE);
          CreateObject(OBJECT_TYPE_CREATURE, "quest_ts_sombra4", GetLocation(OBJECT_SELF), TRUE);
          CreateObject(OBJECT_TYPE_CREATURE, "quest_ts_sombra4", GetLocation(OBJECT_SELF), TRUE);
          CreateObject(OBJECT_TYPE_CREATURE, "quest_ts_sombra4", GetLocation(OBJECT_SELF), TRUE);
          CreateObject(OBJECT_TYPE_CREATURE, "quest_ts_sombra4", GetLocation(OBJECT_SELF), TRUE);
      }
  }

  // Nada ocurre
  else
  {
      SendMessageToPC(oPC, "<cþ<<>El portal está cerrado.</c>");
      return;
  }
}
