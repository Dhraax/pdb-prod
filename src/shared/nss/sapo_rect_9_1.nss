#include "sapo_constantes"
#include "sapo_func_recetas"
#include "sapo_rect_9_inc"

int ComprobarComponentesYCargar(object oUbicado);
int CargarVariables(object oUbicado, string sNomPiel);
int CargarVariablesFormula(object oUbicado, string sNomPiel);
int DificultadSegunPiel(string sNomPiel);
string SubparteParaNombreSegunPiel(string sNomPiel);
int CargarVariablesObjeto(object oUbicado, string sNomAccesorio, string sNomTablon, int iTotTablones, int iTotTablonesFormula);
string CuerosCreadosSegunPiel(string sNomPiel);

void main()
{

    int iFuncion=GetLocalInt(OBJECT_SELF,"Funcion");
    switch (iFuncion) {
        case FUNCION_COMPROBAR_Y_CARGAR:
            SetLocalInt(OBJECT_SELF,"fnRetorno",ComprobarComponentesYCargar(OBJECT_SELF));
        case FUNCION_CREAR_OBJETO:
            //No es necesario en este caso
    }

}

int ComprobarComponentesYCargar(object oUbicado) {

    if (DEBUG) SpeakString("----Entrando en ComprobarComponentesYCargar----");
    string sResRef = GetResRef(oUbicado);

    SetLocalString(oUbicado,"fnMaterialMascara1","pielde*");
    SetLocalString(oUbicado,"fnMaterialMascara2","pellejoderata");

    ExecuteScript("sapo_rect_gen",OBJECT_SELF);

    string sNomPiel=GetLocalString(oUbicado,"fnMaterialRetorno1");
    int iTotPieles=GetLocalInt(oUbicado,"fnMaterialRetornoTotal1");
    string sNomPellejo=GetLocalString(oUbicado,"fnMaterialRetorno2");
    int iTotPellejo=GetLocalInt(oUbicado,"fnMaterialRetornoTotal2");


    int iTotMateriales=GetLocalInt(oUbicado,"fnMaterialesRetornoTotal");

    if (iTotPellejo>0)
    {sNomPiel="pielderata";
     iTotPieles=iTotPellejo;
     iTotPellejo=0;
     iTotMateriales=iTotPieles;
    }

    int iRetorno=GetLocalInt(oUbicado,"fnRetorno");

    BorrarVariablesParaScript_sapo_rect_gen(oUbicado);

    if (iRetorno==FALSE) return FALSE;
    if (iTotPieles!=1) {
        AgregarPista(oUbicado,"*Necesitas una unica piel*");
        return FALSE;
    }

    int iTotalIngrediente;
    iTotalIngrediente=TotalMaterialEnInventarioSegunNombre(oUbicado,"sapo_ing_sal",FALSE);
    if (iTotalIngrediente!=1) {
        AgregarPista(oUbicado,"*Necesitas un unico saco de sal*");
        return FALSE;
    }
    iTotalIngrediente=TotalMaterialEnInventarioSegunNombre(oUbicado,"sapo_ing_tanino",FALSE);
    if (iTotalIngrediente!=1) {
        AgregarPista(oUbicado,"*Necesitas una unica botella de tanino*");
        return FALSE;
    }
    iTotalIngrediente=TotalMaterialEnInventarioSegunNombre(oUbicado,"sapo_ing_cera",FALSE);
    if (iTotalIngrediente!=1) {
        AgregarPista(oUbicado,"*Necesitas una unica barra de cera*");
        return FALSE;
    }



    //if (iTotMateriales!=1) {
    //
    //    AgregarPista(oUbicado,"*Algo sobra o falta...*");
    //    return FALSE;
    //}


    return CargarVariables(oUbicado, sNomPiel);

}


int CargarVariables(object oUbicado, string sNomPiel) {

    CargarVariablesComunes(oUbicado);
    return CargarVariablesFormula(oUbicado, sNomPiel);

}

int CargarVariablesFormula(object oUbicado, string sNomPiel) {


    string sNombreParte1=SubparteParaNombreSegunPiel(sNomPiel);
    string sObjetoCrear="sapo_cuero_" + sNombreParte1;

    int iDificultad=DificultadSegunPiel(sNomPiel);

    DificultadFormula(oUbicado,iDificultad);
    ObjetoCrear(oUbicado,sObjetoCrear);
    ObjetoCrearCantidad(oUbicado, CuerosCreadosSegunPiel(sNomPiel));
    SetLocalInt(oUbicado,"CRAFT_CUEROPELE",1);
    return TRUE;

}

int DificultadSegunPiel(string sNomPiel) {

    if (sNomPiel=="pielderata") return 80;
    if (sNomPiel=="pieldeserpiente") return 140;
    if (sNomPiel=="pieldeciervo") return 200;
    if (sNomPiel=="pieldelobo") return 260;
    if (sNomPiel=="pieldejabali") return 320;
    //if (sNomPiel=="pieldeloboinvernal") return 380;
    if (sNomPiel=="pieldeloboinvern") return 380;
    if (sNomPiel=="pieldeoso") return 440;
    if (sNomPiel=="pieldemurci") return 140;
    if (sNomPiel=="pielderothe") return 200;
    if (sNomPiel=="pieldecani") return 260;
    if (sNomPiel=="pieldelagar") return 320;
    if (sNomPiel=="pieldewyrm") return 440;

    return 1000;

}

string CuerosCreadosSegunPiel(string sNomPiel) {

    if (sNomPiel=="pielderata") return "1";
    if (sNomPiel=="pieldeserpiente") return "1";
    if (sNomPiel=="pieldeciervo") return "d3()";
    if (sNomPiel=="pieldelobo") return "d3()";
    if (sNomPiel=="pieldejabali") return "d3()";
    if (sNomPiel=="pieldeloboinvern") return "d3()";
    if (sNomPiel=="pieldeoso") return "d6()";
    if (sNomPiel=="pieldemurci") return "1";
    if (sNomPiel=="pielderothe") return "d3()";
    if (sNomPiel=="pieldecani") return "d3()";
    if (sNomPiel=="pieldelagar") return "d3()";
    if (sNomPiel=="pieldewyrm") return "d6()";

    return "1";

}

string SubparteParaNombreSegunPiel(string sNomPiel) {


    return GetStringLeft(GetStringRight(sNomPiel,GetStringLength(sNomPiel) - GetStringLength("pielde")),5);

}



