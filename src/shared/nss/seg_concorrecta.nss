#include "mti_libreria"
#include "x0_i0_petrify"

void main()
{
  object oPC = GetPCSpeaker();

  DeleteLocalInt(oPC, "SEG_OCUPADO");
  SetCutsceneMode(oPC, FALSE);
  DeleteLocalInt(GetModule(), "SEG_INTENTOS" + GetPCPublicCDKey(oPC));

  // Los muertos al Plano de Fuga
  if(ObtenerIntPersistente(oPC, "ESTOY_EN_PLANOFUGA") > 0)
  {
      FadeToBlack(oPC);
      SetCutsceneMode(oPC, TRUE);
      DelayCommand(3.0, AssignCommand(oPC, ActionStartConversation(oPC, "pg_muerto", TRUE)));
      DelayCommand(15.0, FadeFromBlack(oPC));
      return;
  }

  // SUBRAZAS: APLICAR AJUSTES INICIALES
  if(ObtenerIntPersistente(oPC, "LETO_APLICADO") == FALSE && GetSubRace(oPC) != "")
  {
      SetCutsceneMode(oPC, TRUE);
      FloatingTextStringOnCreature("<c´þd>* Ajustes iniciales de subraza aplicándose *</c>", oPC, FALSE);
      DelayCommand(4.0, AssignCommand(oPC, ActionStartConversation(oPC, "ms_convgeneral", TRUE)));
      return;
  }

  // RESTAURAR VIDA PERSISTENTE (si es necesario)
  int iVidaActual = GetCampaignInt(ObjectToString(GetModule()), GetName(oPC, TRUE));
  if(iVidaActual != 0 && GetLocalInt(oPC, "SEG_RESUCITADO"))
  {
      RemoveEffectOfType(oPC, EFFECT_TYPE_POLYMORPH);
      int iVidaMaxima = GetMaxHitPoints(oPC);
      int iDanyo;
      if(iVidaActual > iVidaMaxima) iDanyo = iVidaActual-iVidaMaxima;
      else iDanyo = iVidaMaxima-iVidaActual;
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDanyo), oPC);
      DeleteLocalInt(oPC, "SEG_RESUCITADO");
  }
}
