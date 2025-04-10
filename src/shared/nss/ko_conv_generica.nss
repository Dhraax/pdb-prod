void main()
{

string sContador = GetLocalString(OBJECT_SELF, "contador");
string sEtiquetaPnj1 = GetLocalString(OBJECT_SELF, "etiqueta_pnj_1");
string sEtiquetaPnj2 = GetLocalString(OBJECT_SELF, "etiqueta_pnj_2");
string sDialogo1 = GetLocalString(OBJECT_SELF, "dialogo_1");
string sDialogo2 = GetLocalString(OBJECT_SELF, "dialogo_2");
object oPC = GetEnteringObject();
object oPnj1 = GetNearestObjectByTag(sEtiquetaPnj1, oPC);
object oPnj2 = GetNearestObjectByTag(sEtiquetaPnj2, oPC);
string sNombrePersonaje = GetName(oPC);

if(GetIsPC(oPC)&& GetLocalInt(oPC, sContador) == 0){

    SetLocalInt(oPC, sContador, 1);
    DelayCommand(300.0f, DeleteLocalInt(oPC, sContador));
    AssignCommand(oPnj1, SpeakString(sDialogo1));
    AssignCommand(oPnj2, SpeakString(sDialogo2));
    }
    }
