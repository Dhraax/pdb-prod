float Comisiones_Ingresos(int nDeposito, int nBalance, int nVoz=FALSE)
{
    float fComision =0.00;
    int nMontante = nDeposito + nBalance;
    if (nVoz==FALSE)
    {

             if (nMontante <= 10000)    { fComision = 0.005;}
        else if (nMontante <= 50000)    { fComision = 0.01;}
        else if (nMontante <= 100000)   { fComision = 0.02;}
        else if (nMontante <= 300000)   { fComision = 0.04;}
        else if (nMontante <= 600000)   { fComision = 0.08;}
        else if (nMontante <= 1200000)  { fComision = 0.16;}
        else if (nMontante <= 1800000)  { fComision = 0.24;}
        else if (nMontante <= 2400000)  { fComision = 0.32;}
        else if (nMontante <= 3000000)  { fComision = 0.4;}
        else if (nMontante <= 3600000)  { fComision = 0.48;}
        else if (nMontante <= 4200000)  { fComision = 0.56;}
        else if (nMontante <= 4800000)  { fComision = 0.64;}
        else if (nMontante <= 5400000)  { fComision = 0.72;}
        else if (nMontante <= 6000000)  { fComision = 0.8;}
        else { fComision = 0.8;}

             /*if (nDeposito >0 && nDeposito < 50000) { fComision = fComision + 0.05;}
        else if { fComision =  fComision + 0.1;}    */

    }
    else
    {


             if (nMontante <= 10000)    { fComision = 0.005;}
        else if (nMontante <= 50000)    { fComision = 0.01;}
        else if (nMontante <= 100000)   { fComision = 0.02;}
        else if (nMontante <= 300000)   { fComision = 0.04;}
        else if (nMontante <= 600000)   { fComision = 0.08;}
        else if (nMontante <= 1200000)  { fComision = 0.16;}
        else if (nMontante <= 1800000)  { fComision = 0.24;}
        else if (nMontante <= 2400000)  { fComision = 0.32;}
        else if (nMontante <= 3000000)  { fComision = 0.4;}
        else if (nMontante <= 3600000)  { fComision = 0.48;}
        else if (nMontante <= 4200000)  { fComision = 0.56;}
        else if (nMontante <= 4800000)  { fComision = 0.64;}
        else if (nMontante <= 5400000)  { fComision = 0.72;}
        else if (nMontante <= 6000000)  { fComision = 0.8;}
        else { fComision = 0.8;}

        /*int iCont = 0; //Contador para saber cuantos montones de 50.000 po
        if (nDeposito >= 50000)
        {
            iCont = nDeposito/50000;
            fComision = fComision + (IntToFloat(iCont)*0.01);
            iCont = nDeposito - (iCont*50000);
            if (iCont>0 && iCont<50000) { fComision = fComision + 0.005;}

        } */

    }
    if (fComision > 0.8) { fComision = 0.8;}
    return fComision;
}



float Comisiones_Sacar(int nVoz=FALSE)

{

    float fComision =0.00;
    if (nVoz==FALSE)
    {
        fComision = 0.05;
    }
    else
    {
       fComision = 0.01;
    }
    return fComision;
}
