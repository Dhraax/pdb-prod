void main()
{
  if(GetIsPC(GetEnteringObject()) == FALSE) return;

  object oMod = GetModule();
  object oChico1 = GetObjectByTag("chico1_B");
  object oChico2 = GetObjectByTag("chico2_B");

  if(GetLocalInt(oMod, "CONVERSACIOCHICOSB") == 0)
  {
      SetLocalInt(oMod, "CONVERSACIOCHICOSB", 1);
      DelayCommand(10.0, SetLocalInt(oMod, "CONVERSACIOCHICOSB", 2));
      DelayCommand(0.1, AssignCommand(oChico1, PlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL,1.0,10.0)));
      DelayCommand(3.5, AssignCommand(oChico2, PlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL,1.0,7.4)));
      DelayCommand(0.5, AssignCommand(oChico1, SpeakString("¡¡¡Muaaaaaa!!! ¡¡Quiero salir de aqui!!")));
      DelayCommand(3.5, AssignCommand(oChico2, SpeakString("¡¡Callate!! Siempre llorando.. ays.. si tuviera mi tirachinas..")));
      DelayCommand(6.5, AssignCommand(oChico1, SpeakString("¡¿Por qué nos tienen encerrados?! ¡¡Muaaaaaaaa!!")));
     DelayCommand(9.5, AssignCommand(oChico2, SpeakString("¿¿Por qué crees que nos tienen aquí imbécil?? Son vampiros pedazo de idiota")));
  }

  else if(GetLocalInt(oMod, "CONVERSACIOCHICOSB") == 2)
  {
      SetLocalInt(oMod, "CONVERSACIOCHICOSB", 3);
      DelayCommand(20.0, SetLocalInt(oMod, "CONVERSACIOCHICOSB", 4));
      DelayCommand(0.1, AssignCommand(oChico1, PlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL,1.0,10.0)));
      DelayCommand(3.5, AssignCommand(oChico2, PlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL,1.0,7.4)));
      DelayCommand(0.5, AssignCommand(oChico1, SpeakString("¡¡¡Vampiro!!! ¡¡Mira lo que tengo para ti, son dos monedas de oro ni mas ni menos!!")));
      DelayCommand(3.5, AssignCommand(oChico2, SpeakString("¡¡¡Que haces loca, la paga semanal nooo!!! Aunque podria funcionar...")));
      DelayCommand(6.5, AssignCommand(oChico1, SpeakString("¿Nos dejais salir ya?")));
      DelayCommand(9.5, AssignCommand(oChico1, SpeakString("¿Ya?")));
      DelayCommand(12.5, AssignCommand(oChico1, SpeakString("¿Aun no?")));
      DelayCommand(15.5, AssignCommand(oChico1, SpeakString("¿Y ahora?")));
      DelayCommand(18.5, AssignCommand(oChico2, SpeakString("Dejalo... pensemos en otra cosa")));
  }

  else if(GetLocalInt(oMod, "CONVERSACIOCHICOSB") == 4)
  {
      SetLocalInt(oMod, "CONVERSACIOCHICOSB", 5);
      DelayCommand(20.0, DeleteLocalInt(oMod, "CONVERSACIOCHICOSB"));
      DelayCommand(0.1, AssignCommand(oChico1, PlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL,1.0,10.0)));
      DelayCommand(3.5, AssignCommand(oChico2, PlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL,1.0,7.4)));
      DelayCommand(0.5, AssignCommand(oChico1, SpeakString("Vampirito... que mala suerte, tengo que ir al servicio, venga abreme.")));
      DelayCommand(3.5, AssignCommand(oChico2, SpeakString("El olor a sangre ya te afecta ¿eh?")));
      DelayCommand(6.5, AssignCommand(oChico1, SpeakString("¡¡Abridnossss!!")));
      DelayCommand(9.5, AssignCommand(oChico1, SpeakString("¿Ya nos abres?")));
      DelayCommand(12.5, AssignCommand(oChico1, SpeakString("¿De verdad?")));
      DelayCommand(15.5, AssignCommand(oChico1, SpeakString("¿Y ahora?")));
      DelayCommand(16.5, AssignCommand(oChico2, SpeakString("...")));
  }
}
