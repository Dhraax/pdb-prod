void main()
{
    object oPC = GetPCSpeaker();
    object oAdalon = OBJECT_SELF;
    string message = "";
    int bEnemy = FALSE;

    switch(GetAlignmentGoodEvil(oPC))
    {
        case ALIGNMENT_GOOD:
            message = GetLocalString(oAdalon, "talk_good");
            break;
        case ALIGNMENT_NEUTRAL:
            message = GetLocalString(oAdalon, "talk_neutral");
            bEnemy = TRUE;
            break;
        case ALIGNMENT_EVIL:
            message = GetLocalString(oAdalon, "talk_evil");
            bEnemy = TRUE;
            break;
        default:
            message = GetLocalString(oAdalon, "talk_evil");
            bEnemy = TRUE;
            break;
    }


    AssignCommand(oAdalon, ClearAllActions());
    AssignCommand(oAdalon, ActionSpeakString(message));
    if(bEnemy)
        {
            DelayCommand(1.0, SetIsTemporaryEnemy(oPC, oAdalon));
            DelayCommand(1.0, SetIsTemporaryEnemy(oAdalon, oPC ));
        }
}
