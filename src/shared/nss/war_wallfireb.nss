#include "pb_constantes"

void main()
{
    object oTarget = GetExitingObject();
    int nMuroFuego = GetLocalInt(oTarget, "AOE_" + IntToString(AOE_PER_WARLOCK_WALLFIRE));

    SetLocalInt(oTarget, "AOE_" + IntToString(AOE_PER_WARLOCK_WALLFIRE), nMuroFuego <= 0 ? 0 : nMuroFuego - 1);
}
