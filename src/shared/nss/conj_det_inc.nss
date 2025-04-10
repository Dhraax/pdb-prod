 //::///////////////////////////////////////////////
//:: LIBRERIA DE CONJUROS DE DETECTAR
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Libreria con las funciones de los conjuros de Detectar.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 19 de Junio de 2013
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "x0_i0_position"

string ObtenerAuraDetectarElMal(object oCriatura)
{
  int iRaza = GetRacialType(oCriatura);
  int iNivel = GetHitDice(oCriatura);

  if (iRaza == RACIAL_TYPE_OUTSIDER || GetLevelByClass(CLASS_TYPE_CLERIC, oCriatura) > 0)
  {
      if(iNivel == 1) return "débil";
      else if(iNivel >= 2 && iNivel <= 4) return "moderada";
      else if(iNivel >= 5 && iNivel <= 10) return "fuerte";
      else return "abrumadora";
  }
  else if (PB_Race_GetIsUndead(oCriatura))
  {
      if(iNivel >= 1 && iNivel <= 2) return "débil";
      else if(iNivel >= 3 && iNivel <= 8) return "moderada";
      else if(iNivel >= 9 && iNivel <= 20) return "fuerte";
      else return "abrumadora";
  }
  else
  {
      if(iNivel >= 1 && iNivel <= 10) return "débil";
      else if(iNivel >= 11 && iNivel <= 25) return "moderada";
      else if(iNivel >= 26 && iNivel <= 50) return "fuerte";
      else return "abrumadora";
  }
}

string ObtenerAuraDetectarElBien(object oCriatura)
{
  int iRaza = GetRacialType(oCriatura);
  int iNivel = GetHitDice(oCriatura);

  if(GetLevelByClass(CLASS_TYPE_CLERIC, oCriatura) > 0 ||
     GetLevelByClass(CLASS_TYPE_PALADIN, oCriatura) > 0)
  {
      if(iNivel == 1) return "débil";
      else if(iNivel >= 2 && iNivel <= 4) return "moderada";
      else if(iNivel >= 5 && iNivel <= 10) return "fuerte";
      else return "abrumadora";
  }
  else
  {
      if(iNivel >= 1 && iNivel <= 10) return "débil";
      else if(iNivel >= 11 && iNivel <= 25) return "moderada";
      else if(iNivel >= 26 && iNivel <= 50) return "fuerte";
      else return "abrumadora";
  }
}

string ObtenerAuraDetectarLeyCaos(object oCriatura)
{
  int iRaza = GetRacialType(oCriatura);
  int iNivel = GetHitDice(oCriatura);

  if(GetLevelByClass(CLASS_TYPE_CLERIC, oCriatura) > 0)
  {
      if(iNivel == 1) return "débil";
      else if(iNivel >= 2 && iNivel <= 4) return "moderada";
      else if(iNivel >= 5 && iNivel <= 10) return "fuerte";
      else return "abrumadora";
  }
  else
  {
      if(iNivel >= 1 && iNivel <= 10) return "débil";
      else if(iNivel >= 11 && iNivel <= 25) return "moderada";
      else if(iNivel >= 26 && iNivel <= 50) return "fuerte";
      else return "abrumadora";
  }
}

string ObtenerAuraDetectarMV(object oCriatura)
{
  int iNivel = GetHitDice(oCriatura);

  if(iNivel == 1) return "débil";
  else if(iNivel >= 2 && iNivel <= 4) return "moderada";
  else if(iNivel >= 5 && iNivel <= 10) return "fuerte";
  else return "abrumadora";
}

int AturdimientoDetectar(object oPC, object oCriatura, string sAura, int iAlineamiento)
{
  if(GetAlignmentGoodEvil(oPC) == iAlineamiento  &&
     sAura == "abrumadora"                       &&
     GetHitDice(oCriatura) >= GetHitDice(oPC)*2)
  {
      SendMessageToPC(OBJECT_SELF, "<cþþþ>La presencia de un aura muy abrumadora te aturde.</c>");
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oPC, 6.0);
      return TRUE;
  }

  return FALSE;
}

location PosicionCono(object oPC)
{
    float fDir = GetFacing(oPC);
    return GenerateNewLocation(oPC, 5.0, fDir, fDir + 180.0);
}

void Detectar(object oPC, int iConjuro)
{
  string sMensajeInicio, sMensajeError;
  int iBusqueda, iAlineamientoOpuestoBusqueda;

  switch(iConjuro)
  {
      case 1095: { sMensajeInicio = "<cþþþ>Criaturas buenas detectadas:<cª¾þ>";   iBusqueda = ALIGNMENT_GOOD;     iAlineamientoOpuestoBusqueda = ALIGNMENT_EVIL;    sMensajeError = "<cþþþ>No detectas ninguna criatura buena en las cercanías.</c>"; }   break;
      case 1096: { sMensajeInicio = "<cþþþ>Criaturas malignas detectadas:<cþ•w>"; iBusqueda = ALIGNMENT_EVIL;     iAlineamientoOpuestoBusqueda = ALIGNMENT_GOOD;    sMensajeError = "<cþþþ>No detectas ninguna criatura maligna en las cercanías.</c>"; } break;
      case 1097: { sMensajeInicio = "<cþþþ>Criaturas legales detectadas:<cþþŽ>";  iBusqueda = ALIGNMENT_LAWFUL;   iAlineamientoOpuestoBusqueda = ALIGNMENT_CHAOTIC; sMensajeError = "<cþþþ>No detectas ninguna criatura legal en las cercanías.</c>"; }   break;
      case 1098: { sMensajeInicio = "<cþþþ>Criaturas caóticas detectadas:<c¬zþ>"; iBusqueda = ALIGNMENT_CHAOTIC;  iAlineamientoOpuestoBusqueda = ALIGNMENT_LAWFUL;  sMensajeError = "<cþþþ>No detectas ninguna criatura caótica en las cercanías.</c>"; } break;
      case 1099: { sMensajeInicio = "<cþþþ>Muertos vivientes detectados:<c»ðª>";  iBusqueda = RACIAL_TYPE_UNDEAD; iAlineamientoOpuestoBusqueda = ALIGNMENT_GOOD;    sMensajeError = "<cþþþ>No detectas ningún muerto viviente en las cercanías.</c>"; }   break;
  }

  //Apply the VFX
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SILENCE), oPC);

  string sMensaje;
  string sAura;

  //Get first target in spell are
  int iContador;
  object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 18.0, PosicionCono(oPC), FALSE, OBJECT_TYPE_CREATURE, GetPosition(oPC));
  while(GetIsObjectValid(oTarget))
  {
      if(iBusqueda == RACIAL_TYPE_UNDEAD) // Detectar muertos vivientes
      {
          if(GetIsDead(oTarget) == FALSE && PB_Race_GetIsUndead(oTarget))
          {
              sAura = ObtenerAuraDetectarMV(oTarget);
              if(AturdimientoDetectar(oPC, oTarget, sAura, iAlineamientoOpuestoBusqueda) == TRUE) return;
              sMensaje = sMensaje + " [" + GetName(oTarget) + ", aura " + sAura + "]";
              iContador++;
          }
      }
      else  // Detectar el bien, el mal, la ley y el caos
      {
          if(GetIsDead(oTarget) == FALSE &&
             GetAlignmentGoodEvil(oTarget) == iBusqueda &&
             GetHasSpellEffect(1012, oTarget) == FALSE && // Alineamiento indetectable normal de asesino
             GetHasSpellEffect(1100, oTarget) == FALSE && // Alineamiento indetectable normal
             GetHasSpellEffect(1123, oTarget) == FALSE)   // Alineamiento indetectable normal de agente harpista
          {
              if(iConjuro == 1095)                          sAura = ObtenerAuraDetectarElBien(oTarget);
              else if(iConjuro == 1096)                     sAura = ObtenerAuraDetectarElMal(oTarget);
              else if(iConjuro == 1097 || iConjuro == 1098) sAura = ObtenerAuraDetectarLeyCaos(oTarget);
              if(AturdimientoDetectar(oPC, oTarget, sAura, iAlineamientoOpuestoBusqueda) == TRUE) return;
              sMensaje = sMensaje + " [" + GetName(oTarget) + ", aura " + sAura + "]";
              iContador++;
          }
      }

      SignalEvent(oTarget, EventSpellCastAt(oPC, iConjuro, FALSE));

      //Get next target in spell area
      oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 18.0, PosicionCono(oPC), FALSE, OBJECT_TYPE_CREATURE, GetPosition(oPC));
  }

  if(iContador == 0) SendMessageToPC(oPC, sMensajeError);
  else
  {
      sMensaje = sMensaje + "</c>.</c>";
      SendMessageToPC(oPC, sMensajeInicio + sMensaje);
  }
}
