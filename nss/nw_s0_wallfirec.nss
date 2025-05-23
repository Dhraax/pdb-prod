// void main()
// {
//     object oTarget = GetExitingObject();
//     int nMuroFuego = GetLocalInt(oTarget, "AOE_" + IntToString(AOE_PER_WALLFIRE));

//     SetLocalInt(oTarget, "AOE_" + IntToString(AOE_PER_WALLFIRE), nMuroFuego <= 0 ? 0 : nMuroFuego - 1);
// }

void main()
{
    object oTarget = GetExitingObject();
    int nMuroFuego = GetLocalInt(oTarget, "AOE_" + IntToString(AOE_PER_WALLFIRE));

    //("[Wall of Fire] Exit: Target: " + GetName(oTarget) + " | nMuroFuego: " + IntToString(nMuroFuego));

    // Decrementar el contador del muro de fuego
    if (nMuroFuego > 0)
    {
        SetLocalInt(oTarget, "AOE_" + IntToString(AOE_PER_WALLFIRE), nMuroFuego <= 0 ? 0 : nMuroFuego - 1);

        //WriteTimestampedLogEntry("[Wall of Fire] Exit: Decrementando contador de muro de fuego para " + GetName(oTarget) + " | Nuevo nMuroFuego: " + IntToString(nMuroFuego));

        // Si es el último muro de fuego, cancelar el bucle de daño
        if (nMuroFuego == 0)
        {
            DeleteLocalInt(oTarget, "AOE_" + IntToString(AOE_PER_WALLFIRE));
            DeleteLocalInt(oTarget, "MuroFuegoActive"); // Flag to indicate the damage loop should stop
            //WriteTimestampedLogEntry("[Wall of Fire] Exit: Eliminando flags para " + GetName(oTarget));
        }
    }
}