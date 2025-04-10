#include "mti_libreria"
void main()
{
    object oPC  = GetPCSpeaker();
    if (GetPhenoType(oPC) == 40 || GetPhenoType(oPC) == 41 || GetPhenoType(oPC) == 42 || GetPhenoType(oPC) == 43 || GetPhenoType(oPC) == 44 || GetPhenoType(oPC) == 45 || GetPhenoType(oPC) == 46 || GetPhenoType(oPC) == 47 || GetPhenoType(oPC) == 48 || GetPhenoType(oPC) == 49 || GetPhenoType(oPC) == 50|| GetPhenoType(oPC) == 51)
    {
        SetPhenoType(0, oPC);
    }


    else if (GetPhenoType(oPC) == 61 || GetPhenoType(oPC) == 62 || GetPhenoType(oPC) == 63 || GetPhenoType(oPC) == 64 || GetPhenoType(oPC) == 65 || GetPhenoType(oPC) == 66 || GetPhenoType(oPC) == 67 || GetPhenoType(oPC) == 68 || GetPhenoType(oPC) == 69 || GetPhenoType(oPC) == 70|| GetPhenoType(oPC) == 71 || GetPhenoType(oPC) == 72)
    {

        SetPhenoType(2, oPC);
    }
    SendMessageToPC(oPC, "Desactivado estilo de lucha.");
    int nCambAlt = ObtenerIntPersistente(oPC, "CAB_ALTURA");
    if (nCambAlt ==TRUE)
    {
            float fAltura = ObtenerFloatPersistente(oPC, "IND_ALTURA");
            SetObjectVisualTransform (oPC, OBJECT_VISUAL_TRANSFORM_SCALE, fAltura);
    }
}
