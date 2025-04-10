#include "meteo_library"
void main()
{
    int inum=5;
    int iLluvia=1;
    object oPC =GetPCSpeaker();
    SendMessageToPC(oPC, "Has modificado el clima en el Valle de Minsor a lluvioso.");
    Guardar_VarClimaticas(inum, iLluvia);
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
