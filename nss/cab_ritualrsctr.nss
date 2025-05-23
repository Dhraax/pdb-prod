#include "cab_inc"

void main()
{
  object oPC = GetPCSpeaker();

  // Intentamos sacar una montura pero tenemos el establo demasiado lejos
  location lLugarEstablo = GetLocation(GetWaypointByTag(GetTag(GetArea(oPC)) + "establo"));
  float fDistanciaEstablo = GetDistanceBetweenLocations(GetLocation(oPC), lLugarEstablo);
  if(fDistanciaEstablo == -1.0 || fDistanciaEstablo > 15.0)
  {
      SendMessageToPC(oPC, "<cüGB>Debes estar cerca de un establo para poder empezar con el ritual druídico.</c>");
      return;
  }

  object oMonturaMuerta = GetLocalObject(oPC, "CAB_POSIBLEMUERTO");
  int iNivelMontura = GetLocalInt(oMonturaMuerta, "NIVELMONTURA");
  int iOroNecesario = iNivelMontura * 500;

  // No tenemos el oro necesario
  if(GetGold(oPC) < iOroNecesario)
  {
      SendMessageToPC(oPC, "<cüGB>No dispones de las "+IntToString(iOroNecesario)+" monedas de oro necesarias para poder empezar con el ritual druídico.</c>");
      return;
  }

  // No tenemos nivel 3
  if(GetHitDice(oPC) < 3)
  {
      SendMessageToPC(oPC, "<cüGB>Necesitas alcanzar al menos el nivel 3 para poder empezar con el ritual druídico.</c>");
      return;
  }

  // Perdemos la pasta y la xp
  int iExperienciaPerdida = iNivelMontura * 50;
  SetXP(oPC, GetXP(oPC) - iExperienciaPerdida);
  AssignCommand(oPC, TakeGoldFromCreature(iOroNecesario, oPC, TRUE));

  // Variables y maldicion a su sitio
  if(iNivelMontura > 1)
  {
      SetLocalInt(oMonturaMuerta, "NIVELMONTURA", iNivelMontura - 1);
      int iXPMontura = GetLocalInt(oMonturaMuerta, "NIVELMONTURAXP");
      int iXPMonturaAjuste = CalculoSiguienteNivelXPMontura(iNivelMontura - 2);
      if(iXPMonturaAjuste <= 0) iXPMonturaAjuste = 1;
      SetLocalInt(oMonturaMuerta, "NIVELMONTURAXP", iXPMonturaAjuste);

  }
  SetItemCursedFlag(oMonturaMuerta, FALSE);
  DeleteLocalInt(oMonturaMuerta, "CAB_MUERTO");
  DescripcionMontura(oMonturaMuerta);

  // Animaciones
  AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 6.0));
  SetCutsceneMode(oPC, TRUE);
  FadeToBlack(oPC, FADE_SPEED_MEDIUM);
  DelayCommand(4.0, FadeFromBlack(oPC, FADE_SPEED_MEDIUM));
  DelayCommand(4.5, SetCutsceneMode(oPC, FALSE));
  DelayCommand(5.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_TORNADO), oPC));
  DelayCommand(5.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_NATURES_BALANCE ), oPC));
  DelayCommand(5.0, FloatingTextStringOnCreature("<c þ >¡Tu montura ya vuelve a estar viva!</c>", oPC, FALSE));
}
