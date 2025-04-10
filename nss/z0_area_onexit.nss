void SEGC_DestruirPNJs()
    {
    object oArea = OBJECT_SELF;
    int iPCsEnArea = 0;
    object oPCArea = GetFirstObjectInArea(oArea);

    while(GetIsObjectValid(oPCArea))
    {
        if(GetIsPC(oPCArea) || GetIsDM(oPCArea)) iPCsEnArea = 1;
        oPCArea = GetNextObjectInArea(oArea);
    }

    if(iPCsEnArea == 0)
    {
        oPCArea = GetFirstObjectInArea(oArea);
        while(GetIsObjectValid(oPCArea))
        {
            if(GetObjectType(oPCArea) == OBJECT_TYPE_CREATURE)
            {
                //Criaturas generadas por encuentro hostiles
                if(GetIsEncounterCreature(oPCArea) || GetLocalInt(oPCArea, "ENC_CLASS")) DestroyObject(oPCArea);
                //Criaturas generadas estaticamente
                if(GetLocalInt(oPCArea, "SEGC_CriaturaSistema") == 1) DestroyObject(oPCArea);
            }

            oPCArea = GetNextObjectInArea(oArea);
        }

        SetLocalInt(oArea,"SEGC_HECHO",0);
    }

    SetLocalInt(oArea,"SEGC_DESTRUC_LANZADA", 0);
}

void main()
{
    object oPlayer = OBJECT_SELF;
    object oArea = GetArea(oPlayer);

    //******************************************************************************
    // Sistemas que se activan cuando no hay nadie en el area
    //******************************************************************************
    //sistema estatico de generacion de criaturas, los pnjs se destruyen al no haber jugadores en el area
    //Anulado hasta nuevo aviso.
    int iPCsEnArea = 0;
    int nSEGC_DestrEnCurso = GetLocalInt(oArea,"SEGC_DESTRUC_LANZADA");
    int nSAM_DestrEnCurso = GetLocalInt(oArea,"SAM_DESTRUC_LANZADA");
    int nSAM_HoraCeroActiv = GetLocalInt (oArea, "SAM_HORACEROACTIV");
    object oItem;
    object oPCArea = GetFirstObjectInArea(oArea);

    while(GetIsObjectValid(oPCArea))
    {
        if(GetIsPC(oPCArea) || GetIsDM(oPCArea)) iPCsEnArea = 1;
        oPCArea = GetNextObjectInArea(oArea);
    }

    if(iPCsEnArea == 0 && nSEGC_DestrEnCurso == 0)
    {
        DelayCommand(600.0, SEGC_DestruirPNJs()); //A los 600 segundos si no hay jugadores destruye los pnjs del SEGC
        SetLocalInt(oArea,"SEGC_DESTRUC_LANZADA", 1);
    }

    //Parche de Varacho.
    if(GetLocalInt(oPlayer,"ARENA") > 0)
    {
        DeleteLocalInt(oPlayer, "ARENA");
        WriteTimestampedLogEntry("MODO ARENA: Un PJ salió de un área arena sin tener borrada la variable, comprobar los OnEnter y OnExit del área: "+GetName(oArea)+".");
    }
}
