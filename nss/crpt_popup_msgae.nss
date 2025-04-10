//////////////////////////////////
//: t_intro - by Kerry Solberg
//: http://www.realmsofmyth.org
//////////////////////////////////
/*
This script plays a popup message on a PC entering a trigger.
It will only play once per hour and only once ever, per PC.
* Make sure each intro trigger has a unique tag.
* The text for the popup is contained within a variable on the trigger
called "sMsg". Edit the variable to change the message text.
*/
#include "colors_inc"
//set to 1:  player recieves floaty description notification
//set to 0:  notification disabled
const int FLOATY = 1;
void main()
{
    object oPC = GetEnteringObject();
    string sMyTag = GetTag(OBJECT_SELF);
    // Do not fire for DMs.
    if ( GetIsDM(oPC) )
        return;
    // Only fire once per PC.
    if ( !GetLocalInt(oPC, sMyTag) )
    {
        if ( FLOATY == 1 )
        {
            // The text for the floaty notification and its color.
            string sColoredText = ColorToken(0, 255, 255) + "*Descripcion*" + ColorTokenEnd();
            FloatingTextStringOnCreature(sColoredText, oPC, FALSE);
        }
        string sMsg = ColorTokenWhite() + GetLocalString(OBJECT_SELF, "Al aproximarte al umbral de la puerta, sientes como toda la magia de tus objetos magicos se desvanece subitamente, y todo efecto magico o conjuro que portes queda anulado") + ColorTokenEnd();
        //AssignCommand(oPC, PlaySound("gui_open"));
        DelayCommand(0.5, SendMessageToPC(oPC, sMsg));
        SetLocalInt(oPC, sMyTag, TRUE);
    }
}

