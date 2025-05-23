#include "mti_libreria"
#include "cls_ing_lib"
#include "nwnx_creature"

void main()
{
    object oPC = GetPCSpeaker();
    object oObjetivo = GetLocalObject(oPC, "CLS_ING_DOTE");
    int iModo = StringToInt(GetScriptParam("Modo"));
    int iTipo = StringToInt(GetScriptParam("Tipo"));

    //Elegimos el tipo de artillero.
    if(iModo == 1)
    {
        //Artillero.
        if(iTipo == 1)
        {
            GuardarIntPersistente(oPC,"CLS_ING_TIPO",1);
            SendMessageToPC(oPC,"<c þ >Has elegido el ingeniero tipo Artillero.</c>");
            NWNX_Creature_AddFeat(oPC,1768);
            NWNX_Creature_AddFeat(oPC,1206); //Armadura intermedia.
        }
        //Armero.
        if(iTipo == 2)
        {
            GuardarIntPersistente(oPC,"CLS_ING_TIPO",2);
            SendMessageToPC(oPC,"<c þ >Has elegido el ingeniero tipo Armero.</c>");
            NWNX_Creature_AddFeat(oPC,1769);
            NWNX_Creature_AddFeat(oPC,1206); //Armaduras intermedias.
            NWNX_Creature_AddFeat(oPC,1207); //Armaduras pesadas.
        }
        //Herrero de batalla. //SIN IMPLEMENTAR
        if(iTipo == 3)
        {
            GuardarIntPersistente(oPC,"CLS_ING_TIPO",3);
            SendMessageToPC(oPC,"<c þ >Has elegido el ingeniero tipo Herrero de Batalla.</c>");
            NWNX_Creature_AddFeat(oPC,999999);
        }
        //Alquimista.
        if(iTipo == 4)
        {
            GuardarIntPersistente(oPC,"CLS_ING_TIPO",4);
            SendMessageToPC(oPC,"<c þ >Has elegido el ingeniero tipo Alquimista.</c>");
            NWNX_Creature_AddFeat(oPC,1770);
            NWNX_Creature_AddFeat(oPC,945); //Crear pergaminos.
            NWNX_Creature_AddFeat(oPC,946); //Crear varitas.
        }
        return;
    }
    //Elegimos el tipo de arreglo mágico.
    if(iModo == 2)
    {
        //Solo con objetos.
        if(GetObjectType(oObjetivo) != OBJECT_TYPE_ITEM)
        {
            SendMessageToPC(oPC,"<c´$$>Los arreglos mágicos solo funcionan en objetos.</c>");
            return;
        }
        //Solo podemos meter un arreglo mágico por item.
        if(GetLocalInt(oObjetivo,"CLS_ING_ARREGLOMAGICO") == 1)
        {
            SendMessageToPC(oPC,"<c´$$>Solo puedes añadir un arreglo mágico.</c>");
            return;
        }

        itemproperty iProp;

        //APARTADO DE LUZ.
        //Luz azul.
        if(iTipo == 1)
        {
            iProp = ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL,IP_CONST_LIGHTCOLOR_BLUE);
        }
        //Luz verde.
        if(iTipo == 2)
        {
            iProp = ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL,IP_CONST_LIGHTCOLOR_GREEN);
        }
        //Luz naranja.
        if(iTipo == 3)
        {
            iProp = ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL,IP_CONST_LIGHTCOLOR_ORANGE);
        }
        //Luz morada.
        if(iTipo == 4)
        {
            iProp = ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL,IP_CONST_LIGHTCOLOR_PURPLE);
        }
        //Luz roja.
        if(iTipo == 5)
        {
            iProp = ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL,IP_CONST_LIGHTCOLOR_RED);
        }
        //Luz blanca.
        if(iTipo == 6)
        {
            iProp = ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL,IP_CONST_LIGHTCOLOR_WHITE);
        }
        //Luz amarilla.
        if(iTipo == 7)
        {
            iProp = ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL,IP_CONST_LIGHTCOLOR_YELLOW);
        }
        //Añadimos la propiedad nueva.
        IPSafeAddItemProperty(oObjetivo, iProp);
        SetLocalInt(oObjetivo,"CLS_ING_ARREGLOMAGICO",1);
        return;
    }
    //Elegimos el tipo de infusión.
    if(iModo == 4)
    {
        //Damos la dote en el nivel que estamos (si baja, pues pierde la dote).
        NWNX_Creature_AddFeatByLevel(oPC,iTipo,GetHitDice(oPC));
        return;
    }

}
