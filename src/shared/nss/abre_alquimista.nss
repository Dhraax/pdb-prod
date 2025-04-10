#include "mti_libreria"
#include "sute_libreria"


void main(){
   object oPC= GetLastOpenedBy();
   object oMesa= OBJECT_SELF;
   object oBorrado;

   string sAlquimista= GetLocalString(oMesa, "ALQUIMISTA");
   if(sAlquimista!=""){
      if(sAlquimista!=GetName(oPC)){
         //Nuevo Alquimista
         effect eFracaso= EffectVisualEffect(57);
         DelayCommand(0.1, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFracaso, GetLocation(oMesa)));
         oBorrado = GetFirstItemInInventory(oMesa);
         while (GetIsObjectValid(oBorrado)){
            DestroyObject(oBorrado);
            oBorrado = GetNextItemInInventory(oMesa);
         }
         DelayCommand(0.1, FloatingTextStringOnCreature("*La transformación que alguien estaba efectuando se ha echado a perder...*", oPC));
         DeleteLocalString(oMesa, "ALQUIMISTA");
         DeleteLocalInt(oMesa, "PASO");
         DeleteLocalInt(oPC, "INGREDIENTE1");
         DeleteLocalInt(oPC, "INGREDIENTE2");
         SetLocalString(oMesa, "ALQUIMISTA", GetName(oPC));
      }
   }

   // Comprobamos si tiene equipado los guantes de alquimista
   string sGuantes = GetTag(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC));
   if(sGuantes != "guantesAlquimista"){
       DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
       DelayCommand(0.3, FloatingTextStringOnCreature("*¡No puedes efectuar transformaciones sin los guantes de alquimista puestos!*", oPC));
       return;
   }

   int ing1= GetLocalInt(oMesa, "INGREDIENTE1");
   int ing2= GetLocalInt(oMesa, "INGREDIENTE2");
   if(ing1==0){
      // Ponemos la probabilidad de que los guantes se rompan
      object oGuantes = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
      int iUsosGuantes= GetLocalInt(oGuantes, "USOSGUANTES");
      if(iUsosGuantes == 0) SetLocalInt(oGuantes, "USOSGUANTES", d6(10));
      else if(iUsosGuantes == 1){
         DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
         DelayCommand(0.5, AssignCommand(oPC,PlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED, 1.0, 2.5)));
         DelayCommand(0.8, FloatingTextStringOnCreature("*¡Tus guantes de alquimista se han roto!*", oPC));
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
      DelayCommand(0.8, FloatingTextStringOnCreature("*Coloca el primer ingrediente de la transformación...*", oPC));
      DeleteLocalInt(oPC, "INGREDIENTE1");
      DeleteLocalInt(oPC, "INGREDIENTE2");
      SetLocalInt(oMesa, "PASO", 1);
   }else if (ing2==0){
      // Animacion del PJ
      DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(0.5, AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 1.5)));
      //Segundo componente o efectuar transformación de 1 componente
      DelayCommand(0.8, FloatingTextStringOnCreature("*Coloca el segundo ingrediente de la transformación o bien una redoma vacía si has terminado...*", oPC));
      SetLocalInt(oMesa, "PASO", 2);
   }else{
      // Animacion del PJ
      DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(0.5, AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 1.5)));
      //Efectuar transformación de 2 componentes
      DelayCommand(0.8, FloatingTextStringOnCreature("*Coloca una redoma vacía para terminar...*", oPC));
      SetLocalInt(oMesa, "PASO", 3);
   }
}
