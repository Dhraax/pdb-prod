#include "mti_libreria"
#include "nw_i0_tool"

int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "QUEST_CAMINOCOSTA_DRIANNA");
int nComprobarFracaso = GetLocalInt(oPC, "FALLO_BUSQUEDA_GATO");

if(
  (HasItem(oPC, "ko_missy"))&&
  (!HasItem(oPC, "ko_missy_hijo"))&&
  (nComprobarVar == 1)&&
  (nComprobarFracaso != 1)
  )
return TRUE;
return FALSE;
}

