void main()
{
    object oPC = GetEnteringObject();
    if (GetIsPC(oPC))
    {
        //ExecuteScript ("fvex_area_inside", oPC);
        object oArea = GetArea(oPC);
        location lLocation = GetLocation(GetWaypointByTag("NW_POSTCREATUREFAC"));
        object oObjeto = GetFirstObjectInArea(oArea);
        string sFaction = GetLocalString(oArea, "Faccion");
        object oFakeCriatura;
        if (sFaction=="Vampiro")
        {
            oFakeCriatura =CreateObject(OBJECT_TYPE_CREATURE, "Q1_SKEL_COMM001", lLocation); //Criatura de la faccion vampira GetObjectByTag(sEtiqueta);

        }
        if (GetIsObjectValid(oFakeCriatura))
        {
            while (GetIsObjectValid(oObjeto))
            {

                if (GetObjectType(oObjeto) == OBJECT_TYPE_CREATURE && GetIsEncounterCreature(oObjeto) && GetEncounterActive())
                {
                    ChangeFaction(oObjeto,oFakeCriatura);
                }
                oObjeto = GetNextObjectInArea(oArea);
            }

        }
        DestroyObject(oFakeCriatura, 1.0f);
    }
}
