//******************************************************************************
// Archivo de configuracion para Sistema Generador de Tesoros
//* Nombre de archivo: gt_ubic_cfg
//* Autor: Tomas GB
//******************************************************************************

//****** UBICADOS *******

/*
--------------------------------------------------------------------------------
El sistema de tesoros para contenedores ubicados usa el sistema de ordenacion
estandar de la paleta de tesoros del aurora. Tesoros Unicos, Altos, Medios y Bajos.

Parametros de configuracion:

UBICADO_COFRE_XX
    Parametro de configuracion del cofre del sistema de tesoros.
    xxxx_xxxxxxxx
    Los primeros 4 digitos configuran el nivel del cofre (epic, alto, medi, peke)
    Si en estos 4 digitos se indica null el cofre queda desactivado para generar
    tesoros en contenedores ubicados.
    Los ultimos 8 digitos le dicen al sistema si el cofre en cuestion generara
    tesoro en el contenedor ubicado correspondiente.
    Los contenedores ubicados son: (0 desactiva, 1 activa)
        Aparatos de alquimista
        Armario con cerradura
        Cofre
        Estantería
        Panoplia de armadura
        Panoplia de armas
        Panoplia de armas a distancia
        Panoplia de armas cuerpo a cuerpo
        Panoplia de armas grandes

    Por ejemplo:

    epic_011011111 le diria al sistema que el cofre del sistema de tesoros es epico
                   y generaria tesoro en los sigientes ubicados Armario con cerradura,
                   Cofre, Panoplia de armadura, Panoplia de armas, Panoplia de armas a distancia,
                   Panoplia de armas cuerpo a cuerpo y Panoplia de armas grandes
--------------------------------------------------------------------------------
*/
int SGT_OBJETOFIJO = 600;                       //Tiempo de regeneracion de objetos fijos

int TG_EPICO = 90;                              //Tiempo de regeneracion para contenedores ubicados epicos.
int TG_ALTO = 60;                               //Tiempo de regeneracion para contenedores ubicados altos.
int TG_MEDIO = 30;                              //Tiempo de regeneracion para contenedores ubicados medios.
int TG_PEKENO = 15;                             //Tiempo de regeneracion para contenedores ubicados bajos.

int PROB_ORO_UBI = 30;                          //Probabilidad de generar oro en el contenedor ubicado.
int ORO_UBI_EPIC = 4000;                        //Cantidad maxima de oro generado para contenedores ubicados epicos (aleatorio)
int ORO_UBI_ALTO = 2000;                        //Cantidad maxima de oro generado para contenedores ubicados altos (aleatorio)
int ORO_UBI_MED = 1000;                         //Cantidad maxima de oro generado para contenedores ubicados medios (aleatorio)
int ORO_UBI_BAJO = 500;                         //Cantidad maxima de oro generado para contenedores ubicados bajos (aleatorio)

string UBICADO_COFRE_01 = "epic_011011111";
int UBICADO_TIRADAS_COFRE_01 = 1;
int UBICADO_PROBABILIDAD_COFRE_01 = 5;          //Armas y Armaduras Epicas-Objetos mayor nivel 20 o superior a +5
int UBICADO_PORCENTAGE_COFRE_01 = 100;
int UBICADO_APILAR_COFRE_01 = 1;

string UBICADO_COFRE_02 = "epic_011000000";
int UBICADO_TIRADAS_COFRE_02 = 1;
int UBICADO_PROBABILIDAD_COFRE_02 = 5;          //Objetos Miscelaneos Epicos-Objetos mayor nivel 20 o superior a +5
int UBICADO_PORCENTAGE_COFRE_02 = 100;
int UBICADO_APILAR_COFRE_02 = 1;

string UBICADO_COFRE_03 = "alto_011011111";
int UBICADO_TIRADAS_COFRE_03 = 1;
int UBICADO_PROBABILIDAD_COFRE_03 = 10;         //Armas y Armaduras Alto-Objetos nivel 14 a 20
int UBICADO_PORCENTAGE_COFRE_03 = 100;
int UBICADO_APILAR_COFRE_03 = 1;

string UBICADO_COFRE_04 = "alto_011000000";
int UBICADO_TIRADAS_COFRE_04 = 1;
int UBICADO_PROBABILIDAD_COFRE_04 = 10;         //Miscelaneo Alto-Objetos nivel 14 a 20
int UBICADO_PORCENTAGE_COFRE_04 = 100;
int UBICADO_APILAR_COFRE_04 = 1;

string UBICADO_COFRE_05 = "medi_011011111";
int UBICADO_TIRADAS_COFRE_05 = 1;
int UBICADO_PROBABILIDAD_COFRE_05 = 20;         //Armas y Armaduras Medio-Objetos nivel 7 a 13
int UBICADO_PORCENTAGE_COFRE_05 = 100;
int UBICADO_APILAR_COFRE_05 = 1;

string UBICADO_COFRE_06 = "medi_011000000";
int UBICADO_TIRADAS_COFRE_06 = 1;
int UBICADO_PROBABILIDAD_COFRE_06 = 20;         //Miscelaneo Medio-Objetos nivel 7 a 13
int UBICADO_PORCENTAGE_COFRE_06 = 100;
int UBICADO_APILAR_COFRE_06 = 1;

string UBICADO_COFRE_07 = "peke_011011111";
int UBICADO_TIRADAS_COFRE_07 = 1;
int UBICADO_PROBABILIDAD_COFRE_07 = 40;         //Armas y Armaduras Pequenyo-Objetos nivel 2 a 6
int UBICADO_PORCENTAGE_COFRE_07 = 100;
int UBICADO_APILAR_COFRE_07 = 1;

string UBICADO_COFRE_08 = "peke_011000000";
int UBICADO_TIRADAS_COFRE_08 = 1;
int UBICADO_PROBABILIDAD_COFRE_08 = 40;         //Miscelaneo Pequenyo-Objetos nivel 2 a 6
int UBICADO_PORCENTAGE_COFRE_08 = 100;
int UBICADO_APILAR_COFRE_08 = 1;

string UBICADO_COFRE_09 = "peke_0110011111";
int UBICADO_TIRADAS_COFRE_09 = 1;
int UBICADO_PROBABILIDAD_COFRE_09 = 80;        //Armas y Armaduras No magico o nivel 1-Objetos nivel 1
int UBICADO_PORCENTAGE_COFRE_09 = 100;
int UBICADO_APILAR_COFRE_09 = 1;

string UBICADO_COFRE_10 = "peke_011000000";
int UBICADO_TIRADAS_COFRE_10 = 1;
int UBICADO_PROBABILIDAD_COFRE_10 = 80;        //Miscelaneo No magico o nivel 1-Objetos nivel 1
int UBICADO_PORCENTAGE_COFRE_10 = 100;
int UBICADO_APILAR_COFRE_10 = 1;

string UBICADO_COFRE_11 = "peke_110100000";
int UBICADO_TIRADAS_COFRE_11 = 3;
int UBICADO_PROBABILIDAD_COFRE_11 = 10;         //Libros
int UBICADO_PORCENTAGE_COFRE_11 = 100;
int UBICADO_APILAR_COFRE_11 = 1;

string UBICADO_COFRE_12 = "medi_111100000";
int UBICADO_TIRADAS_COFRE_12 = 3;
int UBICADO_PROBABILIDAD_COFRE_12 = 10;         //Pergaminos
int UBICADO_PORCENTAGE_COFRE_12 = 100;
int UBICADO_APILAR_COFRE_12 = 1;

string UBICADO_COFRE_13 = "medi_111000000";
int UBICADO_TIRADAS_COFRE_13 = 3;
int UBICADO_PROBABILIDAD_COFRE_13 = 20;        //Pociones
int UBICADO_PORCENTAGE_COFRE_13 = 100;
int UBICADO_APILAR_COFRE_13 = 3;

string UBICADO_COFRE_14 = "alto_111000000";
int UBICADO_TIRADAS_COFRE_14 = 1;
int UBICADO_PROBABILIDAD_COFRE_14 = 50;        //Cetros
int UBICADO_PORCENTAGE_COFRE_14 = 100;
int UBICADO_APILAR_COFRE_14 = 1;

string UBICADO_COFRE_15 = "peke_111000000";
int UBICADO_TIRADAS_COFRE_15 = 3;
int UBICADO_PROBABILIDAD_COFRE_15 = 90;        //Baratijas
int UBICADO_PORCENTAGE_COFRE_15 = 100;
int UBICADO_APILAR_COFRE_15 = 2;

string UBICADO_COFRE_16 = "peke_111000000";
int UBICADO_TIRADAS_COFRE_16 = 1;
int UBICADO_PROBABILIDAD_COFRE_16 = 40;        //Varitas
int UBICADO_PORCENTAGE_COFRE_16 = 100;
int UBICADO_APILAR_COFRE_16 = 1;

string UBICADO_COFRE_17 = "null_000000000";
int UBICADO_TIRADAS_COFRE_17 = 0;
int UBICADO_PROBABILIDAD_COFRE_17 = 0;         //No utilizado
int UBICADO_PORCENTAGE_COFRE_17 = 0;
int UBICADO_APILAR_COFRE_17 = 0;

string UBICADO_COFRE_18 = "null_000000000";
int UBICADO_TIRADAS_COFRE_18 = 0;
int UBICADO_PROBABILIDAD_COFRE_18 = 0;          //No utilizado
int UBICADO_PORCENTAGE_COFRE_18 = 0;
int UBICADO_APILAR_COFRE_18 = 0;
