void main()
{
    object oPC = GetEnteringObject();
    string sText;
    int iRandom = d4(1);

    if(GetIsPC(oPC))
    {
        object oCespe = GetNearestObjectByTag("pnj_bpCespenar");
        SetLocalInt(oCespe, "ConvKey", iRandom);
        switch (iRandom)
        {
            case 1:  sText = "¡Oh, Brillantes!";
                     break;
            case 2:  sText = "¡Cespenar es un buen siervo, sí!";
                     break;
            case 3:  sText = "Um-de-dum, um-de-dum-de-dum...";
                     break;
            case 4:  sText = "¡Oh, Brillantes!";
                     break;

            default: sText= "¡Oh, Brillantes!"; break;

        }
        //SpeakOneLinerConversation(sText) ;
        //ActionSpeakString (, TALKVOLUME_TALK);
        //AssignCommand(oCespe, ActionSpeakString (sText, TALKVOLUME_TALK));
        FloatingTextStringOnCreature(sText, oCespe, FALSE);
        if ( GetLocalInt(oCespe, "ConvReset") == 0 )
        {
            SetLocalInt(oCespe, "ConvReset", 1);
            DelayCommand(500.0, SetLocalInt(OBJECT_SELF, "ConvReset", 0));
            DelayCommand(500.0, SetLocalInt(OBJECT_SELF, "ConvKey", 0));
        }

    }



}
