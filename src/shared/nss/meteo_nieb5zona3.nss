#include "meteo_library"
void main()
{
    object oMod = GetModule();
    int inum=3, iNiebla = 70;
    string sLluvia= "Lluvia" + IntToString(inum), sNieve = "Nieve" + IntToString(inum);
    object oPC =GetPCSpeaker();
    SendMessageToPC(oPC, "Has modificado la niebla en Amn Centro-Sur a 35%.");
    object oArea = GetFirstArea();
    Guardar_VarClimaticas(inum,GetLocalInt(oMod, sLluvia),GetLocalInt(oMod, sNieve), iNiebla);
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
