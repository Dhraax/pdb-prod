//::///////////////////////////////////////////////
//:: COMPRENSION IDIOMATICA
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Comprension idiomatica.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 10 de Junio de 2010
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_DIVINATION);
  /*
    Spellcast Hook Code
    Added 2003-07-07 by Georg Zoeller
    If you want to make changes to all spells,
    check x2_inc_spellhook.nss to find out more
  */

  if (!X2PreSpellCastCode())
  {
      // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
      return;
  }

  // End of Spell Cast Hook

  // Variables
  object oTarget = GetSpellTargetObject();
  int iNivelLanzador = GetTotalCasterLevel(OBJECT_SELF);
  float fDuracion = TurnsToSeconds(iNivelLanzador);
  effect eImpact = EffectVisualEffect(829);
  effect eVis = EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL);

  // Evento
  SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

  // Efectos
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget, fDuracion);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuracion);
  SendMessageToPC(oTarget, "<cþþþ>Ahora entenderás cualquier idioma que no conozcas.</c>");
  DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
