#include "mti_libreria"
#include "sute_libreria"
#include "lib_race"

/*Marca en la mesa la informacion de la elaboracion en curso*/
void obtenerInformacionElaboracion(object oCaldero, int ing1, int ing2, int ing3){
   string sElaboracion="";
   string sElaboracionTag="";
   string sPocionBase="";
   int iDificultad=0;
   switch(ing1){
      case 1:
         switch(ing2){
            case 1:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                    break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     sElaboracion= "Poción Curativa";
                     sElaboracionTag= "sute_her_051_045_n";
                     sPocionBase= "sute_her_con_m";
                     iDificultad= 45;
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     sElaboracion= "Poción de Agua";
                     sElaboracionTag= "sute_her_108_100_n";
                     sPocionBase= "sute_her_enc_a";
                     iDificultad= 100;
                     break;
                  default:
                     sElaboracion= "Poción Refrescante";
                     sElaboracionTag= "sute_her_008_015_n";
                     sPocionBase= "sute_her_con_b";
                     iDificultad= 15;
                     break;
               }
               break;
            case 2:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     sElaboracion= "Poción de Barrera";
                     sElaboracionTag= "sute_her_061_055_n";
                     sPocionBase= "sute_her_abj_m";
                     iDificultad= 55;
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 3:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     sElaboracion= "Poción de Protección";
                     sElaboracionTag= "sute_her_050_045_n";
                     sPocionBase= "sute_her_abj_m";
                     iDificultad= 45;
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                    //Pasta de raíz de viraguia
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 13)));
                     sElaboracionTag= "Saquitodeveneno_013";
                     sPocionBase= "cerr_ven_con";
                     iDificultad= 60;
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 4:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                    //Musgo del yo
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 21)));
                     sElaboracionTag= "Saquitodeveneno_021";
                     sPocionBase= "cerr_ven_ing";
                     iDificultad= 40;
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 5:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     sElaboracion= "Zumo mágico";
                     sElaboracionTag= "sute_her_127_075_n_DrinkHIGH";
                     sPocionBase= "sute_her_DH1";
                     iDificultad= 75;
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     sElaboracion= "Poción de Intuición";
                     sElaboracionTag= "sute_her_043_040_n";
                     sPocionBase= "sute_her_tra_m";
                     iDificultad= 40;
                     break;
               }
               break;
            case 6:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     sElaboracion= "Poción Brillante";
                     sElaboracionTag= "sute_her_015_020_n";
                     sPocionBase= "sute_her_nig_b";
                     iDificultad= 20;
                     break;
               }
               break;
            case 7:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                    //Polvo de Ungol
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 26)));
                     sElaboracionTag= "Saquitodeveneno_026";
                     sPocionBase= "cerr_ven_inh";
                     iDificultad= 50;
                     break;
                  case 5:
                     sElaboracion= "Poción Atontadora";
                     sElaboracionTag= "sute_her_060_055_n";
                     sPocionBase= "sute_her_nig_m";
                     iDificultad= 55;
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                    //Veneno de araña Mediana
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 36)));
                     sElaboracionTag= "Saquitodeveneno_036";
                     sPocionBase= "cerr_ven_her";
                     iDificultad= 40;
                     break;
                  default:
                     sElaboracion= "Poción Turbia";
                     sElaboracionTag= "sute_her_012_020_n";
                     sPocionBase= "sute_her_nig_b";
                     iDificultad= 20;
                     break;
               }
               break;
            case 8:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            default:
               sElaboracion= "Agua pura";
               //sElaboracionTag= "sute_her_001_005_n_DrinkMED"; //sute_her_DM1
               sElaboracionTag= "sute_her_DM1";
               sPocionBase= "sute_her_DM1";
               iDificultad= 5;
               break;
         }
         break;
      case 2:
         switch(ing2){
            case 1:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     sElaboracion= "Poción de Desvío";
                     sElaboracionTag= "sute_her_067_060_n";
                     sPocionBase= "sute_her_con_m";
                     iDificultad= 60;
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 2:
               switch(ing3){
                  case 1:
                     sElaboracion= "Poción Sensorial";
                     sElaboracionTag= "sute_her_046_040_n";
                     sPocionBase= "sute_her_adi_m";
                     iDificultad= 40;
                     break;
                  case 2:
                     sElaboracion= "Poción Resplandeciente";
                     sElaboracionTag= "sute_her_073_070_n";
                     sPocionBase= "sute_her_adi_m";
                     iDificultad= 70;
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     sElaboracion= "Poción Consciente";
                     sElaboracionTag= "sute_her_070_065_n";
                     sPocionBase= "sute_her_adi_m";
                     iDificultad= 65;
                     break;
                  case 6:
                     break;
                  case 7:
                     sElaboracion= "Poción Opaca";
                     sElaboracionTag= "sute_her_022_227_n";
                     sPocionBase= "sute_her_enc_b";
                     iDificultad= 30;
                     break;
                  case 8:
                     sElaboracion= "Poción de Aire";
                     sElaboracionTag= "sute_her_107_100_n";
                     sPocionBase= "sute_her_adi_a";
                     iDificultad= 100;
                     break;
                  default:
                     break;
               }
               break;
            case 3:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 4:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     sElaboracion= "Poción Aullante";
                     sElaboracionTag= "sute_her_109_080_n";
                     sPocionBase= "sute_her_abj_a";
                     iDificultad= 80;
                     break;
                  case 7:
                     break;
                  case 8:
                     sElaboracion= "Poción Translucida";
                     sElaboracionTag= "sute_her_090_075_n";
                     sPocionBase= "sute_her_ilu_a";
                     iDificultad= 75;
                     break;
                  default:
                     sElaboracion= "Poción Brumosa";
                     sElaboracionTag= "sute_her_003_010_n";
                     sPocionBase= "sute_her_abj_b";
                     iDificultad= 10;
                     break;
               }
               break;
            case 5:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     sElaboracion= "Poción de Atracción";
                     sElaboracionTag= "sute_her_042_040_n";
                     sPocionBase= "sute_her_tra_m";
                     iDificultad= 40;
                     break;
               }
               break;
            case 6:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 7:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     sElaboracion= "Poción Nocturna";
                     sElaboracionTag= "sute_her_054_050_n";
                     sPocionBase= "sute_her_tra_m";
                     iDificultad= 50;
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     sElaboracion= "Poción Repulsiva";
                     sElaboracionTag= "sute_her_058_055_n";
                     sPocionBase= "sute_her_nig_m";
                     iDificultad= 55;
                      break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     sElaboracion= "Poción Mohosa";
                     sElaboracionTag= "sute_her_014_020_n";
                     sPocionBase= "sute_her_nig_b";
                     iDificultad= 20;
                     break;
               }
               break;
            case 8:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     sElaboracion= "Poción Transparente";
                     sElaboracionTag= "sute_her_068_065_n";
                     sPocionBase= "sute_her_ilu_m";
                     iDificultad= 65;
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            default:
               sElaboracion= "Poción Acústica";
               sElaboracionTag= "sute_her_010_015_n";
               sPocionBase= "sute_her_tra_b";
               iDificultad= 15;
               break;
         }
         break;
      case 3:
         switch(ing2){
            case 1:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     sElaboracion= "Poción Nudosa";
                     sElaboracionTag= "sute_her_057_050_n";
                     sPocionBase= "sute_her_tra_m";
                     iDificultad= 50;
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 2:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 3:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     sElaboracion= "Poción Disipadora";
                     sElaboracionTag= "sute_her_074_065_n";
                     sPocionBase= "sute_her_abj_m";
                     iDificultad= 65;
                     break;
                  case 6:
                     break;
                  case 7:
                    //Esencia de sombra
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 10)));
                     sElaboracionTag= "Saquitodeveneno_010";
                     sPocionBase= "cerr_ven_her";
                     iDificultad= 70;
                     break;
                  case 8:
                     sElaboracion= "Poción de Tierra";
                     sElaboracionTag= "sute_her_106_100_n";
                     sPocionBase= "sute_her_con_a";
                     iDificultad= 100;
                     break;
                  default:
                     break;
               }
               break;
            case 4:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     sElaboracion= "Poción Polvorienta";
                     sElaboracionTag= "sute_her_072_070_n";
                     sPocionBase= "sute_her_abj_m";
                     iDificultad= 70;
                     break;
                  case 4:
                     break;
                  case 5:
                     sElaboracion= "Poción de Poder";
                     sElaboracionTag= "sute_her_095_080_n";
                     sPocionBase= "sute_her_evo_a";
                     iDificultad= 80;
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 5:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     sElaboracion= "Poción de Robustez";
                     sElaboracionTag= "sute_her_048_045_n";
                     sPocionBase= "sute_her_tra_m";
                     iDificultad= 45;
                     break;
               }
               break;
            case 6:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 7:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     sElaboracion= "Poción Debilitante";
                     sElaboracionTag= "sute_her_065_060_n";
                     sPocionBase= "sute_her_nig_m";
                     iDificultad= 60;
                    break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     sElaboracion= "Poción Inconsistente";
                     sElaboracionTag= "sute_her_017_025_n";
                     sPocionBase= "sute_her_nig_b";
                     iDificultad= 25;
                     break;
               }
               break;
            case 8:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            default:
               sElaboracion= "Poción de Aislamiento";
               sElaboracionTag= "sute_her_009_015_n";
               sPocionBase= "sute_her_abj_b";
               iDificultad= 15;
               break;
         }
         break;
      case 4:
         switch(ing2){
            case 1:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 2:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     sElaboracion= "Poción Volátil";
                     sElaboracionTag= "sute_her_098_085_n";
                     sPocionBase= "sute_her_tra_a";
                     iDificultad= 85;
                     break;
                  case 6:
                     break;
                  case 7:
                     sElaboracion= "Poción Densa";
                     sElaboracionTag= "sute_her_025_035_n";
                     sPocionBase= "sute_her_tra_b";
                     iDificultad= 35;
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 3:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     sElaboracion= "Poción Corrosiva";
                     sElaboracionTag= "sute_her_097_085_n";
                     sPocionBase= "sute_her_con_a";
                     iDificultad= 85;
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     sElaboracion= "Poción de Furia";
                     sElaboracionTag= "sute_her_104_095_n";
                     sPocionBase= "sute_her_tra_a";
                     iDificultad= 95;
                     break;
                  default:
                     break;
               }
               break;
            case 4:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     sElaboracion= "Poción Furiosa";
                     sElaboracionTag= "sute_her_023_035_n";
                     sPocionBase= "sute_her_tra_b";
                     iDificultad= 35;
                     break;
                  case 6:
                     sElaboracion= "Poción Calorífica";
                     sElaboracionTag= "sute_her_100_090_n";
                     sPocionBase= "sute_her_evo_a";
                     iDificultad= 90;
                     break;
                  case 7:
                    //Hoja mortal
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 12)));
                     sElaboracionTag= "Saquitodeveneno_012";
                     sPocionBase= "cerr_ven_her";
                     iDificultad= 90;
                     break;
                  case 8:
                     sElaboracion= "Poción de Fuego";
                     sElaboracionTag= "sute_her_105_100_n";
                     sPocionBase= "sute_her_evo_a";
                     iDificultad= 100;
                     break;
                  default:
                     sElaboracion= "Poción Agitada";
                     sElaboracionTag= "sute_her_045_040_n";
                     sPocionBase= "sute_her_tra_m";
                     iDificultad= 40;
                     break;
               }
               break;
            case 5:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     sElaboracion= "Poción de Agilidad";
                     sElaboracionTag= "sute_her_049_045_n";
                     sPocionBase= "sute_her_tra_m";
                     iDificultad= 45;
                   break;
               }
               break;
            case 6:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     sElaboracion= "Poción de Guerra";
                     sElaboracionTag= "sute_her_099_090_n";
                     sPocionBase= "sute_her_evo_a";
                     iDificultad= 90;
                     break;
                  case 6:
                     sElaboracion= "Poción Tenaz";
                     sElaboracionTag= "sute_her_093_080_n";
                     sPocionBase= "sute_her_abj_a";
                     iDificultad= 80;
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 7:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                    //Relinchos azules
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 8)));
                     sElaboracionTag= "Saquitodeveneno_008";
                     sPocionBase= "cerr_ven_her";
                     iDificultad= 40;
                     break;
                  case 4:
                     break;
                  case 5:
                     sElaboracion= "Poción Agarrotadora";
                     sElaboracionTag= "sute_her_064_060_n";
                     sPocionBase= "sute_her_nig_m";
                     iDificultad= 60;
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     sElaboracion= "Poción Viscosa";
                     sElaboracionTag= "sute_her_018_025_n";
                     sPocionBase= "sute_her_nig_b";
                     iDificultad= 25;
                     break;
               }
               break;
            case 8:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            default:
               sElaboracion= "Poción Radiante";
               sElaboracionTag= "sute_her_007_010_n";
               sPocionBase= "sute_her_evo_b";
               iDificultad= 10;
               break;
         }
         break;
      case 5:
         switch(ing2){
            case 1:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 2:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 3:
               switch(ing3){
                  case 1:
                     sElaboracion= "Poción Reparadora";
                     sElaboracionTag= "sute_her_055_050_n";
                     sPocionBase= "sute_her_con_m";
                     iDificultad= 50;
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 4:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                    //Extracto de loto negro
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 19)));
                     sElaboracionTag= "Saquitodeveneno_019";
                     sPocionBase= "cerr_ven_con";
                     iDificultad= 90;
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 5:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     sElaboracion= "Galleta mágica";
                     sElaboracionTag= "sute_her_128_075_n_FoodRICH";
                     sPocionBase= "sute_her_FR1";
                     iDificultad= 75;
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     sElaboracion= "Poción Evolutiva";
                     sElaboracionTag= "sute_her_071_070_n";
                     sPocionBase= "sute_her_tra_m";
                     iDificultad= 70;
                     break;
                  default:
                     sElaboracion= "Poción de Dureza";
                     sElaboracionTag= "sute_her_047_045_n";
                     sPocionBase= "sute_her_tra_m";
                     iDificultad= 45;
                     break;
               }
               break;
            case 6:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 7:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     sElaboracion= "Poción Malsana";
                     sElaboracionTag= "sute_her_063_060_n";
                     sPocionBase= "sute_her_nig_m";
                     iDificultad= 60;
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     sElaboracion= "Poción Grumosa";
                     sElaboracionTag= "sute_her_019_025_n";
                     sPocionBase= "sute_her_nig_b";
                     iDificultad= 25;
                     break;
               }
               break;
            case 8:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            default:
               sElaboracion= "Raíces comestibles";
               sElaboracionTag= "sute_her_002_005_n_FoodNORM";
               sPocionBase= "sute_her_FN1";
               iDificultad= 5;
               break;
         }
         break;
      case 6:
         switch(ing2){
            case 1:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     sElaboracion= "Poción Negra";
                     sElaboracionTag= "sute_her_091_075_n";
                     sPocionBase= "sute_her_abj_a";
                     iDificultad= 75;
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 2:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 3:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 4:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     sElaboracion= "Poción de Soporte";
                     sElaboracionTag= "sute_her_024_035_n";
                     sPocionBase= "sute_her_enc_b";
                     iDificultad= 35;
                     break;
                  }
               break;
            case 5:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 6:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     sElaboracion= "Poción de Ascenso";
                     sElaboracionTag= "sute_her_103_095_n";
                     sPocionBase= "sute_her_abj_a";
                     iDificultad= 95;
                     break;
                  default:
                     break;
               }
               break;
            case 7:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                    //Raíz de sanguinaria
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 4)));
                     sElaboracionTag= "Saquitodeveneno_004";
                     sPocionBase= "cerr_ven_her";
                     iDificultad= 20;
                     break;
               }
               break;
            case 8:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            default:
               sElaboracion= "Poción de Perseverancia";
               sElaboracionTag= "sute_her_011_015_n";
               sPocionBase= "sute_her_abj_b";
               iDificultad= 15;
               break;
         }
         break;
      case 7:
         switch(ing2){
            case 1:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                    //Polvo de liche
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 24)));
                     sElaboracionTag= "Saquitodeveneno_024";
                     sPocionBase= "cerr_ven_ing";
                     iDificultad= 70;
                     break;
                  case 5:
                     sElaboracion= "Poción Carmesí";
                     sElaboracionTag= "sute_her_056_050_n";
                     sPocionBase= "sute_her_nig_m";
                     iDificultad= 50;
                    break;
                  case 6:
                     sElaboracion= "Poción Blanca";
                     sElaboracionTag= "sute_her_092_075_n";
                     sPocionBase= "sute_her_abj_a";
                     iDificultad= 75;
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     sElaboracion= "Poción Rojiza";
                     sElaboracionTag= "sute_her_016_020_n";
                     sPocionBase= "sute_her_nig_b";
                     iDificultad= 20;
                     break;
               }
               break;
            case 2:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                    //Bilis de dragón
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 15)));
                     sElaboracionTag= "Saquitodeveneno_015";
                     sPocionBase= "cerr_ven_con";
                     iDificultad= 100;
                     break;
                  case 5:
                     break;
                  case 6:
                    //Niebla del caos
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 28)));
                     sElaboracionTag= "Saquitodeveneno_028";
                     sPocionBase= "cerr_ven_inh";
                     iDificultad= 50;
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                    //Vomicalia
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 14)));
                     sElaboracionTag= "Saquitodeveneno_014";
                     sPocionBase= "cerr_ven_con";
                     iDificultad= 30;
                     break;
               }
               break;
            case 3:
               switch(ing3){
                  case 1:
                    //Aceite de gárrala
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 20)));
                     sElaboracionTag= "Saquitodeveneno_020";
                     sPocionBase= "cerr_ven_ing";
                     iDificultad= 50;
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     sElaboracion= "Poción Blanquecina";
                     sElaboracionTag= "sute_her_021_030_n";
                     sPocionBase= "sute_her_tra_b";
                     iDificultad= 30;
                     break;
                  case 5:
                    //Pólvoras de asaltante oscuro
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 25)));
                     sElaboracionTag= "Saquitodeveneno_025";
                     sPocionBase= "cerr_ven_ing";
                     iDificultad= 80;
                     break;
                  case 6:
                     break;
                  case 7:
                    //Residuo de hoja de cativera
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 16)));
                     sElaboracionTag= "Saquitodeveneno_016";
                     sPocionBase= "cerr_ven_con";
                     iDificultad= 60;
                     break;
                  case 8:
                     break;
                  default:
                     sElaboracion= "Poción Férrea";
                     sElaboracionTag= "sute_her_004_010_n";
                     sPocionBase= "sute_her_abj_b";
                     iDificultad= 10;
                     break;
               }
               break;
            case 4:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                    //Veneno de draco
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 7)));
                     sElaboracionTag= "Saquitodeveneno_007";
                     sPocionBase= "cerr_ven_her";
                     iDificultad= 70;
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     sElaboracion= "Poción Oscura";
                     sElaboracionTag= "sute_her_094_080_n";
                     sPocionBase= "sute_her_nig_a";
                     iDificultad= 80;
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                    //Seta listada
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 22)));
                     sElaboracionTag= "Saquitodeveneno_022";
                     sPocionBase= "cerr_ven_ing";
                     iDificultad= 10;
                     break;
               }
               break;
            case 5:
               switch(ing3){
                  case 1:
                     sElaboracion= "Poción Reconfortante";
                     sElaboracionTag= "sute_her_020_030_n";
                     sPocionBase= "sute_her_con_b";
                     iDificultad= 30;
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                    //Veneno de escorpión Grande
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 6)));
                     sElaboracionTag= "Saquitodeveneno_006";
                     sPocionBase= "cerr_ven_her";
                     iDificultad= 80;
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                    break;
                  case 8:
                     break;
                  default:
                    //Arsénico
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 23)));
                     sElaboracionTag= "Saquitodeveneno_023";
                     sPocionBase= "cerr_ven_ing";
                     iDificultad= 30;
                     break;
               }
               break;
            case 6:
               switch(ing3){
                  case 1:
                     sElaboracion= "Poción de Alivio";
                     sElaboracionTag= "sute_her_066_060_n";
                     sPocionBase= "sute_her_con_m";
                     iDificultad= 60;
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                    //Efluvios somarreros
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 27)));
                     sElaboracionTag= "Saquitodeveneno_027";
                     sPocionBase= "cerr_ven_inh";
                     iDificultad= 80;
                     break;
                  case 6:
                     sElaboracion= "Poción de Supervivencia";
                     sElaboracionTag= "sute_her_110_080_n";
                     sPocionBase= "sute_her_abj_a";
                     iDificultad= 80;
                     break;
                  case 7:
                    //Veneno de avispa gigante
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 9)));
                     sElaboracionTag= "Saquitodeveneno_009";
                     sPocionBase= "cerr_ven_her";
                     iDificultad= 80;
                     break;
                  case 8:
                     break;
                  default:
                    //Aceite de sangreverde
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 3)));
                     sElaboracionTag= "Saquitodeveneno_003";
                     sPocionBase= "cerr_ven_her";
                     iDificultad= 30;
                     break;
               }
               break;
            case 7:
               switch(ing3){
                  case 1:
                     sElaboracion= "Poción Purificadora";
                     sElaboracionTag= "sute_her_041_040_n";
                     sPocionBase= "sute_her_con_m";
                     iDificultad= 40;
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     sElaboracion= "Poción Omniosa";
                     sElaboracionTag= "sute_her_053_050_n";
                     sPocionBase= "sute_her_tra_m";
                     iDificultad= 50;
                     break;
                  case 6:
                     sElaboracion= "Poción Vital";
                     sElaboracionTag= "sute_her_096_085_n";
                     sPocionBase= "sute_her_nig_a";
                     iDificultad= 85;
                     break;
                  case 7:
                    //Raíz de terinav
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 17)));
                     sElaboracionTag= "Saquitodeveneno_017";
                     sPocionBase= "cerr_ven_con";
                     iDificultad= 60;
                     break;
                  case 8:
                     sElaboracion= "Poción de Descenso";
                     sElaboracionTag= "sute_her_102_095_n";
                     sPocionBase= "sute_her_nig_a";
                     iDificultad= 95;
                     break;
                  default:
                    //Veneno de víbora negra
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 11)));
                     sElaboracionTag= "Saquitodeveneno_011";
                     sPocionBase= "cerr_ven_her";
                     iDificultad= 20;
                     break;
               }
               break;
            case 8:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     sElaboracion= "Poción Bendita";
                     sElaboracionTag= "sute_her_062_060_n";
                     sPocionBase= "sute_her_abj_m";
                     iDificultad= 60;
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                    //Veneno de ciempiés pequeño
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 1)));
                     sElaboracionTag= "Saquitodeveneno_001";
                     sPocionBase= "cerr_ven_her";
                     iDificultad= 10;
                     break;
               }
               break;
            default:
               sElaboracion= "Poción Descorazonadora";
               sElaboracionTag= "sute_her_005_010_n";
               sPocionBase= "sute_her_enc_b";
               iDificultad= 10;
               break;
         }
         break;
      case 8:
         switch(ing2){
            case 1:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     sElaboracion= "Poción Antimagia";
                     sElaboracionTag= "sute_her_101_090_n";
                     sPocionBase= "sute_her_enc_a";
                     iDificultad= 90;
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 2:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     sElaboracion= "Poción de Lentitud";
                     sElaboracionTag= "sute_her_026_035_n";
                     sPocionBase= "sute_her_adi_b";
                     iDificultad= 35;
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 3:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 4:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 5:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     sElaboracion= "Poción de Deducción";
                     sElaboracionTag= "sute_her_044_040_n";
                     sPocionBase= "sute_her_tra_b";
                     iDificultad= 40;
                     break;
               }
               break;
            case 6:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     sElaboracion= "Poción de Absorción";
                     sElaboracionTag= "sute_her_069_065_n";
                     sPocionBase= "sute_her_abj_m";
                     iDificultad= 65;
                     break;
                  case 4:
                     break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            case 7:
               switch(ing3){
                  case 1:
                    //Veneno de gusano púrpura
                     sElaboracion= GetStringByStrRef(StringToInt(Get2DAString("poison", "Name", 5)));
                     sElaboracionTag= "Saquitodeveneno_005";
                     sPocionBase= "cerr_ven_her";
                     iDificultad= 100;
                     break;
                  case 2:
                     sElaboracion= "Poción de Verdad";
                     sElaboracionTag= "sute_her_089_075_n";
                     sPocionBase= "sute_her_adi_a";
                     iDificultad= 75;
                     break;
                  case 3:
                     break;
                  case 4:
                     break;
                  case 5:
                     sElaboracion= "Poción Obtusa";
                     sElaboracionTag= "sute_her_059_055_n";
                     sPocionBase= "sute_her_nig_m";
                     iDificultad= 55;
                    break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     sElaboracion= "Poción Desconcertante";
                     sElaboracionTag= "sute_her_013_020_n";
                     sPocionBase= "sute_her_nig_b";
                     iDificultad= 20;
                     break;
               }
               break;
            case 8:
               switch(ing3){
                  case 1:
                     break;
                  case 2:
                     break;
                  case 3:
                     break;
                  case 4:
                     sElaboracion= "Poción Borrosa";
                     sElaboracionTag= "sute_her_052_050_n";
                     sPocionBase= "sute_her_ilu_m";
                     iDificultad= 50;
                    break;
                  case 5:
                     break;
                  case 6:
                     break;
                  case 7:
                     break;
                  case 8:
                     break;
                  default:
                     break;
               }
               break;
            default:
               sElaboracion= "Poción Mística";
               sElaboracionTag= "sute_her_006_010_n";
               sPocionBase= "sute_her_enc_b";
               iDificultad= 10;
               break;
         }
         break;
      default:
        break;
   }
   SetLocalString(oCaldero, "ELABORACION", sElaboracion);
   SetLocalString(oCaldero, "ELABORACIONTAG", sElaboracionTag);
   SetLocalString(oCaldero, "POCIONBASE", sPocionBase);
   SetLocalInt(oCaldero, "DIFICULTAD", iDificultad);
}

/*Obtiene el ingrediente introducido en el caldero:
 *   0: objeto invalido o mas de un objeto
 *   1-8: ingrediente
 *   9: botella
 */
int obtenerComponente(object oCaldero){
   object oObjeto;
   int numObjetos= 0;
   int resultado= 0;

   oObjeto = GetFirstItemInInventory(oCaldero);
   while (GetIsObjectValid(oObjeto)){
      numObjetos= numObjetos+1;
      if(GetTag(oObjeto)=="zumoAcuoso"){
         resultado= 1;
      }else if(GetTag(oObjeto)=="humoGaseoso"){
         resultado= 2;
      }else if(GetTag(oObjeto)=="pastaTerrosa"){
         resultado= 3;
      }else if(GetTag(oObjeto)=="especiaSulfurosa"){
         resultado= 4;
      }else if(GetTag(oObjeto)=="picadaRocosa"){
         resultado= 5;
      }else if(GetTag(oObjeto)=="virutasResplandecientes"){
         resultado= 6;
      }else if(GetTag(oObjeto)=="limoPutrefacto"){
         resultado= 7;
      }else if(GetTag(oObjeto)=="esenciaInvisible"){
         resultado= 8;
      }else if(GetTag(oObjeto)=="x2_it_cfm_pbottl"){
         resultado= 9;
      }
      DestroyObject(oObjeto);
      oObjeto = GetNextItemInInventory(oCaldero);
   }
   if(numObjetos==1){
      return resultado;
   }else{
      return 0;
   }
}


void main(){
   object oPC= GetLastClosedBy();
   object oCaldero= OBJECT_SELF;
   object oBorrado;

   int paso= GetLocalInt(oCaldero, "PASO");
   int objeto;
   int elaborar= FALSE;
   effect eComponente;
   switch(paso){
      case 1:
         objeto= obtenerComponente(oCaldero);
         SetLocalInt(oCaldero, "INGREDIENTE1", objeto);
         switch (objeto){
            case 1:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Viertes el Zumo Acuoso en la poción...*", oPC));
               eComponente = EffectVisualEffect(149);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            case 2:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Agitas el Humo Gaseoso en la poción...*", oPC));
               eComponente = EffectVisualEffect(62);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            case 3:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Introduces la Pasta Terrosa en la poción...*", oPC));
               eComponente = EffectVisualEffect(353);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            case 4:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Sazonas la poción con Especia Sulfurosa...*", oPC));
               eComponente = EffectVisualEffect(60);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            case 5:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Pones la Picada Rocosa en la poción...*", oPC));
               eComponente = EffectVisualEffect(302);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            case 6:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Espolvoreas las Virutas Resplandecientes en la poción...*", oPC));
               eComponente = EffectVisualEffect(98);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            case 7:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Vuelcas el Limo Putrefacto en la poción...*", oPC));
               eComponente = EffectVisualEffect(217);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            case 8:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Cubres la poción con la Esencia Invisible...*", oPC));
               eComponente = EffectVisualEffect(407);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            default:
               DelayCommand(0.5, FloatingTextStringOnCreature("*¡Eso no es un ingrediente adecuado para la poción, se ha echado a perder!*", oPC));
               eComponente = EffectVisualEffect(57);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               DeleteLocalString(oCaldero, "HERBOLARIO");
               DeleteLocalInt(oCaldero, "PASO");
               DeleteLocalInt(oCaldero, "INGREDIENTE1");
               DeleteLocalInt(oCaldero, "INGREDIENTE2");
               DeleteLocalInt(oCaldero, "INGREDIENTE3");
               break;
         }
         break;
      case 2:
         objeto= obtenerComponente(oCaldero);
         SetLocalInt(oCaldero, "INGREDIENTE2", objeto);
         switch (objeto){
            case 1:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Viertes el Zumo Acuoso en la poción...*", oPC));
               eComponente = EffectVisualEffect(149);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            case 2:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Agitas el Humo Gaseoso en la poción...*", oPC));
               eComponente = EffectVisualEffect(62);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            case 3:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Introduces la Pasta Terrosa en la poción...*", oPC));
               eComponente = EffectVisualEffect(353);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            case 4:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Sazonas la poción con Especia Sulfurosa...*", oPC));
               eComponente = EffectVisualEffect(60);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            case 5:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Pones la Picada Rocosa en la poción...*", oPC));
               eComponente = EffectVisualEffect(302);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            case 6:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Espolvoreas las Virutas Resplandecientes en la poción...*", oPC));
               eComponente = EffectVisualEffect(98);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            case 7:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Vuelcas el Limo Putrefacto en la poción...*", oPC));
               eComponente = EffectVisualEffect(217);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            case 8:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Cubres la poción con la Esencia Invisible...*", oPC));
               eComponente = EffectVisualEffect(407);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            case 9:
               elaborar=TRUE;
               break;
            default:
               DelayCommand(0.5, FloatingTextStringOnCreature("*¡Eso no es un ingrediente adecuado para la poción, se ha echado a perder!*", oPC));
               eComponente = EffectVisualEffect(57);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               DeleteLocalString(oCaldero, "HERBOLARIO");
               DeleteLocalInt(oCaldero, "PASO");
               DeleteLocalInt(oCaldero, "INGREDIENTE1");
               DeleteLocalInt(oCaldero, "INGREDIENTE2");
               DeleteLocalInt(oCaldero, "INGREDIENTE3");
               break;
         }
         break;
      case 3:
         objeto= obtenerComponente(oCaldero);
         SetLocalInt(oCaldero, "INGREDIENTE3", objeto);
         switch (objeto){
            case 1:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Viertes el Zumo Acuoso en la poción...*", oPC));
               eComponente = EffectVisualEffect(149);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            case 2:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Agitas el Humo Gaseoso en la poción...*", oPC));
               eComponente = EffectVisualEffect(62);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            case 3:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Introduces la Pasta Terrosa en la poción...*", oPC));
               eComponente = EffectVisualEffect(353);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            case 4:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Sazonas la poción con Especia Sulfurosa...*", oPC));
               eComponente = EffectVisualEffect(60);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            case 5:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Pones la Picada Rocosa en la poción...*", oPC));
               eComponente = EffectVisualEffect(302);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            case 6:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Espolvoreas las Virutas Resplandecientes en la poción...*", oPC));
               eComponente = EffectVisualEffect(98);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            case 7:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Vuelcas el Limo Putrefacto en la poción...*", oPC));
               eComponente = EffectVisualEffect(217);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            case 8:
               DelayCommand(0.5, FloatingTextStringOnCreature("*Cubres la poción con la Esencia Invisible...*", oPC));
               eComponente = EffectVisualEffect(407);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               break;
            case 9:
               elaborar=TRUE;
               break;
            default:
               DelayCommand(0.5, FloatingTextStringOnCreature("*¡Eso no es un ingrediente adecuado para la poción, se ha echado a perder!*", oPC));
               eComponente = EffectVisualEffect(57);
               DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
               DeleteLocalString(oCaldero, "HERBOLARIO");
               DeleteLocalInt(oCaldero, "PASO");
               DeleteLocalInt(oCaldero, "INGREDIENTE1");
               DeleteLocalInt(oCaldero, "INGREDIENTE2");
               DeleteLocalInt(oCaldero, "INGREDIENTE3");
               break;
         }
         break;
      case 4:
         objeto= obtenerComponente(oCaldero);
         if (objeto==9){
            elaborar=TRUE;
         }else{
            DelayCommand(0.5, FloatingTextStringOnCreature("*¡Eso no es un ingrediente adecuado para la poción, se ha echado a perder!*", oPC));
            eComponente = EffectVisualEffect(57);
            DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
            DeleteLocalString(oCaldero, "HERBOLARIO");
            DeleteLocalInt(oCaldero, "PASO");
            DeleteLocalInt(oCaldero, "INGREDIENTE1");
            DeleteLocalInt(oCaldero, "INGREDIENTE2");
            DeleteLocalInt(oCaldero, "INGREDIENTE3");
         }
         break;
      default:
         oBorrado = GetFirstItemInInventory(oCaldero);
         while (GetIsObjectValid(oBorrado)){
            DestroyObject(oBorrado);
            oBorrado = GetNextItemInInventory(oCaldero);
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
            effect e2 = EffectAbilityDecrease(ABILITY_DEXTERITY,4);
            effect e3 = EffectDamage(iHP/2,DAMAGE_TYPE_FIRE,DAMAGE_POWER_PLUS_TWENTY);
            DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oPC));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oPC));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oPC));
            DelayCommand(2.0, FloatingTextStringOnCreature("*¡La poción ha explotado!*", oPC));
            DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(22), GetLocation(oPC)));
         //Salpicadura
         }else if(iLesion == 2){
            effect e1 = EffectAbilityDecrease(ABILITY_CHARISMA,4);
            effect e2= EffectBlindness();
            effect e3= EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
            DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oPC));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oPC));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oPC));
            DelayCommand(2.0, FloatingTextStringOnCreature("*¡La poción te salpica en la cara!*", oPC));
            DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(61), GetLocation(oPC)));
         //Quemadura leve
         }else{
            int iHP = GetCurrentHitPoints(oPC);
            effect e1 = EffectAbilityDecrease(ABILITY_CHARISMA,2);
            effect e2 = EffectAbilityDecrease(ABILITY_DEXTERITY,2);
            effect e3 = EffectDamage(iHP/8,DAMAGE_TYPE_ACID,DAMAGE_POWER_PLUS_TWENTY);
            DelayCommand(2.0, AssignCommand(oPC,ClearAllActions(TRUE)));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, oPC));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oPC));
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oPC));
            DelayCommand(2.0, FloatingTextStringOnCreature("*¡Te has quemado la mano!*", oPC));
            DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(61), GetLocation(oPC)));
         }
         oBorrado = GetFirstItemInInventory(oCaldero);
         while (GetIsObjectValid(oBorrado)){
            DestroyObject(oBorrado);
            oBorrado = GetNextItemInInventory(oCaldero);
         }
         return;
      }

      //Porcentage de acceso a la formula de exito
      int iNivelHabilidad = ObtenerIntPersistente(oPC, "NIVELHERBOLOGIA");
      //No tiene ni el nivel 1 en la habilidad
      if (iNivelHabilidad==0){
         DelayCommand(1.5, AssignCommand(oPC,ClearAllActions(TRUE)));
         DelayCommand(1.5, FloatingTextStringOnCreature("*Quizá deberías hablar con algún Maestro de Herboristería antes de nada...*", oPC));
         return;
      }

      int iTiradaAcceso = d100();
      int iBonoTiradaAcceso = (iNivelHabilidad/4);
      // 70% a nivel 0 // 75% a nivel 20 // 85% a nivel 60 // etc. (mínimo 95%)
      if(iTiradaAcceso + iBonoTiradaAcceso >= 30){
         //Informacion de la Elaboracion a crear
         obtenerInformacionElaboracion(oCaldero,
                                       GetLocalInt(oCaldero, "INGREDIENTE1"),
                                       GetLocalInt(oCaldero, "INGREDIENTE2"),
                                       GetLocalInt(oCaldero, "INGREDIENTE3"));

         int iDificultad= GetLocalInt(oCaldero, "DIFICULTAD");
         string sElaboracion= GetLocalString(oCaldero, "ELABORACION");
         string sElaboracionTag= GetLocalString(oCaldero, "ELABORACIONTAG");
         string sPocionBase= GetLocalString(oCaldero, "POCIONBASE");

         if(sElaboracion!=""){
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
             if(IntToFloat(iTiradaExito) <= (fProbabilidadExito + IntToFloat(GetSkillRank(22,oPC))) ){
                effect eExito= EffectVisualEffect(70);
                DelayCommand(2.0, FloatingTextStringOnCreature(("*¡Has conseguido: "+ sElaboracion+ "!*"), oPC));
                DelayCommand(2.0, FuncionCrearObjetoYTag(sPocionBase, oPC, 1, sElaboracion, sElaboracionTag));
                DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExito, GetLocation(oCaldero)));

                //Formula de subida de nivel
                int iTiradaAprendizaje = d100();
                int iBonoInt = bonoRealCaracteristicaPJ(ABILITY_INTELLIGENCE, oPC);
                float fProbablidadAprendizaje= ((IntToFloat((iDificultad*5)-(iNivelHabilidad*5)+iBonoInt))/80)*100;
                if((iNivelHabilidad<100)&&(IntToFloat(iTiradaAprendizaje) <= fProbablidadAprendizaje)){
                   int iExperiencia = (iNivelHabilidad + 1)/2;
                   if(iExperiencia == 0) iExperiencia = 1;
                   else if(iExperiencia > 50) iExperiencia = 50;
                   DelayCommand(2.5, PlaySound("gui_level_up"));
                   DelayCommand(2.5, FloatingTextStringOnCreature("¡Has subido al nivel " + IntToString(iNivelHabilidad + 1) + " en Herbología!", oPC));
                   DelayCommand(2.5, SetXP(oPC, GetXP(oPC) + iExperiencia));
                   GuardarIntPersistente(oPC, "NIVELHERBOLOGIA", iNivelHabilidad + 1);
                }
             }else{
                //Probabilidad de notar que la formula estaba bien
                if((d20()+ iBonoSab/2)>=17){
                   DelayCommand(2.0, FloatingTextStringOnCreature(("*No has conseguido nada, pero la poción ha reaccionado por un momento...*"), oPC));
                   effect eCasiExito= EffectVisualEffect(251);
                   DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eCasiExito, GetLocation(oCaldero)));
                }else{
                   DelayCommand(2.0, FloatingTextStringOnCreature("*¡Algo ha fallado, la poción se ha echado a perder!*", oPC));
                   eComponente = EffectVisualEffect(57);
                   DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
                }
             }
         }else{
            DelayCommand(2.0, FloatingTextStringOnCreature("*¡Algo ha fallado, la poción se ha echado a perder!*", oPC));
            eComponente = EffectVisualEffect(57);
            DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
         }
      }else{
         DelayCommand(2.0, FloatingTextStringOnCreature("*¡Algo ha fallado, la poción se ha echado a perder!*", oPC));
         eComponente = EffectVisualEffect(57);
         DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eComponente, GetLocation(oCaldero)));
      }
      DeleteLocalString(oCaldero, "HERBOLARIO");
      DeleteLocalInt(oCaldero, "PASO");
      DeleteLocalInt(oCaldero, "INGREDIENTE1");
      DeleteLocalInt(oCaldero, "INGREDIENTE2");
      DeleteLocalInt(oCaldero, "INGREDIENTE3");
      DeleteLocalString(oCaldero, "ELABORACION");
      DeleteLocalString(oCaldero, "ELABORACIONTAG");
      DeleteLocalString(oCaldero, "POCIONBASE");
      DeleteLocalInt(oCaldero, "DIFICULTAD");
   }
}
