void main()
{
    object oTarget = GetExitingObject();
    int nMuroFuego = GetLocalInt(oTarget, "AOE_" + IntToString(AOE_PER_WALLFIRE));

    SetLocalInt(oTarget, "AOE_" + IntToString(AOE_PER_WALLFIRE), nMuroFuego - 1);
}
