//******************************************************************************
//* Funciones para el Sistema Generador de Tesoros (SGT)
//* Nombre de archivo: gt_inc
//* Autor: Tomas GB
//******************************************************************************

#include "sgt_gen_cfg"

// Counting the actual date from Year0 Month0 Day0 Hour0 in hours
int SGT_GetHourTimeZero(int iYear = 99999, int iMonth = 99, int iDay = 99, int iHour = 99);

//Mensajes de inicio del sistema en el servidor
void SGT_MensajesServidor(object oPlayer);

//Crea en oDestino los objetos que se encuentren dentro del ubicado en un tiempo iTiempo
void GT_ObjetoFijo(object oDestino, int iTiempo, object oPC);

//Destruye todos los objetos contenidos en oUbicado
void GT_DestruirContenido(object oUbicado);



//Cuenta el numero de objetos del cofre con la etiqueta sTagCofre en el area
//con la etiqueta sAreaCofres
void GT_ContarObjsCofre(string sAreaCofres, string sTagCofre);

//Genera un tesoro
//iTiradas = Numero de tiradas de dados para generar el tesoro.
//iProbaGT = Probabilidad de generacion.
//Porcentage = Porcentage de generacion del tesoro.
//iApilar = Numero de objetos a apilar como maximo (es aleatorio).
//sAreaTesoro = Area del cofre del que se sacara el objeto a generar.
//sTagCofre = Etiqueta del cofre del area de tesoros utilizado para generar el tesoro.
//
//Por ejemplo, para hacer dos tiradas con una probabilidad de exito de 3 por 200, apilando 3 objetos
// del cofre GT_Cofre_01 del area de tesoros _SGT_Areas_03_
//
//GT_GenerarTesoro(2, 3, 200, 3, "_SGT_Areas_03_", "GT_Cofre_01");
void GT_GenerarTesoro(int iTiradas, int iProbaGT, int Porcentage, int iApilar, string sAreaTesoro, string sTagCofre);

//Funcion para cambiar de color los textos
string SGT_ColorText(string sText, string sColor);

//Funcion para activar trampa magica para eliminacion de efectos magicos
void SGT_TrampaDisipacion(object oPC);

//******************************************************************************
// ColorText
//******************************************************************************
string SGT_ColorText(string sText, string sColor)
{
    //string DST_COLOR_TAGS = GetName(GetObjectByTag("dem_color_text"));
    string DST_COLOR_WHITE   = "<cσσσ>"; // White //GetSubString(DST_COLOR_TAGS, 0, 6);
    string DST_COLOR_YELLOW  = "<cσσ >"; //GetSubString(DST_COLOR_TAGS, 6, 6);
    string DST_COLOR_MAGENTA = "<cσ σ>"; //GetSubString(DST_COLOR_TAGS, 12, 6);
    string DST_COLOR_LILA    = "<cξ~ξ>";
    string DST_COLOR_CYAN    = "<c σσ>"; //GetSubString(DST_COLOR_TAGS, 18, 6);
    string DST_COLOR_RED     = "<cσ  >"; //GetSubString(DST_COLOR_TAGS, 24, 6);
    string DST_COLOR_GREEN   = "<c σ >"; //GetSubString(DST_COLOR_TAGS, 30, 6);
    string DST_COLOR_BLUE    = "<c  σ>"; //GetSubString(DST_COLOR_TAGS, 36, 6);
    string DST_COLOR_END     = "</c>";   // (color end TAG)
    string DST_COLOR_NORMAL = DST_COLOR_WHITE;

    string sApply = DST_COLOR_NORMAL;
    string sTest = GetStringLowerCase(GetStringLeft(sColor, 1));
    if (sTest=="y")  sApply = DST_COLOR_YELLOW;
    else if (sTest == "m") sApply = DST_COLOR_MAGENTA;
    else if (sTest == "l") sApply = DST_COLOR_LILA;
    else if (sTest == "c") sApply = DST_COLOR_CYAN;
    else if (sTest == "r") sApply = DST_COLOR_RED;
    else if (sTest == "g") sApply = DST_COLOR_GREEN;
    else if (sTest == "b") sApply = DST_COLOR_BLUE;
    string sFinal = sApply + sText + DST_COLOR_END;
    return sFinal;
}

//::///////////////////////////////////////////////
//:: SGT_GetHourTimeZero
//:: Copyright (c) 2002 BrotherhoodofZock
//:://////////////////////////////////////////////
/*
   modified July 30, 2002
   iHourTimeZero calculation modified. iYear-1 replaced by iYear.
   In NWN the Year-count starts with 0 (though year 0 doesn't make much sense).
   Think of year 0 as the first year (Year 1).
*/
//:://////////////////////////////////////////////
//:: Created By: Timo "Lord Gsox" Bischoff (NWN Nick: Kihon)
//:: Created On: July 07, 2002
//:://////////////////////////////////////////////

// Counting the actual date from Year0 Month0 Day0 Hour0 in hours
int SGT_GetHourTimeZero(int iYear = 99999, int iMonth = 99, int iDay = 99, int iHour = 99)
{
  // Check if a specific Date/Time is forwarded to the function.
  // If no or invalid values are forwarded to the function, the current Date/Time will be used
  if (iYear > 30000)
    iYear = GetCalendarYear();
  if (iMonth > 12)
    iMonth = GetCalendarMonth();
  if (iDay > 28)
    iDay = GetCalendarDay();
  if (iHour > 23)
    iHour = GetTimeHour();

  //Calculate and return the "HourTimeZero"-TimeIndex
  int iHourTimeZero = (iYear)*12*28*24 + (iMonth-1)*28*24 + (iDay-1)*24 + iHour;
  return iHourTimeZero;
}

//******************************************************************************
//* SGT_MensajesServidor
//******************************************************************************
void SGT_MensajesServidor(object oPlayer)
{
SendMessageToPC(oPlayer, "Cargado el Sistema de Tesoros RC (Release Candidate).");
SendMessageToPC(oPlayer, "Cargados "+IntToString(GetLocalInt(GetModule(), "GT_Cofre_01"))+" objetos del Sistema Generador de Tesoros.");
SendMessageToPC(oPlayer, "Cargados "+IntToString(GetLocalInt(GetModule(), "GT_Cofre_02"))+" objetos del Sistema Generador de Tesoros.");
SendMessageToPC(oPlayer, "Cargados "+IntToString(GetLocalInt(GetModule(), "GT_Cofre_03"))+" objetos del Sistema Generador de Tesoros.");
SendMessageToPC(oPlayer, "Cargados "+IntToString(GetLocalInt(GetModule(), "GT_Cofre_04"))+" objetos del Sistema Generador de Tesoros.");
SendMessageToPC(oPlayer, "Cargados "+IntToString(GetLocalInt(GetModule(), "GT_Cofre_05"))+" objetos del Sistema Generador de Tesoros.");
SendMessageToPC(oPlayer, "Cargados "+IntToString(GetLocalInt(GetModule(), "GT_Cofre_06"))+" objetos del Sistema Generador de Tesoros.");
SendMessageToPC(oPlayer, "Cargados "+IntToString(GetLocalInt(GetModule(), "GT_Cofre_07"))+" objetos del Sistema Generador de Tesoros.");
SendMessageToPC(oPlayer, "Cargados "+IntToString(GetLocalInt(GetModule(), "GT_Cofre_08"))+" objetos del Sistema Generador de Tesoros.");
SendMessageToPC(oPlayer, "Cargados "+IntToString(GetLocalInt(GetModule(), "GT_Cofre_09"))+" objetos del Sistema Generador de Tesoros.");
SendMessageToPC(oPlayer, "Cargados "+IntToString(GetLocalInt(GetModule(), "GT_Cofre_10"))+" objetos del Sistema Generador de Tesoros.");
SendMessageToPC(oPlayer, "Cargados "+IntToString(GetLocalInt(GetModule(), "GT_Cofre_11"))+" objetos del Sistema Generador de Tesoros.");
SendMessageToPC(oPlayer, "Cargados "+IntToString(GetLocalInt(GetModule(), "GT_Cofre_12"))+" objetos del Sistema Generador de Tesoros.");
SendMessageToPC(oPlayer, "Cargados "+IntToString(GetLocalInt(GetModule(), "GT_Cofre_13"))+" objetos del Sistema Generador de Tesoros.");
SendMessageToPC(oPlayer, "Cargados "+IntToString(GetLocalInt(GetModule(), "GT_Cofre_14"))+" objetos del Sistema Generador de Tesoros.");
SendMessageToPC(oPlayer, "Cargados "+IntToString(GetLocalInt(GetModule(), "GT_Cofre_15"))+" objetos del Sistema Generador de Tesoros.");
SendMessageToPC(oPlayer, "Cargados "+IntToString(GetLocalInt(GetModule(), "GT_Cofre_16"))+" objetos del Sistema Generador de Tesoros.");
SendMessageToPC(oPlayer, "Cargados "+IntToString(GetLocalInt(GetModule(), "GT_Cofre_17"))+" objetos del Sistema Generador de Tesoros.");
SendMessageToPC(oPlayer, "Cargados "+IntToString(GetLocalInt(GetModule(), "GT_Cofre_18"))+" objetos del Sistema Generador de Tesoros.");
}

//******************************************************************************
//* GT_DestruirContenido
//******************************************************************************
void GT_DestruirContenido(object oUbicado)
{
object oObjeto = GetFirstItemInInventory(oUbicado);

while( GetIsObjectValid(oObjeto))
     {
     DestroyObject(oObjeto);
     oObjeto = GetNextItemInInventory(oUbicado);
     }
}


//******************************************************************************
//* GT_ObjetoFijo
//******************************************************************************
void GT_CrearObjeto(string sRRObjeto, object oLugar)
{
CreateItemOnObject(sRRObjeto, oLugar);
}

void GT_ObjetoFijo(object oDestino, int iTiempo, object oPC)
{
string sResRefObjeto = GetLocalString(oDestino, "SGT_RRObjetoFijo");
string sResRefObjeto2 = GetLocalString(oDestino, "SGT_RRObjetoFijo2");
object oObjeto = OBJECT_INVALID;
int iSomeObject = 0;
float sTiempo = IntToFloat(iTiempo);

//bug system
string sNombreArea = GetName(GetArea(oPC));
if(sResRefObjeto == "") SendMessageToAllDMs("Error: Ubicado sin variable en area "+sNombreArea+". SGT - Objetos fijos.");

DelayCommand(sTiempo - 0.1, GT_DestruirContenido(oDestino));
DelayCommand(sTiempo, GT_CrearObjeto(sResRefObjeto, oDestino));
if(sResRefObjeto2 == "" || sResRefObjeto2 == "NULL")
    {
    }
else DelayCommand(sTiempo, GT_CrearObjeto(sResRefObjeto2, oDestino));
}


//******************************************************************************
//* SGT_TrampaDisipacion
//******************************************************************************
void SGT_TrampaDisipacion(object oPC)
{
    effect eVisual = EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION);

    SendMessageToPC(oPC, "Prueba de buscar no superada. Has activado una trampa magica.");
    DelayCommand(0.1,AssignCommand(oPC, PlaySound("gui_trapsetoff")));
    DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oPC));
    effect eEfecto = GetFirstEffect(oPC);
    while(GetIsEffectValid(eEfecto))
        {
        if (GetEffectType(eEfecto) == EFFECT_TYPE_ABILITY_DECREASE ||
            GetEffectType(eEfecto) == EFFECT_TYPE_AC_DECREASE ||
            GetEffectType(eEfecto) == EFFECT_TYPE_ATTACK_DECREASE ||
            GetEffectType(eEfecto) == EFFECT_TYPE_DAMAGE_DECREASE ||
            GetEffectType(eEfecto) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
            GetEffectType(eEfecto) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
            GetEffectType(eEfecto) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
            GetEffectType(eEfecto) == EFFECT_TYPE_SKILL_DECREASE ||
            GetEffectType(eEfecto) == EFFECT_TYPE_BLINDNESS ||
            GetEffectType(eEfecto) == EFFECT_TYPE_DEAF ||
            GetEffectType(eEfecto) == EFFECT_TYPE_PARALYZE ||
            GetEffectType(eEfecto) == EFFECT_TYPE_NEGATIVELEVEL)
                {
                //No hacer nada
                }
        else RemoveEffect(oPC, eEfecto);
        eEfecto = GetNextEffect(oPC);
        }
}

//******************************************************************************
//* GT_ContarObjsCofre
//******************************************************************************
void GT_ContarObjsCofre(string sAreaCofres, string sTagCofre)
{
   object oAreaCofres = GetObjectByTag(sAreaCofres);
   object oBuscarCofre = OBJECT_INVALID;
   object oCofre = OBJECT_INVALID;
   object oObjeto = OBJECT_INVALID;
   int iNumObjetos = 1;
   oBuscarCofre = GetFirstObjectInArea(oAreaCofres);
   while (oBuscarCofre != OBJECT_INVALID)
        {
        if (GetTag(oBuscarCofre) == sTagCofre) oCofre = oBuscarCofre;
        oBuscarCofre = GetNextObjectInArea (oAreaCofres);
        }
   if (oCofre == OBJECT_INVALID) return;
   oObjeto = GetFirstItemInInventory(oCofre);
   while (oObjeto != OBJECT_INVALID)
        {
        oObjeto = GetNextItemInInventory(oCofre);
        iNumObjetos = iNumObjetos + 1;
        }
   SetLocalInt(oCofre, "NumObjetos", iNumObjetos);
   SetLocalInt(GetModule(), sTagCofre, iNumObjetos);
}

//******************************************************************************
//* GT_GenerarTesoro, Generar un tesoro en un objeto ya sea criatura o ubicado.
//******************************************************************************
void GT_GenerarTesoro(int iTiradas, int iProbaGT, int Porcentage, int iApilar, string sAreaTesoro, string sTagCofre)
{

if(SGT_DEBUG) SendMessageToAllDMs("Tiradas - Probabilidad - Porcentage - Apilar - Area - Cofre "
              +IntToString(iTiradas)+" "+IntToString(iProbaGT)+" "+IntToString(Porcentage)+" "+IntToString(iApilar)+" "+sAreaTesoro+" "+sTagCofre);

object oAreaCofres = GetObjectByTag(sAreaTesoro);
object oBuscarCofre = OBJECT_INVALID;
object oCofre = OBJECT_INVALID;
object oBuscarObjeto = OBJECT_INVALID;
object oObjeto = OBJECT_INVALID;
object oObjetoFinal = OBJECT_INVALID;
int iNumObjects;
int iNumSelecc;
int iTiradaActual = 0;
int iObjetoActual = 0;
int iApilarActual = 0;

for (iTiradaActual=0;iTiradaActual<iTiradas;iTiradaActual++)
    {
    if(SGT_DEBUG) SendMessageToAllDMs("Efectuando tirada...");
    if (Random(Porcentage) <= iProbaGT-1)
        {
        if(SGT_DEBUG) SendMessageToAllDMs("Exito!!");
        oBuscarCofre = GetFirstObjectInArea(oAreaCofres);
        while (oBuscarCofre != OBJECT_INVALID)
            {
            if (GetTag(oBuscarCofre) == sTagCofre) oCofre = oBuscarCofre;
            oBuscarCofre = GetNextObjectInArea (oAreaCofres);
            }
        if (oCofre == OBJECT_INVALID) return;
        iNumObjects = GetLocalInt(oCofre, "NumObjetos");
        if(SGT_DEBUG) SendMessageToAllDMs("Numero de objetos del cofre seleccionado: "+IntToString(iNumObjects));
        iNumSelecc = Random(iNumObjects) + 1;
        if(SGT_DEBUG) SendMessageToAllDMs("Elegido objeto numero: "+IntToString(iNumSelecc));
        oObjeto = GetFirstItemInInventory(oCofre);
        for(iObjetoActual=1;iObjetoActual<iNumSelecc;iObjetoActual++) oObjeto = GetNextItemInInventory(oCofre);
        if (GetIsObjectValid(oObjeto)) oObjetoFinal = CopyItem(oObjeto, OBJECT_SELF);
        if (GetNumStackedItems(oObjetoFinal) == 1) SetItemStackSize(oObjetoFinal, Random(iApilar) + 1);
        }
    }
}
