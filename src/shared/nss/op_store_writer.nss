 #include "nw_i0_plot"

void main() {
    object oPC = GetPCSpeaker();
    object oTienda = GetObjectByTag("tienda_escritura");

    gplotAppraiseOpenStore(oTienda, oPC);
}
