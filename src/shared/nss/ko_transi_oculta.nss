#include "nw_i0_tool"

void main()
{
    object oPersonaje = GetEnteringObject();
    string sLlave1 = GetLocalString (OBJECT_SELF, "Llave1");
    string sLlave2 = GetLocalString (OBJECT_SELF, "Llave2");
    string sDestino = GetLocalString (OBJECT_SELF, "Destino");
    int sAbierta = GetLocalInt (OBJECT_SELF, "Libre");

    if((sAbierta == 1)||HasItem(oPersonaje, sLlave1)||HasItem(oPersonaje, sLlave2))
        {
        object oDestino = GetObjectByTag(sDestino);
        DelayCommand(0.5,AssignCommand(oPersonaje,ActionJumpToLocation(GetLocation(oDestino))));
        }
        return;
}
