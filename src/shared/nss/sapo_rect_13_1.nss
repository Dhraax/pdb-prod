#include "sapo_constantes"
#include "sapo_func_recetas"
#include "sapo_rect_13_inc"
#include "x2_inc_itemprop"

const string MASCARA_BASE="sapo_plnt12_";
const string MASCARA_MATERIAL="sapo_cuero_";
const string KIT_HERRAMIENTA1="sapo_kitcuero";
const string CONTENEDOR_CREAR="sapo_cont_guarn";
const int PROP_MAX =2;
const int CAR_MAX=6;
const int HAB_MAX = 7;
const int SAL_MAX=4;
const int RED_MAX=1;
const int AC_MAX=5;

int ComprobarComponentesYCargar(object oUbicado);
//int CargarVariables(object oUbicado, string sNomBase, string sNomMaterial, int iTotTachones, int iTotPieles);
int CargarVariables(object oUbicado, string sNomBase, string sNomMaterial);
//int CargarVariablesFormula(object oUbicado, string sNomBase, string sNomMaterial, int iTotTachones, int iTotPieles);
int CargarVariablesFormula(object oUbicado, string sNomBase, string sNomMaterial);

//las que creo yo para el sistema
void CrearObjeto(object oUbicado);
int DificultadArmadura(string sNomMaterial);
int iTipoArmadura;
int Bono_Cuero_Rata(object oUbicado);
int Bono_Cuero_Serpiente(object oUbicado);
int Bono_Cuero_Ciervo(object oUbicado);
int Bono_Cuero_Jabali(object oUbicado);
int Bono_Cuero_Oso(object oUbicado);
int Bono_Cuero_Lobo(object oUbicado);
int Bono_Cuero_Loboinvern(object oUbicado);
//variables de materiales
int iTotMateriales;
int iTotTachones;
int iTotPieles;
int iTotPell;
int iTotTelas;
//variable para numero de propiedades
int iTotProp=0;
//arenilla de azabache
int     iTotAza;
//belladona
int     iTotbelladona;
//aceite de oliva
int     iTotaceite;
//tinte para cuero negro
int     iTottinte;
//tinte para cuero verde
int     iTotTintv;
//shandon
int     iTotShandon;
//limo putrefacto
int     iTotlimo;
//placas de pherlock
int     iTotpher;
//piedra fria
int     iTotpiedra;
//esencia de abjuracion
int     iToteseabj;
//esencia de nigromancia
int     iTotesenig;
//esencia de evocacion
int     iTotEseEvo;
//pasta terrosa
int     iTotpaster;
//esencia de conjuracion
int     iTotEseCon;
//esencia de transmutacion
int     iTotEseTra;
//Arenilla de obsidiana
int     iTotObs;
//abdomen de escarabajo
int iTotabdesc;
//glandula de seda de tracnido
int iTotGlanSed;
//material de curandero
int iTotMatCur;
//ojo de rakshasa
int iTotOjoRak;
//polvo de hada
int iTotPolHada;
//bolsa maranyas
int iTotBolMara;
//Cuerda con garfio
int iTotCuerGarf;
//polvo antiluz
int iTotPolAnti;
//flor de loto
int iTotFlorLoto;
//brisa susurrante;
int iTotBriSusu;
//diente de bodak
int iTotDieBod;
//belladona
int iTotBelladona;
//trampas
int iTotTrampas;
//hogueras
int iTotHogue;


void main()
{

    int iFuncion=GetLocalInt(OBJECT_SELF,"Funcion");
    switch (iFuncion) {
        case FUNCION_COMPROBAR_Y_CARGAR:
            SetLocalInt(OBJECT_SELF,"fnRetorno",ComprobarComponentesYCargar(OBJECT_SELF));
            break;
        case FUNCION_CREAR_OBJETO:
            CrearObjeto(OBJECT_SELF);
            break;
    }

}

int ComprobarComponentesYCargar(object oUbicado) {


    string sResRef = GetResRef(oUbicado);
    //define en variables que elementos quiere buscar
    //la plantilla
    SetLocalString(oUbicado,"fnMaterialMascara1",MASCARA_BASE + "*");
    //los cueros
    SetLocalString(oUbicado,"fnMaterialMascara2",MASCARA_MATERIAL + "*");
    //piel para armadura de pieles que seria un cuero + x pieles
    SetLocalString(oUbicado,"fnMaterialMascara3","pielde*");
    //tachones para cuero tachonado
    SetLocalString(oUbicado,"fnMaterialMascara4","sapo_ing_tachon");
       //sedas que usare para acolchada, mirar si puede ser tela
       SetLocalString(oUbicado,"fnMaterialMascara5","finassedas");

    // a partir de aqui es la lista de materiales para combinar
    //aqui defino y cargo los materiales que se pueden usar en las recetas de guarnicionador

    //arenilla de azabache
        SetLocalString(oUbicado,"fnMaterialMascara6","polvo_aza");
    //belladona
       SetLocalString(oUbicado,"fnMaterialMascara7","NW_IT_MSMLMISC23");
    //aceite de oliva
       SetLocalString(oUbicado,"fnMaterialMascara8","AceiteSigilo");
    //tinte para cuero negro
       SetLocalString(oUbicado,"fnMaterialMascara9","x2_it_dyel23");
    //shandon
       SetLocalString(oUbicado,"fnMaterialMascara10","shandon");
    //limo putrefacto
       SetLocalString(oUbicado,"fnMaterialMascara11","limoputrefacto");
    //placas de pherlock
       SetLocalString(oUbicado,"fnMaterialMascara12","ust_plaksfher");
    //piedra fria
       SetLocalString(oUbicado,"fnMaterialMascara13","x1_it_msmlmisc01");
    //esencia de abjuracion
       SetLocalString(oUbicado,"fnMaterialMascara14","pb_artesa_reg");
    //esencia de nigromancia
       SetLocalString(oUbicado,"fnMaterialMascara15","pb_artesa_sal208");
    //sapo_esencia_evo
       SetLocalString(oUbicado,"fnMaterialMascara16","pb_artesa_car1");
    //pasta terrosa
       SetLocalString(oUbicado,"fnMaterialMascara17","pastaterrosa");
    //esencia de conjuracion
       SetLocalString(oUbicado,"fnMaterialMascara18","pb_artesa_car0");
    //esencia de transmutacion
       SetLocalString(oUbicado,"fnMaterialMascara19","pb_artesa_car2");
    //kit de curacion
       SetLocalString(oUbicado,"fnMaterialMascara20","medicinebag");
    //tinte para cuero verde
       SetLocalString(oUbicado,"fnMaterialMascara21","x2_it_dyel48");
    //pellejo de rata
       SetLocalString(oUbicado,"fnMaterialMascara22","pellejoderata");
    //arenilla de obsidiana
    SetLocalString(oUbicado,"fnMaterialMascara23","polvo_obs");
    //abdomen de escarabajo
    SetLocalString(oUbicado,"fnMaterialMascara24","NW_IT_MSMLMISC08");
    // glandula de tracnido
    SetLocalString(oUbicado,"fnMaterialMascara25","NW_IT_MSMLMISC07");
    // Material de curacion
    SetLocalString(oUbicado,"fnMaterialMascara26","vendas_pb_01");
    // ojo de raksasha
    SetLocalString(oUbicado,"fnMaterialMascara27","NW_IT_MSMLMISC09");
    // polvo de hadas
    SetLocalString(oUbicado,"fnMaterialMascara28","NW_IT_MSMLMISC19");
    // bolsa de maranyas
    SetLocalString(oUbicado,"fnMaterialMascara29","X1_WMGRENADE006");
    // cuerda con garfio
    SetLocalString(oUbicado,"fnMaterialMascara30","gz_it_rope");
    // hogueras
    SetLocalString(oUbicado,"fnMaterialMascara31","HC_Tinderbox");
    // polvo antiluz
    SetLocalString(oUbicado,"fnMaterialMascara32","polvoantiluz");
    // Luz cegadora de bezekira -> Equilibrio
    SetLocalString(oUbicado,"fnMaterialMascara33","pb_artesa_hab31");
    // Brisa susurrante
    SetLocalString(oUbicado,"fnMaterialMascara34","brisaSusurrante");
    // diente de bodak
    SetLocalString(oUbicado,"fnMaterialMascara35","NW_IT_MSMLMISC06");
    // trampas
    SetLocalString(oUbicado,"fnMaterialMascara36","NW_IT_TRAP001");


    ////////////////////////////////////////////////////////////////
    //llama al buscador
    ExecuteScript("sapo_rect_gen",OBJECT_SELF);
    //guardo en variables internas los totales que me haya devuelto elbuscador
    string sNomBase=GetLocalString(oUbicado,"fnMaterialRetorno1");
    int iTotBases=GetLocalInt(oUbicado,"fnMaterialRetornoTotal1");

    string sNomMaterial=GetLocalString(oUbicado,"fnMaterialRetorno2");
    iTotMateriales=GetLocalInt(oUbicado,"fnMaterialRetornoTotal2");

    string sNomPiel=GetLocalString(oUbicado,"fnMaterialRetorno3");
    iTotPieles=GetLocalInt(oUbicado,"fnMaterialRetornoTotal3");
    string sNomTachon=GetLocalString(oUbicado,"fnMaterialRetorno4");
    iTotTachones=GetLocalInt(oUbicado,"fnMaterialRetornoTotal4");
       int iTotMaterialesUbicado=GetLocalInt(oUbicado,"fnMaterialesRetornoTotal");
    int iRetorno=GetLocalInt(oUbicado,"fnRetorno");
    //////////////////////////////
       string sNomTelas=GetLocalString(oUbicado,"fnMaterialRetorno5");
       iTotTelas=GetLocalInt(oUbicado,"fnMaterialRetornoTotal5");
    //componentes nuevos


    //arenilla de azabache
    string sNomAza=GetLocalString(oUbicado,"fnMaterialRetorno6");
       iTotAza=GetLocalInt(oUbicado,"fnMaterialRetornoTotal6");
    //belladona
    string sNombelladona=GetLocalString(oUbicado,"fnMaterialRetorno7");
       iTotbelladona=GetLocalInt(oUbicado,"fnMaterialRetornoTotal7");
    //aceite de oliva
       string sNomaceite=GetLocalString(oUbicado,"fnMaterialRetorno8");
       iTotaceite=GetLocalInt(oUbicado,"fnMaterialRetornoTotal8");
    //tinte para cuero negro
       string sNomtinte=GetLocalString(oUbicado,"fnMaterialRetorno9");
       iTottinte=GetLocalInt(oUbicado,"fnMaterialRetornoTotal9");
    //shandon
       string sNomshandon=GetLocalString(oUbicado,"fnMaterialRetorno10");
       iTotShandon=GetLocalInt(oUbicado,"fnMaterialRetornoTotal10");
    //limo putrefacto
       string sNomlimo=GetLocalString(oUbicado,"fnMaterialRetorno11");
       iTotlimo=GetLocalInt(oUbicado,"fnMaterialRetornoTotal11");
    //placas de pherlock
       string sNompher=GetLocalString(oUbicado,"fnMaterialRetorno12");
       iTotpher=GetLocalInt(oUbicado,"fnMaterialRetornoTotal12");
    //piedra fria
       string sNompiedra=GetLocalString(oUbicado,"fnMaterialRetorno13");
       iTotpiedra=GetLocalInt(oUbicado,"fnMaterialRetornoTotal13");
    //esencia de abjuracion
       string sNomeseabj=GetLocalString(oUbicado,"fnMaterialRetorno14");
       iToteseabj=GetLocalInt(oUbicado,"fnMaterialRetornoTotal14");
    //esencia de nigromancia
       string sNomesenig=GetLocalString(oUbicado,"fnMaterialRetorno15");
       iTotesenig=GetLocalInt(oUbicado,"fnMaterialRetornoTotal15");
    //sapo_esencia_evo
       string sNomEseEvo=GetLocalString(oUbicado,"fnMaterialRetorno16");
       iTotEseEvo=GetLocalInt(oUbicado,"fnMaterialRetornoTotal16");
    //pasta terrosa
       string sNompaster=GetLocalString(oUbicado,"fnMaterialRetorno17");
       iTotpaster=GetLocalInt(oUbicado,"fnMaterialRetornoTotal17");
    //esencia de conjuracion
       string sNomEseCon=GetLocalString(oUbicado,"fnMaterialRetorno18");
       iTotEseCon=GetLocalInt(oUbicado,"fnMaterialRetornoTotal18");
    //esencia de transmutacion
       string sNomEseTra=GetLocalString(oUbicado,"fnMaterialRetorno19");
       iTotEseTra=GetLocalInt(oUbicado,"fnMaterialRetornoTotal19");
    //kit de curacion ahora se usara material de curacion
//       string sNomkitcur=GetLocalString(oUbicado,"fnMaterialRetorno20");
//       iTotkitcur=GetLocalInt(oUbicado,"fnMaterialRetornoTotal20");
    //tinte para cuero verde
       string sNomTintv=GetLocalString(oUbicado,"fnMaterialRetorno21");
       iTotTintv=GetLocalInt(oUbicado,"fnMaterialRetornoTotal21");
    //pellejo de rata
       string sNomPell=GetLocalString(oUbicado,"fnMaterialRetorno22");
       iTotPell=GetLocalInt(oUbicado,"fnMaterialRetornoTotal22");
   //arenilla de obsidiana
       string sNomObs=GetLocalString(oUbicado,"fnMaterialRetorno23");
       iTotObs=GetLocalInt(oUbicado,"fnMaterialRetornoTotal23");
       //abdomen de escarabajo
    string sNomTotabdesc=GetLocalString(oUbicado,"fnMaterialRetorno24");
    iTotabdesc=GetLocalInt(oUbicado,"fnMaterialRetornoTotal24");
    // glandula de tracnido
    string sNomTotGlaSed=GetLocalString(oUbicado,"fnMaterialMascara25");
    iTotGlanSed=GetLocalInt(oUbicado,"fnMaterialMascara25");
    // Material de curacion
    string sNomTotMatCur=GetLocalString(oUbicado,"fnMaterialMascara26");
    iTotMatCur=GetLocalInt(oUbicado,"fnMaterialMascara26");
    // ojo de raksasha
    string sNomTotOjRak=GetLocalString(oUbicado,"fnMaterialMascara27");
    iTotOjoRak=GetLocalInt(oUbicado,"fnMaterialMascara27");
    // polvo de hadas
    string sNomTotPoHad=GetLocalString(oUbicado,"fnMaterialMascara28");
    iTotPolHada=GetLocalInt(oUbicado,"fnMaterialMascara28");
    // bolsa de maranyas
    string sNomTotBoMar=GetLocalString(oUbicado,"fnMaterialMascara29");
    iTotBolMara=GetLocalInt(oUbicado,"fnMaterialMascara29");
    // cuerda con garfio
    string sNomTotCuGar=GetLocalString(oUbicado,"fnMaterialMascara30");
    iTotCuerGarf=GetLocalInt(oUbicado,"fnMaterialMascara30");
    // humo gaseoso
    string sNomTotHogue=GetLocalString(oUbicado,"fnMaterialMascara31");
    iTotHogue=GetLocalInt(oUbicado,"fnMaterialMascara31");
    // polvo antiluz
    string sNomTotPoAnt=GetLocalString(oUbicado,"fnMaterialMascara32");
    iTotPolAnti=GetLocalInt(oUbicado,"fnMaterialMascara32");
    // flor de loto
    string sNomTotFloLot=GetLocalString(oUbicado,"fnMaterialMascara33");
    iTotFlorLoto=GetLocalInt(oUbicado,"fnMaterialMascara33");
    // Brisa susurrante
    string sNomTotBrSus=GetLocalString(oUbicado,"fnMaterialMascara34");
    iTotBriSusu=GetLocalInt(oUbicado,"fnMaterialMascara34");
    // diente de bodak
    string sNomTotDiBod=GetLocalString(oUbicado,"fnMaterialMascara35");
    iTotDieBod=GetLocalInt(oUbicado,"fnMaterialMascara35");
    // trampas
    string sNomTotTramp=GetLocalString(oUbicado,"fnMaterialMascara35");
    iTotTrampas=GetLocalInt(oUbicado,"fnMaterialMascara36");


    //
    BorrarVariablesParaScript_sapo_rect_gen(oUbicado);

    //si ya el script rect gen dice que no es valido no continuo
    if (iRetorno==FALSE) return FALSE;

    //aqui verifico los materiales distintos y segun doy pista
    if (iTotBases>1) {
        AgregarPista(oUbicado,"*Necesitas una unica plantilla*");
        return FALSE;
    }
     if (iTotBases=0) {
        AgregarPista(oUbicado,"*Necesitas alguna plantilla*");
        return FALSE;
    }
    if (sNomBase!=MASCARA_BASE + "armd"){
        AgregarPista(oUbicado,"*Para guarnicioneria debes usar plantilla para armaduras*");
        return FALSE;
    }

    if (iTotMateriales==0) {
        AgregarPista(oUbicado,"*Necesitas algun cuero*");
        return FALSE;
    }

       if (iTotMateriales>6) {
        AgregarPista(oUbicado,"*Demasiados cueros*");
        return FALSE;
    }

    int iTotalHerramientas=TotalMaterialEnInventarioSegunNombre(oUbicado,KIT_HERRAMIENTA1,FALSE);

    if (iTotalHerramientas!=1) {
        AgregarPista(oUbicado,"*Necesitas herramientas para trabajar el cuero*");
        return FALSE;
    }

    if (iTotTachones>1) {
        AgregarPista(oUbicado,"*Para armaduras de cuero tachonado solo necesitas un juego de tachones*");
        return FALSE;
    }
    if (iTotabdesc>1) {
        AgregarPista(oUbicado,"*Para corazas solo necesitas un abdomen de escarabajo de fuego*");
        return FALSE;
    }

    //los pellejos tambien suman para la armadura de pieles
    iTotPieles= iTotPieles +iTotPell;

    if (iTotPieles>0 && iTotMateriales==0) {
        AgregarPista(oUbicado,"*Para armaduras de pieles necesitas un cuero de base*");
        return FALSE;
    }
    if (iTotPieles>0 && iTotMateriales>1) {
        AgregarPista(oUbicado,"*Para armaduras de pieles necesitas solo un cuero de base*");
        return FALSE;
    }
       if (iTotTelas>0 && iTotMateriales==0) {
        AgregarPista(oUbicado,"*Para armadura acolchada necesitas un cuero de base*");
        return FALSE;
    }
    if (iTotTelas>0 && iTotMateriales>1) {
        AgregarPista(oUbicado,"*Para armaduras acolchada necesitas solo un cuero de base*");
        return FALSE;
    }
        if (iTotPieles>0 && iTotTachones>0 && iTotTelas>0) {
        AgregarPista(oUbicado,"*O pieles o tachones o telas. Pero no todo mezclado.*");
        return FALSE;
    }

    //clasifico primero el tipo de armadura

       if (iTotTachones>0)
        {
           iTipoArmadura = 0;   //tachonada
           if (iTotabdesc>0)
           {iTipoArmadura = 4;}   //Coraza

    }
    else
    {
         if (iTotPieles>0)
         { iTipoArmadura = 1;       //pieles
         }
         else
         {
           if (iTotTelas>0)
           { iTipoArmadura = 2;     //acolchada
           }
              else
             { iTipoArmadura = 3;         //cuero
             }
         }

    }


    /////aqui las validaciones de los componentes segun el tipo de piel

    if ( sNomMaterial == "sapo_cuero_rata")
        {if (Bono_Cuero_Rata(oUbicado)==FALSE) return FALSE;        }
    if ( sNomMaterial == "sapo_cuero_serpi" || sNomMaterial == "sapo_cuero_murci")
        {if (Bono_Cuero_Serpiente(oUbicado)==FALSE) return FALSE;        }
    if ( sNomMaterial == "sapo_cuero_cierv" || sNomMaterial == "sapo_cuero_rothe")
        {if (Bono_Cuero_Ciervo(oUbicado)==FALSE) return FALSE;        }
    if ( sNomMaterial == "sapo_cuero_jabal" || sNomMaterial == "sapo_cuero_lagar")
        {if (Bono_Cuero_Jabali(oUbicado)==FALSE) return FALSE;        }
    if ( sNomMaterial == "sapo_cuero_oso" || sNomMaterial == "sapo_cuero_wyrm")
        {if (Bono_Cuero_Oso(oUbicado)==FALSE) return FALSE;        }
    if ( sNomMaterial == "sapo_cuero_lobo" || sNomMaterial == "sapo_cuero_cani")
        {if (Bono_Cuero_Lobo(oUbicado)==FALSE) return FALSE;        }
    if ( sNomMaterial == "sapo_cuero_loboi")
        {if (Bono_Cuero_Loboinvern(oUbicado)==FALSE) return FALSE;        }
   //////

    //SpeakString("Cueros: " + IntToString(iTotMateriales));
    //SpeakString("Tachones: " + IntToString(iTotTachones));
    //SpeakString("Pieles: " + IntToString(iTotPieles));
    //SpeakString("Telas: "+ IntToString(iTotTelas));
    //SpeakString("Materiales: " + IntToString(iTotMaterialesUbicado));
    //SendMessageToPC(GetFirstPC(), "Cueros: " + IntToString(iTotMateriales));
    //SendMessageToPC(GetFirstPC(), "Tachones: " + IntToString(iTotTachones));
    //SendMessageToPC(GetFirstPC(), "Pieles: " + IntToString(iTotPieles));
    //SendMessageToPC(GetFirstPC(), "Telas: "+ IntToString(iTotTelas));

    //limitamos a 8 esencias para caracteristicas, sino decimos que sobran
    if ( (iTotEseTra + iTotEseEvo + iTotEseCon) > CAR_MAX ){//6
        AgregarPista(oUbicado,"*¡¡Has puesto demasiadas esencias!!*");
        return FALSE;
    }
    //Limitamos a 14 ingredientes para habilidades, sino decimos que hay demasiados componentes para habilidades
    if ( (iTotbelladona + iTotaceite + iTottinte + iTotTintv + iTotShandon + iTotlimo
        + iTotGlanSed + iTotMatCur + iTotOjoRak + iTotPolHada + iTotBolMara + iTotCuerGarf + iTotHogue
        + iTotPolAnti + iTotFlorLoto + iTotBriSusu + iTotDieBod + iTotTrampas) > HAB_MAX ){//10 14
        AgregarPista(oUbicado,"*¡¡Has puesto demasiados componentes de habilidad!!*");
        return FALSE;
    }
    //Limitamos las salvaciones concretas en un mismo objeto a 6 (como en amuletos)
    if ( (iTotAza + iTotesenig ) > SAL_MAX ){ //6
        //AgregarPista(oUbicado,"*¡¡Las salvaciones concretas no pueden sumar mas de 6 entre ellas!!*");
        AgregarPista(oUbicado,"*¡¡Las salvaciones concretas no pueden sumar mas de " + IntToString(SAL_MAX) + " entre ellas!!*");
        return FALSE;
    }
    //Limitamos reducciones de daño a 5
    if ( (iTotpiedra + iTotabdesc) > RED_MAX){
        AgregarPista(oUbicado,"*¡¡Las reducciones de daño no pueden sumar mas de 5!!*");
        return FALSE;
    }

    //Limitamos a 5 habilidades, si son mas de 3 incrementamos el valor hasta nivel 16 minimo
    iTotProp=0;
    if (iTotAza > 0) iTotProp++;
    if (iTotbelladona > 0) iTotProp++;
    if (iTotaceite > 0) iTotProp++;
    if (iTottinte > 0) iTotProp++;
    if (iTotTintv > 0) iTotProp++;
    if (iTotShandon > 0) iTotProp++;
    if (iTotlimo > 0) iTotProp++;
    if (iTotpher > 0) iTotProp++;
    if (iTotpiedra > 0) iTotProp++;
    if (iToteseabj > 0) iTotProp++;
    if (iTotesenig > 0) iTotProp++;
    if (iTotEseEvo > 0) iTotProp++;
    if (iTotpaster > 0) iTotProp++;
    if (iTotEseCon > 0) iTotProp++;
    if (iTotEseTra > 0) iTotProp++;
    if (iTotObs > 0) iTotProp++;
    if (iTotabdesc > 0) iTotProp++;
    if (iTotGlanSed > 0) iTotProp++;
    if (iTotMatCur > 0) iTotProp++;
    if (iTotOjoRak > 0) iTotProp++;
    if (iTotPolHada > 0) iTotProp++;
    if (iTotBolMara > 0) iTotProp++;
    if (iTotCuerGarf > 0) iTotProp++;
    if (iTotHogue > 0) iTotProp++;
    if (iTotPolAnti > 0) iTotProp++;
    if (iTotFlorLoto > 0) iTotProp++;
    if (iTotBriSusu > 0) iTotProp++;
    if (iTotDieBod > 0) iTotProp++;
    if (iTotTrampas > 0) iTotProp++;
    if (iTotProp > PROP_MAX) {
        AgregarPista(oUbicado,"*¡¡No puedes poner más de " + IntToString(PROP_MAX) + " propiedades!!*");
        return FALSE;
    }

    //return CargarVariables(oUbicado, sNomBase, sNomMaterial, iTotTachones, iTotPieles);
    return CargarVariables(oUbicado, sNomBase, sNomMaterial);

}

//int CargarVariables(object oUbicado, string sNomBase, string sNomMaterial, int iTotTachones, int iTotPieles);
int CargarVariables(object oUbicado, string sNomBase, string sNomMaterial) {

    CargarVariablesComunes(oUbicado);
    //return CargarVariablesFormula(oUbicado, sNomBase, sNomMaterial, iTotTachones, iTotPieles);
    return CargarVariablesFormula(oUbicado, sNomBase, sNomMaterial);

}
//int CargarVariablesFormula(object oUbicado, string sNomBase, string sNomMaterial, int iTotTachones, int iTotPieles);
int CargarVariablesFormula(object oUbicado, string sNomBase, string sNomMaterial) {

     RequisitoClasesTodos(oUbicado,TRUE);
/*     RequisitoClase(oUbicado,1,CLASS_TYPE_BARBARIAN,1);
     RequisitoClase(oUbicado,2,CLASS_TYPE_FIGHTER,1);
     RequisitoClase(oUbicado,3,CLASS_TYPE_RANGER,1);
     RequisitoClase(oUbicado,4,CLASS_TYPE_ROGUE,1);
     RequisitoClase(oUbicado,5,CLASS_TYPE_DRUID,1);*/
    int iDifCalc= DificultadArmadura(sNomMaterial);

// Eliminados requisitos de nivel minimo
    ////requisitos de nivel por dificultad
/*    if (iDifCalc > 500)
    {  SetLocalInt(oUbicado,"NivelPJMinimo",15);
    }
    else
    {  if (iDifCalc > 300)
       { SetLocalInt(oUbicado,"NivelPJMinimo",10);
       }
    }*/
    /////////////////////////////////////////
    DificultadFormula(oUbicado,iDifCalc);

    RecetaCrear(oUbicado,"sapo_rect_13_1");

    //

    return TRUE;

}

void CrearObjeto(object oUbicado) {

//volvemos a recoger  los componentes para tener los bonos

    string sResRef = GetResRef(oUbicado);
    //define en variables que elementos quiere buscar
    //la plantilla
    SetLocalString(oUbicado,"fnMaterialMascara1",MASCARA_BASE + "*");
    //los cueros
    SetLocalString(oUbicado,"fnMaterialMascara2",MASCARA_MATERIAL + "*");
    //piel para armadura de pieles que seria un cuero + x pieles
    SetLocalString(oUbicado,"fnMaterialMascara3","pielde*");
    //tachones para cuero tachonado
    SetLocalString(oUbicado,"fnMaterialMascara4","sapo_ing_tachon");
    //sedas que usare para acolchada, mirar si puede ser tela
       SetLocalString(oUbicado,"fnMaterialMascara5","finassedas");

    // a partir de aqui es la lista de materiales para combinar
    //aqui defino y cargo los materiales que se pueden usar en las recetas de guarnicionador

    //arenilla de azabache
        SetLocalString(oUbicado,"fnMaterialMascara6","polvo_aza");
    //belladona
       SetLocalString(oUbicado,"fnMaterialMascara7","NW_IT_MSMLMISC23");
    //aceite de oliva
        SetLocalString(oUbicado,"fnMaterialMascara8","AceiteSigilo");
    //tinte para cuero negro
        SetLocalString(oUbicado,"fnMaterialMascara9","x2_it_dyel23");
    //shandon
        SetLocalString(oUbicado,"fnMaterialMascara10","shandon");
    //limo putrefacto
        SetLocalString(oUbicado,"fnMaterialMascara11","limoputrefacto");
    //placas de pherlock
        SetLocalString(oUbicado,"fnMaterialMascara12","ust_plaksfher");
    //piedra fria
        SetLocalString(oUbicado,"fnMaterialMascara13","x1_it_msmlmisc01");
    //esencia de abjuracion
        SetLocalString(oUbicado,"fnMaterialMascara14","pb_artesa_reg");
    //esencia de nigromancia
        SetLocalString(oUbicado,"fnMaterialMascara15","pb_artesa_sal208");
    //sapo_esencia_evo
        SetLocalString(oUbicado,"fnMaterialMascara16","pb_artesa_car1");
    //pasta terrosa
        SetLocalString(oUbicado,"fnMaterialMascara17","pastaterrosa");
    //raiz petrea
        SetLocalString(oUbicado,"fnMaterialMascara18","pb_artesa_car0");
    //esencia de transmutacion
        SetLocalString(oUbicado,"fnMaterialMascara19","pb_artesa_car2");
    //kit de curacion
        SetLocalString(oUbicado,"fnMaterialMascara20","medicinebag");
    //tinte para cuero verde
       SetLocalString(oUbicado,"fnMaterialMascara21","x2_it_dyel48");
    //pellejo de rata
       SetLocalString(oUbicado,"fnMaterialMascara22","pellejoderata");
        //arenilla de obsidiana
    SetLocalString(oUbicado,"fnMaterialMascara23","polvo_obs");
    //abdomen de escarabajo
    SetLocalString(oUbicado,"fnMaterialMascara24","NW_IT_MSMLMISC08");
    // glandula de tracnido
    SetLocalString(oUbicado,"fnMaterialMascara25","NW_IT_MSMLMISC07");
    // Material de curacion
    SetLocalString(oUbicado,"fnMaterialMascara26","vendas_pb_01");
    // ojo de raksasha
    SetLocalString(oUbicado,"fnMaterialMascara27","NW_IT_MSMLMISC09");
    // polvo de hadas
    SetLocalString(oUbicado,"fnMaterialMascara28","NW_IT_MSMLMISC19");
    // bolsa de maranyas
    SetLocalString(oUbicado,"fnMaterialMascara29","X1_WMGRENADE006");
    // cuerda con garfio
    SetLocalString(oUbicado,"fnMaterialMascara30","gz_it_rope");
    // hogueras
    SetLocalString(oUbicado,"fnMaterialMascara31","HC_Tinderbox");
    // polvo antiluz
    SetLocalString(oUbicado,"fnMaterialMascara32","polvoantiluz");
    // Luz cegadora de bezekira -> Equilibrio
    SetLocalString(oUbicado,"fnMaterialMascara33","pb_artesa_hab31");
    // Brisa susurrante
    SetLocalString(oUbicado,"fnMaterialMascara34","brisaSusurrante");
    // diente de bodak
    SetLocalString(oUbicado,"fnMaterialMascara35","NW_IT_MSMLMISC06");
    // trampas
    SetLocalString(oUbicado,"fnMaterialMascara36","NW_IT_TRAP001");

    //llama al buscador
    ExecuteScript("sapo_rect_gen",OBJECT_SELF);
    //guardo en variables internas los totales que me haya devuelto elbuscador
    string sNomBase=GetLocalString(oUbicado,"fnMaterialRetorno1");
    int iTotBases=GetLocalInt(oUbicado,"fnMaterialRetornoTotal1");
    string sNomMaterial=GetLocalString(oUbicado,"fnMaterialRetorno2");
    iTotMateriales=GetLocalInt(oUbicado,"fnMaterialRetornoTotal2");
    string sNomPiel=GetLocalString(oUbicado,"fnMaterialRetorno3");
    iTotPieles=GetLocalInt(oUbicado,"fnMaterialRetornoTotal3");
    string sNomTachon=GetLocalString(oUbicado,"fnMaterialRetorno4");
    iTotTachones=GetLocalInt(oUbicado,"fnMaterialRetornoTotal4");
       int iTotMaterialesUbicado=GetLocalInt(oUbicado,"fnMaterialesRetornoTotal");
    int iRetorno=GetLocalInt(oUbicado,"fnRetorno");
    //////////////////////////////
       string sNomTelas=GetLocalString(oUbicado,"fnMaterialRetorno5");
       iTotTelas=GetLocalInt(oUbicado,"fnMaterialRetornoTotal5");
    //componentes nuevos
    //arenilla de azabache
    string sNomAza=GetLocalString(oUbicado,"fnMaterialRetorno6");
       iTotAza=GetLocalInt(oUbicado,"fnMaterialRetornoTotal6");
    //belladona
    string sNombelladona=GetLocalString(oUbicado,"fnMaterialRetorno7");
       iTotbelladona=GetLocalInt(oUbicado,"fnMaterialRetornoTotal7");
    //aceite de oliva
       string sNomaceite=GetLocalString(oUbicado,"fnMaterialRetorno8");
       iTotaceite=GetLocalInt(oUbicado,"fnMaterialRetornoTotal8");
    //tinte para cuero negro
       string sNomtinte=GetLocalString(oUbicado,"fnMaterialRetorno9");
       iTottinte=GetLocalInt(oUbicado,"fnMaterialRetornoTotal9");
    //shandon
       string sNomshandon=GetLocalString(oUbicado,"fnMaterialRetorno10");
       iTotShandon=GetLocalInt(oUbicado,"fnMaterialRetornoTotal10");
    //limo putrefacto
       string sNomlimo=GetLocalString(oUbicado,"fnMaterialRetorno11");
       iTotlimo=GetLocalInt(oUbicado,"fnMaterialRetornoTotal11");
    //placas de pherlock
       string sNompher=GetLocalString(oUbicado,"fnMaterialRetorno12");
       iTotpher=GetLocalInt(oUbicado,"fnMaterialRetornoTotal12");
    //piedra fria
       string sNompiedra=GetLocalString(oUbicado,"fnMaterialRetorno13");
       iTotpiedra=GetLocalInt(oUbicado,"fnMaterialRetornoTotal13");
    //esencia de abjuracion
       string sNomeseabj=GetLocalString(oUbicado,"fnMaterialRetorno14");
       iToteseabj=GetLocalInt(oUbicado,"fnMaterialRetornoTotal14");
    //esencia de nigromancia
       string sNomesenig=GetLocalString(oUbicado,"fnMaterialRetorno15");
       iTotesenig=GetLocalInt(oUbicado,"fnMaterialRetornoTotal15");
    //sapo_esencia_evo
       string sNomEseEvo=GetLocalString(oUbicado,"fnMaterialRetorno16");
       iTotEseEvo=GetLocalInt(oUbicado,"fnMaterialRetornoTotal16");
    //pasta terrosa
       string sNompaster=GetLocalString(oUbicado,"fnMaterialRetorno17");
       iTotpaster=GetLocalInt(oUbicado,"fnMaterialRetornoTotal17");
    //raiz petrea
       string sNomEseCon=GetLocalString(oUbicado,"fnMaterialRetorno18");
       iTotEseCon=GetLocalInt(oUbicado,"fnMaterialRetornoTotal18");
    //abdomen de escarabajo de fuego
       string sNomEseTra=GetLocalString(oUbicado,"fnMaterialRetorno19");
       iTotEseTra=GetLocalInt(oUbicado,"fnMaterialRetornoTotal19");
    //kit de curacion ahora se usara material de curacion
//       string sNomkitcur=GetLocalString(oUbicado,"fnMaterialRetorno20");
//       iTotkitcur=GetLocalInt(oUbicado,"fnMaterialRetornoTotal20");
     //tinte para cuero verde
       string sNomTintv=GetLocalString(oUbicado,"fnMaterialRetorno21");
       iTotTintv=GetLocalInt(oUbicado,"fnMaterialRetornoTotal21");
     //pellejo de rata
       string sNomPell=GetLocalString(oUbicado,"fnMaterialRetorno22");
       iTotPell=GetLocalInt(oUbicado,"fnMaterialRetornoTotal22");
    //arenilla de obsidiana
       string sNomObs=GetLocalString(oUbicado,"fnMaterialRetorno23");
       iTotObs=GetLocalInt(oUbicado,"fnMaterialRetornoTotal23");
    //abdomen de escarabajo
    string sNomTotabdesc=GetLocalString(oUbicado,"fnMaterialRetorno24");
    iTotabdesc=GetLocalInt(oUbicado,"fnMaterialRetornoTotal24");
    // glandula de tracnido
    string sNomTotGlaSed=GetLocalString(oUbicado,"fnMaterialMascara25");
    iTotGlanSed=GetLocalInt(oUbicado,"fnMaterialMascara25");
    // Material de curacion
    string sNomTotMatCur=GetLocalString(oUbicado,"fnMaterialMascara26");
    iTotMatCur=GetLocalInt(oUbicado,"fnMaterialMascara26");
    // ojo de raksasha
    string sNomTotOjRak=GetLocalString(oUbicado,"fnMaterialMascara27");
    iTotOjoRak=GetLocalInt(oUbicado,"fnMaterialMascara27");
    // polvo de hadas
    string sNomTotPoHad=GetLocalString(oUbicado,"fnMaterialMascara28");
    iTotPolHada=GetLocalInt(oUbicado,"fnMaterialMascara28");
    // bolsa de maranyas
    string sNomTotBoMar=GetLocalString(oUbicado,"fnMaterialMascara29");
    iTotBolMara=GetLocalInt(oUbicado,"fnMaterialMascara29");
    // cuerda con garfio
    string sNomTotCuGar=GetLocalString(oUbicado,"fnMaterialMascara30");
    iTotCuerGarf=GetLocalInt(oUbicado,"fnMaterialMascara30");
    // humo gaseoso
    string sNomTotHogue=GetLocalString(oUbicado,"fnMaterialMascara31");
    iTotHogue=GetLocalInt(oUbicado,"fnMaterialMascara31");
    // polvo antiluz
    string sNomTotPoAnt=GetLocalString(oUbicado,"fnMaterialMascara32");
    iTotPolAnti=GetLocalInt(oUbicado,"fnMaterialMascara32");
    // flor de loto
    string sNomTotFloLot=GetLocalString(oUbicado,"fnMaterialMascara33");
    iTotFlorLoto=GetLocalInt(oUbicado,"fnMaterialMascara33");
    // Brisa susurrante
    string sNomTotBrSus=GetLocalString(oUbicado,"fnMaterialMascara34");
    iTotBriSusu=GetLocalInt(oUbicado,"fnMaterialMascara34");
    // diente de bodak
    string sNomTotDiBod=GetLocalString(oUbicado,"fnMaterialMascara35");
    iTotDieBod=GetLocalInt(oUbicado,"fnMaterialMascara35");
    // trampas
    string sNomTotTramp=GetLocalString(oUbicado,"fnMaterialMascara35");
    iTotTrampas=GetLocalInt(oUbicado,"fnMaterialMascara36");
    //
    //los pellejos tambien suman para la armadura de pieles
    iTotPieles= iTotPieles +iTotPell;

    BorrarVariablesParaScript_sapo_rect_gen(oUbicado);

    object oPC = GetLastUsedBy();
    string sSubraza = GetStringLowerCase(GetSubRace(oPC));
    string sDescripAux ="";
    string sNameAux="";
    sDescripAux = "Esta es una armadura ";
    sNameAux="Armadura ";
    if (sSubraza == "drow")
    {
           sDescripAux = "Imbuida por feerzess esta es una armadura drow ";
           sNameAux=sNameAux+"drow ";
    }

    //clasifico el tipo de armadura

    if (iTotTachones>0)
        {  iTipoArmadura = 0;   //tachonada
           sDescripAux = sDescripAux + "tachonada hecha con cuero de ";
           sNameAux=sNameAux+"de cuero tachonado";
           if (iTotabdesc>0)
           {iTipoArmadura = 4;   //coraza
            if (sSubraza == "drow")
             {
             sDescripAux = "Imbuida por feerzess esta es una coraza drow ";
             sNameAux="Coraza drow ";
             }
             else
             {
             sDescripAux = "Esta es una coraza refozada con cuero de ";
             sNameAux="coraza";
             }
           }
    }
    else
    {
         if (iTotPieles>0)
         { iTipoArmadura = 1;       //pieles
           sDescripAux = sDescripAux + "de pieles hecha con cuero de ";
           sNameAux=sNameAux+"de pieles";
         }
         else
         {
           if (iTotTelas>0)
           { iTipoArmadura = 2;     //acolchada
             sDescripAux = sDescripAux + "acolchada hecha con cuero de ";
             sNameAux=sNameAux+"acolchada";
           }
              else
             { iTipoArmadura = 3;         //cuero
               sDescripAux = sDescripAux + "de cuero de ";
                          sNameAux=sNameAux+"cuero";
             }
         }

    }


if ( sNomMaterial == "sapo_cuero_rata")
    {if (Bono_Cuero_Rata(oUbicado)==FALSE) {
                                    if (DEBUG) SpeakString("mierda rata");
                                   }
     sDescripAux = sDescripAux + "rata ";
     sNameAux=sNameAux+" ratuna";
 }
if ( sNomMaterial == "sapo_cuero_serpi")
    {if (Bono_Cuero_Serpiente(oUbicado)==FALSE) {
                                    if (DEBUG) SpeakString("mierda serpiente");
                                   }
    sDescripAux = sDescripAux + "serpiente ";
    sNameAux=sNameAux+" serpentina";
 }
if ( sNomMaterial == "sapo_cuero_murci")
    {if (Bono_Cuero_Serpiente(oUbicado)==FALSE) {
                                    if (DEBUG) SpeakString("mierda murci");
                                   }
    sDescripAux = sDescripAux + "murcielago ";
    sNameAux=sNameAux+" quiroptera";
 }
if ( sNomMaterial == "sapo_cuero_cierv")
    {if (Bono_Cuero_Ciervo(oUbicado)==FALSE) {
                                    if (DEBUG) SpeakString("mierda ciervo");
                                   }
    sDescripAux = sDescripAux + "ciervo ";
    sNameAux=sNameAux+" cervina";
 }
if ( sNomMaterial == "sapo_cuero_rothe")
    {if (Bono_Cuero_Ciervo(oUbicado)==FALSE) {
                                    if (DEBUG) SpeakString("mierda rothe");
                                   }
    sDescripAux = sDescripAux + "rothe ";
    sNameAux=sNameAux+" rothuna";
 }
if ( sNomMaterial == "sapo_cuero_jabal")
    {if (Bono_Cuero_Jabali(oUbicado)==FALSE) {
                                    if (DEBUG) SpeakString("mierda jabali");
                                   }
    sDescripAux = sDescripAux + "jabali ";
    sNameAux=sNameAux+" jabalina";
 }
if ( sNomMaterial == "sapo_cuero_lagar")
    {if (Bono_Cuero_Jabali(oUbicado)==FALSE) {
                                    if (DEBUG) SpeakString("mierda lagar");
                                   }
    sDescripAux = sDescripAux + "lagarto ";
    sNameAux=sNameAux+" reptiliana";
 }
if ( sNomMaterial == "sapo_cuero_oso")
    {if (Bono_Cuero_Oso(oUbicado)==FALSE) {
                                    if (DEBUG) SpeakString("mierda oso");
                                   }
    sDescripAux = sDescripAux + "oso ";
    sNameAux=sNameAux+" osuna";
 }
if ( sNomMaterial == "sapo_cuero_wyrm")
    {if (Bono_Cuero_Oso(oUbicado)==FALSE) {
                                    if (DEBUG) SpeakString("mierda wyrm");
                                   }
    sDescripAux = sDescripAux + "wyrm ";
    sNameAux=sNameAux+" draconica";
 }
if ( sNomMaterial == "sapo_cuero_lobo")
    {if (Bono_Cuero_Lobo(oUbicado)==FALSE) {
                                    if (DEBUG) SpeakString("mierda lobo");
                                   }
    sDescripAux = sDescripAux + "lobo ";
    sNameAux=sNameAux+" lobuna";
 }
if ( sNomMaterial == "sapo_cuero_cani")
    {if (Bono_Cuero_Lobo(oUbicado)==FALSE) {
                                    if (DEBUG) SpeakString("mierda cani");
                                   }
    sDescripAux = sDescripAux + "sabueso infernal ";
    sNameAux=sNameAux+" infernal";
 }
if ( sNomMaterial == "sapo_cuero_loboi")
    {if (Bono_Cuero_Loboinvern(oUbicado)==FALSE) {
                                    if (DEBUG) SpeakString("mierda lobo invernal");
                                   }
    sDescripAux = sDescripAux + "lobo invernal ";
    sNameAux=sNameAux+" de lobo de las nieves";
 }
//recogidos ya los bonos creo primero la armadura que corresponda



    int iBonoAC=0;
    string SArmadura ="";
    switch (iTipoArmadura)
        {
     case 0:
        //tachonada
              SArmadura = "nw_aarcl002";
              iBonoAC = iTotMateriales - 1;
                  if (sSubraza == "drow")
                  {int iBonDrow = 7 + iTotMateriales;
                   if (iBonDrow > 9)
                   {
                     SArmadura = "x2_mdrowar0"+IntToString(iBonDrow);
                   }
                   else
                   {
                     SArmadura = "x2_mdrowar00"+IntToString(iBonDrow);
                   }

                  }
                 //drow x2_mdrowar008
                 if (iBonoAC>AC_MAX) iBonoAC = AC_MAX;
                 break;
     case 1:
        //pieles
              SArmadura = "nw_aarcl008";
                 iBonoAC = iTotPieles - 1;
                 if (iBonoAC>AC_MAX) iBonoAC = AC_MAX;
                 break;
     case 2:
        //acolchada
              SArmadura = "nw_aarcl009";
                 iBonoAC = iTotTelas - 1;
                 if (iBonoAC>AC_MAX) iBonoAC = AC_MAX;
                 break;
     case 3:
        //cuero
              SArmadura = "nw_aarcl001";
              iBonoAC = iTotMateriales - 1;
                 //drow x2_mdrowar001
                 if (sSubraza == "drow")
                  {SArmadura = "x2_mdrowar00"+IntToString(iTotMateriales);
                  }
              if (iBonoAC>AC_MAX) iBonoAC = AC_MAX;

              break;
      case 4:
        //coraza
              SArmadura = "nw_aarcl010";
              iBonoAC = iTotMateriales - 1;
              if (iBonoAC>AC_MAX) iBonoAC = AC_MAX;
              break;
            }

        //"NW_AARCL012" mallas 4/4


      //creo objeto
   //object oContenedorParaCrear=GetObjectByTag(SAPO_CONTENEDOR_CREAR);
   object oContenedorParaCrear=GetObjectByTag(CONTENEDOR_CREAR);
   //object oObjeto=CreateItemOnObject(SArmadura,oContenedorParaCrear,1,"");
   object oObjeto;
   //
   //Tintamos el cuero segun la piel o el tinte
   if ( sNomMaterial == "sapo_cuero_loboi" || iTottinte >0 || iTotTintv >0 || iTipoArmadura ==4)
   {  //si piel lobo invernal o se usa tinte entonces tintamos antes de hacer el resto
      int iColor;
      if (iTipoArmadura==4)
      {iColor=52;}
      if (sNomMaterial == "sapo_cuero_loboi")
      {iColor=62;}
      if (iTotTintv >0)
       {iColor=19;}
      if (iTottinte > 0 )
      {iColor=63;}

      object oObjetoAux=CreateItemOnObject(SArmadura,oContenedorParaCrear,1,"");
      object oObjetoAux1=IPDyeArmor(oObjetoAux,0,iColor);
      object oObjetoAux2=IPDyeArmor(oObjetoAux1,1,iColor);
      object oObjetoAux3=IPDyeArmor(oObjetoAux2,2,iColor);
      oObjeto=IPDyeArmor(oObjetoAux3,3,iColor);
      //oObjeto=CopyItemAndModify(oObjetoAux,ITEM_APPR_TYPE_ARMOR_COLOR,ITEM_APPR_ARMOR_COLOR_*,iColor,TRUE);

   }
   else
   { oObjeto=CreateItemOnObject(SArmadura,oContenedorParaCrear,1,"");
   }


    if (sSubraza != "drow" )
    {
      if (iBonoAC>AC_MAX)
      {
         iBonoAC=AC_MAX;
      }
      itemproperty ipAdd=ItemPropertyACBonus(iBonoAC);
      if (GetIsObjectValid(oObjeto))
          AddItemProperty(DURATION_TYPE_PERMANENT, ipAdd, oObjeto);
    }
    else
    {if(iTipoArmadura==1 || iTipoArmadura==2 || iTipoArmadura==4)
      {
         if (iBonoAC>AC_MAX)
         {
            iBonoAC=AC_MAX;
         }
         itemproperty ipAdd=ItemPropertyACBonus(iBonoAC);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipAdd, oObjeto);
      }
    }


//como las validaciones ya están hechas aqui solo pasamos a crear el objeto y de paso
//ir incluyendo los bonos, consideramos los de todos.
    //bono esconderse
    if (iTottinte >0 || iTotTintv >0)
       {

        int iBonoEsc =0;
        if (iTottinte > 0)
        {iBonoEsc = iTottinte;}
        else
        {iBonoEsc = iTotTintv;}
        if (iBonoEsc>HAB_MAX)
        {
            iBonoEsc=HAB_MAX;
        }
        itemproperty ipBonoEsc = ItemPropertySkillBonus(SKILL_HIDE, iBonoEsc);
        AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoEsc, oObjeto);
        sDescripAux = sDescripAux + ", esta oscurecida para camuflarse mejor ";
       }

    //bono buscar
    if (iTotShandon >0)
       {
        int iBonoBus = iTotShandon;
        if (iBonoBus>HAB_MAX)
        {
            iBonoBus=HAB_MAX;
        }
        itemproperty ipBonoBus = ItemPropertySkillBonus(SKILL_SEARCH, iBonoBus);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoBus, oObjeto);
         sDescripAux = sDescripAux + ", posee como un brillo curioso ";
       }
    //bono a enganyar
    if (iTotlimo >0)
       {
        int iBonoBus = iTotlimo;
        if (iBonoBus>HAB_MAX)
        {
            iBonoBus=HAB_MAX;
        }
        itemproperty ipBonoBus = ItemPropertySkillBonus(23, iBonoBus);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoBus, oObjeto);
       }
    //bono a supervivencia
    if(iTotbelladona >0)
       {
        int iBonoBus = iTotbelladona;
        if (iBonoBus>HAB_MAX)
        {
            iBonoBus=HAB_MAX;
        }
        itemproperty ipBonoBus = ItemPropertySkillBonus(36, iBonoBus);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoBus, oObjeto);
        sDescripAux = sDescripAux + ", huele suavemente a plantas astringentes ";

       }

    //bono Sigilo
    if (iTotaceite >0)
       {
        int iBonoMovSil = iTotaceite;
        if (iBonoMovSil>HAB_MAX)
        {
            iBonoMovSil=HAB_MAX;
        }
        itemproperty ipBonoMovSil = ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, iBonoMovSil);
        AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoMovSil, oObjeto);
        sDescripAux = sDescripAux + ", esta aceitada para no hacer ruido ";


       }

//bono a trepar = glandula de seda de tracnido
if (iTotGlanSed >0){
         int iBonoTre = iTotGlanSed;
         if (iBonoTre>HAB_MAX)
         {
            iBonoTre=HAB_MAX;
         }
         itemproperty ipBonoTre = ItemPropertySkillBonus(37, iBonoTre);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoTre, oObjeto);
         sDescripAux = sDescripAux + ", puede trepar facilmente";
}
//bono a sanar = material de curandero
if (iTotMatCur >0){
         int iBonoSan = iTotMatCur;
         if (iBonoSan>HAB_MAX)
         {
            iBonoSan=HAB_MAX;
         }
         itemproperty ipBonoSan = ItemPropertySkillBonus(4, iBonoSan);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoSan, oObjeto);
         sDescripAux = sDescripAux + ", puedes curar mas facilmente";
}
//bono a concentracion = ojo de rakshasa
if (iTotOjoRak >0){
       int iBonoConc = iTotOjoRak;
       if (iBonoConc>HAB_MAX)
       {
            iBonoConc=HAB_MAX;
       }
       itemproperty ipBonoConc = ItemPropertySkillBonus(1, iBonoConc);
       AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoConc, oObjeto);
       sDescripAux = sDescripAux + ", te ayuda a concentrarte";
}
//bono a nadar = polvo de hada
if (iTotPolHada >0){
       int iBonoNad = iTotPolHada;
       if (iBonoNad>HAB_MAX)
       {
            iBonoNad=HAB_MAX;
       }
        itemproperty ipBonoNad = ItemPropertySkillBonus(25, iBonoNad);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoNad, oObjeto);
         sDescripAux = sDescripAux + ", puedes nadar con ella";
}
//juego de manos = bolsa maranyas
if (iTotBolMara >0){
       int iBonoJue = iTotBolMara;
       if (iBonoJue>HAB_MAX)
       {
            iBonoJue=HAB_MAX;
       }
        itemproperty ipBonoJue = ItemPropertySkillBonus(13, iBonoJue);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoJue, oObjeto);
         sDescripAux = sDescripAux + ", tus dedos son escurridizos";
}
//bono a uso de cuerdas = Cuerda con garfio
if (iTotCuerGarf >0){
       int iBonoUsCuerd = iTotCuerGarf;
        if (iBonoUsCuerd>HAB_MAX)
       {
            iBonoUsCuerd=HAB_MAX;
       }
        itemproperty ipBonoUsCuerd = ItemPropertySkillBonus(38, iBonoUsCuerd);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoUsCuerd, oObjeto);
         sDescripAux = sDescripAux + ", atas bien las cuerdas";
}
//bono a escapismo = polvo antiluz
if (iTotPolAnti >0){
       int iBonoEsca = iTotPolAnti;
        if (iBonoEsca>HAB_MAX)
        {
            iBonoEsca=HAB_MAX;
        }
        itemproperty ipBonoEsca = ItemPropertySkillBonus(32, iBonoEsca);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoEsca, oObjeto);
         sDescripAux = sDescripAux + ", te escurres como una serpiente";
}
//bono a equilibrio = flor de loto
if (iTotFlorLoto >0){
       int iBonoEqui = iTotFlorLoto;
        if (iBonoEqui>HAB_MAX)
        {
            iBonoEqui=HAB_MAX;
        }
        itemproperty ipBonoEqui = ItemPropertySkillBonus(31, iBonoEqui);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoEqui, oObjeto);
         sDescripAux = sDescripAux + ", te mantienes bien de pie";
}
//bono saltar = brisa susurrante;
if (iTotBriSusu >0){
       int iBonoSaltar = iTotBriSusu;
       if (iBonoSaltar>HAB_MAX)
        {
            iBonoSaltar=HAB_MAX;
        }
        itemproperty ipBonoSaltar = ItemPropertySkillBonus(26, iBonoSaltar);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoSaltar, oObjeto);
         sDescripAux = sDescripAux + ", puedes saltar mas lejos";
}
//bono a intimidar = diente de bodak
if (iTotDieBod >0){
       int iBonoInti = iTotDieBod;
        if (iBonoInti>HAB_MAX)
        {
            iBonoInti=HAB_MAX;
        }
        itemproperty ipBonoInti = ItemPropertySkillBonus(24, iBonoInti);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoInti, oObjeto);
         sDescripAux = sDescripAux + ", eres mas imponente";
}
//bono de disfrazarse = hoguera
if (iTotHogue > 0){
       int iBonoDisf = iTotHogue;
        if (iBonoDisf>HAB_MAX)
        {
            iBonoDisf=HAB_MAX;
        }
        itemproperty ipBonoDisf = ItemPropertySkillBonus(30, iBonoDisf);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoDisf, oObjeto);
         sDescripAux = sDescripAux + ", te ayuda a disfrazarte";
}

    //bono reflejos
    if (iTotAza >0)
       {
       int iBonoRef = iTotAza;
       if (iBonoRef>SAL_MAX)
       {
          iBonoRef= SAL_MAX;
       }
       itemproperty ipBonoTSRef = ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_REFLEX, iBonoRef);
        AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoTSRef, oObjeto);
        sDescripAux = sDescripAux + ", para como si con ella se fuera mas agil ";
       }

 //bono regeneracion (M)
    if (iToteseabj>0)
    {
    int iBr = 1;
    //iBr=iToteseabj;

     itemproperty ipBonoReg = ItemPropertyRegeneration(iBr);
     AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoReg, oObjeto);
    }
//bono Miedo
    if (iTotesenig >0)
       {
        //int nAlign = IP_CONST_ALIGNMENTGROUP_GOOD;
        int nAlign = IP_CONST_SAVEVS_FEAR;
        int iBonoTSMie = iTotesenig;
        if (iBonoTSMie>SAL_MAX)
        {
           iBonoTSMie = SAL_MAX;
        }
        itemproperty ipBonoTSBien=ItemPropertyBonusSavingThrowVsX(nAlign, iBonoTSMie);
//        itemproperty ipBonoTSBien=ItemPropertyACBonusVsAlign(nAlign, iBonoTSBien);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoTSBien, oObjeto);
         sDescripAux = sDescripAux + ", sin miedo marca en runas oscuras ";
       }
//bono para quitar penalizacion de conjuro arcano
    if(iTotObs >0)
    {


        int nModLevel = 9;
        if(iTotObs >1)
        {nModLevel = 8;}
        if(iTotObs >2)
        {nModLevel = 7;}
        if(iTotObs >3)
        {nModLevel = 6;}

        itemproperty ipBonoPen=ItemPropertyArcaneSpellFailure(nModLevel);
        AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoPen, oObjeto);
        sDescripAux = sDescripAux + ", la urdimbre parece que se funde con ella ";
       }
 //bono resistencia frio
 if (iTotpiedra >0)
       {
        //int nAlign = IP_CONST_ALIGNMENTGROUP_GOOD;
        int nDamageType =IP_CONST_DAMAGETYPE_COLD;
        int nHPResist = 0;
        if (iTotpiedra >=RED_MAX)
        {
            nHPResist = IP_CONST_DAMAGERESIST_5;
        }
        itemproperty ipAdd = ItemPropertyDamageResistance(nDamageType, nHPResist);
//        itemproperty ipBonoTSBien=ItemPropertyACBonusVsAlign(nAlign, iBonoTSBien);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipAdd, oObjeto);
         sDescripAux = sDescripAux + ", huele a una mañana nevada ";
       }
//la coraza al ser hecha con escarabajo de fuego resistencia fuego, si da el numero de propiedades
if (iTipoArmadura==4 && iTotProp < PROP_MAX)
{

        int nDamageType =IP_CONST_DAMAGETYPE_FIRE;
        int nHPResist = IP_CONST_DAMAGERESIST_5;
        itemproperty ipAdd = ItemPropertyDamageResistance(nDamageType, nHPResist);
        AddItemProperty(DURATION_TYPE_PERMANENT, ipAdd, oObjeto);
         sDescripAux = sDescripAux + ", pulsa calida aun calida por los restos del escarabajo de fuego ";
       }

//bono FUE
    if (iTotEseCon >0)
       {
        int nbonofue =IP_CONST_ABILITY_STR;
        int ndopefue = 0;
        ndopefue = iTotEseCon;
        if (ndopefue > CAR_MAX)
        {
         ndopefue = CAR_MAX;
        }
        itemproperty ipAddStrength=ItemPropertyAbilityBonus(nbonofue, ndopefue);
        AddItemProperty(DURATION_TYPE_PERMANENT, ipAddStrength, oObjeto);
         sDescripAux = sDescripAux + ", con ella el dueño parece mas fuerte ";
       }
//bono DES
if (iTotEseEvo >0)
       {
        int nbonodes =IP_CONST_ABILITY_DEX;
        int ndopedes = 0;
        ndopedes = iTotEseEvo;
        if (ndopedes > CAR_MAX)
        {
         ndopedes = CAR_MAX;
        }
        itemproperty ipAdddes=ItemPropertyAbilityBonus(nbonodes, ndopedes);
        AddItemProperty(DURATION_TYPE_PERMANENT, ipAdddes, oObjeto);
         sDescripAux = sDescripAux + ", con ella el dueño parece mas agil ";
       }
//bono CON
if (iTotEseTra >0)
       {
        int nbonocon =IP_CONST_ABILITY_CON;
        int ndopecon = 0;
        ndopecon = iTotEseTra;
        if (ndopecon > CAR_MAX)
        {
         ndopecon = CAR_MAX;
        }
        itemproperty ipAddcon=ItemPropertyAbilityBonus(nbonocon, ndopecon);
        AddItemProperty(DURATION_TYPE_PERMANENT, ipAddcon, oObjeto);
         sDescripAux = sDescripAux + ", con ella el dueño parece mas resistente ";
       }
//reduccion de daño
if (iTotpher >0)
       {
        int nEnhancement = 0;
        int nHPSoak = 1;

        if (iTotpher ==1 )
        {
        nEnhancement =IP_CONST_DAMAGEREDUCTION_1;
        nHPSoak= IP_CONST_DAMAGESOAK_10_HP;
        }
        if (iTotpher ==2 )
        {
        nEnhancement =IP_CONST_DAMAGEREDUCTION_2;
        nHPSoak= IP_CONST_DAMAGESOAK_10_HP;
        }
        if (iTotpher ==3 )
        {
        nEnhancement =IP_CONST_DAMAGEREDUCTION_3;
        nHPSoak= IP_CONST_DAMAGESOAK_10_HP;
        }
        if (iTotpher ==4 )
        {
        nEnhancement =IP_CONST_DAMAGEREDUCTION_4;
        nHPSoak= IP_CONST_DAMAGESOAK_5_HP;
        }
        if (iTotpher >4 )
        {
        nEnhancement =IP_CONST_DAMAGEREDUCTION_5;
        nHPSoak= IP_CONST_DAMAGESOAK_5_HP;
        }
        itemproperty ipAdddam = ItemPropertyDamageReduction(nEnhancement, nHPSoak);
        AddItemProperty(DURATION_TYPE_PERMANENT, ipAdddam, oObjeto);
         sDescripAux = sDescripAux + ", al tocarla resuena como si fuera acero templado ";
       }
//aumento velocidad
if (iTotpaster >0)
       {
        int nreducpes = 0;
        int nexped = 0;

        if (iTotpaster ==1)
        {

        nreducpes = IP_CONST_REDUCEDWEIGHT_80_PERCENT;

        }
        if (iTotpaster ==2)
        {

        nreducpes = IP_CONST_REDUCEDWEIGHT_60_PERCENT;

        }
        if (iTotpaster ==3)
        {

        nreducpes = IP_CONST_REDUCEDWEIGHT_40_PERCENT;

        }
        if (iTotpaster ==4)
        {

        nreducpes = IP_CONST_REDUCEDWEIGHT_20_PERCENT;

        }
        if (iTotpaster ==5)
        {
        nexped = 1;
        nreducpes = IP_CONST_REDUCEDWEIGHT_10_PERCENT;
        }
        if (iTotpaster >5)
        {
        nexped = 2;
        nreducpes = IP_CONST_REDUCEDWEIGHT_10_PERCENT;
        }

        //itemproperty ipAdd = ItemPropertyDamageReduction(nEnhancement, nHPSoak);
        itemproperty ipAddpes = ItemPropertyWeightReduction(nreducpes);
        AddItemProperty(DURATION_TYPE_PERMANENT, ipAddpes, oObjeto);
         sDescripAux = sDescripAux + ", con ella te sientes mas ligero ";
       }



//Si tiene mas de 3 propiedades, guardamos una variable para impedir que se lo equipe alguien de menos de nivel 15
    iTotProp=0;
    if (iTotAza > 0) iTotProp++;
    if (iTotbelladona > 0) iTotProp++;
    if (iTotaceite > 0) iTotProp++;
    if (iTottinte > 0) iTotProp++;
    if (iTotTintv > 0) iTotProp++;
    if (iTotShandon > 0) iTotProp++;
    if (iTotlimo > 0) iTotProp++;
    if (iTotpher > 0) iTotProp++;
    if (iTotpiedra > 0) iTotProp++;
    if (iToteseabj > 0) iTotProp++;
    if (iTotesenig > 0) iTotProp++;
    if (iTotEseEvo > 0) iTotProp++;
    if (iTotpaster > 0) iTotProp++;
    if (iTotEseCon > 0) iTotProp++;
    if (iTotEseTra > 0) iTotProp++;
    if (iTotObs > 0) iTotProp++;
    if (iTotabdesc > 0) iTotProp++;
    if (iTotGlanSed > 0) iTotProp++;
    if (iTotMatCur > 0) iTotProp++;
    if (iTotOjoRak > 0) iTotProp++;
    if (iTotPolHada > 0) iTotProp++;
    if (iTotBolMara > 0) iTotProp++;
    if (iTotCuerGarf > 0) iTotProp++;
    if (iTotHogue > 0) iTotProp++;
    if (iTotPolAnti > 0) iTotProp++;
    if (iTotFlorLoto > 0) iTotProp++;
    if (iTotBriSusu > 0) iTotProp++;
    if (iTotDieBod > 0) iTotProp++;
    if (iTotTrampas > 0) iTotProp++;
    if ( iTotProp > 3){
    if (GetGoldPieceValue(oObjeto) < 50000){
        SetLocalInt(oObjeto, "masNivel15", 1);
//        AddItemProperty(DURATION_TYPE_PERMANENT, ITEM_PROPERTY_ADDITIONAL
    }
}

       //para poder personalizar el nombre metiendo en el contenedor una hoja con el nombre
    //en el nombre de la hoja se pondra para el nombre, y en descripcion para quien
    object  oPapel=GetFirstItemInInventory(oUbicado);
    while(oPapel!=OBJECT_INVALID) {

        if(GetTag(oPapel)=="esc_papel")
        {
        string sNomPapel = GetName(oPapel);
        if (sNomPapel!=""){sNameAux = sNameAux + " de " +sNomPapel;}
        string sDesPapel = GetDescription(oPapel);
        if (sDesPapel!=""){sDescripAux = sDescripAux + " Fabricada para " + sDesPapel;}
        break;
        }

        oPapel=GetNextItemInInventory(oUbicado);
    }

    //

        // //
//////

    string sOroAux = IntToString(ValorOroPorObjeto(oObjeto));

    int iOroAux = ValorOroPorObjeto(oObjeto);
    SetLocalInt(oObjeto,"OROVENTA",iOroAux);
    //SetDescription(oObjeto,sDescripAux ,TRUE);
    SetDescription(oObjeto,sDescripAux,FALSE);
    SetLocalInt(oObjeto,"CRAFT_ARMORPELE",1);
    //experimento para la descripcion
    SetLocalString(oUbicado, "DescripcionObjeto",sDescripAux);
    SetLocalString(oUbicado, "NombreObjeto",sNameAux);
    //

    SetLocalObject(oUbicado, "ObjetoCreado", oObjeto);

}






int DificultadArmadura(string sNomMaterial)  {

    int iDifAux = 0;
    //Calculamos la dificultad de crear la armadura
    //Primera la dificultad inicial por tipo de cuero
    if (sNomMaterial=="sapo_cuero_rata")
   {iDifAux = 80;
   }
   if (sNomMaterial=="sapo_cuero_serpi" || sNomMaterial=="sapo_cuero_murci")
   {iDifAux = 100;
   }
   if (sNomMaterial=="sapo_cuero_cierv" || sNomMaterial=="sapo_cuero_rothe")
   {   iDifAux = 120;
   }
   if (sNomMaterial=="sapo_cuero_jabal" || sNomMaterial=="sapo_cuero_lagar")
   {   iDifAux = 140;
   }
   if (sNomMaterial=="sapo_cuero_oso"   || sNomMaterial=="sapo_cuero_wyrm")
   {   iDifAux = 150;
   }
   if (sNomMaterial=="sapo_cuero_lobo"  || sNomMaterial=="sapo_cuero_cani")
   {    iDifAux = 170;
   }
   if (sNomMaterial=="sapo_cuero_loboi")
   {   iDifAux = 180;
   }

    //Luego modificamos por tipo de armadura
    switch (iTipoArmadura)
    {
        case 0:   //tachonada
            iDifAux = iDifAux + 10;
            break;
        case 1:   //pieles
            iDifAux = iDifAux - 10;
            break;
        case 2:   //acolchada
            iDifAux = iDifAux - 20;
            break;
        case 3:   //cuero
             iDifAux = iDifAux;
             break;
        case 4:   //coraza
             iDifAux = iDifAux + 30;
             break;
        default:
            if (DEBUG) SpeakString("----No esta el tipo de armadura,mierda----");
            break;
    }
    //Finalmente aplicamos el aumento de dificultad por los bonos aplicados
        int iNumBonos;
        iNumBonos =
        //arenilla de azabache
        iTotAza    +
        //belladona
        iTotbelladona  +
        //aceite de oliva
        iTotaceite     +
        //tinte para cuero negro
        iTottinte      +
        //tinte para cuero verde
        iTotTintv      +
        //shandon
        iTotShandon     +
        //limo putrefacto
        iTotlimo       +
        //placas de pherlock
        iTotpher       +
        //piedra fria
        iTotpiedra     +
        //esencia de abjuracion
        iToteseabj     +
        //esencia de nigromancia
        iTotesenig     +
        //sapo_esencia_evo
        iTotEseEvo      +
        //pasta terrosa
        iTotpaster     +
        //raiz petrea
        iTotEseCon      +
        //abdomen de escarabajo de fuego
        iTotEseTra     +
        //glandula de seda
        iTotGlanSed +
        //Material de curacin
        iTotMatCur +
        //ojo de raksasha
        iTotOjoRak +
        //polvo de hadas
        iTotPolHada +
        //bolsa de maranyas
        iTotBolMara +
        //cuerda con garfio
        iTotCuerGarf +
        //hoguera
        iTotHogue +
        //polvo antiluz
        iTotPolAnti +
        //flor de loto
        iTotFlorLoto +
        //Brisa susurrante
        iTotBriSusu +
        //diente de Bodak
        iTotDieBod +
        //Trampas
        iTotTrampas
  ;
        //
        //En principio cada bono aumenta 4 la dificultad
        int iModDif = 0;
        if (iNumBonos==0)
        {
         iModDif =  0;
        }
        else
        {
         iModDif = iNumBonos * 4;
        }
        //También tener en cuenta que el bono por numeros de cueros es (+1 +60 dif, +2 +120dif, +3 +180 dif)
        //y para rata y serpiente quizas hagan falta el doble de pieles
        int iModDifBon = 0;
        int iAux = 0;
        if (iTotTelas > 0 || iTotPieles)
        {
          //modificador dificultad para acolchada
          if (iTotTelas >0)
          {iAux = iTotTelas -1;
          }
          //modificador dificultad para pieles
          if (iTotPieles >0)
          {iAux = iTotPieles -1;
          }
        }
        else
        {
          //modificador dificultad para las de cuero
          iAux = iTotMateriales -1;
        }
        iModDifBon = iAux *60;
        //if (sNomMaterial=="sapo_cuero_rata" || sNomMaterial=="sapo_cuero_serpiente")
        //la dificultad de no penalizar conjuros dif 10

         int iModConj = iTotObs * 10;



        //
        iDifAux = iDifAux + iModDif + iModDifBon + iModConj;
        //con habilidad 100 lo maximo que se puede llegar es 570 con al menos un minimo
        if (iDifAux>570) {iDifAux=570;}
    //


    return iDifAux;


}


int Bono_Cuero_Rata(object oUbicado)  {

//aqui por un lado se ponen los bonos que hay al tiempo que si hay materiales no permitidos se da error
    //en estos bonos lo que hago es limitar a seis, luego quizas pongo otro limite
    //bono esconderse
    if (iTottinte >7)
       {iTottinte = 7;}
    if (iTotTintv >7)
       {iTotTintv = 7;}
    //bono buscar
    if (iTotShandon >7)
       {iTotShandon = 7;}
    //bono a enganyar
    if (iTotlimo >7)
       {iTotlimo = 7;}
    //bono para no penalizar lanzar conjuros
    if (iTotObs > 6)
       {iTotObs = 6;}
    //bono a trepar
    if (iTotGlanSed > 7)
       {iTotGlanSed = 7;}
    //bono nadar
    if (iTotPolHada > 7)
       {iTotPolHada = 7;}
    //bono a juego de manos
    if (iTotBolMara > 7)
       {iTotBolMara = 7;}

    //aqui comprobamos si hay elementos que no permitimos y que hacen no valida la receta
    if (
    //arenilla de azabache
    iTotAza > 0 ||
    //belladona
    iTotbelladona > 0 ||
    //aceite de oliva
    iTotaceite > 0 ||
    //tinte para cuero negro
    // iTottinte > 0 ||
    // iTotTintv > 0 ||
    //shandon
    // iTotShandon > 0 ||
    //limo putrefacto
    // iTotlimo > 0 ||
    //placas de pherlock
    iTotpher > 0 ||
    //piedra fria
    iTotpiedra > 0 ||
    //esencia de abjuracion
    iToteseabj > 0 ||
    //esencia de nigromancia
    iTotesenig > 0 ||
    //sapo_esencia_evo
    iTotEseEvo > 0 ||
    //pasta terrosa
    iTotpaster > 0 ||
    //raiz petrea
    iTotEseCon > 0 ||
    //abdomen de escarabajo de fuego
    iTotEseTra > 0 ||
    //glandula de seda
//    iTotGlanSed > 0 ||
    //Material de curacin
    iTotMatCur > 0 ||
    //ojo de raksasha
    iTotOjoRak > 0 ||
    //polvo de hadas
//    iTotPolHada > 0 ||
    //bolsa de maranyas
//    iTotBolMara > 0 ||
    //cuerda con garfio
    iTotCuerGarf > 0 ||
    //hoguera
    iTotHogue > 0 ||
    //polvo antiluz
    iTotPolAnti > 0 ||
    //flor de loto
    iTotFlorLoto > 0 ||
    //Brisa susurrante
    iTotBriSusu > 0 ||
    //diente de Bodak
    iTotDieBod > 0 ||
    //Trampas
    iTotTrampas
    )
    {
        AgregarPista(oUbicado,"*Has metido algun componente que no es valido para este tipo de cuero*");
        return FALSE;
    }
    return TRUE;
}

int Bono_Cuero_Serpiente(object oUbicado)  {

//aqui por un lado se ponen los bonos que hay al tiempo que si hay materiales no permitidos se da error
    //en estos bonos lo que hago es limitar a seis, luego quizas pongo otro limite
    //bono a supervivencia
    if(iTotbelladona >7)
       {iTotbelladona = 7;}
    //bono Sigilo
    if (iTotaceite >7)
       {iTotaceite = 7;}
    //bono reflejos
    if (iTotAza >3)
       {iTotAza = 3;}
    //bono a enganyar
    if (iTotlimo >7)
       {iTotlimo = 7;}
    //bono curar
    if(iTotMatCur >7)
       {iTotMatCur = 7;}
    //bono para no penalizar lanzar conjuros
    if (iTotObs > 6)
       {iTotObs = 6;}
    //bono a trepar
    if (iTotGlanSed > 7)
       {iTotGlanSed = 7;}
    //bono a nadar
    if (iTotPolHada > 7)
       {iTotPolHada = 7;}
    //bono a equilibrio
    if (iTotFlorLoto > 7)
       {iTotFlorLoto = 7;}
    //bono a escapismo
    if (iTotPolAnti > 7)
       {iTotPolAnti = 7;}
    //bono a uso de cuerdas
    if (iTotCuerGarf > 7)
       {iTotCuerGarf = 7;}

    //aqui comprobamos si hay elementos que no permitimos y que hacen no valida la receta
    if (
    //arenilla de azabache
    //iTotAza > 0 ||
    //belladona
    //iTotbelladona > 0 ||
    //aceite de oliva
    //iTotaceite > 0 ||
    //tinte para cuero negro
     iTottinte > 0 ||
     iTotTintv > 0 ||
    //shandon
     iTotShandon > 0 ||
    //limo putrefacto
    // iTotlimo > 0 ||
    //placas de pherlock
    iTotpher > 0 ||
    //piedra fria
    iTotpiedra > 0 ||
    //esencia de abjuracion
    iToteseabj > 0 ||
    //esencia de nigromancia
    iTotesenig > 0 ||
    //sapo_esencia_evo
    iTotEseEvo > 0 ||
    //pasta terrosa
    iTotpaster > 0 ||
    //raiz petrea
    iTotEseCon > 0 ||
    //abdomen de escarabajo de fuego
    iTotEseTra > 0 ||
    //kit de curacion
    //iTotkitcur > 0
    //glandula de seda
//    iTotGlanSed > 0 ||
    //Material de curacin
//    iTotMatCur > 0 ||
    //ojo de raksasha
    iTotOjoRak > 0 ||
    //polvo de hadas
//    iTotPolHada > 0 ||
    //bolsa de maranyas
    iTotBolMara > 0 ||
    //cuerda con garfio
//    iTotCuerGarf > 0 ||
    //hoguera
    iTotHogue > 0 ||
    //polvo antiluz
//    iTotPolAnti > 0 ||
    //flor de loto
//    iTotFlorLoto > 0 ||
    //Brisa susurrante
    iTotBriSusu > 0 ||
    //diente de Bodak
    iTotDieBod > 0 ||
    //Trampas
    iTotTrampas
    )
    {
        AgregarPista(oUbicado,"*Has metido algun componente que no es valido para este tipo de cuero*");
        return FALSE;
    }
    return TRUE;
}

int Bono_Cuero_Ciervo(object oUbicado)  {

//aqui por un lado se ponen los bonos que hay al tiempo que si hay materiales no permitidos se da error
    //en estos bonos lo que hago es limitar a seis, luego quizas pongo otro limite
      //bono reflejos
    if (iTotAza >3)
       {iTotAza = 3;}
    //bono DES
    if (iTotEseEvo >6)
       {iTotEseEvo = 6;}
    //bono movimiento
    if (iTotpaster >6)
       {iTotpaster = 6;}
        //bono para no penalizar lanzar conjuros
    if (iTotObs > 6)
       {iTotObs = 6;}
    //bono a escapismo
    if (iTotPolAnti > 7)
       {iTotPolAnti = 7;}
    //bono a saltar
    if (iTotBriSusu > 7)
       {iTotBriSusu = 7;}


    //aqui comprobamos si hay elementos que no permitimos y que hacen no valida la receta
    if (
    //arenilla de azabache
    //iTotAza > 0 ||
    //belladona
    iTotbelladona > 0 ||
    //aceite de oliva
    iTotaceite > 0 ||
    //tinte para cuero negro
     iTottinte > 0 ||
     iTotTintv > 0 ||
    //shandon
     iTotShandon > 0 ||
    //limo putrefacto
     iTotlimo > 0 ||
    //placas de pherlock
    iTotpher > 0 ||
    //piedra fria
    iTotpiedra > 0 ||
    //esencia de abjuracion
    iToteseabj > 0 ||
    //esencia de nigromancia
    iTotesenig > 0 ||
    //sapo_esencia_evo
    //iTotEseEvo > 0 ||
    //pasta terrosa
    //iTotpaster > 0 ||
    //raiz petrea
    iTotEseCon > 0 ||
    //abdomen de escarabajo de fuego
    iTotEseTra > 0 ||
    //glandula de seda
    iTotGlanSed > 0 ||
    //Material de curacin
    iTotMatCur > 0 ||
    //ojo de raksasha
    iTotOjoRak > 0 ||
    //polvo de hadas
    iTotPolHada > 0 ||
    //bolsa de maranyas
    iTotBolMara > 0 ||
    //cuerda con garfio
    iTotCuerGarf > 0 ||
    //hoguera
    iTotHogue > 0 ||
    //polvo antiluz
//    iTotPolAnti > 0 ||
    //flor de loto
    iTotFlorLoto > 0 ||
    //Brisa susurrante
//    iTotBriSusu > 0 ||
    //diente de Bodak
    iTotDieBod > 0 ||
    //Trampas
    iTotTrampas
    )
    {
        AgregarPista(oUbicado,"*Has metido algun componente que no es valido para este tipo de cuero*");
        return FALSE;
    }
    return TRUE;
}
int Bono_Cuero_Jabali(object oUbicado)  {

//aqui por un lado se ponen los bonos que hay al tiempo que si hay materiales no permitidos se da error
    //en estos bonos lo que hago es limitar a seis, luego quizas pongo otro limite
    //Buscar
     if (iTotShandon >7)
       {iTotShandon = 7;}
    //contra miedo    (M)
    if (iTotesenig >3)
       {iTotesenig = 3;}
    //CON     (M)
    if (iTotEseTra >6)
       {iTotEseTra = 6;}
        //bono para no penalizar lanzar conjuros
    if (iTotObs > 6)
       {iTotObs = 6;}
    //bono a intimidar
    if (iTotDieBod >7)
       {iTotDieBod = 7;}

    //aqui comprobamos si hay elementos que no permitimos y que hacen no valida la receta
    if (
    //arenilla de azabache
    iTotAza > 0 ||
    //belladona
    iTotbelladona > 0 ||
    //aceite de oliva
    iTotaceite > 0 ||
    //tinte para cuero negro
    iTottinte > 0 ||
    iTotTintv > 0 ||
    //shandon
    //iTotShandon > 0 ||
    //limo putrefacto
    //iTotlimo > 0 ||
    //placas de pherlock
    iTotpher > 0 ||
    //piedra fria
    iTotpiedra > 0 ||
    //esencia de abjuracion
    iToteseabj > 0 ||
    //esencia de nigromancia
    //iTotesenig > 0 ||
    //sapo_esencia_evo
    iTotEseEvo > 0 ||
    //pasta terrosa
    iTotpaster > 0 ||
    //raiz petrea
    iTotEseCon > 0 ||
    //abdomen de escarabajo de fuego
    //iTotEseTra > 0 ||
    //glandula de seda
    iTotGlanSed > 0 ||
    //Material de curacin
    iTotMatCur > 0 ||
    //ojo de raksasha
    iTotOjoRak > 0 ||
    //polvo de hadas
    iTotPolHada > 0 ||
    //bolsa de maranyas
    iTotBolMara > 0 ||
    //cuerda con garfio
    iTotCuerGarf > 0 ||
    //hoguera
    iTotHogue > 0 ||
    //polvo antiluz
    iTotPolAnti > 0 ||
    //flor de loto
    iTotFlorLoto > 0 ||
    //Brisa susurrante
    iTotBriSusu > 0 ||
    //diente de Bodak
//    iTotDieBod > 0 ||
    //Trampas
    iTotTrampas

    )
    {
        AgregarPista(oUbicado,"*Has metido algun componente que no es valido para este tipo de cuero*");
        return FALSE;
    }
    return TRUE;
}
int Bono_Cuero_Oso(object oUbicado)  {

//aqui por un lado se ponen los bonos que hay al tiempo que si hay materiales no permitidos se da error
    //en estos bonos lo que hago es limitar a seis, luego quizas pongo otro limite
    //FUE
     if (iTotEseCon >6)
       {iTotEseCon = 6;}
    //Resdaño
    if (iTotpher >6)
       {iTotpher = 6;}
    // bono a sanar
    if (iTotMatCur >7)
       {iTotMatCur = 7;}
        //bono para no penalizar lanzar conjuros
    if (iTotObs > 6)
       {iTotObs = 6;}

    // bono a concentracion
    if (iTotOjoRak >7)
       {iTotOjoRak = 7;}

    // bono a nadar
    if (iTotPolHada >7)
       {iTotPolHada = 7;}

    // bono a intimidar
    if (iTotDieBod >7)
       {iTotDieBod = 7;}

    //bono a supervivencia
    if(iTotbelladona >7)
       {iTotbelladona = 7;}



    //aqui comprobamos si hay elementos que no permitimos y que hacen no valida la receta
    if (
    //arenilla de azabache
    iTotAza > 0 ||
    //belladona
//    iTotbelladona > 0 ||
    //aceite de oliva
    iTotaceite > 0 ||
    //tinte para cuero negro
    iTottinte > 0 ||
    iTotTintv > 0 ||
    //shandon
    iTotShandon > 0 ||
    //limo putrefacto
    iTotlimo > 0 ||
    //placas de pherlock
    //iTotpher > 0 ||
    //piedra fria
    iTotpiedra > 0 ||
    //esencia de abjuracion
    iToteseabj > 0 ||
    //esencia de nigromancia
    iTotesenig > 0 ||
    //sapo_esencia_evo
    iTotEseEvo > 0 ||
    //pasta terrosa
    iTotpaster > 0 ||
    //raiz petrea
    //iTotEseCon > 0 ||
    //abdomen de escarabajo de fuego
    iTotEseTra > 0  ||
     //glandula de seda
    iTotGlanSed > 0 ||
    //Material de curacin
    iTotMatCur > 0 ||
    //ojo de raksasha
//    iTotOjoRak > 0 ||
    //polvo de hadas
//    iTotPolHada > 0 ||
    //bolsa de maranyas
    iTotBolMara > 0 ||
    //cuerda con garfio
    iTotCuerGarf > 0 ||
    //hoguera
    iTotHogue > 0 ||
    //polvo antiluz
    iTotPolAnti > 0 ||
    //flor de loto
    iTotFlorLoto > 0 ||
    //Brisa susurrante
    iTotBriSusu > 0 ||
    //diente de Bodak
//    iTotDieBod > 0 ||
    //Trampas
    iTotTrampas
   )
    {
        AgregarPista(oUbicado,"*Has metido algun componente que no es valido para este tipo de cuero*");
        return FALSE;
    }
    return TRUE;
}
int Bono_Cuero_Lobo(object oUbicado)  {

//aqui por un lado se ponen los bonos que hay al tiempo que si hay materiales no permitidos se da error
    //en estos bonos lo que hago es limitar a seis, luego quizas pongo otro limite
    //Esconderse
    if (iTottinte >7)
       {iTottinte = 7;}
    if (iTotTintv > 7)
       {iTotTintv = 7;}
    //Sigilo
    if (iTotaceite >7)
       {iTotaceite = 7;}
    //Buscar
    if (iTotShandon >7)
       {iTotShandon = 7;}
    //regeneracion
    if (iToteseabj >1)
       {iToteseabj = 1;}
    //-Movimiento o Reducción Peso
    if (iTotpaster >6)
       {iTotpaster = 6;}
        //bono para no penalizar lanzar conjuros
    if (iTotObs > 6)
       {iTotObs = 6;}
    //saltar
    if (iTotBriSusu >7)
       {iTotBriSusu = 7;}
    //disfrazarse
    if (iTotHogue >7)
       {iTotHogue = 7;}
    //equilibrio
    if (iTotFlorLoto >7)
       {iTotFlorLoto = 7;}
    //escapismo
    if (iTotPolAnti >7)
       {iTotPolAnti = 7;}
    //intimidar
    if (iTotDieBod >7)
       {iTotDieBod = 7;}
    //bono a supervivencia
    if(iTotbelladona >7)
       {iTotbelladona = 7;}

    //aqui comprobamos si hay elementos que no permitimos y que hacen no valida la receta
    if (
    //arenilla de azabache
    iTotAza > 0 ||
    //belladona
//    iTotbelladona > 0 ||
    //aceite de oliva
    //iTotaceite > 0 ||
    //tinte para cuero negro
    //iTottinte > 0 ||
    //iTotTintv > 0 ||
    //shandon
    //iTotShandon > 0 ||
    //limo putrefacto
    iTotlimo > 0 ||
    //placas de pherlock
    iTotpher > 0 ||
    //piedra fria
    iTotpiedra > 0 ||
    //esencia de abjuracion
    //iToteseabj > 0 ||
    //esencia de nigromancia
    iTotesenig > 0 ||
    //sapo_esencia_evo
    iTotEseEvo > 0 ||
    //pasta terrosa
    //iTotpaster > 0 ||
    //raiz petrea
    iTotEseCon > 0 ||
    //abdomen de escarabajo de fuego
    iTotEseTra > 0 ||
    //glandula de seda
    iTotGlanSed > 0 ||
    //Material de curacin
    iTotMatCur > 0 ||
    //ojo de raksasha
    iTotOjoRak > 0 ||
    //polvo de hadas
    iTotPolHada > 0 ||
    //bolsa de maranyas
    iTotBolMara > 0 ||
    //cuerda con garfio
    iTotCuerGarf > 0 ||
    //hoguera
//    iTotHogue > 0 ||
    //polvo antiluz
//    iTotPolAnti > 0 ||
    //flor de loto
//    iTotFlorLoto > 0 ||
    //Brisa susurrante
//    iTotBriSusu > 0 ||
    //diente de Bodak
//    iTotDieBod > 0 ||
    //Trampas
    iTotTrampas
    )
    {
        AgregarPista(oUbicado,"*Has metido algun componente que no es valido para este tipo de cuero*");
        return FALSE;
    }
    return TRUE;
}
int Bono_Cuero_Loboinvern(object oUbicado)  {

//aqui por un lado se ponen los bonos que hay al tiempo que si hay materiales no permitidos se da error
    //en estos bonos lo que hago es limitar a seis, luego quizas pongo otro limite
    //Esconderse
    if (iTottinte >10)
       {iTottinte = 10;}
    if (iTotTintv > 10)
       {iTotTintv = 10;}
    //Sigilo
    if (iTotaceite >10)
       {iTotaceite = 10;}
    //-Movimiento o Reducción Peso
    if (iTotpaster >6)
       {iTotpaster = 6;}
    //Res Daño       (M)
    if (iTotpher >6)
       {iTotpher = 6;}
    //Res Frio
    if (iTotpiedra >6)
       {iTotpiedra = 6;}
        //bono para no penalizar lanzar conjuros
    if (iTotObs > 6)
       {iTotObs = 6;}
    //saltar
    if (iTotBriSusu >10)
       {iTotBriSusu = 10;}
    //disfrazarse
    if (iTotHogue >10)
       {iTotHogue = 10;}
    //equilibrio
    if (iTotFlorLoto >10)
       {iTotFlorLoto = 10;}
    //escapismo
    if (iTotPolAnti >10)
       {iTotPolAnti = 10;}
    //intimidar
    if (iTotDieBod >10)
       {iTotDieBod = 10;}
    //bono a supervivencia
    if(iTotbelladona >10)
       {iTotbelladona = 10;}

    //aqui comprobamos si hay elementos que no permitimos y que hacen no valida la receta
    if (
    //arenilla de azabache
    iTotAza > 0 ||
    //belladona
//    iTotbelladona > 0 ||
    //aceite de oliva
    //iTotaceite > 0 ||
    //tinte para cuero negro
    //iTottinte > 0 ||
    //shandon
    iTotShandon > 0 ||
    //limo putrefacto
    iTotlimo > 0 ||
    //placas de pherlock
    //iTotpher > 0 ||
    //piedra fria
    //iTotpiedra > 0 ||
    //esencia de abjuracion
    iToteseabj > 0 ||
    //esencia de nigromancia
    iTotesenig > 0 ||
    //sapo_esencia_evo
    iTotEseEvo > 0 ||
    //pasta terrosa
    //iTotpaster > 0 ||
    //raiz petrea
    iTotEseCon > 0 ||
    //abdomen de escarabajo de fuego
    iTotEseTra > 0 ||
    //glandula de seda
    iTotGlanSed > 0 ||
    //Material de curacin
    iTotMatCur > 0 ||
    //ojo de raksasha
    iTotOjoRak > 0 ||
    //polvo de hadas
    iTotPolHada > 0 ||
    //bolsa de maranyas
    iTotBolMara > 0 ||
    //cuerda con garfio
    iTotCuerGarf > 0 ||
    //hoguera
//    iTotHogue > 0 ||
    //polvo antiluz
//    iTotPolAnti > 0 ||
    //flor de loto
//    iTotFlorLoto > 0 ||
    //Brisa susurrante
//    iTotBriSusu > 0 ||
    //diente de Bodak
//    iTotDieBod > 0 ||
    //Trampas
    iTotTrampas
    )
    {
        AgregarPista(oUbicado,"*Has metido algun componente que no es valido para este tipo de cuero*");
        return FALSE;
    }
    return TRUE;
}
