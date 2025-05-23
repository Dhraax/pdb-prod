#include "cab_inc"

void main()
{
  object oPC = GetPCSpeaker();

  // Se escucha un nombre correctamente
  int iCanal = GetListenPatternNumber();
  if(iCanal == 777)
  {
      // Cambio de nombre
      string sNombre = GetMatchedSubstring(0);
      SetName(OBJECT_SELF, sNombre);

      // Animaciones y ajustes en monturas
      if(VerSiEsMontura() == TRUE)
      {
          SpeakString("<cþ<<>* La montura parece feliz con su nuevo nombre: "+sNombre+" *</c>");

          if(VerSiDebeTenerSonidoCaballo())
          {
              AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_FIREFORGET_TAUNT));
              AssignCommand(oPC, PlaySound("c_horse_bat"+IntToString(d2())));
          }
          else
          {
              AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1));
              AssignCommand(oPC, PlaySound("c_maggris_bat"+IntToString(d3())));
          }

          object oMonturaActiva = GetFirstItemInInventory(oPC);
          while(GetIsObjectValid(oMonturaActiva) == TRUE)
          {
              if(GetTag(oMonturaActiva) == "cab_montura" &&
                 GetItemCursedFlag(oMonturaActiva) == TRUE &&
                 GetLocalInt(oMonturaActiva, "CAB_MUERTO") == FALSE)
              {
                  SetLocalString(oMonturaActiva, "CABNOMBRE", sNombre);
                  DescripcionMontura(oMonturaActiva);
              }
              oMonturaActiva = GetNextItemInInventory(oPC);
          }
      }

      // Animaciones y ajustes en mascotas
      else
      {
          object oObjetoMascota = GetLocalObject(oPC, "MASCOTA_OBJGUARDADO");
          SpeakString("<cþ<<>* La mascota sonríe feliz con su nuevo nombre: "+sNombre+" *</c>");
          SetLocalString(oObjetoMascota, "MASCOTA_NOMBREPERS", sNombre);
          DescripcionMascota(oObjetoMascota);
      }
  }

  // No se escucha un nombre correctamente
  else
  {
      SendMessageToPC(oPC, "<cþ<<>¡No has dicho nada! Di en voz alta un nombre y luego selecciona 'Hecho'.</c>");
  }
}
