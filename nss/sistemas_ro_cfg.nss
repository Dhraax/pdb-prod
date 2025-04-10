//******************************************************************************
// Nombre:      sistemas_ro_cfg
// Descripcion: Script general de configuracion de los sistemas del modulo.
// Autor:       Tomas Gomez
//******************************************************************************

//******************************************************************************
//* Opciones de Continente Faerun
//******************************************************************************


string BD_SPER = "ro_cf_sp";                    //Nombre de la base de datos persistente
string NBDE_SGPER = "nbde_sgper";               //Base de datos NB de persistencia, su desaparicion no tiene importancia


//******************************************************************************
//* Sistema de comida y bebida
//******************************************************************************

int HABILITAR_SCB = 0;                          //- Habilita el sistema de comida y
                                                //  bebida.

int MENSAGES_LOG = 0;                           //- Activa los mensages de testeo y
                                                //  depuracion.

//Pozo en Ubicados/Estandar/Miscelaneo
string RESREF_FUENTE_AGUA_1 = "plc_well";               //- Res. Ref. de los lugares donde se
                                                        //  puede obtener agua. Se pueden tener
//Fuente en Ubicados/Estandar/Miscelaneo                //  5 lugares. Todos ellos deberan estar
string RESREF_FUENTE_AGUA_2 = "plc_fountain";           //  marcados como utilizables.

//Agua en Ubicados/Personalizados/Parques y naturaleza
//para poner en rios y estanques.
string RESREF_FUENTE_AGUA_3 = "agua";

//Bomba en Ubicados/Estandar/Oficios Academicos y Granja
string RESREF_FUENTE_AGUA_4 = "x0_pump";

string RESREF_FUENTE_AGUA_5 = "_ANULADO_";

string RESREF_FUENTE_AGUA_6 = "_ANULADO_";

string RESREF_FUENTE_AGUA_7 = "_ANULADO_";

string RESREF_FUENTE_AGUA_8 = "_ANULADO_";

string RESREF_FUENTE_AGUA_9 = "_ANULADO_";


string TAG_CANTIMPLORA = "Cantimplora";         //- Etiqueta del objeto que sera usado
                                                //  como cantimplora. (Objeto incluido
                                                //  en el paquete).

string TAG_ODRE = "Odre";                       //- Etiqueta del objeto que sera usado
                                                //  como odre. (Objeto incluido
                                                //  en el paquete).

int USOS_MAX_CANTIMPLORA = 10;                  //- Numero maximo de veces que se puede
                                                //  beber de la cantilplora.

int USOS_MAX_ODRE = 30;                         //- Numero maximo de veces que se puede
                                                //  beber del odre.

int AGUA_RESTA_PUNTOS = 150;                    //- Puntos de sed que se restan al beber
                                                //  agua.

//Racion de Comida en
//Objetos/Personalizado/Miscelanea/Otros
string TAG_COMIDA_1 = "RaciondeComida";         //- Etiqueta de los objetos que seran
                                                //  usados como comida.
string TAG_COMIDA_2 = "_ANULADO_";

string TAG_COMIDA_3 = "_ANULADO_";

string TAG_COMIDA_4 = "_ANULADO_";

string TAG_COMIDA_5 = "_ANULADO_";

string TAG_COMIDA_6 = "_ANULADO_";

string TAG_COMIDA_7 = "_ANULADO_";

string TAG_COMIDA_8 = "_ANULADO_";

string TAG_COMIDA_9 = "_ANULADO_";

int COMIDA_1_RESTA_PUNTOS = 225;                //- Puntos de hambre que se restan al
                                                //  ingerir algun alimento.
int COMIDA_2_RESTA_PUNTOS = 0;

int COMIDA_3_RESTA_PUNTOS = 0;

int COMIDA_4_RESTA_PUNTOS = 0;

int COMIDA_5_RESTA_PUNTOS = 0;

int COMIDA_6_RESTA_PUNTOS = 0;

int COMIDA_7_RESTA_PUNTOS = 0;

int COMIDA_8_RESTA_PUNTOS = 0;

int COMIDA_9_RESTA_PUNTOS = 0;


string TAG_BEBIDA_1 = "_ANULADO_";              //- Etiqueta de los objetos que seran
                                                //  usados como bebidas especiales.
string TAG_BEBIDA_2 = "_ANULADO_";

string TAG_BEBIDA_3 = "_ANULADO_";

string TAG_BEBIDA_4 = "_ANULADO_";

string TAG_BEBIDA_5 = "_ANULADO_";

string TAG_BEBIDA_6 = "_ANULADO_";

string TAG_BEBIDA_7 = "_ANULADO_";

string TAG_BEBIDA_8 = "_ANULADO_";

string TAG_BEBIDA_9 = "_ANULADO_";

int BEBIDA_1_RESTA_PUNTOS = 0;                  //- Puntos de sed que se restan al
                                                //  ingerir alguna bebida.
int BEBIDA_2_RESTA_PUNTOS = 0;

int BEBIDA_3_RESTA_PUNTOS = 0;

int BEBIDA_4_RESTA_PUNTOS = 0;

int BEBIDA_5_RESTA_PUNTOS = 0;

int BEBIDA_6_RESTA_PUNTOS = 0;

int BEBIDA_7_RESTA_PUNTOS = 0;

int BEBIDA_8_RESTA_PUNTOS = 0;

int BEBIDA_9_RESTA_PUNTOS = 0;

                                                //- Puntos para cambiar al siguiente
                                                //  estado de hambre.
int PUNTOS_NO_HAMBRE = 225;                     //- Hasta PUNTOS_NO_HAMBRE no se siente
                                                //  hambre.
int PUNTOS_ALGO_HAMBRE = 315;                   //- Entre PUNTOS_NO_HAMBRE y PUNTOS_ALGO_HAMBRE
                                                //  se siente algo de hambre
int PUNTOS_HAMBRIENTO = 1440;                   //- Entre PUNTOS_ALGO_HAMBRE y PUNTOS_HAMBRIENTO
                                                //  se siente hambriento.
                                                //- Por encima de PUNTOS_HAMBRIENTO se
                                                //  empieza a morir de hambre.

                                                //- Puntos para cambiar al siguiente
                                                //  estado de sed.
int PUNTOS_NO_SED = 150;                        //- Hasta PUNTOS_NO_SED no se siente
                                                //  sed.
int PUNTOS_ALGO_SED = 300;                      //- Entre PUNTOS_NO_SED y PUNTOS_ALGO_SED
                                                //  se siente algo de sed.
int PUNTOS_SEDIENTO = 1200;                     //- Entre PUNTOS_ALGO_SED y PUNTOS_SEDIENTO
                                                //  se siente sediento.
                                                //- Por encima de PUNTOS_SEDIENTO se
                                                //  empieza a morir de sed.



//******************************************************************************
//* Sistema de XP
//******************************************************************************

int HABILITAR_SXP = 1;                          //Habilita el sistema de XP

int XP_LOG = 0;                                 //Activa los mensajes de testeo

int BASE_XP = 30;                               //Base del sistema de XP.

int MULTIPLICADOR_XP = 1;                       //Multiplicador de XP.

int DIF_DESEQUILIBRIO = 4;                      //Diferencia maxima de nivel en el grupo
                                                //para considerarlo desequilibrado.

int MAX_PX_DESEQUIL = 100;                       //Maximo de XP ganada en un grupo desequilibrado.

int MIN_XP = 10;                                //Minimo de XP que se ganara.

int MAX_XP = 300;                               //Maximo de PX que se ganara.


//******************************************************************************
//* Sistema de muerte permanente en PJs
//******************************************************************************

int HABILITAR_SMP = 1;                          //Habililitar el sistema de MP

int BONO_PJ_MP = 1;                             //Multiplicador de bono a los PJs de
                                                //de muerte permanente.

int NIVEL_INIC_PjMP = 5;                        //Nivel inicial del PJ.

int BONO_ORO_SMP = 5000;                        //Bono de oro.



/*void main(){}*/
