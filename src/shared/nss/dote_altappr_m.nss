#include "mti_libreria"
void main()
{
    string sFunction = GetScriptParam("FUNCTION");

    if (sFunction == "") {
        if (!GetIsPC(OBJECT_SELF)) return;
        AssignCommand(OBJECT_SELF, ActionStartConversation(OBJECT_SELF, "dote_altaspecto", TRUE, FALSE));

        return;
    }

    object oPC = GetPCSpeaker();
    if (sFunction == "ChangeAppearance")
    {
        int nAppearance = StringToInt(GetScriptParam("APPEARANCE"));
        //Ahora que están los Ogros Hechiceros y demases, hacemos pequeños cambios.
        //Para evitar apariencias gigantes (por ejemplo al usar la dote un Ogro Hechicero).
        if (ObtenerIntPersistente(oPC, "CAB_ALTURA")==TRUE)     //Cargamos si tiene el tamaño guardado.
        {
            float fAltura = ObtenerFloatPersistente(oPC, "IND_ALTURA");     //Leemos el tamaño original.
            if(ObtenerIntPersistente(oPC, "APTITUD_POLY_RAZA") == FALSE)    //No estamos poliformados.
            {
                GuardarIntPersistente(oPC, "APTITUD_POLY_RAZA_APARIENCIA", GetAppearanceType(oPC)); //Guardamos la apariencia original.
                SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, 1.0);  //Aplicamos escala 1.0.
                GuardarIntPersistente(oPC, "APTITUD_POLY_RAZA", 1);     //Guardamos la variable de poliformado.
                SetCreatureAppearanceType(oPC, nAppearance);    //Aplicamos la apariencia deseada.
                GuardarIntPersistente(oPC, "APTITUD_POLY_RAZA_ORIGINAL", GetRacialType(oPC)); //Guardamos la raza original.
            }
            else if(ObtenerIntPersistente(oPC, "APTITUD_POLY_RAZA") == TRUE)    //Estamos poliformados.
            {
                SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, fAltura);  //Aplicamos la altura original.
                BorrarIntPersistente(oPC, "APTITUD_POLY_RAZA");     //Borramos la variable de poliformar.
                SetCreatureAppearanceType(oPC, ObtenerIntPersistente(oPC, "APTITUD_POLY_RAZA_APARIENCIA"));    //Aplicamos la apariencia original.
                BorrarIntPersistente(oPC, "APTITUD_POLY_RAZA_APARIENCIA");     //Borramos la variable de la apariencia original.
                BorrarIntPersistente(oPC, "APTITUD_POLY_RAZA_ORIGINAL");     //Borramos la variable de la raza original.
            }
        }
        else if (ObtenerIntPersistente(oPC, "CAB_ALTURA")==FALSE)
        {
            SendMessageToPC(oPC,ColorTexto("Por favor, acude a un maniquí y haz un cambio de tamaño (aunque mantengas el mismo tamaño actual), para que el sistema funcione correctamente.",TXT_COLOR_ROJO));
            return;
        }
    }
    else if (sFunction == "ShowWings")
    {
        object oPC = GetPCSpeaker();
        SetCreatureWingType(19, oPC);
    }
    else if (sFunction == "HideWings")
    {
        object oPC = GetPCSpeaker();
        SetCreatureWingType(CREATURE_WING_TYPE_NONE, oPC);
    }

    effect eSuspiro = EffectVisualEffect(36);`
    effect eLuz = EffectVisualEffect(146);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eSuspiro, oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eLuz, oPC);
}
