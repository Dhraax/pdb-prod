//::///////////////////////////////////////////////
//:: OFICIO DE ARTESANIA URDIMBRICA, ON CLOSE
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
  3er Oficio de Artesania Urdimbrica.
  Se situa en el OnClose de la Mesa de Artesanía Urdímbrica,
  realiza las comprobaciones iniciales
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 16 de Agosto de 2013
//:://////////////////////////////////////////////

#include "mti_libreria"
#include "pb_ofi_artesa_i"

void main()
{
  object oPC = GetLastClosedBy();

  // Antisaturamiento de la mesa
  if(GetLocalInt(OBJECT_SELF, "ANTI_SPAM") == TRUE) return;

  // Se elimina el objeto guardado anteriormente
  if(GetLocalObject(OBJECT_SELF, "OBJETO_A_ENCANTAR") != OBJECT_INVALID) DeleteLocalObject(OBJECT_SELF, "OBJETO_A_ENCANTAR");

  // Si la mesa esta vacia, nanay
  object oObjetoAEncantar = GetFirstItemInInventory();
  if(oObjetoAEncantar == OBJECT_INVALID) return;

  // Debemos tener nivel 1 o más en el oficio
  int iNivelHabilidad = ObtenerIntPersistente(oPC, "Profesion15");
  if(iNivelHabilidad == 0)
  {
      SendMessageToPC(oPC, "<cþ<<>Deberías hablar con algún maestro de Artesanía Urdímbrica antes de usar esto.</c>");
      return;
  }

  // Contador de objetos encantables y notas/libros
  object oObjetoAEncantarGuardado;
  object oObjetoNota;
  int iContadorObjetosAEncantar = 0;
  int iContadorObjetosNota = 0;
  while(GetIsObjectValid(oObjetoAEncantar) == TRUE && iContadorObjetosAEncantar < 2)
  {
      if(GetLocalInt(oObjetoAEncantar, "OFICIO_OBJETO_ENCANTABLE") == TRUE)
      {
          oObjetoAEncantarGuardado = oObjetoAEncantar;
          SetLocalObject(OBJECT_SELF, "OBJETO_A_ENCANTAR", oObjetoAEncantar);
          iContadorObjetosAEncantar = iContadorObjetosAEncantar + 1;
      }
      if(GetTag(oObjetoAEncantar) == "esc_papel")
      {
          iContadorObjetosNota = iContadorObjetosNota + 1;
          oObjetoNota = oObjetoAEncantar;
      }

      oObjetoAEncantar = GetNextItemInInventory();
  }

  // Solo 1 objeto encantable debe haber
  if(iContadorObjetosAEncantar == 0 || iContadorObjetosAEncantar > 1)
  {
      SendMessageToPC(oPC, "<cþ<<>Debe de haber un único objeto susceptible al encantamiento sobre la mesa.</c>");
      SetLocalInt(OBJECT_SELF, "ERRORENCANTAMIENTO", 1);
      return;
  }

  // Notas del sistema de escritura, cambio de nombre y descripcion
  int iEncantamientosActuales = GetLocalInt(oObjetoAEncantarGuardado, "ENCANTAMIENTOS_REALIZADOS");
  if(iContadorObjetosNota >= 1 && iEncantamientosActuales > 0)
  {
      if(iContadorObjetosNota > 1)
      {
          SendMessageToPC(oPC, "<cþ<<>Sólo debe de haber una nota/libro sobre la mesa para cambiar el nombre y la descripción del objeto susceptible al encantamiento.</c>");
          SetLocalInt(OBJECT_SELF, "ERRORENCANTAMIENTO", 2);
          return;
      }

      string sNombreNota = GetName(oObjetoNota);
      string sDescripcionNota = GetDescription(oObjetoNota);

      SetName(oObjetoAEncantarGuardado, sNombreNota);
      SetDescription(oObjetoAEncantarGuardado, sDescripcionNota);

      SendMessageToPC(oPC, "<c´þd>Cambio de nombre y descripción aplicado.</c>");
      SetLocalInt(oObjetoAEncantarGuardado, "ARTESANIA_DESC_FIJA", TRUE);
      DestroyObject(oObjetoNota, 0.5);
      return;
  }

  // Objetos con 5 propiedades no se encantan
  if(BuclePropiedades(oObjetoAEncantarGuardado) >= 5)
  {
      SendMessageToPC(oPC, "<cþ<<>El objeto ya no admite más encantamientos.</c>");
      SetLocalInt(OBJECT_SELF, "ERRORENCANTAMIENTO", 3);
      return;
  }

  // Definimos qué objetos son encantables (por defecto sólo los de oficio)
  string sTagObjeto = GetTag(oObjetoAEncantarGuardado);
  string sTag1 = GetStringLeft(sTagObjeto, 7);
  string sTag2 = GetStringLeft(sTagObjeto, 3);
  string sTag3 = GetStringLeft(sTagObjeto, 8);
  string sTag4 = GetStringLeft(sTagObjeto, 6);
  string sTag5 = GetStringLeft(sTagObjeto, 4);

  if((sTag1 == "anillo_"  && iEncantamientosActuales == 1) ||  // Orfebreria
     (sTag5 == "amu_"     && iEncantamientosActuales == 2) ||
     (sTag2 == "pi_"      && iEncantamientosActuales == 1) ||  // Carpinteria
     (sTag2 == "ci_"      && iEncantamientosActuales == 1) ||
     (sTag2 == "ab_"      && iEncantamientosActuales == 2) ||
     (sTag2 == "ce_"      && iEncantamientosActuales == 2) ||
     (sTag2 == "al_"      && iEncantamientosActuales == 2) ||
     (sTag2 == "ol_"      && iEncantamientosActuales == 3) ||
     (sTag2 == "ro_"      && iEncantamientosActuales == 3) ||
     (sTag2 == "fr_"      && iEncantamientosActuales == 3) ||
     (sTag2 == "hr_"      && iEncantamientosActuales == 1) ||  // Herreria
     (sTag2 == "co_"      && iEncantamientosActuales == 1) ||
     (sTag2 == "ac_"      && iEncantamientosActuales == 2) ||
     (sTag2 == "pl_"      && iEncantamientosActuales == 2) ||
     (sTag2 == "hf_"      && iEncantamientosActuales == 2) ||
     (sTag2 == "or_"      && iEncantamientosActuales == 3) ||
     (sTag2 == "mi_"      && iEncantamientosActuales == 3) ||
     (sTag2 == "ad_"      && iEncantamientosActuales == 3) ||
     (sTag2 == "dl_"      && iEncantamientosActuales == 3) ||
     (sTag2 == "hi_"      && iEncantamientosActuales == 3) ||
     (sTag2 == "ac_"      && iEncantamientosActuales == 3) ||
     (sTag3 == "platino_" && iEncantamientosActuales == 3) ||
     (sTag2 == "ar_"      && iEncantamientosActuales == 3) ||
     (sTag2 == "me_"      && iEncantamientosActuales == 3) ||
     (sTag4 == "meteo_"   && iEncantamientosActuales == 3) ||
     (sTag5 == "aco_"     && iEncantamientosActuales == 3) ||
      GetLocalInt(oObjetoAEncantarGuardado, "REGENERACION_PROPIEDAD_UNICA") == TRUE) // Regeneracion es propiedad unica
  {
      SendMessageToPC(oPC, "<cþ<<>El objeto ya no admite más encantamientos.</c>");
      SetLocalInt(OBJECT_SELF, "ERRORENCANTAMIENTO", 3);
      return;
  }

  // Todo está bien, estamos listos para lanzar el conjuro
  SendMessageToPC(oPC, "<c´þd>Has colocado un objeto susceptible al encantamiento sobre la mesa. Puedes empezar con el encantamiento lanzando un conjuro sobre la mesa.</c>");
  if(GetLocalInt(OBJECT_SELF, "ERRORENCANTAMIENTO") > 0) DeleteLocalInt(OBJECT_SELF, "ERRORENCANTAMIENTO");
}
