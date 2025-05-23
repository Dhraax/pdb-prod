#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  if(GetGold(oPC) < 5000)
  {
      return TRUE;
  }
  else
  {
      // Variables, mensajes, oro, xp y objetos
      GuardarIntPersistente(oPC, "NIVELEQUITACION", 1);
      GuardarIntPersistente(oPC, "NIVELEQUITACIONXP", 1);
      DelayCommand(5.0, SendMessageToPC(oPC,"<c´þd>¡Tu equitación ha subido al nivel 1!</c>"));
      DelayCommand(5.1, SendMessageToPC(oPC,"<cþ>Tu nuevo rango de jinete es: <c´þd>Novicio jinete.</c></c>"));
      TakeGoldFromCreature(5000, oPC, TRUE);
      GiveXPToCreature(oPC, 250);
      CreateItemOnObject("cab_equitacion", oPC);

      // Animaciones
      SetCutsceneMode(oPC, TRUE);
      FadeToBlack(oPC, FADE_SPEED_MEDIUM);
      DelayCommand(2.0, AssignCommand(oPC, PlaySound("gui_level_up")));
      DelayCommand(4.0, FadeFromBlack(oPC, FADE_SPEED_MEDIUM));
      DelayCommand(4.5, SetCutsceneMode(oPC, FALSE));

      return FALSE;
  }
}
