void main()
{
    object oStatue = GetObjectByTag("pb_estasacerbaal");
    location lStatue = GetLocation (oStatue);
    location lSacerBaal = GetLocation(GetWaypointByTag("WP_sacerdote_baal_01"));
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(1512), lStatue, 2.0); //Portal al ras de suelo
    int iSacer=FALSE;
    object oBicho = GetFirstObjectInArea();
    while (GetIsObjectValid(oBicho))
    {
        if(GetObjectType(oBicho)==OBJECT_TYPE_CREATURE)
        {
            if(GetTag(oBicho)=="sacerdote_baal")
            {
                iSacer=TRUE;
            }
        }
    oBicho = GetNextObjectInArea();
    }


    if (iSacer==FALSE)
    {
         ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), lSacerBaal, 2.0);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(1670), lSacerBaal, 2.0);
        object oSacerBaal = CreateObject(OBJECT_TYPE_CREATURE, "pb_sacerbaal001", lSacerBaal, FALSE, "sacerdote_baal");
        lSacerBaal = GetLocation(oSacerBaal);
        //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(241), lSacerBaal);

        //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(241), oSacerBaal);
        //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(30), oSacerBaal, 99999.9); //Palabra de poder mortal          1670


    }

}
