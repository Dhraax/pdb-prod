void main()
{
    string sTag = GetTag(OBJECT_SELF);

    // SUNDIAL
    if (sTag == "lordo_sundial")
    {
        if (GetIsNight())
            AssignCommand(GetLastUsedBy(), ActionSpeakString("¡Es un reloj de sol, no funciona por la noche!"));
        else
            AssignCommand(GetLastUsedBy(), ActionSpeakString("El sol muestra que son las " + IntToString(GetTimeHour()) + " horas"  ));
        return;
    }
}
