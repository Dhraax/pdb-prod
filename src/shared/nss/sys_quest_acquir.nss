#include "mti_libreria"
#include "nwnx_player"


void QuestAcquire (object oPC, object oItem)
{
    string sItem = GetTag(oItem);

    //*************//
    //QUEST EJEMPLO//
    //*************//
    //Si la etiqueta del item obtenido coincide.
    if(sItem == "etiquetaitem")
    {
        //Miramos si la variable de la quest está en el valor que necesita.
        if(ObtenerIntPersistente(oPC, "variabledelaquest") == 5)
        {
            //Aumentamos la variable en 1.
            GuardarIntPersistente(oPC, "variabledelaquest", ObtenerIntPersistente(oPC, "variabledelaquest") + 1);
            //Confirmamos que se ha cumplido este requisito para la quest.
            if(ObtenerIntPersistente(oPC, "variabledelaquest") == 6)
            {SendMessageToPC(oPC,"<c þ >Has conseguido encontrar el objeto deseado, deberías ir a informar.</c>"); NWNX_Player_PlaySound(oPC,"GUI_JOURNALAAD", oPC);}
        }
    }
    if(sItem == "qt_tabacoi3")
    {
        //Miramos si la variable de la quest está en el valor que necesita.
        if(ObtenerIntPersistente(oPC, "qt_tabaco") == 4)
        {
            DestroyObject(oItem);
            SendMessageToPC(oPC,ColorTexto("Ya has liberado a los rehenes, tener la llave no sirve de nada, la vuelves a dejar en el cadáver.",TXT_COLOR_ROJO));
        }
    }
}

//void main(){}

