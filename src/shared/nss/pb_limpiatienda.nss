#include "inc_sqlite_time"

void main()
{
    int Ind_Limpia = GetLocalInt(OBJECT_SELF, "Ind_Limpieza");
    int iHora = GetTimeHour();
    int iLimpiezaHora = GetLocalInt(OBJECT_SELF, "Ind_Limpieza");

    //Si no son horas de cierre y no se ha limpiado la tienda...
    if ((iHora != 4 && iHora != 3) && (SQLite_GetTimeStamp() > iLimpiezaHora))
    {
        //Las tiendas se resetearán como lo hacían antes, cada "día" (24 horas antaño son 72 minutos).
        SetLocalInt(OBJECT_SELF, "Ind_Limpieza", SQLite_GetTimeStamp() + 4320);

        //Limpiamos la tienda.
        object oCurrentItem = GetFirstItemInInventory();
        int iPCItem;

        while(oCurrentItem != OBJECT_INVALID)
        {

            iPCItem = GetLocalInt(oCurrentItem, "PCItem");  //Objeto obtenido por jugador
            if (iPCItem==1) { DestroyObject(oCurrentItem);}
            oCurrentItem = GetNextItemInInventory();
        }
    }
}
