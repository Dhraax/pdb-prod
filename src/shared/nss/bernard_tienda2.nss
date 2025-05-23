#include "nw_i0_plot"
void main()
{

object oPC = GetPCSpeaker();
object oTienda = GetObjectByTag("tienda_equipo_basico_2");

gplotAppraiseOpenStore(oTienda, oPC, -10, 6);
}
