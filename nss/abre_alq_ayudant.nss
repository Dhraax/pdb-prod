#include "mti_libreria"

void main()
{
   object oPC= GetLastOpenedBy();
   object oBrasero= OBJECT_SELF;
   object oBorrado;

   string sAyudante= GetLocalString(oBrasero, "AYUDANTE");
   if(sAyudante!=""){
      if(sAyudante!=GetName(oPC)){
         //Nuevo Ayudante
         effect eFracaso= EffectVisualEffect(57);
         DelayCommand(0.1, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFracaso, GetLocation(oBrasero)));
         oBorrado = GetFirstItemInInventory(oBrasero);
         while (GetIsObjectValid(oBorrado)){
            DestroyObject(oBorrado);
            oBorrado = GetNextItemInInventory(oBrasero);
         }
         DelayCommand(0.1, FloatingTextStringOnCreature("*La poción que alguien estaba preparando se ha echado a perder...*", oPC));
         DeleteLocalString(oBrasero, "AYUDANTE");
         DeleteLocalString(oBrasero, "POCION");
         DeleteLocalString(oBrasero, "POCIONBASE");
         DeleteLocalString(oBrasero, "POCIONNOMBRE");
         DeleteLocalString(oBrasero, "POCIONTAG");
         DeleteLocalInt(oBrasero, "PASO");
         DeleteLocalInt(oBrasero, "DIFICULTAD");
         DeleteLocalInt(oBrasero, "NIVELCOCINA");
         SetLocalString(oBrasero, "AYUDANTE", GetName(oPC));
      }
   }

   // Comprobamos si tiene equipado los guantes de cocinero
   string sGuantes = GetTag(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC));
   if(sGuantes != "guantesCocinero"){
       DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
       DelayCommand(0.3, FloatingTextStringOnCreature("*¡No puedes preparar la poción para el alquimista sin los guantes de cocionero puestos!*", oPC));
       return;
   }

   //Comprobamos que sabe Cocina
   int iNivelHabilidad = ObtenerIntPersistente(oPC, "NIVELCOCINA");
   //No tiene ni el nivel 1 en la habilidad
   if (iNivelHabilidad==0){
      DelayCommand(1.5, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(1.5, FloatingTextStringOnCreature("*Quizá deberías hablar con algún Maestro de Herboristería antes de nada...*", oPC));
      return;
   }

   string pocion= GetLocalString(oBrasero, "POCION");
   if(pocion==""){
      // Ponemos la probabilidad de que los guantes se rompan
      object oGuantes = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
      int iUsosGuantes= GetLocalInt(oGuantes, "USOSGUANTES");
      if(iUsosGuantes == 0) SetLocalInt(oGuantes, "USOSGUANTES", d6(8));
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
      //Primer componente
      DelayCommand(0.8, FloatingTextStringOnCreature("*Coloca la poción para el alquimista...*", oPC));
      SetLocalInt(oBrasero, "PASO", 1);
   }else {
      // Animacion del PJ
      DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(0.5, AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 1.5)));
      //Primer componente
      DelayCommand(0.8, FloatingTextStringOnCreature("*Coloca una redoma vacía y espera a que el alquimista acabe...*", oPC));
      SetLocalInt(oBrasero, "PASO", 2);
   }
}
