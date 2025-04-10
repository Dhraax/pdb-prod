#include "chat_emociones2"
#include "mti_libreria"

void main()
{
  object oPC = GetPCChatSpeaker();
  string sTexto = GetPCChatMessage();

  if(ObtenerIntPersistente(oPC, "CHAT_NOEMOCIONES") == TRUE) return;

  if(FindSubString(GetStringLowerCase(sTexto), "se inclina") != -1 ||
     FindSubString(GetStringLowerCase(sTexto), "muestra cortesía") != -1    ||
     FindSubString(GetStringLowerCase(sTexto), "muestra cortesia") != -1) AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_BOW, 1.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "bebe") != -1 &&
          FindSubString(GetStringLowerCase(sTexto), "sentado") != -1)
  {
      AssignCommand(oPC, ActionPlayAnimation( ANIMATION_LOOPING_SIT_CROSS, 1.0, 99999.0f));
      DelayCommand(1.0f, AssignCommand(oPC, PlayAnimation( ANIMATION_FIREFORGET_DRINK, 1.0)));
      DelayCommand(3.0f, AssignCommand(oPC, PlayAnimation( ANIMATION_LOOPING_SIT_CROSS, 1.0, 99999.0)));
  }
  else if(FindSubString(GetStringLowerCase(sTexto), "bebe") != -1 ||
          FindSubString(GetStringLowerCase(sTexto), "eructa") != -1) AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_DRINK, 1.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "lee") != -1 &&
          FindSubString(GetStringLowerCase(sTexto), "sentado") != -1)
  {
      AssignCommand(oPC, ActionPlayAnimation( ANIMATION_LOOPING_SIT_CROSS, 1.0, 99999.0f));
      DelayCommand(1.0f, AssignCommand(oPC, PlayAnimation( ANIMATION_FIREFORGET_READ, 1.0)));
      DelayCommand(3.0f, AssignCommand(oPC, PlayAnimation( ANIMATION_LOOPING_SIT_CROSS, 1.0, 99999.0)));
  }
  else if(FindSubString(GetStringLowerCase(sTexto), "se sienta")!= -1) AssignCommand(oPC, ActionPlayAnimation( ANIMATION_LOOPING_SIT_CROSS, 1.0, 99999.0f));
  else if(FindSubString(GetStringLowerCase(sTexto), "bienvenida")!= -1) AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_GREETING, 1.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "bosteza")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "se aburre") != -1)  AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED, 1.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "se estira")!= -1)
  {
      AssignCommand(oPC,ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC)));
      AssignCommand(oPC,ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC)));
      AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, 1.0));
  }
  else if(FindSubString(GetStringLowerCase(sTexto), "lee")!= -1) AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_READ, 1.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "saluda")!= -1)
  {
      AssignCommand(oPC,ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC)));
      AssignCommand(oPC,ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC)));
      AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_SALUTE, 1.0));
  }
  else if(FindSubString(GetStringLowerCase(sTexto), "roba")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "chinga") != -1) AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_STEAL, 1.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "insulta")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "se burla") != -1)
  {
      PlayVoiceChat(VOICE_CHAT_TAUNT, oPC);
      AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_TAUNT, 1.0));
  }
  else if(FindSubString(GetStringLowerCase(sTexto), "fuma") != -1 ||
          FindSubString(GetStringLowerCase(sTexto), "inhala") != -1) SmokePipe(oPC);
  else if(FindSubString(GetStringLowerCase(sTexto), "aviva")!= -1)
  {
      PlayVoiceChat(VOICE_CHAT_CHEER, oPC);
      AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_VICTORY1, 1.0));
  }
  else if(FindSubString(GetStringLowerCase(sTexto), "hurra")!= -1)
  {
      PlayVoiceChat(VOICE_CHAT_CHEER, oPC);
      AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_VICTORY2, 1.0));
  }
  else if(FindSubString(GetStringLowerCase(sTexto), "celebra")!= -1)
  {
      PlayVoiceChat(VOICE_CHAT_CHEER, oPC);
      AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_VICTORY3, 1.0));
  }
  else if(FindSubString(GetStringLowerCase(sTexto), "jijiji")!= -1 &&
          GetGender(oPC) == GENDER_FEMALE) AssignCommand(oPC, PlaySound("vs_fshaldrf_haha"));
  else if(FindSubString(GetStringLowerCase(sTexto), "fracasa")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "se tira")!= -1)  AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "recoge del suelo")!= -1) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "coge")!= -1) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 5.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "afirma")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "asiente")!= -1)  AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_LISTEN, 1.0, 4.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "bizquea")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "escudriña")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "busca")!= -1)  AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_LOOK_FAR, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "reza")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "medita")!= -1)
  {
      AssignCommand(oPC,ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC)));
      AssignCommand(oPC,ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC)));
      AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 99999.0));
  }
  else if(FindSubString(GetStringLowerCase(sTexto), "bebido")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "borracho")!= -1)  AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "cansado")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "fatigado")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "exhausto")!= -1)
  {
      PlayVoiceChat(VOICE_CHAT_REST, oPC);
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED, 1.0, 3.0));
  }
  else if(FindSubString(GetStringLowerCase(sTexto), "se pone nervioso")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "se mea encima")!= -1)  AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_PAUSE2, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "sienta")!= -1 &&
          FindSubString(GetStringLowerCase(sTexto), "suelo")!= -1)  AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "amenaza")!= -1) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "rie")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "carcajada")!= -1)
  {
      PlayVoiceChat(VOICE_CHAT_LAUGH, oPC);
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 1.0, 2.0));
  }
  else if(FindSubString(GetStringLowerCase(sTexto), "pide")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "ruega")!= -1)  AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "adora")!= -1)  AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "duerme")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "siesta")!= -1)
  {
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM18, 1.0, 999999.0));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SLEEP), oPC);
  }
  else if(FindSubString(GetStringLowerCase(sTexto), "canta")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "recita")!= -1)  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BARD_SONG), oPC, 6.0f);
  else if(FindSubString(GetStringLowerCase(sTexto), "susurra")!= -1)  AssignCommand(oPC, PlaySound("as_pl_whistle2"));
  else if(FindSubString(GetStringLowerCase(sTexto), "habla")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "conversa")!= -1)  AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "gira la cabeza")!= -1)
  {
      AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT, 1.0, 0.25f));
      DelayCommand(0.15f, AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT, 1.0, 0.25f)));
      DelayCommand(0.40f, AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT, 1.0, 0.25f)));
      DelayCommand(0.65f, AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT, 1.0, 0.25f)));
  }
  else if(FindSubString(GetStringLowerCase(sTexto), "elude")!= -1) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DODGE_DUCK, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "esquiva")!= -1) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DODGE_SIDE, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "conjura")!= -1) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "invoca")!= -1) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE2, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "se cae")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "se desmaya")!= -1) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "espasmo")!= -1) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_SPASM, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "toca")!= -1 &&
          FindSubString(GetStringLowerCase(sTexto), "trompeta")!= -1) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM3, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "nombra")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "señala")!= -1) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM16, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "a las armas")!= -1) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM16, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "escéptico")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "esceptico")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "dudoso")!= -1) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM17, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "llora")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "tiene miedo")!= -1) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM5, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "brazos cruzados")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "espera")!= -1) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM7, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "anima")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "espabila")!= -1) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM16, 2.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "se agacha")!= -1) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM10, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "besa")!= -1 ||
          FindSubString(GetStringLowerCase(sTexto), "besarse")!= -1) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM11, 1.0, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "baila")!= -1) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM19, 1.5, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "salta")!= -1) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM8, 1.5, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "acostarse encima")!= -1) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM12, 1.5, 99999.0));
  else if(FindSubString(GetStringLowerCase(sTexto), "acostarse debajo")!= -1) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM13, 1.5, 99999.0));
}
