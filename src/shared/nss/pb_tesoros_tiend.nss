//::////////////////////////////////////////////////////////////////////////////
//:: PUERTA DE BALDUR I (www.puertadebaldur.net)
//:: SCRIPT: Tesoro en tiendas.
//:: Creado por: Monti
//:: Creado el: 02/10/2013
//::////////////////////////////////////////////////////////////////////////////

#include "pb_tesoros_inc"

void main()
{
  // Solo desencadenado por jugadores
  if(!GetIsPC(GetEnteringObject())) return;

  // Solo una vez
  if(GetLocalInt(OBJECT_SELF, "TES_SPAM")) return;
  SetLocalInt(OBJECT_SELF, "TES_SPAM", TRUE);

  // Buscamos la tienda definida, si no se encuentra el script no sigue
  string sTienda = GetLocalString(OBJECT_SELF, "TES_ETIQUETA_TIENDA");
  object oTienda = GetNearestObjectByTag(sTienda);
  if(GetObjectType(oTienda) == OBJECT_TYPE_CREATURE) oTienda = GetNearestObjectByTag(sTienda, OBJECT_SELF, 2);
  if(GetObjectType(oTienda) != OBJECT_TYPE_STORE) return;

  int iLote = 1;
  int iTipoDeObjeto, iCantidadFija, iCantidadAleatoria, iInfinito, iCalidad, iCantidadTotal;

  while(GetLocalInt(OBJECT_SELF, IntToString(iLote) + "TES_TIPO_OBJETO") != 0)
  {
      // Obtenemos los datos del lote a crear
      iTipoDeObjeto      = GetLocalInt(OBJECT_SELF, IntToString(iLote) + "TES_TIPO_OBJETO");
      iCantidadFija      = GetLocalInt(OBJECT_SELF, IntToString(iLote) + "TES_CANTIDAD_FIJA");
      iCantidadAleatoria = GetLocalInt(OBJECT_SELF, IntToString(iLote) + "TES_CANTIDAD_ALEATORIA");
      //iInfinito          = GetLocalInt(OBJECT_SELF, IntToString(iLote) + "TES_INFINITO");
      iCalidad           = GetLocalInt(OBJECT_SELF, IntToString(iLote) + "TES_CALIDAD");

      if(iTipoDeObjeto < 1 || iTipoDeObjeto > 12) iTipoDeObjeto = 2;
      if(iCantidadFija == 0) iCantidadFija = 5;
      if(iCantidadAleatoria != 0) iCantidadAleatoria = Random(iCantidadAleatoria)+1;

      // Creamos los objetos
      iCantidadTotal = iCantidadFija + iCantidadAleatoria;
      while(iCantidadTotal > 0)
      {
          switch(iTipoDeObjeto)
          {
              case 1: CrearArmadura(oTienda, iCalidad, TRUE); break;
              case 2: CrearArmaCuerpo(oTienda, iCalidad, TRUE); break;
              case 3: CrearArmaDistancia(oTienda, iCalidad, TRUE); break;
              case 4: CrearMunicion(oTienda, iCalidad, TRUE); break;
              case 5: CrearBastonesMagicos(oTienda, iCalidad, TRUE); break;
              case 6: CrearVaritasCetros(oTienda, iCalidad, TRUE); break;
              case 7: CrearGuanteletesMonje(oTienda, iCalidad, TRUE); break;
              case 8: CrearPergamino(oTienda, iCalidad, TRUE); break;
              case 9: CrearGemas(oTienda, iCalidad, TRUE); break;
              case 10: CrearBasura(oTienda, iCalidad, TRUE); break;
              case 11: CrearMiscelanea(oTienda, iCalidad, TRUE); break;
              case 12: CrearPocion(oTienda, iCalidad, TRUE); break;
          }

          iCantidadTotal = iCantidadTotal - 1;
      }

      iLote = iLote + 1;
  }
}
