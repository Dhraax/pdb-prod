#include "meteo_library"
void main()
{
    int inum=6;
    int iNieva=1;
    object oPC =GetPCSpeaker();
    SendMessageToPC(oPC, "Has modificado el clima en el Bosque de Tezhyr a nevado.");
     Guardar_VarClimaticas(inum,0,iNieva);
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
