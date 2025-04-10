#include "mti_libreria"
void main()
{
  object oPC = GetLastUsedBy();
  int iVariableQuest = ObtenerIntPersistente(oPC, "LITHQUESTEOWO");
  string sSubraza = GetStringLowerCase(GetSubRace(oPC));

  if(iVariableQuest == 1)
  {
      SendMessageToPC(oPC, "Esta lanza debe ser la de nuestro difunto hermano difunto.");
      GuardarIntPersistente(oPC, "LITHQUESTEOWO", 2);
      AssignCommand(oPC, ClearAllActions());
      DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 10.0));
      DelayCommand(0.1, AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 10.0)));
      DelayCommand(10.0, SetXP(oPC, GetXP(oPC) + 100));
      DelayCommand(10.0, SendMessageToPC(oPC, "Debería volver al claro para hablar con Eowonmylith."));
      return;
  }
  else if(iVariableQuest > 1)
  {
      SendMessageToPC(oPC, "Ya recé a mi hermano difunto.");
      return;
  }
  else
  {
      SendMessageToPC(oPC, "Es una lanza corriente, no hay nada interesante.");
      return;
  }
}
