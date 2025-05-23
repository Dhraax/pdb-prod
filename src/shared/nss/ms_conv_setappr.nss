#include "pb_constantes"
void main()
{
    object oPC = GetPCSpeaker();
    int iRaza = GetRacialType(oPC);
    int iModo = StringToInt(GetScriptParam("Modo"));
    int iOpcion = GetLocalInt(oPC,"ApaRazaOpcion");
    int iApa;


    if(iRaza == RACIAL_TYPE_GNOLL)
    {
        if(iModo == 1)
        {
            if(iOpcion == 0){iApa = 388;}
            else if(iOpcion == 1){iApa = 389;}
            iOpcion = iOpcion + 1;
            //Maximo, volvemos al inicio.
            if(iOpcion > 2){iOpcion = 0; iApa = 388;}
            SetLocalInt(oPC,"ApaRazaOpcion", iOpcion);
        }
        if(iModo == 2)
        {
            if(iOpcion == 0){iApa = 388;}
            else if(iOpcion == 1){iApa = 389;}
            iOpcion = iOpcion - 1;
            //Maximo, volvemos al inicio.
            if(iOpcion < 0){iOpcion = 2; iApa = 389;}
            SetLocalInt(oPC,"ApaRazaOpcion", iOpcion);
        }
    }
    if(iRaza == RACIAL_TYPE_GRAN_TRASGO)
    {
        if(iModo == 1)
        {
            if(iOpcion == 0){iApa = 390;}
            else if(iOpcion == 1){iApa = 391;}
            iOpcion = iOpcion + 1;
            //Maximo, volvemos al inicio.
            if(iOpcion > 2){iOpcion = 0; iApa = 390;}
            SetLocalInt(oPC,"ApaRazaOpcion", iOpcion);
        }
        if(iModo == 2)
        {
            if(iOpcion == 0){iApa = 390;}
            else if(iOpcion == 1){iApa = 391;}
            iOpcion = iOpcion - 1;
            //Maximo, volvemos al inicio.
            if(iOpcion < 0){iOpcion = 2; iApa = 391;}
            SetLocalInt(oPC,"ApaRazaOpcion", iOpcion);
        }
    }
    if(iRaza == RACIAL_TYPE_KOBOLD)
    {
        if(iModo == 1)
        {
            if(iOpcion == 0){iApa = 302;}
            else if(iOpcion == 1){iApa = 305;}
            else if(iOpcion == 2){iApa = 300;}
            else if(iOpcion == 3){iApa = 303;}
            else if(iOpcion == 4){iApa = 301;}
            else if(iOpcion == 5){iApa = 304;}
            else if(iOpcion == 6){iApa = 2166;}
            else if(iOpcion == 7){iApa = 2164;}
            else if(iOpcion == 8){iApa = 2165;}
            else if(iOpcion == 9){iApa = 3;}
            iOpcion = iOpcion + 1;
            //Maximo, volvemos al inicio.
            if(iOpcion > 8){iOpcion = 0; iApa = 302;}
            SetLocalInt(oPC,"ApaRazaOpcion", iOpcion);
        }
        if(iModo == 2)
        {
            if(iOpcion == 0){iApa = 302;}
            else if(iOpcion == 1){iApa = 305;}
            else if(iOpcion == 2){iApa = 300;}
            else if(iOpcion == 3){iApa = 303;}
            else if(iOpcion == 4){iApa = 301;}
            else if(iOpcion == 5){iApa = 304;}
            else if(iOpcion == 6){iApa = 2166;}
            else if(iOpcion == 7){iApa = 2164;}
            else if(iOpcion == 8){iApa = 2165;}
            else if(iOpcion == 9){iApa = 3;}
            iOpcion = iOpcion - 1;
            //Maximo, volvemos al inicio.
            if(iOpcion < 0){iOpcion = 9; iApa = 3;}
            SetLocalInt(oPC,"ApaRazaOpcion", iOpcion);
        }
    }
    if(iRaza == RACIAL_TYPE_MINOTAURO)
    {
        if(iModo == 1)
        {
            if(iOpcion == 0){iApa = 120;}
            else if(iOpcion == 1){iApa = 121;}
            else if(iOpcion == 2){iApa = 122;}
            else if(iOpcion == 3){iApa = 1266;}
            iOpcion = iOpcion + 1;
            //Maximo, volvemos al inicio.
            if(iOpcion > 3){iOpcion = 0; iApa = 120;}
            SetLocalInt(oPC,"ApaRazaOpcion", iOpcion);
        }
        if(iModo == 2)
        {
            if(iOpcion == 0){iApa = 120;}
            else if(iOpcion == 1){iApa = 121;}
            else if(iOpcion == 2){iApa = 122;}
            else if(iOpcion == 3){iApa = 1266;}
            iOpcion = iOpcion - 1;
            //Maximo, volvemos al inicio.
            if(iOpcion < 0){iOpcion = 3; iApa = 1266;}
            SetLocalInt(oPC,"ApaRazaOpcion", iOpcion);
        }
    }
    if(iRaza == RACIAL_TYPE_ORCO_MONTANA)
    {
        if(iModo == 1)
        {
            if(iOpcion == 0){iApa = 136;}
            else if(iOpcion == 1){iApa = 137;}
            else if(iOpcion == 2){iApa = 138;}
            else if(iOpcion == 3){iApa = 139;}
            else if(iOpcion == 4){iApa = 140;}
            else if(iOpcion == 5){iApa = 141;}
            iOpcion = iOpcion + 1;
            //Maximo, volvemos al inicio.
            if(iOpcion > 5){iOpcion = 0; iApa = 136;}
            SetLocalInt(oPC,"ApaRazaOpcion", iOpcion);
        }
        if(iModo == 2)
        {
            if(iOpcion == 0){iApa = 136;}
            else if(iOpcion == 1){iApa = 137;}
            else if(iOpcion == 2){iApa = 138;}
            else if(iOpcion == 3){iApa = 139;}
            else if(iOpcion == 4){iApa = 140;}
            else if(iOpcion == 5){iApa = 141;}
            iOpcion = iOpcion - 1;
            //Maximo, volvemos al inicio.
            if(iOpcion < 0){iOpcion = 5; iApa = 141;}
            SetLocalInt(oPC,"ApaRazaOpcion", iOpcion);
        }
    }
    if(iRaza == RACIAL_TYPE_OSGO)
    {
        if(iModo == 1)
        {
            if(iOpcion == 0){iApa = 2239;}
            else if(iOpcion == 1){iApa = 2241;}
            else if(iOpcion == 2){iApa = 2242;}
            else if(iOpcion == 3){iApa = 2243;}
            else if(iOpcion == 4){iApa = 2583;}
            else if(iOpcion == 5){iApa = 2584;}
            else if(iOpcion == 6){iApa = 29;}
            else if(iOpcion == 7){iApa = 30;}
            else if(iOpcion == 8){iApa = 25;}
            else if(iOpcion == 9){iApa = 26;}
            else if(iOpcion == 10){iApa = 27;}
            else if(iOpcion == 11){iApa = 28;}
            else if(iOpcion == 12){iApa = 2238;}
            else if(iOpcion == 13){iApa = 2240;}
            iOpcion = iOpcion + 1;
            //Maximo, volvemos al inicio.
            if(iOpcion > 13){iOpcion = 0; iApa = 2239;}
            SetLocalInt(oPC,"ApaRazaOpcion", iOpcion);
        }
        if(iModo == 2)
        {
            if(iOpcion == 0){iApa = 2239;}
            else if(iOpcion == 1){iApa = 2241;}
            else if(iOpcion == 2){iApa = 2242;}
            else if(iOpcion == 3){iApa = 2243;}
            else if(iOpcion == 4){iApa = 2583;}
            else if(iOpcion == 5){iApa = 2584;}
            else if(iOpcion == 6){iApa = 29;}
            else if(iOpcion == 7){iApa = 30;}
            else if(iOpcion == 8){iApa = 25;}
            else if(iOpcion == 9){iApa = 26;}
            else if(iOpcion == 10){iApa = 27;}
            else if(iOpcion == 11){iApa = 28;}
            else if(iOpcion == 12){iApa = 2238;}
            else if(iOpcion == 13){iApa = 2240;}
            iOpcion = iOpcion - 1;
            //Maximo, volvemos al inicio.
            if(iOpcion < 0){iOpcion = 13; iApa = 2240;}
            SetLocalInt(oPC,"ApaRazaOpcion", iOpcion);
        }
    }
    if(iRaza == RACIAL_TYPE_TRASGO)
    {
        if(iModo == 1)
        {
            if(iOpcion == 0){iApa = 82;}
            else if(iOpcion == 1){iApa = 83;}
            else if(iOpcion == 2){iApa = 84;}
            else if(iOpcion == 3){iApa = 85;}
            else if(iOpcion == 4){iApa = 86;}
            else if(iOpcion == 5){iApa = 87;}
            else if(iOpcion == 6){iApa = 2;}
            iOpcion = iOpcion + 1;
            //Maximo, volvemos al inicio.
            if(iOpcion > 5){iOpcion = 0; iApa = 82;}
            SetLocalInt(oPC,"ApaRazaOpcion", iOpcion);
        }
        if(iModo == 2)
        {
            if(iOpcion == 0){iApa = 82;}
            else if(iOpcion == 1){iApa = 83;}
            else if(iOpcion == 2){iApa = 84;}
            else if(iOpcion == 3){iApa = 85;}
            else if(iOpcion == 4){iApa = 86;}
            else if(iOpcion == 5){iApa = 87;}
            else if(iOpcion == 6){iApa = 2;}
            iOpcion = iOpcion - 1;
            //Maximo, volvemos al inicio.
            if(iOpcion < 0){iOpcion = 6; iApa = 2;}
            SetLocalInt(oPC,"ApaRazaOpcion", iOpcion);
        }
    }
    if(iRaza == RACIAL_TYPE_KENKU)
    {
        if(iModo == 1)
        {
            if(iOpcion == 0){iApa = 906;}
            else if(iOpcion == 1){iApa = 907;}
            else if(iOpcion == 2){iApa = 2516;}
            else if(iOpcion == 3){iApa = 2517;}
            else if(iOpcion == 4){iApa = 2518;}
            else if(iOpcion == 5){iApa = 2519;}
            else if(iOpcion == 6){iApa = 3;}
            iOpcion = iOpcion + 1;
            //Maximo, volvemos al inicio.
            if(iOpcion > 5){iOpcion = 0; iApa = 906;}
            SetLocalInt(oPC,"ApaRazaOpcion", iOpcion);
        }
        if(iModo == 2)
        {
            if(iOpcion == 0){iApa = 906;}
            else if(iOpcion == 1){iApa = 907;}
            else if(iOpcion == 2){iApa = 2516;}
            else if(iOpcion == 3){iApa = 2517;}
            else if(iOpcion == 4){iApa = 2518;}
            else if(iOpcion == 5){iApa = 2519;}
            else if(iOpcion == 6){iApa = 3;}
            iOpcion = iOpcion - 1;
            //Maximo, volvemos al inicio.
            if(iOpcion < 0){iOpcion = 6; iApa = 3;}
            SetLocalInt(oPC,"ApaRazaOpcion", iOpcion);
        }
    }
    SetCreatureAppearanceType(oPC, iApa);
}
