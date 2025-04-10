/*
    Script para Puerta de Baldur

    Cuando una tienda se abre hay que comprobar según su horario
    si se limpia de objetos. Después hay que añadir los objetos
    aleatorio según nivel y tipo de tienda.

    Constantes Objetos.

    Según pb_tesoro_boss

        - pb_tesoro_armor

            Armaduras.

             0. Ropas.
             1. Armadura Ligera.
             2. Armaduras Intermedia.
             3. Armaduras Pesadas.

        - pb_tesoro_ccweap

            Armas Cuerpo a Cuerpo.

             0. Espadas largas.
             1. Espadas de dos hojas.
             2. Dagas.
             3. Espadones
             4. Espadas cortas
             5. Espadas bastardas
             6. Cimitarras.
             7. Alfanjes.
             8. Katanas.
             9. Estoques.
            10. Picos.
            11. Tridentes.
            12-17. Hachas.
            18. Alabardas.
            19. Lanzas.
            20. Guadañas.
            21. Clavas.
            22-23. Manguales.
            24-25. Martillos.
            26-27. Mazas.
            28. Mazas de armas.
            29. Bastones.
            30. Hoces.
            31. Kamas.
            32. Kukirs.
            33. Látigos.

            34* Guanteles. crearGuantesMonje - Se genera además una función especial para guantes para monjes.


        - pb_tesoro_diweap

            Armas a Distancia.

             0. Dardos.
             1. Shuriken.
             2. Ballestas.
             3. Arcos.
             4. Hondas.

        - pb_tesoro_escudo

            Escudos.

             0. Escudos pequeños.
             1. Escudos grandes.
             2. Escudos paveses.

        - pb_tesoro_magos

            * Tiene dos funciones especiales una maga Bastones (crearBastonMago) y otras para Cetros o Varas (crearCetrosVaras)
             0. Varitas.
             1. Cetros.

        - pb_tesoro_miscel

             0. Amuletos.
             1. Anillos.
             2. Botas.
             3. Brazaletes.
             4. Capas.
             5. Cinturones.
             6. Yelmos.

        - pb_tesoro_munici

             0. Virotes.
             1. Flechas.
             2. Balas.


*/

#include "pb_tesoro_gold"
#include "pb_tesoro_scroll"
#include "pb_tesoro_potion"
#include "pb_tesoro_ccweap"
#include "pb_tesoro_diweap"
#include "pb_tesoro_munici"
#include "pb_tesoro_magos"
#include "pb_tesoro_escudo"
#include "pb_tesoro_miscel"
#include "pb_tesoro_armor"
#include "inc_sqlite_time"

void IdentificarObjetos()
{
    object oCurrentItem = GetFirstItemInInventory(OBJECT_SELF);
    while(oCurrentItem != OBJECT_INVALID)
    {

        if(GetIdentified(oCurrentItem)==FALSE)
        {
            SetIdentified(oCurrentItem, TRUE);
        }

        oCurrentItem = GetNextItemInInventory(OBJECT_SELF);   //do next item
    }
}

void LimpiarTienda()
{
        object oCurrentItem = GetFirstItemInInventory();
        int iPCItem;

        while(oCurrentItem != OBJECT_INVALID)
        {

            iPCItem = GetLocalInt(oCurrentItem, "PCItem");  //Objeto obtenido por jugador
            if (iPCItem==1) { DestroyObject(oCurrentItem);}
            oCurrentItem = GetNextItemInInventory();
        }
}

void GenerarObjeto_Ale (object oTienda, string sTipo, int iRango)
{
           int nTirada = Random(100);
           int nDG;
           switch (iRango)
           {
                case 0: nDG =8;break;
                case 1: nDG =9;break;
                case 2: nDG=19;break;
                case 3: nDG=29;break;
                case 4: nDG=39;break;
                case 5: nDG=59;break;

                default: nDG =8;break;
           }
           if (sTipo=="GENERAL")
           {

                           if(nTirada <= 12)   DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE));
                      else if(nTirada <= 24)   DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE));
                      else if(nTirada <= 36)   DelayCommand(0.1,crearArmaDI(oTienda, iRango, TRUE));
                      else if(nTirada <= 48)   DelayCommand(0.1,crearMunicion(oTienda, iRango, TRUE));
                      else if(nTirada <= 54)   DelayCommand(0.1,crearBastonMago(oTienda, iRango, TRUE));
                      else if(nTirada <= 66)   DelayCommand(0.1,crearCetrosVaras(oTienda, iRango, TRUE));
                      else if(nTirada <= 72)   DelayCommand(0.1,crearGuantesMonje(oTienda, iRango, TRUE));
                      else if(nTirada <= 78)   DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 0)); // 0.-Amuletos, 1.- Anillos
                      else if(nTirada <= 84)   DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 1));
                      else if(nTirada <= 90)   DelayCommand(0.1,addPotion(oTienda, iRango, TRUE));
                      else if(nTirada <= 94)   DelayCommand(0.1,addGem(oTienda, iRango, TRUE));
                      else if(nTirada <= 100)  DelayCommand(0.1,addScroll(oTienda, nDG, TRUE));
            }
            else if (sTipo=="ARCANA")
            {

                           if(nTirada <= 20)    DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE, FALSE, 0)); // 0.-Ropas, 1.-Armadura Ligera, 2.- Armadura Intermedia, 3.- Armadura Pesada
                      else if(nTirada <= 40)    DelayCommand(0.1,crearBastonMago(oTienda, iRango, TRUE));
                      else if(nTirada <= 50)    DelayCommand(0.1,crearCetrosVaras(oTienda, iRango, TRUE));
                      else if(nTirada <= 80)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 0)); // 0.-Amuletos, 1.- Anillos
                      else if(nTirada <= 90)   DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 1));
                      else if(nTirada <= 100)  DelayCommand(0.1,addScroll(oTienda, nDG, TRUE));

            }
            else if (sTipo=="SASTRE")
            {

                           if(nTirada <= 20)    DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE, FALSE, 0));// 0.-Ropas, 1.-Armadura Ligera, 2.- Armadura Intermedia, 3.- Armadura Pesada
                      else if(nTirada <= 40)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 2)); //Botas
                      else if(nTirada <= 70)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 3));  //Brazaletes
                      else if(nTirada <= 85)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 4)); //Capas
                      else if(nTirada <= 100)   DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 5)); //Cinturones.

            }
            else if (sTipo=="PELETERO")
            {

                           if(nTirada <= 20)   DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 2)); //Botas
                      else if(nTirada <= 40)   DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE, FALSE, 1)); // 0.-Ropas, 1.-Armadura Ligera, 2.- Armadura Intermedia, 3.- Armadura Pesada
                      else if(nTirada <= 60)   DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE, FALSE, 2));
                      else if(nTirada <= 80)   DelayCommand(0.1,crearGuantesMonje(oTienda, iRango, TRUE));
                      else if(nTirada <= 100)  DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 5)); //Cinturones

            }
            else if (sTipo=="CARPINTERO")
            {

                           if(nTirada <= 20)    DelayCommand(0.1,crearArmaDI(oTienda, iRango, TRUE, FALSE, 0)); //0. Ballestas
                      else if(nTirada <= 40)    DelayCommand(0.1,crearArmaDI(oTienda, iRango, TRUE, FALSE, 3)); //3. Arcos
                      else if(nTirada <= 60)    DelayCommand(0.1,crearArmaDI(oTienda, iRango, TRUE));
                      else if(nTirada <= 80)    DelayCommand(0.1,crearMunicion(oTienda, iRango, TRUE));
                      else if(nTirada <= 100)   DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE, FALSE, 29)); // 29. Bastones

            }
            else if (sTipo=="ARMERO")
            {

                      if(nTirada <= 100)         DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE));

            }
            else if (sTipo=="HERRERO")
            {

                           if(nTirada <= 33)    DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE, FALSE, 2)); // 0.-Ropas, 1.-Armadura Ligera, 2.- Armadura Intermedia, 3.- Armadura Pesada
                      else if(nTirada <= 66)    DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE, FALSE, 3));
                      else if(nTirada <= 100)   DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 6));  // Yelmos

            }
            else if (sTipo=="ESCUDERO")
            {

                           if(nTirada <= 33)     DelayCommand(0.1,crearEscudo(oTienda, iRango, TRUE, FALSE, 0)); // 0.-Escudos Pequeños, 1.-Escudos Grandes, 2.-Escudo Paveses.
                      else if(nTirada <= 66)     DelayCommand(0.1,crearEscudo(oTienda, iRango, TRUE, FALSE, 1));
                      else if(nTirada <= 100)    DelayCommand(0.1,crearEscudo(oTienda, iRango, TRUE, FALSE, 2));


            }
            else if (sTipo=="JOYERO")
            {

                           if(nTirada <= 33)     DelayCommand(0.1,addGem(oTienda, iRango, TRUE));
                      else if(nTirada <= 66)     DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 0)); // 0.-Amuletos, 1.- Anillos
                      else if(nTirada <= 100)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 1));

            }
            else if (sTipo=="HONDERO")
            {
                           if(nTirada <= 66)      DelayCommand(0.1,crearArmaDI(oTienda, iRango, TRUE, FALSE, 4)); // 4.-Hondas
                      else if(nTirada <= 100)     DelayCommand(0.1,crearMunicion(oTienda, iRango, TRUE, FALSE, 2)); // 2.-Balas,
            }
            else if (sTipo=="VARITAS")
            {
                           if(nTirada <= 50)     DelayCommand(0.1,crearCetrosVaras(oTienda, iRango, TRUE, FALSE, 0)); // 0.-Varitas
                      else if(nTirada <= 60)     DelayCommand(0.1,addPotion(oTienda, nDG, TRUE));
                      else if(nTirada <= 70)     DelayCommand(0.1,addScroll(oTienda, 9, TRUE)); //   9.- Pergaminos de la esfera 0
                      else if(nTirada <= 90)     DelayCommand(0.1,addScroll(oTienda, 19, TRUE)); // 19.- Pergaminos de la esfera 1 y 2.
                      else if(nTirada <= 100)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 3));  //Brazalete

            }
            else if (sTipo=="MONJE")
            {

                           if(nTirada <= 44)    DelayCommand(0.1,crearGuantesMonje(oTienda, iRango, TRUE));
                      else if(nTirada <= 66)    DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE, FALSE, 0)); //0. Ropas
                      else if(nTirada <= 88)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 5)); //Cinturones.
                      else if(nTirada <= 100)   DelayCommand(0.1,crearMunicion(oTienda, iRango, TRUE, FALSE, 2)); // 2.-Balas,

            }
            else if (sTipo=="CASCOS")
            {

                           if(nTirada <= 100)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 6));  // Yelmos

            }
            else if (sTipo=="BOTAS")
            {

                           if(nTirada <= 100)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 2));  // Botas

            }
            else if (sTipo=="CINTOS")
            {

                           if(nTirada <= 100)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 5));  // Cinturones

            }
            else if (sTipo=="MAZAS")
            {

                           if(nTirada <= 33)     DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE, FALSE, 27)); // 27.- Mazas
                      else if(nTirada <= 66)     DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE, FALSE, 28)); // 28.- Mazas de armas
                      else if(nTirada <= 100)    DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE, FALSE, 23)); // 23.- Manguales

            }
            else if (sTipo=="MARTILLOS")
            {

                           if(nTirada <= 40)     DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE, FALSE, 25)); // 25.- Hachas
                      else if(nTirada <= 100)    DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE, FALSE, 17)); // 17.- Martillos

            }

}



int GenerarObjeto(object oTienda, string sTipo, int iCalidad, int iCont, int nItem, int iMejora)
{

            int iRango, iSupe, iNormal, iInfe;
            iRango = iCalidad;
            int nDG;
           switch (iRango)
           {
                case 0: nDG =8;break;
                case 1: nDG =9;break;
                case 2: nDG=19;break;
                case 3: nDG=29;break;
                case 4: nDG=39;break;
                case 5: nDG=59;break;

                default: nDG =8;break;
           }
            switch (iCalidad)
            {
                case 0: iRango = 8; break;
                case 1: iRango=iCalidad*10; break;
                case 2: /*iSupe = FloatToInt(IntToFloat(nItem)* 0.03);
                        if (iSupe<=0){ iSupe=1;}  */
                        iNormal = FloatToInt(IntToFloat(nItem)* 0.1);
                        if (iNormal<=0){ iNormal=1;}
                        iInfe= nItem - iNormal;
                        /*iInfe = nItem - (iSupe + iNormal);
                        if (iCont <= iSupe)
                        {
                            iRango = (iCalidad + 1)*10;
                            GenerarObjeto_Ale(oTienda, sTipo, iRango);
                            //return iCont;
                        }
                        else if (iCont <= iSupe + iNormal)
                        {
                            iRango = iCalidad*10;
                            GenerarObjeto_Ale(oTienda, sTipo, iRango);
                            //return iCont;
                        }*/
                        if (iCont <= iNormal)
                        {
                            iRango = iCalidad*10;
                            GenerarObjeto_Ale(oTienda, sTipo, iRango);
                            //return iCont;
                        }
                        iRango = (iCalidad - 1)*10;
                        break;
                case 3: iRango = (iCalidad - 1)*10;
                        break;
                case 4: iSupe = FloatToInt(IntToFloat(nItem)* 0.8);
                        if (iSupe<=0){ iSupe=1;}
                        if (iCont <= iSupe)
                        {
                                iRango = (iCalidad + 1)*10;
                                GenerarObjeto_Ale(oTienda, sTipo, iRango);
                                //return iCont;

                        }
                        iRango = iCalidad*10;
                        break;

                default: iRango=iCalidad*10; break;

            }
            int iAux=0, iAux2=0, iCant1=0, iCant2=0,iCant3=0,iCant4=0,iCant5=0,iCant6=0,iCant7=0,iCant8=0,iCant9=0,iCant10=0, iCant11=0, iCant12=0, iElem=0;  //Variables para el autorrelleno cuando número de Item supera el mínimo.
            if (iMejora<=1){iElem=50;}else{iElem=100;}
            iAux = nItem - iElem;
            if (sTipo=="GENERAL")
            {

                  if (iAux>0)
                  {
                       while (iAux>0) //Autorellenado del exceso de Item a repartir según la diferentes categoría
                       {
                            iAux2++;
                            if (iAux>0){ iCant1=iAux2; iAux--;}
                            if (iAux>0){ iCant2=iAux2; iAux--;}
                            if (iAux>0){ iCant3=iAux2; iAux--;}
                            if (iAux>0){ iCant4=iAux2; iAux--;}
                            if (iAux>0){ iCant5=iAux2; iAux--;}
                            if (iAux>0){ iCant6=iAux2; iAux--;}
                            if (iAux>0){ iCant7=iAux2; iAux--;}
                            if (iAux>0){ iCant8=iAux2; iAux--;}
                            if (iAux>0){ iCant9=iAux2; iAux--;}
                            if (iAux>0){ iCant10=iAux2; iAux--;}
                            if (iAux>0){ iCant11=iAux2; iAux--;}
                            if (iAux>0){ iCant12=iAux2; iAux--;}

                       }
                  }
                  if(iMejora== 1)  // 25% de objetos encantados
                  {
                           if(iCont <= 6+iCant12)   DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE));
                      else if(iCont <= 12+iCant11)   DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE));
                      else if(iCont <= 18+iCant10)  DelayCommand(0.1,crearArmaDI(oTienda, iRango, TRUE));
                      else if(iCont <= 24+iCant9)   DelayCommand(0.1,crearBastonMago(oTienda, iRango, TRUE));
                      else if(iCont <= 27+iCant8)   DelayCommand(0.1,crearCetrosVaras(oTienda, iRango, TRUE));
                      else if(iCont <= 33+iCant7)   DelayCommand(0.1,crearGuantesMonje(oTienda, iRango, TRUE));
                      else if(iCont <= 36+iCant6)   DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 0)); // 0.-Amuletos, 1.- Anillos
                      else if(iCont <= 39+iCant5)   DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 1));
                      else if(iCont <= 42+iCant4)   DelayCommand(0.1,crearMunicion(oTienda, iRango, TRUE));
                      else if(iCont <= 45+iCant3)   DelayCommand(0.1,addPotion(oTienda, nDG, TRUE, FALSE));
                      else if(iCont <= 47+iCant2)   DelayCommand(0.1,addGem(oTienda, nDG, TRUE, FALSE));
                      else if(iCont <= 50+iCant1)   DelayCommand(0.1,addScroll(oTienda, nDG, TRUE, FALSE));


                  }
                  else if(iMejora== 2)  // 50% de objetos encantados
                  {



                           if(iCont <= 12+iCant12)    DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE));
                      else if(iCont <= 24+iCant11)   DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE));
                      else if(iCont <= 36+iCant10)   DelayCommand(0.1,crearArmaDI(oTienda, iRango, TRUE));
                      else if(iCont <= 48+iCant9)    DelayCommand(0.1,crearBastonMago(oTienda, iRango, TRUE));
                      else if(iCont <= 54+iCant8)    DelayCommand(0.1,crearCetrosVaras(oTienda, iRango, TRUE));
                      else if(iCont <= 66+iCant7)    DelayCommand(0.1,crearGuantesMonje(oTienda, iRango, TRUE));
                      else if(iCont <= 72+iCant6)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 0)); // 0.-Amuletos, 1.- Anillos
                      else if(iCont <= 78+iCant5)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 1));
                      else if(iCont <= 84+iCant4)    DelayCommand(0.1,crearMunicion(oTienda, iRango, TRUE));
                      else if(iCont <= 90+iCant3)    DelayCommand(0.1,addPotion(oTienda, nDG, TRUE, FALSE));
                      else if(iCont <= 94+iCant2)    DelayCommand(0.1,addGem(oTienda, nDG, TRUE, FALSE));
                      else if(iCont <= 100+iCant1)   DelayCommand(0.1,addScroll(oTienda, nDG, TRUE, FALSE));



                 }


            }
            else if (sTipo=="ARCANA")
            {
                  if(iMejora== 1)  // 25% de objetos encantados
                  {


                           if (iAux>0)
                           {
                                   while (iAux>0)
                                   {
                                        iAux2++;
                                        if (iAux>0){ iCant1=iAux2; iAux--;}
                                        if (iAux>0){ iCant2=iAux2; iAux--;}
                                        if (iAux>0){ iCant3=iAux2; iAux--;}
                                        if (iAux>0){ iCant4=iAux2; iAux--;}
                                        if (iAux>0){ iCant5=iAux2; iAux--;}
                                        if (iAux>0){ iCant6=iAux2; iAux--;}
                                        if (iAux>0){ iCant7=iAux2; iAux--;}
                                        if (iAux>0){ iCant8=iAux2; iAux--;}
                                   }
                           }

                           if(iCont <= 6+iCant8)   DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE, FALSE, 0)); // 0.-Ropas, 1.-Armadura Ligera, 2.- Armadura Intermedia, 3.- Armadura Pesada
                      else if(iCont <= 12+iCant7)  DelayCommand(0.1,crearBastonMago(oTienda, iRango, TRUE));
                      else if(iCont <= 18+iCant6)  DelayCommand(0.1,crearCetrosVaras(oTienda, iRango, TRUE, FALSE, 0)); // 0.Varitas 1.Cetros
                      else if(iCont <= 24+iCant5)  DelayCommand(0.1,crearCetrosVaras(oTienda, iRango, TRUE, FALSE, 1));
                      else if(iCont <= 30+iCant4)  DelayCommand(0.1,addPotion(oTienda, nDG, TRUE, FALSE));
                      else if(iCont <= 36+iCant3)  DelayCommand(0.1,addScroll(oTienda, nDG, TRUE, FALSE));
                      else if(iCont <= 42+iCant2)  DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 0)); // 0.-Amuletos, 1.- Anillos
                      else if(iCont <= 50+iCant1)  DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 1));
                  }
                  else if(iMejora== 2)  // 50% de objetos encantados
                  {



                           if(iCont <= 12+iCant8)   DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE, FALSE, 0)); // 0.-Ropas, 1.-Armadura Ligera, 2.- Armadura Intermedia, 3.- Armadura Pesada
                      else if(iCont <= 24+iCant7)   DelayCommand(0.1,crearBastonMago(oTienda, iRango, TRUE));
                      else if(iCont <= 36+iCant6)   DelayCommand(0.1,crearCetrosVaras(oTienda, iRango, TRUE, FALSE, 0)); // 0.Varitas 1.Cetros
                      else if(iCont <= 48+iCant5)   DelayCommand(0.1,crearCetrosVaras(oTienda, iRango, TRUE, FALSE, 1));
                      else if(iCont <= 60+iCant4)   DelayCommand(0.1,addPotion(oTienda, nDG, TRUE, FALSE));
                      else if(iCont <= 72+iCant3)   DelayCommand(0.1,addScroll(oTienda, nDG, TRUE, FALSE));
                      else if(iCont <= 84+iCant2)   DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 0)); // 0.-Amuletos, 1.- Anillos
                      else if(iCont <= 100+iCant1)  DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 1));

                 }
            }
            else if (sTipo=="SASTRE")
            {
                  if (iAux>0)
                  {
                        while (iAux>0)
                        {
                            iAux2++;
                            if (iAux>0){ iCant1=iAux2; iAux--;}
                            if (iAux>0){ iCant2=iAux2; iAux--;}
                            if (iAux>0){ iCant3=iAux2; iAux--;}
                            if (iAux>0){ iCant4=iAux2; iAux--;}
                            if (iAux>0){ iCant5=iAux2; iAux--;}

                         }
                  }
                  if(iMejora== 1)  // 25% de objetos encantados
                  {

                           if(iCont <= 10+iCant5)    DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE, FALSE, 0));// 0.-Ropas, 1.-Armadura Ligera, 2.- Armadura Intermedia, 3.- Armadura Pesada
                      else if(iCont <= 20+iCant4)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 2)); //Botas
                      else if(iCont <= 35+iCant3)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 3));  //Brazaletes
                      else if(iCont <= 43+iCant2)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 4)); //Capas
                      else if(iCont <= 50+iCant1)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 5)); //Cinturones.



                  }
                  else if(iMejora== 2)  // 50% de objetos encantados
                  {

                           if(iCont <= 20+iCant5)      DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE, FALSE, 0));
                      else if(iCont <= 40+iCant4)      DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 2));
                      else if(iCont <= 70+iCant3)      DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 3));
                      else if(iCont <= 85+iCant2)      DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 4));
                      else if(iCont <= 100+iCant1)     DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 5));

                 }

            }
            else if (sTipo=="PELETERO")
            {
                  if (iAux>0)
                  {
                        while (iAux>0)
                        {
                            iAux2++;
                            if (iAux>0){ iCant1=iAux2; iAux--;}
                            if (iAux>0){ iCant2=iAux2; iAux--;}
                            if (iAux>0){ iCant3=iAux2; iAux--;}
                            if (iAux>0){ iCant4=iAux2; iAux--;}
                            if (iAux>0){ iCant5=iAux2; iAux--;}

                         }
                  }
                  if(iMejora== 1)  // 25% de objetos encantados
                  {


                           if(iCont <= 10+iCant5)   DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 2)); //Botas
                      else if(iCont <= 20+iCant4)   DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE, FALSE, 1)); // 0.-Ropas, 1.-Armadura Ligera, 2.- Armadura Intermedia, 3.- Armadura Pesada
                      else if(iCont <= 30+iCant3)   DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE, FALSE, 2));
                      else if(iCont <= 40+iCant2)   DelayCommand(0.1,crearGuantesMonje(oTienda, iRango, TRUE));
                      else if(iCont <= 50+iCant1)   DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 5)); //Cinturones


                  }
                  else if(iMejora== 2)  // 50% de objetos encantados
                  {

                           if(iCont <= 20+iCant5)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 2));
                      else if(iCont <= 40+iCant4)    DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE, FALSE, 1));
                      else if(iCont <= 60+iCant3)    DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE, FALSE, 2));
                      else if(iCont <= 80+iCant2)    DelayCommand(0.1,crearGuantesMonje(oTienda, iRango, TRUE));
                      else if(iCont <= 100+iCant1)   DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 5));

                 }

            }
            else if (sTipo=="CARPINTERO")
            {

                  if (iAux>0)
                  {
                        while (iAux>0)
                        {
                            iAux2++;
                            if (iAux>0){ iCant1=iAux2; iAux--;}
                            if (iAux>0){ iCant2=iAux2; iAux--;}
                            if (iAux>0){ iCant3=iAux2; iAux--;}
                            if (iAux>0){ iCant4=iAux2; iAux--;}
                            if (iAux>0){ iCant5=iAux2; iAux--;}

                         }
                  }
                  if(iMejora== 1)  // 25% de objetos encantados
                  {

                           if(iCont <= 10+iCant5)    DelayCommand(0.1,crearArmaDI(oTienda, iRango, TRUE, FALSE, 2)); //2. Ballestas
                      else if(iCont <= 20+iCant4)    DelayCommand(0.1,crearArmaDI(oTienda, iRango, TRUE, FALSE, 3)); //3. Arcos
                      else if(iCont <= 30+iCant3)    DelayCommand(0.1,crearArmaDI(oTienda, iRango, TRUE));
                      else if(iCont <= 40+iCant2)    DelayCommand(0.1,crearMunicion(oTienda, iRango, TRUE));
                      else if(iCont <= 50+iCant1)    DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE, FALSE, 29)); // 29. Bastones

                  }
                  else if(iMejora== 2)  // 50% de objetos encantados
                  {

                           if(iCont <= 20+iCant5)     DelayCommand(0.1,crearArmaDI(oTienda, iRango, TRUE, FALSE, 2));
                      else if(iCont <= 40+iCant4)     DelayCommand(0.1,crearArmaDI(oTienda, iRango, TRUE, FALSE, 3));
                      else if(iCont <= 60+iCant3)     DelayCommand(0.1,crearArmaDI(oTienda, iRango, TRUE));
                      else if(iCont <= 80+iCant2)     DelayCommand(0.1,crearMunicion(oTienda, iRango, TRUE));
                      else if(iCont <= 100+iCant1)    DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE, FALSE, 29));

                 }

            }
            else if (sTipo=="ARMERO")
            {
                  if (iAux>0)
                  {
                      iCant1=iAux;
                  }
                  if(iMejora== 1)  // 25% de objetos encantados
                  {
                      if(iCont <= 50+iCant1)   DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE));

                  }
                  else if(iMejora== 2)  // 50% de objetos encantados
                  {
                       if(iCont <= 100+iCant1)  DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE));
                  }

            }
            else if (sTipo=="HERRERO")
            {

                  if (iAux>0)
                  {
                        while (iAux>0)
                        {
                            iAux2++;
                            if (iAux>0){ iCant1=iAux2; iAux--;}
                            if (iAux>0){ iCant2=iAux2; iAux--;}
                            if (iAux>0){ iCant3=iAux2; iAux--;}

                         }
                  }
                  if(iMejora== 1)  // 25% de objetos encantados
                  {

                           if(iCont <= 16+iCant3)    DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE, FALSE, 2)); // 0.-Ropas, 1.-Armadura Ligera, 2.- Armadura Intermedia, 3.- Armadura Pesada
                      else if(iCont <= 32+iCant2)    DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE, FALSE, 3)); //3
                      else if(iCont <= 50+iCant1)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 6));  // Yelmos

                  }
                  else if(iMejora== 2)  // 50% de objetos encantados
                  {
                           if(iCont <= 33+iCant3)    DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE, FALSE, 2));
                      else if(iCont <= 66+iCant2)    DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE, FALSE, 3)); //3
                      else if(iCont <= 100+iCant1)   DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 6));
                 }

            }
            else if (sTipo=="ESCUDERO")
            {
                  if (iAux>0)
                  {
                        while (iAux>0)
                        {
                            iAux2++;
                            if (iAux>0){ iCant1=iAux2; iAux--;}
                            if (iAux>0){ iCant2=iAux2; iAux--;}
                            if (iAux>0){ iCant3=iAux2; iAux--;}
                         }
                  }
                  if(iMejora== 1)  // 25% de objetos encantados
                  {
                           if(iCont <= 16+iCant3)     DelayCommand(0.1,crearEscudo(oTienda, iRango, TRUE, FALSE, 0)); // 0.-Escudos Pequeños, 1.-Escudos Grandes, 2.-Escudo Paveses.
                      else if(iCont <= 32+iCant2)     DelayCommand(0.1,crearEscudo(oTienda, iRango, TRUE, FALSE, 1));
                      else if(iCont <= 50+iCant1)    DelayCommand(0.1,crearEscudo(oTienda, iRango, TRUE, FALSE, 2));

                  }
                  else if(iMejora== 2)  // 50% de objetos encantados
                  {

                           if(iCont <= 33+iCant3)     DelayCommand(0.1,crearEscudo(oTienda, iRango, TRUE, FALSE, 0));
                      else if(iCont <= 66+iCant2)     DelayCommand(0.1,crearEscudo(oTienda, iRango, TRUE, FALSE, 1));
                      else if(iCont <= 100+iCant1)    DelayCommand(0.1,crearEscudo(oTienda, iRango, TRUE, FALSE, 2));

                 }

            }
            else if (sTipo=="JOYERO")
            {
                  if (iAux>0)
                  {
                        while (iAux>0)
                        {
                            iAux2++;
                            if (iAux>0){ iCant1=iAux2; iAux--;}
                            if (iAux>0){ iCant2=iAux2; iAux--;}
                            if (iAux>0){ iCant3=iAux2; iAux--;}
                         }
                  }
                  if(iMejora== 1)  // 25% de objetos encantados
                  {

                            if(iCont <= 16+iCant3)     DelayCommand(0.1,addGem(oTienda, nDG, TRUE, FALSE));
                      else if(iCont <= 32+iCant2)     DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 0)); // 0.-Amuletos, 1.- Anillos
                      else if(iCont <= 50+iCant1)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 1));

                  }
                  else if(iMejora== 2)  // 50% de objetos encantados
                  {
                           if(iCont <= 33+iCant3)     DelayCommand(0.1,addGem(oTienda, nDG, TRUE, FALSE));
                      else if(iCont <= 66+iCant2)     DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 0)); // 0.-Amuletos, 1.- Anillos
                      else if(iCont <= 100+iCant1)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 1));

                 }

            }
            else if (sTipo=="HONDERO")
            {
                 if (iAux>0)
                  {
                        while (iAux>0)
                        {
                            iAux2++;
                            if (iAux>0){ iCant1=iAux2; iAux--;}
                            if (iAux>0){ iCant2=iAux2; iAux--;}

                         }
                  }
                  if(iMejora== 1)  // 25% de objetos encantados
                  {

                            if(iCont <= 33+iCant2)    DelayCommand(0.1,crearArmaDI(oTienda, iRango, TRUE, FALSE, 4)); // 4.-Hondas
                      else if(iCont <= 50+iCant1)     DelayCommand(0.1,crearMunicion(oTienda, iRango, TRUE, FALSE, 2)); // 2.-Balas,


                  }
                  else if(iMejora== 2)  // 50% de objetos encantados
                  {
                           if(iCont <= 66+iCant2)     DelayCommand(0.1,crearArmaDI(oTienda, iRango, TRUE, FALSE, 4)); // 4.-Hondas
                      else if(iCont <= 100+iCant1)    DelayCommand(0.1,crearMunicion(oTienda, iRango, TRUE, FALSE, 2)); // 2.-Balas,

                 }

           }
           else if (sTipo=="VARITAS")
            {

                  if (iAux>0)
                  {
                        while (iAux>0)
                        {
                            iAux2++;
                            if (iAux>0){ iCant1=iAux2; iAux--;}
                            if (iAux>0){ iCant2=iAux2; iAux--;}
                            if (iAux>0){ iCant3=iAux2; iAux--;}
                            if (iAux>0){ iCant4=iAux2; iAux--;}
                         }
                  }
                  if(iMejora== 1)  // 25% de objetos encantados
                  {

                           if(iCont <= 25+iCant5)    DelayCommand(0.1,crearCetrosVaras(oTienda, iRango, TRUE, FALSE, 0)); // 0.-Varitas
                      else if(iCont <= 30+iCant4)    DelayCommand(0.1,addPotion(oTienda, nDG, TRUE, FALSE));
                      else if(iCont <= 35+iCant3)    DelayCommand(0.1,addScroll(oTienda, 9, TRUE, FALSE)); //   9.-  Pergaminos de la esfera 0
                      else if(iCont <= 45+iCant2)    DelayCommand(0.1,addScroll(oTienda, 19, TRUE, FALSE)); // 29.-  Pergaminos de la esfera 1 y 2.
                      else if(iCont <= 50+iCant1)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 3));  //Brazalete
                  }
                  else if(iMejora== 2)  // 50% de objetos encantados
                  {

                           if(iCont <= 50+iCant5)      DelayCommand(0.1,crearCetrosVaras(oTienda, iRango, TRUE, FALSE, 0)); // 0.-Varitas
                      else if(iCont <= 60+iCant4)      DelayCommand(0.1,addPotion(oTienda, nDG, TRUE, FALSE));
                      else if(iCont <= 70+iCant3)      DelayCommand(0.1,addScroll(oTienda, 9, TRUE, FALSE)); //    9.-  Pergaminos de la esfera 0
                      else if(iCont <= 90+iCant2)      DelayCommand(0.1,addScroll(oTienda, 19, TRUE, FALSE)); //  19.-  Pergaminos de la esfera 1 y 2
                      else if(iCont <= 100+iCant1)     DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 3));  //Brazalete

                 }

            }
            else if (sTipo=="MONJE")
            {

                  if (iAux>0)
                  {
                        while (iAux>0)
                        {
                            iAux2++;
                            if (iAux>0){ iCant1=iAux2; iAux--;}
                            if (iAux>0){ iCant2=iAux2; iAux--;}
                            if (iAux>0){ iCant3=iAux2; iAux--;}
                            if (iAux>0){ iCant4=iAux2; iAux--;}
                         }
                  }
                  if(iMejora== 1)  // 25% de objetos encantados
                  {

                           if(iCont <= 22+iCant4)    DelayCommand(0.1,crearGuantesMonje(oTienda, iRango, TRUE));
                      else if(iCont <= 33+iCant3)    DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE, FALSE, 0)); //0. Ropas
                      else if(iCont <= 44+iCant2)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 5)); //Cinturones.
                      else if(iCont <= 50+iCant1)    DelayCommand(0.1,crearMunicion(oTienda, iRango, TRUE, FALSE, 2)); // 2.-Balas,
                  }
                  else if(iMejora== 2)  // 50% de objetos encantados
                  {

                           if(iCont <= 44+iCant4)     DelayCommand(0.1,crearGuantesMonje(oTienda, iRango, TRUE));
                      else if(iCont <= 66+iCant3)     DelayCommand(0.1,crearArmadura(oTienda, iRango, TRUE, FALSE, 0)); //0. Ropas
                      else if(iCont <= 88+iCant2)     DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 5)); //Cinturones.
                      else if(iCont <= 100+iCant1)    DelayCommand(0.1,crearMunicion(oTienda, iRango, TRUE, FALSE, 2)); // 2.-Balas,

                 }

            }
            else if (sTipo=="CASCOS")
            {

                  if (iAux>0)
                  {
                        while (iAux>0)
                        {
                            iAux2++;
                            if (iAux>0){ iCant1=iAux2; iAux--;}
                         }
                  }
                  if(iMejora== 1)  // 25% de objetos encantados
                  {

                           if(iCont <= 25+iCant1)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 6));  // Yelmos
                  }
                  else if(iMejora== 2)  // 50% de objetos encantados
                  {

                           if(iCont <= 50+iCant1)     DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 6));  // Yelmos

                 }

            }
            else if (sTipo=="BOTAS")
            {

                  if (iAux>0)
                  {
                        while (iAux>0)
                        {
                            iAux2++;
                            if (iAux>0){ iCant1=iAux2; iAux--;}
                         }
                  }
                  if(iMejora== 1)  // 25% de objetos encantados
                  {

                           if(iCont <= 25+iCant1)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 2));  // Botas
                  }
                  else if(iMejora== 2)  // 50% de objetos encantados
                  {

                           if(iCont <= 50+iCant1)     DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 2));  // Botas

                 }

            }
            else if (sTipo=="CINTOS")
            {

                  if (iAux>0)
                  {
                        while (iAux>0)
                        {
                            iAux2++;
                            if (iAux>0){ iCant1=iAux2; iAux--;}
                         }
                  }
                  if(iMejora== 1)  // 25% de objetos encantados
                  {

                           if(iCont <= 25+iCant1)    DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 5));  // Cinturones
                  }
                  else if(iMejora== 2)  // 50% de objetos encantados
                  {

                           if(iCont <= 50+iCant1)     DelayCommand(0.1,crearMiscelaneo(oTienda, iRango, TRUE, FALSE, 5));  // Cinturones

                 }
            }
            else if (sTipo=="MAZAS")
            {
                  if (iAux>0)
                  {
                        while (iAux>0)
                        {
                            iAux2++;
                            if (iAux>0){ iCant1=iAux2; iAux--;}
                            if (iAux>0){ iCant2=iAux2; iAux--;}
                            if (iAux>0){ iCant3=iAux2; iAux--;}
                         }
                  }
                  if(iMejora== 1)  // 25% de objetos encantados
                  {

                            if(iCont <= 16+iCant3)   DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE, FALSE, 27)); // 27.- Mazas
                      else if(iCont <= 32+iCant2)    DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE, FALSE, 28)); // 28.- Mazas de armas
                      else if(iCont <= 50+iCant1)    DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE, FALSE, 23)); // 23.- Manguales

                  }
                  else if(iMejora== 2)  // 50% de objetos encantados
                  {
                           if(iCont <= 33+iCant3)     DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE, FALSE, 27)); // 27.- Mazas
                      else if(iCont <= 66+iCant2)     DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE, FALSE, 28)); // 28.- Mazas de armas
                      else if(iCont <= 100+iCant1)    DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE, FALSE, 23)); // 23.- Manguales

                  }
             }
             else if (sTipo=="MARTILLOS")
             {
                  if (iAux>0)
                  {
                        while (iAux>0)
                        {
                            iAux2++;
                            if (iAux>0){ iCant1=iAux2; iAux--;}
                            if (iAux>0){ iCant2=iAux2; iAux--;}
                         }
                  }
                  if(iMejora== 1)  // 25% de objetos encantados
                  {

                           if(iCont <= 20+iCant2)    DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE, FALSE, 25)); // 25.- Martillo
                      else if(iCont <= 50+iCant1)    DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE, FALSE, 17)); // 17.- Hachas

                  }
                  else if(iMejora== 2)  // 50% de objetos encantados
                  {
                           if(iCont <= 40+iCant2)     DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE, FALSE, 25)); // 25.- Martillos
                      else if(iCont <= 100+iCant1)    DelayCommand(0.1,crearArmaCC(oTienda, iRango, TRUE, FALSE, 17)); // 17.- Hachas

                  }
            }
    return iCont;
}

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
        LimpiarTienda();
        //Y ya hacemos andar el sistema de generación de tesoros.
        int iMejora = GetLocalInt(OBJECT_SELF, "Ind_Mejora");
        int nElem=0;
        int iCont=1;
        int nItem = GetLocalInt(OBJECT_SELF, "Num_Item");
        if (iMejora==1){nElem=50;} else { nElem=100;}
        nElem = nElem + nItem;
        if (nElem<0) {nElem=0;}
        string sTipo = GetLocalString(OBJECT_SELF, "Tipo_Tienda");
        int iCalidad = GetLocalInt(OBJECT_SELF, "Nivel");
        while (iCont <= nElem)
        {
            iCont = GenerarObjeto (OBJECT_SELF, sTipo, iCalidad, iCont, nElem, iMejora);
            iCont++;

        }
        //DelayCommand(0.15,IdentificarObjetos());
    }

}

