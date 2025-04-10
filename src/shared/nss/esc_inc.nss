#include "nwnx_object"

int UsosTinta(object oPC)
{
  object oTinta = GetItemPossessedBy(oPC, "esc_tinta");

  // Si tenemos o no tinta
  if(GetIsObjectValid(oTinta) != TRUE)
  {
      SendMessageToPC(oPC, "<cþ<<>¡No tienes tinta! No puedes escribir con una pluma sin tinta.</c>");
      return FALSE;
  }

  // Usos tinta
  int iUsosTinta = GetLocalInt(oTinta, "USOS");
  if(iUsosTinta == 0)
  {
      SetLocalInt(oTinta, "USOS", 65 + d20());
  }
  else if(iUsosTinta == 1)
  {
      SendMessageToPC(oPC, "<cþ<<>Se te acabó un frasco de tinta.</c>");
      DestroyObject(oTinta);
  }
  else
  {
      SetLocalInt(oTinta, "USOS", iUsosTinta - 1);
  }

  return TRUE;
}

void ModoEscritura(int iModoEscritura, string sTextoHablado, object oPC)
{
  object oEscritoGuardado = GetLocalObject(oPC, "ESC_PAPEL");

  // Codigos: nuevo parrafo
  if(GetStringLowerCase(sTextoHablado) == GetStringLowerCase("nuevo parrafo") ||
     GetStringLowerCase(sTextoHablado) == GetStringLowerCase("nuevo párrafo"))
  {
      if(iModoEscritura == 1)
      {
          SendMessageToPC(oPC, "<cþ>[Modo escritura]: <cÍþ>No puedes añadir un nuevo párrafo en el nombre.</c></c>");
          return;
      }
      else if(iModoEscritura == 2)
      {
          SendMessageToPC(oPC, "<cþ>[Modo escritura]: <cÍþ>Añades un nuevo párrafo.</c></c>");
          SetDescription(oEscritoGuardado, GetDescription(oEscritoGuardado) + "\n\n");
          return;
      }
      else
      {
          SendMessageToPC(oPC, "<cþ>[Modo escritura]: <cÍþ>Añades un nuevo párrafo.</c></c>");
          SetDescription(oPC, GetDescription(oPC) + "\n\n");
          return;
      }
  }

  // Codigos: colores
  else if(GetStringLowerCase(sTextoHablado) == GetStringLowerCase("color rojo"))
  {
      SendMessageToPC(oPC, "<cþ>[Modo escritura]: <cÍþ>Ajuste de color rojo, lo próximo que escribas será en este color.</c></c>");
      SetLocalString(oPC, "ESC_COLOR", "<cþ<<>");
      return;
  }
  else if(GetStringLowerCase(sTextoHablado) == GetStringLowerCase("color azul"))
  {
      SendMessageToPC(oPC, "<cþ>[Modo escritura]: <cÍþ>Ajuste de color azul, lo próximo que escribas será en este color.</c></c>");
      SetLocalString(oPC, "ESC_COLOR", "<c!}þ>");
      return;
  }
  else if(GetStringLowerCase(sTextoHablado) == GetStringLowerCase("color amarillo"))
  {
      SendMessageToPC(oPC, "<cþ>[Modo escritura]: <cÍþ>Ajuste de color amarillo, lo próximo que escribas será en este color.</c></c>");
      SetLocalString(oPC, "ESC_COLOR", "<cþïP>");
      return;
  }
  else if(GetStringLowerCase(sTextoHablado) == GetStringLowerCase("color verde"))
  {
      SendMessageToPC(oPC, "<cþ>[Modo escritura]: <cÍþ>Ajuste de color verde, lo próximo que escribas será en este color.</c></c>");
      SetLocalString(oPC, "ESC_COLOR", "<c´þd>");
      return;
  }
  else if(GetStringLowerCase(sTextoHablado) == GetStringLowerCase("color violeta"))
  {
      SendMessageToPC(oPC, "<cþ>[Modo escritura]: <cÍþ>Ajuste de color violeta, lo próximo que escribas será en este color.</c></c>");
      SetLocalString(oPC, "ESC_COLOR", "<cÍþ>");
      return;
  }
  else if(GetStringLowerCase(sTextoHablado) == GetStringLowerCase("color cian"))
  {
      SendMessageToPC(oPC, "<cþ>[Modo escritura]: <cÍþ>Ajuste de color cian, lo próximo que escribas será en este color.</c></c>");
      SetLocalString(oPC, "ESC_COLOR", "<cßþ>");
      return;
  }
  else if(GetStringLowerCase(sTextoHablado) == GetStringLowerCase("color naranja"))
  {
      SendMessageToPC(oPC, "<cþ>[Modo escritura]: <cÍþ>Ajuste de color naranja, lo próximo que escribas será en este color.</c></c>");
      SetLocalString(oPC, "ESC_COLOR", "<cþ–2>");
      return;
  }
  else if(GetStringLowerCase(sTextoHablado) == GetStringLowerCase("color blanco"))
  {
      SendMessageToPC(oPC, "<cþ>[Modo escritura]: <cÍþ>Ajuste de color blanco, lo próximo que escribas será en este color.</c></c>");
      DeleteLocalString(oPC, "ESC_COLOR");
      return;
  }

  // Usos tinta (descripcion y retrato de pjs no)
  if(iModoEscritura < 3 )
  {
      if(UsosTinta(oPC) == FALSE) return;
  }

  // Miramos que color debemos usar
  string sColor = GetLocalString(oPC, "ESC_COLOR");
  string sEscrito;
  if(sColor == "") sEscrito = sTextoHablado;
  else sEscrito = sColor + sTextoHablado + "</c>";

  string sDescripcionEscritoGuardado = GetDescription(oEscritoGuardado);
  string sDescripcionPJ = GetDescription(oPC);

  // Editar nombre
  if(iModoEscritura == 1)
  {
      SetName(oEscritoGuardado, sEscrito);
      FloatingTextStringOnCreature("<c´þd>* Escribes un nuevo nombre: " + sEscrito + " *</c>", oPC, FALSE);
      SendMessageToPC(oPC, "<cþ>Advertencia: <cþ<<>Es posible que tengas que examinar o mover de sitio el objeto para que el nuevo nombre se visualice correctamente.</c></c>");
  }

  // Editar descripcion (notas)
  else if(iModoEscritura == 2)
  {
      // Guardamos el anterior estado
      SetLocalString(oEscritoGuardado, "ESC_ANTERIORCAMBIO", sDescripcionEscritoGuardado);

      // Miramos si la descripcion del objeto ya se modifico o no
      if(GetLocalInt(oEscritoGuardado, "ESC_USADO") == TRUE) sEscrito = sDescripcionEscritoGuardado + " " + sEscrito;
      else
      {
          sEscrito = " " + sEscrito;
          SetLocalInt(oEscritoGuardado, "ESC_USADO", TRUE);
      }

      SetDescription(oEscritoGuardado, sEscrito);
      FloatingTextStringOnCreature("<c´þd>* Escribes en el papel con tu pluma lentamente *</c>", oPC, FALSE);
      SendMessageToPC(oPC, "<c›þþ>Texto añadido a la descripción: <cßþ>" + sTextoHablado + "</c></c>");
  }

  // Editar descripcion (PJ)
  else if(iModoEscritura == 3)
  {
      // Guardamos el anterior estado
      SetLocalString(oPC, "DSCPJ_ANTERIORCAMBIO", sDescripcionPJ);

      // Miramos si la descripcion del jugador ya se modifico o no
      if(sDescripcionPJ != "") sEscrito = sDescripcionPJ + " " + sEscrito;
      else sEscrito = " " + sEscrito;

      SetDescription(oPC, sEscrito);
      FloatingTextStringOnCreature("<c´þd>* Añades nuevas frases a la descripción de tu PJ *</c>", oPC, FALSE);
      SendMessageToPC(oPC, "<c›þþ>Texto añadido a la descripción: <cßþ>" + sTextoHablado + "</c></c>");
  }

  // Editar retrato (PJ)
  else if(iModoEscritura == 4)
  {
      SetPortraitResRef(oPC, sTextoHablado);
      SendMessageToPC(oPC, "<ceî´>Aplicado retrato: " + sTextoHablado + ".</c>");
  }
  // Editar apariencia de ubicado.
  else if(iModoEscritura == 5)
  {
      object oUbicado = GetLocalObject(oPC, "DM_PAA_oTarget");
      NWNX_Object_SetAppearance(oUbicado, StringToInt(sTextoHablado));
      //Le ponemos el nombre para que lo pueda detectar la peonza.
      SetName(oUbicado, "DMAPA_"+sTextoHablado);
      object oUbicadoNuevo = CopyObject(oUbicado, GetLocation(oUbicado),OBJECT_INVALID,GetTag(oUbicado),TRUE);
      DestroyObject(oUbicado);
      SetLocalObject(oPC, "DM_PAA_oTarget", oUbicadoNuevo);
      SendMessageToPC(oPC, "<ceî´>Aplicada apariencia: " + sTextoHablado + ".</c>");
  }
}
//void main(){}
