/*COMPRADOR DE CABELLERAS, APARECEN OBJETOS*/
#include "nw_i0_tool"
int StartingConditional()
{
object oPC = GetPCSpeaker();

//Cabelleras
string sEtiqueta1 = "Cabelleradebandido";

//Comprobar si el PJ que habla al menos tiene algunos de estos objetos
if(HasItem(GetPCSpeaker(), sEtiqueta1)) return TRUE;
return FALSE;
}
