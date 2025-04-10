#include "cab_inc"

void main()
{
  object oPC = GetPCSpeaker();

  // Si estamos montados, no se peude entrenar
  if(ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0)
  {
      AssignCommand(OBJECT_SELF, ActionSpeakString("¡Desmóntate de esa montura y hablamos mejor!"));
      return;
  }

  // Si no nos sigue ninguna montura, no se puede entrenar
  object oAyudante1 = GetHenchman(oPC, 1);
  object oAyudante2 = GetHenchman(oPC, 2);
  object oAyudante3 = GetHenchman(oPC, 3);

  if(VerSiEsMontura(oAyudante1) == FALSE &&
     VerSiEsMontura(oAyudante2) == FALSE &&
     VerSiEsMontura(oAyudante3) == FALSE)
  {
      AssignCommand(OBJECT_SELF, ActionSpeakString("¡Pero si no te sigue ninguna montura! Vuelve cuando tengas alguna."));
      return;
  }

  // Obtenemos el nivel de la montura
  object oMonturaUsada = GetFirstItemInInventory(oPC);
  int iNivelMontura;
  while(GetIsObjectValid(oMonturaUsada) == TRUE)
  {
      if(GetTag(oMonturaUsada) == "cab_montura" &&
         GetItemCursedFlag(oMonturaUsada) == TRUE &&
         GetLocalInt(oMonturaUsada, "CAB_MUERTO") == FALSE)
      {
          // Variables, mensajes, oro, xp y objetos
          iNivelMontura = GetLocalInt(oMonturaUsada, "NIVELMONTURA");
          SetLocalInt(oMonturaUsada, "NIVELMONTURA", iNivelMontura + 1);
          DelayCommand(5.0, SendMessageToPC(oPC,"<c´þd>¡Tu montura ha subido al nivel "+IntToString(iNivelMontura+1)+"!</c>"));
          SetXP(oPC, GetXP(oPC) + (25*(iNivelMontura+1)));

          // Subir de nivel a la montura y descripcion
          object oMontura = GetHenchman(oPC);
          if(GetTag(GetHenchman(oPC, 2)) == "cab_montura") oMontura = GetHenchman(oPC, 2);
          else if(GetTag(GetHenchman(oPC, 3)) == "cab_montura") oMontura = GetHenchman(oPC, 3);
          LevelUpHenchman(oMontura, GetClassByPosition(1, oMontura));
          DescripcionMontura(oMonturaUsada);

          // Animaciones
          SetCutsceneMode(oPC, TRUE);
          FadeToBlack(oPC, FADE_SPEED_MEDIUM);
          DelayCommand(2.0, AssignCommand(oPC, PlaySound("gui_level_up")));
          DelayCommand(4.0, FadeFromBlack(oPC, FADE_SPEED_MEDIUM));
          DelayCommand(4.5, SetCutsceneMode(oPC, FALSE));
          DelayCommand(5.0, AssignCommand(OBJECT_SELF, ActionSpeakString("¡Aquí tienes, más fuerte que nunca! Jajaja")));

          return;
      }

      oMonturaUsada = GetNextItemInInventory(oPC);
  }

  AssignCommand(OBJECT_SELF, ActionSpeakString("// Debería haber entrenado a tu montura pero por alguna extraña razón no lo he hecho... Avisa a los DMs de este bug, anda."));
}
