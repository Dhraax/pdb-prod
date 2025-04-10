#include "mti_libreria"
void main()
{
    object oPC = GetPCSpeaker();
    int iActivado = ObtenerIntPersistente(oPC, "EntradaySalidaAviso");

    if(iActivado == 0)
    {
        GuardarIntPersistente(oPC, "EntradaySalidaAviso", 1);
        SendMessageToPC(oPC,ColorTexto("Desactivas el aviso de tu conexión a otros jugadores.",TXT_COLOR_ROJO));
    }
    if(iActivado == 1)
    {
        GuardarIntPersistente(oPC, "EntradaySalidaAviso", 0);
        SendMessageToPC(oPC,ColorTexto("Activas el aviso de tu conexión a otros jugadores.",TXT_COLOR_VERDE));
    }
}


