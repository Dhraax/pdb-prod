#include "mti_libreria"
#include "nwnx_player"

void QuestDeath (object oKiller, object oNPC)
{
    string sTag = GetTag(oNPC);

    //Si el asesino es un PNJ, el asesino es un maestro.
    if (!GetIsPC(oKiller)) {oKiller = GetMaster(oKiller);}

    //*************//
    //QUEST EJEMPLO//
    //*************//
    //Si la criatura tiene el tag.
    if(sTag == "etiquetadelarata")
    {
        //Pedimos que el PJ tenga la variable por encima de 0 (vamos que tenga minimo 1 punto para que pueda sumar), hasta tener 9, donde meterá la última var que sumara 10.
        if(ObtenerIntPersistente(oKiller, "variabledelaquest") >0 && ObtenerIntPersistente(oKiller, "variabledelaquest") <10)
        {
            //Actualizamos la variable con cada muerte, sumando un +1.
            GuardarIntPersistente(oKiller, "variabledelaquest", ObtenerIntPersistente(oKiller, "variabledelaquest") + 1);
            //Hasta que lleguemos, con cada muerte, indicamos al PJ cuantas ratas ha matado.
            if(ObtenerIntPersistente(oKiller, "variabledelaquest") < 10)
            {SendMessageToPC(oKiller,"<c þ >Rata eliminadas: "+IntToString(ObtenerIntPersistente(oKiller, "variabledelaquest"))+"/10.</c>");}
            //Cuando hemos matado 10 ratas, pues indicamos que no hacen falta más.
            if(ObtenerIntPersistente(oKiller, "variabledelaquest") == 10)
            {SendMessageToPC(oKiller,"<c þ >Ya has matado suficientes ratas, con ésto, debería bastar.</c>"); NWNX_Player_PlaySound(oKiller,"GUI_JOURNALAAD", oKiller);}
            //Si matamos muchos bichos a la vez con un un conjuro en área tenemos cuidadín.
            if(ObtenerIntPersistente(oKiller, "variabledelaquest") > 10){GuardarIntPersistente(oKiller, "variabledelaquest", 10);}
        }
    }
    //******************//
    //QUEST RATAS LLANOS//
    //******************//
    //Si la criatura tiene el tag.
    if(sTag == "qt_ratasviejob")
    {
        //Si tiene la variable en 1 y mata 8 ratas.
        if(ObtenerIntPersistente(oKiller, "qt_ratasviejo") >0 && ObtenerIntPersistente(oKiller, "qt_ratasviejo") <10)
        {
            //Actualizamos la variable con cada muerte, sumando un +1.
            GuardarIntPersistente(oKiller, "qt_ratasviejo", ObtenerIntPersistente(oKiller, "qt_ratasviejo") + 1);
            //Hasta que lleguemos, con cada muerte, indicamos al PJ cuantas ratas ha matado.
            if(ObtenerIntPersistente(oKiller, "qt_ratasviejo") < 10)
            {SendMessageToPC(oKiller,"<c þ >Rata eliminadas: "+IntToString(ObtenerIntPersistente(oKiller, "qt_ratasviejo")-1)+"/8.</c>");}
            //Cuando hemos matado 8 ratas, pues indicamos que no hacen falta más.
            if(ObtenerIntPersistente(oKiller, "qt_ratasviejo") == 9)
            {SendMessageToPC(oKiller,"<c þ >Ya has matado suficientes ratas, con ésto, debería bastar.</c>"); NWNX_Player_PlaySound(oKiller,"GUI_JOURNALAAD", oKiller);}
            if(ObtenerIntPersistente(oKiller, "qt_ratasviejo") > 9){GuardarIntPersistente(oKiller, "qt_ratasviejo", 9);}
        }
    }
}

//void main(){}

