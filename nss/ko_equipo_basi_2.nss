 #include "nw_i0_plot"
void main()
{

    object oPC = GetPCSpeaker();
    object oTienda = GetObjectByTag("tienda_equipo_basico_2");
    int iVarCompra = GetLocalInt(OBJECT_SELF, "Compra"); //Lo que varia cuando el bicho te vende
    int iVarVenta = GetLocalInt(OBJECT_SELF, "Venta"); //Lo que varia cuando el bicho te compra

gplotAppraiseOpenStore(oTienda, oPC, iVarCompra, iVarVenta);
}


