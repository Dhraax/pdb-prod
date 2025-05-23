// ABRE LA TIENDA MAS CERCANA QUE TIENE LA MISMA ETIQUETA QUE EL VENDEDOR
#include "nw_i0_plot"
void main()
{
  object oPC = GetPCSpeaker();
  object oPNJ = OBJECT_SELF;
  string sEtiquetaDelPNJ = GetTag(oPNJ);
  object oTienda = GetNearestObjectByTag(sEtiquetaDelPNJ);

  //Abrir la tienda con el sistema del SOU de tasaccion
  gplotAppraiseOpenStore(oTienda, oPC);
}
