void main()
{
  object oPC = GetLastOpenedBy();
  object oForja = OBJECT_SELF;
  object oBorrado;

  string sFundidor = GetLocalString(oForja, "FUNDIDOR");
  if(sFundidor != "")
  {
      if(sFundidor != GetName(oPC))
      {
          //Nuevo Fundidor
          effect eFracaso = EffectVisualEffect(60);
          DelayCommand(0.1, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFracaso, GetLocation(oForja)));

          oBorrado = GetFirstItemInInventory(oForja);
          while(GetIsObjectValid(oBorrado))
          {
              DestroyObject(oBorrado);
              oBorrado = GetNextItemInInventory(oForja);
          }

          DelayCommand(0.1, FloatingTextStringOnCreature("*El metal que alguien estaba fundiendo se ha echado a perder...*", oPC));
          DeleteLocalString(oForja, "FUNDIDOR");
          SetLocalString(oForja, "FUNDIDOR", GetName(oPC));
      }
  }

  // Comprobamos si tiene equipado los guantes de fundidor
  string sGuantes = GetTag(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC));
  if(sGuantes != "guantesFundidor")
  {
      DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(0.3, FloatingTextStringOnCreature("*¡No puedes fundir metales sin los guantes de fundidor puestos!*", oPC));
      return;
  }

  // Ponemos la probabilidad de que los guantes se rompan
  object oGuantes = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
  int iUsosGuantes = GetLocalInt(oGuantes, "USOSGUANTES");
  if(iUsosGuantes == 0) SetLocalInt(oGuantes, "USOSGUANTES", d6(10));
  else if(iUsosGuantes == 1)
  {
      DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(0.5, AssignCommand(oPC,PlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED, 1.0, 2.5)));
      DelayCommand(0.8, FloatingTextStringOnCreature("*¡Tus guantes de fundidor se han roto!*", oPC));
      DestroyObject(oGuantes, 0.8);
      DelayCommand(1.8, PlayVoiceChat(VOICE_CHAT_CUSS ,oPC));
      return;
  }

  else
  {
      SetLocalInt(oGuantes, "USOSGUANTES", iUsosGuantes - 1);
  }

  // Animacion del PJ
  DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
  DelayCommand(0.5, AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 1.5)));

  //Plantas
  DelayCommand(0.8, FloatingTextStringOnCreature("*Coloca las pepitas para fundir el metal...*", oPC));
  SetLocalInt(oForja, "PASO", 1);
}
