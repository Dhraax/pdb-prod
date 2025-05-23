//Variante en dote del item lupa
#include "mti_libreria"
void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();

    SetLocalObject(oPC, "dmfi_univ_target", oTarget);
    object oDMFIObjetivo = GetLocalObject(oPC, "dmfi_univ_target");
    SendMessageToPC(oPC,ColorTexto("Seleccionas como objetivo a "+GetName(oDMFIObjetivo)+".",TXT_COLOR_VERDE));

}
