//******************************************************************************
//* Funciones para el Sistema Generador de Tesoros (SGT)
//* Generacion de tesoros en ubicados
//* Nombre de archivo: gt_pnj_inc
//* Autor: Tomas GB
//******************************************************************************

#include "sgt_gen_inc"
#include "sgt_ubic_cfg"

void GT_CrearTersoroUbicado(object oUbicado);

int GT_ObtenerTiempoRegeneracion(object oUbicado);

//******************************************************************************
//* GT_CrearTersoroUbicado
//******************************************************************************
void GT_CrearTersoroUbicado(object oUbicado)
{
string sEtiquetaUbicado = GetTag(oUbicado);
string sTipoUbicado = "NULL";
int iGenerarTesoro = 0;
int iCodUbicado = 99;
int i;
int iOroUbicado = 0;

//Salir si el cofre no esta utilizado
if (GetStringLeft(UBICADO_COFRE_01, 4) == "null") return;

//Comprobacion del nivel del Ubicado
if (GetStringRight(sEtiquetaUbicado, 3) == "NIQ") {iCodUbicado = 1; iOroUbicado = ORO_UBI_EPIC;}
if (GetStringRight(sEtiquetaUbicado, 3) == "IGH") {iCodUbicado = 2; iOroUbicado = ORO_UBI_ALTO;}
if (GetStringRight(sEtiquetaUbicado, 3) == "MED") {iCodUbicado = 3; iOroUbicado = ORO_UBI_MED;}
if (GetStringRight(sEtiquetaUbicado, 3) == "LOW") {iCodUbicado = 4; iOroUbicado = ORO_UBI_BAJO;}
//Generacion aleatoria de oro
if((Random(100)+1) <= PROB_ORO_UBI) CreateItemOnObject("nw_it_gold001", OBJECT_SELF, Random(iOroUbicado));

for (i = iCodUbicado; i <= 4; i++)
    {
    if (i == 1) sTipoUbicado = "epic";
    if (i == 2) sTipoUbicado = "alto";
    if (i == 3) sTipoUbicado = "medi";
    if (i == 4) sTipoUbicado = "peke";

    //SendMessageToAllDMs("Tipo de Ubicado "+sTipoUbicado);

    if (sTipoUbicado == GetStringLeft(UBICADO_COFRE_01, 4))
    {
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_POT" && GetSubString(UBICADO_COFRE_01, 5, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_CLT" && GetSubString(UBICADO_COFRE_01, 6, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ANY" && GetSubString(UBICADO_COFRE_01, 7, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_BOO" && GetSubString(UBICADO_COFRE_01, 8, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ARM" && GetSubString(UBICADO_COFRE_01, 9, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_WEA" && GetSubString(UBICADO_COFRE_01, 10, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_RAN" && GetSubString(UBICADO_COFRE_01, 11, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_MLE" && GetSubString(UBICADO_COFRE_01, 12, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_NOA" && GetSubString(UBICADO_COFRE_01, 13, 1) == "1") iGenerarTesoro = 1;
    if (iGenerarTesoro == 1)
        {
        GT_GenerarTesoro(UBICADO_TIRADAS_COFRE_01, UBICADO_PROBABILIDAD_COFRE_01, UBICADO_PORCENTAGE_COFRE_01, UBICADO_APILAR_COFRE_01, AREA_COFRE_01, TAG_COFRE_01);
        iGenerarTesoro = 0;
        }
    }
    if (sTipoUbicado == GetStringLeft(UBICADO_COFRE_02, 4))
    {
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_POT" && GetSubString(UBICADO_COFRE_02, 5, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_CLT" && GetSubString(UBICADO_COFRE_02, 6, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ANY" && GetSubString(UBICADO_COFRE_02, 7, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_BOO" && GetSubString(UBICADO_COFRE_02, 8, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ARM" && GetSubString(UBICADO_COFRE_02, 9, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_WEA" && GetSubString(UBICADO_COFRE_02, 10, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_RAN" && GetSubString(UBICADO_COFRE_02, 11, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_MLE" && GetSubString(UBICADO_COFRE_02, 12, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_NOA" && GetSubString(UBICADO_COFRE_02, 13, 1) == "1") iGenerarTesoro = 1;
    if (iGenerarTesoro == 1)
        {
        GT_GenerarTesoro(UBICADO_TIRADAS_COFRE_02, UBICADO_PROBABILIDAD_COFRE_02, UBICADO_PORCENTAGE_COFRE_02, UBICADO_APILAR_COFRE_02, AREA_COFRE_02, TAG_COFRE_02);
        iGenerarTesoro = 0;
        }
    }
    if (sTipoUbicado == GetStringLeft(UBICADO_COFRE_03, 4))
    {
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_POT" && GetSubString(UBICADO_COFRE_03, 5, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_CLT" && GetSubString(UBICADO_COFRE_03, 6, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ANY" && GetSubString(UBICADO_COFRE_03, 7, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_BOO" && GetSubString(UBICADO_COFRE_03, 8, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ARM" && GetSubString(UBICADO_COFRE_03, 9, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_WEA" && GetSubString(UBICADO_COFRE_03, 10, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_RAN" && GetSubString(UBICADO_COFRE_03, 11, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_MLE" && GetSubString(UBICADO_COFRE_03, 12, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_NOA" && GetSubString(UBICADO_COFRE_03, 13, 1) == "1") iGenerarTesoro = 1;
    if (iGenerarTesoro == 1)
        {
        GT_GenerarTesoro(UBICADO_TIRADAS_COFRE_03, UBICADO_PROBABILIDAD_COFRE_03, UBICADO_PORCENTAGE_COFRE_03, UBICADO_APILAR_COFRE_03, AREA_COFRE_03, TAG_COFRE_03);
        iGenerarTesoro = 0;
        }
    }
    if (sTipoUbicado == GetStringLeft(UBICADO_COFRE_04, 4))
    {
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_POT" && GetSubString(UBICADO_COFRE_04, 5, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_CLT" && GetSubString(UBICADO_COFRE_04, 6, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ANY" && GetSubString(UBICADO_COFRE_04, 7, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_BOO" && GetSubString(UBICADO_COFRE_04, 8, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ARM" && GetSubString(UBICADO_COFRE_04, 9, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_WEA" && GetSubString(UBICADO_COFRE_04, 10, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_RAN" && GetSubString(UBICADO_COFRE_04, 11, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_MLE" && GetSubString(UBICADO_COFRE_04, 12, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_NOA" && GetSubString(UBICADO_COFRE_04, 13, 1) == "1") iGenerarTesoro = 1;
    if (iGenerarTesoro == 1)
        {
        GT_GenerarTesoro(UBICADO_TIRADAS_COFRE_04, UBICADO_PROBABILIDAD_COFRE_04, UBICADO_PORCENTAGE_COFRE_04, UBICADO_APILAR_COFRE_04, AREA_COFRE_04, TAG_COFRE_04);
        iGenerarTesoro = 0;
        }
    }
    if (sTipoUbicado == GetStringLeft(UBICADO_COFRE_05, 4))
    {
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_POT" && GetSubString(UBICADO_COFRE_05, 5, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_CLT" && GetSubString(UBICADO_COFRE_05, 6, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ANY" && GetSubString(UBICADO_COFRE_05, 7, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_BOO" && GetSubString(UBICADO_COFRE_05, 8, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ARM" && GetSubString(UBICADO_COFRE_05, 9, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_WEA" && GetSubString(UBICADO_COFRE_05, 10, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_RAN" && GetSubString(UBICADO_COFRE_05, 11, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_MLE" && GetSubString(UBICADO_COFRE_05, 12, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_NOA" && GetSubString(UBICADO_COFRE_05, 13, 1) == "1") iGenerarTesoro = 1;
    if (iGenerarTesoro == 1)
        {
        GT_GenerarTesoro(UBICADO_TIRADAS_COFRE_05, UBICADO_PROBABILIDAD_COFRE_05, UBICADO_PORCENTAGE_COFRE_05, UBICADO_APILAR_COFRE_05, AREA_COFRE_05, TAG_COFRE_05);
        iGenerarTesoro = 0;
        }
    }
    if (sTipoUbicado == GetStringLeft(UBICADO_COFRE_06, 4))
    {
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_POT" && GetSubString(UBICADO_COFRE_06, 5, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_CLT" && GetSubString(UBICADO_COFRE_06, 6, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ANY" && GetSubString(UBICADO_COFRE_06, 7, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_BOO" && GetSubString(UBICADO_COFRE_06, 8, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ARM" && GetSubString(UBICADO_COFRE_06, 9, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_WEA" && GetSubString(UBICADO_COFRE_06, 10, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_RAN" && GetSubString(UBICADO_COFRE_06, 11, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_MLE" && GetSubString(UBICADO_COFRE_06, 12, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_NOA" && GetSubString(UBICADO_COFRE_06, 13, 1) == "1") iGenerarTesoro = 1;
    if (iGenerarTesoro == 1)
        {
        GT_GenerarTesoro(UBICADO_TIRADAS_COFRE_06, UBICADO_PROBABILIDAD_COFRE_06, UBICADO_PORCENTAGE_COFRE_06, UBICADO_APILAR_COFRE_06, AREA_COFRE_06, TAG_COFRE_06);
        iGenerarTesoro = 0;
        }
    }
    if (sTipoUbicado == GetStringLeft(UBICADO_COFRE_07, 4))
    {
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_POT" && GetSubString(UBICADO_COFRE_07, 5, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_CLT" && GetSubString(UBICADO_COFRE_07, 6, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ANY" && GetSubString(UBICADO_COFRE_07, 7, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_BOO" && GetSubString(UBICADO_COFRE_07, 8, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ARM" && GetSubString(UBICADO_COFRE_07, 9, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_WEA" && GetSubString(UBICADO_COFRE_07, 10, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_RAN" && GetSubString(UBICADO_COFRE_07, 11, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_MLE" && GetSubString(UBICADO_COFRE_07, 12, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_NOA" && GetSubString(UBICADO_COFRE_07, 13, 1) == "1") iGenerarTesoro = 1;
    if (iGenerarTesoro == 1)
        {
        GT_GenerarTesoro(UBICADO_TIRADAS_COFRE_07, UBICADO_PROBABILIDAD_COFRE_07, UBICADO_PORCENTAGE_COFRE_07, UBICADO_APILAR_COFRE_07, AREA_COFRE_07, TAG_COFRE_07);
        iGenerarTesoro = 0;
        }
    }
    if (sTipoUbicado == GetStringLeft(UBICADO_COFRE_08, 4))
    {
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_POT" && GetSubString(UBICADO_COFRE_08, 5, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_CLT" && GetSubString(UBICADO_COFRE_08, 6, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ANY" && GetSubString(UBICADO_COFRE_08, 7, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_BOO" && GetSubString(UBICADO_COFRE_08, 8, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ARM" && GetSubString(UBICADO_COFRE_08, 9, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_WEA" && GetSubString(UBICADO_COFRE_08, 10, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_RAN" && GetSubString(UBICADO_COFRE_08, 11, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_MLE" && GetSubString(UBICADO_COFRE_08, 12, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_NOA" && GetSubString(UBICADO_COFRE_08, 13, 1) == "1") iGenerarTesoro = 1;
    if (iGenerarTesoro == 1)
        {
        GT_GenerarTesoro(UBICADO_TIRADAS_COFRE_08, UBICADO_PROBABILIDAD_COFRE_08, UBICADO_PORCENTAGE_COFRE_08, UBICADO_APILAR_COFRE_08, AREA_COFRE_08, TAG_COFRE_08);
        iGenerarTesoro = 0;
        }
    }
    if (sTipoUbicado == GetStringLeft(UBICADO_COFRE_09, 4))
    {
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_POT" && GetSubString(UBICADO_COFRE_09, 5, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_CLT" && GetSubString(UBICADO_COFRE_09, 6, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ANY" && GetSubString(UBICADO_COFRE_09, 7, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_BOO" && GetSubString(UBICADO_COFRE_09, 8, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ARM" && GetSubString(UBICADO_COFRE_09, 9, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_WEA" && GetSubString(UBICADO_COFRE_09, 10, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_RAN" && GetSubString(UBICADO_COFRE_09, 11, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_MLE" && GetSubString(UBICADO_COFRE_09, 12, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_NOA" && GetSubString(UBICADO_COFRE_09, 13, 1) == "1") iGenerarTesoro = 1;
    if (iGenerarTesoro == 1)
        {
        GT_GenerarTesoro(UBICADO_TIRADAS_COFRE_09, UBICADO_PROBABILIDAD_COFRE_09, UBICADO_PORCENTAGE_COFRE_09, UBICADO_APILAR_COFRE_09, AREA_COFRE_09, TAG_COFRE_09);
        iGenerarTesoro = 0;
        }
    }
    if (sTipoUbicado == GetStringLeft(UBICADO_COFRE_10, 4))
    {
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_POT" && GetSubString(UBICADO_COFRE_10, 5, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_CLT" && GetSubString(UBICADO_COFRE_10, 6, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ANY" && GetSubString(UBICADO_COFRE_10, 7, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_BOO" && GetSubString(UBICADO_COFRE_10, 8, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ARM" && GetSubString(UBICADO_COFRE_10, 9, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_WEA" && GetSubString(UBICADO_COFRE_10, 10, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_RAN" && GetSubString(UBICADO_COFRE_10, 11, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_MLE" && GetSubString(UBICADO_COFRE_10, 12, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_NOA" && GetSubString(UBICADO_COFRE_10, 13, 1) == "1") iGenerarTesoro = 1;
    if (iGenerarTesoro == 1)
        {
        GT_GenerarTesoro(UBICADO_TIRADAS_COFRE_10, UBICADO_PROBABILIDAD_COFRE_10, UBICADO_PORCENTAGE_COFRE_10, UBICADO_APILAR_COFRE_10, AREA_COFRE_10, TAG_COFRE_10);
        iGenerarTesoro = 0;
        }
    }
    if (sTipoUbicado == GetStringLeft(UBICADO_COFRE_11, 4))
    {
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_POT" && GetSubString(UBICADO_COFRE_11, 5, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_CLT" && GetSubString(UBICADO_COFRE_11, 6, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ANY" && GetSubString(UBICADO_COFRE_11, 7, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_BOO" && GetSubString(UBICADO_COFRE_11, 8, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ARM" && GetSubString(UBICADO_COFRE_11, 9, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_WEA" && GetSubString(UBICADO_COFRE_11, 10, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_RAN" && GetSubString(UBICADO_COFRE_11, 11, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_MLE" && GetSubString(UBICADO_COFRE_11, 12, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_NOA" && GetSubString(UBICADO_COFRE_11, 13, 1) == "1") iGenerarTesoro = 1;
    if (iGenerarTesoro == 1)
        {
        GT_GenerarTesoro(UBICADO_TIRADAS_COFRE_11, UBICADO_PROBABILIDAD_COFRE_11, UBICADO_PORCENTAGE_COFRE_11, UBICADO_APILAR_COFRE_11, AREA_COFRE_11, TAG_COFRE_11);
        iGenerarTesoro = 0;
        }
    }
    if (sTipoUbicado == GetStringLeft(UBICADO_COFRE_12, 4))
    {
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_POT" && GetSubString(UBICADO_COFRE_12, 5, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_CLT" && GetSubString(UBICADO_COFRE_12, 6, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ANY" && GetSubString(UBICADO_COFRE_12, 7, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_BOO" && GetSubString(UBICADO_COFRE_12, 8, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ARM" && GetSubString(UBICADO_COFRE_12, 9, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_WEA" && GetSubString(UBICADO_COFRE_12, 10, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_RAN" && GetSubString(UBICADO_COFRE_12, 11, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_MLE" && GetSubString(UBICADO_COFRE_12, 12, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_NOA" && GetSubString(UBICADO_COFRE_12, 13, 1) == "1") iGenerarTesoro = 1;
    if (iGenerarTesoro == 1)
        {
        GT_GenerarTesoro(UBICADO_TIRADAS_COFRE_12, UBICADO_PROBABILIDAD_COFRE_12, UBICADO_PORCENTAGE_COFRE_12, UBICADO_APILAR_COFRE_12, AREA_COFRE_12, TAG_COFRE_12);
        iGenerarTesoro = 0;
        }
    }
    if (sTipoUbicado == GetStringLeft(UBICADO_COFRE_13, 4))
    {
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_POT" && GetSubString(UBICADO_COFRE_13, 5, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_CLT" && GetSubString(UBICADO_COFRE_13, 6, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ANY" && GetSubString(UBICADO_COFRE_13, 7, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_BOO" && GetSubString(UBICADO_COFRE_13, 8, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ARM" && GetSubString(UBICADO_COFRE_13, 9, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_WEA" && GetSubString(UBICADO_COFRE_13, 10, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_RAN" && GetSubString(UBICADO_COFRE_13, 11, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_MLE" && GetSubString(UBICADO_COFRE_13, 12, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_NOA" && GetSubString(UBICADO_COFRE_13, 13, 1) == "1") iGenerarTesoro = 1;
    if (iGenerarTesoro == 1)
        {
        GT_GenerarTesoro(UBICADO_TIRADAS_COFRE_13, UBICADO_PROBABILIDAD_COFRE_13, UBICADO_PORCENTAGE_COFRE_13, UBICADO_APILAR_COFRE_13, AREA_COFRE_13, TAG_COFRE_13);
        iGenerarTesoro = 0;
        }
    }
    if (sTipoUbicado == GetStringLeft(UBICADO_COFRE_14, 4))
    {
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_POT" && GetSubString(UBICADO_COFRE_14, 5, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_CLT" && GetSubString(UBICADO_COFRE_14, 6, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ANY" && GetSubString(UBICADO_COFRE_14, 7, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_BOO" && GetSubString(UBICADO_COFRE_14, 8, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ARM" && GetSubString(UBICADO_COFRE_14, 9, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_WEA" && GetSubString(UBICADO_COFRE_14, 10, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_RAN" && GetSubString(UBICADO_COFRE_14, 11, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_MLE" && GetSubString(UBICADO_COFRE_14, 12, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_NOA" && GetSubString(UBICADO_COFRE_14, 13, 1) == "1") iGenerarTesoro = 1;
    if (iGenerarTesoro == 1)
        {
        GT_GenerarTesoro(UBICADO_TIRADAS_COFRE_14, UBICADO_PROBABILIDAD_COFRE_14, UBICADO_PORCENTAGE_COFRE_14, UBICADO_APILAR_COFRE_14, AREA_COFRE_14, TAG_COFRE_14);
        iGenerarTesoro = 0;
        }
    }
    if (sTipoUbicado == GetStringLeft(UBICADO_COFRE_15, 4))
    {
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_POT" && GetSubString(UBICADO_COFRE_15, 5, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_CLT" && GetSubString(UBICADO_COFRE_15, 6, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ANY" && GetSubString(UBICADO_COFRE_15, 7, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_BOO" && GetSubString(UBICADO_COFRE_15, 8, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ARM" && GetSubString(UBICADO_COFRE_15, 9, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_WEA" && GetSubString(UBICADO_COFRE_15, 10, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_RAN" && GetSubString(UBICADO_COFRE_15, 11, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_MLE" && GetSubString(UBICADO_COFRE_15, 12, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_NOA" && GetSubString(UBICADO_COFRE_15, 13, 1) == "1") iGenerarTesoro = 1;
    if (iGenerarTesoro == 1)
        {
        GT_GenerarTesoro(UBICADO_TIRADAS_COFRE_15, UBICADO_PROBABILIDAD_COFRE_15, UBICADO_PORCENTAGE_COFRE_15, UBICADO_APILAR_COFRE_15, AREA_COFRE_15, TAG_COFRE_15);
        iGenerarTesoro = 0;
        }
    }
    if (sTipoUbicado == GetStringLeft(UBICADO_COFRE_16, 4))
    {
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_POT" && GetSubString(UBICADO_COFRE_16, 5, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_CLT" && GetSubString(UBICADO_COFRE_16, 6, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ANY" && GetSubString(UBICADO_COFRE_16, 7, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_BOO" && GetSubString(UBICADO_COFRE_16, 8, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ARM" && GetSubString(UBICADO_COFRE_16, 9, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_WEA" && GetSubString(UBICADO_COFRE_16, 10, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_RAN" && GetSubString(UBICADO_COFRE_16, 11, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_MLE" && GetSubString(UBICADO_COFRE_16, 12, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_NOA" && GetSubString(UBICADO_COFRE_16, 13, 1) == "1") iGenerarTesoro = 1;
    if (iGenerarTesoro == 1)
        {
        GT_GenerarTesoro(UBICADO_TIRADAS_COFRE_16, UBICADO_PROBABILIDAD_COFRE_16, UBICADO_PORCENTAGE_COFRE_16, UBICADO_APILAR_COFRE_16, AREA_COFRE_16, TAG_COFRE_16);
        iGenerarTesoro = 0;
        }
    }
    if (sTipoUbicado == GetStringLeft(UBICADO_COFRE_17, 4))
    {
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_POT" && GetSubString(UBICADO_COFRE_17, 5, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_CLT" && GetSubString(UBICADO_COFRE_17, 6, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ANY" && GetSubString(UBICADO_COFRE_17, 7, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_BOO" && GetSubString(UBICADO_COFRE_17, 8, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ARM" && GetSubString(UBICADO_COFRE_17, 9, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_WEA" && GetSubString(UBICADO_COFRE_17, 10, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_RAN" && GetSubString(UBICADO_COFRE_17, 11, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_MLE" && GetSubString(UBICADO_COFRE_17, 12, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_NOA" && GetSubString(UBICADO_COFRE_17, 13, 1) == "1") iGenerarTesoro = 1;
    if (iGenerarTesoro == 1)
        {
        GT_GenerarTesoro(UBICADO_TIRADAS_COFRE_17, UBICADO_PROBABILIDAD_COFRE_17, UBICADO_PORCENTAGE_COFRE_17, UBICADO_APILAR_COFRE_17, AREA_COFRE_17, TAG_COFRE_17);
        iGenerarTesoro = 0;
        }
    }
    if (sTipoUbicado == GetStringLeft(UBICADO_COFRE_18, 4))
    {
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_POT" && GetSubString(UBICADO_COFRE_18, 5, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_CLT" && GetSubString(UBICADO_COFRE_18, 6, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ANY" && GetSubString(UBICADO_COFRE_18, 7, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_BOO" && GetSubString(UBICADO_COFRE_18, 8, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_ARM" && GetSubString(UBICADO_COFRE_18, 9, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_WEA" && GetSubString(UBICADO_COFRE_18, 10, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_RAN" && GetSubString(UBICADO_COFRE_18, 11, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_MLE" && GetSubString(UBICADO_COFRE_18, 12, 1) == "1") iGenerarTesoro = 1;
    if (GetSubString(sEtiquetaUbicado, 7, 4) == "_NOA" && GetSubString(UBICADO_COFRE_18, 13, 1) == "1") iGenerarTesoro = 1;
    if (iGenerarTesoro == 1)
        {
        GT_GenerarTesoro(UBICADO_TIRADAS_COFRE_18, UBICADO_PROBABILIDAD_COFRE_18, UBICADO_PORCENTAGE_COFRE_18, UBICADO_APILAR_COFRE_18, AREA_COFRE_18, TAG_COFRE_18);
        iGenerarTesoro = 0;
        }
    }
    }
}

//******************************************************************************
//* GT_ObtenerTiempoRegeneracion, Obtiene el tiempo de regeneracion del tesoro ubicado
//******************************************************************************

int GT_ObtenerTiempoRegeneracion(object oUbicado)
{
string sEtiquetaUbicado = GetTag(oUbicado);

if (GetStringRight(sEtiquetaUbicado, 3) == "NIQ") return TG_EPICO;
if (GetStringRight(sEtiquetaUbicado, 3) == "IGH") return TG_ALTO;
if (GetStringRight(sEtiquetaUbicado, 3) == "MED") return TG_MEDIO;
if (GetStringRight(sEtiquetaUbicado, 3) == "LOW") return TG_PEKENO;
return 99;
}
