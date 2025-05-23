#include "mti_libreria"
#include "sute_libreria"

/*Obtiene la pocion introducida en la mesa de mezclas:
 *   "": objeto invalido o mas de un objeto
 *   Tag de la pocion: pocion introducida
 */
string obtenerPocion(object oBrasero, object oPC){
   object oObjeto;
   int numObjetos= 0;
   string sPocionNombre= "";
   string sPocionTag= "";
   string sPocionBase="";

   oObjeto = GetFirstItemInInventory(oBrasero);
   while (GetIsObjectValid(oObjeto)){
      numObjetos= numObjetos+1;
      sPocionNombre= GetName(oObjeto);
      sPocionTag= GetTag(oObjeto);
      sPocionBase= GetResRef(oObjeto);
      DestroyObject(oObjeto);
      oObjeto = GetNextItemInInventory(oBrasero);
   }
   if(numObjetos==1){
      if(GetSubString(sPocionTag, 0, 9)=="sute_her_"){
         SetLocalString(oBrasero, "POCIONNOMBRE", sPocionNombre);
         SetLocalString(oBrasero, "POCIONTAG", sPocionTag);
         SetLocalString(oBrasero, "POCIONBASE", sPocionBase);
         SetLocalInt(oBrasero, "DIFICULTAD", StringToInt(GetSubString(sPocionTag, 13, 3)));
         SetLocalInt(oBrasero, "NIVELCOCINA", ObtenerIntPersistente(oPC, "NIVELCOCINA"));
         return sPocionTag;
      }else{
         return "";
      }
   }else{
      return "";
   }
}

void main(){
   object oPC= GetLastClosedBy();
   object oBrasero= OBJECT_SELF;
   object oBorrado;
   effect ePocion;

   int iPaso= GetLocalInt(oBrasero, "PASO");
   if (iPaso==1){
      string sPocion= obtenerPocion(oBrasero, oPC);
      if (sPocion!=""){
         SetLocalString(oBrasero, "POCION", sPocion);
         DelayCommand(0.5, FloatingTextStringOnCreature("*Preparas la poción para su transformación...*", oPC));
         ePocion = EffectVisualEffect(31);
         DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, ePocion, GetLocation(oBrasero)));
         if ((GetName(oPC)=="Ukiah")||(GetName(oPC)=="Teiris")){
            SendMessageToPC(oPC, "Estas preparando: "+ GetLocalString(oBrasero, "POCIONNOMBRE")+ ", de TAG: "+ GetLocalString(oBrasero, "POCIONTAG")+ ", de base: "+ GetLocalString(oBrasero, "POCIONBASE")+ ", de Dificultad: "+ IntToString(GetLocalInt(oBrasero, "DIFICULTAD"))+ " y tu nivel de Cocina Registrado es: "+ IntToString(GetLocalInt(oBrasero, "NIVELCOCINA")));
         }
      }else{
         DelayCommand(0.5, FloatingTextStringOnCreature("*¡Eso no es una poción adecuada para el alquimista, se ha echado a perder!*", oPC));
         ePocion = EffectVisualEffect(57);
         DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, ePocion, GetLocation(oBrasero)));
         oBorrado = GetFirstItemInInventory(oBrasero);
         while (GetIsObjectValid(oBorrado)){
            DestroyObject(oBorrado);
            oBorrado = GetNextItemInInventory(oBrasero);
         }
         DeleteLocalString(oBrasero, "AYUDANTE");
         DeleteLocalString(oBrasero, "POCION");
         DeleteLocalString(oBrasero, "POCIONBASE");
         DeleteLocalString(oBrasero, "POCIONNOMBRE");
         DeleteLocalString(oBrasero, "POCIONTAG");
         DeleteLocalInt(oBrasero, "PASO");
         DeleteLocalInt(oBrasero, "DIFICULTAD");
         DeleteLocalInt(oBrasero, "NIVELCOCINA");
      }
   }
   if (iPaso==2){
      DelayCommand(0.5, FloatingTextStringOnCreature("*El fuego consume los restos y el brasero vuelve a estar listo...*", oPC));
      ePocion = EffectVisualEffect(60);
      DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, ePocion, GetLocation(oBrasero)));
      oBorrado = GetFirstItemInInventory(oBrasero);
      while (GetIsObjectValid(oBorrado)){
         DestroyObject(oBorrado);
         oBorrado = GetNextItemInInventory(oBrasero);
      }
      DeleteLocalString(oBrasero, "POCION");
      DeleteLocalString(oBrasero, "POCIONBASE");
      DeleteLocalString(oBrasero, "POCIONNOMBRE");
      DeleteLocalString(oBrasero, "POCIONTAG");
      DeleteLocalInt(oBrasero, "PASO");
      DeleteLocalInt(oBrasero, "DIFICULTAD");
      DeleteLocalInt(oBrasero, "NIVELCOCINA");
   }
}
