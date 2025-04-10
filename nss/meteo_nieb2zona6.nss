#include "meteo_library"
void main()
{
    object oMod = GetModule();
    int inum=6, iNiebla = 15;
    string sLluvia= "Lluvia" + IntToString(inum), sNieve = "Nieve" + IntToString(inum);
    object oPC =GetPCSpeaker();
    SendMessageToPC(oPC, "Has modificado la niebla en el Bosque de Tezhyr a 7,5%.");
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
