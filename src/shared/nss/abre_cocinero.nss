void main()
{
   object oPC= GetLastOpenedBy();
   object oMarmita= OBJECT_SELF;
   object oBorrado;

   string sCocinero= GetLocalString(oMarmita, "COCINERO");
   if(sCocinero!=""){
      if(sCocinero!=GetName(oPC)){
         //Nuevo Ayudante
         effect eFracaso= EffectVisualEffect(57);
         DelayCommand(0.1, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFracaso, GetLocation(oMarmita)));
         oBorrado = GetFirstItemInInventory(oMarmita);
         while (GetIsObjectValid(oBorrado)){
            DestroyObject(oBorrado);
            oBorrado = GetNextItemInInventory(oMarmita);
         }
         DelayCommand(0.1, FloatingTextStringOnCreature("*El ingrediente que alguien estaba cocinando se ha echado a perder...*", oPC));
         DeleteLocalString(oMarmita, "COCINERO");
         SetLocalString(oMarmita, "COCINERO", GetName(oPC));
      }
   }

   // Comprobamos si tiene equipado los guantes de cocinero
   string sGuantes = GetTag(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC));
   if(sGuantes != "guantesCocinero"){
       DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
       DelayCommand(0.3, FloatingTextStringOnCreature("*¡No puedes cocinar ingredientes sin los guantes de cocinero puestos!*", oPC));
       return;
   }

   // Ponemos la probabilidad de que los guantes se rompan
   object oGuantes = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
   int iUsosGuantes= GetLocalInt(oGuantes, "USOSGUANTES");
   if(iUsosGuantes == 0) SetLocalInt(oGuantes, "USOSGUANTES", d6(10));
   else if(iUsosGuantes == 1){
      DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(0.5, AssignCommand(oPC,PlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED, 1.0, 2.5)));
      DelayCommand(0.8, FloatingTextStringOnCreature("*¡Tus guantes de cocinero se han roto!*", oPC));
      DestroyObject(oGuantes, 0.8);
      DelayCommand(1.8, PlayVoiceChat(VOICE_CHAT_CUSS ,oPC));
      return;
   }else{
      SetLocalInt(oGuantes, "USOSGUANTES", iUsosGuantes - 1);
   }

   // Animacion del PJ
   DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
   DelayCommand(0.5, AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 1.5)));
   //Plantas
   DelayCommand(0.8, FloatingTextStringOnCreature("*Coloca las plantas para elaborar el ingrediente...*", oPC));
   SetLocalInt(oMarmita, "PASO", 1);
}
