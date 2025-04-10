#include "nw_i0_plot"
void main()
{
object oPC = GetPCSpeaker();
object oTienda = GetNearestObjectByTag("cervezas");

//Abrir la tienda con el sistema del SOU de tasaccion
gplotAppraiseOpenStore(oTienda, oPC, 0, 0);
}
