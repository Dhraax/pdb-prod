#include "inc_sum_golem"

void main()
{
    object oMaster = GetMaster();
    DeleteActiveAndPermanentHPGolemVariablesOnPlayer(oMaster);
    SetGolemDeathOnPlayer(OBJECT_SELF,oMaster);

    if (GetTag(OBJECT_SELF) == GOLEM_TAG_HOMUNCULUS)  ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(d10(2)),oMaster);
}
