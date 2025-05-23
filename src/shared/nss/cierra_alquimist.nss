#include "mti_libreria"
#include "sute_libreria"
#include "lib_race"

/*Comprueba que la poción no sea apta para extender su duración*/
int noExtensible(int idPocion){
   if ((idPocion==1)||
       (idPocion==2)||
       (idPocion==8)||
       (idPocion==12)||
       (idPocion==13)||
       (idPocion==14)||
       (idPocion==16)||
       (idPocion==17)||
       (idPocion==18)||
       (idPocion==19)||
       (idPocion==20)||
       (idPocion==41)||
       (idPocion==46)||
       (idPocion==51)||
       (idPocion==56)||
       (idPocion==58)||
       (idPocion==59)||
       (idPocion==60)||
       (idPocion==62)||
       (idPocion==63)||
       (idPocion==64)||
       (idPocion==65)||
       (idPocion==66)||
       (idPocion==127)||
       (idPocion==128)){
      return 1;
   }else{
      return 0;
   }
}

/*Comprueba que la poción no sea apta para potenciar sus efectos*/
int noPotenciable(int idPocion){
   if ((idPocion==1)||
       (idPocion==2)||
       (idPocion==8)||
       (idPocion==9)||
       (idPocion==16)||
       (idPocion==51)||
       (idPocion==52)||
       (idPocion==55)||
       (idPocion==56)||
       (idPocion==66)||
       (idPocion==68)||
       (idPocion==72)||
       (idPocion==127)||
       (idPocion==128)){
      return 0;
   }else{
      return 1;
   }
}

/*Comprueba que la poción sea del grupo especial*/
int esEspecial(int idPocion){
   if ((idPocion==1)||
       (idPocion==2)||
       (idPocion==8)||
       (idPocion==12)||
       (idPocion==13)||
       (idPocion==14)||
       (idPocion==17)||
       (idPocion==18)||
       (idPocion==19)||
       (idPocion==51)||
       (idPocion==58)||
       (idPocion==59)||
       (idPocion==60)||
       (idPocion==65)||
       (idPocion==66)||
       (idPocion==67)||
       (idPocion==128)||
       (idPocion==127)){
      return 1;
   }else{
      return 0;
   }
}

/*Devuelve la pocion de alquimista resultante de la pocion
   y los ingredientes introducidos*/
void obtenerInformacionTransformacion(object oPC, object oBrasero, object oMesa, int ing1, int ing2){
   string sPocionNombre= GetLocalString(oBrasero, "POCIONNOMBRE");
   string sPocionTag= GetLocalString(oBrasero, "POCIONTAG");
   string sPocionBase= GetLocalString(oBrasero, "POCIONBASE");
   int iDificultad= GetLocalInt(oBrasero, "DIFICULTAD");
   string sNumBasica= GetSubString(sPocionTag, 17, 1);
   string sEscuela= GetSubString(sPocionBase, 9, 3);
   string sCategoria= GetSubString(sPocionBase, 13, 1);
   int idPocion= StringToInt(GetSubString(sPocionTag, 9, 3));
   string sIzquierda= "";
   string sDerecha= "";
   int cambio= 0;

    //Formula descubierta
   if (esEspecial(idPocion)==1){
      if (idPocion==1){
         if ((ing1==9)&&(ing2==12)){
            sPocionTag= "sute_her_253_025_n_DrinkMED_ENERGY1";
            sPocionNombre= "Infusión encantada";
            sPocionBase= "sute_her_DE1";
            //iDificultad= iDificultad+20;
            cambio= 1;
         }
      //Formula descubierta
      }else if (idPocion==2){
         if ((ing1==13)&&(ing2==3)){
            sPocionTag= "sute_her_254_025_n_FoodNORM_ENERGY1";
            sPocionNombre= "Frutos secos encantados";
            sPocionBase= "sute_her_FE1";
            iDificultad= iDificultad+5;
            cambio= 1;
         }

      }else if (idPocion==127){
         if ((ing1==9)&&(ing2==12)){
            sPocionTag= "sute_her_255_095_n_DrinkHIGH_ENERGY2";
            sPocionNombre= "Hidromiel encantada";
            sPocionBase= "sute_her_DE2";
            iDificultad= iDificultad+20;
            cambio= 1;
         }

      }else if (idPocion==128){
         if ((ing1==13)&&(ing2==16)){
            sPocionTag= "sute_her_256_095_n_FoodRICH_ENERGY2";
            sPocionNombre= "Pastel encantado";
            sPocionBase= "sute_her_FE2";
            iDificultad= iDificultad+20;
            cambio= 1;
         }
      //Formula descubierta
      }else if (idPocion==8){
         if ((ing1==3)&&(ing2==17)){
            sPocionTag= "sute_her_150_015_n";
            sPocionNombre= "Vendas de Herbolario";
            sPocionBase= "sute_her_vendas";
            cambio= 1;
         }else if ((ing1==11)&&(ing2==10)){
            sIzquierda= GetSubString(sPocionTag, 0, 17);
            sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
            sPocionTag= sIzquierda+"p"+sDerecha;
            sPocionNombre= sPocionNombre+ " Mayor";
            cambio= 1;
         }
      }else if (idPocion== 51){
         if ((ing1==11)&&(ing2==17)){
            sPocionTag= "sute_her_151_045_n";
            sPocionNombre= "Vendas Mayores de Herbolario";
            sPocionBase= "sute_her_vendas";
            cambio= 1;
         }else if ((ing1==11)&&(ing2==10)){
            sIzquierda= GetSubString(sPocionTag, 0, 17);
            sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
            sPocionTag= sIzquierda+"p"+sDerecha;
            sPocionNombre= sPocionNombre+ " Mayor";
            cambio= 1;
         }
       //Formula descubierta
      }else if (idPocion==12){
         if ((ing1==15)&&(ing2==14)){
            sPocionTag= "sute_her_132_040_n";
            sPocionNombre= "Frasco Turbio";
            sPocionBase= "sute_her_f_ven";
            cambio= 1;
         }
      }else if (idPocion==13){
         if ((ing1==15)&&(ing2==14)){
            sPocionTag= "sute_her_133_040_n";
            sPocionNombre= "Frasco Desconcertante";
            sPocionBase= "sute_her_f_ven";
            cambio= 1;
         }
      }else if (idPocion==14){
         if ((ing1==15)&&(ing2==14)){
            sPocionTag= "sute_her_134_040_n";
            sPocionNombre= "Frasco Mohoso";
            sPocionBase= "sute_her_f_ven";
            cambio= 1;
         }
      }else if (idPocion==17){
         if ((ing1==15)&&(ing2==14)){
            sPocionTag= "sute_her_129_045_n";
            sPocionNombre= "Frasco Inconsistente";
            sPocionBase= "sute_her_f_ven";
            cambio= 1;
         }
      }else if (idPocion==18){
         if ((ing1==15)&&(ing2==14)){
            sPocionTag= "sute_her_130_045_n";
            sPocionNombre= "Frasco Viscoso";
            sPocionBase= "sute_her_f_ven";
            cambio= 1;
         }
      }else if (idPocion==19){
         if ((ing1==15)&&(ing2==14)){
            sPocionTag= "sute_her_131_045_n";
            sPocionNombre= "Frasco Grumoso";
            sPocionBase= "sute_her_f_ven";
            cambio= 1;
         }
      }else if (idPocion==58){
         if ((ing1==15)&&(ing2==14)){
            sPocionTag= "sute_her_140_075_n";
            sPocionNombre= "Frasco Repulsivo";
            sPocionBase= "sute_her_f_ven";
            cambio= 1;
         }
      }else if (idPocion==59){
         if ((ing1==15)&&(ing2==14)){
            sPocionTag= "sute_her_138_075_n";
            sPocionNombre= "Frasco Obtuso";
            sPocionBase= "sute_her_f_ven";
            cambio= 1;
         }
      }else if (idPocion==60){
         if ((ing1==15)&&(ing2==14)){
            sPocionTag= "sute_her_139_075_n";
            sPocionNombre= "Frasco Atontador";
            sPocionBase= "sute_her_f_ven";
            cambio= 1;
         }
      }else if (idPocion==65){
         if ((ing1==15)&&(ing2==14)){
            sPocionTag= "sute_her_137_080_n";
            sPocionNombre= "Frasco Malsano";
            sPocionBase= "sute_her_f_ven";
            cambio= 1;
         }
      }else if (idPocion==66){
         if ((ing1==15)&&(ing2==14)){
            sPocionTag= "sute_her_136_080_n";
            sPocionNombre= "Frasco Agarrotador";
            sPocionBase= "sute_her_f_ven";
            cambio= 1;
         }
      }else if (idPocion==67){
         if ((ing1==15)&&(ing2==14)){
            sPocionTag= "sute_her_135_080_n";
            sPocionNombre= "Frasco Debilitante";
            sPocionBase= "sute_her_f_ven";
            cambio= 1;
         }
      }
   }else{

       if (sNumBasica=="n"){
          if (sEscuela=="abj"){
             if (ing1==6){
                if ((sCategoria=="b")&&(ing2==17)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }else if ((sCategoria=="a")&&(ing2==14)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }
             }else if (ing1==14){
                if ((sCategoria=="m")&&(ing2==17)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }else if (ing2==15){
                   if(noPotenciable(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"p"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Mayor";
                      iDificultad= iDificultad+20;
                      cambio= 1;
                   }
                }
             }
          }else if (sEscuela=="con"){
             if (ing1==3){
                if ((sCategoria=="b")&&(ing2==17)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }else if ((sCategoria=="a")&&(ing2==11)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }
             }else if (ing1==11){
                if ((sCategoria=="m")&&(ing2==17)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }else if (ing2==10){
                   if(noPotenciable(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"p"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Mayor";
                      iDificultad= iDificultad+20;
                      cambio= 1;
                   }
                }
             }
          }else if (sEscuela=="adi"){
             if (ing1==2){
                if ((sCategoria=="b")&&(ing2==17)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }else if ((sCategoria=="a")&&(ing2==10)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }
             }else if (ing1==10){
                if ((sCategoria=="m")&&(ing2==17)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }else if (ing2==11){
                   if(noPotenciable(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"p"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Mayor";
                      iDificultad= iDificultad+20;
                      cambio= 1;
                   }
                }
             }
          }else if (sEscuela=="enc"){
             if (ing1==1){
                if ((sCategoria=="b")&&(ing2==17)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }else if ((sCategoria=="a")&&(ing2==9)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }
             }else if (ing1==9){
                if ((sCategoria=="m")&&(ing2==17)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }else if (ing2==12){
                   if(noPotenciable(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"p"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Mayor";
                      iDificultad= iDificultad+20;
                      cambio= 1;
                   }
                }
             }
          }else if (sEscuela=="evo"){
             if (ing1==4){
                if ((sCategoria=="b")&&(ing2==17)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }else if ((sCategoria=="a")&&(ing2==12)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }
             }else if (ing1==12){
                if ((sCategoria=="m")&&(ing2==17)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }else if (ing2==9){
                   if(noPotenciable(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"p"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Mayor";
                      iDificultad= iDificultad+20;
                      cambio= 1;
                   }
                }
             }
          }else if (sEscuela=="ilu"){
             if (ing1==8){
                if ((sCategoria=="b")&&(ing2==17)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }else if ((sCategoria=="a")&&(ing2==16)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }
             }else if (ing1==16){
                if ((sCategoria=="m")&&(ing2==17)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }else if (ing2==13){
                   if(noPotenciable(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"p"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Mayor";
                      iDificultad= iDificultad+20;
                      cambio= 1;
                   }
                }
             }
          }else if (sEscuela=="nig"){
             if (ing1==7){
                if ((sCategoria=="b")&&(ing2==17)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }else if ((sCategoria=="a")&&(ing2==15)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }
             }else if (ing1==15){
                if ((sCategoria=="m")&&(ing2==17)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }else if (ing2==14){
                    if(noPotenciable(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"p"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Mayor";
                      iDificultad= iDificultad+20;
                      cambio= 1;
                   }
                }
             }
          }else if (sEscuela=="tra"){
             if (ing1==5){
                if ((sCategoria=="b")&&(ing2==17)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }else if ((sCategoria=="a")&&(ing2==13)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }
             }else if (ing1==13){
                if ((sCategoria=="m")&&(ing2==17)){
                   if(noExtensible(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"d"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Concentrada";
                      cambio= 1;
                   }
                }else if (ing2==16){
                   if(noPotenciable(idPocion)==0){
                      sIzquierda= GetSubString(sPocionTag, 0, 17);
                      sDerecha= GetSubString(sPocionTag, 18, (GetStringLength(sPocionTag)-18));
                      sPocionTag= sIzquierda+"p"+sDerecha;
                      sPocionNombre= sPocionNombre+ " Mayor";
                      iDificultad= iDificultad+20;
                      cambio= 1;
                   }
                }
             }
          }
       }
   }

   if(cambio==1){
      SetLocalString(oMesa, "POCIONNOMBRE", sPocionNombre);
      SetLocalString(oMesa, "POCIONTAG", sPocionTag);
      SetLocalString(oMesa, "POCIONBASE", sPocionBase);
      SetLocalInt(oMesa, "DIFICULTAD", iDificultad);
   }
}


/*Comprueba que el brasero esta a punto*/
int braseroCorrecto(object oBrasero){
   object oObjeto;
   int numObjetos= 0;
   int resultado= 0;

   oObjeto = GetFirstItemInInventory(oBrasero);
   while (GetIsObjectValid(oObjeto)){
      numObjetos= numObjetos+1;
      if(GetTag(oObjeto)=="x2_it_cfm_pbottl"){
         resultado= 1;
      }
      DestroyObject(oObjeto);
      oObjeto = GetNextItemInInventory(oBrasero);
   }
   if(numObjetos==1){
      int iPaso= GetLocalInt(oBrasero, "PASO");
      string sPocion= GetLocalString(oBrasero, "POCION");
      if ((iPaso==2)&&(sPocion!="")){
         DeleteLocalString(oBrasero, "POCION");
         return resultado;
      }else{
         return 0;
      }
   }else{
      return 0;
   }
   return 1;
}

/*Obtiene el componente introducido en la mesa de mezclas:
 *   0: objeto invalido o mas de un objeto
 *   1-16: componente
 *   17: botella
 */
int obtenerComponente(object oMesa){
   object oObjeto;
   int numObjetos= 0;
   int resultado= 0;

   oObjeto = GetFirstItemInInventory(oMesa);
   while (GetIsObjectValid(oObjeto)){
      numObjetos= numObjetos+1;
      if(GetTag(oObjeto)=="bayaAcuosa"){
         resultado= 1;
      }else if(GetTag(oObjeto)=="brisaSusurrante"){
         resultado= 2;
      }else if(GetTag(oObjeto)=="resinaSubterranea"){
         resultado= 3;
      }else if(GetTag(oObjeto)=="ardorDesertico"){
         resultado= 4;
      }else if(GetTag(oObjeto)=="raizPetrea"){
         resultado= 5;
      }else if(GetTag(oObjeto)=="florLuminosa"){
         resultado= 6;
      }else if(GetTag(oObjeto)=="setaNocturna"){
         resultado= 7;
      }else if(GetTag(oObjeto)=="frutoFantasma"){
         resultado= 8;
      }else if(GetTag(oObjeto)=="zumoAcuoso"){
         resultado= 9;
      }else if(GetTag(oObjeto)=="humoGaseoso"){
         resultado= 10;
      }else if(GetTag(oObjeto)=="pastaTerrosa"){
         resultado= 11;
      }else if(GetTag(oObjeto)=="especiaSulfurosa"){
         resultado= 12;
      }else if(GetTag(oObjeto)=="picadaRocosa"){
         resultado= 13;
      }else if(GetTag(oObjeto)=="virutasResplandecientes"){
         resultado= 14;
      }else if(GetTag(oObjeto)=="limoPutrefacto"){
         resultado= 15;
      }else if(GetTag(oObjeto)=="esenciaInvisible"){
         resultado= 16;
      }else if(GetTag(oObjeto)=="x2_it_cfm_pbottl"){
         resultado= 17;
      }
      DestroyObject(oObjeto);
      oObjeto = GetNextItemInInventory(oMesa);
   }
   if(numObjetos==1){
      return resultado;
   }else{
      return 0;
   }
}

void main(){
   object oPC= GetLastClosedBy();
   object oMesa= OBJECT_SELF;
   object oBorrado;

   int paso= GetLocalInt(oMesa, "PASO");
   int objeto;
   int elaborar= FALSE;
   effect eComponente;
   switch(paso){
      case 1:
         objeto= obtenerComponente(oMesa);
         SetLocalInt(oMesa, "INGREDIENTE1", objeto);
         switch (objeto){
            case 1:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Exprimes la Baya Acuosa en la transformación...*", oPC));
               eComponente = EffectVisualEffect(149);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 2:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Deshojas la Brisa Susurrante en la transformación...*", oPC));
               eComponente = EffectVisualEffect(62);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 3:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Viertes la Resina Subterránea en la transformación...*", oPC));
               eComponente = EffectVisualEffect(353);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 4:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Trituras el Ardor Desértico sobre la transformación...*", oPC));
               eComponente = EffectVisualEffect(60);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 5:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Machacas la Raíz Pétrea en la transformación...*", oPC));
               eComponente = EffectVisualEffect(302);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 6:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Rocías la transformación con los pétalos de la Flor Luminosa...*", oPC));
               eComponente = EffectVisualEffect(98);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 7:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Introduces la Seta Nocturna en la transformación...*", oPC));
               eComponente = EffectVisualEffect(217);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 8:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Echas el Fruto Fantasma en la transformación...*", oPC));
               eComponente = EffectVisualEffect(407);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 9:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Viertes el Zumo Acuoso en la transformación...*", oPC));
               eComponente = EffectVisualEffect(149);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 10:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Agitas el Humo Gaseoso en la transformación...*", oPC));
               eComponente = EffectVisualEffect(62);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 11:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Introduces la Pasta Terrosa en la transformación...*", oPC));
               eComponente = EffectVisualEffect(251);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 12:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Sazonas la mezcla con Especia Sulfurosa...*", oPC));
               eComponente = EffectVisualEffect(60);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 13:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Pones la Picada Rocosa en la transformación...*", oPC));
               eComponente = EffectVisualEffect(302);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 14:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Espolvoreas las Virutas Resplandecientes en la transformación...*", oPC));
               eComponente = EffectVisualEffect(98);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 15:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Vuelcas el Limo Putrefacto en la transformación...*", oPC));
               eComponente = EffectVisualEffect(217);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 16:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Cubres la mezcla con la Esencia Invisible...*", oPC));
               eComponente = EffectVisualEffect(407);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            default:
               DelayCommand(0.5, FloatingTextStringOnCreature("*¡Eso no es un componente adecuado para la alquimia, se ha echado a perder la transformación!*", oPC));
               eComponente = EffectVisualEffect(57);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               DeleteLocalString(oMesa, "ALQUIMISTA");
               DeleteLocalInt(oMesa, "PASO");
               DeleteLocalInt(oMesa, "INGREDIENTE1");
               DeleteLocalInt(oMesa, "INGREDIENTE2");
               break;
         }
         break;
      case 2:
         objeto= obtenerComponente(oMesa);
         SetLocalInt(oMesa, "INGREDIENTE2", objeto);
         switch (objeto){
            case 1:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Exprimes la Baya Acuosa en la transformación...*", oPC));
               eComponente = EffectVisualEffect(149);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 2:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Deshojas la Brisa Susurrante en la transformación...*", oPC));
               eComponente = EffectVisualEffect(62);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 3:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Viertes la Resina Subterránea en la transformación...*", oPC));
               eComponente = EffectVisualEffect(353);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 4:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Trituras el Ardor Desértico sobre la transformación...*", oPC));
               eComponente = EffectVisualEffect(60);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 5:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Machacas la Raíz Pétrea en la transformación...*", oPC));
               eComponente = EffectVisualEffect(302);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 6:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Rocías la transformación con los pétalos de la Flor Luminosa...*", oPC));
               eComponente = EffectVisualEffect(98);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 7:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Introduces la Seta Nocturna en la transformación...*", oPC));
               eComponente = EffectVisualEffect(217);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 8:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Echas el Fruto Fantasma en la transformación...*", oPC));
               eComponente = EffectVisualEffect(407);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 9:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Viertes el Zumo Acuoso en la transformación...*", oPC));
               eComponente = EffectVisualEffect(149);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 10:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Agitas el Humo Gaseoso en la transformación...*", oPC));
               eComponente = EffectVisualEffect(62);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 11:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Introduces la Pasta Terrosa en la transformación...*", oPC));
               eComponente = EffectVisualEffect(251);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 12:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Sazonas la mezcla con Especia Sulfurosa...*", oPC));
               eComponente = EffectVisualEffect(60);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 13:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Pones la Picada Rocosa en la transformación...*", oPC));
               eComponente = EffectVisualEffect(302);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 14:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Espolvoreas las Virutas Resplandecientes en la transformación...*", oPC));
               eComponente = EffectVisualEffect(98);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 15:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Vuelcas el Limo Putrefacto en la transformación...*", oPC));
               eComponente = EffectVisualEffect(217);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 16:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Cubres la mezcla con la Esencia Invisible...*", oPC));
               eComponente = EffectVisualEffect(407);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               break;
            case 17:
               elaborar=TRUE;
               break;
            default:
               DelayCommand(0.5, FloatingTextStringOnCreature("*¡Eso no es un componente adecuado para la alquimia, se ha echado a perder la transformación!*", oPC));
               eComponente = EffectVisualEffect(57);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
               DeleteLocalString(oMesa, "ALQUIMISTA");
               DeleteLocalInt(oMesa, "PASO");
               DeleteLocalInt(oMesa, "INGREDIENTE1");
               DeleteLocalInt(oMesa, "INGREDIENTE2");
               break;
         }
         break;
      case 3:
         objeto= obtenerComponente(oMesa);
         if (objeto==17){
            elaborar=TRUE;
         }else{
            DelayCommand(0.5, FloatingTextStringOnCreature("*Eso no es un componente adecuado para la alquimia, se ha echado a perder la transformación!*", oPC));
            eComponente = EffectVisualEffect(57);
            DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
            DeleteLocalString(oMesa, "ALQUIMISTA");
            DeleteLocalInt(oMesa, "PASO");
            DeleteLocalInt(oMesa, "INGREDIENTE1");
            DeleteLocalInt(oMesa, "INGREDIENTE2");
         }
         break;
      default:
         oBorrado = GetFirstItemInInventory(oMesa);
         while (GetIsObjectValid(oBorrado)){
            DestroyObject(oBorrado);
            oBorrado = GetNextItemInInventory(oMesa);
         }
         break;
   }
   if(elaborar==TRUE){
      //Posibilidad de lesiones
      int iLesion = d100(1);
      if (iLesion <= 3){
         //Explosion
         if(iLesion == 1){
            int iHP = GetCurrentHitPoints(oPC);
            effect e1 = EffectAbilityDecrease(ABILITY_CHARISMA,4);
            effect e2 = EffectPolymorph(POLYMORPH_TYPE_CHICKEN, TRUE);
            effect e3 = EffectDamage(iHP/6,DAMAGE_TYPE_FIRE,DAMAGE_POWER_PLUS_TWENTY);
            DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oPC));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oPC));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, e2, oPC, HoursToSeconds(24)));
            DelayCommand(2.0, FloatingTextStringOnCreature("*¡La transformación explota y te cubre!*", oPC));
            DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(22), GetLocation(oPC)));
         //Salpicadura
         }else if(iLesion == 2){
            effect e1 = EffectAbilityDecrease(ABILITY_CHARISMA,4);
            effect e2= EffectNegativeLevel(2);
            effect e3= EffectVisualEffect(VFX_FNF_DEMON_HAND);
            DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oPC));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oPC));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oPC));
            DelayCommand(2.0, FloatingTextStringOnCreature("*¡La transformación emite un destello mágico y te ves expuesto a ella!*", oPC));
            DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(241), GetLocation(oPC)));
         //Quemadura leve
         }else{
            int iHP = GetCurrentHitPoints(oPC);
            effect e2 = EffectSleep();
            effect e3 = EffectDamage(iHP/8,DAMAGE_TYPE_FIRE,DAMAGE_POWER_PLUS_TWENTY);
            DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oPC));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, e2, oPC, TurnsToSeconds(2)));
            DelayCommand(2.0, FloatingTextStringOnCreature("*¡Inhalas vapores sedantes de la transformación!*", oPC));
            DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(97), GetLocation(oPC)));
         }
         oBorrado = GetFirstItemInInventory(oMesa);
         while (GetIsObjectValid(oBorrado)){
            DestroyObject(oBorrado);
            oBorrado = GetNextItemInInventory(oMesa);
         }
         DeleteLocalString(oMesa, "ALQUIMISTA");
         DeleteLocalInt(oMesa, "PASO");
         DeleteLocalInt(oMesa, "INGREDIENTE1");
         DeleteLocalInt(oMesa, "INGREDIENTE2");
         return;
      }

      object oBrasero= GetNearestObjectByTag("sute_her_brasero", oMesa);
      int iCorrecto= braseroCorrecto(oBrasero);
      if (iCorrecto==1){

          //Porcentaje de acceso a la formula de exito
          int iNivelHabilidad = ObtenerIntPersistente(oPC, "NIVELALQUIMIA");
          //No tiene ni el nivel 1 en la habilidad
          if (iNivelHabilidad==0){
             DelayCommand(1.5, AssignCommand(oPC,ClearAllActions(TRUE)));
             DelayCommand(1.5, FloatingTextStringOnCreature("*Quizá deberas hablar con algún Maestro de Herboristería antes de nada...*", oPC));
             return;
          }

          int iTiradaAcceso = d100();
          int iBonoTiradaAcceso = (iNivelHabilidad/4);
          // 70% a nivel 0 // 75% a nivel 20 // 85% a nivel 60 // etc. (mínimo 95%)
          if(iTiradaAcceso + iBonoTiradaAcceso >= 30){
             //Informacion de la Elaboracion a crear
             if ((GetName(oPC)=="Ukiah")||(GetName(oPC)=="Teiris")){
                SendMessageToPC(oPC, "Esta preparado: "+ GetLocalString(oBrasero, "POCIONNOMBRE")+ ", de TAG: "+ GetLocalString(oBrasero, "POCIONTAG")+ ", de base: "+ GetLocalString(oBrasero, "POCIONBASE")+ ", de Dificultad: "+ IntToString(GetLocalInt(oBrasero, "DIFICULTAD"))+ " y tu nivel de Cocina Registrado es: "+ IntToString(GetLocalInt(oBrasero, "NIVELCOCINA")));
             }
             obtenerInformacionTransformacion(oPC, oBrasero, oMesa, GetLocalInt(oMesa, "INGREDIENTE1"), GetLocalInt(oMesa, "INGREDIENTE2"));

             int iDificultad= GetLocalInt(oMesa, "DIFICULTAD");
             string sPocionNombre= GetLocalString(oMesa, "POCIONNOMBRE");
             string sPocionTag= GetLocalString(oMesa, "POCIONTAG");
             string sPocionBase= GetLocalString(oMesa, "POCIONBASE");

           if ((GetName(oPC)=="Ukiah")||(GetName(oPC)=="Teiris")){
              SendMessageToPC(oPC, "Estas transformando: "+ GetLocalString(oMesa, "POCIONNOMBRE")+ ", de TAG: "+ GetLocalString(oMesa, "POCIONTAG")+ ", de base: "+ GetLocalString(oMesa, "POCIONBASE")+ ", de Dificultad: "+ IntToString(GetLocalInt(oMesa, "DIFICULTAD"))+ " y tu nivel de Cocina Registrado es: "+ IntToString(GetLocalInt(oBrasero, "NIVELCOCINA")));
           }
           if (sPocionNombre!=""){
                 //Formula de exito
                 int iTiradaExito = d100();
                 int iBonoSab = bonoRealCaracteristicaPJ(ABILITY_WISDOM, oPC)*2;

                 //Bono Racial
                 int iRaza= GetRacialType(oPC);
                 int iBonusRacial;
                 if(PB_Race_GetIsElf(oPC)) iBonusRacial = d6();
                 else if(iRaza == RACIAL_TYPE_HUMAN) iBonusRacial = d3();
                 else if(iRaza == RACIAL_TYPE_HALFELF) iBonusRacial = d3();
                 else if(PB_Race_GetIsHalfling(oPC)) iBonusRacial = d4();
                 else iBonusRacial = 0;

                 //Probabilidad de conseguirlo
                 float fProbabilidadExito= (1-((IntToFloat((iDificultad*5)-(iNivelHabilidad*5 + iBonoSab + iBonusRacial)))/80))*100;
                 if(IntToFloat(iTiradaExito) <= (fProbabilidadExito+ IntToFloat(GetSkillRank(22,oPC))) ){
                    //Miramos si el cocinero ayudante tiene el nivel suficiente
                    int nivelAyudante= GetLocalInt(oBrasero, "NIVELCOCINA");
                    if (nivelAyudante>=iDificultad){
                        effect eExito= EffectVisualEffect(70);
                        DelayCommand(2.0, FloatingTextStringOnCreature(("*¡Has conseguido: "+ sPocionNombre+ "!*"), oPC));
                        DelayCommand(2.0, FuncionCrearObjetoYTag(sPocionBase, oPC, 1, sPocionNombre, sPocionTag));
                        DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExito, GetLocation(oMesa)));

                        //Formula de subida de nivel
                        int iTiradaAprendizaje = d100();
                        int iBonoInt = bonoRealCaracteristicaPJ(ABILITY_INTELLIGENCE, oPC);
                        float fProbablidadAprendizaje= ((IntToFloat((iDificultad*5)-(iNivelHabilidad*5)+iBonoInt))/80)*100;
                        if((iNivelHabilidad<100)&&(IntToFloat(iTiradaAprendizaje) <= fProbablidadAprendizaje)){
                           int iExperiencia = (iNivelHabilidad + 1)/2;
                           if(iExperiencia == 0) iExperiencia = 1;
                           else if(iExperiencia > 50) iExperiencia = 50;
                           DelayCommand(2.5, PlaySound("gui_level_up"));
                           DelayCommand(2.5, FloatingTextStringOnCreature("¡Has subido al nivel " + IntToString(iNivelHabilidad + 1) + " en Alquimia!", oPC));
                           DelayCommand(2.5, SetXP(oPC, GetXP(oPC) + iExperiencia));
                           GuardarIntPersistente(oPC, "NIVELALQUIMIA", iNivelHabilidad + 1);
                        }
                    }else{
                        DelayCommand(2.0, FloatingTextStringOnCreature("*¡Tu ayudante ha metido la pata!¡No es lo suficientemente bueno para colaborar en una transformación así!*", oPC));
                        eComponente = EffectVisualEffect(57);
                        DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
                    }
                 }else{
                    //Probabilidad de notar que la formula estaba bien
                    if((d20()+ iBonoSab/2)>=17){
                       DelayCommand(2.0, FloatingTextStringOnCreature(("*No has conseguido nada, pero la transformación ha reaccionado por un momento...*"), oPC));
                       effect eCasiExito= EffectVisualEffect(251);
                       DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eCasiExito, GetLocation(oMesa)));
                    }else{
                       DelayCommand(2.0, FloatingTextStringOnCreature("*¡Algo ha fallado, la poción se ha echado a perder!*", oPC));
                       eComponente = EffectVisualEffect(57);
                       DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
                    }
                 }
             }else{
                 DelayCommand(2.0, FloatingTextStringOnCreature("*¡Algo ha fallado, la transformación se ha echado a perder!*", oPC));
                 eComponente = EffectVisualEffect(57);
                 DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
             }
          }else{
            DelayCommand(2.0, FloatingTextStringOnCreature("*¡Algo ha fallado, la transformación se ha echado a perder!*", oPC));
            eComponente = EffectVisualEffect(57);
            DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
          }
      }else{
         DelayCommand(2.0, FloatingTextStringOnCreature("*¡El brasero no está a punto!¡¿Qué está haciendo tu ayudante?!*", oPC));
         eComponente = EffectVisualEffect(57);
         DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oMesa)));
      }
      DeleteLocalString(oMesa, "ALQUIMISTA");
      DeleteLocalInt(oMesa, "PASO");
      DeleteLocalInt(oMesa, "INGREDIENTE1");
      DeleteLocalInt(oMesa, "INGREDIENTE2");
      DeleteLocalString(oMesa, "POCIONNOMBRE");
      DeleteLocalString(oMesa, "POCIONTAG");
      DeleteLocalString(oMesa, "POCIONBASE");
      DeleteLocalInt(oMesa, "DIFICULTAD");
   }
}
