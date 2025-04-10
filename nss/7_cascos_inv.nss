#include "nw_i0_tool"

int StartingConditional()
{
object oPC = GetPCSpeaker();

if (GetItemPossessedBy(oPC, "CascoSvirfneblin_amarillo") == OBJECT_INVALID) return FALSE;
if (GetItemPossessedBy(oPC, "CascoSvirfneblin_azul") == OBJECT_INVALID) return FALSE;
if (GetItemPossessedBy(oPC, "CascoSvirfneblin_marron") == OBJECT_INVALID) return FALSE;
if (GetItemPossessedBy(oPC, "CascoSvirfneblin_naranja") == OBJECT_INVALID) return FALSE;
if (GetItemPossessedBy(oPC, "CascoSvirfneblin_rojo") == OBJECT_INVALID) return FALSE;
if (GetItemPossessedBy(oPC, "CascoSvirfneblin_verde") == OBJECT_INVALID) return FALSE;
if (GetItemPossessedBy(oPC, "CascoSvirfneblin_violenta") == OBJECT_INVALID) return FALSE;
return TRUE;
}
