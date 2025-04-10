#include "nw_i0_tool"
void main()
{
object oPC = GetPCSpeaker();
object oCabeza = GetItemPossessedBy(oPC, "CabezadelJefeJabal");

// Dar un poco de oro al que habla
GiveGoldToCreature(oPC, 2500);

// Dar algunos PX al que habla
SetXP(oPC, GetXP(oPC) + 2000);

// Eliminar la cabeza de jabali
if(GetIsObjectValid(oCabeza) == TRUE) DestroyObject(oCabeza);

// Fijamos la variable a 2 para que nos salga otro texto
SetCampaignInt("QUESTJABALIES", "YAMELOCONTO", 2, oPC);

// Le damos tambien unas sidras
CreateItemOnObject("sidrademanzana", oPC);
CreateItemOnObject("sidradepera", oPC);
}
