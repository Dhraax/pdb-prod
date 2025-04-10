#include "sapo_constantes"
#include "sapo_func_recetas"
#include "sapo_rect_12_inc"
#include "x2_inc_itemprop"

const string MASCARA_BASE="sapo_plnt12_";
const string MASCARA_MATERIAL="sapo_cuero_";
const string KIT_HERRAMIENTA1="sapo_kitcuero";
const string CONTENEDOR_CREAR="sapo_cont_marroq";
const int PROP_MAX =2;
const int CAR_MAX=6;
const int HAB_MAX = 7;
const int SAL_MAX=4;
const int RED_MAX=1;
const int AC_MAX=5;

int ComprobarComponentesYCargar(object oUbicado);
int CargarVariables(object oUbicado, string sNomBase, string sNomMaterial);
int CargarVariablesFormula(object oUbicado, string sNomBase, string sNomMaterial);
int DificultadSegunBase(string sNomBase);
int DificultadSegunMaterial(string sNomMaterial);
int MaterialesSegunBase(string sNomBase);
string SubparteParaNombreSegunBase(string sNomBase);
string SubparteParaNombreSegunMaterial(string sNomMaterial);

//las que creo yo para el sistema
void CrearObjeto(object oUbicado);
int DificultadCosa(string sNomMaterial);
int iTipoCosa;
int Bono_Guantes(object oUbicado);
int Bono_Botas(object oUbicado);
int Bono_Cintos(object oUbicado);
int Bono_Capas(object oUbicado);
int Bono_Capucha(object oUbicado);

//variables de materiales
int iTotMateriales;
//variable para el total de propiedades
int iTotProp=0;

//Picada Rocosa
int iPicadaRocosa;
//esencia de transmutacion
int iEsenTran;
//esencia evocacion
int iEsenEvoc;
//esencia conjuracion
int iEsenConj;
//esencia adivinacion
int iEsenAdiv;
//NUEVO esencia ilusion
int iEsenIlus;
//aceite
int iTotaceite;
//tinte negro
int iTottinte;
//tinte para cuero verde
int iTotTintv;
//espejo de mano
int iTotEspejo;
//arenilla de azabache
int iTotAza;
//esencia sulfurosa
int iTotSulf;
//Guia comercial
int iTotGui;//iTotBara;
//Diente de tiburon
int iTotDienteT;
//estatuilla de sirena
int iTotEstaS;
//piedra fria
int iTotpiedra;
//esencia de abjuracion
int iToteseabj;
//zumo acuoso
int iTotzumac;
//pasta terrosa
int iTotpaster;
//raiz petrea
int iTotraipe;
//abdomen de escarabajo
int iTotabdesc;
//herramientas de ladron +1
int iTotHerLad;
//caracol de tierra
int iTotCarTie;
//viruta resplandeciente
int iTotVirRes;
//shandon
int iTotShandon;
//Diopsido
int iTotDiopsido;
//concha
int iTotConcha;
//fruto fantasma
int iTotFrutFan;
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
//humo gaseoso
int iTotHumGas;
//polvo antiluz
int iTotPolAnti;
//flor de loto
int iTotFlorLoto;
//brisa susurrante;
int iTotBriSusu;
//Baya acuosa
int iTotBayAcuo;
//diente de bodak
int iTotDieBod;
//belladona
int iTotBelladona;
//trampas
int iTotTrampas;


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

    // a partir de aqui es la lista de materiales para combinar
    // aqui defino y cargo los materiales que se pueden usar en las recetas de guarnicionador

        SetLocalString(oUbicado,"fnMaterialMascara3","picadarocosa");
        SetLocalString(oUbicado,"fnMaterialMascara4","sapo_esencia_tra");
        SetLocalString(oUbicado,"fnMaterialMascara5","sapo_esencia_evo");
        SetLocalString(oUbicado,"fnMaterialMascara6","sapo_esencia_con");
        SetLocalString(oUbicado,"fnMaterialMascara7","sapo_esencia_adi");
        SetLocalString(oUbicado,"fnMaterialMascara8","AceiteSigilo");
        SetLocalString(oUbicado,"fnMaterialMascara9","x2_it_dyel23");
        SetLocalString(oUbicado,"fnMaterialMascara10","espejodemano");
        SetLocalString(oUbicado,"fnMaterialMascara11","polvo_aza");
        SetLocalString(oUbicado,"fnMaterialMascara12","especiasulfurosa");
        SetLocalString(oUbicado,"fnMaterialMascara13","Guadelaventurero");
        SetLocalString(oUbicado,"fnMaterialMascara14","dientetiburon");
        SetLocalString(oUbicado,"fnMaterialMascara15","estatuasirena");
        SetLocalString(oUbicado,"fnMaterialMascara16","x1_it_msmlmisc01");
        SetLocalString(oUbicado,"fnMaterialMascara17","pb_artesa_reg");
        SetLocalString(oUbicado,"fnMaterialMascara18","zumoacuoso");
        SetLocalString(oUbicado,"fnMaterialMascara19","pastaterrosa");
        SetLocalString(oUbicado,"fnMaterialMascara20","raizpetrea");
        SetLocalString(oUbicado,"fnMaterialMascara21","NW_IT_MSMLMISC08");
        SetLocalString(oUbicado,"fnMaterialMascara22","NW_IT_PICKS001");
        SetLocalString(oUbicado,"fnMaterialMascara23","caracoldetierra");
        SetLocalString(oUbicado,"fnMaterialMascara24","virutasresplande");
        SetLocalString(oUbicado,"fnMaterialMascara25","shandon");
        SetLocalString(oUbicado,"fnMaterialMascara26","diopsidoestrella");
        SetLocalString(oUbicado,"fnMaterialMascara27","basura_concha");
        SetLocalString(oUbicado,"fnMaterialMascara28","frutofantasma");
        SetLocalString(oUbicado,"fnMaterialMascara29","x2_it_dyel48");
        SetLocalString(oUbicado,"fnMaterialMascara30","sapo_esencia_ilu");
        SetLocalString(oUbicado,"fnMaterialMascara31","NW_IT_MSMLMISC07");
        SetLocalString(oUbicado,"fnMaterialMascara32","vendas_pb_01");
        SetLocalString(oUbicado,"fnMaterialMascara33","NW_IT_MSMLMISC09");
        SetLocalString(oUbicado,"fnMaterialMascara34","NW_IT_MSMLMISC19");
        SetLocalString(oUbicado,"fnMaterialMascara35","X1_WMGRENADE006");
        SetLocalString(oUbicado,"fnMaterialMascara36","gz_it_rope");
        SetLocalString(oUbicado,"fnMaterialMascara37","humoGaseoso");
        SetLocalString(oUbicado,"fnMaterialMascara38","polvoantiluz");
        SetLocalString(oUbicado,"fnMaterialMascara39","pb_artesa_hab31"); // Luz cegadora de bezekira -> Equilibrio
        SetLocalString(oUbicado,"fnMaterialMascara40","brisaSusurrante");
        SetLocalString(oUbicado,"fnMaterialMascara41","bayaAcuosa");
        SetLocalString(oUbicado,"fnMaterialMascara42","NW_IT_MSMLMISC06");
        SetLocalString(oUbicado,"fnMaterialMascara43","NW_IT_MSMLMISC23");
        SetLocalString(oUbicado,"fnMaterialMascara44","NW_IT_TRAP001");

    ////////////////////////////////////////////////////////////////
    //llama al buscador
    ExecuteScript("sapo_rect_gen",OBJECT_SELF);
    //guardo en variables internas los totales que me haya devuelto elbuscador
    string sNomBase=GetLocalString(oUbicado,"fnMaterialRetorno1");
    int iTotBases=GetLocalInt(oUbicado,"fnMaterialRetornoTotal1");

    string sNomMaterial=GetLocalString(oUbicado,"fnMaterialRetorno2");
    iTotMateriales=GetLocalInt(oUbicado,"fnMaterialRetornoTotal2");

    int iTotMaterialesUbicado=GetLocalInt(oUbicado,"fnMaterialesRetornoTotal");
    int iRetorno=GetLocalInt(oUbicado,"fnRetorno");
    //componentes nuevos



    string sNomPicada=GetLocalString(oUbicado,"fnMaterialRetorno3");
    iPicadaRocosa=GetLocalInt(oUbicado,"fnMaterialRetornoTotal3");
    string sNomEsenTran=GetLocalString(oUbicado,"fnMaterialRetorno4");
    iEsenTran=GetLocalInt(oUbicado,"fnMaterialRetornoTotal4");
    string sNomEsenEvoc=GetLocalString(oUbicado,"fnMaterialRetorno5");
    iEsenEvoc=GetLocalInt(oUbicado,"fnMaterialRetornoTotal5");
    string sNomEsenConj=GetLocalString(oUbicado,"fnMaterialRetorno6");
    iEsenConj=GetLocalInt(oUbicado,"fnMaterialRetornoTotal6");
    string sNomEsenAdiv=GetLocalString(oUbicado,"fnMaterialRetorno7");
    iEsenAdiv=GetLocalInt(oUbicado,"fnMaterialRetornoTotal7");
    string sNomTotaceite=GetLocalString(oUbicado,"fnMaterialRetorno8");
    iTotaceite=GetLocalInt(oUbicado,"fnMaterialRetornoTotal8");
    string sNomTottinte=GetLocalString(oUbicado,"fnMaterialRetorno9");
    iTottinte=GetLocalInt(oUbicado,"fnMaterialRetornoTotal9");
    string sNomEspejo=GetLocalString(oUbicado,"fnMaterialRetorno10");
    iTotEspejo=GetLocalInt(oUbicado,"fnMaterialRetornoTotal10");
    string sNomTotAza=GetLocalString(oUbicado,"fnMaterialRetorno11");
    iTotAza=GetLocalInt(oUbicado,"fnMaterialRetornoTotal11");
    string sNomTotSulf=GetLocalString(oUbicado,"fnMaterialRetorno12");
    iTotSulf=GetLocalInt(oUbicado,"fnMaterialRetornoTotal12");
    string sNomTotGui=GetLocalString(oUbicado,"fnMaterialRetorno13");
    iTotGui=GetLocalInt(oUbicado,"fnMaterialRetornoTotal13");
    string sNomDienteT=GetLocalString(oUbicado,"fnMaterialRetorno14");
    iTotDienteT=GetLocalInt(oUbicado,"fnMaterialRetornoTotal14");
    string sNomTotEstaS=GetLocalString(oUbicado,"fnMaterialRetorno15");
    iTotEstaS=GetLocalInt(oUbicado,"fnMaterialRetornoTotal15");
    string sNomTotpiedra=GetLocalString(oUbicado,"fnMaterialRetorno16");
    iTotpiedra=GetLocalInt(oUbicado,"fnMaterialRetornoTotal16");
    string sNomToteseabj=GetLocalString(oUbicado,"fnMaterialRetorno17");
    iToteseabj=GetLocalInt(oUbicado,"fnMaterialRetornoTotal17");
    string sNomTotzumac=GetLocalString(oUbicado,"fnMaterialRetorno18");
    iTotzumac=GetLocalInt(oUbicado,"fnMaterialRetornoTotal18");
    string sNomTotpaster=GetLocalString(oUbicado,"fnMaterialRetorno19");
    iTotpaster=GetLocalInt(oUbicado,"fnMaterialRetornoTotal19");
    string sNomTotraipe=GetLocalString(oUbicado,"fnMaterialRetorno20");
    iTotraipe=GetLocalInt(oUbicado,"fnMaterialRetornoTotal20");
    string sNomTotabdesc=GetLocalString(oUbicado,"fnMaterialRetorno21");
    iTotabdesc=GetLocalInt(oUbicado,"fnMaterialRetornoTotal21");
    string sNomTotHerLad=GetLocalString(oUbicado,"fnMaterialRetorno22");
    iTotHerLad=GetLocalInt(oUbicado,"fnMaterialRetornoTotal22");
    string sNomTotCarTie=GetLocalString(oUbicado,"fnMaterialRetorno23");
    iTotCarTie=GetLocalInt(oUbicado,"fnMaterialRetornoTotal23");
    string sNomTotVirRes=GetLocalString(oUbicado,"fnMaterialRetorno24");
    iTotVirRes=GetLocalInt(oUbicado,"fnMaterialRetornoTotal24");
    string sNomTotShandon=GetLocalString(oUbicado,"fnMaterialRetorno25");
    iTotShandon=GetLocalInt(oUbicado,"fnMaterialRetornoTotal25");
    string sNomTotDiopsido=GetLocalString(oUbicado,"fnMaterialRetorno26");
    iTotDiopsido=GetLocalInt(oUbicado,"fnMaterialRetornoTotal26");
    string sNomTotConcha=GetLocalString(oUbicado,"fnMaterialRetorno27");
    iTotConcha=GetLocalInt(oUbicado,"fnMaterialRetornoTotal27");
    string sNomTotFrutFan=GetLocalString(oUbicado,"fnMaterialRetorno28");
    iTotFrutFan=GetLocalInt(oUbicado,"fnMaterialRetornoTotal28");
    string sNomTintv=GetLocalString(oUbicado,"fnMaterialRetorno29");
    iTotTintv=GetLocalInt(oUbicado,"fnMaterialRetornoTotal29");
    string sNomTotEsIl=GetLocalString(oUbicado,"fnMaterialRetorno30");
    iEsenIlus=GetLocalInt(oUbicado,"fnMaterialRetornoTotal30");
    string sNomTotGlaSed=GetLocalString(oUbicado,"fnMaterialRetorno31");
    iTotGlanSed=GetLocalInt(oUbicado,"fnMaterialRetornoTotal31");
    string sNomTotMatCur=GetLocalString(oUbicado,"fnMaterialRetorno32");
    iTotMatCur=GetLocalInt(oUbicado,"fnMaterialRetornoTotal32");
    string sNomTotOjRak=GetLocalString(oUbicado,"fnMaterialRetorno33");
    iTotOjoRak=GetLocalInt(oUbicado,"fnMaterialRetornoTotal33");
    string sNomTotPoHad=GetLocalString(oUbicado,"fnMaterialRetorno34");
    iTotPolHada=GetLocalInt(oUbicado,"fnMaterialRetornoTotal34");
    string sNomTotBolMar=GetLocalString(oUbicado,"fnMaterialRetorno35");
    iTotBolMara=GetLocalInt(oUbicado,"fnMaterialRetornoTotal35");
    string sNomTotCuGar=GetLocalString(oUbicado,"fnMaterialRetorno36");
    iTotCuerGarf=GetLocalInt(oUbicado,"fnMaterialRetornoTotal36");
    string sNomTotHuGas=GetLocalString(oUbicado,"fnMaterialRetorno37");
    iTotHumGas=GetLocalInt(oUbicado,"fnMaterialRetornoTotal37");
    string sNomTotPolAnt=GetLocalString(oUbicado,"fnMaterialRetorno38");
    iTotPolAnti=GetLocalInt(oUbicado,"fnMaterialRetornoTotal38");
    string sNomTotFlLot=GetLocalString(oUbicado,"fnMaterialRetorno39");
    iTotFlorLoto=GetLocalInt(oUbicado,"fnMaterialRetornoTotal39");
    string sNomTotBrSus=GetLocalString(oUbicado,"fnMaterialRetorno40");
    iTotBriSusu=GetLocalInt(oUbicado,"fnMaterialRetornoTotal40");
    string sNomTotBaAcu=GetLocalString(oUbicado,"fnMaterialRetorno41");
    iTotBayAcuo=GetLocalInt(oUbicado,"fnMaterialRetornoTotal41");
    string sNomTotDiBod=GetLocalString(oUbicado,"fnMaterialRetorno42");
    iTotDieBod=GetLocalInt(oUbicado,"fnMaterialRetornoTotal42");
    string sNomTotBelladona=GetLocalString(oUbicado,"fnMaterialRetorno43");
    iTotBelladona=GetLocalInt(oUbicado,"fnMaterialRetornoTotal43");
    string sNomTotTrampas=GetLocalString(oUbicado,"fnMaterialRetorno44");
    iTotTrampas=GetLocalInt(oUbicado,"fnMaterialRetornoTotal44");



    BorrarVariablesParaScript_sapo_rect_gen(oUbicado);

    //si ya el script rect gen dice que no es valido no continuo

    if (iRetorno==FALSE) return FALSE;
    //aqui verifico los materiales distintos y segun doy pista
    if (iTotBases>1) {
        AgregarPista(oUbicado,"*Necesitas una unica plantilla*");
        return FALSE;
    }
    if (iTotBases<=0) {
        AgregarPista(oUbicado,"*Necesitas alguna plantilla*");
        return FALSE;
    }
     if (iTotBases=0) {
        AgregarPista(oUbicado,"*Necesitas alguna plantilla*");
        return FALSE;
    }

     if (sNomBase==MASCARA_BASE + "armd") {
        AgregarPista(oUbicado,"*Un " + NombreMaestro(PROFESIONES_MARROQUINERIA) + " no sabe hacer armaduras*");
        return FALSE;
    }

    if (iTotMateriales!=1) {
        AgregarPista(oUbicado,"*Necesitas un cuero*");
        return FALSE;
    }


    int iTotalHerramientas=TotalMaterialEnInventarioSegunNombre(oUbicado,KIT_HERRAMIENTA1,FALSE);

    if (iTotalHerramientas!=1) {
        AgregarPista(oUbicado,"*Necesitas herramientas para trabajar el cuero*");
        return FALSE;
    }



    //clasifico primero el tipo de plantilla para ver que quiero hacer
    if (sNomBase==MASCARA_BASE + "guan") iTipoCosa=1;
    if (sNomBase==MASCARA_BASE + "bota") iTipoCosa=2;
    if (sNomBase==MASCARA_BASE + "cint") iTipoCosa=3;
    if (sNomBase==MASCARA_BASE + "capa") iTipoCosa=4;
    if (sNomBase==MASCARA_BASE + "capu") iTipoCosa=5;


    //Valido si he puesto piel valida para la plantilla y si es asi comprobare luego los bonos
    switch (iTipoCosa)
    {
        case 1:
            if ( sNomMaterial == "sapo_cuero_rata" || sNomMaterial == "sapo_cuero_serpi"
                                                   || sNomMaterial == "sapo_cuero_murci")
            {
            //son pieles validas y pasamos a ver si tiene ingredientes validos
            if (Bono_Guantes(oUbicado)==FALSE) return FALSE;


            }
            else
            {
               AgregarPista(oUbicado,"*Con estos cueros no hacemos guantes*");
               return FALSE;
            }
            break;
        case 2:
             if ( sNomMaterial == "sapo_cuero_cierv" || sNomMaterial == "sapo_cuero_jabal"
               || sNomMaterial == "sapo_cuero_rothe" || sNomMaterial == "sapo_cuero_lagar")
            {
            //son pieles validas y pasamos a ver si tiene ingredientes validos
            if (Bono_Botas(oUbicado)==FALSE) return FALSE;


            }
            else
            {
               AgregarPista(oUbicado,"*Con estos cueros no hacemos botas*");
               return FALSE;
            }
            break;
        case 3:
            if ( sNomMaterial == "sapo_cuero_oso" || sNomMaterial == "sapo_cuero_lobo"
              || sNomMaterial == "sapo_cuero_wyrm"|| sNomMaterial == "sapo_cuero_cani")
            {
            //son pieles validas y pasamos a ver si tiene ingredientes validos
            if (Bono_Cintos(oUbicado)==FALSE) return FALSE;


            }
            else
            {
               AgregarPista(oUbicado,"*Con estos cueros no hacemos cintos*");
               return FALSE;
            }
            break;
        case 4:
            if ( sNomMaterial == "sapo_cuero_oso" || sNomMaterial == "sapo_cuero_lobo"
               ||sNomMaterial == "sapo_cuero_loboi" || sNomMaterial == "sapo_cuero_wyrm"
               || sNomMaterial == "sapo_cuero_cani")
            {
            //son pieles validas y pasamos a ver si tiene ingredientes validos
            if (Bono_Capas(oUbicado)==FALSE) return FALSE;


            }
            else
            {
               AgregarPista(oUbicado,"*Con estos cueros no hacemos capas*");
               return FALSE;
            }
            break;
        case 5:
            if ( sNomMaterial == "sapo_cuero_cierv" || sNomMaterial == "sapo_cuero_rothe" )
            {
            //son pieles validas y pasamos a ver si tiene ingredientes validos
            if (Bono_Capucha(oUbicado)==FALSE) return FALSE;


            }
            else
            {
               AgregarPista(oUbicado,"*Con estos cueros no hacemos capuchas*");
               return FALSE;
            }
            break;
    }


    //SpeakString("Cueros: " + IntToString(iTotMateriales));
    //SpeakString("Materiales: " + IntToString(iTotMaterialesUbicado));
    //SendMessageToPC(GetFirstPC(), "Cueros: " + IntToString(iTotMateriales));

    //limitamos a 8 esencias para caracteristicas, sino decimos que sobran
    if ( (iEsenTran + iEsenEvoc + iEsenConj + iEsenAdiv +iEsenIlus) > CAR_MAX ){
        AgregarPista(oUbicado,"*¡¡Has puesto demasiadas esencias!!*");
        return FALSE;
    }
    //Limitamos a 14 ingredientes para habilidades, sino decimos que hay demasiados componentes para habilidades
    if ( (iTotaceite + iTottinte + iTotTintv + iTotEspejo + iTotSulf + iTotGui + iTotDienteT + iTotEstaS + iTotHerLad
            + iTotCarTie + iTotShandon + iTotDiopsido + iTotConcha +iTotGlanSed + iTotMatCur + iTotOjoRak + iTotPolHada
            + iTotBolMara + iTotCuerGarf + iTotHumGas + iTotPolAnti + iTotFlorLoto + iTotBriSusu + iTotBayAcuo + iTotDieBod
            + iTotBelladona + iTotTrampas) > HAB_MAX  ){  //10 14
        AgregarPista(oUbicado,"*¡¡Has puesto demasiados componentes de habilidad!!*");
        return FALSE;
    }
    //Limitamos las salvaciones concretas en un mismo objeto a 6 (como en amuletos)
    if ( (iTotAza + iTotFrutFan) > SAL_MAX ){//6
        //AgregarPista(oUbicado,"*¡¡Las salvaciones concretas no pueden sumar mas de 6 entre ellas!!*");
        AgregarPista(oUbicado,"*¡¡Las salvaciones concretas no pueden sumar mas de " + IntToString(SAL_MAX) + " entre ellas!!*");
        return FALSE;
    }
    //Limitamos reducciones de daño a 5
    if ( (iTotzumac + iTotpaster + iTotraipe + iTotpiedra + iTotabdesc ) > RED_MAX ){
        AgregarPista(oUbicado,"*¡¡Las reducciones de daño no pueden sumar mas de 5!!*");
        return FALSE;
    }

    //Limitamos a 5 habilidades, si son mas de 3 incrementamos el valor hasta nivel 16 minimo
    iTotProp=0;
    if (iPicadaRocosa > 0) iTotProp++;
    if (iEsenTran > 0) iTotProp++;
    if (iEsenEvoc > 0) iTotProp++;
    if (iEsenConj > 0) iTotProp++;
    if (iEsenAdiv > 0) iTotProp++;
    if (iEsenIlus > 0) iTotProp++;
    if (iTotaceite > 0) iTotProp++;
    if (iTottinte > 0) iTotProp++;
    if (iTotTintv > 0) iTotProp++;
    if (iTotEspejo > 0) iTotProp++;
    if (iTotAza > 0) iTotProp++;
    if (iTotSulf > 0) iTotProp++;
    if (iTotGui > 0) iTotProp++;
    if (iTotDienteT > 0) iTotProp++;
    if (iTotEstaS > 0) iTotProp++;
    if (iTotpiedra > 0) iTotProp++;
    if (iToteseabj > 0) iTotProp++;
    if (iTotzumac > 0) iTotProp++;
    if (iTotpaster > 0) iTotProp++;
    if (iTotraipe > 0) iTotProp++;
    if (iTotabdesc > 0) iTotProp++;
    if (iTotHerLad > 0) iTotProp++;
    if (iTotCarTie > 0) iTotProp++;
    if (iTotVirRes > 0) iTotProp++;
    if (iTotShandon > 0) iTotProp++;
    if (iTotDiopsido > 0) iTotProp++;
    if (iTotConcha > 0) iTotProp++;
    if (iTotFrutFan > 0) iTotProp++;
    if (iTotGlanSed > 0) iTotProp++;
    if (iTotMatCur > 0) iTotProp++;
    if (iTotOjoRak > 0) iTotProp++;
    if (iTotPolHada > 0) iTotProp++;
    if (iTotBolMara > 0) iTotProp++;
    if (iTotCuerGarf > 0) iTotProp++;
    if (iTotHumGas > 0) iTotProp++;
    if (iTotPolAnti > 0) iTotProp++;
    if (iTotFlorLoto > 0) iTotProp++;
    if (iTotBriSusu > 0) iTotProp++;
    if (iTotBayAcuo > 0) iTotProp++;
    if (iTotDieBod > 0) iTotProp++;
    if (iTotBelladona > 0) iTotProp++;
    if (iTotTrampas > 0) iTotProp++;
    if (iTotProp >PROP_MAX) {
        AgregarPista(oUbicado,"*¡¡No puedes poner más de " + IntToString(PROP_MAX) + "  dos propiedades!!*");
        return FALSE;
    }


    //si hemos llegado hasta aqui es que todo va bien


    return CargarVariables(oUbicado, sNomBase, sNomMaterial);

}


int CargarVariables(object oUbicado, string sNomBase, string sNomMaterial) {

    CargarVariablesComunes(oUbicado);

    return CargarVariablesFormula(oUbicado, sNomBase, sNomMaterial);

}

int CargarVariablesFormula(object oUbicado, string sNomBase, string sNomMaterial) {
     RequisitoClasesTodos(oUbicado,TRUE);
     //Liberado para todas las clases
/*     RequisitoClase(oUbicado,1,CLASS_TYPE_BARBARIAN,1);
     RequisitoClase(oUbicado,2,CLASS_TYPE_FIGHTER,1);
     RequisitoClase(oUbicado,3,CLASS_TYPE_RANGER,1);
     RequisitoClase(oUbicado,4,CLASS_TYPE_ROGUE,1);
     RequisitoClase(oUbicado,5,CLASS_TYPE_BARD,1);
     RequisitoClase(oUbicado,6,CLASS_TYPE_DRUID,1);*/

    int iDifCalc= DificultadCosa(sNomMaterial);


/* Eliminados requisitos de nivel
    ////requisitos de nivel por dificultad
    if (iDifCalc > 500)
    {  SetLocalInt(oUbicado,"NivelPJMinimo",15);
    }
    else
    {  if (iDifCalc > 300)
       { SetLocalInt(oUbicado,"NivelPJMinimo",10);
       }
    }
    /////////////////////////////////////////
*/

    DificultadFormula(oUbicado,iDifCalc);
//    SetLocalInt(oUbicado,"Dificultad",iDifCalc);
    RecetaCrear(oUbicado,"sapo_rect_12_1");


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

    //aqui defino y cargo los materiales que se pueden usar en las recetas de guarnicionador


        SetLocalString(oUbicado,"fnMaterialMascara3","picadarocosa");
        SetLocalString(oUbicado,"fnMaterialMascara4","pb_artesa_car2");
        SetLocalString(oUbicado,"fnMaterialMascara5","pb_artesa_car1");
        SetLocalString(oUbicado,"fnMaterialMascara6","pb_artesa_car0");
        SetLocalString(oUbicado,"fnMaterialMascara7","pb_artesa_car5");
        SetLocalString(oUbicado,"fnMaterialMascara8","AceiteSigilo");
        SetLocalString(oUbicado,"fnMaterialMascara9","x2_it_dyel23");
        SetLocalString(oUbicado,"fnMaterialMascara10","espejodemano");
        SetLocalString(oUbicado,"fnMaterialMascara11","polvo_aza");
        SetLocalString(oUbicado,"fnMaterialMascara12","especiasulfurosa");
        SetLocalString(oUbicado,"fnMaterialMascara13","Guadelaventurero");
        SetLocalString(oUbicado,"fnMaterialMascara14","dientetiburon");
        SetLocalString(oUbicado,"fnMaterialMascara15","estatuasirena");
        SetLocalString(oUbicado,"fnMaterialMascara16","x1_it_msmlmisc01");
        SetLocalString(oUbicado,"fnMaterialMascara17","pb_artesa_reg");
        SetLocalString(oUbicado,"fnMaterialMascara18","zumoacuoso");
        SetLocalString(oUbicado,"fnMaterialMascara19","pastaterrosa");
        SetLocalString(oUbicado,"fnMaterialMascara20","raizpetrea");
        SetLocalString(oUbicado,"fnMaterialMascara21","NW_IT_MSMLMISC08");
        SetLocalString(oUbicado,"fnMaterialMascara22","NW_IT_PICKS001");
        SetLocalString(oUbicado,"fnMaterialMascara23","caracoldetierra");
        SetLocalString(oUbicado,"fnMaterialMascara24","virutasresplande");
        SetLocalString(oUbicado,"fnMaterialMascara25","shandon");
        SetLocalString(oUbicado,"fnMaterialMascara26","diopsidoestrella");
        SetLocalString(oUbicado,"fnMaterialMascara27","basura_concha");
        SetLocalString(oUbicado,"fnMaterialMascara28","frutofantasma");
        SetLocalString(oUbicado,"fnMaterialMascara29","x2_it_dyel48");
        SetLocalString(oUbicado,"fnMaterialMascara30","pb_artesa_car3");
        SetLocalString(oUbicado,"fnMaterialMascara31","NW_IT_MSMLMISC07");
        SetLocalString(oUbicado,"fnMaterialMascara32","vendas_pb_01");
        SetLocalString(oUbicado,"fnMaterialMascara33","NW_IT_MSMLMISC09");
        SetLocalString(oUbicado,"fnMaterialMascara34","NW_IT_MSMLMISC19");
        SetLocalString(oUbicado,"fnMaterialMascara35","X1_WMGRENADE006");
        SetLocalString(oUbicado,"fnMaterialMascara36","gz_it_rope");
        SetLocalString(oUbicado,"fnMaterialMascara37","humoGaseoso");
        SetLocalString(oUbicado,"fnMaterialMascara38","polvoantiluz");
        SetLocalString(oUbicado,"fnMaterialMascara39","pb_artesa_hab31"); // Luz cegadora de bezekira -> Equilibrio
        SetLocalString(oUbicado,"fnMaterialMascara40","brisaSusurrante");
        SetLocalString(oUbicado,"fnMaterialMascara41","bayaAcuosa");
        SetLocalString(oUbicado,"fnMaterialMascara42","NW_IT_MSMLMISC06");
        SetLocalString(oUbicado,"fnMaterialMascara43","NW_IT_MSMLMISC23");
        SetLocalString(oUbicado,"fnMaterialMascara44","NW_IT_TRAP001");


    //llama al buscador
    ExecuteScript("sapo_rect_gen",OBJECT_SELF);
    //guardo en variables internas los totales que me haya devuelto elbuscador
    string sNomBase=GetLocalString(oUbicado,"fnMaterialRetorno1");
    int iTotBases=GetLocalInt(oUbicado,"fnMaterialRetornoTotal1");
    string sNomMaterial=GetLocalString(oUbicado,"fnMaterialRetorno2");
    iTotMateriales=GetLocalInt(oUbicado,"fnMaterialRetornoTotal2");

    int iRetorno=GetLocalInt(oUbicado,"fnRetorno");
    //////////////////////////////
       string sNomPicada=GetLocalString(oUbicado,"fnMaterialRetorno3");
    iPicadaRocosa=GetLocalInt(oUbicado,"fnMaterialRetornoTotal3");
    string sNomEsenTran=GetLocalString(oUbicado,"fnMaterialRetorno4");
    iEsenTran=GetLocalInt(oUbicado,"fnMaterialRetornoTotal4");
    string sNomEsenEvoc=GetLocalString(oUbicado,"fnMaterialRetorno5");
    iEsenEvoc=GetLocalInt(oUbicado,"fnMaterialRetornoTotal5");
    string sNomEsenConj=GetLocalString(oUbicado,"fnMaterialRetorno6");
    iEsenConj=GetLocalInt(oUbicado,"fnMaterialRetornoTotal6");
    string sNomEsenAdiv=GetLocalString(oUbicado,"fnMaterialRetorno7");
    iEsenAdiv=GetLocalInt(oUbicado,"fnMaterialRetornoTotal7");
    string sNomTotaceite=GetLocalString(oUbicado,"fnMaterialRetorno8");
    iTotaceite=GetLocalInt(oUbicado,"fnMaterialRetornoTotal8");
    string sNomTottinte=GetLocalString(oUbicado,"fnMaterialRetorno9");
    iTottinte=GetLocalInt(oUbicado,"fnMaterialRetornoTotal9");
    string sNomEspejo=GetLocalString(oUbicado,"fnMaterialRetorno10");
    iTotEspejo=GetLocalInt(oUbicado,"fnMaterialRetornoTotal10");
    string sNomTotAza=GetLocalString(oUbicado,"fnMaterialRetorno11");
    iTotAza=GetLocalInt(oUbicado,"fnMaterialRetornoTotal11");
    string sNomTotSulf=GetLocalString(oUbicado,"fnMaterialRetorno12");
    iTotSulf=GetLocalInt(oUbicado,"fnMaterialRetornoTotal12");
    string sNomTotGui=GetLocalString(oUbicado,"fnMaterialRetorno13");
    iTotGui=GetLocalInt(oUbicado,"fnMaterialRetornoTotal13");
    string sNomDienteT=GetLocalString(oUbicado,"fnMaterialRetorno14");
    iTotDienteT=GetLocalInt(oUbicado,"fnMaterialRetornoTotal14");
    string sNomTotEstaS=GetLocalString(oUbicado,"fnMaterialRetorno15");
    iTotEstaS=GetLocalInt(oUbicado,"fnMaterialRetornoTotal15");
    string sNomTotpiedra=GetLocalString(oUbicado,"fnMaterialRetorno16");
    iTotpiedra=GetLocalInt(oUbicado,"fnMaterialRetornoTotal16");
    string sNomToteseabj=GetLocalString(oUbicado,"fnMaterialRetorno17");
    iToteseabj=GetLocalInt(oUbicado,"fnMaterialRetornoTotal17");
    string sNomTotzumac=GetLocalString(oUbicado,"fnMaterialRetorno18");
    iTotzumac=GetLocalInt(oUbicado,"fnMaterialRetornoTotal18");
    string sNomTotpaster=GetLocalString(oUbicado,"fnMaterialRetorno19");
    iTotpaster=GetLocalInt(oUbicado,"fnMaterialRetornoTotal19");
    string sNomTotraipe=GetLocalString(oUbicado,"fnMaterialRetorno20");
    iTotraipe=GetLocalInt(oUbicado,"fnMaterialRetornoTotal20");
    string sNomTotabdesc=GetLocalString(oUbicado,"fnMaterialRetorno21");
    iTotabdesc=GetLocalInt(oUbicado,"fnMaterialRetornoTotal21");
    string sNomTotHerLad=GetLocalString(oUbicado,"fnMaterialRetorno22");
    iTotHerLad=GetLocalInt(oUbicado,"fnMaterialRetornoTotal22");
    string sNomTotCarTie=GetLocalString(oUbicado,"fnMaterialRetorno23");
    iTotCarTie=GetLocalInt(oUbicado,"fnMaterialRetornoTotal23");
    string sNomVirRes=GetLocalString(oUbicado,"fnMaterialRetorno24");
    iTotVirRes=GetLocalInt(oUbicado,"fnMaterialRetornoTotal24");
    string sNomTotShandon=GetLocalString(oUbicado,"fnMaterialRetorno25");
    iTotShandon=GetLocalInt(oUbicado,"fnMaterialRetornoTotal25");
    string sNomTotDiopsido=GetLocalString(oUbicado,"fnMaterialRetorno26");
    iTotDiopsido=GetLocalInt(oUbicado,"fnMaterialRetornoTotal26");
    string sNomTotConcha=GetLocalString(oUbicado,"fnMaterialRetorno27");
    iTotConcha=GetLocalInt(oUbicado,"fnMaterialRetornoTotal27");
    string sNomTotFrutFan=GetLocalString(oUbicado,"fnMaterialRetorno28");
    iTotFrutFan=GetLocalInt(oUbicado,"fnMaterialRetornoTotal28");
    string sNomTintv=GetLocalString(oUbicado,"fnMaterialRetorno29");
    iTotTintv=GetLocalInt(oUbicado,"fnMaterialRetornoTotal29");
    string sNomEsenIlus=GetLocalString(oUbicado,"fnMaterialRetorno30");
    iEsenIlus=GetLocalInt(oUbicado,"fnMaterialRetornoTotal30");
    string sNomTotGlaSed=GetLocalString(oUbicado,"fnMaterialRetorno31");
    iTotGlanSed=GetLocalInt(oUbicado,"fnMaterialRetornoTotal31");
    string sNomTotMatCur=GetLocalString(oUbicado,"fnMaterialRetorno32");
    iTotMatCur=GetLocalInt(oUbicado,"fnMaterialRetornoTotal32");
    string sNomTotOjRak=GetLocalString(oUbicado,"fnMaterialRetorno33");
    iTotOjoRak=GetLocalInt(oUbicado,"fnMaterialRetornoTotal33");
    string sNomTotPoHad=GetLocalString(oUbicado,"fnMaterialRetorno34");
    iTotPolHada=GetLocalInt(oUbicado,"fnMaterialRetornoTotal34");
    string sNomTotBolMar=GetLocalString(oUbicado,"fnMaterialRetorno35");
    iTotBolMara=GetLocalInt(oUbicado,"fnMaterialRetornoTotal35");
    string sNomTotCuGar=GetLocalString(oUbicado,"fnMaterialRetorno36");
    iTotCuerGarf=GetLocalInt(oUbicado,"fnMaterialRetornoTotal36");
    string sNomTotHuGas=GetLocalString(oUbicado,"fnMaterialRetorno37");
    iTotHumGas=GetLocalInt(oUbicado,"fnMaterialRetornoTotal37");
    string sNomTotPolAnt=GetLocalString(oUbicado,"fnMaterialRetorno38");
    iTotPolAnti=GetLocalInt(oUbicado,"fnMaterialRetornoTotal38");
    string sNomTotFlLot=GetLocalString(oUbicado,"fnMaterialRetorno39");
    iTotFlorLoto=GetLocalInt(oUbicado,"fnMaterialRetornoTotal39");
    string sNomTotBrSus=GetLocalString(oUbicado,"fnMaterialRetorno40");
    iTotBriSusu=GetLocalInt(oUbicado,"fnMaterialRetornoTotal40");
    string sNomTotBaAcu=GetLocalString(oUbicado,"fnMaterialRetorno41");
    iTotBayAcuo=GetLocalInt(oUbicado,"fnMaterialRetornoTotal41");
    string sNomTotDiBod=GetLocalString(oUbicado,"fnMaterialRetorno42");
    iTotDieBod=GetLocalInt(oUbicado,"fnMaterialRetornoTotal42");
    string sNomTotBelladona=GetLocalString(oUbicado,"fnMaterialRetorno43");
    iTotBelladona=GetLocalInt(oUbicado,"fnMaterialRetornoTotal43");
    string sNomTotTrampas=GetLocalString(oUbicado,"fnMaterialRetorno44");
    iTotTrampas=GetLocalInt(oUbicado,"fnMaterialRetornoTotal44");

    BorrarVariablesParaScript_sapo_rect_gen(oUbicado);

    object oPC = GetLastUsedBy();
    string sSubraza = GetStringLowerCase(GetSubRace(oPC));
    string sDescripAux ="";
    string sNameAux="";
    //clasifico primero el tipo de plantilla para ver que quiero hacer
    if (sNomBase==MASCARA_BASE + "guan") iTipoCosa=1;
    if (sNomBase==MASCARA_BASE + "bota") iTipoCosa=2;
    if (sNomBase==MASCARA_BASE + "cint") iTipoCosa=3;
    if (sNomBase==MASCARA_BASE + "capa") iTipoCosa=4;
    if (sNomBase==MASCARA_BASE + "capu") iTipoCosa=5;



    string sCosa ="";

    switch (iTipoCosa)
    {
    case 1:
       if (Bono_Guantes(oUbicado)==FALSE) {
                                    if (DEBUG) SpeakString("mierda ");
                                   }
       sDescripAux = "Estos son unos guantes ";
       sNameAux="Guantes ";
       sCosa = "guantesdecuero";
       break;
    case 2:
       if (Bono_Botas(oUbicado)==FALSE) {
                                    if (DEBUG) SpeakString("mierda ");
                                   }
       sDescripAux = "Estas son unas botas ";
       sNameAux="Botas ";
       sCosa = "botasdecuero";
       break;
    case 3:
       if (Bono_Cintos(oUbicado)==FALSE) {
                                    if (DEBUG) SpeakString("mierda");
                                   }
       sDescripAux = "Esto es un cinto ";
       sNameAux="Cinto ";
       sCosa = "cinturndecuero";
       break;
    case 4:
       if (Bono_Capas(oUbicado)==FALSE) {
                                    if (DEBUG) SpeakString("mierda");
                                   }
       if (sSubraza != "drow")
       {
       sDescripAux = "Esta es una capa ";
       sNameAux="Capa ";
       }
       else
       {
       sDescripAux = "Esta es un piwafi ";
       sNameAux="Piwafi ";
       }
       sCosa = "capadepiel";
       break;
    case 5:
       if (Bono_Capucha(oUbicado)==FALSE) {
                                    if (DEBUG) SpeakString("mierda");
                                   }
       sDescripAux = "Esta es una capucha ";
       sNameAux="Capucha ";
       sCosa = "capucha";
       break;
    }
    //descripcion por tipo de piel
    if (sNomMaterial=="sapo_cuero_rata")
   {   sDescripAux =  sDescripAux + "de cuero de rata ";
       sNameAux= sNameAux + "de rata ";
   }
   if (sNomMaterial=="sapo_cuero_serpi")
   {sDescripAux =  sDescripAux + "de cuero de serpiente ";
       sNameAux= sNameAux + "de serpiente ";
   }
   if (sNomMaterial=="sapo_cuero_cierv")
   {   sDescripAux =  sDescripAux + "de cuero de ciervo ";
       sNameAux= sNameAux + "de ciervo ";
   }
   if (sNomMaterial=="sapo_cuero_jabal")
   {   sDescripAux =  sDescripAux + "de cuero de jabalí ";
       sNameAux= sNameAux + "de jabali ";
   }
   if (sNomMaterial=="sapo_cuero_oso")
   {   sDescripAux =  sDescripAux + "de cuero de oso ";
       sNameAux= sNameAux + "de oso ";
   }
   if (sNomMaterial=="sapo_cuero_lobo")
   {    sDescripAux =  sDescripAux + "de cuero de lobo ";
       sNameAux= sNameAux + "de lobo ";
   }
   if (sNomMaterial=="sapo_cuero_loboi")
   {   sDescripAux =  sDescripAux + "de cuero de lobo invernal ";
       sNameAux= sNameAux + "de lobo invernal ";
   }
   if (sNomMaterial=="sapo_cuero_murci")
   {   sDescripAux =  sDescripAux + "de cuero de murciélago ";
       sNameAux= sNameAux + "de murcielago ";
   }
   if (sNomMaterial=="sapo_cuero_rothe")
   {   sDescripAux =  sDescripAux + "de cuero de rothé ";
       sNameAux= sNameAux + "de rothe ";
   }
   if (sNomMaterial=="sapo_cuero_lagar")
   {   sDescripAux =  sDescripAux + "de cuero de lagarto ";
       sNameAux= sNameAux + "de lagarto ";
   }
   if (sNomMaterial=="sapo_cuero_wyrm")
   {   sDescripAux =  sDescripAux + "de cuero de draco ";
       sNameAux= sNameAux + "de wyrm ";
   }
   if (sNomMaterial=="sapo_cuero_cani")
   {   sDescripAux =  sDescripAux + "de cuero de can infernal ";
       sNameAux= sNameAux + "infernal ";
   }

    ///

    int iBonoAC = 0;
    if (iPicadaRocosa>0)
    {
        iBonoAC=iPicadaRocosa;
        if (iBonoAC>AC_MAX)
        {
            iBonoAC = AC_MAX;
        }

    }


      //creo objeto

   object oContenedorParaCrear=GetObjectByTag(CONTENEDOR_CREAR);
   //Tintamos el cuero segun la piel o el tinte
   object oObjeto;
   if ( sNomMaterial == "sapo_cuero_loboi" || iTottinte >0 || iTotTintv >0 )
   {  //si piel lobo invernal o se usa tinte entonces tintamos antes de hacer el resto
      int iColor;
      if (sNomMaterial == "sapo_cuero_loboi")
      {iColor=62;}
      if (iTotTintv >0)
       {iColor=19;}
      if (iTottinte > 0 )
      {iColor=63;}

      object oObjetoAux=CreateItemOnObject(sCosa,oContenedorParaCrear,1,"");
      object oObjetoAux1=IPDyeArmor(oObjetoAux,0,iColor);
      object oObjetoAux2=IPDyeArmor(oObjetoAux1,1,iColor);
      object oObjetoAux3=IPDyeArmor(oObjetoAux2,2,iColor);
      oObjeto=IPDyeArmor(oObjetoAux3,3,iColor);


   }
   else
   { oObjeto=CreateItemOnObject(sCosa,oContenedorParaCrear,1,"");
   }
   //object oObjeto=CreateItemOnObject(sCosa,oContenedorParaCrear,1,"");

    //incluyo el bono de armadura


      itemproperty ipAdd=ItemPropertyACBonus(iBonoAC);
      if (GetIsObjectValid(oObjeto))
          //IPSafeAddItemProperty(oObjeto, ipAdd);
      AddItemProperty(DURATION_TYPE_PERMANENT, ipAdd, oObjeto);



//como las validaciones ya están hechas aqui solo pasamos a crear el objeto y de paso
//ir incluyendo los bonos, consideramos los de todos.


    //bono esconderse
    if (iTottinte >0 || iTotTintv > 0)
       {
        int iBonoEsc;
        if (iTotTintv>0)
        {iBonoEsc=iTotTintv;}
        else
        {iBonoEsc = iTottinte;}
        if (iBonoEsc >HAB_MAX)
        {
            iBonoEsc = HAB_MAX;

        }
        itemproperty ipBonoEsc = ItemPropertySkillBonus(SKILL_HIDE, iBonoEsc);
        AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoEsc, oObjeto);
        sDescripAux = sDescripAux + ", está oscurecida para camuflarse mejor ";

       }
    //bono piruetas
    if (iTotSulf >0)
       {
        int iBonoBus = iTotSulf;
        if (iBonoBus >HAB_MAX)
        {
            iBonoBus = HAB_MAX;

        }
        itemproperty ipBonoBus = ItemPropertySkillBonus(SKILL_TUMBLE, iBonoBus);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoBus, oObjeto);
         sDescripAux = sDescripAux + ", te hace sentir mas hábil ";
       }
    //Tasar
    if (iTotGui >0)
       {
        int iBonoBus = iTotGui;
        if (iBonoBus >HAB_MAX)
        {
            iBonoBus = HAB_MAX;

        }
        itemproperty ipBonoBus = ItemPropertySkillBonus(SKILL_APPRAISE, iBonoBus);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoBus, oObjeto);
         //sDescripAux = sDescripAux + ", posee como un brillo curioso ";
       }
     //Empatia Animal ahora trato con animales
    if (iTotDienteT >0)
       {
        int iBonoBus = iTotDienteT;
        if (iBonoBus >HAB_MAX)
        {
            iBonoBus = HAB_MAX;

        }
        itemproperty ipBonoBus = ItemPropertySkillBonus(SKILL_ANIMAL_EMPATHY, iBonoBus);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoBus, oObjeto);
         //sDescripAux = sDescripAux + ", posee como un brillo curioso ";
       }
     //Fabricar Trampas ahora artesania
    if (iTotHumGas >0)
       {
        int iBonoBus = iTotHumGas;
        if (iBonoBus >HAB_MAX)
        {
            iBonoBus = HAB_MAX;

        }
        itemproperty ipBonoBus = ItemPropertySkillBonus(SKILL_CRAFT_TRAP, iBonoBus);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoBus, oObjeto);
         //sDescripAux = sDescripAux + ", posee como un brillo curioso ";
       }
    //Abrir cerraduras
    if (iTotHerLad >0)
       {
        int iBonoBus = iTotHerLad;
        if (iBonoBus >HAB_MAX)
        {
            iBonoBus = HAB_MAX;

        }
        itemproperty ipBonoBus = ItemPropertySkillBonus(SKILL_OPEN_LOCK, iBonoBus);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoBus, oObjeto);
         //sDescripAux = sDescripAux + ", posee como un brillo curioso ";
       }
    //poner trampas
    if (iTotTrampas >0)
       {
        int iBonoBus = iTotTrampas;
        if (iBonoBus >HAB_MAX)
        {
            iBonoBus = HAB_MAX;

        }
        itemproperty ipBonoBus = ItemPropertySkillBonus(SKILL_SET_TRAP, iBonoBus);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoBus, oObjeto);
         //sDescripAux = sDescripAux + ", posee como un brillo curioso ";
       }
    //quitar trampas
    if (iTotCarTie >0)
       {
        int iBonoBus = iTotCarTie;
        if (iBonoBus >HAB_MAX)
        {
            iBonoBus = HAB_MAX;

        }
        itemproperty ipBonoBus = ItemPropertySkillBonus(SKILL_DISABLE_TRAP, iBonoBus);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoBus, oObjeto);
         //sDescripAux = sDescripAux + ", posee como un brillo curioso ";
       }
    //Disciplina , ahora cambia a saber local?
    if (iTotEstaS >0)
       {
        int iBonoBus = iTotEstaS;
        if (iBonoBus >HAB_MAX)
        {
            iBonoBus = HAB_MAX;

        }
        itemproperty ipBonoBus = ItemPropertySkillBonus(SKILL_DISCIPLINE, iBonoBus);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoBus, oObjeto);
         //sDescripAux = sDescripAux + ", posee como un brillo curioso ";
       }
    //Persuadir o diplomacia
    if (iTotEspejo >0)
       {
        int iBonoPer = iTotEspejo;
        if (iBonoPer >HAB_MAX)
        {
            iBonoPer = HAB_MAX;

        }
        itemproperty ipBonoPer = ItemPropertySkillBonus(SKILL_PERSUADE, iBonoPer);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoPer, oObjeto);
         //sDescripAux = sDescripAux + ", posee como un brillo curioso ";
       }
    //Buscar
    if (iTotShandon >0)
       {
        int iBonoBus = iTotShandon;
        if (iBonoBus >HAB_MAX)
        {
            iBonoBus = HAB_MAX;

        }
        itemproperty ipBonoBus = ItemPropertySkillBonus(SKILL_SEARCH, iBonoBus);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoBus, oObjeto);
         //sDescripAux = sDescripAux + ", posee como un brillo curioso ";
       }
    //Avistar
    if (iTotDiopsido >0)
       {
        int iBonoBus = iTotDiopsido;
        if (iBonoBus >HAB_MAX)
        {
            iBonoBus = HAB_MAX;

        }
        itemproperty ipBonoBus = ItemPropertySkillBonus(SKILL_SPOT, iBonoBus);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoBus, oObjeto);
         //sDescripAux = sDescripAux + ", posee como un brillo curioso ";
       }
    //Escuchar
    if (iTotConcha >0)
       {
        int iBonoBus = iTotConcha;
        if (iBonoBus >HAB_MAX)
        {
            iBonoBus = HAB_MAX;

        }
        itemproperty ipBonoBus = ItemPropertySkillBonus(SKILL_LISTEN, iBonoBus);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoBus, oObjeto);
         //sDescripAux = sDescripAux + ", posee como un brillo curioso ";
       }

    //bono Sigilo
    if (iTotaceite >0)
       {
       int iBonoMovSil = iTotaceite;
       if (iBonoMovSil >HAB_MAX)
        {
            iBonoMovSil = HAB_MAX;

        }
        itemproperty ipBonoMovSil = ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, iBonoMovSil);
        AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoMovSil, oObjeto);
        sDescripAux = sDescripAux + ", esta aceitada para no hacer ruido ";

       }
    //bono reflejos
    if (iTotAza >0)
       {
       int iBonoRef = iTotAza;
       if (iBonoRef >SAL_MAX)
       {
            iBonoRef = SAL_MAX;

       }
       itemproperty ipBonoTSRef = ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_REFLEX, iBonoRef);
        AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoTSRef, oObjeto);
        sDescripAux = sDescripAux + ", para como si con ella se fuera mas agil ";
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
//bono resistencia fuego
 if (iTotabdesc >0)
       {
        //int nAlign = IP_CONST_ALIGNMENTGROUP_GOOD;
        int nDamageType =IP_CONST_DAMAGETYPE_FIRE;
        int nHPResist = 0;
        if (iTotabdesc >=RED_MAX)
        {
            nHPResist = IP_CONST_DAMAGERESIST_5;

        }
        itemproperty ipAdd = ItemPropertyDamageResistance(nDamageType, nHPResist);
//        itemproperty ipBonoTSBien=ItemPropertyACBonusVsAlign(nAlign, iBonoTSBien);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipAdd, oObjeto);
         sDescripAux = sDescripAux + ", huele a chamuscado ";
       }
//bono resistencia acido
 if (iTotVirRes >0)
       {
        //int nAlign = IP_CONST_ALIGNMENTGROUP_GOOD;
        int nDamageType =IP_CONST_DAMAGETYPE_ACID;
        int nHPResist = 0;
        if (iTotVirRes >=RED_MAX)
        {
            nHPResist = IP_CONST_DAMAGERESIST_5;
        }

        itemproperty ipAdd = ItemPropertyDamageResistance(nDamageType, nHPResist);
//        itemproperty ipBonoTSBien=ItemPropertyACBonusVsAlign(nAlign, iBonoTSBien);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipAdd, oObjeto);
         sDescripAux = sDescripAux + ", huele a ácido ";
       }
//bono resistencia cortante
 if (iTotzumac >0)
       {
        //int nAlign = IP_CONST_ALIGNMENTGROUP_GOOD;
        int nDamageType =IP_CONST_DAMAGETYPE_SLASHING;
        int nHPResist = 0;
        if (iTotzumac >=RED_MAX)
        {
            nHPResist = IP_CONST_DAMAGERESIST_5;
        }

        itemproperty ipAdd = ItemPropertyDamageResistance(nDamageType, nHPResist);
//        itemproperty ipBonoTSBien=ItemPropertyACBonusVsAlign(nAlign, iBonoTSBien);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipAdd, oObjeto);
         sDescripAux = sDescripAux + ", parece que el cuchillo resbala ";
       }
//bono resistencia punzante
 if (iTotraipe >0)
       {

        int nDamageType =IP_CONST_DAMAGETYPE_PIERCING;
        int nHPResist = 0;
        if (iTotraipe >=RED_MAX)
        {
            nHPResist = IP_CONST_DAMAGERESIST_5;
        }

        itemproperty ipAdd = ItemPropertyDamageResistance(nDamageType, nHPResist);

         AddItemProperty(DURATION_TYPE_PERMANENT, ipAdd, oObjeto);
         sDescripAux = sDescripAux + ", parece que una aguja no la penetra ";
       }
//bono resistencia contundente
 if (iTotpaster >0)
       {

        int nDamageType =IP_CONST_DAMAGETYPE_BLUDGEONING;
        int nHPResist = 0;
        if (iTotpaster >=RED_MAX)
        {
            nHPResist = IP_CONST_DAMAGERESIST_5;
        }

        itemproperty ipAdd = ItemPropertyDamageResistance(nDamageType, nHPResist);

         AddItemProperty(DURATION_TYPE_PERMANENT, ipAdd, oObjeto);
         sDescripAux = sDescripAux + ", parece que el martillo rebota ";
       }
//regeneracion maxima 1 si tiene mas propiedades
    if (iToteseabj>0)
    {
    int iBr = 1;
    //iBr=iToteseabj;
     itemproperty ipBonoReg = ItemPropertyRegeneration(iBr);
     AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoReg, oObjeto);
    }
//bono FUE
    if (iEsenConj >0)
       {
        int nbonofue =IP_CONST_ABILITY_STR;
        int ndopefue = 0;
        if (iEsenConj > CAR_MAX)
        {
            ndopefue= CAR_MAX;
        }

        itemproperty ipAddStrength=ItemPropertyAbilityBonus(nbonofue, ndopefue);
        AddItemProperty(DURATION_TYPE_PERMANENT, ipAddStrength, oObjeto);
         sDescripAux = sDescripAux + ", con ella el dueño parece más fuerte ";
       }
//bono DES
if (iEsenEvoc >0)
       {
        int nbonodes =IP_CONST_ABILITY_DEX;
        int ndopedes = 0;

        if (iEsenEvoc > CAR_MAX)
        {
            ndopedes= CAR_MAX;
        }

        itemproperty ipAdddes=ItemPropertyAbilityBonus(nbonodes, ndopedes);
        AddItemProperty(DURATION_TYPE_PERMANENT, ipAdddes, oObjeto);
         sDescripAux = sDescripAux + ", con ella el dueño parece más ágil ";
       }
//bono CON
if (iEsenTran >0)
       {
        int nbonocon =IP_CONST_ABILITY_CON;
        int ndopecon = 0;

        if (iEsenTran > CAR_MAX)
        {
           ndopecon= CAR_MAX;
        }

        itemproperty ipAddcon=ItemPropertyAbilityBonus(nbonocon, ndopecon);
        AddItemProperty(DURATION_TYPE_PERMANENT, ipAddcon, oObjeto);
         sDescripAux = sDescripAux + ", con ella el dueño parece más resistente ";
       }
//bono CHA
if (iEsenAdiv >0)
       {
        int nbonocon =IP_CONST_ABILITY_CHA;
        int ndopecha = 0;

        if (iEsenAdiv> CAR_MAX)
        {
           ndopecha= CAR_MAX;
        }

        itemproperty ipAddcon=ItemPropertyAbilityBonus(nbonocon, ndopecha);
        AddItemProperty(DURATION_TYPE_PERMANENT, ipAddcon, oObjeto);
         sDescripAux = sDescripAux + ", con ella el dueño parece más resistente ";
       }
//Bono INT
if (iEsenIlus > 0)
       {
        int nbonocon =IP_CONST_ABILITY_INT;
        int ndopeint = 0;

        if (iEsenIlus> CAR_MAX)
        {
           ndopeint= CAR_MAX;
        }

        itemproperty ipAddcon=ItemPropertyAbilityBonus(nbonocon, ndopeint);
        AddItemProperty(DURATION_TYPE_PERMANENT, ipAddcon, oObjeto);
         sDescripAux = sDescripAux + ", con ella el dueño parece más listo ";
       }
//bono a salvacion contra enajenador
if (iTotFrutFan >0)
       {
/*        int iBonoBus = iTotFrutFan;
        itemproperty ipBonoBus = ItemPropertySkillBonus(28, iBonoBus);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoBus, oObjeto);
         //sDescripAux = sDescripAux + ", posee como un brillo curioso ";
*/
        int nAlign = IP_CONST_SAVEVS_MINDAFFECTING;
        int iBonoTSMie = iTotFrutFan;
        if (iBonoTSMie> SAL_MAX)
        {
          iBonoTSMie= SAL_MAX;
        }
        itemproperty ipBonoTSBien=ItemPropertyBonusSavingThrowVsX(nAlign, iBonoTSMie);

         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoTSBien, oObjeto);
         //sDescripAux = sDescripAux + ", sin miedo marca en runas oscuras ";*/
       }

//bono a trepar = glandula de seda de tracnido
if (iTotGlanSed >0){
       int iBonoTre = iTotGlanSed;
       if (iBonoTre >HAB_MAX)
        {
            iBonoTre = HAB_MAX;

        }
        itemproperty ipBonoBus = ItemPropertySkillBonus(37, iBonoTre);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoBus, oObjeto);
         sDescripAux = sDescripAux + ", puede trepar facilmente";
}
//bono a sanar = material de curandero
if (iTotMatCur >0){
       int iBonoSan = iTotMatCur;
       if (iBonoSan >HAB_MAX)
        {
            iBonoSan = HAB_MAX;

        }
        itemproperty ipBonoSan = ItemPropertySkillBonus(4, iBonoSan);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoSan, oObjeto);
         sDescripAux = sDescripAux + ", puedes curar mas facilmente";
}
//bono a concentracion = ojo de rakshasa
if (iTotOjoRak >0){
       int iBonoConc = iTotOjoRak;
       if (iBonoConc >HAB_MAX)
        {
            iBonoConc = HAB_MAX;

        }
        itemproperty ipBonoConc = ItemPropertySkillBonus(1, iBonoConc);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoConc, oObjeto);
         sDescripAux = sDescripAux + ", te ayuda a concentrarte";
}
//bono a nadar = polvo de hada
if (iTotPolHada >0){
       int iBonoNad = iTotPolHada;
       if (iBonoNad >HAB_MAX)
        {
            iBonoNad = HAB_MAX;

        }
        itemproperty ipBonoNad = ItemPropertySkillBonus(25, iBonoNad);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoNad, oObjeto);
         sDescripAux = sDescripAux + ", puedes nadar con ellos";
}
//juego de manos = bolsa maranyas
if (iTotBolMara >0){
       int iBonoJue = iTotBolMara;
       if (iBonoJue >HAB_MAX)
        {
            iBonoJue = HAB_MAX;

        }
        itemproperty ipBonoJue = ItemPropertySkillBonus(13, iBonoJue);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoJue, oObjeto);
         sDescripAux = sDescripAux + ", tus dedos son escurridizos";
}
//bono a uso de cuerdas = Cuerda con garfio
if (iTotCuerGarf >0){
       int iBonoUsCuerd = iTotCuerGarf;
        if (iBonoUsCuerd >HAB_MAX)
        {
            iBonoUsCuerd = HAB_MAX;

        }
        itemproperty ipBonoUsCuerd = ItemPropertySkillBonus(38, iBonoUsCuerd);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoUsCuerd, oObjeto);
         sDescripAux = sDescripAux + ", atas bien las cuerdas";
}
//bono a escapismo = polvo antiluz
if (iTotPolAnti >0){
       int iBonoEsca = iTotPolAnti;
       if (iBonoEsca >HAB_MAX)
        {
            iBonoEsca = HAB_MAX;

        }
        itemproperty ipBonoEsca = ItemPropertySkillBonus(32, iBonoEsca);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoEsca, oObjeto);
         sDescripAux = sDescripAux + ", te escurres como una serpiente";
}
//bono a equilibrio = flor de loto
if (iTotFlorLoto >0){
       int iBonoEqui = iTotFlorLoto;
        if (iBonoEqui >HAB_MAX)
        {
            iBonoEqui = HAB_MAX;

        }
        itemproperty ipBonoEqui = ItemPropertySkillBonus(31, iBonoEqui);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoEqui, oObjeto);
         sDescripAux = sDescripAux + ", te mantienes bien de pie";
}
//bono saltar = brisa susurrante;
if (iTotBriSusu >0){
       int iBonoSaltar = iTotBriSusu;
       if (iBonoSaltar >HAB_MAX)
        {
           iBonoSaltar = HAB_MAX;

        }
        itemproperty ipBonoSaltar = ItemPropertySkillBonus(26, iBonoSaltar);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoSaltar, oObjeto);
         sDescripAux = sDescripAux + ", puedes saltar mas lejos";
}
//bono a averiguar intenciones = Baya acuosa
if (iTotBayAcuo >0){
       int iBonoAveriguar = iTotBayAcuo;
        if (iBonoAveriguar>HAB_MAX)
        {
          iBonoAveriguar = HAB_MAX;

        }
        itemproperty ipBonoAveriguar = ItemPropertySkillBonus(28, iBonoAveriguar);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoAveriguar, oObjeto);
         sDescripAux = sDescripAux + ", eres mas despierto";
}
//diente de bodak
if (iTotDieBod >0){
       int iBonoInti = iTotDieBod;
       if (iBonoInti>HAB_MAX)
        {
          iBonoInti = HAB_MAX;

        }
        itemproperty ipBonoInti = ItemPropertySkillBonus(24, iBonoInti);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoInti, oObjeto);
         sDescripAux = sDescripAux + ", eres mas imponente";
}
    //bono a supervivencia
    if(iTotBelladona >0)
       {
        int iBonoBus = iTotBelladona;
        if (iBonoBus>HAB_MAX)
        {
          iBonoBus = HAB_MAX;

        }
        itemproperty ipBonoBus = ItemPropertySkillBonus(36, iBonoBus);
         AddItemProperty(DURATION_TYPE_PERMANENT, ipBonoBus, oObjeto);
         //sDescripAux = sDescripAux + ", posee como un brillo curioso ";
        sDescripAux = sDescripAux + ", huele suavemente a plantas astringentes ";

       }


//Si tiene mas de 3 propiedades, guardamos una variable para impedir que se lo equipe alguien de menos de nivel 15
    iTotProp=0;
    if (iPicadaRocosa > 0) iTotProp++;
    if (iEsenTran > 0) iTotProp++;
    if (iEsenEvoc > 0) iTotProp++;
    if (iEsenConj > 0) iTotProp++;
    if (iEsenAdiv > 0) iTotProp++;
    if (iEsenIlus > 0) iTotProp++;
    if (iTotaceite > 0) iTotProp++;
    if (iTottinte > 0) iTotProp++;
    if (iTotTintv > 0) iTotProp++;
    if (iTotEspejo > 0) iTotProp++;
    if (iTotAza > 0) iTotProp++;
    if (iTotSulf > 0) iTotProp++;
    if (iTotGui > 0) iTotProp++;
    if (iTotDienteT > 0) iTotProp++;
    if (iTotEstaS > 0) iTotProp++;
    if (iTotpiedra > 0) iTotProp++;
    if (iToteseabj > 0) iTotProp++;
    if (iTotzumac > 0) iTotProp++;
    if (iTotpaster > 0) iTotProp++;
    if (iTotraipe > 0) iTotProp++;
    if (iTotabdesc > 0) iTotProp++;
    if (iTotHerLad > 0) iTotProp++;
    if (iTotCarTie > 0) iTotProp++;
    if (iTotVirRes > 0) iTotProp++;
    if (iTotShandon > 0) iTotProp++;
    if (iTotDiopsido > 0) iTotProp++;
    if (iTotConcha > 0) iTotProp++;
    if (iTotFrutFan > 0) iTotProp++;
    if (iTotGlanSed > 0) iTotProp++;
    if (iTotMatCur > 0) iTotProp++;
    if (iTotOjoRak > 0) iTotProp++;
    if (iTotPolHada > 0) iTotProp++;
    if (iTotBolMara > 0) iTotProp++;
    if (iTotCuerGarf > 0) iTotProp++;
    if (iTotHumGas > 0) iTotProp++;
    if (iTotPolAnti > 0) iTotProp++;
    if (iTotFlorLoto > 0) iTotProp++;
    if (iTotBriSusu > 0) iTotProp++;
    if (iTotBayAcuo > 0) iTotProp++;
    if (iTotDieBod > 0) iTotProp++;
    if (iTotBelladona > 0) iTotProp++;
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
        if (sDesPapel!=""){sDescripAux = sDescripAux + " realizado para " + sDesPapel;}

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
    SetLocalInt(oObjeto,"CRAFT_MISCEPELE",1);
    SetDescription(oObjeto,sDescripAux,FALSE);
    //experimento para la descripcion
    SetLocalString(oUbicado, "DescripcionObjeto",sDescripAux);
    SetLocalString(oUbicado, "NombreObjeto",sNameAux);
    //

    SetLocalObject(oUbicado, "ObjetoCreado", oObjeto);
}






int DificultadCosa(string sNomMaterial)  {

    int iDifAux = 0;
    //Calculamos la dificultad de crear 80 por bono a AC
    int iAuxAC = 0;
    iAuxAC = iPicadaRocosa * 60;
    //calculamos --85-- (modificado a 40) por bono de aumento caracteristicas
    int  iAuxCar = 0;
    iAuxCar = (iEsenTran + iEsenEvoc + iEsenConj + iEsenAdiv + iToteseabj + iEsenIlus + iTotFrutFan) * 40;
    //calculamos a los de resistencia al daño por 70  , tambien a la resistencia enajenadores
    int iAuxRes = 0;
    iAuxRes = (iTotpiedra + iTotabdesc + iTotVirRes + iTotzumac + iTotpaster + iTotraipe ) *50;
    //Finalmente aplicamos el aumento de dificultad por los bonos aplicados
        int iNumBonos;
        iNumBonos =
            iTotaceite +
            iTottinte  +
            iTotTintv  +
            iTotEspejo +
            iTotAza +
            iTotSulf +
            iTotGui +
            iTotDienteT +
            iTotEstaS +
            //iTotpiedra +
            //iToteseabj +
            //iTotzumac +
            //iTotpaster +
            //iTotraipe +
            //iTotabdesc +
            //iTotVirRes    +
            iTotHerLad +
            iTotCarTie +
            iTotShandon +
            iTotDiopsido +
            iTotConcha +
            iTotGlanSed +
            iTotMatCur +
            iTotOjoRak +
            iTotPolHada +
            iTotBolMara +
            iTotCuerGarf +
            iTotHumGas +
            iTotPolAnti +
            iTotFlorLoto +
            iTotBriSusu +
            iTotBayAcuo +
            iTotDieBod +
            iTotBelladona +
            iTotTrampas
            ;
        //
        //En principio cada bono aumenta 7 la dificultad
        int iModDif = 0;
        if (iNumBonos==0)
        {
         iModDif =  0;
        }
        else
        {
         iModDif = iNumBonos * 7;
        }




        //
        iDifAux = iAuxAC + iAuxCar + iAuxRes + iModDif;
        //con habilidad 100 lo maximo que se puede llegar es 570 con al menos un minimo
        if (iDifAux>570) {iDifAux=570;}
        if (iDifAux<80)  {iDifAux=80;}
    //


    return iDifAux;


}


int Bono_Guantes(object oUbicado)  {

//aqui por un lado se ponen los bonos que hay al tiempo que si hay materiales no permitidos se da error
    //en estos bonos lo que hago es limitar a seis, los de caracteristica o armadura a tres
    // Modificado para la actualizacin, ahora el bono maximo es 6 dado que no se apilara nunca. Habilidades a 10 y CA 5

    if(iEsenEvoc >6)
       {iEsenEvoc = 6;}

    if (iEsenConj >6)
       {iEsenConj = 6;}

    if (iTotGui >7)
       {iTotGui = 7;}

    if (iTotDienteT >7)
       {iTotDienteT = 7;}

    if (iTotHerLad >7)
       {iTotHerLad = 7;}

    if (iTotCarTie >7)
       {iTotCarTie = 7;}

    if (iTotEstaS > 7)
       {iTotEstaS = 7;}

    if (iTotGlanSed >7)
        {iTotGlanSed = 7;}

    if (iTotTrampas > 7)
        {iTotTrampas = 7;}

    if (iTotMatCur > 7)
        {iTotMatCur = 7;}

    if (iTotOjoRak > 7)
        {iTotOjoRak = 7;}

    if (iTotPolHada > 7)
        {iTotPolHada = 7;}

    if (iTotBolMara > 7)
        {iTotBolMara = 7;}

    if (iTotCuerGarf > 7)
        {iTotCuerGarf = 7;}

    if (iTotHumGas > 7)
        {iTotHumGas = 7;}


    //aqui comprobamos si hay elementos que no permitimos y que hacen no valida la receta
    if (
        iPicadaRocosa > 0 ||
        iEsenTran > 0 ||
        //iEsenEvoc > 0 ||
        //iEsenConj > 0 ||
        iEsenAdiv > 0 ||
        iEsenIlus > 0 ||
        iTotaceite > 0 ||
        iTottinte > 0 ||
        iTotTintv > 0 ||
        iTotEspejo > 0 ||
        iTotAza > 0 ||
        iTotSulf > 0 ||
        //iTotGui > 0 ||
        //iTotDienteT > 0 ||
        //iTotEstaS > 0 ||
        iTotpiedra > 0 ||
        iToteseabj > 0 ||
        iTotzumac > 0 ||
        iTotpaster > 0 ||
        iTotraipe > 0 ||
        iTotabdesc > 0 ||
        iTotVirRes    >0 ||
        //iTotHerLad > 0 ||
        //iTotCarTier > 0
        iTotShandon > 0 ||
        iTotDiopsido > 0 ||
        iTotConcha > 0    ||
        iTotFrutFan > 0 ||
//        iTotGlanSed > 0 ||
//        iTotMatCur > 0 ||
//        iTotOjoRak > 0 ||
//        iTotPolHada > 0 ||
//        iTotBolMara > 0 ||
//        iTotCuerGarf > 0 ||
//        iTotHumGas > 0 ||
        iTotPolAnti > 0 ||
        iTotFlorLoto > 0 ||
        iTotBriSusu > 0 ||
        iTotBayAcuo > 0 ||
        iTotDieBod > 0 ||
        iTotBelladona > 0
//        iTotTrampas > 0
        )
    {
        AgregarPista(oUbicado,"*Has metido algun componente que no es valido para hacer guantes*");
        return FALSE;
    }
    return TRUE;
}



int Bono_Botas(object oUbicado)  {

//aqui por un lado se ponen los bonos que hay al tiempo que si hay materiales no permitidos se da error
    //en estos bonos lo que hago es limitar a seis, los de caracteristica o armadura a tres

    if(iPicadaRocosa >3)
       {iPicadaRocosa = 3;}

    if (iEsenTran >6)
       {iEsenTran = 6;}

    if (iEsenEvoc >6)
       {iEsenEvoc = 6;}

    if (iTotAza >3)
       {iTotAza = 3;}

    if (iTotaceite >7)
       {iTotaceite = 7;}

    if (iTotSulf >7)
       {iTotSulf = 7;}

    if (iToteseabj >3)
       {iToteseabj = 3;}

    if (iTotPolHada > 7)
        {iTotPolHada = 7;}

    if (iTotPolAnti > 7)
        {iTotPolAnti = 7;}

    if (iTotFlorLoto > 7)
        {iTotFlorLoto = 7;}

    if (iTotBriSusu > 7)
        {iTotBriSusu = 7;}




    //aqui comprobamos si hay elementos que no permitimos y que hacen no valida la receta
    if (
        //iPicadaRocosa > 0 ||
        //iEsenTran > 0 ||
        //iEsenEvoc > 0 ||
        iEsenConj > 0 ||
        iEsenAdiv > 0 ||
        iEsenIlus > 0 ||
        //iTotaceite > 0 ||
        iTottinte > 0 ||
        iTotTintv > 0 ||
        iTotEspejo > 0 ||
        //iTotAza > 0 ||
        //iTotSulf > 0 ||
        iTotGui > 0 ||
        iTotDienteT > 0 ||
        iTotEstaS > 0 ||
        iTotpiedra > 0 ||
        //iToteseabj > 0 ||
        iTotzumac > 0 ||
        iTotpaster > 0 ||
        iTotraipe > 0 ||
        iTotabdesc > 0 ||
        iTotVirRes    >0 ||
        iTotHerLad > 0 ||
        iTotCarTie > 0 ||
        iTotShandon > 0 ||
        iTotDiopsido > 0 ||
        iTotConcha > 0||
        iTotFrutFan > 0 ||
        iTotGlanSed > 0 ||
        iTotMatCur > 0 ||
        iTotOjoRak > 0 ||
//        iTotPolHada > 0 ||
        iTotBolMara > 0 ||
        iTotCuerGarf > 0 ||
        iTotHumGas > 0 ||
//        iTotPolAnti > 0 ||
//        iTotFlorLoto > 0 ||
//        iTotBriSusu > 0 ||
        iTotBayAcuo > 0 ||
        iTotDieBod > 0 ||
        iTotBelladona > 0 ||
        iTotTrampas > 0

    )
    {
        AgregarPista(oUbicado,"*Has metido algun componente que no es valido para hacer Botas*");
        return FALSE;
    }
    return TRUE;
}

 int Bono_Cintos(object oUbicado)  {

//aqui por un lado se ponen los bonos que hay al tiempo que si hay materiales no permitidos se da error
    //en estos bonos lo que hago es limitar a seis, los de caracteristica o armadura a tres

    if(iEsenEvoc >6)
       {iEsenEvoc = 6;}

    if (iEsenConj >6)
       {iEsenConj = 6;}

    if (iTotzumac >2)
       {iTotzumac = 2;}

    if (iTotpaster >2)
       {iTotpaster = 2;}

    if (iTotraipe >2)
       {iTotraipe = 2;}

    if (iPicadaRocosa >3)
       {iPicadaRocosa = 3;}

    if (iTotMatCur >7)
       {iTotMatCur = 7;}

    if (iTotOjoRak >7)
       {iTotOjoRak = 7;}

    if (iTotPolHada >7)
       {iTotPolHada = 7;}

    if (iTotPolAnti >7)
       {iTotPolAnti = 7;}

    if (iTotFlorLoto >7)
       {iTotFlorLoto = 7;}

    if (iTotBriSusu >7)
       {iTotBriSusu = 7;}

    if (iTotBelladona >7)
       {iTotBelladona = 7;}



    //aqui comprobamos si hay elementos que no permitimos y que hacen no valida la receta
    if (
        //iPicadaRocosa > 0 ||
        iEsenTran > 0 ||
        //iEsenEvoc > 0 ||
        //iEsenConj > 0 ||
        iEsenAdiv > 0 ||
        iEsenIlus > 0 ||
        iTotaceite > 0 ||
        iTottinte > 0 ||
        iTotTintv > 0 ||
        iTotEspejo > 0 ||
        iTotAza > 0 ||
        iTotSulf > 0 ||
        iTotGui > 0 ||
        iTotDienteT > 0 ||
        iTotEstaS > 0 ||
        iTotpiedra > 0 ||
        iToteseabj > 0 ||
        //iTotzumac > 0 ||
        //iTotpaster > 0 ||
        //iTotraipe > 0 ||
        iTotabdesc > 0 ||
        iTotVirRes    >0 ||
        iTotHerLad > 0 ||
        iTotCarTie > 0 ||
        iTotShandon > 0 ||
        iTotDiopsido > 0 ||
        iTotConcha > 0    ||
        iTotFrutFan > 0 ||
        iTotGlanSed > 0 ||
//        iTotMatCur > 0 ||
//        iTotOjoRak > 0 ||
//        iTotPolHada > 0 ||
        iTotBolMara > 0 ||
        iTotCuerGarf > 0 ||
        iTotHumGas > 0 ||
//        iTotPolAnti > 0 ||
//        iTotFlorLoto > 0 ||
//        iTotBriSusu > 0 ||
        iTotBayAcuo > 0 ||
        iTotDieBod > 0 ||
//        iTotBelladona > 0 ||
        iTotTrampas > 0

    )
    {
        AgregarPista(oUbicado,"*Has metido algun componente que no es valido para hacer Cintos*");
        return FALSE;
    }
    return TRUE;
}

int Bono_Capas(object oUbicado)  {

//aqui por un lado se ponen los bonos que hay al tiempo que si hay materiales no permitidos se da error
    //en estos bonos lo que hago es limitar a seis, los de caracteristica o armadura a tres

    if(iPicadaRocosa >5)
       {iPicadaRocosa = 5;}

    if (iEsenAdiv >6)
       {iEsenAdiv = 6;}

    if (iEsenTran >6)
       {iEsenTran = 6;}

    if (iTottinte  >7)
       {iTottinte  = 7;}

    if (iTotTintv > 7)
       {iTotTintv  = 7;}

    if (iTotpiedra >2)
       {iTotpiedra = 2;}

    if (iTotabdesc >2)
       {iTotabdesc = 2;}

    if (iTotVirRes >2)
       {iTotVirRes = 2;}

    if (iTotEspejo > 7)
       {iTotEspejo =7;}

    if (iTotBayAcuo > 7)
       {iTotBayAcuo =7;}

    if (iTotDieBod > 7)
       {iTotDieBod =7;}

    if (iTotBelladona > 7)
       {iTotBelladona =7;}

    if (iToteseabj > 1)
       {iToteseabj = 1;}



    //aqui comprobamos si hay elementos que no permitimos y que hacen no valida la receta
    if (
        //iPicadaRocosa > 0 ||
        //iEsenTran > 0 ||
        iEsenEvoc > 0 ||
        iEsenConj > 0 ||
        //iEsenAdiv > 0 ||
        iEsenIlus > 0 ||
        iTotaceite > 0 ||
        //iTottinte > 0 ||
        //iTotTintv > 0 ||
        //iTotEspejo > 0 ||
        iTotAza > 0 ||
        iTotSulf > 0 ||
        iTotGui > 0 ||
        iTotDienteT > 0 ||
        iTotEstaS > 0 ||
        //iTotpiedra > 0 ||
//        iToteseabj > 0 ||
        iTotzumac > 0 ||
        iTotpaster > 0 ||
        iTotraipe > 0 ||
        //iTotabdesc > 0 ||
        //iTotVirRes    >0 ||
        iTotHerLad > 0 ||
        iTotCarTie > 0 ||
        iTotShandon > 0 ||
        iTotDiopsido > 0 ||
        iTotConcha > 0     ||
        iTotFrutFan > 0 ||
        iTotGlanSed > 0 ||
        iTotMatCur > 0 ||
        iTotOjoRak > 0 ||
        iTotPolHada > 0 ||
        iTotBolMara > 0 ||
        iTotCuerGarf > 0 ||
        iTotHumGas > 0 ||
        iTotPolAnti > 0 ||
        iTotFlorLoto > 0 ||
        iTotBriSusu > 0 ||
//        iTotBayAcuo > 0 ||
//        iTotDieBod > 0 ||
//        iTotBelladona > 0 ||
        iTotTrampas > 0

    )
    {
        AgregarPista(oUbicado,"*Has metido algun componente que no es valido para hacer Capas*");
        return FALSE;
    }
    return TRUE;
}
int Bono_Capucha(object oUbicado)  {

//aqui por un lado se ponen los bonos que hay al tiempo que si hay materiales no permitidos se da error
    //en estos bonos lo que hago es limitar a seis, los de caracteristica o armadura a tres


    if (iTotShandon >7)
       {iTotShandon = 7;}

    if (iTotDiopsido >7)
       {iTotDiopsido = 7;}

    if (iTotConcha >7)
       {iTotConcha = 7;}

    if (iTotEspejo > 7)
       {iTotEspejo =7;}

    if (iTotFrutFan > 3)
       {iTotFrutFan = 3;}
    if (iTottinte > 7)
       {iTottinte = 7;}
    if (iTotTintv > 7)
       {iTotTintv = 7;}
    if (iEsenIlus > 7)
       {iEsenIlus = 7;}

    if (iPicadaRocosa >5)
       {iPicadaRocosa = 5;}

    if (iTotBayAcuo > 7)
       {iTotBayAcuo =7;}

    if (iTotDieBod > 7)
       {iTotDieBod =7;}

    if (iTotBelladona > 7)
       {iTotBelladona =7;}

    if (iTotOjoRak > 7)
       {iTotOjoRak = 7;}


    //aqui comprobamos si hay elementos que no permitimos y que hacen no valida la receta
    if (
        //iPicadaRocosa > 0 ||
        iEsenTran > 0 ||
        iEsenEvoc > 0 ||
        iEsenConj > 0 ||
        iEsenAdiv > 0 ||
        //iEsenIlus > 0 ||
        iTotaceite > 0 ||
        //iTottinte > 0 ||
        //iTotEspejo > 0 ||
        iTotAza > 0 ||
        iTotSulf > 0 ||
        iTotGui > 0 ||
        iTotDienteT > 0 ||
        iTotEstaS > 0 ||
        iTotpiedra > 0 ||
        iToteseabj > 0 ||
        iTotzumac > 0 ||
        iTotpaster > 0 ||
        iTotraipe > 0 ||
        iTotabdesc > 0 ||
        iTotVirRes    >0 ||
        iTotHerLad > 0 ||
        iTotCarTie > 0 ||
        //iTotShandon > 0 ||
        //iTotDiopsido > 0 ||
        //iTotConcha > 0
        //iTotFrutFan > 0
//        iTotFrutFan > 0 ||
        iTotGlanSed > 0 ||
        iTotMatCur > 0 ||
//        iTotOjoRak > 0 ||
        iTotPolHada > 0 ||
        iTotBolMara > 0 ||
        iTotCuerGarf > 0 ||
        iTotHumGas > 0 ||
        iTotPolAnti > 0 ||
        iTotFlorLoto > 0 ||
        iTotBriSusu > 0 ||
//        iTotBayAcuo > 0 ||
//        iTotDieBod > 0 ||
//        iTotBelladona > 0 ||
        iTotTrampas > 0

    )
    {
        AgregarPista(oUbicado,"*Has metido algun componente que no es valido para hacer Capuchas*");
        return FALSE;
    }
    return TRUE;
}

