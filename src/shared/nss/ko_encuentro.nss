void main()
{

int iActivacion = GetLocalInt (OBJECT_SELF, "ACTIVADO");//Variable en el desencadenante
string sResref1 = GetLocalString (OBJECT_SELF, "RESREF1");
string sResref2 = GetLocalString (OBJECT_SELF, "RESREF2");
string sResref3 = GetLocalString (OBJECT_SELF, "RESREF3");
string sResref4 = GetLocalString (OBJECT_SELF, "RESREF4");
string sTipo = GetLocalString (OBJECT_SELF, "TIPO");     //terminan las variables en el desencadenante

string sEtiqueta1 = sResref1 + sTipo +"_1";
string sEtiqueta2 = sResref1 + sTipo +"_2";
string sEtiqueta3 = sResref1 + sTipo +"_3";
string sEtiqueta4 = sResref1 + sTipo +"_4";
string sEtiqueta5 = sResref2 + sTipo +"_5";
string sEtiqueta6 = sResref2 + sTipo +"_6";
string sEtiqueta7 = sResref2 + sTipo +"_7";
string sEtiqueta8 = sResref2 + sTipo +"_8";
string sEtiqueta9 = sResref3 + sTipo +"_9";
string sEtiqueta10 = sResref3 + sTipo +"_10";
string sEtiqueta11 = sResref3 + sTipo +"_11";
string sEtiqueta12 = sResref3 + sTipo +"_12";
string sEtiqueta13 = sResref4 + sTipo +"_13";
string sEtiqueta14 = sResref4 + sTipo +"_14";
string sEtiqueta15 = sResref4 + sTipo +"_15";
string sEtiqueta16 = sResref4 + sTipo +"_16";

object oPC = GetEnteringObject();
location lLugar1 = GetLocation(GetNearestObjectByTag("WP_"+sEtiqueta1+"_01", oPC));//Ejemplo de punto de ruta: WP_ko_filo_soldado_Ext_1_01
location lLugar2 = GetLocation(GetNearestObjectByTag("WP_"+sEtiqueta2+"_01", oPC));                            //ko_filo_soldado -> Es la resref de la criatura
location lLugar3 = GetLocation(GetNearestObjectByTag("WP_"+sEtiqueta3+"_01", oPC));                            //_Ext es la variable TIPO (para diferenciar los guardias interiores, de exteriores, o donde sea.
location lLugar4 = GetLocation(GetNearestObjectByTag("WP_"+sEtiqueta4+"_01", oPC));
location lLugar5 = GetLocation(GetNearestObjectByTag("WP_"+sEtiqueta5+"_01", oPC));
location lLugar6 = GetLocation(GetNearestObjectByTag("WP_"+sEtiqueta6+"_01", oPC));
location lLugar7 = GetLocation(GetNearestObjectByTag("WP_"+sEtiqueta7+"_01", oPC));
location lLugar8 = GetLocation(GetNearestObjectByTag("WP_"+sEtiqueta8+"_01", oPC));
location lLugar9 = GetLocation(GetNearestObjectByTag("WP_"+sEtiqueta9+"_01", oPC));
location lLugar10 = GetLocation(GetNearestObjectByTag("WP_"+sEtiqueta10+"_01", oPC));
location lLugar11 = GetLocation(GetNearestObjectByTag("WP_"+sEtiqueta11+"_01", oPC));
location lLugar12 = GetLocation(GetNearestObjectByTag("WP_"+sEtiqueta12+"_01", oPC));
location lLugar13 = GetLocation(GetNearestObjectByTag("WP_"+sEtiqueta13+"_01", oPC));
location lLugar14 = GetLocation(GetNearestObjectByTag("WP_"+sEtiqueta14+"_01", oPC));
location lLugar15 = GetLocation(GetNearestObjectByTag("WP_"+sEtiqueta15+"_01", oPC));
location lLugar16 = GetLocation(GetNearestObjectByTag("WP_"+sEtiqueta16+"_01", oPC));

if (iActivacion == 0)
    {
    SetLocalInt(OBJECT_SELF, "ACTIVADO", 1);
    object oPnj1 = CreateObject(OBJECT_TYPE_CREATURE, sResref1, lLugar1, FALSE, sEtiqueta1);
    object oPnj2 = CreateObject(OBJECT_TYPE_CREATURE, sResref1, lLugar2, FALSE, sEtiqueta2);
    object oPnj3 = CreateObject(OBJECT_TYPE_CREATURE, sResref1, lLugar3, FALSE, sEtiqueta3);
    object oPnj4 = CreateObject(OBJECT_TYPE_CREATURE, sResref1, lLugar4, FALSE, sEtiqueta4);
    object oPnj5 = CreateObject(OBJECT_TYPE_CREATURE, sResref2, lLugar5, FALSE, sEtiqueta5);
    object oPnj6 = CreateObject(OBJECT_TYPE_CREATURE, sResref2, lLugar6, FALSE, sEtiqueta6);
    object oPnj7 = CreateObject(OBJECT_TYPE_CREATURE, sResref2, lLugar7, FALSE, sEtiqueta7);
    object oPnj8 = CreateObject(OBJECT_TYPE_CREATURE, sResref2, lLugar8, FALSE, sEtiqueta8);
    object oPnj9 = CreateObject(OBJECT_TYPE_CREATURE, sResref3, lLugar9, FALSE, sEtiqueta9);
    object oPnj10 = CreateObject(OBJECT_TYPE_CREATURE, sResref3, lLugar10, FALSE, sEtiqueta10);
    object oPnj11 = CreateObject(OBJECT_TYPE_CREATURE, sResref3, lLugar11, FALSE, sEtiqueta11);
    object oPnj12 = CreateObject(OBJECT_TYPE_CREATURE, sResref3, lLugar12, FALSE, sEtiqueta12);
    object oPnj13 = CreateObject(OBJECT_TYPE_CREATURE, sResref4, lLugar13, FALSE, sEtiqueta13);
    object oPnj14 = CreateObject(OBJECT_TYPE_CREATURE, sResref4, lLugar14, FALSE, sEtiqueta14);
    object oPnj15 = CreateObject(OBJECT_TYPE_CREATURE, sResref4, lLugar15, FALSE, sEtiqueta15);
    object oPnj16 = CreateObject(OBJECT_TYPE_CREATURE, sResref4, lLugar16, FALSE, sEtiqueta16);

    ExecuteScript ("ko_tuneo_aleat", oPnj1);
    ExecuteScript ("ko_tuneo_aleat", oPnj2);
    ExecuteScript ("ko_tuneo_aleat", oPnj3);
    ExecuteScript ("ko_tuneo_aleat", oPnj4);
    ExecuteScript ("ko_tuneo_aleat", oPnj5);
    ExecuteScript ("ko_tuneo_aleat", oPnj6);
    ExecuteScript ("ko_tuneo_aleat", oPnj7);
    ExecuteScript ("ko_tuneo_aleat", oPnj8);
    ExecuteScript ("ko_tuneo_aleat", oPnj9);
    ExecuteScript ("ko_tuneo_aleat", oPnj10);
    ExecuteScript ("ko_tuneo_aleat", oPnj11);
    ExecuteScript ("ko_tuneo_aleat", oPnj12);
    ExecuteScript ("ko_tuneo_aleat", oPnj13);
    ExecuteScript ("Ko_tuneo_aleat", oPnj14);
    ExecuteScript ("Ko_tuneo_aleat", oPnj15);
    ExecuteScript ("Ko_tuneo_aleat", oPnj16);
    }

}
