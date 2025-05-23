//::///////////////////////////////////////////////
//:: Placeable OnUsed
//:: q_mill_lever_act
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This OnUsed event is designed to be used with a placeable lever
    and the new Project Q Millstone placeables (QP_MILLWHEEL_001 and
    QP_MILLWHEEL_002).

    1. Place the millstone placeable in the area.

    2. Place a lever and assign it the following variables

       - X2_L_PLC_ACTIVATED_STATE / int / 0

       - Q_ACT_TARGET / string / QP_MILLWHEEL_001 <or> QP_MILLWHEEL_002

    3. Open the lever's properties and set its initial state to "deactivated"

    4. Assign this script to the placeable lever's OnUsed event

    5. Place the "Mill Wheel" sound object near the millwheel, open its
       properties and uncheck the "active" button

    When the PC uses the lever, the mill wheel will begin to turn and the
    sound will play. When the lever is used again, the wheel and sound will
    stop

    Based upon an original BioWare script by Georg Zoeller

*/
//:://////////////////////////////////////////////
//:: Created By: Pstemarie
//:: Created On: September 23, 2013
//:://////////////////////////////////////////////
void main()
{
    string sTarget    = GetLocalString(OBJECT_SELF, "Q_ACT_TARGET");
    object oPlaceable = GetNearestObjectByTag(sTarget);
    object oSound     = GetNearestObjectByTag("MillWheel");
    int    nActive    = GetLocalInt (OBJECT_SELF,"X2_L_PLC_ACTIVATED_STATE");

    // * Play Appropriate Animation
    if (!nActive)
    {
        ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
        AssignCommand(oPlaceable, ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
        SoundObjectPlay(oSound);
    }
    else
    {
        ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
        AssignCommand(oPlaceable, ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
        SoundObjectStop(oSound);
    }
    // * Store New State
    SetLocalInt(OBJECT_SELF,"X2_L_PLC_ACTIVATED_STATE",!nActive);
}
