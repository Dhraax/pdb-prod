#include "hench_i0_assoc"


void main()
{
    object oRealMaster = GetRealMaster();
    object oClosest =  GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
                        oRealMaster, 1);
    if (GetIsObjectValid(oClosest) && GetDistanceBetween(oClosest, oRealMaster) <= henchMaxScoutDistance)
    {
        SetLocalInt(OBJECT_SELF, sHenchScoutingFlag, TRUE);
        SetLocalObject(OBJECT_SELF, sHenchScoutTarget, oClosest);
        ClearAllActions();
        if (CheckStealth())
        {
            SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE);
        }
        ActionMoveToObject(oClosest, FALSE, 1.0);
        ActionMoveToObject(oClosest, FALSE, 1.0);
        ActionMoveToObject(oClosest, FALSE, 1.0);
    }
    else
    {
        DeleteLocalInt(OBJECT_SELF,sHenchScoutingFlag);
    }
}
