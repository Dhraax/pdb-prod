#include "sute_libreria"

void main(){
   object oPC= GetLastOpenedBy();
   object oCaldero= OBJECT_SELF;
   object oBorrado;

   string sHerbolario= GetLocalString(oCaldero, "HERBOLARIO");
   if(sHerbolario!=""){
      if(sHerbolario!=GetName(oPC)){
         //Nuevo Herbolario
         effect eFracaso= EffectVisualEffect(57);
         DelayCommand(0.1, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFracaso, GetLocation(OBJECT_SELF)));
         oBorrado = GetFirstItemInInventory(oCaldero);
         while (GetIsObjectValid(oBorrado)){
            DestroyObject(oBorrado);
            oBorrado = GetNextItemInInventory(oCaldero);
         }
         DelayCommand(0.1, FloatingTextStringOnCreature("*La poción que alguien estaba elaborando se ha echado a perder...*", oPC, FALSE));
         DeleteLocalString(oCaldero, "HERBOLARIO");
         DeleteLocalInt(oCaldero, "PASO");
         DeleteLocalInt(oCaldero, "INGREDIENTE1");
         DeleteLocalInt(oCaldero, "INGREDIENTE2");
         DeleteLocalInt(oCaldero, "INGREDIENTE3");
         SetLocalString(oCaldero, "HERBOLARIO", GetName(oPC));
      }
   }

   // Comprobamos si tiene equipado los guantes de herbolario
   string sGuantes = GetTag(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC));
   if(sGuantes != "guantesHerbolario"){
       DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
       DelayCommand(0.3, FloatingTextStringOnCreature("*¡No puedes elaborar pociones sin los guantes de herbolario puestos!*", oPC, FALSE));
       return;
   }

   int ing1= GetLocalInt(oCaldero, "INGREDIENTE1");
   int ing2= GetLocalInt(oCaldero, "INGREDIENTE2");
   int ing3= GetLocalInt(oCaldero, "INGREDIENTE3");
   if(ing1==0){
      // Ponemos la probabilidad de que los guantes se rompan
      object oGuantes = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
      int iUsosGuantes= GetLocalInt(oGuantes, "USOSGUANTES");
      if(iUsosGuantes == 0) SetLocalInt(oGuantes, "USOSGUANTES", d6(10));
      else if(iUsosGuantes == 1){
         DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
         DelayCommand(0.5, AssignCommand(oPC,PlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED, 1.0, 2.5)));
         DelayCommand(0.8, FloatingTextStringOnCreature("*¡Tus guantes de herbolario se han roto!*", oPC, FALSE));
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
      DelayCommand(0.6, FloatingTextStringOnCreature("*Coloca el primer ingrediente de la poción...*", oPC, FALSE));
      DeleteLocalInt(oCaldero, "INGREDIENTE1");
      DeleteLocalInt(oCaldero, "INGREDIENTE2");
      DeleteLocalInt(oCaldero, "INGREDIENTE3");
      SetLocalInt(oCaldero, "PASO", 1);
   }else if (ing2==0){
      // Animacion del PJ
      DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(0.5, AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 1.5)));
      //Segundo componente o elaborar pocion de 1 componente
      DelayCommand(0.8, FloatingTextStringOnCreature("*Coloca el segundo ingrediente de la poción o bien una redoma vacía si has terminado...*", oPC, FALSE));
      SetLocalInt(oCaldero, "PASO", 2);
   }else if (ing3==0){
      // Animacion del PJ
      DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(0.5, AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 1.5)));
      //Tercer componente o elaborar pocion de 2 componentes
      DelayCommand(0.8, FloatingTextStringOnCreature("*Coloca el tercer ingrediente de la poción o bien una redoma vacía si has terminado...*", oPC, FALSE));
      SetLocalInt(oCaldero, "PASO", 3);
   }else{
      // Animacion del PJ
      DelayCommand(0.3, AssignCommand(oPC,ClearAllActions(TRUE)));
      DelayCommand(0.5, AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 1.5)));
      //Elaborar pocion de 3 componentes
      DelayCommand(0.8, FloatingTextStringOnCreature("*Coloca una redoma vacía para terminar...*", oPC, FALSE));
      SetLocalInt(oCaldero, "PASO", 4);
   }
}
