void AplicarVeneno(object oTarget, int idVeneno);

void main()
{
    object oTarget = GetEnteringObject();
    location lTarget = GetLocation(oTarget);
    int idVeneno = 12;

    object oVenom = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, FALSE, OBJECT_TYPE_WAYPOINT);
    while (GetIsObjectValid(oVenom))
    {
        if (GetStringRight(GetTag(oVenom), 10) == "envenenado")
        {
            idVeneno = StringToInt(GetStringLeft(GetTag(oVenom), 2));
            break;
        }
        oVenom = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, FALSE, OBJECT_TYPE_WAYPOINT);
    }

    SetLocalInt(oTarget, "inhalando_veneno", idVeneno);
    AplicarVeneno(oTarget, idVeneno);
}

void AplicarVeneno(object oTarget, int idVeneno) {
    if (GetLocalInt(oTarget, "inhalando_veneno") > 0) {
        int idVeneno = GetLocalInt(oTarget, "inhalando_veneno");
        effect ePoison = EffectPoison(idVeneno);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget);

        DelayCommand(RoundsToSeconds(1), AplicarVeneno(oTarget, idVeneno));
    }
}
