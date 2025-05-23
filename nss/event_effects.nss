#include "nwnx_events"
#include "x0_i0_match"
#include "mti_libreria"

void main()
{
    string sCurrentEvent = NWNX_Events_GetCurrentEvent();
    object oCreador = StringToObject(NWNX_Events_GetEventData("CREATOR"));
    object oPC = OBJECT_SELF;
    int iConjuro = StringToInt(NWNX_Events_GetEventData("SPELL_ID"));

    if (sCurrentEvent == "NWNX_ON_EFFECT_REMOVED_AFTER")
    {
        //Artífice:
        //Tamaño y color de la Infusión del Berserker vuelve al eliminarse el efecto.
        if(iConjuro == 1421)
        {
            //Cambios de tamaño.
            if (ObtenerIntPersistente(oPC, "CAB_ALTURA")==TRUE)
            {
                float fAltura = ObtenerFloatPersistente(oPC, "IND_ALTURA");
                SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, fAltura);
                int ColorPiel =  ObtenerIntPersistente(oPC,"BerserkerColorPiel");
                SetColor(oPC, COLOR_CHANNEL_SKIN, ColorPiel);
            }
            // Con el cambio de altura del ingeniero, por si caso, aquellos PJs que no tienen seteada ninguna altura, los ponemos a 1.0.
            else if (ObtenerIntPersistente(oPC, "CAB_ALTURA")==FALSE)
            {
                SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, 1.0);
                int ColorPiel =  ObtenerIntPersistente(oPC,"BerserkerColorPiel");
                SetColor(oPC, COLOR_CHANNEL_SKIN, ColorPiel);
            }
            DeleteLocalInt(oPC,"CLS_ING_ELIXIRBERS");
        }

    }
}
