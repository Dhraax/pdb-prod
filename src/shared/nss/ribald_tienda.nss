#include "nw_i0_plot"
void main()
{
object oPC = GetPCSpeaker();
object oTienda = GetObjectByTag("Ribald");

if(GetGold(oPC) >= 1000)
{
    AssignCommand(oPC, TakeGoldFromCreature(1000, oPC, TRUE));
    gplotAppraiseOpenStore(oTienda, oPC, 0, 0);
}

else
{
    SendMessageToPC(oPC, "¡No trates de engañarme! No tienes el dinero.");
}
}
