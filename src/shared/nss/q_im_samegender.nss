//::///////////////////////////////////////////////
//:: Name: Q General Conversation
//:: FileName: q_im_samegender
//:: Website: http://q.neverwintervault.org
//:://////////////////////////////////////////////
/*
    Project Q - Release 2.2

    Return TRUE if
        -   PC Speaker is same gender as conversation owner (OBJECT_SELF)
*/
//:://////////////////////////////////////////////
//:: Created By: meaglyn
//:: Created On: 10 Sep 2016
//:://////////////////////////////////////////////

int StartingConditional()
{
    if(GetGender(GetPCSpeaker()) == GetGender(OBJECT_SELF))
        return TRUE;

    return FALSE;
}
