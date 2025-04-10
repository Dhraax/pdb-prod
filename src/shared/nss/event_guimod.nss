#include "inc_spells"
#include "mti_libreria"
#include "pb_constantes"

void main()
{
    int nGuiEvent    = GetLastGuiEventType();
    object oPC       = GetLastGuiEventPlayer();

    switch ( nGuiEvent )
    {
        //Activamos el chat.
        case GUIEVENT_CHATBAR_FOCUS:
        {
            if(ObtenerIntPersistente(oPC,"Chat_Burbuja") != TRUE)
            {
                //Siempre removemos el efecto por si acaso
                PJ_EfectoQuitarTag(oPC, "VFX_DUR_CHAT_BUBBLE");
                //Damos el efecto
                effect eEfecto = EffectVisualEffect(VFX_DUR_CHAT_BUBBLE, FALSE, 0.6f,[0.0,0.0,0.2]);
                eEfecto = UnyieldingEffect(eEfecto);
                eEfecto = TagEffect(eEfecto, "VFX_DUR_CHAT_BUBBLE");
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEfecto, oPC);
            }
            break;
        }
        //Desactivamos el chat.
        case GUIEVENT_CHATBAR_UNFOCUS:
        {
            if(ObtenerIntPersistente(oPC,"Chat_Burbuja") != TRUE)
            {
                PJ_EfectoQuitarTag(oPC, "VFX_DUR_CHAT_BUBBLE");
            }
            break;
        }
    }
}
