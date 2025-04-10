#include "mti_libreria"

void CrearArmadura(string sResrefArmadura, object oPC)
{
  CreateItemOnObject(sResrefArmadura, oPC);
  GiveXPToCreature(oPC, 4000);
}

void main()
{
  object oPC = GetPCSpeaker();
  string sEscama = "escama_olatelghi";
  object oEscama = GetItemPossessedBy(oPC, sEscama);
  if(GetGold(oPC) < 25000)
  {
      ActionSpeakString("¡No tienes suficiente oro inepto! Vuelve a mi cuando tengas el oro que te pido.");
      return;
  }
  if (GetIsObjectValid(oEscama)) DestroyObject(oEscama);
  GuardarIntPersistente(oPC,"ESCAMASDRAGNIEBLA", 1);
  TakeGoldFromCreature(25000, oPC);

  SetCutsceneMode(oPC, TRUE);
  ActionSpeakString("Bien bien... Esto requerirá un tiempo, dame unos minutos...");
  DelayCommand(2.0, FadeToBlack(oPC, FADE_SPEED_MEDIUM));
  DelayCommand(4.0, AssignCommand(oPC, PlaySound("as_cv_shopmetal1")));
  DelayCommand(4.0, AssignCommand(oPC, PlaySound("as_cv_minepick1")));
  DelayCommand(7.0, AssignCommand(oPC, PlaySound("as_cv_shopmetal1")));
  DelayCommand(7.0, AssignCommand(oPC, PlaySound("as_cv_minepick2")));
  DelayCommand(7.0, FadeFromBlack(oPC, FADE_SPEED_MEDIUM));
  DelayCommand(9.0, ActionSpeakString("¡Listo, aquí tienes tus ropas!"));
  DelayCommand(9.0, CrearArmadura("elghinn_ropas", oPC));
  DelayCommand(10.0, SetCutsceneMode(oPC, FALSE));
}
