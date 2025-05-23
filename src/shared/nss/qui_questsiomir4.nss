#include "mti_libreria"

void FuncionCrearAnillo(object oPC)
{
  CreateItemOnObject("qui_anillolith", oPC);
}

void FuncionCrearEspiritu(location lLugar)
{
  object oEspiritu = CreateObject(OBJECT_TYPE_CREATURE, "nw_s_airelder", lLugar);
  SetName(oEspiritu, "Espíritu del viento");
  DelayCommand(1.0, AssignCommand(oEspiritu, ActionSpeakString("*El viento os despeina y remueve la energía de toda la sala, el espíritu habla entre susurros antinaturales e ininteligibles, de forma sosegada y profunda*")));
  DelayCommand(11.0, AssignCommand(oEspiritu, ActionSpeakString("*Una ráfaga de viento recorre la sala después de varios minutos de incertidumbre. Un torbellino de aire vuelve a introducirse dentro del foco, retornando todo a la normalidad. Te percatas de que el copo de nieve cristalizada se derrite lentamente, dejando en su lugar un frío anillo*")));
  DelayCommand(11.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DISPEL), lLugar));
  DelayCommand(13.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DISPEL), lLugar));
  DelayCommand(21.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DISPEL), lLugar));
  DelayCommand(21.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), lLugar));
  DestroyObject(oEspiritu, 21.0);
}

void main()
{
  object oPC = GetPCSpeaker();

  // Animaciones..
  effect eInmo = EffectCutsceneImmobilize();
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInmo, oPC, 32.0);

  object oSiomir = GetNearestObjectByTag("LithSiomir", oPC);

  AssignCommand(oSiomir, ClearAllActions());

  DelayCommand(1.0, AssignCommand(oSiomir, SetFacing(180.0)));
  DelayCommand(1.0, AssignCommand(oSiomir, ActionSpeakString("*Deja el copo de nieve cristalizado sobre el altar y se concentra en él, con los ojos cerrados. Comienza a recitar unos cánticos, haciendo que la energía espiritual fluya hasta el foco. De repente, la energía se hace visible elevándose desde el copo y haciéndose tangible.*")));
  DelayCommand(1.0, AssignCommand(oSiomir, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 3.0)));

  location lLugarAltar = GetLocation(GetWaypointByTag("lith_altar"));
  object oPuntoEnergia = CreateObject(OBJECT_TYPE_PLACEABLE, "ub_puntoenergia", lLugarAltar);

  location lLugarInvocacion = GetLocation(GetWaypointByTag("lith_invocacion"));
  DelayCommand(5.0, AssignCommand(oSiomir, ActionCastFakeSpellAtObject(SPELL_GREATER_STONESKIN, oSiomir)));

  DelayCommand(8.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DISPEL), lLugarInvocacion));
  DelayCommand(8.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), lLugarInvocacion));
  DelayCommand(8.0, FuncionCrearEspiritu(lLugarInvocacion));

  DelayCommand(13.0, AssignCommand(oSiomir, ActionSpeakString("¡Oh gran espíritu del viento, os imploramos vuestra protección!")));
  DelayCommand(13.1, AssignCommand(oSiomir, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE2, 1.0, 14.0)));

  DestroyObject(oPuntoEnergia, 23.0);
  DelayCommand(28.0, AssignCommand(oSiomir, ActionSpeakString("*Abrumado por el torrente de energía espiritual* El espíritu ha hablado y ha dado su aprobación, dice que eres digno de su protección. *Toma el gélido anillo del altar y te lo entrega* Éste es su presente, hermano. Tómalo y gracias por todo. ")));

  // Recompensas...
  object oCopoNieve = GetItemPossessedBy(oPC, "qui_coponieve");
  DestroyObject(oCopoNieve);
  DelayCommand(32.0, SetXP(oPC, GetXP(oPC) + 600));
  DelayCommand(32.0, FuncionCrearAnillo(oPC));
  GuardarIntPersistente(oPC, "LITHQUESTSIOMIR", 2);
}
