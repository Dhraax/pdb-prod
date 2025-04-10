#include "mti_libreria"
#include "inc_spells"
void main()
{
    object oPC = GetPCSpeaker();
    int iActivado = ObtenerIntPersistente(oPC, "Chat_Burbuja");

    if(iActivado == 0)
    {
        GuardarIntPersistente(oPC, "Chat_Burbuja", 1);
        SendMessageToPC(oPC,ColorTexto("Desactivas el efecto visual al escribir en el chat.",TXT_COLOR_ROJO));
        PJ_EfectoQuitarTag(oPC, "VFX_DUR_CHAT_BUBBLE");
    }
    if(iActivado == 1)
    {
        GuardarIntPersistente(oPC, "Chat_Burbuja", 0);
        SendMessageToPC(oPC,ColorTexto("Activas el efecto visual al escribir en el chat.",TXT_COLOR_VERDE));
    }
}



