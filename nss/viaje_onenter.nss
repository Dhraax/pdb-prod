/////////////////////////////////////////////////
// viaje_onenter
////////////////////////////////////////////////
/*
Utilizado para áreas de encuentro aleatorio
Se debe poner en el OnEnter del area de encuentro
*/

#include "viaje_enc_table"

void main()
{
    object oPC = GetEnteringObject();
    int nTileSet = GetLocalInt(oPC, "TileSet");

    //Generamos el encuentro según zona
 GenerarEncuentroViaje(nTileSet, OBJECT_SELF, oPC);
}
