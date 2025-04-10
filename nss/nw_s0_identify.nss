//::///////////////////////////////////////////////
//:: Identificar
//:: NW_S0_Identify.nss
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
    Identifica un objeto.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 26/03/2012
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_DIVINATION);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

  if (!X2PreSpellCastCode())
  {
      // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
      return;
  }
  // End of Spell Cast Hook

  object oTarget = GetSpellTargetObject();

  //Apply linked and VFX effects
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGICAL_VISION), OBJECT_SELF);

  //Fire cast spell at event for the specified target
  SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_IDENTIFY, FALSE));

  // ---------------- TARGETED ON ITEM  -------------------
  if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
  {
      if(GetIdentified(oTarget) == FALSE)
      {
          SetIdentified(oTarget, TRUE);
          SendMessageToPC(OBJECT_SELF, "<c´þd>Objeto identificado: " + GetName(oTarget) + "</c>");
      }
      else SendMessageToPC(OBJECT_SELF, "<cþ<<>El objeto objetivo ya estaba identificado.</c>");

      return;
  }

  // ---------------- TARGETED ON CHARACTER----------------
  int iSoloUno = FALSE;
  object oObjetoNoIdentificado = GetFirstItemInInventory();
  while(GetIsObjectValid(oObjetoNoIdentificado) && iSoloUno == FALSE)
  {
      if(GetIdentified(oObjetoNoIdentificado) == FALSE)
      {
          SetIdentified(oObjetoNoIdentificado, TRUE);
          SendMessageToPC(OBJECT_SELF, "<c´þd>Objeto identificado: " + GetName(oObjetoNoIdentificado) + "</c>");
          iSoloUno = TRUE;
      }

      oObjetoNoIdentificado = GetNextItemInInventory();
  }

  if(iSoloUno == FALSE) SendMessageToPC(OBJECT_SELF, "<cþ<<>No tienes objetos no identificados en el inventario.</c>");
  DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
