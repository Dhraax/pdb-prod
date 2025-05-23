    //::////////////////////////////////////////////////////////////////////////////
//:: PUERTA DE BALDUR I (www.puertadebaldur.net)
//:: SCRIPT: Tesoro en ubicados.
//:: Creado por: Monti
//:: Creado el: 20/09/2011
//::////////////////////////////////////////////////////////////////////////////

#include "pb_tesoros_inc"

void main()
{
  int iCalidad = 1;
  switch(GetLocalInt(OBJECT_SELF, "TIPOTESORO"))
  {
      case 1: iCalidad = 1; break;
      case 2: iCalidad = 1; break;
      case 3: iCalidad = 1; break;

  }

  GenerarTesoroEnUbicados(GetLastOpenedBy(), iCalidad);
}

