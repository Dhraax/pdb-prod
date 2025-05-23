#include "meteo_library"
void main()
{
    int inum=3;
    object oPC =GetPCSpeaker();
    SendMessageToPC(oPC, "Has modificado el clima en Amn Centro-Sur a soleado.");
    Guardar_VarClimaticas(inum,0,0);
    object oArea = GetFirstArea();
    while (oArea != OBJECT_INVALID)
    {
        if (GetLocalInt(oArea,"ZONA_CLIMA")==inum)
        {

            if (GetLocalInt(oArea,"CAMB_CLIMA")==1)
            {
                SetLocalInt(oArea, "CAMB_CLIMA", 0);
            }
        }
        oArea= GetNextArea();
    }

    Obtener_Clima(inum,GetArea(oPC),oPC);
}
