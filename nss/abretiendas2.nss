// ABRE LA TIENDA DEFINIDA EN UNA VARIABLE DEL PNJ

#include "nw_i0_plot"

void main()
{
  object oPC = GetPCSpeaker();
  object oPNJ = OBJECT_SELF;
  string sTienda = GetLocalString(OBJECT_SELF, "TIENDA");
  object oTienda = GetObjectByTag(sTienda);

  //Abrir la tienda con el sistema del SOU de tasaccion
  gplotAppraiseOpenStore(oTienda, oPC);
}
