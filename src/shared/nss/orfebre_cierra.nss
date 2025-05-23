#include "mti_libreria"
#include "yunque_inc"

void main()
{
  object oPC = GetLastClosedBy();

  // SI EL YUNQUE YA ESTA OCUPADO POR OTRA PERSONA, NADA OCURRE
  string sNombreMemorizado = GetLocalString(OBJECT_SELF, "YUNQUEOCUPADO");
  if(sNombreMemorizado != GetName(oPC, TRUE))
  {
      FloatingTextStringOnCreature("*La mesa ya está siendo usado por otra persona*", oPC, FALSE);
      return;
  }

  // SI EL YUNQUE ESTA VACIO, NADA OCURRE
  if(GetFirstItemInInventory() == OBJECT_INVALID)
  {
      FloatingTextStringOnCreature("*No hay nada en la mesa, nada ocurre*", oPC, FALSE);
      return;
  }

  // NECESITAS TENER NIVEL 1 O MAS PARA USAR EL YUNQUE
  int iNivelHabilidad = ObtenerIntPersistente(oPC, "NIVELTALLADOR");
  if(iNivelHabilidad == 0)
  {
      FloatingTextStringOnCreature("*Quizás debería hablar con algún maestro de Orfebreria antes de nada*", oPC, FALSE);
      return;
  }

  // SI NO TE EQUIPAS UN MARTILLO LIGERO DE HERRERO, EL SCRIPT NO SIGUE
  object oMartillo = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
  if(GetTag(oMartillo) != "pinzas_orfebre")
  {
      FloatingTextStringOnCreature("*No tienes equipado ningúnas pinzas de orfebre*", oPC, FALSE);
      EliminarVariablesYunque();
      return;
  }

  // MIREMOS A VER QUE TIPO DE MOLDE HEMOS METIDO Y LO GUARDAMOS
  object oMolde;
  oMolde = GetFirstItemInInventory();
  int iContadorMoldes;
  iContadorMoldes = 0;
  while(GetIsObjectValid(oMolde) == TRUE && iContadorMoldes < 2)
  {
      if(GetStringLeft(GetTag(oMolde), 6) == "molde_")
      {
          SetLocalObject(OBJECT_SELF, "MOLDE", oMolde);
          iContadorMoldes = iContadorMoldes + 1;
      }

      oMolde = GetNextItemInInventory();
  }

  // SI HAY MAS DE 1 MOLDE, EL SCRIPT NO SIGUE
  if(iContadorMoldes == 2)
  {
      FloatingTextStringOnCreature("*Sólo necesitas usar un tipo de molde*", oPC, FALSE);
      EliminarVariablesYunque();
      return;
  }

  // SI NO HAY MOLDE, EL SCRIPT NO SIGUE
  object oMoldeGuardado = GetLocalObject(OBJECT_SELF, "MOLDE");
  if(oMoldeGuardado == OBJECT_INVALID)
  {
      FloatingTextStringOnCreature("*¡Sin un molde en el yunque no puedes forjar nada¡*", oPC, FALSE);
      EliminarVariablesYunque();
      return;
  }

  // MIREMOS A VER QUE TIPO(S) DE LINGOTE(S)/INGREDIENTE(S) HEMOS METIDO Y
  // GUARDAMOS LA CANTIDAD
  int iLingotesCobre = 0;
  int iLingotesPlata = 0;
  int iLingotesOro = 0;
  int iLingotesPlatino = 0;


  object oLingIng = GetFirstItemInInventory();
  while(GetIsObjectValid(oLingIng) == TRUE)
  {
      if(GetTag(oLingIng) == "pepitaCobre") iLingotesCobre = iLingotesCobre + 1;
      else if(GetTag(oLingIng) == "pepitaPlata") iLingotesPlata = iLingotesPlata + 1;
      else if(GetTag(oLingIng) == "pepitaOro") iLingotesOro = iLingotesOro + 1;
      else if(GetTag(oLingIng) == "pepitaPlatino") iLingotesPlatino = iLingotesPlatino + 1;

      oLingIng = GetNextItemInInventory();
  }

  int iSumaLingotes = iLingotesCobre + iLingotesPlata + iLingotesOro +
      iLingotesPlatino;

  // SI NO HAY LINGOTE, EL SCRIPT NO SIGUE
  if(iSumaLingotes == 0)
  {
      FloatingTextStringOnCreature("*¡No hay ningúna piedra para crear anillos o cadenas en la mesa!*", oPC, FALSE);
      EliminarVariablesYunque();
      return;
  }

  // A CREAR OBJETOS!
  string sTagMolde = GetTag(oMoldeGuardado);

  // AROS
  if(sTagMolde == "molde_aro")
  {

      // Aro de bronce
      if(iLingotesCobre == 1)
      {
          CrearArosCadenas(oPC, "Fabricando un aro de bronce...", "bronce_aro",
          "*¡Has logrado fabricar un aro de bronce!*",
          "*¡Has logrado fabricar dos aros de bronce!*",
          "*¡Has logrado fabricar tres aros de bronce!*", 0, 0);
      }

      // Aro de plata
      else if(iLingotesPlata == 1)
      {
          CrearArosCadenas(oPC, "Fabricando un aro de plata...", "plata_aro",
          "*¡Has logrado fabricar un aro de plata!*",
          "*¡Has logrado fabricar dos aros de plata!*",
          "*¡Has logrado fabricar tres aros de plata!*", 0, 0);
      }

      // Aro de oro
      else if(iLingotesOro == 1)
      {
          CrearArosCadenas(oPC, "Fabricando un aro de oro...", "oro_aro",
          "*¡Has logrado fabricar un aro de oro!*",
          "*¡Has logrado fabricar dos aros de oro!*",
          "*¡Has logrado fabricar tres aros de oro!*", 0, 0);
      }

      //Aro de Platino
      else if(iLingotesPlatino == 1)
      {
          CrearArosCadenas(oPC, "Fabricando un aro de platino...", "platino_aro",
          "*¡Has logrado fabricar un aro de platino!*",
          "*¡Has logrado fabricar dos aros de platino!*",
          "*¡Has logrado fabricar tres aros de platino!*", 0, 0);
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // CADENAS
  else if(sTagMolde == "molde_cadena")
  {
      // Cadena de bronce
      if(iLingotesCobre == 1)
      {
          CrearArosCadenas(oPC, "Fabricando un Cadena de bronce...", "bronce_cadena",
          "*¡Has logrado fabricar un Cadena de bronce!*",
          "*¡Has logrado fabricar dos Cadenas de bronce!*",
          "*¡Has logrado fabricar tres Cadenas de bronce!*", 0, 0);
      }

      // Cadena de plata
      else if(iLingotesPlata == 1)
      {
          CrearArosCadenas(oPC, "Fabricando un Cadena de plata...", "plata_cadena",
          "*¡Has logrado fabricar un Cadena de plata!*",
          "*¡Has logrado fabricar dos Cadenas de plata!*",
          "*¡Has logrado fabricar tres Cadenas de plata!*", 0, 0);
      }

      // Cadena de oro
      else if(iLingotesOro == 1)
      {
          CrearArosCadenas(oPC, "Fabricando un Cadena de oro...", "oro_cadena",
          "*¡Has logrado fabricar un Cadena de oro!*",
          "*¡Has logrado fabricar dos Cadenas de oro!*",
          "*¡Has logrado fabricar tres Cadenas de oro!*", 0, 0);
      }

      //Cadena de Platino
      else if(iLingotesPlatino == 1)
      {
          CrearArosCadenas(oPC, "Fabricando un Cadena de platino...", "platino_cadena",
          "*¡Has logrado fabricar un Cadena de platino!*",
          "*¡Has logrado fabricar dos Cadenas de platino!*",
          "*¡Has logrado fabricar tres Cadenas de platino!*", 0, 0);
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de molde y lingote(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }

  // No hay molde?
  else
  {
      FloatingTextStringOnCreature("ERROR: Este mensaje no debería salir nunca, por favor informa a Darth sobre esto", oPC, FALSE);
      EliminarVariablesYunque();
      return;
  }
}

